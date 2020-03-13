@isTest(seeAllData = true)
public class InventoryItemsReplenisherTest{
    
    public static TestMethod void InventoryItemsReplenisherTest(){
    
         List<Inventory_item__c> itemsBelowThreshold = [SELECT Planning_Policy__c
                                                        FROM Inventory_Item__c 
                                                        WHERE Requires_Replenishment__c = true];
                                                        
        for(Inventory_item__c items : itemsBelowThreshold ){
            items.Planning_Policy__c = 'No MRP Planning';
        }
        
        if(itemsBelowThreshold.size() > 0){
            update itemsBelowThreshold;
        }
                                                        
    
         List<Inventory_item__c> itemsToManufactore = [Select Id,Policy_Quantity__c,Reorder_Point__c,Minimum_Quantity__c,Item_Company__c,
                                                       Planning_Policy__c,Inventory_Stock__c,Pending_Replenishment_Quantity__c
                                                       FROM Inventory_item__c
                                                       WHERE Item_Group__c != null 
                                                       AND Has_BOM__c = true 
                                                       AND Item_Source__c = 'Manufactured'];
           
                                       
          if(itemsToManufactore.size() > 0){
              Inventory_item__c item = itemsToManufactore.get(0);
              
              item.Reorder_Point__c= item.Inventory_Stock__c + item.Pending_Replenishment_Quantity__c + 10;
              item.Policy_Quantity__c = 150;
              item.Planning_Policy__c = 'Reorder Point';
              
              update item;
          }
          
          List<Inventory_item__c> itemsToProcure = [Select Id,Policy_Quantity__c,Minimum_Quantity__c,Item_Company__c,
                                                    Planning_Policy__c,Inventory_Stock__c,Pending_Replenishment_Quantity__c
                                                    FROM Inventory_item__c
                                                    WHERE Item_Group__c != null  
                                                    AND Item_Source__c = 'Purchased'
                                                    AND ID IN (SELECT inventory_item__c FROM Purchase_Order_Item__c WHERE Vendor_Type__c = 'Primary')
                                                    LIMIT 1];
                                         
          if(itemsToProcure.size() > 0){
              Inventory_item__c item = itemsToProcure.get(0);
              
              item.Reorder_Point__c= item.Inventory_Stock__c + item.Pending_Replenishment_Quantity__c + 10;
              item.Policy_Quantity__c = 150;
              item.Planning_Policy__c = 'Reorder Point';
              
              update item;
          }
          
          //Replenish Inventory
          InventoryItemsReplenisherScheduler sc = new InventoryItemsReplenisherScheduler ();
         
         //Schedule
          InventoryItemsReplenisherScheduler.scheduleThis(null);
          sc.execute(null);
    }
}