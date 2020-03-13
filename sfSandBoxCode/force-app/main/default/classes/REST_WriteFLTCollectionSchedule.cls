@RestResource(urlMapping='/write_flt_collection_schedule')
global with sharing class REST_WriteFLTCollectionSchedule {
      //Incoming data from 
       global class FieldData{
           global String guid;
           global Date scheduleDate;
           global String toiletId;
           global String missedCollectionId;
           global Double solidWeight;
           global Double urineWeight;
           global String scheduleStatus;
           global String route;
    }
    global class Response{
        String guid;
        Date scheduleDate;
        String toiletId;
        Double solidWeight;
        Double urineWeight;
        Boolean completed;
        String message;
    }
    //Write to the collections object
    @HttpPost
    global static List<Response> collectionData(List<FieldData> schedules){
        
        List<Response> responses = new List<Response>();
        
        if(schedules!=null && schedules.size() > 0){
            for(FieldData schedule: schedules){
                
                FLT_Collection_Schedule__c sched = null;
                
                if(schedule.guid != null){
                    sched=[SELECT Id,Toilet_Name__c,Route_Name__c,
                               Schedule_Status__c,Urine_Weight__c,
                               Solid_Waste_Weight__c,
                               Missed_Collection_Reason__c,Toilet__c,
                               Completed__c,Planned_Collection_Date__c
                           FROM FLT_Collection_Schedule__c
                           WHERE Id=:schedule.guid
                           AND Completed__c=false];
                    
                    sched.Solid_Waste_Weight__c = schedule.solidWeight;
                    sched.Urine_Weight__c = schedule.urineWeight;
                    sched.Missed_Collection_Reason__c = schedule.missedCollectionId;
                    sched.Schedule_Status__c = schedule.scheduleStatus;
                    
                    update sched;
                    
                } else {
                    sched = new FLT_Collection_Schedule__c();
                    
                    sched.Planned_Collection_Date__c = schedule.scheduleDate;
                    sched.Toilet__c = schedule.toiletId;
                    sched.Missed_Collection_Reason__c = schedule.missedCollectionId;
                    sched.Solid_Waste_Weight__c = schedule.solidWeight;
                    sched.Urine_Weight__c = schedule.urineWeight;
                    sched.Schedule_Status__c = schedule.scheduleStatus; 
                    sched.Completed__c = true;
                    
                    insert sched;
                }
                
                Response response = new Response();
                
                response.guid = sched.Id;
                response.toiletId = sched.Toilet_Name__c;
                response.scheduleDate = sched.Planned_Collection_Date__c; 
                response.solidWeight = sched.Solid_Waste_Weight__c;
                response.urineWeight = sched.Urine_Weight__c;
                response.completed = sched.Completed__c;
                
                responses.add(response);
            }
        }
        
        return responses;
    }
}