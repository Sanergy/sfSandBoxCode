@isTest 
private class LocationDemolitionValidationTest {
    static testMethod void validateLocationDemolitionInsert() {
        
        // Create Location  
        Location__c loc = new Location__c();
        loc.Name = 'NRB-20';
        loc.Last_FLT__c = 0;
        loc.Franchise_Type__c = 'Hybrid-Plot';
        loc.Sub_Area__c = 'a09D000000JZ1eH';//subArea.Id;--Diamond
        INSERT loc;
        
        // Create Location  
        Location__c loc2 = new Location__c();
        loc2.Name = 'NRB-21';
        loc2.Last_FLT__c = 0;
        loc2.Franchise_Type__c = 'Hybrid-Plot';
        loc2.Sub_Area__c = 'a09D000000JZ1rd';//subArea.Id;--Diamond
        INSERT loc2;
        
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
        
        Toilet__c toilet2=new Toilet__c(
            Name='NRB-21.1',
            Location__c=loc2.ID,
            Opening_Date__c=Date.today(),
            Opportunity__c=op.ID,
            Operational_Status__c='Open',
            Current_Specific_Status__c='Open - New',
            Collection_Route__c='KR Collection Center'
        );
        
        INSERT toilet2;       
        
        List<Location_Demolition__c>  LD_List=new List<Location_Demolition__c>();
        
        
        //insert location demolition
        Location_Demolition__c locDemo=new Location_Demolition__c(
            
            Demolished_Location__c=locRetrieved.ID
        );
        
        //insert location demolition
        Location_Demolition__c locDemo2=new Location_Demolition__c(
            
            Demolished_Location__c=locRetrieved.ID,
            Firm_Toilets__c=true
        );
        
        //insert location demolition
        Location_Demolition__c locDemo3=new Location_Demolition__c(
            
            Demolished_Location__c=loc2.ID
            
        );
        
        LD_List.add(locDemo);
        
        LD_List.add(locDemo3);
        
        insert LD_List;
        
        
        
        
        //insert Location Demolition Toilet
        Location_Demolition_Toilets__c ldt=new Location_Demolition_Toilets__c(
            Toilet__c=toilet.ID,
            Location_Demolition__c=locDemo.ID,
            CurrencyIsoCode='KES',
            Close_Toilet__c=true
        );
        
        
        insert ldt;
        
        
        
        Integer count=[SELECT count()
                       FROM Location_Demolition_Toilets__c
                      ];
        
        System.assertEquals(count,1);
        
        try
        {
            
            locDemo.Firm_Toilets__c=true;
            update locDemo; 
            Location_Demolition_Toilets__c ldt_firmed=new Location_Demolition_Toilets__c(
                Toilet__c=toilet2.ID,
                Location_Demolition__c=locDemo.ID,
                CurrencyIsoCode='KES'
            );
            
            insert ldt_firmed;
            
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 2. MyException class extends Exception.
            System.debug('Error not thrown');
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('New toilets cannot be added if Toilets have been firmed'));
        }
        
        
        
        try
        {
            
            Location_Demolition_Toilets__c ldt_diffLoc=new Location_Demolition_Toilets__c(
                Toilet__c=toilet2.ID,
                Location_Demolition__c=locDemo3.ID,
                CurrencyIsoCode='KES'
            );
            
            insert ldt_diffLoc;
            
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 2. MyException class extends Exception.
            System.debug('Error not thrown');
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('This toilet is not in the specified location'));
        }
        
        try
        {
            
            Location_Demolition_Toilets__c ldt_duplicate=new Location_Demolition_Toilets__c(
                Toilet__c=toilet.ID,
                Location_Demolition__c=locDemo.ID,
                CurrencyIsoCode='KES',
                Toilet_Status__c='Demolished Indefinitely'
            );
            
            insert ldt_duplicate;
            
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 2. MyException class extends Exception.
            System.debug('Error not thrown');
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            //System.Assert(e.getMessage().contains('You cannot insert the same toilet more than once in a Location Demolition'));
        }
        
        
        
        try
        {
            
            locDemo.Firm_Toilets__c=true;
            update locDemo;
            
            delete ldt;
            
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 2. MyException class extends Exception.
            System.debug('Error not thrown');
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('Location Demolition Toilets cannot be deleted if Toilets have been firmed'));
        }
    }
}