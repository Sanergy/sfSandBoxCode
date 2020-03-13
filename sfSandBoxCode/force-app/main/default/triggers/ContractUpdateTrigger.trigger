trigger ContractUpdateTrigger on Contract (before insert, before update) {
    
    List<Contract> contracts = new List<Contract>();
    
    String version = 'V'; 
    Integer initialVersionNumberOfContract = 0;
    
    for(Contract c: Trigger.New){
       
        if(Trigger.isUpdate && Trigger.oldMap.get(c.Id).Current_Version_Of_Contract__c !=c.Current_Version_Of_Contract__c){
            
                Integer convertToInteger = Integer.valueOf(c.Contract_Version__c.substring(1,2));
                
                contracts = [SELECT Id,Name,AccountId,Current_Version_Of_Contract__c,
                             Contract_Summary__c,Current_Version_Of_Contract__r.AccountId,
                             StartDate,ContractTerm,Primary_Contract__c
                             FROM Contract
                             WHERE AccountId =: c.AccountId
                             ORDER BY ContractNumber DESC];
            
                if(contracts.size()>0 && contracts!=null){
                    if(c.Current_Version_Of_Contract__c!=null){
                        c.StartDate = contracts.get(0).StartDate;
                        c.ContractTerm = contracts.get(0).ContractTerm;
                        c.Primary_Contract__c = true;
                        c.Contract_Summary__c = contracts.get(0).Contract_Summary__c;
                        convertToInteger+=1;                
                        c.Contract_Version__c = version+convertToInteger;
                    }
                }// end if
            //}// end if Trigger.oldMap.get(c.Current_Version_Of_Contract__c)
        }// end if Trigger.isUpdate
        
        if(Trigger.isInsert){
            c.Contract_Version__c = version+initialVersionNumberOfContract;
        }// end if Trigger.isInsert
    }// end for loop
}