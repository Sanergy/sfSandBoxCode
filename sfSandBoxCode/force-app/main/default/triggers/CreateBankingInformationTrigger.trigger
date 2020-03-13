trigger CreateBankingInformationTrigger on Employee_Banking_Information__c (before insert) {
    
    for(Employee_Banking_Information__c employeeBankInfo : Trigger.New ){
        
        //fetch the banking information
        List<Employee_Banking_Information__c> empBankInfo = [SELECT Current_Bank_Account__c,Employee__c
                                                             FROM Employee_Banking_Information__c
                                                             WHERE Employee__c =: employeeBankInfo.Employee__c
                                                            ];
        
        //set all current active bank account to false(not active)
        for(Employee_Banking_Information__c bankInfo : empBankInfo){
            //loop through and set all of the null
            bankInfo.Current_Bank_Account__c = false;
        }
        
        //set the last one to true
        employeeBankInfo.Current_Bank_Account__c = true;
        
        //update 
        UPDATE empBankInfo;
    }
}