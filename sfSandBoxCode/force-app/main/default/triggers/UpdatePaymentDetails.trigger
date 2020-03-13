trigger UpdatePaymentDetails on Casuals_Job_Assignment__c (before insert) {
    
    for(Casuals_Job_Assignment__c  cja:Trigger.new){ 
       
        Casual_Job_Line_Item__c cjLine=[SELECT Id, Number_Of_Casuals__c, End_Date__c, Start_Date__c
                                              FROM Casual_Job_Line_Item__c
                                              WHERE ID=:cja.Casual_Job_Line_Item__c];
                                              
         if(cjLine != null){
             
             List<Casuals_Job_Assignment__c> assign =[SELECT Id, Casual_Job_Line_Item__c, Casual__c
                                                      FROM Casuals_Job_Assignment__c 
                                                      WHERE Casual_Job_Line_Item__c =: cjLine.Id ];
             If(assign.size() >= cjLine.Number_Of_Casuals__c){
                 
                 cja.addError('You have reached Maximum Assignments as specified in the Job Specification');
                 
             }
             for(Casuals_Job_Assignment__c assgn:assign){
                 
                 if(assgn.Casual__c == cja.Casual__c){
                     
                      cja.addError('This contractor has already been assigned to another Job Specification');
                                      
                 }                 
             }
         }
    }
}