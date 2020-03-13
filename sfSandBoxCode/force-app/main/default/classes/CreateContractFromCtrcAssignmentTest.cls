@isTest (seeAllData = true)
Public class CreateContractFromCtrcAssignmentTest{ 
    static testMethod void CreateContractFromCtrcAssignmentTest() {
        List<Casuals_Job_Assignment__c> jobAssignment= new List<Casuals_Job_Assignment__c>();
        jobAssignment = [SELECT id, Name FROM Casuals_Job_Assignment__c ORDER BY CreatedDate DESC LIMIT 10];
        
        if(jobAssignment.size()>0){
            PageReference pageRef = Page.CreateContractFromJobAssignment;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(jobAssignment.get(0));
            CreateContractFromContractorAssignment ctrl = new CreateContractFromContractorAssignment(sc);
            ctrl.createContract();
        }
    }
}