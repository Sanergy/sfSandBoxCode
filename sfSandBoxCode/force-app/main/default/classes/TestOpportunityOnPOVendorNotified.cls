@isTest(seeAllData = true)
public class TestOpportunityOnPOVendorNotified{

    @isTest
    private static void testPoCreate() {
        
        Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
        String FlikDivision = settings.get('FLIK Division Id - rstk').Value__c;
        
        String FlikBuyer = settings.get('FLIK Sales Order Buyer').Value__c;
                        
        rstk__syusr__c user = [SELECT Id, rstk__syusr_respbuyerind__c, rstk__syusr_obsolete__c, rstk__syusr_employee__c FROM rstk__syusr__c WHERE Id = :FlikBuyer];
    
        if(user != null && user.rstk__syusr_respbuyerind__c && !user.rstk__syusr_obsolete__c){
    
            String sanergyVendor = settings.get('Sanergy Vendor Id').Value__c;
            String deptSops = settings.get('FLIK SOPS Department').Value__c;
            rstk__pohdr__c poHeader = new rstk__pohdr__c();
            
            poHeader.rstk__pohdr_buyusrno__c = user.Id;
            poHeader.rstk__pohdr_vendno__c = sanergyVendor;
            poHeader.rstk__pohdr_requestorg__c = deptSops;
            poHeader.rstk__pohdr_div__c = FlikDivision;
            
            insert poHeader;
        }
    }

}