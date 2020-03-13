@isTest(SeeAllData=true)
private class CreateNewFollowUpTriggerTest {
    static testMethod void CreateFollowUp() {
        
       //insert Account
       Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES');                        
       insert Ac;
             
       //insert Contact
       Contact con=new Contact(lastname='Onyando',Sex__c='Male');
       insert con;
       
       //get employee
       Employee__c emp=[SELECT id FROM Employee__c LIMIT 1];
       //insert Opportunity
        Opportunity op=new Opportunity(
                    Name='x',
                    RecordTypeId='012D0000000KGB7IAO',
                    StageName='Pending Resale',
                    AccountId=Ac.id,
                    CloseDate=Date.today().addMonths(3),
                    Phone_Number__c='254700000000',
                    Free_or_Discounted_Trial__c='No',
                    Sales_Order_Signed__c='No',
                    Payment_Method__c='Cash',
                    Payment_Schedule__c='Upfront',
                    Delivery__c='Delivery instructions',
                    Delivery_Method__c='Delivery',
                    Preferred_Delivery_Pickup_Date_Time__c=Datetime.now()
                );
         Insert op;
         
         Ag_Sales_Followup__c agFollowup=new Ag_Sales_Followup__c(
             Name='x',
             Opportunity_Name__c=op.id,
             Employee__c=emp.id,
             Planned_Date__c=Date.today(),
             Comments__c='comments',
             Task__c='Task'
         );
         
         insert agFollowup;
         
         agFollowup.Next_Followup_Date__c=Date.today()+1;
         
         update agFollowup;
       
       }
}