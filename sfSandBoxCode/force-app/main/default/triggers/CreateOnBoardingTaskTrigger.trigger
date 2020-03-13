trigger CreateOnBoardingTaskTrigger on Onboarding_Task_Config__c (before insert, before update) {
    for(Onboarding_Task_Config__c onboardingtaskconfig : Trigger.new){
        
        //run a query to get the fields from employee role
        List<Sanergy_Department_Unit__c> departmentUnit = [SELECT Sanergy_Department__c, Sanergy_Department__r.Name, Talent_Partner__r.Name, Line_Manager__c, Line_Manager__r.Name
                                                           FROM Sanergy_Department_Unit__c
                                                           WHERE ID
                                                           IN
                                                           (
                                                               SELECT Sanergy_Department_Unit__c
                                                               FROM Employee_Role__c 
                                                               WHERE ID =: onboardingtaskconfig.Employee_Role__c
                                                           )];
        
        
        //query the employee object to get the emp salesforceaccount(links employee object to Account object)
        List<Employee__c> emp = [SELECT ID, Employee_SF_Account__c
                                 FROM Employee__c
                                 WHERE NAME =: departmentUnit.get(0).Line_Manager__r.Name];
        
        //query the department unit to get the team lead
        List<Sanergy_Department__c> sanerDept = [SELECT Team_Lead__c
                                                 FROM Sanergy_Department__c 
                                                 WHERE Team_Lead__c =: departmentUnit.get(0).Line_Manager__c 
                                                ];
        
        System.debug('Saner dept : '+sanerDept.get(0).Team_Lead__c);
        
        //to get the salesforceaccountId from employee object
        List<Employee__c> employee = [SELECT Employee_SF_Account__c
                                      FROM Employee__c
                                      WHERE id =: sanerDept.get(0).Team_Lead__c
                                      LIMIT 1];
        
         
       
        //DROPDOWN LIST SELECT OPTION
        if(onboardingtaskconfig.On_boarding_Done_By__c == 'Director'){  
            
            //get the company from sanergy_department object and then check if its sanergy or freshlife
            Sanergy_Department__c sanerDepartment = [SELECT RecordTypeId 
                                                     FROM Sanergy_Department__c 
                                                     WHERE Team_Lead__c =: sanerDept.get(0).Team_Lead__c
                                                     LIMIT 1];
            
            //System.debug('Saner Departments all : '+sanerDepartment);
            
            //if department is sanergy ->id(012D0000000KIvqIAG)
            if(sanerDepartment.RecordTypeId == '012D0000000KIvqIAG'){
                
                //assign to Ani Vallabhaneni ->userId(005D0000001qz2K)
                onboardingtaskconfig.Assigned_To__c = '005D0000001qz2K';
                
            }else if(sanerDepartment.RecordTypeId == '012D0000000KIvvIAG'){
                //if  company department is fresh life -> id(012D0000000KIvvIAG)
                
                //assign to Lindsay Stradley ->userId(005D0000001qyr7)
                onboardingtaskconfig.Assigned_To__c = '005D0000001qyr7';
                
            }else{
                onboardingtaskconfig.Assigned_To__c = '';
            }
            
        }else if(onboardingtaskconfig.On_boarding_Done_By__c == 'Team Lead'){
            
            //assign the Line Manager(User Object Id) to the assigned_to field
            onboardingtaskconfig.Assigned_To__c = employee.get(0).Employee_SF_Account__c; 
            
        }else if(onboardingtaskconfig.On_boarding_Done_By__c == 'Line Manager'){
            
            //get the id and assign 
            for(Employee__c emps : emp){ 
                //assign the Line Manager(User Object Id) Id
                onboardingtaskconfig.Assigned_To__c = emps.Employee_SF_Account__c;      
            }
            
            
        }else if(onboardingtaskconfig.On_boarding_Done_By__c == 'Talent Partner'){
            //assign the talent partner id 
            onboardingtaskconfig.Assigned_To__c = departmentUnit.get(0).Talent_Partner__c;
        }
    }
}