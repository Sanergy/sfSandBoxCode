public class CreateOpportunityHistoryRecords{
 
  //function to create new Opportunity History Records
  public static void createRecord(String Opportunity, String Recordtype, String Event){
  
  
  Opportunity_History_Records__c OHR=new Opportunity_History_Records__c(
                                                                         Date__c=Datetime.now(),
                                                                         Event__c=Event,
                                                                         Opportunity__c=Opportunity,
                                                                         Record_Type__c=Recordtype
                                                                            );
                                                                            
     insert OHR;
  
  }
 }