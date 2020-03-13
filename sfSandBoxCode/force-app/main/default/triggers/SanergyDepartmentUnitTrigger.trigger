trigger SanergyDepartmentUnitTrigger on Sanergy_Department_Unit__c (before insert, before update) {
    
    for(Sanergy_Department_Unit__c departmentUnit: Trigger.new){
        
        System.debug('lineManagerSfAc: = ' + departmentUnit.Line_Manager__c);
        
        Employee__c lineManagerSfAc = [SELECT Id,Employee_SF_Account__c 
                                       FROM Employee__c 
                                       WHERE Id =: departmentUnit.Line_Manager__c];
        System.debug('lineManagerSfAc LIST: = ' + lineManagerSfAc);
        Employee__c TeamLeadSfAc = [SELECT Id,Employee_SF_Account__c 
                                    FROM Employee__c 
                                    WHERE Id =: departmentUnit.Team_Lead__c
                                   ];
        System.debug('TeamLeadSfAc: = ' + TeamLeadSfAc);        
        System.debug('Talent_Partner_Emp_Account__c: = ' + departmentUnit.Talent_Partner_Emp_Account__c);  
        Employee__c TalentPartnerSfAc = [SELECT Id,Employee_SF_Account__c 
                                         FROM Employee__c 
                                         WHERE Id =: departmentUnit.Talent_Partner_Emp_Account__c
                                        ];
        System.debug('TalentPartnerSfAc: = ' + TalentPartnerSfAc);        
        
        if(Trigger.isUpdate && Trigger.isBefore){
            
            //Update LM/TL/TP
            departmentUnit.Line_Manager_SF_Account__c = lineManagerSfAc.Employee_SF_Account__c;
            departmentUnit.Approver__c = lineManagerSfAc.Employee_SF_Account__c; //default to same value as LM
            departmentUnit.Team_Lead_SF_Account__c = TeamLeadSfAc.Employee_SF_Account__c;
            departmentUnit.Talent_Partner__c = TalentPartnerSfAc.Employee_SF_Account__c;
            departmentUnit.Approver__c = lineManagerSfAc.Employee_SF_Account__c;
        }else{            
            //Insert LM/TL/TP
            departmentUnit.Line_Manager_SF_Account__c = lineManagerSfAc.Employee_SF_Account__c;
            departmentUnit.Approver__c = lineManagerSfAc.Employee_SF_Account__c;
            departmentUnit.Team_Lead_SF_Account__c = TeamLeadSfAc.Employee_SF_Account__c;
            departmentUnit.Talent_Partner__c = TalentPartnerSfAc.Employee_SF_Account__c;            
            
        }//End if(Trigger.isUpdate && Trigger.isBefore)
        
    }//End for()
}