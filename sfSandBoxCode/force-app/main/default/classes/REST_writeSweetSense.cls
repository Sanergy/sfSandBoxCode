@RestResource(urlMapping='/write_sweetSense')
global with sharing class REST_writeSweetSense {
    
    //Incoming data from client
     global class clientRequest {
        public String cardId;
        public String toiletId;
        public Integer cardType;
        public Integer triggerType;
        public Integer fillLevel;
        public Double timestamp;
        public Double id;
        public String status;
        public String comments;
         
     }
     
    //Response to the client
    global class Message {
        public String cardId;
        public String toiletId;
        public Integer cardType;
        public Integer triggerType;
        public Integer fillLevel;
        public Double timestamp;
        public Double id;
        public String message;
        public boolean success;
        public String status;
        public String comments;
        
        
    }

  //Write to SweetSense_Sanergy_Int__c
  @HttpPost
   
   global static Message sweetData(String jsonRequest) {
      
      Message message = new Message();
      clientRequest  request = (clientRequest) System.JSON.deserialize(jsonRequest,	clientRequest.class);
                   if(request!=null){
                       try{
                       SweetSense_Sanergy_Int__c st=new SweetSense_Sanergy_Int__c();
                       st.Card_Id__c=request.cardId;
                       st.Card_Type__c=request.cardType;
                       st.Fill_Level__c=request.fillLevel;
                       st.Id__c=request.id;
                           
                       st.Trigger_Type__c=request.triggerType;
                       st.timeStamp__c=request.timestamp;
                       st.Toilet_Id__c=request.toiletId;
                       st.Comments__c=request.comments;
                       st.Status__c=request.status;
                       insert st;
                       
                   
                    message.cardId=request.cardId;
                    message.toiletId=request.toiletId;
                    message.cardType=request.cardType;
                    message.triggerType=request.triggerType;
                    message.fillLevel=request.fillLevel;
                    message.timestamp=request.timestamp;
                    message.id=request.id;
                    message.success=true; 
                    message.status=request.status;       
                    message.comments=request.comments; 
                           
                  } Catch(exception e){
                   message.success=false;
                   message.message=e.getMessage();
                      system.debug('DEBUG'+e.getMessage());
               		}
               
                   }else{message.message='ERROR: Insert FAILED due to EMPTY REQUEST';
                        message.success=false;
                        }
        return message;
       
  	  }             
      
}