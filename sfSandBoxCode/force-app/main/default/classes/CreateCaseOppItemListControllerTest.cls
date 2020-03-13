@isTest(seeAllData=true)
private class CreateCaseOppItemListControllerTest{
    static testMethod void CreateCaseOppItemListControllerTest() {
         //get a maintenance case opportunity
         List<Opportunity> op=[SELECT ID FROM Opportunity WHERE RecordTypeID IN
                               (SELECT ID FROM RecordType WHERE Name ='Maintenance Cases')
                               LIMIT 1];
         
         
         //get an inventory item
         List<Inventory_Item__c> item=[SELECT ID FROM Inventory_Item__c LIMIT 2];
         
         //create a rootstock inventory item record
         Rootstock_Inventory_Item__c rItem = new Rootstock_Inventory_Item__c(
             InventoryItem__c=item.get(0).id,
             isActive__c=true
         );
          Rootstock_Inventory_Item__c rItem2 = new Rootstock_Inventory_Item__c(
             InventoryItem__c=item.get(1).id,
             isActive__c=true
         );
         insert rItem;
         insert rItem2;
         
         //create a case opportunity item
         Case_Opportunity_Item__c caseOppItem=new Case_Opportunity_Item__c(
             Quantity__c=4,
             Rstk_Inventory_Item__c=rItem.id,
             Opportunity__c=op.get(0).id
         );
         
         insert caseOppItem;
         
        //add products
        PageReference pageRef = Page.Opportunity_Maintenance_Case_Items;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(op.get(0));
        CreateCaseOpportunityItemListController oppController = new CreateCaseOpportunityItemListController(sc);
        oppController.UpdateOpportunityStage();
    
    }
}