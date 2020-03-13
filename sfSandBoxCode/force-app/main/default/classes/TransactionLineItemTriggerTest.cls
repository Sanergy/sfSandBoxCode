@isTest(seeAllData=true)
public class TransactionLineItemTriggerTest {
    static testMethod void CreateTransactionLine(){
        
        c2g__codaCompany__c company = new c2g__codaCompany__c();
        company.Name = 'Pauline';
        company.CurrencyIsoCode = 'KES';
        insert company;                                           
        
         system.debug('Test Company'+ company);                                          
        Account acc = new Account();
        acc.Name = 'Unilever';
        acc.CurrencyIsoCode = 'KES';
        insert acc;
          system.debug('Test Account'+ acc);                                                     
        
       c2g__codaTransaction__c trans = new c2g__codaTransaction__c();
        trans.c2g__TransactionDate__c = date.today();
        trans.c2g__OwnerCompany__c = company.Id;
        insert trans;
        
        c2g__codaTransactionLineItem__c transactionLine = new c2g__codaTransactionLineItem__c();
        transactionLine.c2g__LineNumber__c = 1;
        transactionLine.c2g__OwnerCompany__c = company.Id;
        transactionLine.c2g__HomeValue__c =500;
        transactionLine.c2g__LineType__c = 'Account';
        transactionLine.c2g__Account__c = acc.Id;
        transactionLine.c2g__AccountOutstandingValue__c = 100;
        insert transactionLine;
        
     /*  c2g__codaTransactionLineItem__c transactionLine = [SELECT c2g__OwnerCompany__c, c2g__OwnerCompany__r.Name, c2g__Account__c,c2g__AccountOutstandingValue__c
                                        FROM c2g__codaTransactionLineItem__c
                                        WHERE c2g__LineType__c = 'Account'
                                                          Limit 1
                                      AND c2g__Account__c =: acc.Id
                                        ];*/
        system.debug('Test Transaction'+ transactionLine);    
    }
}