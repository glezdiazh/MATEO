library(ChemmineR)
library(base)
library(expm)
library(MASS)
library("stringr")


eeqqCalc <- function(refData, r, load, temp, time, cat_zv, prod_ea, solv_zv, nuc_sae, cat_sae, cat_apolar, cat_ea, prod_apolar, subs_Vvdw){
 

  
  eeqq = -0.914038918667643 + as.numeric(refData[r,"ee_ref"]) - 0.821032133512764 * (load-as.numeric(refData[r,"Load"]))
  - 0.343919121414324 * (temp-as.numeric(refData[r,"Temp"]))
  + 0.211791266990752 * (time-as.numeric(refData[r,"Time"]))
  + 22.0406704292748 * (cat_zv - as.numeric(refData[r,"Zv_Cuns_Cat_Mean_ref"]))
  - 215.982019256065 * (prod_ea - as.numeric(refData[r,"EA_Csat_Prod_Mean_ref"]))
  - 12.4578151202493 * (solv_zv - as.numeric(refData[r,"Zv_Cuns_Solv_Mean_ref"]))
  - 42.4863067259439 * (nuc_sae - as.numeric(refData[r,"SAe_Het_Nuc_Mean_ref"]))
  + 750.757360483937 * (cat_sae - as.numeric(refData[r,"SAe_HetNoX_Cat_Mean_ref"]))
  - 174.368536901798 * (cat_apolar - as.numeric(refData[r,"aPolar_Cuns_Cat_Mean_ref"]))
  - 1747.11691314115 * (cat_ea - as.numeric(refData[r,"EA_HetNoX_Cat_Mean_ref"]))
  - 1534.17019704508 * (prod_apolar - as.numeric(refData[r,"aPolar_HetNoX_Prod_Mean_ref"]))
  - 34.1870137382133 * (subs_Vvdw - as.numeric(refData[r,"Vvdw_All_Sub_Mean_ref"]))
  

  if (eeqq >= 100)
  {
    eeqq = 99
  }
  
  if (eeqq <= -100)
  {
    eeqq = -99
  }
  

  return(eeqq);
}


minMaxDist <- function(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                    cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp){
  
  dist <- sqrt((cat_Zv_Cuns - refData[1,"Zv_Cuns_Cat_Mean_ref"])^2
               + (prod_EA_Csat - refData[1,"EA_Csat_Prod_Mean_ref"])^2
               + (solv_Zv_Cuns - refData[1,"Zv_Cuns_Solv_Mean_ref"])^2
               + (nuc_SAe_Het - refData[1,"SAe_Het_Nuc_Mean_ref"])^2
               + (cat_Sae_HetNox - refData[1,"SAe_HetNoX_Cat_Mean_ref"])^2
               + (cat_aPolar_Cuns - refData[1,"aPolar_Cuns_Cat_Mean_ref"])^2
               + (cat_EA_HetNox - refData[1,"EA_HetNoX_Cat_Mean_ref"])^2
               + (prod_aPolar_HetNox - refData[1,"aPolar_HetNoX_Prod_Mean_ref"])^2
               + (subs_Vvdw_All - refData[1,"Vvdw_All_Sub_Mean_ref"])^2
               + (load-refData[1,"Load"])^2 + (time-refData[1,"Time"])^2 + (temp-refData[1,"Temp"])^2)
  
  minDist = dist
  maxDist = dist
  
  for (reaction in 2: nrow(refData))
  {
    dist <- sqrt((cat_Zv_Cuns - refData[reaction,"Zv_Cuns_Cat_Mean_ref"])^2
                 + (prod_EA_Csat - refData[reaction,"EA_Csat_Prod_Mean_ref"])^2
                 + (solv_Zv_Cuns - refData[reaction,"Zv_Cuns_Solv_Mean_ref"])^2
                 + (nuc_SAe_Het - refData[reaction,"SAe_Het_Nuc_Mean_ref"])^2
                 + (cat_Sae_HetNox - refData[reaction,"SAe_HetNoX_Cat_Mean_ref"])^2
                 + (cat_aPolar_Cuns - refData[reaction,"aPolar_Cuns_Cat_Mean_ref"])^2
                 + (cat_EA_HetNox - refData[reaction,"EA_HetNoX_Cat_Mean_ref"])^2
                 + (prod_aPolar_HetNox - refData[reaction,"aPolar_HetNoX_Prod_Mean_ref"])^2
                 + (subs_Vvdw_All - refData[reaction,"Vvdw_All_Sub_Mean_ref"])^2)
                 + (load-refData[[reaction,"Load"]])^2 + (time-refData[reaction,"Time"])^2 + (temp-refData[reaction,"Temp"])^2
    
    if (dist < minDist)
    {
      minDist <- dist
    }
    
    if (dist > maxDist)
    {
      maxDist <- dist
    }
    
    return (list(minDist, maxDist))
  }
  
}


eeText <- function(quiral)
{
  if (quiral == 1)
    return ("*ee(%)[R]Calc")
  else
    return ("*ee(%)[S]Calc")
}

minDist <- function(refData, subs_Vvdw_All, nuc_SAe_Het, prod_EA_Csat, prod_aPolar_HetNox,  cat_Zv_Cuns, cat_Sae_HetNox,
                    cat_aPolar_Cuns, cat_EA_HetNox, solv_Zv_Cuns, load, time, temp){
  
  #Calculate min distance Substrate
  minDist = sqrt((subs_Vvdw_All - refData[1,"Vvdw_All_Sub_Mean_ref"])^2)
  minReactionSubs<-data.frame(refData[1,])
  
  for(refReaction in 2:nrow(refData)){
    
    distEstSubs = sqrt((subs_Vvdw_All - refData[refReaction,"Vvdw_All_Sub_Mean_ref"])^2)
    
    if (distEstSubs == minDist)
    {
      minReactionSubs[nrow(minReactionSubs) + 1,]<-data.frame(refData[refReaction,])
    }
    else
    {
      if (distEstSubs < minDist)
      {
        minReactionSubs <- minReactionSubs[FALSE, ]
        minReactionSubs<-data.frame(refData[refReaction,])
        minDist <- distEstSubs
      }
    }
    
  }
  
  minReactionDist <- minReactionSubs
  
  
  #Calculate min distance Nucleophile, Product
  if(nrow(minReactionDist) > 1)
  {
    
    minDistEstNucProd = sqrt((prod_EA_Csat - minReactionSubs[1,"EA_Csat_Prod_Mean_ref"])^2
                             + (prod_aPolar_HetNox - minReactionSubs[1,"aPolar_HetNoX_Prod_Mean_ref"])^2
                             + (nuc_SAe_Het - minReactionSubs[1,"SAe_Het_Nuc_Mean_ref"])^2)
    
    minReactionNucProd<-data.frame(minReactionSubs[1,])
    
    
    for(refReaction in 2:nrow(minReactionSubs)){
      
      distEstNucProd = sqrt((prod_EA_Csat - minReactionSubs[refReaction,"EA_Csat_Prod_Mean_ref"])^2
                            + (prod_aPolar_HetNox - minReactionSubs[refReaction,"aPolar_HetNoX_Prod_Mean_ref"])^2
                            + (nuc_SAe_Het - minReactionSubs[refReaction,"SAe_Het_Nuc_Mean_ref"])^2)
      
      if (distEstNucProd == minDistEstNucProd)
      {
        minReactionNucProd[nrow(minReactionNucProd) + 1,]<-data.frame(minReactionSubs[refReaction,])
      }
      else
      {
        if (distEstNucProd < minDistEstNucProd)
        {
          minReactionNucProd <- minReactionNucProd[FALSE, ]
          minReactionNucProd<-data.frame(minReactionSubs[refReaction,])
          minDistEstNucProd <- minReactionNucProd
        }
      }
    }
    
    minReactionDist <- minReactionNucProd
  }
  
  #Calculate min distance Catalist, Solvent, condictions(Load, Time, Temp)
  if(nrow(minReactionDist) > 1)
  {
    minDistEstCatSolCondictions = sqrt((cat_Zv_Cuns - minReactionNucProd[1,"Zv_Cuns_Cat_Mean_ref"])^2
                                       + (cat_Sae_HetNox - minReactionNucProd[1,"SAe_HetNoX_Cat_Mean_ref"])^2
                                       + (cat_aPolar_Cuns - minReactionNucProd[1,"aPolar_Cuns_Cat_Mean_ref"])^2
                                       + (cat_EA_HetNox - minReactionNucProd[1,"EA_HetNoX_Cat_Mean_ref"])^2
                                       + (solv_Zv_Cuns - minReactionNucProd[1,"Zv_Cuns_Solv_Mean_ref"])^2
                                       + (load-minReactionNucProd[[1,"Load"]])^2 + (time-minReactionNucProd[1,"Time"])^2 + (temp-minReactionNucProd[1,"Temp"])^2)
    
    minReactionCatSolCondictions<-data.frame(minReactionNucProd[1,])
    
    for(refReaction in 2:nrow(minReactionNucProd)){
      
      distEstCatSolConditions =sqrt((cat_Zv_Cuns - minReactionNucProd[refReaction,"Zv_Cuns_Cat_Mean_ref"])^2
                                    + (cat_Sae_HetNox - minReactionNucProd[refReaction,"SAe_HetNoX_Cat_Mean_ref"])^2
                                    + (cat_aPolar_Cuns - minReactionNucProd[refReaction,"aPolar_Cuns_Cat_Mean_ref"])^2
                                    + (cat_EA_HetNox - minReactionNucProd[refReaction,"EA_HetNoX_Cat_Mean_ref"])^2
                                    + (solv_Zv_Cuns - minReactionNucProd[refReaction,"Zv_Cuns_Solv_Mean_ref"])^2
                                    + (load-minReactionNucProd[refReaction,"Load"])^2 + (time-minReactionNucProd[refReaction,"Time"])^2 
                                    + (temp-minReactionNucProd[refReaction,"Temp"])^2)
      
      
      
      if (distEstCatSolConditions == minDistEstCatSolCondictions)
      {
        minReactionCatSolCondictions[nrow(minReactionCatSolCondictions) + 1,]<-data.frame(minReactionNucProd[refReaction,])
      }
      else
      {
        if (distEstCatSolConditions < minDistEstCatSolCondictions)
        {
          minReactionCatSolCondictions <- minReactionCatSolCondictions[FALSE, ]
          minReactionCatSolCondictions <- data.frame(minReactionNucProd[refReaction,])
          minDistEstCatSolCondictions <-  distEstCatSolConditions
          
        }
      }
    }
    
    minReactionDist <- minReactionCatSolCondictions
    
  }
 
  
  return (data.frame(minReactionDist))
  
}

calculateDescriptor <- function(rutaParcial, atomPropExcluded, atomTypesSelected, smile, kPower="3") {
  
  
  rutaAtomProperties = paste(rutaParcial,"/R/EECalc/AtomProperties.txt",sep = "", collapse = NULL) 
  dfW=read.table(rutaAtomProperties,header=T)  # read weigths TXT file
  
  excludeAtomsFormat <-lapply(strsplit(atomPropExcluded,','), as.character)[[1]]
  outputAtomsFile<-dfW[ , !(names(dfW) %in% excludeAtomsFormat)]
  
  Headers    <- names(outputAtomsFile)             # list variable names into the dataset
  wNoRows    <- dim(outputAtomsFile)[1]            # number of rows = atoms with properties
  wNoCols    <- dim(outputAtomsFile)[2]            # number of cols = atomic element, properties 
  
  atomTypes <- unlist(strsplit(atomTypesSelected, split=","))
  
  #-------------------------------------------------------------------------------
  # PROCESS EACH SMILES
  # - calculate MMPs for each SMILES, each pythical-chemical property and atom type
  #   averaged for all powers (0-kPower)
  #-------------------------------------------------------------------------------
  
  tryCatch({
    
    sdf <- smiles2sdf(as.character(smile))
    BM <- conMA(sdf,exclude=c("H"))    # bond matrix (complex list!)
    
    # Connectivity matrix CM
    CM <- BM[[1]]                      # get only the matrix  
    CM[CM > 0] <- 1                    # convert bond matrix into connectivity matrix/adjacency matrix CM
    
    # Degrees
    deg <- rowSums(CM)                 # atom degree (no of chemical bonds)
    atomNames <- (rownames(CM))        # atom labels from the bond table (atom_index)
    nAtoms <- length(atomNames)        # number of atoms
    BMM <- matrix(BM[[1]][1:(nAtoms*nAtoms)],ncol=nAtoms,byrow=T) # only matrix, no row names
    
    # Get list with atoms and positions
    Atoms <- list()                    # inicialize the list of atoms 
    AtIndexes <- list()                # inicialize the list of atom indixes
    for(a in 1:nAtoms){                # process each atom in bond table
      Atom <- atomNames[a]                      # pick one atom
      Elem_Ind <- strsplit(Atom,'_')            # split atom labels (atom_index)
      AtElem <- Elem_Ind[[1]][1]                # get atomic element
      AtIndex <- Elem_Ind[[1]][2]               # get index of atom element
      Atoms[a] <- c(AtElem)                     # add atom element to a list
      AtIndexes[a] <- as.numeric(c(AtIndex))    # add index of atom elements to a list
    }
    
    # Weights data frame (for all atom properties)
    # -----------------------------------------------------------------------
    # Atoms data frame
    dfAtoms <- data.frame(Pos=as.numeric(t(t(AtIndexes))),AtomE=t(t(Atoms)))
    
    # Weights data frame
    dfAtomsW <- merge(outputAtomsFile,dfAtoms,by=c("AtomE")) # merge 2 data frame using values of AtomE
    dfAtomsW <- dfAtomsW[order(dfAtomsW$Pos),1:wNoCols] # order data frame and remove Pos
    rownames(dfAtomsW) <- seq(1:dim(dfAtomsW)[1])
    
    # NEED CORRECTION FOR ATOMS that are not in the properties file: nAtoms could be different by dim(dfAtomsW)[1] if the atom is not in the properties list
    
    # Get vectors for each type of atom: All (all atoms), Csat, Cinst, Halog, Hetero, Hetero No Halogens (6 = 5 types + all atoms)
    vAtoms=(c(dfAtomsW["AtomE"]))                         # List of atoms
    # Initialize all zero vectors for each type of atom
    #vAll    <- vector(mode = "numeric", length = nAtoms)  # All atoms 
    #vCsat   <- vector(mode = "numeric", length = nAtoms)  # Saturated C
    #vCuns   <- vector(mode = "numeric", length = nAtoms)  # Unsaturated C
    #vHal    <- vector(mode = "numeric", length = nAtoms)  # Halogen atom (F,Cl,Br,I)
    #vHet    <- vector(mode = "numeric", length = nAtoms)  # Heteroatoms (any atom different of C)
    #vHetnoX <- vector(mode = "numeric", length = nAtoms)  # Heteroatoms excluding the halogens
    
    if ('All' %in% atomTypes){
      vAll    <- vector(mode = "numeric", length = nAtoms)  # All atoms 
      vAll <- vAll+1                              # vector 1 for All atoms
    }
    
    if ('Csat' %in% atomTypes){
      vCsat   <- vector(mode = "numeric", length = nAtoms)  # Saturated C
    }
    
    if ('Cuns' %in% atomTypes){
      vCuns   <- vector(mode = "numeric", length = nAtoms)  # Unsaturated C
    }
    
    if ('Hal' %in% atomTypes){
      vHal    <- vector(mode = "numeric", length = nAtoms)  # Halogen atom (F,Cl,Br,I)
    }
    
    if ('Het' %in% atomTypes){
      vHet    <- vector(mode = "numeric", length = nAtoms)  # Heteroatoms (any atom different of C)
    }
    
    if ('HetNoX' %in% atomTypes){
      vHetnoX <- vector(mode = "numeric", length = nAtoms)  # Heteroatoms excluding the halogens
    }
    
    
    
    for(a in 1:nAtoms){                         # process each atom from the list
      if (vAtoms[[1]][a]=="C"){                 # C atoms
        
        if ('Csat' %in% atomTypes){
          if (max(BMM[a,]) == 1){ 
            vCsat[a] <- 1 } # saturated C
        }
        
        if ('Cuns' %in% atomTypes){
          if (max(BMM[a,]) > 1) { 
            vCuns[a] <- 1 } # unsaturated C 
        }
        
      }
      
      else {
        if ('Het' %in% atomTypes){
          vHet[a] <- 1 # Heteroatom
        }
        
        if (vAtoms[[1]][a] %in% c("F", "Cl", "Br", "I") ) { 
          if ('Hal' %in% atomTypes){
            vHal[a] <- 1 } # Halogen atom (F,Cl,Br,I)
        }
        else {
          if ('HetNoX' %in% atomTypes){
            vHetnoX[a] <- 1 } # Heteroatoms excluding the halogens
        }
      }
    }
    
    listAtomVectors <- list() # list with the atom type vectors
    
    if ('All' %in% atomTypes){
      listAtomVectors <- c(listAtomVectors, list(vAll))
    }
    
    if ('Csat' %in% atomTypes){
      listAtomVectors <- c(listAtomVectors, list(vCsat))
    }
    
    if ('Cuns' %in% atomTypes){
      listAtomVectors <- c(listAtomVectors, list(vCuns))
    }
    
    if ('Hal' %in% atomTypes){
      listAtomVectors <- c(listAtomVectors, list(vHal))
    }
    
    if ('Het' %in% atomTypes){
      listAtomVectors <- c(listAtomVectors, list(vHet))
      
    }
    
    if ('HetNoX' %in% atomTypes){
      listAtomVectors <- c(listAtomVectors, list(vHetnoX))
    }
    
    # For each atom property
    # -----------------------------------------
    vMMP <- c()                        # final MMP descriptors for one molecule
    for(prop in 2:wNoCols){                    # for each property
      w <- t(data.matrix(dfAtomsW[prop]))[1,]    # weigths VECTOR
      W <- t(CM * w)                             # weigthed MATRIX
      p0j <- w/sum(w,na.rm=TRUE)                            # absolute initial probabilities vector
      
      # Probability Matrix P
      # ----------------------
      degW <- rowSums(W,na.rm=TRUE) # degree vector
      P <- W * ifelse(degW == 0, 0, 1/degW)      # transition probability matrix (corrected for zero division)
      # Average all descriptors by power (0-k)
      # ------------------------------------------------------------
      
      for(v in 1:length(listAtomVectors)){       # for each type of atom
        vFilter <- unlist(listAtomVectors[v])          # vector to filter the atoms (using only a type of atom)
        vMMPk <- c()                                   # MMPs for k values
        
        for(k in 0:kPower){                            # power between 0 and kPower
          
          Pk <- (P %^% k)                              # Pk = k-powered transition probability matrix
          MMPk = (vFilter*t(p0j)) %*% Pk %*% (t(t(w))*vFilter)           # MMPk for all atoms for one k = vMv type product
          
          vMMPk <- c(vMMPk, MMPk)                      # vector with all MMPs for all ks and atom properties
          
        }
        
        avgvMMP  <- mean(vMMPk,na.rm=TRUE)             # average value for all k values ( +1 because of k starting with 0) for each type of atom
        
      } 
    }
    
    
    
    return(avgvMMP)
    
  }, error=function(e){
    return("error")
  })
  
}

