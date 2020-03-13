@RestResource(urlMapping='/items')
global with sharing class REST_Rootstock_Items {

  @HttpPost
  global static List<ItemHolder> getAllInventoryItems() {
     
      List<ItemHolder> IH=new List<ItemHolder>();

      List<rstk__icitem__c> InventoryItems = [SELECT ID, Name, rstk__icitem_descr__c, rstk__icitem_item__c,
                                                  rstk__icitem_div__c, rstk__icitem_div__r.Name
                                                  FROM rstk__icitem__c];  
                                               
     


        for(rstk__icitem__c rstkItems:InventoryItems){
            ItemHolder it_holder=new ItemHolder();
            
            it_holder.guid = rstkItems.ID;
            it_holder.name = rstkItems.Name;
            it_holder.description = rstkItems.rstk__icitem_descr__c;
            it_holder.itemNumber = rstkItems.rstk__icitem_item__c;
            it_holder.division = rstkItems.rstk__icitem_div__c;
            it_holder.divisionName = rstkItems.rstk__icitem_div__r.Name;
            
            IH.add(it_holder);
        }
       
        return IH;
     }
  
  
     global class ItemHolder{
        public String guid;
        public String name;
        public String description;
        public String itemNumber;
        public String division;
        public String divisionName;
      } 
}