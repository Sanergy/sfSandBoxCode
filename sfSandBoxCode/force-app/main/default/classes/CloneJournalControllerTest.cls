@isTest(SeeAllData=true)
public class CloneJournalControllerTest{
    
    public static testMethod void testCloneJournalController() {
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
            System.runAs(userFFA.get(0)){
                
                //get a journal
                List<c2g__codaJournal__c> JournalList =
                    [
                        SELECT ID, Name , c2g__Type__c, c2g__Year__c, c2g__Period__r.Name
                        FROM c2g__codaJournal__c 
                        WHERE  c2g__JournalCurrency__r.c2g__OwnerCompany__r.name='Sanergy Limited' 
                        AND c2g__Type__c ='Manual Journal'
                        ORDER BY c2g__Period__r.Name DESC, CreatedDate DESC
                        LIMIT 1
                    ];
                if(JournalList.size()>0){
                    
                    /*  AggregateResult[] aggr = [ Select count(Id) 
FROM Payroll_Group_Detail__c 
Where Tax_Batch__c = null 
And CreatedDate >= 2012-07-21T00:00:00-05:00 
And Total_Tax_Amount__c != null
Group By Total_Tax_Amount__c ];

Integer counter = Integer.valueOf(aggr.size());

System.debug('#### counter: ' + counter);*/
                    

                    PageReference pageRef = Page.Clone_Journal;
                    Test.setCurrentPage(pageRef);
                    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(JournalList.get(0));
                    ApexPages.currentPage().getParameters().put('Id',JournalList.get(0).id);
                    CloneJournalController controller = new CloneJournalController(sc);
                    
                    controller.cloneJournal();
                } 
            }
        }       
    }
}