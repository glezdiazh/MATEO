# ===================================================================================
# RDMMProp = R Drug Markov Mean Properties
# ===================================================================================
# Calculate Markov Mean Properties (molecular descriptors) using SMILES drug formulas
# enanomapper.net
# ----------------------------------------------------------------------------------------------
# AUTHORS: 
# ----------------------------------------------------------------------------------------------
# Cristian R. Munteanu: RNASA-IMEDIR, University of A Coruna, Spain, muntisa@gmail.com
# Carlos Fernandez-Lozano: RNASA-IMEDIR, University of A Coruna, Spain, carlos.fernandez@udc.es 
# Georgia Tsiliki: ChemEng - NTUA, Greece, g_tsiliki@hotmail.com
# Haralambos Sarimveis: ChemEng - NTUA, Greece, hsarimv@central.ntua.gr
# Humberto Gonzalez-Diaz, IKERBASQUE / University of Basque Country, Spain, gonzalezdiazh@yahoo.es
# Egon Willighagen: BiGCaT - Maastricht University, Netherlands, egon.willighagen@gmail.com
# ----------------------------------------------------------------------------------------------

# if you downloaded a source distribution, you can also use the version in the package:
library(ChemmineR)
library(base)
library(expm)
library(MASS)
library("stringr")

args <- commandArgs(TRUE)

rutaParcial = args[1]
inputFile = args[2]
errorFile = args[3]
outputFile = args[4]
atomProp = args[5]
atomTypes = args[6]


rutaFinal = paste(rutaParcial,"/R/MDCalc/RMarkovTI/R/RMarkovTI_functions.R",sep = "", collapse = NULL) 

source(rutaFinal)

print(inputFile)

RDMarkovSingulars_results <- RDMarkovSingulars(SFile=inputFile, sErrorFile = errorFile, sResultFile=outputFile, 
                                               atomPropExcluded=atomProp, atomTypesSelected = atomTypes, ruta=rutaParcial)

