@isTest(seeAllData = true)
public class EvergrowSalesPlanningDashboardTest{
    
     public static TestMethod void EvergrowSalesPlanningDashboardTester(){
           EvergrowSalesPlanningDashboard eSales = new EvergrowSalesPlanningDashboard();
           
           List<Opportunity> oppList = [SELECT Primary_Salesperson__c
                                        FROM Opportunity
                                        WHERE RecordType.Name LIKE '%Agricultural Product Sales%'
                                        AND Primary_Salesperson__c != null
                                        LIMIT 1];
          
           eSales.getContacts(); 
          
           eSales.selectedContacts.add(oppList.get(0).Primary_Salesperson__c);
           eSales.refresh();
           
           eSales.getOppListSize();
           
           eSales.oppWrapper.get(0).selected = true;
           eSales.save();
           
           eSales.cancel();
           
     }
}