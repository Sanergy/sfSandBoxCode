@isTest(seeAllData = true)
public class CreateEPRFromTimesheetTest{
     static testMethod void CreateEPRFromTimesheetTest(){
        List<Casuals_Timesheet__c> timesheet =[SELECT Id
                                               FROM Casuals_Timesheet__c 
                                               WHERE EPR_Created__c = false
                                               AND EPR__c = null
                                               ORDER BY Name DESC
                                               LIMIT 1];
        
        if(timesheet.size() > 0){
            PageReference pageReff = Page.CreateEPRFromTimesheet;
            Test.setCurrentPage(pageReff);
            ApexPages.Standardcontroller cont = new ApexPages.Standardcontroller(timesheet.get(0));
            CreateEPRFromTimesheet createEPR= new CreateEPRFromTimesheet (cont); 
            createEPR.createEPR();
        }   
    }
}