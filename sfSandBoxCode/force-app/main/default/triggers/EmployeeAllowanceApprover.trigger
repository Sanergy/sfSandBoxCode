trigger EmployeeAllowanceApprover on Employee__c (before insert) {
    for(Employee__c emp : Trigger.new){
        if(emp.Allowance_Approver__c ==null ){
            List<Sanergy_Department_Unit__c> departmentUnit =[select id,Approver__c
                                                             from Sanergy_Department_Unit__c
                                                             where id =:emp.Sanergy_Department_Unit__c 
                                                             and Approver__c!=null];
            if(departmentUnit.size()>0){
                emp.Allowance_Approver__c = departmentUnit.get(0).Approver__c;
            }
            
        }
    }
  
}