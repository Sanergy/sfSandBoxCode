trigger LeaveStarted on Employee_Leave_Request__c (before update) {
       for(Employee_Leave_Request__c inv: Trigger.new){
           if(inv.Leave_Started__c == true && inv.Approval_Status__c == 'Cancelled'){
             inv.Leave_Started__c = false;  
           }
       }
}