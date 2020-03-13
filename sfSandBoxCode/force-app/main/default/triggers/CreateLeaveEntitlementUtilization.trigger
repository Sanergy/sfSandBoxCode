trigger CreateLeaveEntitlementUtilization on Employee__c (after update) {
    
    //Leave Group
    public Leave_Group__c leaveGroup {get; set;}
    
    for(Employee__c e: Trigger.new){
        if(Trigger.isUpdate){
                    /*if(((Trigger.oldMap.get(e.Id).Leave_Group__c != null) && e.Leave_Group__c ==null) || (Trigger.oldMap.get(e.id).Leave_Group__c!= null && (e.Leave_Group__c != Trigger.oldMap.get(e.id).Leave_Group__c))){
        
        //Get the Leave Entitlement Utilizations
        List<Leave_Entitlement_Utilization__c> leaveUtilizations = [SELECT Id,Name,Leave_Entitlement_Type_Config__c,
        Employee__c,Total_No_of_Leave_Days__c
        FROM Leave_Entitlement_Utilization__c
        WHERE Employee__c =: e.Id];
        DELETE leaveUtilizations;
        
        //Get the Leave Accruals
        List<Leave_Accrual__c> leaveAccruals = [SELECT Id,Name,Leave_Entitlement_Utilization__c,
        Employee__c,Period__c,Days_Accrued__c,Days_Worked__c
        FROM Leave_Accrual__c
        WHERE Employee__c =: e.Id];
        DELETE leaveAccruals;
        
        //Get Employee Leave Requests
        List<Employee_Leave_Request__c> leaveRequests = [SELECT Id,Name,Leave_Entitlement_Utilization__c,
        Employee__c,Leave_Start_Date__c,Leave_End_Date__c,
        Employee_s_Department__c,Department_Team_Lead__c,
        Stage__c,No_Of_Approved_Leave_Days__c,
        No_Of_Leave_Days_Requested__c,Comments__c
        FROM Employee_Leave_Request__c
        WHERE Employee__c =: e.Id];
        DELETE leaveRequests;                
        
        }*/
            Integer currentyear = date.today().year();

            if(Trigger.oldMap.get(e.id).Leave_Group__c== null && e.Leave_Group__c !=null || (Trigger.oldMap.get(e.id).Leave_Group__c!= null && (e.Leave_Group__c != Trigger.oldMap.get(e.id).Leave_Group__c))){                
                //Get the Leave Group
                leaveGroup= [SELECT Id,Name,Leave_Group_Status__c,Leave_Group__c 
                             FROM Leave_Group__c
                             WHERE Id =: e.Leave_Group__c];
                List<Leave_Entitlement_Type_Config__c> leaveTypeConfigs;
                //Get the Leave Entitlement Type Configs
                if(e.Gender__c == 'Female'){
                    leaveTypeConfigs = [SELECT Id,Name,Leave_Group__c,Leave_Group__r.Name,
                                        Leave_Type__c,Year__c,Total_No_of_Leave_Days__c,
                                        Proratable__c,Display_to_User__c
                                        FROM Leave_Entitlement_Type_Config__c
                                        WHERE Leave_Group__c =: leaveGroup.Id
                                        AND Leave_Type__c != 'Paternity Leave'
                                        AND Year__c =: currentyear
                                        AND Display_to_User__c = true
                                        AND ID NOT IN (SELECT Leave_Entitlement_Type_Config__c FROM Leave_Entitlement_Utilization__c
                                                                                                       	WHERE Leave_Type__c != 'Paternity Leave'
                                                                                                       	AND Leave_Year__c =: currentyear
                                                                                                       	AND Leave_Entitlement_Type_Config__r.Leave_Group__c =: leaveGroup.Id
                                                       													AND Employee__c =: e.id
                                                                                                      )
                                       ];
                } 
                else if(e.Gender__c == 'Male'){
                    leaveTypeConfigs = [SELECT Id,Name,Leave_Group__c,Leave_Group__r.Name,
                                        Leave_Type__c,Year__c,Total_No_of_Leave_Days__c,
                                        Proratable__c,Display_to_User__c
                                        FROM Leave_Entitlement_Type_Config__c
                                        WHERE Leave_Group__c =: leaveGroup.Id
                                        AND Leave_Type__c != 'Maternity Leave'
                                        AND Year__c =: currentyear
                                        AND Display_to_User__c = true
                                        AND ID NOT IN (SELECT Leave_Entitlement_Type_Config__c FROM Leave_Entitlement_Utilization__c
                                                                                                       	WHERE Leave_Type__c != 'Paternity Leave'
                                                                                                       	AND Leave_Year__c =: currentyear
                                                                                                       	AND Leave_Entitlement_Type_Config__r.Leave_Group__c =: leaveGroup.Id
                                                       													AND Employee__c =: e.id
                                                                                                      )
                                       ];
                } 
                
                IF(leaveTypeConfigs != NULL){
                                for(Leave_Entitlement_Type_Config__c leaveTypeConfig : leaveTypeConfigs){
                    
                    //Create Leave Entitlement Utilizations for the Employee
                    Leave_Entitlement_Utilization__c leaveUtilization = new Leave_Entitlement_Utilization__c();
                    leaveUtilization.Leave_Entitlement_Type_Config__c = leaveTypeConfig.Id;
                    leaveUtilization.Employee__c = e.Id;
                    INSERT leaveUtilization;
                    
                    
                    //Create Leave Accrual
                    Leave_Accrual__c leaveAccrual = new Leave_Accrual__c();
                    //leaveAccrual.Name = leaveTypeConfig.Leave_Type__c;
                    leaveAccrual.Leave_Entitlement_Utilization__c = leaveUtilization.Id;
                    leaveAccrual.Employee__c = e.Id;
                    //leaveAccrual.Period__c = System.today().year() + ' - ' + System.today().month();
                    leaveAccrual.Period__c = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day()).format('yyyy-MM');
                    
                    if(leaveTypeConfig.Proratable__c==true){
                        leaveAccrual.Days_Accrued__c = 0.0;
                    }else{
                        leaveAccrual.Days_Accrued__c = leaveTypeConfig.Total_No_of_Leave_Days__c;
                    }                
                    //leaveAccrual.Days_Worked__c
                    INSERT leaveAccrual;
                }      
                }
              
            }  
        }       
    }
}