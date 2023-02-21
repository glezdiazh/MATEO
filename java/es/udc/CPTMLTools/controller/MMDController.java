package es.udc.CPTMLTools.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import es.udc.CPTMLTools.model.MMDParams;
import es.udc.CPTMLTools.util.Utils;


@Controller
public class MMDController {
	
	private static String FILE_NAME = "";
	
	 @RequestMapping(value = "/calculateDescriptors")
	 public String calculateDescriptors(@ModelAttribute("parameters") MMDParams parameters,
			 @RequestParam("fileToUpload") MultipartFile file, Model model, HttpServletRequest request) throws IOException {
		 
		 String url = "";
		 
		 if (parameters.getContent().equals("") && file.getSize() == 0)
		 {
			 model.addAttribute("error", "No smiles to process. Please insert smiles to proccess selecting option 1 or option 2");	
			 url = "/mmd/mmd";
		 }
		 else
		 {
		
		 	String raiz = System.getProperty("user.dir").replace("\\","/");		 
		 	String UPLOADED_FOLDER = raiz +"/R/MDCalc/uploadedFolder/";	 	
		 	String RESULT_FOLDER = raiz +"/R/MDCalc/resultFolder/";
	
		 	boolean error = false;
		 	
		
		 	try{
			
				Utils utils = new Utils();					
				
				if (file.getSize() != 0)
				{
					FILE_NAME = file.getOriginalFilename();
					
					byte[] bytes = file.getBytes();
				    Path path = Paths.get(UPLOADED_FOLDER + FILE_NAME);
		            Files.write(path, bytes);	
				}
				else				
				{
					FILE_NAME = utils.randomNameFile()+".csv";
					
					PrintWriter writer = new PrintWriter(UPLOADED_FOLDER+FILE_NAME, "UTF-8");
					String smiles = utils.formateaCadenas(parameters.getContent().trim());
					
				    if (!smiles.equals("error"))
					{					
						writer.println(smiles);
						writer.close();
					}
					else
					{
						error = true;
					}				
				}
				
				String FILE_NAME_RESULT = FILE_NAME.substring(0, file.getOriginalFilename().length()-4)+".csv";
				
				if(error)
				{
					model.addAttribute("parameters", parameters);	
					model.addAttribute("error", "Error format. The correct format is NameMolecule,SMILEMolecule. See the example to verify that the format strings is correct. ");	
					url = "/mmd/mmd";
				}
				else
				{
					String atomProperties = utils.atomProperties(parameters);
					String atomTypes = utils.atomTypes(parameters);
					
					if (parameters.isMeans())
					{	
						String RscriptMeans ="Rscript "+raiz+"/R/MDCalc/means.R "+ " " 
								+raiz	+" "
								+UPLOADED_FOLDER+FILE_NAME +" "
								+RESULT_FOLDER+"ERROR_MEANS_"+FILE_NAME_RESULT+" "
								+RESULT_FOLDER+"MEANS_"+FILE_NAME_RESULT+atomProperties+" "
								+atomTypes;
						
						Runtime.getRuntime().exec(RscriptMeans);					
						System.out.println(RscriptMeans);
						
						model.addAttribute("meansResulFile", "MEANS_"+FILE_NAME_RESULT);				
						model.addAttribute("errorMeansResultFile", "ERROR_MEANS_"+FILE_NAME_RESULT);					
					}
						
					if (parameters.isSingular())
					{
						String RscriptSingular = "Rscript "+raiz+"/R/MDCalc/singular.R "
								+ " " +raiz+" "
								+UPLOADED_FOLDER+FILE_NAME+" " 
								+RESULT_FOLDER+"ERROR_SINGULAR_"+FILE_NAME_RESULT+" "
								+RESULT_FOLDER+"SINGULAR_"+FILE_NAME_RESULT+atomProperties+" "
								+atomTypes;
						
						Runtime.getRuntime().exec(RscriptSingular);			
						System.out.println(RscriptSingular);	
						
						model.addAttribute("singularResulFile", "SINGULAR_"+FILE_NAME_RESULT);
						model.addAttribute("errorSingularResultFile", "ERROR_SINGULAR_"+FILE_NAME_RESULT);					
					}
					
					model.addAttribute("server", "MMD");
					
					url = "/mmd/results";
				}
			
			} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			  } 
			
			  
			}
		return url;
	 }
	 
}
