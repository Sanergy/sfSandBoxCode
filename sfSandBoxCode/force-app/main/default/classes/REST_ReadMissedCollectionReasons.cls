@RestResource(urlMapping='/read_missed_collection_reasons')
global with sharing class REST_ReadMissedCollectionReasons {
   
  @HttpPost
  global static List<dataHolder> getAll() {
      //list of DimensionHolder class
      List<dataHolder> DH=new List<dataHolder>();

   LIST<Missed_Collection_Reason__c> MCRs=[SELECT Id,Action_Taken__c,Data_Needed__c,Team_To_Investigate__c,Collect__c,Description__c,Code_Number__c,Name 
                                            FROM Missed_Collection_Reason__c
                                            WHERE isActive__c = true]; 

     
      
        for(Missed_Collection_Reason__c wca:MCRs){
            dataHolder newReason=new dataHolder();
            newReason.setId(wca.Id);
            newReason.setName(wca.Name);
            newReason.setMissedCollectionReason(wca.Description__c);
            newReason.setMissedCollectionCode(wca.Code_Number__c);
            newReason.setActionTaken(wca.Action_Taken__c);
            newReason.setDataNeeded(wca.Data_Needed__c);
            newReason.setCollection(wca.Collect__c);
            newReason.setTeamToInvestigate(wca.Team_To_Investigate__c);
                        
            DH.add(newReason);
        }
      return DH;
     }
    //utility class to help with serialization of JSON
          global class dataHolder{
                String Id;
                String name;
                String codeNumber;
                String description;
                String collection;
                String actionTaken;
                String dataNeeded;
                String teamToInvestigate;
               
                              
            
            public dataHolder(){
                Id='';
                name = '';
                codeNumber='';
                description='';
                collection='';
                dataNeeded='';
                actionTaken='';
                teamToInvestigate='';
                
                
           }
            
            public void setId(String Id){
                this.Id = Id;
            }
            public void setName(String Name){
                this.Name = Name;
            }
            public void setMissedCollectionCode(String codeNumber){
                this.codeNumber=codeNumber;
            }
            
            public void setMissedCollectionReason(String description){
                this.description = description;
            }
            public void setTeamToInvestigate(String teamToInvestigate){
                this.teamToInvestigate = teamToInvestigate;
            }
            public void setCollection(String collection){
                this.collection = collection;
            }
            public void setActionTaken(String actionTaken){
                this.actionTaken=actionTaken;
            }
            
            public void setDataNeeded(String dataNeeded){
                this.dataNeeded = dataNeeded;
            }  
           
            public String getId(){
                return this.Id;
            }
            public String getName(){
                return this.Name;
            }
            public String getMissedCollectionCode(){
                return this.codeNumber;
            }                         
            public String getMissedCollectionReason(){
                return this.description;
            }
             public String getTeamToInvestigate(){
                return this.teamToInvestigate;
            }
            public String getActionTaken(){
                return this.actionTaken;
            }
            public String getDataNeeded(){
                return this.dataNeeded;
            }                         
            public String getCollection(){
                return this.collection;
            }
          
      }
}