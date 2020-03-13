trigger PayrollModificationApprovers on Employee__c (before update) {
    for(Employee__c emp : Trigger.new ){
        Employee__c oldEmp = Trigger.oldMap.get(emp.Id); 
        If (emp.User__c != oldEmp.User__c ){
            emp.Allowance_Approver__c = emp.User__c;
            
        }
        
    }
}