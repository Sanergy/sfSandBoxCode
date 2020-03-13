trigger AreaTrigger on Area__c (before insert, before update/*, after update*/) {
    
    /*Integer convertToInteger;
    String lastThreeCharacters = '' ;
    
    for(Area__c area: Trigger.new){
        
        Location__c lastLocation = [SELECT Id,Name,Last_FLT__c,Area__c,Area_Name__c
                                    FROM Location__c
                                    WHERE Area_Name__c =: area.Id//Area__c =: area.Name
                                    ORDER BY Name DESC
                                    LIMIT 1];
        
        lastThreeCharacters = lastLocation.Name;
        lastThreeCharacters = lastThreeCharacters.mid(3, 2);
        System.debug('lastThreeCharacters ====== ' + lastThreeCharacters);
        
        //Check if value is Numeric
        if(lastThreeCharacters.isNumeric()){
            //Convert String to Integer
            convertToInteger = Integer.valueOf(lastThreeCharacters);
        }
        
        //Insert Last Location No.
        area.Last_Location_No__c = convertToInteger;
        
    }    
    
    /*SubArea List
    List<Sub_Area__c> subAreas = new List<Sub_Area__c>();    
    
    for(Area__c area: Trigger.new){
        
        //Execute Before Trigger
        if (Trigger.isBefore){        
            
            //Get customerSupportAssistantManager
            Employee__c customerSupportAssistantManager = [SELECT Id,Employee_SF_Account__c 
                                                           FROM Employee__c 
                                                           WHERE ID =: area.Customer_Support_Asst_Mngr_EmployeeGUID__c];        
            
            //Get customerSupportCSA
            Employee__c customerSupportCSA = [SELECT Id,Employee_SF_Account__c 
                                              FROM Employee__c 
                                              WHERE ID =: area.Customer_Support_CSA_EmployeeGUID__c];
            
            
            //Get salesAssistantManager
            Employee__c salesAssistantManager = [SELECT Id,Employee_SF_Account__c 
                                                 FROM Employee__c 
                                                 WHERE ID =: area.Sales_Asst_Mngr_EmployeeGUID__c];
            
            //Get salesAssociate
            Employee__c salesAssociate = [SELECT Id,Employee_SF_Account__c 
                                          FROM Employee__c 
                                          WHERE ID =: area.Sales_SA_EmployeeGUID__c];
            
            //UPDATE Employee SF Accounts
            area.Customer_Support_Asst_Mngr_SF_User_Acct__c = customerSupportAssistantManager.Employee_SF_Account__c;
            area.Customer_Support_CSA_SF_User_Acct__c = customerSupportCSA.Employee_SF_Account__c;
            area.Sales_Asst_Mngr_SF_User_Acct__c = salesAssistantManager.Employee_SF_Account__c;
            area.Sales_SA_SF_User_Acct__c= salesAssociate.Employee_SF_Account__c;
            
        }// End if (Trigger.isBefore)
        
        //Execute After Trigger
        if (Trigger.isAfter){
            
            //Get all Sub Areas that belong to the same Area
            List<Sub_Area__c> subAreaList = [SELECT Id,Name,Area_Name__c,Customer_Support_Asst_Mngr_EmployeeGUID__c,
                                             Customer_Support_Asst_Mngr_SF_User_Acct__c,Customer_Support_CSA_EmployeeGUID__c,
                                             Customer_Support_CSA_SF_User_Acct__c,Sales_Asst_Mngr_EmployeeGUID__c,
                                             Sales_Asst_Mngr_SF_User_Acct__c,Sales_SA_EmployeeGUID__c,Sales_SA_SF_User_Acct__c    
                                             FROM Sub_Area__c 
                                             WHERE Area_Name__c =: area.Id
                                            ];
            
            if(subAreaList.size() > 0) {
                
                for(Sub_Area__c subArea : subAreaList){
                    //Create Sub_Area__c
                    subArea.Customer_Support_CSA_EmployeeGUID__c = area.Customer_Support_CSA_EmployeeGUID__c;
                    subArea.Customer_Support_CSA_SF_User_Acct__c = area.Customer_Support_CSA_SF_User_Acct__c;                
                    subArea.Customer_Support_Asst_Mngr_EmployeeGUID__c = area.Customer_Support_Asst_Mngr_EmployeeGUID__c;
                    subArea.Customer_Support_Asst_Mngr_SF_User_Acct__c = area.Customer_Support_Asst_Mngr_SF_User_Acct__c;
                    subArea.Sales_SA_EmployeeGUID__c = area.Sales_SA_EmployeeGUID__c;
                    subArea.Sales_SA_SF_User_Acct__c = area.Sales_SA_SF_User_Acct__c;
                    subArea.Sales_Asst_Mngr_EmployeeGUID__c = area.Sales_Asst_Mngr_EmployeeGUID__c;
                    subArea.Sales_Asst_Mngr_SF_User_Acct__c = area.Sales_Asst_Mngr_SF_User_Acct__c;
                    
                    //Add all records to the list
                    subAreas.add(subArea);
                }
                
                UPDATE subAreas;
            }//End if(subAreaList.size() > 0) 
        }//End if (Trigger.isAfter)
        
    }*/
    
}