@istest(seeAllData=true)
public class CreateLeadFromSAPresentationsTest {
      //test for CreateLeadFromSAPresentations trigger
    static testMethod void CreateLeadFromSAPresentationsTest() {
        
         SA_Presentations__c ld=new SA_Presentations__c(
                Company__c='s',
          	    Last_Name__c='John', 
                First_name__c='Somebody',
                Phone__c='0701234567'
               // Sub_Area__c='Jogoo Road'                                             
            );
            
            insert ld;     
        
        test.StartTest();
        PageReference pageRef = Page.CreateLeadFromSAP;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ld);
        CreateLeadFromSAPresentation controller = new CreateLeadFromSAPresentation(sc);
        controller.createLead();
        test.StopTest(); 
    }
    
}