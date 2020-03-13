trigger ExpenseItemsWoClose on c2g__codaJournalLineItem__c (after insert) {

   for (c2g__codaJournalLineItem__c lineItem: Trigger.new) {
        
      if(lineItem.c2g__Journal__c != null && !lineItem.GLA_Change__c){
       
           List<c2g__codaJournal__c> journal=[SELECT c2g__JournalDescription__c, c2g__Reference__c
                                              FROM c2g__codaJournal__c 
                                              WHERE ID=:lineItem.c2g__Journal__c];
            String jDescription = journal.get(0).c2g__JournalDescription__c;
            String jReference = journal.get(0).c2g__Reference__c;
            
            if(jDescription != null && jReference != null && jDescription == 'WOCLOSE') {
                
                String accountId = null;
                
                if(jReference == 'SLK Opportunity Structure (Opportunity Structure)'){
                     Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
                     accountId = settings.get('SLK Opportunity Structure').Value__c;
                } else if(jReference == 'FLIK Opportunity Structure (Opportunity Structure)'){
                    Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
                    accountId = settings.get('FLIK Opportunity Structure').Value__c;
                } else if(jReference == 'SLK Opportunity Lauch Item (BIB Launch Item)'){
                    Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
                    accountId = settings.get('SLK Opportunity Lauch Item').Value__c;
                } else if(jReference == 'FLIK Opportunity Lauch Item (BIB Launch Item)'){
                    Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
                    accountId = settings.get('FLIK Opportunity Lauch Item').Value__c;
                }
                
               if(lineItem.c2g__Value__c > 0 && accountId != null){
               
                    c2g__codaJournalLineItem__c debit = lineItem.clone(false,false,false,false);
                    debit.c2g__Value__c = (debit.c2g__Value__c * -1);
                    debit.GLA_Change__c = true;
                    debit.id=null;
                    
                    insert debit;
                    
                    c2g__codaJournalLineItem__c credit = lineItem.clone(false,false,false,false);
                    credit.GLA_Change__c = true;
                    credit.c2g__GeneralLedgerAccount__c = accountId;
                    credit.id=null;
                    
                    insert credit;
                } 
            }
        }


   }

}