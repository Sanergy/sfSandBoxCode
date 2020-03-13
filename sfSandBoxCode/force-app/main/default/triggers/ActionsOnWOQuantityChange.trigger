trigger ActionsOnWOQuantityChange on Work_Order__c (after update) {
    
    Set<id> itemsChangedQuantities = new Set<id>();
    
    for(Work_Order__c wo: Trigger.new){        
        //Check if quantities change
        if(Trigger.oldMap.get(wo.id).Inventory_Item_Quantity__c != wo.Inventory_Item_Quantity__c){
            itemsChangedQuantities.add(wo.id);
        }
        
        //Check if status changed
        if(wo.Status__c == 'Cancelled'){
            itemsChangedQuantities.add(wo.id);
        }
    }
    
     if(itemsChangedQuantities.size() > 0){
    
         List<Inventory_Replenishment_Tracker__c> trackerList = new List<Inventory_Replenishment_Tracker__c>();
         
         List<Work_Order__c> wo = [SELECT Inventory_Item_Quantity__c, Status__c,
                                  (SELECT name, id, Quantity_Pending__c FROM Inventory_Replenishment_Trackers__r LIMIT 1) 
                                   FROM Work_Order__c 
                                   WHERE ID IN :itemsChangedQuantities];
                                         
       
        for(Work_Order__c w : wo){
            if(w.Inventory_Replenishment_Trackers__r != null && w.Inventory_Replenishment_Trackers__r.size() > 0){
                w.Inventory_Replenishment_Trackers__r.get(0).Quantity_Pending__c = w.Inventory_Item_Quantity__c;
           
               if(w.Status__c == 'Cancelled'){
                   w.Inventory_Replenishment_Trackers__r.get(0).Status__c='Cancelled';
               }
               
               trackerList.add(w.Inventory_Replenishment_Trackers__r.get(0));
            }
        } 
        
        if(trackerList.size() > 0){
            update trackerList; 
        } 
    }
       
}