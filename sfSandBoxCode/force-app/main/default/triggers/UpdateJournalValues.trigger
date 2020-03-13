trigger UpdateJournalValues on c2g__codaJournal__c (before insert) {

    for (c2g__codaJournal__c journal : Trigger.new) {
    
      /*  if(journal.c2g__Reference__c != null){
        
            List<rstk__peitem__c> engItems = [SELECT Id, Name, rstk__peitem_item__c FROM rstk__peitem__c 
                                    WHERE rstk__peitem_item__c = :journal.c2g__Reference__c];
                                    
            if(engItems.size() > 0){
                rstk__peitem__c engItem = engItems.get(0);
                
                if(engItem.Name != null && !engItem.Name.equals('')){
                    journal.c2g__Reference__c = engItem.Name;
                }
            }
        }
*/
    }

}