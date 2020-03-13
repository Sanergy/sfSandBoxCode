@RestResource(urlMapping='/sweet_sanergy')
global with sharing class REST_SweetSanergy {
    /*//Commented as we are no longer using this application - 2020-02-13
    //Incoming data from client
     global class clientRequest {
        public String CARDID;
        public String TOILETID;
        public Integer CARDTYPE;
        public Integer TRIGGERTYPE;
        public Integer FILLLEVEL;
        public Double TIMESTAMP;
        public Double ID;
         
     }
     
    //Response to the client
    global class Message {
        public String CardID;
        public String ToiletID;
        public Integer CardType;
        public Integer TriggerType;
        public Integer FillLevel;
        public Double timestamp;
        public Double id;
        public String message;
        public boolean success;
        
        
    }

  //Write to SweetSense_Sanergy_Int__c
  @HttpPost
   
   global static Message sweetData(String jsonRequest) {
      
      Message message = new Message();
      clientRequest  request = (	clientRequest) System.JSON.deserialize(jsonRequest, 	clientRequest.class);
                   if(request!=null){
                       try{
                       SweetSense_Sanergy_Int__c st=new SweetSense_Sanergy_Int__c();
                       st.Card_Id__c=request.CARDID;
                       st.Card_Type__c=request.CARDTYPE;
                       st.Fill_Level__c=request.FILLLEVEL;
                       st.Id__c=request.ID;
                       st.timeStamp__c=request.TIMESTAMP;
                       st.Toilet_Id__c=request.TOILETID;
                       st.Trigger_Type__c=request.TRIGGERTYPE;
                       insert st;
                       
                   
                    message.CardID=request.CARDID;
                    message.ToiletID=request.TOILETID;
                    message.CardType=request.CARDTYPE;
                    message.TriggerType=request.TRIGGERTYPE;
                    message.FillLevel=request.FILLLEVEL;
                    message.timestamp=request.TIMESTAMP;
                    message.id=request.ID;
                    message.success=true; 
                           
                  } Catch(exception e){
                   message.success=false;
                   message.message=e.getMessage();
               		}
               
                   }else{message.message='ERROR: Insert FAILED due to EMPTY REQUEST';
                        message.success=false;
                        }
        return message;
       
  	  }
      @HttpGet
  global static List<dataHolder> getAll() {
      //list of DimensionHolder class
      List<dataHolder> DH=new List<dataHolder>();

   List<SweetSense_Sanergy_Int__c> swt=[SELECT Id,Card_Id__c,Card_Type__c,Fill_Level__c,Id__c,timeStamp__c,Toilet_Id__c,Trigger_Type__c,Name 
                                            FROM SweetSense_Sanergy_Int__c]; 

     
      
        for(SweetSense_Sanergy_Int__c dta:swt){
            dataHolder newSwt=new dataHolder();
            newSwt.setName(dta.Name);
            newSwt.setCardID(dta.Card_Id__c);
            newSwt.setToiletID(dta.Toilet_Id__c);
            Decimal l;
            newSwt.setCardType(dta.Card_Type__c);
            newSwt.setTriggerType(dta.Trigger_Type__c);
            newSwt.setFillLevel(dta.Fill_Level__c);
            newSwt.setTimestamp(dta.timeStamp__c);
            newSwt.setid(dta.Id__c);
            
            
            DH.add(newSwt);
        }
          
        //String jsonString=JSON.serialize(DH);
        //String jsonString=JSON.serialize(dimension2);
        
             return DH;
     }
    //utility class to help with serialization of JSON
          global class dataHolder{
            String name;
            String CardID;
        	String ToiletID;
         	Decimal CardType;
            Decimal TriggerType;
            Decimal FillLevel;
            Decimal Timestamp;
            Decimal id;
                   
            
            public dataHolder(){
                name = '';
                CardID='';
        	 	ToiletID='';
         		CardType=0;
            	TriggerType=0;
           	    FillLevel=0;
            	Timestamp=0;
            	 id=0;
            }
            
            public void setName(String name){
                this.name = Name;
            }
            public void setCardID(String CardID){
                this.CardID = CardID;
            }
            public void setToiletID(String ToiletID){
                this.ToiletID = ToiletID;
            }
              public void setCardType(Decimal CardType){
                this.CardType=CardType;
            }
              public void setTriggerType(Decimal TriggerType){
                this.TriggerType=TriggerType;
            }
              public void setFillLevel(Decimal FillLevel){
                this.FillLevel=FillLevel;
            }
            
           
              public void setid(Decimal id){
                this.id=id;
            }
            
            public String getName(){
                return this.name;
            }
            public String getCardID(){
                return this.CardID;
            }
            public String getToiletID(){
                return this.ToiletID;
            }
                         
            public Decimal getCardType(){
                return this.CardType;
            }
              public Decimal getTriggerType(){
                return this.TriggerType;
            }
              public Decimal getFillLevel(){
                return this.FillLevel;
            }
    
      public void setTimestamp(Decimal Timestamp){
                this.Timestamp=Timestamp;
      }
    
             public Decimal getTimestamp(){
                return this.Timestamp;
            } 
               public Decimal getid(){
                return this.id;
            }
              
      }
*/
}