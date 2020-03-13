trigger SetQuoteInfoOnItemSelect on PTS_Line_Item__c (before insert, before update) {
    
     for(PTS_Line_Item__c item : Trigger.new){
         
         boolean updateItem = true;
         
         if(Trigger.isUpdate){
             for(PTS_Line_Item__c old: Trigger.old){
                 
                 if(item.Inventory_Item__c == old.Inventory_Item__c){
                     updateItem = false;
                 }
             }
         }
                  
         if(item.Inventory_Item__c != null && updateItem){
             
             List<Purchase_Order_Item__c> poItems = [SELECT Id, Name, Inventory_Item__c, Vendor__c,
                                                     Primary_Vendor__c
                                                     FROM Purchase_Order_Item__c
                                                     WHERE Inventory_Item__c = :item.Inventory_Item__c
                                                     AND Primary_Vendor__c = true
                                                    ];
             
             if(poItems != null && poItems.size() > 0){
                 
                 Purchase_Order_Item__c poItem = poItems.get(0);
                 
                 if(item.Purchase_Order_Item__c != null){
                     for(Purchase_Order_Item__c pitm :poItems){
                         if(pitm.Inventory_Item__c == item.Inventory_Item__c){
                             poItem = pitm;
                         }
                     }
                 }
                 
                 item.Vendor__c = poItem.Vendor__c;
                 item.Purchase_Order_Item__c = poItem.Id;
             } else {
                 item.Vendor__c = null;
                 item.Purchase_Order_Item__c = null;
             }
         }
     }
}