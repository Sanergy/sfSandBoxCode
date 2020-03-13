trigger Pull_Toilets_To_Accounts on Toilet__c (after update,after insert,after delete) {
    if (Trigger.isAfter) {
        if(Trigger.isUpdate){
            for(Toilet__c toilet:Trigger.New){
               Toilet__c oldT = Trigger.oldMap.get(toilet.Id);
        		if(toilet.Operational_Status__c!=oldT.Operational_Status__c){
            
           		 Integer  countToilets=[SELECT count() FROM Toilet__c 
                                  WHERE Opportunity__r.AccountId=:toilet.AccountId__c
                                 AND Operational_Status__c='Open' ];
                    
            	 LIST<Account> acc=[SELECT Numbe_Of_Open_Toilets__c FROM Account WHERE ID=:toilet.AccountId__c];
                if(acc.size()>0){
                     acc.get(0).Numbe_Of_Open_Toilets__c=countToilets;
           		 	 update acc;
               }
            }    
        }
        }
        if(Trigger.isInsert){
            for(Toilet__c toilet:Trigger.New){
        		 Integer  countToilets=[SELECT count() FROM Toilet__c 
                                  WHERE Opportunity__r.AccountId=:toilet.AccountId__c
                                 AND Operational_Status__c='Open' ];
                    
            	 LIST<Account> acc=[SELECT Numbe_Of_Open_Toilets__c FROM Account WHERE ID=:toilet.AccountId__c];
                if(acc.size()>0){
                     acc.get(0).Numbe_Of_Open_Toilets__c=countToilets;
           		 	 update acc;
                }
                               
            }    
        }
       
    }
}