package es.udc.CPTMLTools.util;


import java.util.Random;
import org.springframework.util.StringUtils;

import es.udc.CPTMLTools.model.MMDParams;


public class Utils {
	
	public String randomNameFile()
	{
		String cadenaAleatoria = "";
		long milis = new java.util.GregorianCalendar().getTimeInMillis();
		Random r = new Random(milis);
		
		int i = 0;
		while ( i < 5){
			char c = (char)r.nextInt(255);
			if ( (c >= '0' && c <='9') || (c >='A' && c <='Z') ){
				cadenaAleatoria += c;
				i ++;
			}
		}
		
		return cadenaAleatoria;
	}
	

	public String formateaCadenas(String cadena)
	{
		 
		String cadenaFormateada = "";
		String[] lineas = cadena.replaceAll(" ","").split("\\r?\\n");
		
		for (String linea: lineas) {           
	       
			if (!linea.equals(""))
			{
				int comas = StringUtils.countOccurrencesOf(linea, ",");
				
				if (!linea.contains(";") || comas > 1)
				{
					cadenaFormateada = "error";
					break;
				}
				else
				{
					cadenaFormateada = cadenaFormateada + linea+"\n";
				}
			}
	    }
		
		return cadenaFormateada;
	}
	

	public String getElementScan(boolean scanCat, boolean scanSol, boolean scanNuc, boolean scanSub)
	{
		String elementScan = "";
		
		if (scanCat)
		{
			elementScan ="cat";
		}
		else
		{		
			if (scanSol)
			{
				elementScan ="sol";
			}
			else
			{			
				if (scanNuc)
				{
					elementScan ="nuc";
				}
				else {									
					if (scanSub)
					{
						elementScan ="sub";
					}
					else
					{
						elementScan = "none";
					}
				}
			}
		}
		return elementScan;
	}
	

	
	public String atomProperties(MMDParams parameters)
	{
		String atomPropertiesUnselected = " ";
		
				
		if (!parameters.isaPolar())
		{
			atomPropertiesUnselected = atomPropertiesUnselected + "aPolar,";
		}
		
		if (!parameters.isEa())
		{
			atomPropertiesUnselected = atomPropertiesUnselected + "EA,";
		}
		
		if (!parameters.isSae())
		{
			atomPropertiesUnselected = atomPropertiesUnselected + "SAe,";
		}
		
		if (!parameters.isVvdw())
		{
			atomPropertiesUnselected = atomPropertiesUnselected + "Vvdw,";
		}
		
		if (!parameters.isZv())
		{
			atomPropertiesUnselected = atomPropertiesUnselected + "Zv,";
		}
		
		if ((parameters.isaPolar() && (parameters.isEa()) && (parameters.isSae()) && (parameters.isVvdw())
				&& (parameters.isZv())) || (parameters.isNoneAtProp()))
		{
			atomPropertiesUnselected =  " none,"; 
		}
		
		String atomPropertiesUnselectedFinal = atomPropertiesUnselected.substring(0, atomPropertiesUnselected.length()-1);
		
			
		return atomPropertiesUnselectedFinal;
	}
	
	public String atomTypes(MMDParams parameters)
	{
		String atomTypesSelected = "";
		String atomTypesSelectedFinal = "";
		
		if (parameters.isAllAtoms())
		{
			atomTypesSelected = atomTypesSelected +"All,";
					
		}
		
		if (parameters.iscSat())
		{
			atomTypesSelected = atomTypesSelected +"Csat,";
					
		}
		
		if (parameters.iscUns())
		{
			atomTypesSelected = atomTypesSelected +"Cuns,";
					
		}
		
		if (parameters.isHal())
		{
			atomTypesSelected = atomTypesSelected +"Hal,";
					
		}
		
		if (parameters.isHet())
		{
			atomTypesSelected = atomTypesSelected +"Het,";
					
		}
		
		if (parameters.isHetNoX())
		{
			atomTypesSelected = atomTypesSelected +"HetNoX,";
					
		}
		
		if (!atomTypesSelected.equals("")) {
			
			atomTypesSelectedFinal = atomTypesSelected.substring(0, atomTypesSelected.length()-1);
		}		
	
		return atomTypesSelectedFinal;
	}
	
	public String tiempoEstimado(Long time)
	{		
		int minutos = (int) Math.round(time/600);		
		int horas = 0;
		
		if (minutos > 60)
		{
			horas = (int) Math.round(minutos/60);
			minutos = minutos % 60;
			return "Estimated  time: "+ horas +" hours : "+ minutos + " minutes";
		}
		else
		{
			return "";
		}
		
	 
	}

}
