@RestResource(urlMapping='/write_missed_collection_reasons')
global with sharing class REST_WriteMissedCollectionReasons {
	//Incoming data from 
       global class fieldData{
           
       global String codeNumber;
       global String collection;
       global String actionTaken;
       global String dataNeeded;
       global String teamToInvestigate;                     
    }
    global class Response{
        String codeNumber;
        String collection;
        String actionTaken;
        String dataNeeded;
        String teamToInvestigate;
        String message;
        Boolean success;
    }
    //Write to the collections object
    @HttpPost
    global static Response collectionData(String jsonRequest){
        Response response = new Response();
        fieldData data = (fieldData) System.JSON.deserialize(jsonRequest, fieldData.class);
        if(data!=null){
            try{
                //Data mapping goes here
                Missed_Collection_Reason__c newWcs=new Missed_Collection_Reason__c();
                
                 newWcs.Collect__c=data.collection;
           		 newWcs.Code_Number__c=data.codeNumber;
           		 newWcs.Action_Taken__c=data.actionTaken;
           		 newWcs.Data_Needed__c=data.dataNeeded;
           		 newWcs.Team_To_Investigate__c=data.teamToInvestigate;
                 
                insert newWcs;
                //Reponse to the fieldClient
                response.success=true;
                response.collection=data.collection;
                response.codeNumber=data.codeNumber;
                response.actionTaken=data.actionTaken;                
                response.dataNeeded=data.dataNeeded;
                response.teamToInvestigate=data.teamToInvestigate;
               
              
                
            }catch(exception e){
                response.success=false;
                response.message=e.getMessage();
            }
        }else{
            response.message='ERROR:Insert Failed Due To Empty Request';
            response.success=false;
        }return response;
    }
}