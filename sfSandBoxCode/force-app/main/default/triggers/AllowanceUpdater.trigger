trigger AllowanceUpdater on Sanergy_Department_Unit__c (before update ){
    for(Sanergy_Department_Unit__c departmentUnit : Trigger.new ){
        Sanergy_Department_Unit__c oldDep = Trigger.oldMap.get(departmentUnit.id);  
        if(departmentUnit.Approver__c != oldDep.Approver__c){
            List<Employee__c> employee = [select Allowance_Approver__c,Department_Unit__c
                                          from Employee__c where Department_Unit__c =:departmentUnit.id
                                         ];
            for(Employee__c emp:employee ){
                emp.Allowance_Approver__c = departmentUnit.Approver__c;
            }
            update employee;    
        }
    }
}