trigger AccountsTrigger on Account (before insert, before Update) {
    /*For Each acc
    for(Account acc : Trigger.new){

        
        if(acc.Vendor_Status__c == 'Active'){
            
        List<Purchase_Order_Item__c> POILIST = [SELECT Id,Name,Company_Name__c,Inventory_Item__c,Inventory_UOM__c,Item_Description__c,
                                                Primary_Vendor__c,Purchase_UoM__c,Status__c,Requires_Contract__c,Item_Cost__c,
                                                Unit_Net_Price__c,Net_VAT__c,Vendor__c,Vendor_Type__c
                                                FROM Purchase_Order_Item__c 
                                                WHERE Vendor__c =: acc.Id
                                                AND Status__c != 'Active'
                                                AND Approved__c = true
                                               ];
            if(POILIST.size() > 0){
                for(Purchase_Order_Item__c poi:POILIST ) {
                  poi.Status__c = 'Active';  
                }
            }            
        }
        
        else  if(acc.Vendor_Status__c == 'Inactive'){
            
        List<Purchase_Order_Item__c> POILIST = [SELECT Id,Name,Company_Name__c,Inventory_Item__c,Inventory_UOM__c,Item_Description__c,
                                                Primary_Vendor__c,Purchase_UoM__c,Status__c,Requires_Contract__c,Item_Cost__c,
                                                Unit_Net_Price__c,Net_VAT__c,Vendor__c,Vendor_Type__c
                                                FROM Purchase_Order_Item__c 
                                                WHERE Vendor__c =: acc.Id
                                                AND Status__c = 'Active'
                                               ]; 
            
            if(POILIST.size() > 0){
                for(Purchase_Order_Item__c poi: POILIST){
                acc.addError('The Following PurchaseOrderItem(s) are  active for this Account.' 
                             + poi.Name + 'Kindly Deactivate the PurchaseOrderItem(s) before deactivating this account.'); 
                    
                }

            }            
            
        } 
        
    }*/
    
}