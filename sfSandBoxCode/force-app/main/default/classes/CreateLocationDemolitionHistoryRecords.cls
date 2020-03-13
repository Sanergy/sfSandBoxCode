public class CreateLocationDemolitionHistoryRecords{
    
    public static void createRecord(String event, String stage, String LD_ID){
        Location_Demolition_History_Record__c LDHR=new Location_Demolition_History_Record__c(
                                                                    Event__c=event,
                                                                    Location_Demolition__c=LD_ID,
                                                                    Stage__c=stage );
                                                                    
        insert LDHR;
    }
}