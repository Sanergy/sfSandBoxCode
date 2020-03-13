@isTest(seeAllData = true)
public class UpdateJournalValuesTriggerTest{
   
    static testMethod void testUpdateJournalValues() {
        List<User> user=[SELECT ID
                         FROM User
                         WHERE Name='Temp RS Account'
                         AND isActive=true];
                         
         if(user.size()>0){
             System.runAs(user.get(0)){
                 List<c2g__codaJournal__c> journalSelected=[SELECT c2g__Reference__c, c2g__OwnerCompany__c 
                                           FROM c2g__codaJournal__c
                                           WHERE c2g__Reference__c  <> null
                                           AND c2g__OwnerCompany__c <> null
                                           LIMIT 1]; 
       
                c2g__codaJournal__c journal=new c2g__codaJournal__c(
                    c2g__JournalDate__c=date.today(),
                    c2g__Reference__c =journalSelected.get(0).c2g__Reference__c,
                    c2g__OwnerCompany__c=journalSelected.get(0).c2g__OwnerCompany__c 
                );

             insert journal;
    
             
             
             }
         }
    }
}