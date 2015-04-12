@isTest
public class VFP_TestDataFactory {
    /**createTestRecords creates Competitor__c record with one linked Competitor_Details__c
     *produces : numCompetitorDetails/2 Competitor_Details__c in Bruxelles
     *produces : numCompetitorDetails/2 Competitor_Details__c in Antwerpen
     *produces : numCompetitorDetails/2 Competitor_Details__c in master segment <100
     *produces : numCompetitorDetails/2 Competitor_Details__c in master segment >100
     *produces : numCompetitorDetails/3 Competitor_Details__c with  product  SEP
     *produces : numCompetitorDetails/3 Competitor_Details__c with  product  SSS
     *produces : numCompetitorDetails/3 Competitor_Details__c with  product  Absenteism
    */ 
    public static void createTestRecords(Integer numCompetitor, Integer numCompetitorDetails) {
        Integer i; // common index
        List<Competitor__c> comps= new List<Competitor__c> ();
        
        // simples checks
        if (numCompetitor <1) {numCompetitor=1;}
        if (numCompetitorDetails <1 ) {numCompetitorDetails=1;}
        if (numCompetitor < numCompetitorDetails) {numCompetitor=numCompetitorDetails;}
        for ( i=0; i< numCompetitor;i++) {
            Competitor__c c=new Competitor__c(name='Test Competitor n°'+i);
            comps.add(c);
        }
        insert comps;
        
        List<Competitor_Details__c> compsdets = new List<Competitor_Details__c> ();
        for ( i=0; i< numCompetitorDetails;i++) {
            Competitor_Details__c cd=new Competitor_Details__c();
            cd.name='Test Competitor Details n°'+i;
            cd.country__c='Country n°'+i;
            cd.region__c=((math.mod(i,2)==0)?'Bruxelles':'Antwerpen');
            if (math.mod(i,3)==0) {
                cd.product__c='SSS';
            } else if (math.mod(i,3)==1) {
                cd.product__c='SEP';                
            } else {
                 cd.product__c='Absenteism';                               
            }            
            cd.master_segment__c=((math.mod(i,2)==0)?'<100':'>100');  
            cd.Competitor__c=comps[i].Id;
            compsdets.add(cd);
        } 
        insert compsdets;
    }
}