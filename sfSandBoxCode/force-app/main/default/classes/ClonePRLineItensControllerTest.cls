@isTest(seeAllData=true)
public class ClonePRLineItensControllerTest{
    static testMethod void testPRCloning(){
        List<Procurement_Tracking_Sheet__c> pr = [SELECT Id,Name, Stage__c 
                                          FROM Procurement_Tracking_Sheet__c
                                          Where Stage__c = 'Team Lead Approved' ORDER BY CreatedDate DESC LIMIT 1];
        if(pr.size()>0){
            PageReference clonePage = Page.ClonePRLinesfromCurrentPR;
            Test.setCurrentPage(clonePage);
            ApexPages.StandardController controller = new ApexPages.StandardController(pr.get(0));        
            ClonePRAndPRLineItemsController clonePR = new ClonePRAndPRLineItemsController(controller);       
            clonePR.selectAll();
            clonePR.processSelected();
            clonePR.unselectAll();
        
        }
    }
}