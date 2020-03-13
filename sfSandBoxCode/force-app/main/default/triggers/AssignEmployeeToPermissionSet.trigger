trigger AssignEmployeeToPermissionSet on Employee__c (after update) {
//check if user is active
    if(Trigger.isUpdate){
        for(Employee__c emp: Trigger.new){
            //Have to call future method this way to avoid MIXED DML error
            SanergyUtils.AssignEmpToBambooHRPermSet(emp.Id);
        } 
    }
}