trigger Casuals_Allowance_Trigger on Casuals_Timesheet__c (after update, after insert) {
    for(Casuals_Timesheet__c TimeSheet:Trigger.New){
        
        Double var=0;
        
         LIST<Casuals_Job_Assignment__c>  JobAssignment=[SELECT Casual_Job_Line_Item__c,Id,Total_Allowances__c FROM Casuals_Job_Assignment__c
                                                        WHERE Id=:TimeSheet.Job_Requisition__c];
            if(JobAssignment.size()>0){
                
                LIST<Casual_Job_Line_Item__c> JobSpecificcation=[SELECT Id,Total_Allowance__c FROM Casual_Job_Line_Item__c
                                                         WHERE  Id=:JobAssignment.get(0).Casual_Job_Line_Item__c];
                if(JobSpecificcation.size()>0){
               // for(Casual_Job_Line_Item__c JobSpec:JobSpecificcation){
                    List<Casuals_Job_Assignment__c> AssignmentJobs=[SELECT Id,Total_Allowances__c,Casual_Job_Line_Item__c 
                                                                   FROM Casuals_Job_Assignment__c
                                                                   WHERE Casual_Job_Line_Item__c=:JobSpecificcation.get(0).Id];
                    for(Casuals_Job_Assignment__c ja:AssignmentJobs){
                        var += ja.Total_Allowances__c;                      
                    }
                    //System.debug('DEBUG::::::::'+var);
                    
                    if(Trigger.isUpdate){                        
                    
                        Casuals_Timesheet__c oldTime = Trigger.oldMap.get(TimeSheet.Id);
                        
                        if(TimeSheet.Total_Allowancess__c!=null && oldTime.Total_Allowancess__c!=null && oldTime.Total_Allowancess__c!=TimeSheet.Total_Allowancess__c){
                            
                            Double difference=TimeSheet.Total_Allowancess__c-oldTime.Total_Allowancess__c;
                            
                            Double totalAllowance=var+difference;
                        
                           // System.debug('DEBUG::::::::'+totalAllowance);
                        
                            if(totalAllowance > JobSpecificcation.get(0).Total_Allowance__c ){
                            
                            Double balance=JobSpecificcation.get(0).Total_Allowance__c - totalAllowance;
                            
                            TimeSheet.addError('You have exceeded the allowance as specified in the Job Specification. You have exceeded by: '+balance*-1+' Please reffer to the Job Specification');
                        	}
                        }
                    } if(Trigger.isInsert){
                        
                        
                        	Double difference=TimeSheet.Total_Allowancess__c;
                            
                            Double totalAllowance=var+difference;
                        
                           // System.debug('DEBUG::::::::'+totalAllowance);
                        
                            if(totalAllowance > JobSpecificcation.get(0).Total_Allowance__c ){
                            
                            Double balance=JobSpecificcation.get(0).Total_Allowance__c - totalAllowance;
                            
                            TimeSheet.addError('You have exceeded the allowance as specified in the Job Specification. You have exceeded by: '+balance*-1+' Please reffer to the Job Specification');
                                
                        	}
                    }
                }            
            }
        }
        
    

}