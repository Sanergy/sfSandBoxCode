trigger CreatePTSFromInventoryItemLocation on Inventory_Item_Location__c (before update) {
    
    for(Inventory_Item_Location__c itl: trigger.new){
    }
}