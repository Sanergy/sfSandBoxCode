@isTest 
public class CreateFranchiseeHistoryRecordFrmAccTest{      
    
    /*--------Test creation of renewal opportunity from 2 year opportunity---------- */
    
    static testMethod void CreateFranchiseeHistoryRecordFrAcc() {        
        
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
        
        // Create Location  
        Location__c loc = new Location__c();
        loc.Name = 'NRB-20';
        loc.Last_FLT__c = 0;
        loc.Franchise_Type__c = 'Hybrid-Plot';
        loc.Sub_Area__c = 'a09D000000JZ1eH';//subArea.Id;--Diamond
        INSERT loc;
        
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
        
        //Run test as TEMP RS        
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {            
            INSERT op;
        }//End System.runAs(u)
        
        Toilet__c toilet=new Toilet__c(
            Name='NRB-20.1',
            Location__c=loc.ID,
            Opening_Date__c=Date.today(),
            Opportunity__c=op.ID,
            Operational_Status__c='Open',
            Current_Specific_Status__c='Open - New',
            Collection_Route__c='KR Collection Center'
        );
        
        INSERT toilet;
        
        Test.startTest();
        
        //User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            //change the account name to call the CreateFranchiseeHistoryRecordFrmAcc trigger
            Ac.name='Acc2';
            update Ac;
        }
        
        Test.stopTest();
        
    }
}