trigger JobSpecAllowance on Casual_Job_Line_Item__c (before insert,before update) {
    for(Casual_Job_Line_Item__c spec:Trigger.new){
        
        if(spec.Allowance_Per_Person__c!=null && spec.Number_Of_Casuals__c!=null){
            
             spec.Total_Allowance__c=spec.Allowance_Per_Person__c*spec.Number_Of_Casuals__c;
        } else{
            spec.Total_Allowance__c=0;        
            } 
            if(spec.Allowance_Per_Person__c!=null && spec.Allowance_Description__c==null){
                        
            spec.Allowance_Description__c.addError('Please give a drscription for the Allowance');
            }  
        
        LIST<Casuals_Job_Assignment__c>  JobAssignment=[SELECT Id,Casual_Job_Line_Item__c FROM Casuals_Job_Assignment__c
                                                        WHERE Casual_Job_Line_Item__c=:spec.Id];
        if(JobAssignment.size()>0){
            spec.Assignments__c = JobAssignment.size();
        }else { spec.Assignments__c = 0;}

       
    }

}