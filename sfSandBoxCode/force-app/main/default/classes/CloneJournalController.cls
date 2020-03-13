public with sharing class CloneJournalController {

    private ApexPages.StandardController standardController;

    public CloneJournalController(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
     public PageReference cloneJournal() {
     
        // Record being cloned
        c2g__codaJournal__c originalJnl = (c2g__codaJournal__c) standardController.getRecord();
         
        String soql = Utils.getCreatableFieldsSOQL('c2g__codaJournal__c', 'Id=\'' + originalJnl.Id + '\'');
        c2g__codaJournal__c completeJnl = (c2g__codaJournal__c)Database.query(soql);
         
        c2g__codaJournal__c journal = completeJnl.clone(false, false, false, false);
        
        journal.c2g__JournalStatus__c = 'In Progress';
        journal.c2g__JournalDate__c = System.today();
        journal.ffgl__DerivePeriod__c = true;
        journal.c2g__Transaction__c = null;
         
        insert journal;
         
         if(journal.Id != null){
             //Select Items
             String itemQry = Utils.getCreatableFieldsSOQL('c2g__codaJournalLineItem__c', 'c2g__Journal__c=\'' + originalJnl.Id + '\'');
             
             List<c2g__codaJournalLineItem__c> items = (List<c2g__codaJournalLineItem__c>)Database.query(itemQry);
             List<c2g__codaJournalLineItem__c> itemsToInsert=new List<c2g__codaJournalLineItem__c>();
             
             if(items != null && items.size() > 0){
                 for(c2g__codaJournalLineItem__c item : items){
                     
                     c2g__codaJournalLineItem__c cItem = item.clone(false, false, false, false);
                     cItem.c2g__Journal__c = journal.Id;
                     
                     itemsToInsert.add(cItem);
                 }
                 
                 BatchInsertUtil batch=new BatchInsertUtil (itemsToInsert);
                 Database.executeBatch(batch, 100);
             }
             
             // Redirect to the new cloned record
             return new PageReference('/' + journal.Id);
         }
         
         return null;
    }
}