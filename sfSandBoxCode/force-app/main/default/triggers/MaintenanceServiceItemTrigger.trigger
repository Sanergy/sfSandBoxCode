trigger MaintenanceServiceItemTrigger on Maintenance_Service_Items__c (before insert,before update) {
    
    Asset_Service_Item__c asset = new Asset_Service_Item__c();
    
    for(Maintenance_Service_Items__c maintainService : Trigger.New) {
        //on save or on update get the Asset Service Item
        //check if its null or not
        if(maintainService.Asset_Service_Item__c != null ){
            
            asset = [SELECT Purchase_Order_Item__c,Inventory_Item__c,Inventory_UoM__c,Vendor__c,
                     Unit_Item_Cost__c,Specifications__c,RecordType.Name
                     FROM Asset_Service_Item__c
                     WHERE ID =: maintainService.Asset_Service_Item__c
                    ];
            
            //autopopulate the fields
            maintainService.Purchase_Order_Item__c = asset.Purchase_Order_Item__c;
            maintainService.Inventory_Item__c = asset.Inventory_Item__c;
            maintainService.Inventory_UoM__c = asset.Inventory_Uom__c;
            maintainService.Unit_Item_Cost__c = asset.Unit_Item_Cost__c;
            maintainService.Vendor__c = asset.vendor__c;
            maintainService.RecordType__c = asset.RecordType.Name;
            
        }  
        
    } 
    
    
}