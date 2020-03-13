@RestResource(urlMapping='/write_android_users')
global with sharing class REST_WriteAndroidUsers {
    //Data from the Waste-collection app
    @TestVisible global class appData{
        @TestVisible String email;
        @TestVisible String token;
    }
    //Response to the app
    global class Response{
        String email;
        String token;
        String message;
        Boolean success;
    }
    //Writing to Adnroid_User object
    @HttpPost
    global static Response resp(String jsonRequest){
        //Instance of the response
   		 Response response=new Response();
        //Instance of addData class
        appData data=(appData)System.JSON.deserialize(jsonRequest, appData.class);
        if(data!=null){
            try{
                //Data mapping between Android-User object and the Waste-collection app
                Android_User__c newAndroid=new Android_User__c();
                newAndroid.Email__c=data.email;
                newAndroid.Token__c=data.token;
                
                //response to Waste-Collection app
                response.email=data.email;
                response.token=data.token;
                
            }catch(exception e){
                response.success=false;
                response.message=e.getMessage();
            }
        }else{
            response.message='Insert FAILED due to EMPTY REQUEST';
            response.success=false;
        }return response;
    }  
    
}