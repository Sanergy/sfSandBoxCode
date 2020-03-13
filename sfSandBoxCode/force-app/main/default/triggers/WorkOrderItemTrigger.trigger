trigger WorkOrderItemTrigger on Work_Order_Item__c (before insert,before update) {
    //For Each woi
    for(Work_Order_Item__c woi : Trigger.new){
        if(woi.BOM_Quantity__c == null){
            woi.addError('Kindly provide the BOI Quantity for this work order Item' + woi.Name);    
        } 
        
        else{
            List<Inventory_Item__c> invItem = [SELECT Id,Name,unit_cost__c
                                               FROM Inventory_Item__c
                                               WHERE Id =: woi.Inventory_Item__c
                                              ];
            
            if(invItem.size() > 0){
                woi.Unit_Cost__c = invItem.get(0).unit_cost__c;
                woi.Planned_Cost__c = woi.BOM_Quantity__c * invItem.get(0).unit_cost__c;
                woi.Planned_Material_Cost__c = woi.BOM_Quantity__c; 
            }
        }
    }
}