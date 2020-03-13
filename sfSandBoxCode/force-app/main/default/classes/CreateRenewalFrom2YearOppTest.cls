@isTest 
public class CreateRenewalFrom2YearOppTest{
     
     /*--------Test creation of renewal opportunity from 2 year opportunity---------- */
  
      static testMethod void CreateRenewalFrom2YearOpportunity() {
      /*
               //insert Account
               account Ac=new account(
                                      Name='Acc',
                                      CurrencyIsoCode='KES' 
                                       );                        
               insert Ac;
               
               //insert Contact
               contact con=new contact(
                                      
                                         lastname='Onyando',
                                         Sex__c='Male'
                                       );
              insert con;
               
               Sub_Area__c sa=new Sub_Area__c(Name='SA1',
                                          Area__c='Tassia');
           insert sa;
          
           //insert Location
           Location__c loc=new Location__c(
                                           Name='KB1',
                                           Franchise_Type__c='Hybrid-Plot',
                                           CurrencyIsoCode='KES',
                                           Sub_Area__c=sa.ID);
           insert loc;
           
               //insert Opportunity
               Opportunity op=new Opportunity(
                                               Name='ops',
                                               AccountId=Ac.ID,
                                               StageName='Deposit Paid',
                                               CloseDate=Date.today(),
                                               Primary_Salesperson__c=con.ID,
                                               GR_Approval_Status__c='Approved',
                                               AM_Approval_Status__c='Approved',
                                               Deposit_Paid_Date__c=Date.Today(),
                                               Financing_Method__c='Credit',
                                               Specific_Financing_Method__c='1 Year Loan',
                                               Expected_Deposit_Amount__c=12000,
                                               No_of_FLTs__c=2,
                                               CM_Deposit__c=true,
                                             
                                               Existing_FLO__c=false);
                                               
               Insert op;
               
                Toilet__c toilet=new Toilet__c(
                                       Name='KB1.1',
                                       Location__c=loc.ID,
                                       Opening_Date__c=Date.today(),
                                       Opportunity__c=op.ID,
                                       Operational_Status__c='Open',
                                       Current_Specific_Status__c='Open - New',
                                       Collection_Route__c='KR Collection Center'
                                       );
                                       
                 insert toilet;
                 
                Test.startTest();
                 op.Actual_Launch_Date__c=Date.today();
                 op.Location__c=loc.id;
                 op.StageName='FLO Launched';
                 
                 update op;
                 
               Test.stopTest();
                 
               */
      
      }
}