trigger AssetMaintenanceTaskTriggertrigger on Asset_Maintenance_Task__c (before insert,before Update,after Insert) {
    //variable declarations
    Asset_Maintenance_Task__c maintTask = new Asset_Maintenance_Task__c();
    Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
    List<Asset_Maintenance_Task__c> assetMaintTaskList; 
    List<Asset_Maintenance_Task__c> assetMaintTask = new List<Asset_Maintenance_Task__c>();
    List<Asset_Usage_Reading__c> usageLastReading; 
    List<Asset_Maintenance_Schedule__c> schedule;
    
    
    
    
    //loop through tasks
    for(Asset_Maintenance_Task__c assetTask : Trigger.new){
        
        /**Create new Maintenance Task When Task is Completed**/  
        
        assetMaintTaskList = [Select id, Name,Proposed_Service_Date__c,Next_Task_Proposed_Date__c,Status__c,Service_Date__c,Completion_Date__c,
                              Asset_Maintenance_Schedule__c,Sanergy_Asset__c,Next_Reading__c,Meter_Reading__c
                              FROM Asset_Maintenance_Task__c
                              WHERE Proposed_Service_Date__c  =: assetTask.Next_Task_Proposed_Date__c
                              AND Asset_Maintenance_Schedule__c =: assetTask.Asset_Maintenance_Schedule__c
                              AND Sanergy_Asset__c =: assetTask.Sanergy_Asset__c
                              AND Status__c = 'Open'
                              AND Name =: assetTask.Name
                             ];
        system.debug('assetMaintTaskList' + assetMaintTaskList);
        
        FFA_Config_Object__c id6820 =[SELECT id,Name 
                                      From FFA_Config_Object__c 
                                      WHERE Name = '6720 - Repair and Maintenance - Scheduled'
                                      LIMIT 1
                                     ];
        
        FFA_Config_Object__c id6821 =[SELECT id,Name 
                                      From FFA_Config_Object__c 
                                      WHERE Name =  '6721 - Repair & Maintenance - Unscheduled'
                                      LIMIT 1
                                     ];        
        
               system.debug('AAAAASSSSSSET' + assetTask.Sanergy_Asset__c);

        
        //Update the status After Firm and After Complete
        /*if(Trigger.isUpdate && Trigger.isBefore){
String serviceDate = String.valueOf(assetTask.Service_Date__c);
String completionDate = String.valueOf(assetTask.Completion_Date__c);
system.debug('serviceDate' + serviceDate);
system.debug('completionDate' + completionDate);
if((serviceDate != null || serviceDate != ' ') && (completionDate == null ||completionDate == ' ' )){
assetTask.Status__c = 'In Progress';   
system.debug('assetTaskStatus *****' + assetTask.Status__c);

}
else if(completionDate != null ||completionDate != ' ' ){
system.debug('completionDate2' + completionDate);
assetTask.Status__c = 'Completed';
system.debug('assetTaskStatus *****' + assetTask.Status__c);
}  

}
system.debug('assetTaskStatus ****++++++++++++++++' + assetTask.Status__c);
*/
        
        if(Trigger.isUpdate && Trigger.isBefore){
            //check if status is complete
            System.debug('assetTask  ---> ' + assetTask);
            System.debug('assetTask.Status__c  : ' +assetTask.Status__c );
            System.debug('Maintenance_Type__c  : ' +assetTask.Maintenance_Type__c );
            
            
            if(assetTask.Status__c == 'Completed' && assetTask.Maintenance_Type__c != 'BM(Break Down Maintenance)' && assetTask.CreateTask__c == True){
                
                if(assetMaintTaskList.size() == 0 ) {
                    //create a new Task
                    maintTask.Name = assetTask.Name;
                    maintTask.Maintenance_Type__c = assetTask.Maintenance_Type__c;
                    maintTask.Asset_Maintenance_Schedule__c = assetTask.Asset_Maintenance_Schedule__c;
                    maintTask.Unit_Description__c = assetTask.Unit_Description__c;
                    maintTask.Proposed_Service_Date__c = assetTask.Next_Task_Proposed_Date__c;
                    maintTask.Status__c = 'Open';
                    maintTask.Proposed_Reading__c = assetTask.Proposed_Reading__c;
                    maintTask.GLA__c = assetTask.GLA__c;
                    maintTask.Inventory_Requisition__c = assetTask.Inventory_Requisition__c;
                    maintTask.Assigned_To__c = assetTask.Assigned_To__c;
                    maintTask.Notes__c = assetTask.Notes__c;
                    maintTask.Sanergy_Asset__c = assetTask.Sanergy_Asset__c;
                    // maintTask.Unit_Description__c = 'test Description';
                    //insert item
                    INSERT maintTask;
                    
                    system.debug('New Maintenance Task ' + maintTask);
                    //check if Clone Service Items is selected
                    //if selected then clone maintenance service items
                    if(assetTask.Clone_Service_Items__c == true){
                        //clone service items
                        
                        List<Maintenance_Service_Items__c> servItem = [SELECT Name,Asset_Service_Item__c,Asset_Maintenance_Task__c,Specification__c,Cost_Price__c,
                                                                       Quantity__c,RecordType__c
                                                                       FROM Maintenance_Service_Items__c
                                                                       WHERE Asset_Maintenance_Task__c =: assetTask.Id];
                        System.debug('Serve Item ---> ' + servItem);
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
                                system.debug('New Maintenance Service Item' + items);
                            } 
                        }
                    }                  
                }
            }
        }
        /***********End Of Create Maintenance Task****************/
        
        
        
        /*************Update Sanergy Asset Next Task****************/
        if(Trigger.isInsert && Trigger.isBefore){
            assetTask.Status__c = 'Open';
            assetTask.Planned_Meter_Reading__c = assetTask.Next_Reading__c;	
            
               schedule = [SELECT Id,Employee__c,Sanergy_Asset__c,Maintenance_Type__c
                        FROM Asset_Maintenance_Schedule__c
                        WHERE Id =: assetTask.Asset_Maintenance_Schedule__c
                       ];
            
            if(schedule.size() > 0){
                assetTask.Assigned_To__c = schedule.get(0).Employee__c;
                assetTask.Sanergy_Asset__c = schedule.get(0).Sanergy_Asset__c;
                assetTask.Maintenance_Type__c = schedule.get(0).Maintenance_Type__c;
                
            }    
            
                        
            if(assetTask.Maintenance_Type__c == 'PM(Preventive Maintenance)' || assetTask.Maintenance_Type__c == 'AM(Autonomous Maintenance)'){
                assetTask.GLA__c = id6820.Id;
            }
            else if(assetTask.Maintenance_Type__c == 'BM(Break Down Maintenance)'){
                assetTask.GLA__c = id6821.Id;
            } 
            
        }
        

        
        if((Trigger.isUpdate && Trigger.isBefore)|| (Trigger.isInsert && Trigger.isAfter)){
                 Sanergy_Asset__c asset  = [SELECT id,Next_Asset_Maintenance_Task__c,Planned_Service_Date__c
                                   FROM Sanergy_Asset__c
                                   WHERE Id =: assetTask.Sanergy_Asset__c
                                  ];
        
        system.debug('Asset' + asset); 
            

            if(assetTask.Proposed_Service_Date__c != null ) {
                //query to get the nearest asset by date
                assetMaintTask = [SELECT Id, Name,Proposed_Service_Date__c,Status__c,Sanergy_Asset__c 
                                  FROM Asset_Maintenance_Task__c 
                                  WHERE Sanergy_Asset__c =: assetTask.Sanergy_Asset__c
                                  AND Status__c != 'Completed'
                                  ORDER BY Proposed_Service_Date__c DESC 
                                  LIMIT 1
                                 ];               
            }
            
            else if(assetTask.Perform_Task__c == true && assetTask.Proposed_Service_Date__c == null){
                assetMaintTask = [SELECT Id, Name,Proposed_Service_Date__c,Status__c,Sanergy_Asset__c 
                                  FROM Asset_Maintenance_Task__c 
                                  WHERE Sanergy_Asset__c =: assetTask.Sanergy_Asset__c
                                  AND Status__c != 'Completed'
                                  ORDER BY Proposed_Service_Date__c DESC 
                                  LIMIT 1
                                 ];                  
            }
            
            system.debug('Asset Maintenance Task' + assetMaintTask);
            
            //GET THE VALUE AND DATE TO UPDATE SANERGY ASSET
            if(assetMaintTask.size() > 0 && assetMaintTask != null ){
                
                
                if(asset != null) {
                    asset.Next_Asset_Maintenance_Task__c = assetMaintTask.get(0).Id;
                }
                system.debug('Sanergy Asset' + asset);
                //update sanergy asset object
                UPDATE asset;           
                system.debug('Sanergy Asset Updated' + asset);
                
            }           
            /**************End of Update Sanergy Asset Next Task**************/
            
            
            //Create asset usage reading if meter reading is more than the current Reading
            if(assetTask.Sanergy_Asset__c != null && assetTask.Status__c == 'In Progress' && assetTask.Meter_Reading__c != null){
                //check if there is an Asset Usage Reading that currently exists
                usageLastReading = [SELECT ID,Actual_Units__c,Current_Reading__c,Date__c,Sanergy_Asset__c
                                    FROM Asset_Usage_Reading__c
                                    WHERE Sanergy_Asset__c  =: assetTask.Sanergy_Asset__c
                                    ORDER BY Actual_Units__c DESC 
                                    LIMIT 1
                                   ];
                system.debug('usageLastReading222222222222223' + usageLastReading);
                //if it exists then check if the Task Reading is more than the current one
                if(usageLastReading.Size() > 0){
                    system.debug('Asset Task Meter Reading' + assetTask.Meter_Reading__c);
                    system.debug('usageLast Reading Units' + usageLastReading.get(0).Actual_Units__c );
                    
                    if(assetTask.Meter_Reading__c > usageLastReading.get(0).Actual_Units__c && assetTask.Meter_Reading__c != null){
                        usage.Date__c = assetTask.Service_Date__c;
                        usage.Actual_Units__c = assetTask.Meter_Reading__c;
                        usage.Sanergy_Asset__c = assetTask.Sanergy_Asset__c;
                        usage.Current_Reading__c = true;
                        usage.Source__c = 'Maintenance Task';
                        INSERT usage;
                        system.debug('Usage' + usage);
                    }  
                    //  usageLastReading.get(0).Current_Reading__c = false;
                    // update usageLastReading;
                }
                // if the Asset doesnt Have an existing Usage Reading Create One
                else{
                    usage.Date__c = assetTask.Service_Date__c;
                    usage.Actual_Units__c = assetTask.Meter_Reading__c;
                    usage.Sanergy_Asset__c = assetTask.Sanergy_Asset__c;
                    usage.Current_Reading__c = True;
                    INSERT usage;  
                }
                system.debug('UUUUUUUSSSSSAGE' + usage);
                
            }
            
            
            /**************Update Meter Reading Asset Maintenance Task***********/
            
            
            /******End Of Update Meter Reading Asset Maintenance Task***********/ 
            
            //Assign GLA Based on if the Maintenance Type is PM Or BM
           
            
            
        }
        
        
    }
    /***********End****************/
}