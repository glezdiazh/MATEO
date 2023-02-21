package es.udc.CPTMLTools.model;

public class EEParams {
	
	private double tempSimilarity;
	private double timeSimilarity;
	private double loadSimilarity;
	private int quiralSimilarity;
	
	private double tempStructural;
	private double timeStructural;
	private double loadStructural;
	private int quiralStructural;
	
	private double minTemp;
	private double maxTemp;
	private double stepTemp;
	
	private double minTime;
	private double maxTime;
	private double stepTime;
	
	private double minLoad;
	private double maxLoad;
	private double stepLoad;
	private int quiralConditions;	
	
	
	private boolean scanSol;
	private boolean scanCat;
	private boolean scanNuc;
	private boolean scanSub;
	
	private byte[] file;	
	
	private String idReaction;
	private String contentProd;
	private String contentSubs;
	private String contentCat;
	private String contentSolv;
	private String contentNuc;
	
	private boolean checkSimilarity;
	private boolean checkStructural;
	private boolean checkConditions;	
	
	
	public EEParams()
	{
		this.timeSimilarity = 0.5;
		this.tempSimilarity = 70;
		this.loadSimilarity = 2;
		
		this.timeStructural = 0.5;
		this.tempStructural = 70;
		this.loadStructural = 2;
		
		this.maxTemp = 70;
		this.minTemp = -78;
		this.stepTemp = 20;
		
		this.maxTime = 72;
		this.minTime = 0.5;
		this.stepTime = 5;
		
		this.maxLoad = 25;
		this.minLoad = 2;
		this.stepLoad = 1;
		
		this.checkSimilarity = false;
		this.checkStructural = false;
		this.checkConditions = false;
	}




	public double getTempSimilarity() {
		return tempSimilarity;
	}




	public void setTempSimilarity(double tempSimilarity) {
		this.tempSimilarity = tempSimilarity;
	}




	public double getTimeSimilarity() {
		return timeSimilarity;
	}




	public void setTimeSimilarity(double timeSimilarity) {
		this.timeSimilarity = timeSimilarity;
	}




	public double getLoadSimilarity() {
		return loadSimilarity;
	}




	public void setLoadSimilarity(double loadSimilarity) {
		this.loadSimilarity = loadSimilarity;
	}




	public int getQuiralSimilarity() {
		return quiralSimilarity;
	}




	public void setQuiralSimilarity(int quiralSimilarity) {
		this.quiralSimilarity = quiralSimilarity;
	}




	public double getTempStructural() {
		return tempStructural;
	}




	public void setTempStructural(double tempStructural) {
		this.tempStructural = tempStructural;
	}




	public double getTimeStructural() {
		return timeStructural;
	}




	public void setTimeStructural(double timeStructural) {
		this.timeStructural = timeStructural;
	}




	public double getLoadStructural() {
		return loadStructural;
	}




	public void setLoadStructural(double loadStructural) {
		this.loadStructural = loadStructural;
	}




	public int getQuiralStructural() {
		return quiralStructural;
	}




	public void setQuiralStructural(int quiralStructural) {
		this.quiralStructural = quiralStructural;
	}




	public double getMinTemp() {
		return minTemp;
	}




	public void setMinTemp(double minTemp) {
		this.minTemp = minTemp;
	}




	public double getMaxTemp() {
		return maxTemp;
	}




	public void setMaxTemp(double maxTemp) {
		this.maxTemp = maxTemp;
	}




	public double getStepTemp() {
		return stepTemp;
	}




	public void setStepTemp(double stepTemp) {
		this.stepTemp = stepTemp;
	}




	public double getMinTime() {
		return minTime;
	}




	public void setMinTime(double minTime) {
		this.minTime = minTime;
	}




	public double getMaxTime() {
		return maxTime;
	}




	public void setMaxTime(double maxTime) {
		this.maxTime = maxTime;
	}




	public double getStepTime() {
		return stepTime;
	}




	public void setStepTime(double stepTime) {
		this.stepTime = stepTime;
	}




	public double getMinLoad() {
		return minLoad;
	}




	public void setMinLoad(double minLoad) {
		this.minLoad = minLoad;
	}




	public double getMaxLoad() {
		return maxLoad;
	}




	public void setMaxLoad(double maxLoad) {
		this.maxLoad = maxLoad;
	}




	public double getStepLoad() {
		return stepLoad;
	}




	public void setStepLoad(double stepLoad) {
		this.stepLoad = stepLoad;
	}




	public int getQuiralConditions() {
		return quiralConditions;
	}




	public void setQuiralConditions(int quiralConditions) {
		this.quiralConditions = quiralConditions;
	}


	public boolean isScanSol() {
		return scanSol;
	}




	public void setScanSol(boolean scanSol) {
		this.scanSol = scanSol;
	}




	public boolean isScanCat() {
		return scanCat;
	}




	public void setScanCat(boolean scanCat) {
		this.scanCat = scanCat;
	}




	public boolean isScanNuc() {
		return scanNuc;
	}




	public void setScanNuc(boolean scanNuc) {
		this.scanNuc = scanNuc;
	}




	public boolean isScanSub() {
		return scanSub;
	}




	public void setScanSub(boolean scanSub) {
		this.scanSub = scanSub;
	}


	public byte[] getFile() {
		return file;
	}




	public void setFile(byte[] file) {
		this.file = file;
	}




	public String getIdReaction() {
		return idReaction;
	}




	public void setIdReaction(String idReaction) {
		this.idReaction = idReaction;
	}




	public String getContentProd() {
		return contentProd;
	}




	public void setContentProd(String contentProd) {
		this.contentProd = contentProd;
	}




	public String getContentSubs() {
		return contentSubs;
	}




	public void setContentSubs(String contentSubs) {
		this.contentSubs = contentSubs;
	}




	public String getContentCat() {
		return contentCat;
	}




	public void setContentCat(String contentCat) {
		this.contentCat = contentCat;
	}




	public String getContentSolv() {
		return contentSolv;
	}




	public void setContentSolv(String contentSolv) {
		this.contentSolv = contentSolv;
	}




	public String getContentNuc() {
		return contentNuc;
	}




	public void setContentNuc(String contentNuc) {
		this.contentNuc = contentNuc;
	}




	public boolean isCheckSimilarity() {
		return checkSimilarity;
	}




	public void setCheckSimilarity(boolean checkSimilarity) {
		this.checkSimilarity = checkSimilarity;
	}




	public boolean isCheckStructural() {
		return checkStructural;
	}




	public void setCheckStructural(boolean checkStructural) {
		this.checkStructural = checkStructural;
	}




	public boolean isCheckConditions() {
		return checkConditions;
	}




	public void setCheckConditions(boolean checkConditions) {
		this.checkConditions = checkConditions;
	}
	
	
	
}
