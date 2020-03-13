@isTest(seeAllData=true)
private class AddCaseEngineeringItemsControllerTest{
    /*---------------------------------Test for the Application management----------------------------------*/
     static testMethod void AddCaseEngineeringItemsControllerTst() {
     
         //get a maintenance case opportunity
         List<Opportunity> op=[SELECT Id, Structure_Items_Added__c FROM Opportunity WHERE RecordTypeID IN
                               (SELECT ID FROM RecordType WHERE Name ='Maintenance Cases')
                               AND Structure_Items_Added__c=false
                               LIMIT 1];
         
         
        if(op.size()>0){
             //add products
            PageReference pageRef = Page.Add_Case_Engineering_Items;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(op.get(0));
            AddCaseEngineeringItemsController oppController = new AddCaseEngineeringItemsController(sc);
            oppController.upstructures=1;
            oppController.fltVersion='V2';
            oppController.createItems();
            
            oppController.fltVersion='V2-V3 Hybrid';
            oppController.upstructures=1;
            oppController.createItems();
        }
         
     }
}