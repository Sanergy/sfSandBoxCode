@RestResource(urlMapping='/read_weight_collections')
global with sharing class REST_ReadWeightCollections{
    
    global class Response{
        String guid;
        Date scheduleDate;
        String toiletId;
        String toiletName;
        String missedCollectionId;
        Double solidWeight;
        Double urineWeight;
        String scheduleStatus;
        String route;
        String message;
        Boolean completed;
        Boolean success;
    }
    
    global class Request{
        public String routeNames;
    }
    
    @HttpPost     
    global static List<Response> collectionData(String routeNames){
    
        
        List<Response> responses = new List<Response>();
        try{ 
           
           String[] data = (String[]) System.JSON.deserialize(routeNames, String[].class);
           
           List<Toilet__c> participatingToilets =[SELECT id,name,Collection_Route__c 
                                               FROM Toilet__c
                                               WHERE Location__r.Add_on_Project__c= true
                                               AND Collection_Route__c IN :data
                                               AND Operational_Status__c = 'Open'];
            
            if(participatingToilets.size()>0){
                for(Toilet__c toilet : participatingToilets){
                    
                    Response response = new Response();
                    
                    response.toiletId = toilet.id;
                    response.route = toilet.Collection_Route__c;
                    response.toiletName = toilet.name;
                    response.success = true;
                    response.message = 'success';
                        
                    responses.add(response);
                }                     
                 
            }
            
        }catch(exception e){
           Response response = new Response();
            
            response.success = false;
            response.message = 'error: '+e.getMessage();
                
            responses.add(response);
        }        
        return responses;
    }
}