trigger TransactionLineItemTrigger on c2g__codaTransactionLineItem__c (after insert, after update) {
    for(c2g__codaTransactionLineItem__c transLine:Trigger.new){
        //trying not to check transactions that account Id is Null(Null might return more than 2000 records)
        IF(transLine.c2g__Account__c != NULL && transLine.c2g__LineType__c == 'Account' ) {
            
            List<AggregateResult> result = [SELECT c2g__OwnerCompany__c,c2g__OwnerCompany__r.Name, c2g__Account__c, SUM(c2g__AccountOutstandingValue__c) value
                                            FROM c2g__codaTransactionLineItem__c
                                            WHERE c2g__LineType__c = 'Account' 
                                            AND c2g__Account__c =: transLine.c2g__Account__c
                                            GROUP BY c2g__OwnerCompany__c, c2g__Account__c,c2g__OwnerCompany__r.Name
                                           ];
            system.debug('Results' + result);
            if(result.size() > 0){
                
                
                Account accounts = [SELECT Id,SLK_Balance__c,FLI_Balance__c 
                                    FROM Account
                                    WHERE ID =: transLine.c2g__Account__c
                                   ];
                system.debug('Accounts' + accounts);
                //Set the balances to Null 
                accounts.SLK_Balance__c = NULL;
                accounts.FLI_Balance__c = NULL;
                accounts.Sanergy_FP_Balance__c = NULL;
                accounts.Sanergy_NP_Balance__c = NULL;
                
                // If the list contains new balances then assign them
                system.debug('result' + result);
                for(AggregateResult res:result){
                    String Company =  (String) res.get('Name');
                    Decimal value = (Decimal) res.get('value');
                    
                    if(Company == 'Fresh Life Initiative Limited'){
                        accounts.FLI_Balance__c = value;
                    } 
                    
                    if(Company == 'Sanergy Limited'){
                        accounts.SLK_Balance__c = value; 
                    }
                    if(Company == 'Sanergy, Inc. (FP)'){
                        accounts.Sanergy_FP_Balance__c = value; 
                    }
                    if(Company == 'Sanergy, Inc. (NP)'){
                        accounts.Sanergy_NP_Balance__c = value; 
                    }
                }
                
                update accounts;
                
            }
        }   
    }       
    
    
}