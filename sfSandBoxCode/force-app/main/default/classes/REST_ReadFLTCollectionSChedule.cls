@RestResource(urlMapping='/read_flt_collection_schedule')
global with sharing class REST_ReadFLTCollectionSChedule {
    //public Date scheduleDate;
    //Incoming data from android
       global class AndroidDate{
           global Date scheduleDate;  
       }
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
    
    @HttpPost 
    
    global static List<Response> collectionData(String jsonRequest){
        
        List<Response> responses = new List<Response>();
         AndroidDate data = (AndroidDate) System.JSON.deserialize(jsonRequest, AndroidDate.class);
        if(data!=null){
            try{
                LIST<FLT_Collection_Schedule__c> schedule=[SELECT Toilet_Name__c,Route_Name__c,Schedule_Status__c,Urine_Weight__c,Solid_Waste_Weight__c,Missed_Collection_Reason__c,Toilet__c,Completed__c,Planned_Collection_Date__c 
                                                           FROM FLT_Collection_Schedule__c
                                                          WHERE Planned_Collection_Date__c=:data.scheduleDate
                                                          AND Schedule_Status__c='Collect']; 
                if(schedule.size()>0){
                    for(FLT_Collection_Schedule__c sch:schedule){
                        
                        Response response = new Response();
                        
                        response.guid=sch.Id;
                        response.toiletId=sch.Toilet__c;
                        response.scheduleDate=sch.Planned_Collection_Date__c;
                        response.route=sch.Route_Name__c;                
                        response.solidWeight=sch.Solid_Waste_Weight__c;
                        response.urineWeight=sch.Urine_Weight__c;
                        response.scheduleStatus=sch.Schedule_Status__c;
                        response.completed=sch.Completed__c;
                        response.missedCollectionId=sch.Missed_Collection_Reason__c;
                        response.toiletName=sch.Toilet_Name__c;
                            
                        responses.add(response);
                    }                     
                     
                }
                
            }catch(exception e){
               
            }
            
        }
        
        return responses;
    }
/*      
  global static List<dataHolder> getAll() {
      //list of DimensionHolder class
      List<dataHolder> DH=new List<dataHolder>();
     // Date scheduleDate=date.newInstance(2016, 10, 13);

   List<FLT_Collection_Schedule__c> WCS=[SELECT Id,Completed__c,Planned_Collection_Date__c,Schedule_Status__c,Solid_Waste_Weight__c,Toilet__c,Urine_Weight__c,Route_Name__c,Name 
                                            FROM FLT_Collection_Schedule__c 
                                        WHERE Planned_Collection_Date__c=:scheduleDate]; 

   /*LIST<FLT_Collection_Schedule__c> schedule=[SELECT Completed__c,Planned_Collection_Date__c FROM FLT_Collection_Schedule__c
                                                     WHERE Planned_Collection_Date__c=:date.today()];*/
    //if(schedule.size()>0 && schedule.get(0).Completed__c==false){  
    /*  
        for(FLT_Collection_Schedule__c wca:WCS){
            dataHolder newCollection=new dataHolder();
            newCollection.setId(wca.Id);
            newCollection.setName(wca.Name);
            newCollection.setToilet(wca.Toilet__c);
            newCollection.setPlannedCollectionDate(wca.Planned_Collection_Date__c);
            newCollection.setSolidWasteWeight(wca.Solid_Waste_Weight__c);
            newCollection.setUrineWeight(wca.Urine_Weight__c);
            newCollection.setScheduleStatus(wca.Schedule_Status__c);
            newCollection.setRoute(wca.Route_Name__c);
            newCollection.setCompleted(wca.Completed__c);
            
            DH.add(newCollection);
        }
    //}
      return DH;
  }
    //utility class to help with serialization of JSON
 /*         global class dataHolder{
                String Id;
                String name;
                String toilet;
                String description;
                Date plannedCollectionDate;
                Double solidWeight;
                Double urineWeight;
                String scheduleStatus;
                String route;
                Boolean completed;       
            
            public dataHolder(){
                Id='';
                name = '';
                toilet='';
                description='';
                plannedCollectionDate=date.newInstance(0, 0, 0);
                solidWeight=0;
                urineWeight=0;
                scheduleStatus='';
                route='';
                completed=false;
            }
            
            public void setId(String Id){
                this.Id = Id;
            }
            public void setName(String Name){
                this.Name = Name;
            }
            public void setToilet(String toilet){
                this.toilet = toilet;
            }
            public void setMissedCollectionReason(String description){
                this.description=description;
            }
            public void setPlannedCollectionDate(Date plannedCollectionDate){
                this.plannedCollectionDate=plannedCollectionDate;
            }
            public void setSolidWasteWeight(Decimal solidWeight){
                this.solidWeight=solidWeight;
            }
            public void setUrineWeight(Decimal urineWeight){
                this.urineWeight=urineWeight;
            }
            public void setScheduleStatus(String scheduleStatus){
                this.scheduleStatus=scheduleStatus;
            }
            public void setRoute(String route){
                this.route=route;
            }
            public void setCompleted(Boolean completed){
                this.completed=completed;
            }
            public String getId(){
                return this.Id;
            }
            public String getName(){
                return this.Name;
            }
            public String getToilet(){
                return this.toilet;
            }                         
            public String getMissedCollectionReason(){
                return this.description;
            }
            public Date getPlannedCollectionDate(){
                return this.plannedCollectionDate;
            }
            public Decimal getSolidWasteWeight(){
                return this.solidWeight;
            }             
      
             public Decimal getUrineWeight(){
                return this.urineWeight;
            }
            public String getScheduleStatus(){
                return this.scheduleStatus;
            }
            public String getRoute(){
                return this.route;
            }
            public Boolean getCompleted(){
                return this.completed;
            }
      }
*/

}