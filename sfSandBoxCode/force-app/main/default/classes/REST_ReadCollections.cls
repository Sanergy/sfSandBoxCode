@RestResource(urlMapping='/read_collections')
global with sharing class REST_ReadCollections {
       @HttpGet
  global static List<dataHolder> getAll() {
      //list of DimensionHolder class
      List<dataHolder> DH=new List<dataHolder>();

   List<Waste_Collection_Schedule__c> WCS=[SELECT Id,Scheduled__c,Collection__c,Collection_Date__c,Solid_Waste_Weight__c,Toilet__c,Urine_Weight__c,Name 
                                            FROM Waste_Collection_Schedule__c]; 

     
      
        for(Waste_Collection_Schedule__c wca:WCS){
            dataHolder newCollection=new dataHolder();
            newCollection.setId(wca.Id);
            newCollection.setName(wca.Name);
            newCollection.setToilet(wca.Toilet__c);
            Decimal l;
            newCollection.setCollection(wca.Collection__c);
            newCollection.setCollectionDate(wca.Collection_Date__c);
            newCollection.setSolidWasteWeight(wca.Solid_Waste_Weight__c);
            newCollection.setUrineWeight(wca.Urine_Weight__c);
            newCollection.setScheduled(wca.Scheduled__c);
            
            DH.add(newCollection);
        }
      return DH;
     }
    //utility class to help with serialization of JSON
          global class dataHolder{
                String Id;
                String name;
                String toilet;
                String collection;
                Date collectionDate;
                Double solidWeight;
                Double urineWeight;
                Boolean scheduled;
                       
            
            public dataHolder(){
                Id='';
                name = '';
                toilet='';
        	 	collection='';
         		collectionDate=date.newInstance(0, 0, 0);
            	solidWeight=0;
           	    urineWeight=0;
                scheduled=false;
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
            public void setCollection(String collection){
                this.collection=collection;
            }
            public void setCollectionDate(Date collectionDate){
                this.collectionDate=collectionDate;
            }
            public void setSolidWasteWeight(Decimal solidWeight){
                this.solidWeight=solidWeight;
            }
            public void setUrineWeight(Decimal urineWeight){
                this.urineWeight=urineWeight;
            }
               public void setScheduled(Boolean scheduled){
                this.scheduled=scheduled;
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
            public String getCollection(){
                return this.collection;
            }
            public Date getCollectionDate(){
                return this.collectionDate;
            }
            public Decimal getSolidWasteWeight(){
                return this.solidWeight;
            }             
      
             public Decimal getUrineWeight(){
                return this.urineWeight;
            }
            public Boolean getScheduled(){
                return this.scheduled;
            }
      }


}