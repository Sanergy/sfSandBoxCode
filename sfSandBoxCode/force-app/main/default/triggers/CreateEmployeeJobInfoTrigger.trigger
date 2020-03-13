trigger CreateEmployeeJobInfoTrigger on Employee_Job_Information__c (before insert,before update) {
    for(Employee_Job_Information__c empJobInfo : Trigger.New){
        //get the employeeid
        Employee__c emp = [SELECT Employee_Role__c,Job_Title__c 
                           FROM Employee__c
                           WHERE ID =: empJobInfo.Reports_To__c
                          ];
        
        //get the updated employee role
        emp.Employee_Role__c = empJobInfo.Job_Title__c;
        
        UPDATE emp;
    }
}