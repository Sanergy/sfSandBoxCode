public class CreateFleetRequestForFarmstarDelivery{
  
    private ApexPages.StandardController standardController;
    public Fleet_Request__c fleet{ get; set;}
    public Fleet_Requests__c leg{ get; set;}
    Map<String,Sanergy_Settings_Fleet__c> settings;
    
    public CreateFleetRequestForFarmstarDelivery(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        //Fleet information
        fleet=new Fleet_Request__c();
        fleet.reason_for_Trip__c='Delivery of Evergrow fertilizer';
        
        //leg information
        leg=new Fleet_Requests__c();
        leg.Cargo_Details__c='Evergrow Fertilizer';
        
        settings=Sanergy_Settings_Fleet__c.getAll();
    }
    
    public PageReference createRequest() {
        //get opportunity
        Opportunity opp = (Opportunity) standardController.getRecord();
        
        //create fleet header
         fleet.Company__c=settings.get('farmstar').company__c;
         fleet.Requesting_Department__c=settings.get('farmstar').Dimension_1_id__c;
         fleet.Status__c='Open';
         
         
         insert fleet;
         
        
        //create trip lep
        leg.Reason_for_Trip__c=fleet.Reason_For_Trip__c;
        leg.Fleet_Request_Status__c='Request Open';
        leg.Company__c=settings.get('farmstar').company__c;
        leg.Location_Dim_2__c=settings.get('farmstar').Dimension_2_id__c;
        leg.Dim_3__c=settings.get('farmstar').Dimension_3_id__c;
        leg.Grant_Funding_Availale_Dim_4__c=settings.get('farmstar').Dimension_4_id__c;
        leg.Cargo__c='Yes';
        leg.Fleet_Request__c=fleet.id;
        leg.Opportunity__c=opp.id;
        
        insert leg;
        
         return new PageReference('/' + fleet.Id);
    }
    
  
}