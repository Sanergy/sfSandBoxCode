@isTest(seeAllData = true)
public class SetDimensionsAndGlaTriggerTest{
    
    static testMethod void testSetDimensionsAndGla() {
        
        List<User> userFFA=[SELECT id FROM User WHERE Name='Stephen Kanyi'];
        if(userFFA.size()>0){
            
            
            System.runAs(userFFA.get(0)){
                List<Inventory_Adjustment__c> adjusts = [SELECT Id, Name, Cost_Transaction__c, Dimension_1__c, Dimension_2__c,
                                                         Dimension_3__c, Dimension_4__c, Adjustment_GL_Account__c, Journal__c 
                                                         FROM Inventory_Adjustment__c 
                                                         WHERE Journal__c <> null
                                                         AND Adjustment_GL_Account__c <> null
                                                         LIMIT 1];
                
                //get the journal
                List<c2g__codaJournal__c> journal=[SELECT ID,CurrencyIsoCode,c2g__OwnerCompany__c,c2g__JournalCurrency__c FROM c2g__codaJournal__c  
                                                   WHERE c2g__JournalStatus__c <> 'Complete' 
                                                   AND c2g__JournalStatus__c <> 'Discarded'
                                                   AND c2g__OwnerCompany__c = 'a19D00000026xGa'//<--Sanergy Limited  'a19D00000026xHvIAI'<-- Fresh Life
                                                   //AND CreatedBy=:userFFA.get(0).id
                                                   LIMIT 1];
                System.debug('Journal:'+journal);
                //get the division
                List<rstk__sydiv__c> div=[SELECT ID FROM rstk__sydiv__c LIMIT 1];
                
                if(journal.size()>0){   
                    Inventory_Adjustment__c invAdj=new Inventory_Adjustment__c(
                        Journal__c=journal.get(0).id,
                        Current_Division__c=div.get(0).id
                    );
                    
                    insert invAdj;
                    
                    //get the journal
                    // List<c2g__codaJournal__c> juournalList=[SELECT ID FROM c2g__codaJournal__c LIMIT 1];
                    
                    //get the GLA
                    List<c2g__codaGeneralLedgerAccount__c> glaList=[SELECT ID FROM c2g__codaGeneralLedgerAccount__c LIMIT 1];
                    
                    //get an account
                    //get the account
                    List<Account> acc=[SELECT id FROM Account WHERE c2g__CODAAccountTradingCurrency__c!=null LIMIT 1];
                    
                    
                    c2g__codaJournalLineItem__c journalLine=new c2g__codaJournalLineItem__c ();
                    journalLine.c2g__Journal__c=invAdj.Journal__c;
                    journalLine.c2g__DebitCredit__c='Debit';
                    journalLine.c2g__GeneralLedgerAccount__c=glaList.get(0).ID;
                    journalLine.c2g__LineType__c='Account - Vendor';
                    journalLine.c2g__Value__c=0.5;
                    //journalLine.CurrencyIsoCode=journal.get(0).CurrencyIsoCode;
                    journalLine.c2g__Account__c=acc.get(0).id;
                    journalLine.c2g__OwnerCompany__c=journal.get(0).c2g__OwnerCompany__c;
                    journalLine.GLA_Change__c=false;    
                    
                    
                    insert journalLine;
                }
            }
        }
    }
}