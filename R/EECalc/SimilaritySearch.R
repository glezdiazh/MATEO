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

resultFileImg = paste(substr(resultFile, start=1, stop=nchar(resultFile)-4), sep = "", "Img.txt")

rutaFunctions = paste(rutaParcial,"/R/EECalc/RMarkovTI_functions_VPCR.R",sep = "", collapse = NULL) 

source(rutaFunctions)

minTime = as.numeric(args[4])
maxTime = as.numeric(args[5])
stepTime = as.numeric(args[6])

minTemp = as.numeric(args[7])
maxTemp = as.numeric(args[8])
stepTemp = as.numeric(args[9])

minLoad = as.numeric(args[10])
maxLoad = as.numeric(args[11])
stepLoad = as.numeric(args[12])

quiral = as.numeric(args[13])



#Reference reactions
refData = read.xlsx(paste(rutaParcial,"/R/EECalc/RefReactions.xlsx",sep = "", collapse = NULL), sheet = "All")

#Input reactions
inputData=read.table(fileInput,header=T, sep=";", comment.char="?")

#Output file size
finalDf <- data.frame(matrix(ncol = 5, nrow = 0))
finalDfImg <- data.frame(matrix(ncol = 3, nrow = 0))
#Output file Header
colnames(finalDf) <- c("Reaction",eeText(quiral), "Time", "Temp", "Load")
colnames(finalDfImg) <- c("subs", "nuc", "cat")

for(inputReaction in 1:nrow(inputData)){
  
  
    print("**********************************")
    print(paste("processing", inputData[inputReaction,1]))
    print("**********************************")
    
    # Call functions to calculate individual descriptors
    subs_Vvdw_All <- calculateDescriptor(rutaParcial, "Zv,EA,aPolar,SAe","All", inputData[inputReaction,3])
    
    prod_EA_Csat <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","HetNoX", inputData[inputReaction,5])
    prod_aPolar_HetNox <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","HetNoX", inputData[inputReaction,5])
    
    cat_Zv_Cuns <- calculateDescriptor(rutaParcial, "EA,aPolar,Vvdw,SAe","Cuns", inputData[inputReaction,7])
    cat_Sae_HetNox <- calculateDescriptor(rutaParcial, "Zv,EA,aPolar,Vvdw","HetNoX", inputData[inputReaction,7])
    
    cat_aPolar_Cuns <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","Cuns", inputData[inputReaction,7])
    #cat_EA_HetNox <- calculateDescriptor(rutaParcial, "Zv,aPolar,Vvdw,SAe","HetNoX", inputData[inputReaction,7])
    cat_EA_HetNox <- calculateDescriptor(rutaParcial, "Zv,EA,Vvdw,SAe","HetNoX", inputData[inputReaction,5])
    
    solv_Zv_Cuns <- calculateDescriptor(rutaParcial, "EA,aPolar,Vvdw,SAe","Cuns", inputData[inputReaction,9])
    nuc_SAe_Het <- calculateDescriptor(rutaParcial, "Zv,EA,aPolar,Vvdw","Het", inputData[inputReaction,11])
    
    minResultDistReacion <- minDist(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                                    cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, minLoad, minTime, minTemp)
    
    for(minReaction in 1:nrow(minResultDistReacion)){
      
      for(time in seq(from=minTime, to=maxTime, by=stepTime)){
        
        for(temp in seq(from=minTemp, to=maxTemp, by=stepTemp)){
          
          for(load in seq(from=minLoad, to=maxLoad, by=stepLoad)){
            
              
              eeqq = eeqqCalc(minResultDistReacion,minReaction, load, temp, time, cat_Zv_Cuns, prod_EA_Csat, solv_Zv_Cuns, nuc_SAe_Het,
                              cat_Sae_HetNox, cat_aPolar_Cuns, cat_EA_HetNox, prod_aPolar_HetNox, subs_Vvdw_All)
              
              finalDf[nrow(finalDf) + 1,] = c(as.character(inputData[inputReaction,1]), round(quiral*eeqq, digits=1), time, temp, load)
              finalDfImg[nrow(finalDfImg) + 1,] = c(minResultDistReacion[minReaction,5],minResultDistReacion[minReaction,6], 
                                              minResultDistReacion[minReaction,7])
          }
        }
      }
    }
    
    
    print("**********************************")
    print(paste(inputData[inputReaction,1], "processed"))
    if (inputReaction < (nrow(inputData)))
      print(paste("processing", inputData[inputReaction+1,1]))
    print("**********************************")
  }
  
  write.table(finalDf, resultFile, sep="\t", row.names=FALSE,  quote = TRUE)
  write.table(finalDfImg, resultFileImg, sep="\t", row.names=FALSE,  quote = TRUE)

  
  print("**********************************")
  print(paste("Finalized! Result file is saved in ",resultFile))
  print("**********************************")
  

  
  

  

