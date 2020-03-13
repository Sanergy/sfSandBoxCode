trigger CreateNewMaintenanceTaskTrigger on Asset_Maintenance_Task__c (before insert,before update) {
    //variable declarations
    Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
  /*  Asset_Maintenance_Task__c maintTask = new Asset_Maintenance_Task__c();
    Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
    
    //loop through tasks
    for(Asset_Maintenance_Task__c assetTask : Trigger.new){
        
        if(Trigger.isInsert ||Trigger.isUpdate){
            //check if status is complete
            System.debug('assetTask  ---> ' + assetTask);
            System.debug('assetTask.Status__c  : ' +assetTask.Status__c );
            System.debug('Maintenance_Type__c  : ' +assetTask.Maintenance_Type__c );
            if(assetTask.Status__c == 'Completed' && assetTask.Maintenance_Type__c != 'BM(Break Down Maintenance)'){
                
                //create a new Task
                maintTask.Maintenance_Type__c = assetTask.Maintenance_Type__c;
                maintTask.Asset_Maintenance_Schedule__c = assetTask.Asset_Maintenance_Schedule__c;
                maintTask.Unit_Description__c = assetTask.Unit_Description__c;
                maintTask.Proposed_Service_Date__c = assetTask.Next_Task_Proposed_Date__c;
                maintTask.Status__c = 'Open';
                maintTask.Proposed_Reading__c = assetTask.Proposed_Reading__c;
                maintTask.GLA__c = assetTask.GLA__c;
                maintTask.Procurement_Request__c = assetTask.Procurement_Request__c;
                maintTask.Inventory_Requisition__c = assetTask.Inventory_Requisition__c;
                maintTask.Assigned_To__c = assetTask.Assigned_To__c;
                maintTask.Notes__c = assetTask.Notes__c;
                
                //insert item
                INSERT maintTask;
                
                //check if Clone Service Items is selected
                //if selected then clone maintenance service items
                if(assetTask.Clone_Service_Items__c == true){
                    //clone service items
                    
                    List<Maintenance_Service_Items__c> servItem = [SELECT Name,Asset_Service_Item__c,Asset_Maintenance_Task__c,Specification__c,Cost_Price__c,
                                                                   Quantity__c,RecordType__c
                                                                   FROM Maintenance_Service_Items__c
                                                                   WHERE Asset_Maintenance_Task__c =: assetTask.Id];
                    System.debug('Serve Item ----> ' + servItem);
                    System.debug('assetTask.ID ---> ' + assetTask.Id);
                    
                    //loop through the list to inset the details in the object
                    if(servItem.size() > 0 && servItem != null ){
                        System.debug('Serve Item NOT EMPTY  ----> ' + servItem);
                        
                        //loop through
                        for(Maintenance_Service_Items__c serviceItems : servItem){
                            Maintenance_Service_Items__c items = new Maintenance_Service_Items__c();
                            items.Asset_Maintenance_Task__c = maintTask.Id;
                            items.Asset_Service_Item__c = serviceItems.Asset_Service_Item__c;
                            items.Specification__c = serviceItems.Specification__c;
                            items.Cost_Price__c = serviceItems.Cost_Price__c;
                            items.Quantity__c = serviceItems.Quantity__c;
                            items.RecordType__c = serviceItems.RecordType__c; 
                            
                            //insert 
                            INSERT items;
                        } 
                    }
                }               
                
            }
        }
    }
*/
}