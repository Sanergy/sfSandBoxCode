@isTest(SeeAllData=true)
public class REST_FLTCollectionScheduleTest {
    static testMethod void testMissedCollectons() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/read_collections';
                
        System.RestContext.response = new RestResponse();
        
        List<String> items = new List<String>();
        List<REST_ReadMissedCollectionReasons.dataHolder> recs = REST_ReadMissedCollectionReasons.getAll();
           //to add code coverage, call the getters of the util class
        REST_ReadMissedCollectionReasons.dataHolder rrecs=new REST_ReadMissedCollectionReasons.dataHolder();
        
                 
          rrecs.getId();
          rrecs.getName();
          rrecs.getdataNeeded();
		  rrecs.getTeamToInvestigate();
          rrecs.getMissedCollectionCode();
          rrecs.getActionTaken();
          rrecs.getMissedCollectionReason();
          rrecs.getCollection();
    }
           
        static testMethod void testReadSchedules() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/inv_item_locations';
                
        System.RestContext.response = new RestResponse();
        
        List<String> items = new List<String>();
        List<FLT_Collection_Schedule__c> itms=[SELECT ID,Planned_Collection_Date__c 
                                    FROM FLT_Collection_Schedule__c WHERE Planned_Collection_Date__c!=null
                                    AND Id!=null   LIMIT 1];
                                    
        items.add(itms.get(0).Planned_Collection_Date__c.format());
                     
        REST_ReadFLTCollectionSChedule.AndroidDate andDate=new REST_ReadFLTCollectionSChedule.AndroidDate();
        andDate.scheduleDate=itms.get(0).Planned_Collection_Date__c;
            
        String dateString=System.JSON.serialize(andDate);
            
        List<REST_ReadFLTCollectionSChedule.Response> recs = REST_ReadFLTCollectionSChedule.collectionData(dateString);
            
        }
    static testMethod void testWriteMissedCollections(){
        //Write to REST_WriteCollections          
          
         REST_WriteMissedCollectionReasons.fieldData  adt = new  REST_WriteMissedCollectionReasons.fieldData();
        
            adt.collection='';
           	adt.codeNumber='';
            adt.actionTaken='';
           	adt.dataNeeded='';
           	adt.teamToInvestigate='';
            String s;           
            String jsonString=JSON.serialize(adt);
        	String jString=JSON.serialize(s);
                      
        REST_WriteMissedCollectionReasons wss=new REST_WriteMissedCollectionReasons();
        REST_WriteMissedCollectionReasons.Response resp=REST_WriteMissedCollectionReasons.collectionData(jsonString);
        REST_WriteMissedCollectionReasons.Response res=REST_WriteMissedCollectionReasons.collectionData(jString);
    }
    static testMethod void testWriteFLTSchedules(){
        //Write to REST_WriteCollections          
          
        /* REST_WriteFLTCollectionSchedule.FieldData  adt = new  REST_WriteFLTCollectionSchedule.FieldData();
                 
           adt.solidWeight=0;
           adt.urineWeight=0;        
             
            String jsonString=JSON.serialize(adt);*/
        
            List< REST_WriteFLTCollectionSchedule.FieldData> schedules = new List< REST_WriteFLTCollectionSchedule.FieldData>();
            
        	REST_WriteFLTCollectionSchedule.FieldData filedData=new REST_WriteFLTCollectionSchedule.FieldData();
        	LIST<FLT_Collection_Schedule__c> sched=[SELECT Id,Toilet_Name__c,Route_Name__c,Schedule_Status__c,Urine_Weight__c,Solid_Waste_Weight__c,Missed_Collection_Reason__c,Toilet__c,Completed__c,Planned_Collection_Date__c 
                                                           FROM FLT_Collection_Schedule__c
                                                          WHERE Id!=null  AND Completed__c=false
                                                   LIMIT 1];
        	filedData.guid=sched.get(0).Id;
        	filedData.solidWeight=0;
        	filedData.urineWeight=0;
        
        	schedules.add(filedData);
        
                	
        REST_WriteFLTCollectionSchedule wss=new REST_WriteFLTCollectionSchedule();
        List<REST_WriteFLTCollectionSchedule.Response> resp=REST_WriteFLTCollectionSchedule.collectionData(schedules);
       
    }
   
}