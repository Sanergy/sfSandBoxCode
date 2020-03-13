@istest(seeAllData=true)
 public class PrintFLOReceiptsTest{
 
    //test
    static testMethod void printFLOReceiptsTester() {
    
    List<Account> acc=[SELECT id FROM Account WHERE ID IN (SELECT c2g__Account__c FROM c2g__codaCashEntry__c WHERE c2g__Account__c !=null) LIMIT 1];
        PageReference pageRef = Page.Print_FLO_Receipts;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(acc.get(0));
        PrintFLOReceipt controller = new PrintFLOReceipt(sc);  
        
        controller.getCashEntries();
        controller.generateReceipt();       
    }
}