@isTest(SeeAllData=true)
public class OnboardingTasksControllerTest {
    static testMethod void TestOnboardingcontroller(){
        /*List<Inventory_Requisition__c> requisition = [SELECT Id,Name,Stage__c From Inventory_Requisition__c
                                                     WHERE Stage__c = 'Approved'];
        If(requisition.size()>0){*/
            List<Employee__c> employee = [SELECT Id,Name,Employment_Status__c FROM Employee__c
                                                        WHERE Employment_Status__c  = 'Contract' ];
            if(employee.size()>0){
                
                employee.get(0).Employment_Status__c = 'Pending Onboarding';
                update employee;
                
                On_Offboarding_Checklist__c task = new On_Offboarding_Checklist__c();
                task.Employee__c = employee.get(0).Id;
                task.Task_Name__c = 'trial';
                
                insert task;
                
                PageReference pageRef = Page.InventoryItemIssue;
            
                Test.setCurrentPage(pageRef);
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(employee.get(0));
                OnboardingTasksController controller = new OnboardingTasksController(sc);
                controller.selectAll();
                controller.processSelected();
                controller.unselectAll();
            }

        //}
    }


}