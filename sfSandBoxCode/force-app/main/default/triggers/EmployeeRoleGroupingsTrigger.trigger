trigger EmployeeRoleGroupingsTrigger on Employee_Role_Groupings__c (before insert, before Update) {
    for(Employee_Role_Groupings__c Groupings: Trigger.New){
        if(Groupings.Line_Manager__c	 != null){
         Employee__c lineManagerSfAc = [SELECT Id,Employee_SF_Account__c 
                                           FROM Employee__c 
                                           WHERE ID =: Groupings.Line_Manager__c
                                          ];  
            
            Groupings.Line_Manager_SF_Account__c =  lineManagerSfAc.Employee_SF_Account__c;
        }
   
        
       
    }

    
    
    
}