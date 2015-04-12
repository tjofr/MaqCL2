@isTest
public class VFCSearchTest {
    private static final Integer NUMCOMPDETAILS=12; 
    @testsetup static void setup() {
        // create common data
        VFP_TestDataFactory.createTestRecords(10,NUMCOMPDETAILS);
    }
    
    @isTest public static void testVFCSearch0(){
       // get an object
       Competitor_Details__c cd = [SELECT Id FROM Competitor_Details__c LIMIT 1];

       // set the page
       Test.setCurrentPage(Page.VFPCompetitorDetails);

       //  I got an object now I get the standard controller
       ApexPages.StandardController stdCompDetCtrl=new ApexPages.StandardController(cd);
       system.assert(stdCompDetCtrl != null); // controller has successfully been created 
	        
       // Instantiate a new controller 
       VFCSearch controller = new VFCSearch(stdCompDetCtrl); 

       // test picklists
       List <SelectOption> regions=controller.getRegions(); 
	   System.assert(regions.size()>0,'Is Regions Picklist initialized ?');        	
       List <SelectOption> products=controller.getProducts(); 
	   System.assert(products.size()>0,'Is Products Picklist initialized ?');        	
       List <SelectOption> segments=controller.getSegments(); 
	   System.assert(segments.size()>0,'Is Segments Picklist initialized ?');
       
        // test selection of products

		// launch the action
        PageReference nextPage = controller.doSearch();        
        System.assert ((controller.qSelectedProducts==System.Label.VFP_SelectedNothing),'Is Products picklist selection OK ');

        controller.qProduct.add('SSS');
        controller.qProduct.add('SEP');
        nextPage = controller.doSearch();        
        System.assert ((controller.qSelectedProducts!=System.Label.VFP_SelectedNothing),'Is Products picklist really selection OK ');               
    }

    @isTest public static void testVFCSearch1(){
       // get an object
       Competitor_Details__c cd = [SELECT Id FROM Competitor_Details__c LIMIT 1];

       // set the page
       Test.setCurrentPage(Page.VFPCompetitorDetails);

       //  I got an object now I get the standard controller
       ApexPages.StandardController stdCompDetCtrl=new ApexPages.StandardController(cd);
       system.assert(stdCompDetCtrl != null); // controller has successfully been created 
	        
       // Instantiate a new controller 
       VFCSearch controller = new VFCSearch(stdCompDetCtrl); 
		// no parameters in the page
		// launch the action
        PageReference nextPage = controller.doSearch();
        
		System.debug('Num results '+controller.searchResults.size());
        // default behaviour is no filter
		System.assertEquals(NUMCOMPDETAILS, controller.searchResults.size());        
    }
    
    @isTest public static void testVFCSearch2(){
       // get an object
       Competitor_Details__c cd = [SELECT Id FROM Competitor_Details__c LIMIT 1];

       // set the page
       Test.setCurrentPage(Page.VFPCompetitorDetails);

       //  I got an object now I get the standard controller
       ApexPages.StandardController stdCompDetCtrl=new ApexPages.StandardController(cd);
       system.assert(stdCompDetCtrl != null); // controller has successfully been created 
	        
       // Instantiate a new controller 
       VFCSearch controller = new VFCSearch(stdCompDetCtrl); 
		//  parameters in the page
		controller.qRegion='Bruxelles';
        controller.qSegment='<100';
        
		// launch the action
        PageReference nextPage = controller.doSearch();
        
		System.debug('Num results '+controller.searchResults.size());
		System.assertEquals(NUMCOMPDETAILS/2, controller.searchResults.size());        
    }
    
    @isTest public static void testVFCSearch3(){
       // get an object
       Competitor_Details__c cd = [SELECT Id FROM Competitor_Details__c LIMIT 1];

       // set the page
       Test.setCurrentPage(Page.VFPCompetitorDetails);

       //  I got an object now I get the standard controller
       ApexPages.StandardController stdCompDetCtrl=new ApexPages.StandardController(cd);
       system.assert(stdCompDetCtrl != null); // controller has successfully been created 
	        
       // Instantiate a new controller 
       VFCSearch controller = new VFCSearch(stdCompDetCtrl); 
		//  parameters in the page
		controller.qRegion='Bruxelles';
        controller.qSegment='<100';
        controller.qProduct.add('SSS');
        controller.qProduct.add('SEP');
        
		// launch the action
        PageReference nextPage = controller.doSearch();
        
		System.debug('Num results '+controller.searchResults.size());
		System.assertEquals(NUMCOMPDETAILS/3, controller.searchResults.size());        
    }
    
    @isTest public static void testVFCSearch4(){
       // get an object
       Competitor_Details__c cd = [SELECT Id FROM Competitor_Details__c LIMIT 1];

       // set the page
       Test.setCurrentPage(Page.VFPCompetitorDetails);

       //  I got an object now I get the standard controller
       ApexPages.StandardController stdCompDetCtrl=new ApexPages.StandardController(cd);
       system.assert(stdCompDetCtrl != null); // controller has successfully been created 
	        
       // Instantiate a new controller 
       VFCSearch controller = new VFCSearch(stdCompDetCtrl); 
		//  parameters in the page
		controller.qRegion='Bruxelles';
        
		// launch the action
        PageReference nextPage = controller.doSearch();
        
		System.debug('Num results '+controller.searchResults.size());
		System.assertEquals(NUMCOMPDETAILS/2, controller.searchResults.size());        
    }
    
}