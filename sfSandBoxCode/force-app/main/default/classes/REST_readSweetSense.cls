@RestResource(urlMapping='/read_sweetSense')
global with sharing class REST_readSweetSense {
        

   @HttpGet
  global static List<dataHolder> getAll() {
      //list of DimensionHolder class
      List<dataHolder> DH=new List<dataHolder>();

   List<SweetSense_Sanergy_Int__c> swt=[SELECT Id,Card_Id__c,Status__c,Comments__c,Card_Type__c,Fill_Level__c,Id__c,timeStamp__c,Toilet_Id__c,Trigger_Type__c,Name 
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
            newSwt.setComments(dta.Comments__c);
            newSwt.setStatus(dta.Status__c);
            
            
            DH.add(newSwt);
        }
          
        //String jsonString=JSON.serialize(DH);
        //String jsonString=JSON.serialize(dimension2);
        
             return DH;
     }
    //utility class to help with serialization of JSON
          global class dataHolder{
            String name;
            String cardId;
        	String toiletId;
         	Decimal cardType;
            Decimal triggerType;
            Decimal fillLevel;
            Decimal timestamp;
            Decimal id;
            String Status;
            String Comments;
                   
            
            public dataHolder(){
                name = '';
                cardId='';
        	 	toiletId='';
         		cardType=0;
            	triggerType=0;
           	    fillLevel=0;
            	timestamp=0;
            	 id=0;
                status='';
                comments='';
            }
            
            public void setName(String name){
                this.name = name;
            }
            public void setCardID(String cardId){
                this.cardId = cardId;
            }
            public void setToiletID(String toiletId){
                this.toiletId = toiletId;
            }
            public void setCardType(Decimal cardType){
                this.cardType=cardType;
            }
            public void setTriggerType(Decimal triggerType){
                this.TriggerType=triggerType;
            }
            public void setFillLevel(Decimal fillLevel){
                this.fillLevel=fillLevel;
            }
            public void setid(Decimal id){
                this.id=id;
            }
             public void setStatus(String status){
                this.status=status;
            }
            public void setComments(String comments){
                this.comments=comments;
            }
            public String getName(){
                return this.name;
            }
            public String getCardID(){
                return this.cardID;
            }
            public String getToiletID(){
                return this.toiletId;
            }                         
            public Decimal getCardType(){
                return this.cardType;
            }
            public Decimal getTriggerType(){
                return this.triggerType;
            }
            public Decimal getFillLevel(){
                return this.fillLevel;
            }
              
      public void setTimestamp(Decimal timestamp){
                this.timestamp=timestamp;
      }
    
             public Decimal getTimestamp(){
                return this.timestamp;
            } 
             public Decimal getid(){
                return this.id;
            }
           public String getStatus(){
                return this.status;
            } 
             public String getComments(){
                return this.comments;
            }
              
      }
}