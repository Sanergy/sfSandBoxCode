trigger EmployeeRoleTrigger on Employee_Role__c (before insert, before update, after update) {
    for(Employee_Role__c employeeRole: Trigger.new){    
        if(Trigger.isInsert && Trigger.isBefore){
            Sanergy_Department_Unit__c departmentUnit = 
                [
                    SELECT Id,Name,Sanergy_Department__c,Sanergy_Department__r.Name,
                    Line_Manager__c,Line_Manager_SF_Account__c,Team_Lead__c,
                    Team_Lead_SF_Account__c,Talent_Partner_Emp_Account__c,Talent_Partner__c,
                    Sanergy_Department__r.Id,Sanergy_Department__r.Company__c
                    FROM Sanergy_Department_Unit__c 
                    WHERE Id =: employeeRole.Sanergy_Department_Unit__c
                ];                
            
            //Check if department exists
            if(departmentUnit != null){   
                /*employeeRole.Line_Manager__c = departmentUnit.Line_Manager__c;
                employeeRole.Line_Manager_SF_Account__c = departmentUnit.Line_Manager_SF_Account__c;
                employeeRole.Team_Lead__c = departmentUnit.Team_Lead__c;
                employeeRole.Team_Lead_SF_Account__c = departmentUnit.Team_Lead_SF_Account__c;
                employeeRole.Talent_Partner__c = departmentUnit.Talent_Partner_Emp_Account__c;
                employeeRole.Talent_Partner_SF_Account__c = departmentUnit.Talent_Partner__c;*/
                employeeRole.Job_Title__c = employeeRole.Name;
                employeeRole.Department__c = departmentUnit.Sanergy_Department__r.Id;
                employeeRole.Company_Division__c = departmentUnit.Sanergy_Department__r.Company__c;                
                
            }//End if(departmentUnit != null)
            
            //Get LM
            Employee__c lineManagerSfAc = 
                [
                    SELECT Id,Employee_SF_Account__c 
                    FROM Employee__c 
                    WHERE ID =: employeeRole.Line_Manager__c
                ];
            //Get TL
            Employee__c TeamLeadSfAc = 
                [
                    SELECT Id,Employee_SF_Account__c 
                    FROM Employee__c 
                    WHERE ID =: employeeRole.Team_Lead__c
                ];      
            //Get TP
            Employee__c TalentPartnerSfAc = 
                [
                    SELECT Id,Employee_SF_Account__c 
                    FROM Employee__c 
                    WHERE ID =: employeeRole.Talent_Partner__c
                ]; 
            
            employeeRole.Talent_Partner_SF_Account__c = TalentPartnerSfAc.Employee_SF_Account__c;
            employeeRole.Line_Manager_SF_Account__c = lineManagerSfAc.Employee_SF_Account__c;
            employeeRole.Team_Lead_SF_Account__c = TeamLeadSfAc.Employee_SF_Account__c;
        }
        
        if(Trigger.isUpdate && Trigger.isBefore){
            Sanergy_Department_Unit__c departmentUnit = 
                [
                    SELECT Id,Name,Sanergy_Department__c,Sanergy_Department__r.Name,
                    Line_Manager__c,Line_Manager_SF_Account__c,Team_Lead__c,
                    Team_Lead_SF_Account__c,Talent_Partner_Emp_Account__c,Talent_Partner__c,
                    Sanergy_Department__r.Id,Sanergy_Department__r.Company__c
                    FROM Sanergy_Department_Unit__c 
                    WHERE Id =: employeeRole.Sanergy_Department_Unit__c
                ];            
            
            Employee__c lineManagerSfAc = 
                [
                    SELECT Id,Employee_SF_Account__c 
                    FROM Employee__c 
                    WHERE ID =: employeeRole.Line_Manager__c
                ];
            
            Employee__c TeamLeadSfAc = 
                [
                    SELECT Id,Employee_SF_Account__c 
                    FROM Employee__c 
                    WHERE ID =: employeeRole.Team_Lead__c
                ];      
            
            Employee__c TalentPartnerSfAc = 
                [
                    SELECT Id,Employee_SF_Account__c 
                    FROM Employee__c 
                    WHERE ID =: employeeRole.Talent_Partner__c
                ]; 
            
            employeeRole.Talent_Partner_SF_Account__c = TalentPartnerSfAc.Employee_SF_Account__c;
            employeeRole.Line_Manager_SF_Account__c = lineManagerSfAc.Employee_SF_Account__c;
            employeeRole.Team_Lead_SF_Account__c = TeamLeadSfAc.Employee_SF_Account__c;
            employeeRole.Department__c = departmentUnit.Sanergy_Department__r.Id;
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            List<Employee_Status__c> employeeStatuses = [SELECT id,Employee_Role__c,Current_Status__c,Status__c,Line_Manager__c,
                                                         Team_Lead__c,Talent_Partner__c,Team_Lead_SF_Account__c,Talent_Partner_SF_Account__c
                                                         FROM Employee_Status__c 
                                                         WHERE Employee_Role__c =: employeeRole.Id 
                                                         AND Current_Status__c = true
                                                         AND Status__c = 'Approved'
                                                        ];
            system.debug('employeeStatuses' + employeeStatuses);
            
            if(employeeStatuses.size() > 0) {   
                for(Employee_Status__c empStatus : employeeStatuses){
                    UPDATE empStatus;
                }
            }//End if(employeeStatuses.size() > 0)
        }//End if() 
    }//End for()
}