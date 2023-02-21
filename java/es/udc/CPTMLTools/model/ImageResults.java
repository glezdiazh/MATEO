package es.udc.CPTMLTools.model;

import java.util.ArrayList;
import java.util.List;

public class ImageResults {
	
	 String structure;
	 String refSubs;
     String refCat;
     String refNuc;
     List<String> reaction;
     
     public ImageResults() {
    	 
    	 this.reaction = new ArrayList<String>();
     }

	public String getStructure() {
		return structure;
	}

	public void setStructure(String structure) {
		this.structure = structure;
	}

	public String getRefSubs() {
		return refSubs;
	}

	public void setRefSubs(String refSubs) {
		this.refSubs = refSubs;
	}

	public String getRefCat() {
		return refCat;
	}

	public void setRefCat(String refCat) {
		this.refCat = refCat;
	}

	public String getRefNuc() {
		return refNuc;
	}

	public void setRefNuc(String refNuc) {
		this.refNuc = refNuc;
	}

	public List<String> getReaction() {
		return reaction;
	}

	public void setReaction(List<String> reaction) {
		this.reaction = reaction;
	} 
}
