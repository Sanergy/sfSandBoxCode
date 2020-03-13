public class SyncCaseOppInventoryItems{

    public static void syncItems(){
       
        
        //create list of new Items to add
        List<Rootstock_Inventory_Item__c> oppItemsInsert=new List<Rootstock_Inventory_Item__c>();
        
        //get new inventory items
        List<rstk__icitem__c> newItems=[SELECT id FROM rstk__icitem__c WHERE ID NOT IN (SELECT Inventory_Item__c FROM Rootstock_Inventory_Item__c)];
        
        for(rstk__icitem__c newItem:newItems){
            Rootstock_Inventory_Item__c rItem=new Rootstock_Inventory_Item__c(
               Inventory_Item__c=newItem.id,
               isActive__c=true
            );
            
            oppItemsInsert.add(rItem);
        }
        
        
        
        //get items which have been deleted
        List<Rootstock_Inventory_Item__c> removedItems=[SELECT Inventory_Item__c, isActive__c FROM Rootstock_Inventory_Item__c
                                                       WHERE Inventory_Item__c NOT IN (SELECT ID FROM rstk__icitem__c)];
        for(Rootstock_Inventory_Item__c rItem:removedItems){
            rItem.isActive__c=false;
        }
        
        insert oppItemsInsert;
        update removedItems;
        
       // EmailSender email=new EmailSender(new String[]{'brian.onyando@saner.gy'}, 'Case opportunity Items Sync','Sync Successfull');
       //email.sendMessage();
            
            
    }
}