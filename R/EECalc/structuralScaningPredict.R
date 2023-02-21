library(ChemmineR)
library(base)
library(expm)
library(MASS)
library(openxlsx)
library("stringr")

args <- commandArgs(TRUE)

rutaParcial = args[1]
fileInput = args[2]
resultFile = args[3]

rutaFunctions = paste(rutaParcial,"/R/EECalc/RMarkovTI_functions_VPCR.R",sep = "", collapse = NULL) 
source(rutaFunctions)

scanElements = args[4]
temp =  as.numeric(args[6])
time =  as.numeric(args[5])
load =  as.numeric(args[7])
quiral =  as.numeric(args[8])


#Reference reactions
refData = read.xlsx(paste(rutaParcial,"/R/EECalc/RefReactions.xlsx", sep = "", collapse = NULL), sheet = "All")
refReactions = paste(rutaParcial,"/R/EECalc/RefReactions.xlsx", sep = "", collapse = NULL) 

#Input reactions
inputData=read.table(fileInput,header=T, sep=";", comment.char="?")


finalDf <- data.frame(matrix(ncol = 22, nrow = 0))

for (inputReaction in 1:nrow(inputData))
{
  print("**********************************")
  print(paste("processing", inputData[inputReaction,1]))
  print("**********************************")
  
  subs_Vvdw_All <- calculateDescriptor(rutaParcial, "Zv,EA,aPolar,SAe","All", inputData[inputReaction,3])
  
  prod_EA_Csat <- calculateDescriptor(rutaParcial, "Zv,aPolar,Vvdw,SAe","Csat", inputData[inputReaction,5])
  prod_aPolar_HetNox <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","HetNoX", inputData[inputReaction,5])
  
  cat_Zv_Cuns <- calculateDescriptor(rutaParcial, "EA,aPolar,Vvdw,SAe","Cuns", inputData[inputReaction,7])
  cat_Sae_HetNox <- calculateDescriptor(rutaParcial, "Zv,EA,aPolar,Vvdw","HetNoX", inputData[inputReaction,7])
  cat_aPolar_Cuns <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","Cuns", inputData[inputReaction,7])
  #cat_EA_HetNox <- calculateDescriptor(rutaParcial, "Zv,aPolar,Vvdw,SAe","HetNoX", inputData[inputReaction,7])
  cat_EA_HetNox <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","HetNoX", inputData[inputReaction,5])
  
  solv_Zv_Cuns <- calculateDescriptor(rutaParcial, "EA,aPolar,Vvdw,SAe","Cuns", inputData[inputReaction,9])
  
  nuc_SAe_Het <- calculateDescriptor(rutaParcial, "Zv,EA,aPolar,Vvdw","Het", inputData[inputReaction,11])
  
  none =""
  
  minResultDistReacion <- minDist(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                                  cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp)
  
  minReaction = 1

    
    eeqq = eeqqCalc(minResultDistReacion,minReaction, load, temp, time, cat_Zv_Cuns, prod_EA_Csat, solv_Zv_Cuns, nuc_SAe_Het,
                    cat_Sae_HetNox, cat_aPolar_Cuns, cat_EA_HetNox, prod_aPolar_HetNox, subs_Vvdw_All)
    
    
    finalDf[nrow(finalDf) + 1,] = c(as.character(inputData[inputReaction,1]), none,
                                    time, temp, load, round(eeqq, digits = 1), minResultDistReacion[minReaction,2],minResultDistReacion[minReaction,3],
                                    minResultDistReacion[minReaction,5],minResultDistReacion[minReaction,8],minResultDistReacion[minReaction,7],
                                    minResultDistReacion[minReaction,4],minResultDistReacion[minReaction,6],
                                    minResultDistReacion[minReaction,10],
                                    minResultDistReacion[minReaction,12],minResultDistReacion[minReaction,11],minResultDistReacion[minReaction,10],
                                    minResultDistReacion[minReaction,15],minResultDistReacion[minReaction,14], minResultDistReacion[minReaction,19],
                                    minResultDistReacion[minReaction,13],minResultDistReacion[minReaction,17])
  

  if (scanElements == "sol")
  { 
    refSol = read.xlsx(refReactions, sheet = "Sol")
    
    for (j in 1:nrow(refSol))
    {
      solv_Zv_Cuns <- refSol[j,3]
      solvent <- refSol[j,1]
      solv_smile <- refSol[j,2]
      
      
      minResultDistReacion <- minDist(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                                      cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp)
      
      
      minReaction = 1
      
        eeqq = eeqqCalc(minResultDistReacion,minReaction, load, temp, time, cat_Zv_Cuns, prod_EA_Csat, solv_Zv_Cuns, nuc_SAe_Het,
                      cat_Sae_HetNox, cat_aPolar_Cuns, cat_EA_HetNox, prod_aPolar_HetNox, subs_Vvdw_All)
                
               finalDf[nrow(finalDf) + 1,] = c(as.character(inputData[inputReaction,1]), solvent,
                                           time, temp, load, round(eeqq, digits = 1), minResultDistReacion[minReaction,2],minResultDistReacion[minReaction,3],
                                           minResultDistReacion[minReaction,5],minResultDistReacion[minReaction,8],minResultDistReacion[minReaction,7],
                                           minResultDistReacion[minReaction,4],minResultDistReacion[minReaction,6],
                                           minResultDistReacion[minReaction,10],
                                           minResultDistReacion[minReaction,12],minResultDistReacion[minReaction,11],minResultDistReacion[minReaction,10],
                                           minResultDistReacion[minReaction,15],minResultDistReacion[minReaction,14], minResultDistReacion[minReaction,19],
                                           solv_smile, minResultDistReacion[minReaction,17])
          
      }
  }
  
  if (scanElements == "cat"){ 
    
    refCat = read.xlsx(refReactions, sheet = "Cat")
    
    for (j in 1:nrow(refCat)){
      
      cat_Zv_Cuns = refCat[j,3]
      cat_Sae_HetNox = refCat[j,4]
      cat_aPolar_Cuns = refCat[j,5]
      cat_EA_HetNox = refCat[j,6]
      
      catalyst = refCat[j,1]
      catalyst_smile = refCat[j,2]
      
      minResultDistReacion <- minDist(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                                      cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp)
      
       
      minReaction = 1
        
        eeqq = eeqqCalc(minResultDistReacion,minReaction, load, temp, time, cat_Zv_Cuns, prod_EA_Csat, solv_Zv_Cuns, nuc_SAe_Het,
                        cat_Sae_HetNox, cat_aPolar_Cuns, cat_EA_HetNox, prod_aPolar_HetNox, subs_Vvdw_All)
       
             finalDf[nrow(finalDf) + 1,] = c(as.character(inputData[inputReaction,1]), catalyst,
                                        time, temp, load, round(eeqq, digits = 1), minResultDistReacion[minReaction,2],minResultDistReacion[minReaction,3],
                                        minResultDistReacion[minReaction,5],minResultDistReacion[minReaction,8],minResultDistReacion[minReaction,7],
                                        minResultDistReacion[minReaction,4],minResultDistReacion[minReaction,6],
                                        minResultDistReacion[minReaction,10],
                                        minResultDistReacion[minReaction,12],minResultDistReacion[minReaction,11],minResultDistReacion[minReaction,10],
                                        minResultDistReacion[minReaction,15],minResultDistReacion[minReaction,14], catalyst_smile,
                                        minResultDistReacion[minReaction,13],minResultDistReacion[minReaction,17])
      
    }
    
  }
  
  if (scanElements == "nuc"){ 
    
    refNuc = read.xlsx(refReactions, sheet = "Nuc")
    
    for (j in 1:nrow(refNuc))
    {
      nuc_SAe_Het = refNuc[j,3]
      nucleophile = refNuc[j,4]
      nucleophile_smile = refNuc[j,2]
      
      minResultDistReacion <- minDist(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                                      cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp)
      
       
      minReaction = 1
      
      
        
        eeqq = eeqqCalc(minResultDistReacion,minReaction, load, temp, time, cat_Zv_Cuns, prod_EA_Csat, solv_Zv_Cuns, nuc_SAe_Het,
                        cat_Sae_HetNox, cat_aPolar_Cuns, cat_EA_HetNox, prod_aPolar_HetNox, subs_Vvdw_All)
        
        
        finalDf[nrow(finalDf) + 1,] = c(as.character(inputData[inputReaction,1]), nucleophile,
                                        time, temp, load, round(eeqq, digits = 1), minResultDistReacion[minReaction,2],minResultDistReacion[minReaction,3],
                                        minResultDistReacion[minReaction,5],minResultDistReacion[minReaction,8],minResultDistReacion[minReaction,7],
                                        minResultDistReacion[minReaction,4],minResultDistReacion[minReaction,6],
                                        minResultDistReacion[minReaction,10],
                                        minResultDistReacion[minReaction,12],minResultDistReacion[minReaction,11],minResultDistReacion[minReaction,10],
                                        minResultDistReacion[minReaction,15],minResultDistReacion[minReaction,14], minResultDistReacion[minReaction,19],
                                        minResultDistReacion[minReaction,13],nucleophile_smile)
        
      
    }
    
  }
  
  if (scanElements == "sub")
  { 
    refSub = read.xlsx(refReactions, sheet = "Sub")
   
    for (j in 1:nrow(refSub)){
      
      subs_Vvdw_All = refSub[j,3]
      substrate = refSub[j,1]
      substrate_smile = refSub[j,2]
      
      minResultDistReacion <- minDist(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                                      cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp)
      
       
      minReaction = 1
        
        eeqq = eeqqCalc(minResultDistReacion,minReaction, load, temp, time, cat_Zv_Cuns, prod_EA_Csat, solv_Zv_Cuns, nuc_SAe_Het,
                        cat_Sae_HetNox, cat_aPolar_Cuns, cat_EA_HetNox, prod_aPolar_HetNox, subs_Vvdw_All)
        
             finalDf[nrow(finalDf) + 1,] = c(as.character(inputData[inputReaction,1]), substrate,
                                        time, temp, load, round(eeqq, digits = 1), minResultDistReacion[minReaction,2],minResultDistReacion[minReaction,3],
                                        minResultDistReacion[minReaction,5],minResultDistReacion[minReaction,8],minResultDistReacion[minReaction,7],
                                        minResultDistReacion[minReaction,4],minResultDistReacion[minReaction,6],
                                        minResultDistReacion[minReaction,10],
                                        minResultDistReacion[minReaction,12],minResultDistReacion[minReaction,11],minResultDistReacion[minReaction,10],
                                        substrate_smile,minResultDistReacion[minReaction,14], minResultDistReacion[minReaction,19],
                                        minResultDistReacion[minReaction,13],minResultDistReacion[minReaction,17])
        
      
    }
 }
}

colnames(finalDf) <- c("Reacction_pred", "structure_Changed", 
                       "Time_pred", "Temp_pred", "Load_pred", eeText(quiral), "Reference","ee_ref",
                       "Subs_code_ref","Prod_Code_ref", "Cat_Code_ref",
                       "Solvent_ref","Nuc_code_ref",
                       "dcat_ref",
                       "Time_ref", "Temp_ref","Load_ref",
                       "Smile_Subs_ref", "Smile_Prod_ref","Smile_Cat_ref",
                       "Smile_Solvent_ref","Smile_Nuc_ref")

  
write.table(finalDf, resultFile, sep="\t", quote = FALSE, row.names = FALSE)


print("**********************************")
print(paste("Finalized! Result file is saved in ",resultFile))
print("**********************************")




