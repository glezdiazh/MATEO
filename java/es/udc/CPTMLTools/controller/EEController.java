
package es.udc.CPTMLTools.controller;


import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import es.udc.CPTMLTools.model.EEParams;
import es.udc.CPTMLTools.util.Utils;


@Controller
public class EEController {
		
	private static String FILE_NAME = "";
	private static String FILE_NAME_RESULT = "";
	 
	 @RequestMapping(value = "calculateEE")
	 public String calculateEE(@ModelAttribute("parametersEE") EEParams parametersEE,
			 @RequestParam("fileToUpload") MultipartFile file, Model model, HttpServletRequest request) {
		 
		 String raiz = System.getProperty("user.dir").replace("\\","/");
		 
		 if ((file.getOriginalFilename().equals("")) && 
				 (parametersEE.getContentCat().trim().equals("") || parametersEE.getContentNuc().trim().equals("") || 
				 parametersEE.getContentProd().trim().equals("") || parametersEE.getContentSolv().trim().equals("") ||
				 parametersEE.getContentSubs().trim().equals("")))
		 { 
			 model.addAttribute("error", "No smiles to process. Please insert smiles to proccess selecting option 1 or option 2");
			 model.addAttribute("parametersEE", parametersEE);
			 
			 return "/mateo/mateo";
		 }
		 
			 if (parametersEE.isCheckStructural() && !parametersEE.isScanSol() && !parametersEE.isScanSub() && !parametersEE.isScanCat() && !parametersEE.isScanNuc())
			 {
				 model.addAttribute("error", "If Structural Sacnning option is selected, you must ckeck struture to scan");
				 model.addAttribute("parametersEE", parametersEE);
				 
				 return "/mateo/mateo";
			 }		
			 
			 if (!parametersEE.isCheckStructural() && !parametersEE.isCheckSimilarity() && !parametersEE.isCheckConditions())
			 {
				 model.addAttribute("error", "In step 2, you must ckeck one option");
				 model.addAttribute("parametersEE", parametersEE);
				 
				 return "/mateo/mateo";
			 }		
			 
			 
				 	String UPLOADED_FOLDER = raiz +"/R/EECalc/uploadedFolder/";	 	
				 	String RESULT_FOLDER = raiz +"/R/EECalc/resultFolder/";
				 	
				 	String fileName = "";
				 	String RScript = "";
				 	int nLinea = 0; 
				 	long timeProgres = 0;
				 			 	
				 	Utils utils = new Utils();
								
					try{			
							
						if (file.getSize() != 0)
						{
							FILE_NAME = file.getOriginalFilename().replace(" ","");
						
							
							byte[] bytes = file.getBytes();					
						    Path path = Paths.get(UPLOADED_FOLDER + FILE_NAME);
						    
						    Files.write(path, bytes);		            
						    BufferedReader reader = new BufferedReader(new FileReader(UPLOADED_FOLDER + FILE_NAME));
						    
						    Scanner myReader = new Scanner(new FileReader(UPLOADED_FOLDER + FILE_NAME));
						    
						    while (myReader.hasNextLine()) {
								nLinea = nLinea + 1;
								String data = myReader.nextLine();
									
								 if (StringUtils.countOccurrencesOf(data, ";") != 10)
								 {
									 model.addAttribute("error", "Incorrect SMILE format at line "+nLinea);	
									 return "/mateo/mateo";
								 }						 
								
							}	
							
							reader.close();	
							
						}
						else
						{
							FILE_NAME = utils.randomNameFile() + ".txt";
							
							PrintWriter writer = new PrintWriter(UPLOADED_FOLDER + FILE_NAME, "UTF-8");	
							
							writer.println("Reaction;Subs;SubsSmile;Prod;ProdSmile;Cat;CatSmile;Solv;SolvSmile;Nuc;NucSmile");
							
							writer.println("Reaction;Subs;"+parametersEE.getContentSubs()+";Prod;"+
									parametersEE.getContentProd()+";Cat;"+parametersEE.getContentCat()+";Solv;"+
									parametersEE.getContentSolv()+";Nuc;"+parametersEE.getContentNuc());
						
							
							nLinea = 1;							
							
							writer.close();				
						}
							
						String random = utils.randomNameFile();
						
						
						if (file.getOriginalFilename().length() > 0)
						{
							FILE_NAME_RESULT = FILE_NAME.substring(0, file.getOriginalFilename().trim().length()-4)+"_"+random+"_RESULT.txt";
						}
						else
						{
							FILE_NAME_RESULT = FILE_NAME.substring(0, FILE_NAME.length()-4)+"_"+random+"_RESULT.txt";
						}
						
						
						if (parametersEE.isCheckSimilarity())
						{	
							RScript = "Rscript "+raiz+"/R/EECalc/SimilaritySearch.R "+ " " +raiz+" "+UPLOADED_FOLDER+FILE_NAME +" "+RESULT_FOLDER+"EE_"+FILE_NAME_RESULT+" "+
									parametersEE.getTimeSimilarity()+" "+parametersEE.getTimeSimilarity()+" "+0+" "+
									parametersEE.getTempSimilarity()+" "+parametersEE.getTempSimilarity()+" "+0+" "+
									parametersEE.getLoadSimilarity()+" "+parametersEE.getLoadSimilarity()+" "+ 0+" "+parametersEE.getQuiralSimilarity();	
																		
							
							timeProgres = nLinea * 50;
							
							fileName = "EE_"+FILE_NAME_RESULT;
							
												
						}
						
						if (parametersEE.isCheckStructural())
						{	
							String elementSelected = utils.getElementScan(parametersEE.isScanCat(),parametersEE.isScanSol(), parametersEE.isScanNuc(), parametersEE.isScanSub());
																
							RScript = "Rscript "+raiz+"/R/EECalc/structuralScaningPredict.R "+ " " +raiz+" "+UPLOADED_FOLDER+FILE_NAME +" "+RESULT_FOLDER+"EE_"+elementSelected+"_"+FILE_NAME_RESULT+" "+
									elementSelected+" "+parametersEE.getTimeSimilarity()+" "+parametersEE.getTempSimilarity()+" "+parametersEE.getLoadSimilarity()+" "+parametersEE.getQuiralStructural();
							
							if (elementSelected.equals("sol"))
							{
								timeProgres = nLinea * 100;
							}
							
							if (elementSelected.equals("cat"))
							{
								timeProgres = nLinea * 200;
							}
							
							if (elementSelected.equals("sub"))
							{
								timeProgres = nLinea * 150;
							}
							
							if (elementSelected.equals("nuc"))
							{
								timeProgres = nLinea * 150;
							}
									
							fileName = "EE_"+elementSelected+"_"+FILE_NAME_RESULT;				
														
						}
						
						if (parametersEE.isCheckConditions())
						{	
							
							double minTime = parametersEE.getMinTime();
							double maxTime = parametersEE.getMaxTime();
							double stepTime = parametersEE.getStepTime();
							
							double minTemp = parametersEE.getMinTemp();
							double maxTemp = parametersEE.getMaxTemp();
							double stepTemp = parametersEE.getStepTemp();
							
							double minLoad = parametersEE.getMinLoad();
							double maxLoad = parametersEE.getMaxLoad();
							double stepLoad = parametersEE.getStepLoad();

							double maxStepTime = maxTime - minTime;
							double maxStepTemp = maxTemp - minTemp;
							double maxStepLoad = maxLoad - minLoad;
							
							
							if ((maxTemp > 70) || (minTemp < -78) || (stepTemp > maxStepTemp) || 
									(maxTime > 72) || (minTime < 0.5) || (stepTime > maxStepTime) ||									
									(maxLoad > 25) || (minLoad < 2) || (stepLoad > maxStepLoad)) 
							{
								model.addAttribute("error", "Temperature, time or load out of range.");	
								return "/mateo/mateo";
							}
							else
							{

								RScript = "Rscript "+raiz+"/R/EECalc/SimilaritySearch.R "+ " " +raiz+" "+UPLOADED_FOLDER+FILE_NAME +" "+RESULT_FOLDER+"EE_"+FILE_NAME_RESULT+" "+
										minTime+" "+maxTime+" "+stepTime+" "+minTemp+" "+maxTemp+" "+stepTemp+" "+minLoad+" "+maxLoad+" "+stepLoad+" "+parametersEE.getQuiralConditions();	
								
								timeProgres = nLinea * 100;
								
								fileName="EE_"+FILE_NAME_RESULT;			
							}				
						}
						
						System.out.println(RScript);	
						
						model.addAttribute("server", "EE");
						model.addAttribute("resultFile", FILE_NAME_RESULT);
						model.addAttribute("fileName", fileName);
						model.addAttribute("time", timeProgres);
						model.addAttribute("tiempoEstimado", utils.tiempoEstimado(timeProgres));
						model.addAttribute("parametersEE", parametersEE);
											
							
					} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
					} 
				
					 try {    
						Runtime.getRuntime().exec(RScript);
						//Runtime.getRuntime().exec("cmd /c start cmd.exe /K \""+RScript+"\"");
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					 
					 return "/mateo/results";
				
			}
	 
	 @RequestMapping(value = "returnMateo")
	 public String returnMateo(@ModelAttribute("parametersEE") EEParams parametersEE, Model model, HttpServletRequest request) {
	 
		 model.addAttribute("parametersEE", parametersEE);
	    	
	    	return "/mateo/mateo";
	 }

	 
	 @RequestMapping(value = "/calculateEE/example")
	 public String example()
	 {
		 return "/mateo/example";
	 }
	
	 
}
