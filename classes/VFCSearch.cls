public class VFCSearch {
    private apexpages.standardController controller {get; set; }
    private Competitor_Details__c compDetail;
    private final static String QUOTE='\'';
    
    // Initialisation of multi-select picklist in page section criteria    
    // get region values
    public List<SelectOption> getRegions(){
        List<SelectOption> regions= new List<SelectOption>();
        
        Schema.DescribeFieldResult dfr = Competitor_Details__c.region__c.getDescribe();
        for (Schema.PicklistEntry ple : dfr.getPicklistValues()) {
         regions.add(new SelectOption(ple.getValue(),ple.getLabel(), !ple.isActive()));
        }     
        return regions;
    }
    
    // get products values
    public List<SelectOption> getProducts(){
        List<SelectOption> products= new List<SelectOption>();
        
        Schema.DescribeFieldResult dfr = Competitor_Details__c.product__c.getDescribe();
        for (Schema.PicklistEntry ple : dfr.getPicklistValues()) {
         products.add(new SelectOption(ple.getValue(),ple.getLabel(), !ple.isActive()));
        }     
        return Products;
    }
    
    // get segment values
    public List<SelectOption> getSegments(){
        List<SelectOption> segments= new List<SelectOption>();
        
        Schema.DescribeFieldResult dfr = Competitor_Details__c.master_segment__c.getDescribe();
        for (Schema.PicklistEntry ple : dfr.getPicklistValues()) {
         segments.add(new SelectOption(ple.getValue(),ple.getLabel(), !ple.isActive()));
        }     
        return segments;
    }
    
    // Search Criteria : region, product, segment
    public String qRegion {get;set;} 
    public String[] qProduct {get;set;}
    public String qSegment {get;set;} 
    
    // label to display the selected criterium
    
    public String qSelectedProducts {
        get {
            qSelectedProducts=getSelectedCriterium(qProduct,'');
            if (String.isBlank(qSelectedProducts) ) {
                qSelectedProducts=System.Label.VFP_SelectedNothing;
            }
            return qSelectedProducts;
        }
        set;
    }

    
    // search results
    public List<Competitor_Details__c> searchResults {get;set;}

    public VFCSearch(ApexPages.StandardController controller) {
        this.controller = controller;
        this.compDetail = (Competitor_Details__c) controller.getRecord();
        searchResults = new List<Competitor_Details__c> ();
        qRegion=System.label.VFP_SelectedNothing;
        qSegment=System.label.VFP_SelectedNothing;
        qProduct=new List<String> ();
    } 
    
	// Search Action
    public PageReference doSearch(){
		// results List exist it is initilalized in Constructor
        searchResults.clear();
        
        System.debug('qRegion :'+qRegion);
        System.debug('qProduct :'+qProduct);
        System.debug('qSegment :'+qSegment);
        String query='select Id,Name,Competitor__r.name,Region__c,Sub_region__c,Product__c,Master_Segment__c,Segment__c from Competitor_Details__c ';
        String critere1='';
        String critere2='';
        String critere3='';

        if ((String.isNotBlank(qRegion)) && (qRegion != System.label.VFP_SelectedNothing)) {
            critere1 = '(Region__c = ';
            critere1 = critere1 + QUOTE + qRegion + QUOTE;
            critere1 = critere1 + ') ';
        }
        
        if (qProduct.size() > 0) {
            critere2 = '(Product__c in ('; 
            critere2 = critere2 +getSelectedCriterium (qProduct, QUOTE);
            critere2 = critere2 +')) ';
        }
 
        if ((String.isNotBlank(qSegment)) && (qSegment != System.label.VFP_SelectedNothing)) {
            critere3 = '(Master_Segment__c = ';
            critere3 = critere3 + QUOTE + qSegment + QUOTE;
            critere3 = critere3 + ') ';
        }

        String[] criteria= new List<String>();
        if (String.isNotBlank(critere1)) criteria.add(critere1);
        if (String.isNotBlank(critere2)) criteria.add(critere2);
        if (String.isNotBlank(critere3)) criteria.add(critere3);
        
        if (criteria.size() > 0) {
	        query = query + 'where ';     
            if (criteria.size() == 1) {
                query = query + criteria[0];
            }
            else { /* at least 2 criteria */
                integer i=0;
                
                while (i < criteria.size()-1) {
                    query = query + criteria[i]+ 'AND ';
                    i++;
                }
                query = query + criteria[i];
            }
        }
        
        /*if (String.isNotBlank(critere1) || String.isNotBlank(critere2) || String.isNotBlank(critere3)) {
	        query = query + 'where ';     
        
            if (String.isNotBlank(critere1) ) {
                query = query + critere1;
                if (String.isNotBlank(critere2) || String.isNotBlank(critere3)) {
                    query = query + 'AND ';
                    if (String.isNotBlank(critere2)) {
                        query = query + critere2;
                        if (String.isNotBlank(critere3)) {
                        	query = query + 'AND ' + critere3;                            
                        }
                    } else {
                        query = query + critere3;
                    }                        
                } // else critere2 and critere3 are empty               
            } else { // critere1 is empty 
                    if (String.isNotBlank(critere2) ) {
                         query = query + critere2;
                         if (String.isNotBlank(critere3)) {
                        	query = query + 'AND ' + critere3;                            
                        }
                    } else { 
                         query = query + critere3;                    
                }                  
            }               
        }*/    

        query = query + ' ORDER by Competitor__r.name,Region__c LIMIT 40';
        system.debug('Query is: '+query);
		
        if (String.isNotBlank(qRegion) && String.isNotBlank(qSegment)) {
        searchResults=Database.query(query); 
        } else {
            if (String.isBlank(qRegion)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,System.Label.VFP_Err_NoRegion));
                qRegion=System.label.VFP_SelectedNothing;
            }
            if (String.isBlank(qSegment)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,System.Label.VFP_Err_NoSegment));
                qSegment=System.label.VFP_SelectedNothing;
            }
        }
        return null;
    }
    
    // helper function to produce a concatenated comma separated string of string from a list of strings
    // each element can be prefixed or postfixed by a string constant 
    // for exemple : getSelectedCriterium(["little","lazy","boy"]) returns "little, lazy, boy"
    //   if quoted by '\''    it returns "'little', 'lazy', 'boy'"
    // parameter strCriteria : List of Strings
    // parameter quote : pre and post fix
    private String getSelectedCriterium (List<String> strCriteria,String quotedby){
        String str='';
        Integer i=0;
        if ((strCriteria != null) && (strCriteria.size() > 0))  {
            while( i< (strCriteria.size()-1)) {
					str = str + quotedby + strCriteria[i] + quotedby + ', ';
                	i++;
            }
			str = str + quotedby + strCriteria[strCriteria.size()-1] +quotedby;
        }
        return str;
   }
}