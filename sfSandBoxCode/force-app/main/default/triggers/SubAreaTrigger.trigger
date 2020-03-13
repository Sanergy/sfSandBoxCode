trigger SubAreaTrigger on Sub_Area__c (before insert, before update) {
    
    /*Set<ID> ids = Trigger.newMap.keySet();

    List<Area__c> areas = [SELECT Id,Name,Customer_Support_Asst_Mngr_EmployeeGUID__c,
    Customer_Support_Asst_Mngr_SF_User_Acct__c,Customer_Support_CSA_EmployeeGUID__c,
    Customer_Support_CSA_SF_User_Acct__c,Sales_Asst_Mngr_EmployeeGUID__c,
    Sales_Asst_Mngr_SF_User_Acct__c,Sales_SA_EmployeeGUID__c,Sales_SA_SF_User_Acct__c    
    FROM Area__c  
    WHERE Id IN :ids];
    
    System.debug('FIND AREA: = ' + areas);*/
    
    for(Sub_Area__c subArea: Trigger.new){
        
        /*Get Area
        Area__c area = [SELECT Id,Name,Customer_Support_Asst_Mngr_EmployeeGUID__c,
                        Customer_Support_Asst_Mngr_SF_User_Acct__c,Customer_Support_CSA_EmployeeGUID__c,
                        Customer_Support_CSA_SF_User_Acct__c,Sales_Asst_Mngr_EmployeeGUID__c,
                        Sales_Asst_Mngr_SF_User_Acct__c,Sales_SA_EmployeeGUID__c,Sales_SA_SF_User_Acct__c    
                        FROM Area__c 
                        WHERE Id =: subArea.Area_Name__c
                        LIMIT 1
                       ];
        
        //INSERT or UPDATE Sub Area fields
        subArea.Customer_Support_CSA_EmployeeGUID__c = area.Customer_Support_CSA_EmployeeGUID__c;
        subArea.Customer_Support_CSA_SF_User_Acct__c = area.Customer_Support_CSA_SF_User_Acct__c;                
        subArea.Customer_Support_Asst_Mngr_EmployeeGUID__c = area.Customer_Support_Asst_Mngr_EmployeeGUID__c;
        subArea.Customer_Support_Asst_Mngr_SF_User_Acct__c = area.Customer_Support_Asst_Mngr_SF_User_Acct__c;
        subArea.Sales_SA_EmployeeGUID__c = area.Sales_SA_EmployeeGUID__c;
        subArea.Sales_SA_SF_User_Acct__c = area.Sales_SA_SF_User_Acct__c;
        subArea.Sales_Asst_Mngr_EmployeeGUID__c = area.Sales_Asst_Mngr_EmployeeGUID__c;
        subArea.Sales_Asst_Mngr_SF_User_Acct__c = area.Sales_Asst_Mngr_SF_User_Acct__c;*/
        
        
        //Get customerSupportAssistantManager
        Employee__c customerSupportAssistantManager = [SELECT Id,Employee_SF_Account__c 
                                                       FROM Employee__c 
                                                       WHERE ID =: subArea.Customer_Support_Asst_Mngr_EmployeeGUID__c];        
        
        //Get customerSupportCSA
        Employee__c customerSupportCSA = [SELECT Id,Employee_SF_Account__c 
                                          FROM Employee__c 
                                          WHERE ID =: subArea.Customer_Support_CSA_EmployeeGUID__c];
        
        
        //Get salesAssistantManager
        Employee__c salesAssistantManager = [SELECT Id,Employee_SF_Account__c 
                                             FROM Employee__c 
                                             WHERE ID =: subArea.Sales_Asst_Mngr_EmployeeGUID__c];
        
        //Get salesAssociate
        Employee__c salesAssociate = [SELECT Id,Employee_SF_Account__c 
                                      FROM Employee__c 
                                      WHERE ID =: subArea.Sales_SA_EmployeeGUID__c];
        
        //UPDATE Employee SF Accounts
        if(customerSupportCSA != null){
            subArea.Customer_Support_CSA_SF_User_Acct__c = customerSupportCSA.Employee_SF_Account__c; 
        }
        if(customerSupportAssistantManager != null){
            subArea.Customer_Support_Asst_Mngr_SF_User_Acct__c = customerSupportAssistantManager.Employee_SF_Account__c;
        }
        if(salesAssociate != null){
            subArea.Sales_SA_SF_User_Acct__c = salesAssociate.Employee_SF_Account__c;
        }
        if(salesAssistantManager != null){
            subArea.Sales_Asst_Mngr_SF_User_Acct__c = salesAssistantManager.Employee_SF_Account__c;
        }       
        
    }
}