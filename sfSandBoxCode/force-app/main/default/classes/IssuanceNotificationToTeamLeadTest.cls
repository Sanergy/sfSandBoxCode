@isTest(seeAllData=true)
public class IssuanceNotificationToTeamLeadTest {
    static testMethod void testNotification(){
        LIST<Sanergy_Asset__c> asset=[SELECT Id,Asset_Status__c,Employee__c,Active__c  FROM Sanergy_Asset__c
                                      WHERE Asset_Status__c=:'Inventory'
                                      LIMIT 1];
         List<Employee__c> emp=[SELECT name, Id FROM Employee__c
                                LIMIT 1];
        for(Sanergy_Asset__c ass:asset){
            ass.Employee__c=emp.get(0).Id;
            ass.Active__c=true;
            ass.Asset_Status__c='Issued';  
        } update asset;            
    }
}
//Sanergy_Asset__c a=new Sanergy_Asset__c();