trigger CreateEmployeeStatusTrigger on Employee_Status__c (after update, before insert, before update, before delete) {
    
    if(Trigger.isDelete && Trigger.isBefore){
        for(Employee_Status__c employeeStatus : Trigger.Old){
            if(employeeStatus.Status__c == 'Approved'){
                employeeStatus.AddError('You are not allowed to delete this record');  
            }
        } 
    }
    
    else{ 
        
        for(Employee_Status__c employeeStatus : Trigger.New ){
            
            List<Staff_Allowances__c> allowance;
            
            if(Trigger.isInsert && Trigger.isBefore){
                system.debug('STatus' + employeeStatus.Employment_Status__c);
                system.debug('end Date'+ employeeStatus.Expected_End_Date__c);
                AggregateResult [] UnApproved = [SELECT COUNT(Id)
                                                 FROM Employee_Status__c
                                                 WHERE Employee__c =: employeeStatus.Employee__c
                                                 AND Status__c != 'Approved'
                                                ];  
                if(UnApproved.size() > 1 ){
                    employeeStatus.AddError('There is an existing status that is yet to be approved');   
                }
                
            }
            
            if ((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore)) {
                
                Employee_Role__c role = [SELECT ID,Talent_Partner__c,Talent_Partner_SF_Account__c,Team_Lead__c,
                                         Team_Lead_SF_Account__c,Line_Manager__c,Line_Manager_SF_Account__c,Department__c,
                                         Sanergy_Department_Unit__c,Has_Groupings__c
                                         FROM Employee_Role__c
                                         WHERE id =: employeeStatus.Employee_Role__c                                                                               
                                        ];
                
                system.debug('Role' + role);
                if(role != null){
                    employeeStatus.Talent_Partner__c = role.Talent_Partner__c;
                    employeeStatus.Talent_Partner_SF_Account__c = role.Talent_Partner_SF_Account__c;
                    employeeStatus.Team_Lead__c = role.Team_Lead__c;
                    employeeStatus.Team_Lead_SF_Account__c = role.Team_Lead_SF_Account__c; 
                    employeeStatus.Sanergy_Department__c = role.Department__c;
                    employeeStatus.Sanergy_Department_Unit__c = role.Sanergy_Department_Unit__c;
                    
                    //check if the Role selected has a group
                    //If it has grouping check if the group has been provided check if the group exists
                    if(role.Has_Groupings__c == true && employeeStatus.Employee_Role_Grouping__c != null){
                        
                        List<Employee_Role_Groupings__c> grouping =[SELECT id,Name,Line_Manager__c,Line_Manager_SF_Account__c
                                                                    FROM Employee_Role_Groupings__c
                                                                    WHERE ID =:employeeStatus.Employee_Role_Grouping__c
                                                                   ];
                        //if the group exists and the line manager has been provided then add that as the Line Manager
                        if(grouping.size() > 0){
                            If(grouping.get(0).Line_Manager__c  != null){
                                employeeStatus.Line_Manager__c = grouping.get(0).Line_Manager__c;
                                employeeStatus.Line_Manager_SF_Account__c = grouping.get(0).Line_Manager_SF_Account__c;    
                            }
                            // if the line manager has not been provided then take the name of the Role line Manager
                            else{
                          employeeStatus.Line_Manager__c = role.Line_Manager__c;
                        employeeStatus.Line_Manager_SF_Account__c = role.Line_Manager_SF_Account__c;    
                            }
                        }
                        //if the group doesnt exist then take the name of the Role line Manager
                        else{
                        employeeStatus.Line_Manager__c = role.Line_Manager__c;
                        employeeStatus.Line_Manager_SF_Account__c = role.Line_Manager_SF_Account__c;   
                        }
                    }
                    //If the role doesn't have a grouping then take tha Role Line Manager
                    else{
                        employeeStatus.Line_Manager__c = role.Line_Manager__c;
                        employeeStatus.Line_Manager_SF_Account__c = role.Line_Manager_SF_Account__c;            
                    }
                }
                
                if(employeeStatus.Status__c == 'Approved' && employeeStatus.Current_Status__c == true){
                    //query to get the last job status
                    List<Employee_Status__c> emState = [SELECT id,Name,Date_To__c,Effective_Date__c,Previous_Employee_Status__c
                                                        FROM Employee_Status__c 
                                                        WHERE Employee__c =: employeeStatus.Employee__c 
                                                        AND Current_Status__c = true
                                                        AND ID !=: employeeStatus.id 
                                                        ORDER BY Effective_Date__c DESC
                                                        LIMIT 1
                                                       ];
                    
                    System.debug('State of the em :'+ emState);
                    
                    // give it the end date
                    if(emState.size() > 0 ){
                        emState.get(0).Date_To__c = employeeStatus.Effective_Date__c;
                        emState.get(0).Current_Status__c = false;
                        update emState;
                        
                    }
                    
                }
                
                if(employeeStatus.Employment_Status__c == 'Terminated' && ((employeeStatus.Termination_Type__c == '' || employeeStatus.Termination_Type__c == null)  
                                                                           || (employeeStatus.Termination_Reason__c == '' || employeeStatus.Termination_Reason__c == null) || (employeeStatus.Eligible_for_Rehire__c == '' || employeeStatus.Eligible_for_Rehire__c == null) )) {
                                                                               employeeStatus.AddError('Kindly Provide all the Termination Details'); 
                                                                           }
                
                
            }
            
            if (Trigger.isUpdate && Trigger.isAfter)  {
                
                if(employeeStatus.Status__c == 'Approved' && employeeStatus.Current_Status__c == true){
                    
                    
                    Employee__c currentEmployeeState = [SELECT id, Employee_Active__c,Termination_Date__c,Employment_Status__c,Employee_Role__c,
                                                        Line_Manager_SF_Account__c,Team_Lead_SF_Account__c,Job_Title__c,Talent_Partner__c,
                                                        Company_Division__c,Department_Unit__c,Department__c,Line_Manager__c,
                                                        Sanergy_Department__c,Sanergy_Department_Unit__c,End_Date__c
                                                        FROM Employee__c 
                                                        WHERE Id =: employeeStatus.Employee__c 
                                                       ];
                    
                    currentEmployeeState.Employee_Role__c = employeeStatus.Employee_Role__c;
                    currentEmployeeState.Line_Manager_SF_Account__c = employeeStatus.Line_Manager_SF_Account__c;
                    currentEmployeeState.Team_Lead_SF_Account__c = employeeStatus.Team_Lead_SF_Account__c;
                    currentEmployeeState.Job_Title__c = employeeStatus.Job_Title__c;
                    currentEmployeeState.Team_Lead__c = employeeStatus.Team_Lead__c;
                    currentEmployeeState.Talent_Partner_SF_Account__c = employeeStatus.Talent_Partner_SF_Account__c;
                    currentEmployeeState.Talent_Partner__c = employeeStatus.Talent_Partner__c;
                    currentEmployeeState.Line_Manager__c  = employeeStatus.Line_Manager__c;
                    currentEmployeeState.Company_Division__c =  employeeStatus.Company__c;
                    currentEmployeeState.Sanergy_Department_Unit__c = employeeStatus.Sanergy_Department_Unit__c;
                    currentEmployeeState.Sanergy_Department__c = employeeStatus.Sanergy_Department__c;
                    currentEmployeeState.Department__c = employeeStatus.Department__c;
                    currentEmployeeState.Department_Unit__c = employeeStatus.Department_Unit__c;
                    currentEmployeeState.Current_Status_End_Date__c = employeeStatus.Expected_End_Date__c;
                    currentEmployeeState.Acting_Role__c = employeeStatus.Acting_Role__c;
                    currentEmployeeState.Employee_Role_Grouping__c = employeeStatus.Employee_Role_Grouping__c;
                    
                    
                    if(employeeStatus.Contract_Change_Renewal__c == true){
                        //Update the Contract End Date 
                        currentEmployeeState.End_Date__c = employeeStatus.Expected_End_Date__c;
                    }
                    else{
                       currentEmployeeState.End_Date__c = currentEmployeeState.End_Date__c;  
                    }
                    
                    if(employeeStatus.Employment_Status__c == 'Terminated'){
                        
                        //if employee is terminated, set status as terminated and provide termination date
                        //then set employee active as false(set employee as inactive)
                        
                        //set the employee active to false
                        currentEmployeeState.Employee_Active__c = false;
                        
                        //pick the termination date
                        currentEmployeeState.Termination_Date__c = employeeStatus.Effective_Date__c;
                        
                        //set the employment status to terminated
                        currentEmployeeState.Employment_Status__c = 'Terminated';
                        
                        
                        allowance = [SELECT Id,isActive__c,End_Date__c,Employee__c
                                     FROM Staff_Allowances__c 
                                     WHERE Employee__c =: currentEmployeeState.Id
                                     AND isActive__c = TRUE
                                    ];
                        if(allowance.size() > 0){
                            for(Staff_Allowances__c StAllowance: allowance){
                                stAllowance.isActive__c = false;
                                stAllowance.End_Date__c = employeeStatus.Effective_Date__c; 
                            }
                            
                            update allowance;
                        }
                        
                        
                        
                        
                    }else{
                        
                        //set the provided employment status
                        currentEmployeeState.Employment_Status__c = employeeStatus.Employment_Status__c;
                        
                        //if termination date was provided then set to null
                        currentEmployeeState.Termination_Date__c = NULL;
                        
                        //set the employee active to true
                        currentEmployeeState.Employee_Active__c = TRUE;
                        
                    }             
                    
                    update currentEmployeeState;
                    
                    
                    
                    
                }
                
            }
            
            
            
            
            
            
            
            
        }
    }
}