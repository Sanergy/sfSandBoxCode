trigger SanergyDepartmentTrigger on Sanergy_Department__c (before update, after update, before delete) {
    if(Trigger.isDelete){
        for(Sanergy_Department__c sanergyDepartment: Trigger.old){
            //check if any Dept Units exist
            AggregateResult[] aggDU = 
                [SELECT COUNT(id) DUCount FROM Sanergy_Department_Unit__c 
                 WHERE Sanergy_Department__c =: sanergyDepartment.Id
                ];         
            Integer rowCount =  (aggDU[0].get('DUCount') != null) ? Integer.valueOf(aggDU[0].get('DUCount')) : 0 ;
            if(aggDU[0].get('DUCount') != NULL  && rowCount > 0) {
	            sanergyDepartment.adderror('You are not permitted to delete a department that has existing Department Units');
            }
        } 
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        system.debug('TeamLeadSfAc DD =  + TeamLeadSfAc');
        //update Department TL SF Account from the TL Employee Account
        for(Sanergy_Department__c sanergyDepartment: Trigger.new){
            Employee__c TeamLeadSfAc = 
                [SELECT Id,Employee_SF_Account__c,Employee_Active__c FROM Employee__c WHERE Id =: sanergyDepartment.Team_Lead__c];
            //only select an active employee
            if(TeamLeadSfAc != NULL && TeamLeadSfAc.Employee_SF_Account__c != NULL && TeamLeadSfAc.Employee_Active__c == TRUE){
                sanergyDepartment.Team_Lead_SF_Account__c = TeamLeadSfAc.Employee_SF_Account__c;
            }else
            {
                sanergyDepartment.adderror('No Valid or Active SF Account found for the Team Lead [' + sanergyDepartment.Team_Lead__c + ']');
            }
            
            //Ensure inactive status only allowed if all Dept Units are inactive
            if(sanergyDepartment.Department_Status__c == FALSE){
                AggregateResult[] aggDU = 
                    [SELECT COUNT(id) DUCount FROM Sanergy_Department_Unit__c 
                     WHERE Sanergy_Department__c =: sanergyDepartment.Id AND Active__c = TRUE
                    ];         
                Integer rowCount =  (aggDU[0].get('DUCount') != null) ? Integer.valueOf(aggDU[0].get('DUCount')) : 0 ;
                if(aggDU[0].get('DUCount') != NULL  && rowCount > 0) {
                    sanergyDepartment.adderror('You are not permitted to Deactivate a department that has existing Active Department Units');
                }
            }
            //Check Record Type matches Company
            Sanergy_Department__c dept = 
                [SELECT Id, Name, RecordType.Name FROM Sanergy_Department__c WHERE Id =: sanergyDepartment.Id];
            
            if((sanergyDepartment.Company__c == 'Sanergy' && dept.RecordType.Name != 'Sanergy') || (sanergyDepartment.Company__c == 'Fresh Life' && dept.RecordType.Name != 'FreshLife') ){
                sanergyDepartment.adderror('Invalid Company/Record Type Selected on the Department [' + dept.Name + ']');
            }
        } 
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        //update Department Units
        for(Sanergy_Department__c sanergyDepartment: Trigger.new){
            
            List<Sanergy_Department_Unit__c> sanergyDepartmentList = new List<Sanergy_Department_Unit__c>();          
            
            
            //Get all ACTIVE Sanergy Department Units that belong to the same Sanergy Department
            List<Sanergy_Department_Unit__c> sanergyDepartmentUnit = [SELECT id,Name,Sanergy_Department__c,Sanergy_Department__r.Name,
                                                                      Sanergy_Department__r.Department_Status__c
                                                                      FROM Sanergy_Department_Unit__c 
                                                                      WHERE Sanergy_Department__c =: sanergyDepartment.Id
                                                                      AND Sanergy_Department__r.Department_Status__c = true
                                                                      AND Active__c = TRUE
                                                                     ];         
            
            if(sanergyDepartmentUnit.size() > 0) {
                
                for(Sanergy_Department_Unit__c deptUnit : sanergyDepartmentUnit){ 
                    deptUnit.Team_Lead__c = sanergyDepartment.Team_Lead__c;
                    //deptUnit.Team_Lead_SF_Account__c = sanergyDepartment.Team_Lead_SF_Account__c;
                    
                    //Add all records to the list
                    sanergyDepartmentList.add(deptUnit);
                }
                
                UPDATE sanergyDepartmentList;
            }//End if(sanergyDepartmentUnit.size() > 0) 
        }//End for()
    }
}