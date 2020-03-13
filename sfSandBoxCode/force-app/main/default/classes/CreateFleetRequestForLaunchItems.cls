public class CreateFleetRequestForLaunchItems{
  
    private ApexPages.StandardController standardController;
    public Fleet_Request__c fleet{ get; set;}
    public Fleet_Requests__c leg{ get; set;}
    Map<String,Sanergy_Settings_Fleet__c> settings;
    
    public CreateFleetRequestForLaunchItems(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        //Fleet information
        fleet=new Fleet_Request__c();
        
        //leg information
        leg=new Fleet_Requests__c();
        leg.Cargo_Details__c='Business in a Box Materials';
        
        settings=Sanergy_Settings_Fleet__c.getAll();
    }
    
    public PageReference createRequest() {
        //get opportunity
        Opportunity opp = (Opportunity) standardController.getRecord();
        
        //create fleet header
         fleet.Company__c=settings.get('launch').company__c;
         fleet.Reason_For_Trip__c='Delivery of FLT Launch Materials';
         fleet.Requesting_Department__c=settings.get('launch').Dimension_1_id__c;
         fleet.Status__c='Open';
         
         insert fleet;
         
        
        //create trip lep
        leg.Reason_for_Trip__c=fleet.Reason_For_Trip__c;
        leg.Fleet_Request_Status__c='Request Open';
        leg.Company__c=settings.get('launch').company__c;
        leg.Location_Dim_2__c=settings.get('launch').Dimension_2_id__c;
        leg.Dim_3__c=settings.get('launch').Dimension_3_id__c;
        leg.Grant_Funding_Availale_Dim_4__c=settings.get('launch').Dimension_4_id__c;
        leg.Pickup_Location__c='Mukuru';
        leg.Destination__c='Other';
        leg.Other_Destination__c=opp.Area__c+'-'+opp.Sub_Area_Lookup__r.name+' (Long:'+opp.GPS_Longitude__c+' Lat:'+opp.GPS_Latitude__c+')';
        leg.Cargo__c='Yes';
        leg.Driver_Required__c='Yes';
        leg.Fleet_Request__c=fleet.id;
        leg.Opportunity__c=opp.id;
        
        insert leg;
        
         return new PageReference('/' + fleet.Id);
    }
    
  
}