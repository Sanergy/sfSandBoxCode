trigger AssetServiceItemTrigger on Asset_Service_Item__c (before insert,before update) {
    
    Purchase_Order_Item__c assetServe = new Purchase_Order_Item__c();
    
    for(Asset_Service_Item__c assetService : Trigger.New){
        //System.debug('assetService.Purchase_Order_Item__c  -->' + assetService.Purchase_Order_Item__c );
        
        //soql query to get the po details
        assetServe = [SELECT Inventory_Item__c,Inventory_UOM__c,Inventory_Item__r.Inventory_UoM__c, Vendor__c,Item_Cost__c
                      FROM Purchase_Order_Item__c
                      WHERE Id =: assetService.Purchase_Order_Item__c 
                     ];
        
        //System.debug('assetServe >> ' + assetServe);
        
        //Update fields on save
        assetService.Inventory_Item__c = assetServe.Inventory_Item__c;
        assetService.Inventory_Uom__c = assetServe.Inventory_Item__r.Inventory_UoM__c;
        assetService.vendor__c = assetServe.Vendor__c;
        assetService.Unit_Item_Cost__c = assetServe.Item_Cost__c; 
        
    }    
}