trigger ActionsOnQuantityChange on PTS_Line_Item__c (after update) {
    
   /* 
    Set<id> itemsChangedQuantities = new Set<id>();
     
    for(PTS_Line_Item__c line : Trigger.new){        
        //Check if quantities change
        if(Trigger.oldMap.get(line.id).Quantity__c != line.Quantity__c || Trigger.oldMap.get(line.id).Qty_Delivered__c != line.Qty_Delivered__c){
            itemsChangedQuantities.add(line.id);
        }
        
        //Check if status changed
        if(line.Status__c == 'Cancelled'){
            itemsChangedQuantities.add(line.id);
        }
    }
    
    
    if(itemsChangedQuantities.size() > 0){
    
         List<Inventory_Replenishment_Tracker__c> trackerList = new List<Inventory_Replenishment_Tracker__c>();
         
         List<PTS_Line_Item__c> lines = [SELECT Quantity_Remaining__c, Status__c,UoM_conversion_factor__c,
                                         (SELECT name, id, Quantity_Pending__c FROM Inventory_Replenishment_Trackers__r LIMIT 1) 
                                         FROM PTS_Line_Item__c 
                                         WHERE ID IN :itemsChangedQuantities];
          

        for(PTS_Line_Item__c l : lines){
                        
            if(l.Inventory_Replenishment_Trackers__r != null && l.Inventory_Replenishment_Trackers__r.size() > 0){
                l.Inventory_Replenishment_Trackers__r.get(0).Quantity_Pending__c = l.Quantity_Remaining__c * l.UoM_conversion_factor__c;
           
               if(l.Status__c == 'Cancelled'){
                   l.Inventory_Replenishment_Trackers__r.get(0).Status__c='Cancelled';
               }               
               trackerList.add(l.Inventory_Replenishment_Trackers__r.get(0));
            }
        } 
        
        if(trackerList.size() > 0 ){
            update trackerList;
        }   
    }
  */ 
        
}