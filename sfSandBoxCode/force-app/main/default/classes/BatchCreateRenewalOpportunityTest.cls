@isTest
private class BatchCreateRenewalOpportunityTest  {
    
    
    /*------------------Test Class for the auto-creation of batch opportunities------------------------- */  
    static testMethod void createBatchRenewalOpps() {
        
        /*--------------------Create a dummy toilet and a dummy opportunity----------------------------------*/
        //insert Account
        Account Ac=new Account(
            Name='Acc',
            CurrencyIsoCode='KES' 
        );                        
        insert Ac;
        
        //insert Contact
        Contact con=new Contact(
            
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
        
        //get the date ten months ago
        Date dateTenMonthsAgo=Date.Today().addMonths(-10);
        
        //insert Opportunity
        Opportunity op=new Opportunity(
            Name='ops',
            AccountId=Ac.ID,
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            StageName='Renewal - In Progress',
            Financing_Method__c='Upfront',
            Specific_Financing_Method__c='Upfront',
            Actual_Launch_Date__c=dateTenMonthsAgo
        );
        
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
        
        /*----------------------End of creation of toilet and opportunity------------------------------------*/
        
        batchCreateRenewalOpportunity batch=new batchCreateRenewalOpportunity();
        database.executeBatch(batch,100);
    }
    
    
    
    static testMethod void testBatchRenewalScheduler() {
        Test.StartTest();
        RenewalOpportunityCreator.scheduleThis();
        Test.StopTest();
        
    }
    
}