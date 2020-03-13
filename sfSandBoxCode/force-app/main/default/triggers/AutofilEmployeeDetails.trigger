trigger AutofilEmployeeDetails on Staff_Allowances__c (before insert, before update) {
    for( Staff_Allowances__c sa : Trigger.new){
        if(Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(sa.id).Employee__c != sa.Employee__c && sa.Employee__c != null )){
        
            Employee__c emp = [SELECT Sanergy_Department__c, Sanergy_Department_Unit__c, Sanergy_Department_Unit__r.Approver__c
                               FROM Employee__c
                               WHERE id = :sa.Employee__c];
            if(string.isBlank(emp.Sanergy_Department__c) == TRUE || string.isBlank(emp.Sanergy_Department_Unit__c) == TRUE ){
                sa.adderror('Missing Department and/or Department Unit; Payroll Modification [' + sa.Name + ']');
            }else { //Save record                 
                sa.Sanergy_Department__c = emp.Sanergy_Department__c;
                sa.Department_Unit__c = emp.Sanergy_Department_Unit__c;
                sa.Approver__c = emp.Sanergy_Department_Unit__r.Approver__c;
                System.debug('PAYROLL TRIGGER - DEPARTMENT UNIT: ' + sa.Department_Unit__c + sa.Department_Unit__r.Name + emp.Sanergy_Department_Unit__c);            
            }
        }  
        if(Trigger.isUpdate){
            Employee__c emp = [SELECT Sanergy_Department__c, Sanergy_Department_Unit__c, Sanergy_Department_Unit__r.Approver__c
                               FROM Employee__c
                               WHERE id = :sa.Employee__c];
            if(string.isBlank(emp.Sanergy_Department__c) == TRUE || string.isBlank(emp.Sanergy_Department_Unit__c) == TRUE ){
                sa.adderror('Missing Department and/or Department Unit; Payroll Modification [' + sa.Name + ']');
            }else { //Save record                 
                sa.Sanergy_Department__c = emp.Sanergy_Department__c;
                sa.Department_Unit__c = emp.Sanergy_Department_Unit__c;
                sa.Approver__c = emp.Sanergy_Department_Unit__r.Approver__c;
                System.debug('PAYROLL TRIGGER - DEPARTMENT UNIT: ' + sa.Department_Unit__c + sa.Department_Unit__r.Name + emp.Sanergy_Department_Unit__c);         
            }
        }
    }
}