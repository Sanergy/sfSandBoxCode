@isTest(seeAllData=true)
private class CaseOppWorkOrdersControllerTest{
    /*---------------------------------Test for the Application management----------------------------------*/
    static testMethod void CaseOppWorkOrdersControllerTest() {
        
        //get a maintenance case opportunity
        List<Opportunity> op=[SELECT ID FROM Opportunity WHERE RecordTypeID IN
                              (SELECT ID FROM RecordType WHERE Name ='Maintenance Cases')
                              LIMIT 1];
        
        
        //get an inventory item
        List<Inventory_Item__c> item=[SELECT ID FROM Inventory_Item__c LIMIT 2];
        
        //create a rootstock inventory item record
        Rootstock_Inventory_Item__c rItem = new Rootstock_Inventory_Item__c();
        rItem.InventoryItem__c=item.get(0).id;
        INSERT rItem;
        
        Rootstock_Inventory_Item__c rItem2 = new Rootstock_Inventory_Item__c();
        rItem2.InventoryItem__c=item.get(1).id;
        INSERT rItem2;
        
        // Create a case opportunity item
        Case_Opportunity_Item__c caseOppItem = new Case_Opportunity_Item__c();
        caseOppItem.Quantity__c=4;
        caseOppItem.Rstk_Inventory_Item__c=rItem.id;
        caseOppItem.Opportunity__c=op.get(0).id;
        INSERT caseOppItem;
        
        //change item
        caseOppItem.Rstk_Inventory_Item__c=rItem2.id;
        UPDATE caseOppItem;
        
        //Add products
        PageReference pageRef = Page.Create_Case_Opp_Work_Orders;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(op.get(0));
        CaseOppWorkOrdersController oppController = new CaseOppWorkOrdersController(sc);
        oppController.createOrders();
    }
}