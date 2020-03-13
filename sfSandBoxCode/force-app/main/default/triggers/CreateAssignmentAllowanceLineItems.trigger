trigger CreateAssignmentAllowanceLineItems on Casuals_Job_Assignment__c (after insert) {
    for(Casuals_Job_Assignment__c  casJobAss:Trigger.new){
        List<Casual_Job_Allowance__c> cjaList=[SELECT Allowance_Type__c,Description__c,Quantity__c,Rate__c,Rate_Units__c 
                                              FROM Casual_Job_Allowance__c 
                                              WHERE Casual_Job_Line_Item__c=:casJobAss.Casual_Job_Line_Item__c];
                                           
        List<Casual_Job_Assignment_Allowances__c> cjaaList=new List<Casual_Job_Assignment_Allowances__c>();
        
        for(Casual_Job_Allowance__c cja:cjaList){
            Casual_Job_Assignment_Allowances__c cjaa=new Casual_Job_Assignment_Allowances__c(
                 Allowance_Type__c=cja.Allowance_Type__c,
                 Casual_Job_Assignment__c=casJobAss.id,
                 Description__c=cja.Description__c,
                 Quantity__c=cja.Quantity__c,
                 Rate__c=cja.Rate__c,
                 Rate_Units__c=cja.Rate_Units__c   
            );
            
            cjaaList.add(cjaa);
        }
        
        if(cjaaList.size()>0){
            insert cjaaList;
        }
    }
}