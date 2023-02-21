package es.udc.CPTMLTools.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.udc.CPTMLTools.model.EEParams;
import es.udc.CPTMLTools.model.ImageResults;
import es.udc.CPTMLTools.model.MMDParams;


@Controller
public class DefaultController {

    @GetMapping("/")
    public String home1() {
        return "/home";
    }

    @GetMapping("/mateo")
    public String mateo(Model model) {
    	model.addAttribute("parametersEE", new EEParams());
    	
    	return "/mateo/mateo";
    }

    @GetMapping("/mmd")
    public String mmd(Model model) {
    	model.addAttribute("parameters", new MMDParams());
        return "/mmd/mmd";
    }

    @GetMapping("/login")
    public String login() {
        return "/login";
    }

    @GetMapping("/403")
    public String error403() {
        return "/error/403";
    }
    
  	 
	 @SuppressWarnings("resource")
	@RequestMapping(value = "/viewResult/{server}/{fileName}", method = RequestMethod.GET)
	 public String viewResultImages(@PathVariable("fileName") String fileName, @PathVariable("server") String server, Model model, HttpServletRequest request) {		 
		 
			String raiz = System.getProperty("user.dir").replace("\\","/");	
			String  RESULT_FOLDER = "";
			 
		 	if (server.equals("MMD"))
		 	{
		 		RESULT_FOLDER = raiz +"/R/MDCalc/resultFolder/";			 
			}
		 	
		 	if (server.equals("EE"))
		 	{
		 		RESULT_FOLDER = raiz +"/R/EECalc/resultFolder/";			 
			}
		 	
		 
		 	String csvFile = RESULT_FOLDER +fileName; 	
		 
	        BufferedReader br = null;
	        String line = "";
	       
           List<ImageResults> paula = new ArrayList<ImageResults>();
           List<String> cabecera = new ArrayList<String>();
        
	        try {
	        	
	          	br = new BufferedReader(new FileReader(csvFile));
	    	          
	            int index = 0;
	            
	            while ((line = br.readLine()) != null) {
	            	
	            	ImageResults reaccion = new ImageResults();

	            	index = index +1;            	
	        		String linea = line.replace("\"","");
	        		
	        		if (index == 1)
	        		{
	        			cabecera = Arrays.asList(linea.split("\t"));
	        		}
	        		else
	        		{
		        		reaccion.setReaction(Arrays.asList(linea.split("\t")));
	        			String[] reaction = line.split("\t");		                    
		                if (reaction.length > 11)
		                {
		                	if (csvFile.contains("_nuc_"))
		                	{
		                		reaccion.setStructure("/img/reactions/nuc/"+reaction[1]+".jpg");
		                	}
		                	else
		                	{
		                		if (csvFile.contains("_cat_"))
			                	{
		                			reaccion.setStructure("/img/reactions/cat/"+reaction[1]+".jpg");
			                	}
		                		else
		                		{
		                			if (csvFile.contains("_subs_"))
				                	{
		                				reaccion.setStructure("/img/reactions/subs/"+reaction[1]+".jpg");
				                	}
		                			else
		                			{
		                				reaccion.setStructure("/img/blanco.jpg");
		                			}
		                		}
		                	}   
		                	
	                		reaccion.setRefSubs(reaction[8]);
					        reaccion.setRefNuc(reaction[12]);
					        reaccion.setRefCat(reaction[10]);		                	
		                	
		                }
		                else
		                {
		                	BufferedReader brImg = null;
		          	       	
		                	String ImgFile = RESULT_FOLDER +fileName.substring(0,fileName.length() - 4)+"Img.txt"; 
		                	brImg = new BufferedReader(new FileReader(ImgFile));
		                	brImg.lines();
		                	
		                	   while ((line = brImg.readLine()) != null) {
		                		   String lineaImg = line.replace("\"","");
		                		   String[] imagen = lineaImg.split("\t");
		                		   
		                		   if (index == 2)
		                		   {
		                		   
		                		   reaccion.setRefSubs(imagen[0]);
							       reaccion.setRefNuc(imagen[1]);
							       reaccion.setRefCat(imagen[2]);
		                		   }
		                	 }
		                	   
		                	   brImg.close();
		                }
		                
		                paula.add(reaccion);
	        		}
	            }
	            
	            br.close();

	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            if (br != null) {
	                try {
	                    br.close();
	                } catch (IOException e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	        
	         
	        	        
	        model.addAttribute("fileName", csvFile.replace("/", "\\"));
	        model.addAttribute("paula", paula);
	        model.addAttribute("cabecera", cabecera);
			    
		    return "viewResultImages";
	  }
 
	 @RequestMapping(value = "/downloadResultFile/{server}/{url}", method = RequestMethod.GET)
		public void downloadFile(HttpServletResponse response, @PathVariable("server") String server, 
			@PathVariable("url") String url, HttpServletRequest request) throws IOException {
			
		 	String raiz = System.getProperty("user.dir").replace("\\","/");
			String  RESULT_FOLDER = "";
		
		 	if (server.equals("MMD"))
		 	{
		 		RESULT_FOLDER = raiz +"/R/MDCalc/resultFolder/";	
			}
		 	
		 	if (server.equals("EE"))
		 	{
		 		RESULT_FOLDER = raiz +"/R/EECalc/resultFolder/";	
			 }
		 	
			File file = new File(RESULT_FOLDER+url);
			
			if(!file.exists()){
				String errorMessage = "Sorry, file not found..."+ RESULT_FOLDER+".txt";
				System.out.println(errorMessage);
				OutputStream outputStream = response.getOutputStream();
				outputStream.write(errorMessage.getBytes(Charset.forName("UTF-8")));
				outputStream.close();
				return;
			}
			
			String mimeType= URLConnection.guessContentTypeFromName(file.getName());
			
			if(mimeType==null){
				System.out.println("mimetype is not detectable, will take default");
				mimeType = "application/octet-stream";
			}
			
		    response.setContentType(mimeType);
	        
	        response.setHeader("Content-Disposition", String.format("attachment; filename=\"" + file.getName() +"\""));
	          
	        response.setContentLength((int)file.length());

			InputStream inputStream = new BufferedInputStream(new FileInputStream(file));

	        FileCopyUtils.copy(inputStream, response.getOutputStream());
		}
	 
	 @RequestMapping(value = "/viewResultFile/{server}/{url}", method = RequestMethod.GET)
	 public String viewResultFile(@PathVariable("url") String url, @PathVariable("server") String server, Model model, HttpServletRequest request) {		 
		 
		    model.addAttribute("fileName", "../../files/"+server+"/resultFolder/"+url+".csv");	
			model.addAttribute("title", "Results "+url+".csv");

		 
		return "viewResultFile";
	  }
	 
	 
	   
}
