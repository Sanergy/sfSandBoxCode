@RestResource(urlMapping='/write_collections')
global with sharing class REST_WriteCollections {
    //Incoming data from 
       global class fieldData{
        global String toilet;
        global String collection;
        global Date collectionDate;
        global Double solidWeight;
        global Double urineWeight;        
    }
    global class Response{
        String toilet;
        String collection;
        Date collectionDate;
        Double solidWeight;
        Double urineWeight;
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
                Waste_Collection_Schedule__c newWcs=new Waste_Collection_Schedule__c();
                
                newWcs.Toilet__c=data.toilet;
                newWcs.Collection__c=data.collection;
                newWcs.Collection_Date__c=data.collectionDate;
                newWcs.Solid_Waste_Weight__c=data.solidWeight;
                newWcs.Urine_Weight__c=data.urineWeight;
                insert newWcs;
                //Reponse to the fieldClient
                response.success=true;
                response.toilet=data.toilet;
                response.collection=data.collection;
                response.collectionDate=data.collectionDate;                
                response.solidWeight=data.solidWeight;
                response.urineWeight=data.urineWeight;
              
                
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