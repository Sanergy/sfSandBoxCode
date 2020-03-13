@RestResource(urlMapping='/dimensions')
global with sharing class REST_Dimensions {
          

  //get all the dimensions 
  @HttpPost
  global static List<DimensionHolder> getAllDimensions() {
      //list of DimensionHolder class
      List<DimensionHolder> DH=new List<DimensionHolder>();

      List<c2g__codaDimension1__c> dimension1=[SELECT ID, Name, Dimension_1_Description__c
                                               FROM c2g__codaDimension1__c];  
                                               
      List<c2g__codaDimension2__c> dimension2=[SELECT ID, Name, Dimension_2_Description__c
                                               FROM c2g__codaDimension2__c]; 
      
      List<c2g__codaDimension3__c> dimension3=[SELECT ID, Name, Dimension_3_Description__c
                                               FROM c2g__codaDimension3__c]; 
                                               
      List<c2g__codaDimension4__c> dimension4=[SELECT ID, Name, Dimension_4_Description__c
                                               FROM c2g__codaDimension4__c]; 


        for(c2g__codaDimension1__c cgDim1:dimension1){
            DimensionHolder dh_holder=new DimensionHolder();
            dh_holder.setName(cgDim1.Name);
            dh_holder.setDescription(cgDim1.Dimension_1_Description__c);
            dh_holder.setGuid(cgDim1.ID);
            dh_holder.setDimension(1);
            
            DH.add(dh_holder);
        }
        for(c2g__codaDimension2__c cgDim2:dimension2){
            DimensionHolder dh_holder=new DimensionHolder();
            dh_holder.setName(cgDim2.Name);
            dh_holder.setDescription(cgDim2.Dimension_2_Description__c);
            dh_holder.setGuid(cgDim2.ID);
            dh_holder.setDimension(2);
            
            DH.add(dh_holder);
        }
        for(c2g__codaDimension3__c cgDim3:dimension3){
            DimensionHolder dh_holder=new DimensionHolder();
            dh_holder.setName(cgDim3.Name);
            dh_holder.setDescription(cgDim3.Dimension_3_Description__c);
            dh_holder.setGuid(cgDim3.ID);
            dh_holder.setDimension(3);
            
            DH.add(dh_holder);
        }
        for(c2g__codaDimension4__c cgDim4:dimension4){
            DimensionHolder dh_holder=new DimensionHolder();
            dh_holder.setName(cgDim4.Name);
            dh_holder.setDescription(cgDim4.Dimension_4_Description__c);
            dh_holder.setGuid(cgDim4.ID);
            dh_holder.setDimension(4);
            
            DH.add(dh_holder);
        }
          
        //String jsonString=JSON.serialize(DH);
        //String jsonString=JSON.serialize(dimension2);
        
             return DH;
     }
  
  
  //utility class to help with serialization of JSON
          global class DimensionHolder{
            String name;
            String description;
            String guid;
            Integer dimension;
            
            public DimensionHolder(){
                name = '';
                description = '';
                guid = '';
                dimension = 0;
            }
            
            public void setName(String name){
                this.name = Name;
            }
            public void setDescription(String description){
                this.description = description;
            }
            public void setGuid(String guid){
                this.guid = guid;
            }
            
            public String getName(){
                return this.name;
            }
            public String getDescription(){
                return this.description;
            }
            public String getGuid(){
                return this.guid;
            }
             public void setDimension(Integer dimension){
                this.dimension=dimension;
            }
            
            public Integer getDimension(){
                return this.dimension;
            }
            
        } 
}