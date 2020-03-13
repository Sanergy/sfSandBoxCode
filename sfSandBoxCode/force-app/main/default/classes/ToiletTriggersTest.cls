@isTest 
private class ToiletTriggersTest {
    static testMethod void validateToiletUpdate() {
        
        // Create Location  
        Location__c loc = new Location__c();
        loc.Name = 'NRB-20';
        loc.Last_FLT__c = 0;
        loc.Franchise_Type__c = 'Hybrid-Plot';
        loc.Sub_Area__c = 'a09D000000JZ1eH';//subArea.Id;--Diamond
        INSERT loc;
        
        Location__c locRetrieved=[SELECT ID, No_of_Open_toilets__c
                                  FROM Location__c
                                  WHERE Name='NRB-20'];
        
        System.assertEquals(locRetrieved.No_of_Open_toilets__c , 0);
        
        
        //insert Account
        Account Ac=new Account(
            
            Name='Acc',
            CurrencyIsoCode='KES' 
        );                        
        insert Ac;
        Account AcRetrieved=[SELECT ID
                             FROM Account
                             WHERE Name='Acc'];
        
        
        
        //insert Contact
        Contact con=new Contact(
            
            lastname='Onyando',
            Sex__c='Male'
        );
        insert con;
        Contact conRetrieved=[SELECT ID
                              FROM Contact
                              WHERE lastname='Onyando'];
        
        
        //insert Opportunity
        Opportunity op=new Opportunity(
            Name='ops',
            AccountId=AcRetrieved.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=conRetrieved.ID
            
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
        
        toilet.Current_Specific_Status__c='Open - Relocated';
        update toilet;
        
        locRetrieved=[SELECT ID, No_of_Open_toilets__c
                      FROM Location__c
                      WHERE Name='NRB-20'];
        
        System.assertEquals(locRetrieved.No_of_Open_toilets__c , 1);                       
        
        
    }
}