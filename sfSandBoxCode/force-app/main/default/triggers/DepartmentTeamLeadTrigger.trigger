trigger DepartmentTeamLeadTrigger on Employee_Leave_Request__c (before insert, before update) {    

    for(Employee_Leave_Request__c leaveRequest: Trigger.new){
        
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.oldMap.get(leaveRequest.Id).Employee_s_Department__c!= leaveRequest.Employee_s_Department__c){
            
              
            /*List<FFA_Config_Object__c> RDTL= [SELECT ID,Name,Teamlead__c, Teamlead__r.Team_Lead__c 
                                                FROM FFA_Config_Object__c
                                                WHERE Id=:leaveRequest.Employee_s_Department__c LIMIT 1];*/
            List<Sanergy_Department_Unit__c> sanergyDepartmentUnit = [SELECT Id,Name,Approver__c,Sanergy_Department__c,Unit_Code__c
                                                                      FROM Sanergy_Department_Unit__c
                                                                      WHERE Id =: leaveRequest.Employee_s_Department__c 
                                                                      LIMIT 1];
              
              if(sanergyDepartmentUnit.size()>0){
                  if(sanergyDepartmentUnit.get(0).Approver__c!=null){
                      leaveRequest.Department_Team_Lead__c=sanergyDepartmentUnit.get(0).Approver__c;
                      System.debug('REQUESTING DEPT TL: ' + leaveRequest.Department_Team_Lead__c);
                  }
              } 
         }
    }
}