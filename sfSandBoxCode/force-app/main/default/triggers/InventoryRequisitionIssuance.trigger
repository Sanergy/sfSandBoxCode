trigger InventoryRequisitionIssuance on Inventory_Requisition_Issuance__c (before insert) {
    //to avoid duplication of INVISSUE confirm that quantity remaining > 0
    for(Inventory_Requisition_Issuance__c issReq: Trigger.new){
        if(Trigger.isInsert){
            Inventory_Requisition_Item__c item = new Inventory_Requisition_Item__c();
            item = 
                [
                    SELECT Quantity_Remaining__c
                    FROM Inventory_Requisition_Item__c
                    WHERE id =: issReq.Inventory_Requisition_Item__c
                    LIMIT 1
                ];
            
            if(item != NULL){
                //record found, check if quantity to be issued will surpass the requested quantity
                if(issReq.Quantity__c > item.Quantity_Remaining__c){
                    issReq.Name.addError('Could not create the record. Issue Quantity (' + issReq.Quantity__c +') will surpass the Pending Requested Quantity (' + item.Quantity_Remaining__c + ')');
                }
            }else {
                issReq.Name.addError('Could not create the record. No Parent record found');
            }
        }
    }
}