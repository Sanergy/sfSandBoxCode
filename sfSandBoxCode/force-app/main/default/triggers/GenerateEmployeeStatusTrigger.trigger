trigger GenerateEmployeeStatusTrigger on Employee__c (after insert, before insert) {
    for (Employee__c emp: Trigger.New){
        if(Trigger.isInsert && Trigger.isBefore){
            
            emp.Employment_Status__c = 'Pending Activation';
        }
        system.debug('emp.Employment_Status__c' + emp.Employment_Status__c);
        if(Trigger.isInsert && Trigger.isAfter){
            Employee_Status__c empStatus = new Employee_Status__c();
            empStatus.Employee_Role__c = emp.Employee_Role__c;
            empStatus.Employee__c = emp.Id;
            empStatus.Employment_Status__c = emp.Employment_Status__c;
            empStatus.Contract_Change_Renewal__c = true;
            //empStatus.Current_Status__c = true;
            //
            insert empStatus;
            system.debug('Employee Status' + empStatus);
            // empStatus.Status__c = 'Approved';
            //  update empStatus;
        }

        
        
    }   
}