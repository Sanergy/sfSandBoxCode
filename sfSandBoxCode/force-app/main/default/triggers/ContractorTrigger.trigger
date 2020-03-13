trigger ContractorTrigger on Casual__c (before insert,before update) {
    for(Casual__c casual:Trigger.new){
        List<Account> ac=[SELECT Id,Name FROM Account WHERE Id=:casual.Account__c];
        if(ac.size()>0){
            casual.Name=ac.get(0).Name;
        }
   
        
    }

}