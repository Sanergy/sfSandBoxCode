@isTest(seeAllData=true)
public class GeneratePreviousPOsPRAndIssuancesTest{

     static testMethod void GeneratePreviousPOsPRAndIssuancesTest() {
     
         
         //get an PR Line item
         List<Purchase_Order_Line_Item__c> POLineItem = [SELECT ID FROM Purchase_Order_Line_Item__c LIMIT 1];
         if(POLineItem.size()>0){
             
             //get an PO Line item
         	List<PTS_Line_Item__c> PRLineItem = [SELECT ID FROM PTS_Line_Item__c LIMIT 1];
         	if(POLineItem.size()>0){
                
        		PageReference pageRef1 = Page.Previous5InventoryIssuancesOnPO;
        		Test.setCurrentPage(pageRef1);
        		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(POLineItem.get(0));
        		GeneratePreviousPOsPRsAndPOItemsOnPO prevItemsOnPO = new GeneratePreviousPOsPRsAndPOItemsOnPO(sc);
        		prevItemsOnPO.getPurchaseOrderLineItemList();
                prevItemsOnPO.getProcurementRequestLineItemList();
                prevItemsOnPO.getinventoryTransactionList();
                
                PageReference pageRef2 = Page.PreviousInventoryIssuancesOnPR;
        		Test.setCurrentPage(pageRef2);
        		ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(PRLineItem.get(0));
        		GeneratePreviousPOsPRsAndPOItemsOnPR prevItemsOnPR = new GeneratePreviousPOsPRsAndPOItemsOnPR(sc2);
        		prevItemsOnPO.getPurchaseOrderLineItemList();
                prevItemsOnPO.getProcurementRequestLineItemList();
                prevItemsOnPO.getinventoryTransactionList();
            }
         }
     }
}