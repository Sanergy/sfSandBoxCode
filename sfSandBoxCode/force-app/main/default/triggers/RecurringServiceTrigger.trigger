trigger RecurringServiceTrigger on Recurring_Service__c (before insert, before update) { 
    
    for(Recurring_Service__c recurringService: Trigger.new){
        
        
        if(Trigger.isInsert || Trigger.oldMap.get(recurringService.Id).Maintenance_Department__c != recurringService.Maintenance_Department__c ||
           Trigger.oldMap.get(recurringService.Id).Requesting_Department__c != recurringService.Requesting_Department__c){
               
               List<FFA_Config_Object__c> requestingDepartment = [SELECT Id,Name,Teamlead__c
                                                                  FROM FFA_Config_Object__c
                                                                  WHERE Id =: recurringService.Requesting_Department__c 
                                                                  LIMIT 1];
               
               List<FFA_Config_Object__c> maintenanceDepartment = [SELECT Id,Name,Teamlead__c 
                                                                   FROM FFA_Config_Object__c 
                                                                   WHERE Id =: recurringService.Maintenance_Department__c 
                                                                   LIMIT 1];
               
               if(requestingDepartment.size() > 0){
                   recurringService.Requesting_Department_TL__c =  requestingDepartment.get(0).Teamlead__c;
               }// End if(requestingDepartment.size() > 0)
               
               if(maintenanceDepartment.size() > 0){
                   recurringService.Maintenance_Department_TL__c =  maintenanceDepartment.get(0).Teamlead__c;
               }// End if(maintenanceDepartment.size() > 0)
               
           }// End if(Trigger.isInsert || Trigger.oldMap.get(recurringService.Id).Maintenance_Department__c .....)
        
        //Check if Purchase_Order_Item_SLK__c != null or empty
        if(recurringService.Purchase_Order_Item_SLK__c != null && recurringService.SLK_percentage_value__c != null ){
            
            Purchase_Order_Item__c poItemSLK = [SELECT Id,Name,Vendor__c,Vatable__c,Unit_Net_Price__c,
                                                Contract_Number__c,VAT_Inclusive__c,VAT_Percentage__c,Item_Cost__c
                                                FROM Purchase_Order_Item__c
                                                WHERE Id =: recurringService.Purchase_Order_Item_SLK__c
                                                LIMIT 1];
            
            recurringService.SLK_Vendor_Contract__c = poItemSLK.Contract_Number__c;
            recurringService.Cost_Per_Unit__c = poItemSLK.Unit_Net_Price__c;
        }//End if(recurringService.Purchase_Order_Item_SLK__c != null || recurringService.Purchase_Order_Item_SLK__c != '')
        
        //Check if Purchase_Order_Item_FLI__c != null or empty
        if(recurringService.Purchase_Order_Item_FLI__c != null && recurringService.FLI_percentage_value__c != null){
            
            Purchase_Order_Item__c poItemFLI = [SELECT Id,Name,Vendor__c,Vatable__c,Unit_Net_Price__c,
                                                Contract_Number__c,VAT_Inclusive__c,VAT_Percentage__c,Item_Cost__c
                                                FROM Purchase_Order_Item__c
                                                WHERE Id =: recurringService.Purchase_Order_Item_FLI__c
                                                LIMIT 1];
            
            recurringService.FLI_Vendor_Contract__c = poItemFLI.Contract_Number__c;
            recurringService.Cost_Per_Unit__c = poItemFLI.Unit_Net_Price__c;    
        }//End if(recurringService.Purchase_Order_Item_FLI__c != null || recurringService.Purchase_Order_Item_FLI__c != '')        
        
    }//End for(Recurring_Service__c recurringService: Trigger.new)
    
}