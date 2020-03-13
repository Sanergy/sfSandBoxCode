@RestResource(urlMapping='/write_weight_collections')
global with sharing class REST_WriteWeightCollections {
   
   
   
    //Incoming data from 
   global class FieldData{
        global String guid;
        global Date scheduleDate;
        global String toiletId;
        global String toiletName;
        global String missedCollectionId;
        global String missedCollectionExplanation;
        global Double solidWeight;
        global Double urineWeight;
        global String scheduleStatus;
        global String route;
        global Boolean completed;
        global String message;
        global Boolean success;       
    }
    
    global class Response{
        String message;
        Boolean success;
    }
    
    
    //Write to the collections object
    @HttpPost
    global static Response weightData(String jsonRequest){
        
        Response response = new Response();
        
        List<Waste_Collection_Schedule__c> wasteCollectionWeights = new List<Waste_Collection_Schedule__c>();
        
        try{
            List<FieldData> incomingData = (List<FieldData>)System.JSON.deserialize(jsonRequest, List<FieldData>.class);
            
            for(FieldData data : incomingData){
                //Data mapping goes here
                Waste_Collection_Schedule__c newWcs=new Waste_Collection_Schedule__c();
                
                newWcs.Toilet__c=data.toiletId;
                newWcs.Collection__c=data.scheduleStatus;
                newWcs.Collection_Date__c=data.scheduleDate;
                newWcs.Solid_Waste_Weight__c=data.solidWeight;
                newWcs.Urine_Weight__c=data.urineWeight;
                newWcs.Missed_Collection_Reason__c=data.missedCollectionId;
                newWcs.Missed_Collection_Explanation__c=data.missedCollectionExplanation;
                wasteCollectionWeights.add(newWcs); 
            }
            
            if(wasteCollectionWeights.size() > 0){
                insert wasteCollectionWeights;
                
                //Create Response
                response.success=true;
                response.message='success';
            }
            else{
                //Create Response
                response.success=false;
                response.message='Error: No record was saved';
            }
        }catch(Exception e){
            //Create Response
                response.success=false;
                response.message='Error: '+e.getMessage();
        }
        
        return response;
    }

}