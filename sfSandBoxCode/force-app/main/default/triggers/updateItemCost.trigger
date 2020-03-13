trigger updateItemCost on Case_Opportunity_Item__c (before insert, before update) {
    
    for(Case_Opportunity_Item__c  coi:Trigger.new){
            
        List<Inventory_Item__c> inventoryItem = [SELECT unit_cost__c
                                                 FROM Inventory_Item__c
                                                 WHERE id = :coi.Inventory_Item__c
                                                ];
        
        if(inventoryItem.size() > 0 && inventoryItem.get(0).unit_cost__c != null){
            coi.Cost__c = inventoryItem.get(0).unit_cost__c;
        } else{
            coi.Cost__c = 0;  
        }                                  
    }
}