trigger CreateTimesheetAllowanceLineItems on Casuals_Timesheet__c (before insert, before update) {
     for(Casuals_Timesheet__c casTimeSht:Trigger.new){        
         
         casTimeSht.Total_Amount__c = casTimeSht.Total_Allowancess__c + casTimeSht.Payment_Amount__c;       
         
       
     }
}