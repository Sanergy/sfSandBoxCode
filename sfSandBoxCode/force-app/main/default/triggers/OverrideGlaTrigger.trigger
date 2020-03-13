trigger OverrideGlaTrigger on PTS_Line_Item__c (before update) {
    for(PTS_Line_Item__c inv: Trigger.new){
       
            if(Trigger.IsBefore && Trigger.isUpdate){
                if(inv.Purchase_Order_Item__c != null ){
                    system.debug('Status' + inv.Status__c);
                    Purchase_Order_Item__c inventoryItem;
                    Inventory_Item__c commodityCode;
                    Group_Details__c Gla;
                    if (inv.Status__c  == 'Pending Purchase Order' || inv.Status__c  == 'Open'){
                        //get the inventory item from the purchase order Item
                        
                        inventoryItem = [SELECT id,Inventory_Item__c,Item_Cost__c	
                                         FROM Purchase_Order_Item__c
                                         WHERE Id =: inv.Purchase_Order_Item__c 
                                        ];
                        
                        system.debug('inventoryItem' + inventoryItem);
                        //Get the item group from the inventory Item
                        inv.POI_Unit_Price__c = inventoryItem.Item_Cost__c;
                    }
                    if(inventoryItem != null){
                        commodityCode = [SELECT Id,Item_Group__c
                                         FROM Inventory_Item__c
                                         WHERE Id =: inventoryItem.Inventory_Item__c
                                        ];
                        system.debug('commodityCode' + commodityCode);
                    } 
                    if(commodityCode != null){
                        //get the Gla from group details  
                        Gla = [SELECT Id, Inventory_Item_Group__c,Config_Account__c,Config_Account__r.Name
                               FROM Group_Details__c 
                               WHERE Inventory_Item_Group__c =: commodityCode.Item_Group__c
                               AND Credit_Debit__c = 'Debit'
                               AND Transaction_ID__c = 'PORCPT'
                              ]; 
                        system.debug('Gla' + Gla);
                    }  
                    if(Gla != null) {
                        inv.Commodity_Code_Gla__c = Gla.Config_Account__r.Name;
                        
                    }                    
                    
                }             
            }
        
        
    }
    
}