# ===================================================================================
# RDMMProp = R Drug Markov Mean Properties
# ===================================================================================
# Calculate Markov Mean Properties (molecular descriptors) using SMILES drug formulas
# enanomapper.net
# ----------------------------------------------------------------------------------------------
# AUTHORS: 
# ----------------------------------------------------------------------------------------------
# Cristian R. Munteanuhttps://clc.stackoverflow.com/click?an=41J9JHH38pMbHqxy1cGuTEwsK28u5ctm2bpO_O9U-dttGgzGDD0bGBga7BkZGVi4Wf_eEj8yQ-Vxpy5cnJt1zhuZf7dVd53VQxLrfSB-u1351Q9tJLEvfVJzHystvIIQYzj4b4vqiRvvhBiuAgA&cr=719978&ct=0&url=https%3A%2F%2Fstackoverflow.com%2Fjobs%2Fcompanies%2Fendgame360%3Fso_medium%3DAd%26so_source%3DSharedCompanyAd%26so_campaign%3DGenericRed%26med%3Dclc%26clc-var%3D51&sig=ELTw4MpjkYZlUQ: RNASA-IMEDIR, University of A Coruna, Spain, muntisa@gmail.com
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


RDMarkovMeans_results <- RDMarkovMeans(SFile=inputFile, sErrorFile = errorFile, sResultFile=outputFile, 
                                       atomPropExcluded=atomProp, atomTypesSelected = atomTypes, ruta=rutaParcial)

