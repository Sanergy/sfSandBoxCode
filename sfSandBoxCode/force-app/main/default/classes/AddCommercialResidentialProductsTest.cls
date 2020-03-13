@isTest(seeAllData=true)
private class AddCommercialResidentialProductsTest{
    static testMethod void upfront() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                 
        accountList.add(Ac);    
        insert accountList;
        
        //create Contact
        List<Contact> conList=new List<Contact>();
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        Contact con2=new Contact(lastname='Onyando',Sex__c='Male');
        conList.add(con);
        conList.add(con2);
        insert conList;
        
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get a subarea
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];
        
        List<Location__c> loc=[SELECT id FROM Location__c LIMIT 1];
        
        List<Opportunity> opList=new List<Opportunity>();
        
        Opportunity opCommercialUpfrontExistingFLO=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Upfront',
            Loan_Duration__c='Upfront Payment',
            Pit_Conversion__c=true,
            Existing_FLO__c=true,
            Existing_Location__c=true,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        
        Opportunity opCommercialUpfrontNewFLO=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Upfront',
            Loan_Duration__c='Upfront Payment',
            Pit_Conversion__c=true,
            Existing_FLO__c=False,
            Existing_Location__c=False,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        
        opList.add(opCommercialUpfrontExistingFLO);
        opList.add(opCommercialUpfrontNewFLO);
        insert opList;
        
        Opportunity opCommercialUpfrontExistingFLOandNewLoc=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Upfront',
            Loan_Duration__c='Upfront Payment',
            Pit_Conversion__c=true,
            Existing_FLO__c=TRUE,
            Existing_Location__c=FALSE,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        INSERT opCommercialUpfrontExistingFLOandNewLoc;
        test.startTest();       
        
        AddCommercialResidentialProducts comResEF=new AddCommercialResidentialProducts(opCommercialUpfrontExistingFLO);
        comResEF.addProducts();
        
        AddCommercialResidentialProducts comResNF=new AddCommercialResidentialProducts(opCommercialUpfrontNewFLO);
        comResNF.addProducts();
        
        AddCommercialResidentialProducts comResEFNL=new AddCommercialResidentialProducts(opCommercialUpfrontExistingFLOandNewLoc);
        comResEFNL.addProducts();
        test.stopTest();        
    }
    
    /*---------------------------------Test for the Adding Residential products---------------------------------*/
    static testMethod void oneYear() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                 
        accountList.add(Ac);    
        insert accountList;
        
        //create Contact
        List<Contact> conList=new List<Contact>();
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        Contact con2=new Contact(lastname='Onyando',Sex__c='Male');
        conList.add(con);
        conList.add(con2);
        insert conList;
        
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get a subarea
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];        
        List<Location__c> loc=[SELECT id FROM Location__c LIMIT 1];        
        List<Opportunity> opList=new List<Opportunity>();
        
        Opportunity opCommercialUpfrontExistingFLO=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Credit',
            Loan_Duration__c='One Year',
            Pit_Conversion__c=true,
            Existing_FLO__c=true,
            Existing_Location__c=true,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        
        Opportunity opCommercialUpfrontNewFLO=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Credit',
            Loan_Duration__c='One Year',
            Pit_Conversion__c=true,
            Existing_FLO__c=False,
            Existing_Location__c=False,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        
        Opportunity opCommercialUpfrontExistingFLONewLocOneYear=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Credit',
            Loan_Duration__c='One Year',
            Pit_Conversion__c=true,
            Existing_FLO__c=TRUE,
            Existing_Location__c=FALSE,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        //Add to List
        opList.add(opCommercialUpfrontExistingFLO);
        opList.add(opCommercialUpfrontNewFLO);
        opList.add(opCommercialUpfrontExistingFLONewLocOneYear);
        insert opList;
        
        
        test.startTest();       
        
        AddCommercialResidentialProducts comResEF=new AddCommercialResidentialProducts(opCommercialUpfrontExistingFLO);
        comResEF.addProducts();
        
        AddCommercialResidentialProducts comResNF=new AddCommercialResidentialProducts(opCommercialUpfrontNewFLO);
        comResNF.addProducts();
        
        AddCommercialResidentialProducts comResEFNL1Y=new AddCommercialResidentialProducts(opCommercialUpfrontExistingFLONewLocOneYear);
        comResEFNL1Y.addProducts();
        test.stopTest();
    }
    
    /*---------------------------------Test for the Adding Residential products---------------------------------*/
    static testMethod void lease() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                 
        accountList.add(Ac);    
        insert accountList;
        
        //create Contact
        List<Contact> conList=new List<Contact>();
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        Contact con2=new Contact(lastname='Onyando',Sex__c='Male');
        conList.add(con);
        conList.add(con2);
        insert conList;
        
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get a subarea
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];
        List<Location__c> loc=[SELECT id FROM Location__c LIMIT 1];
        List<Opportunity> opList=new List<Opportunity>();     
        
        Opportunity opCommercialUpfrontNewFLO=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial',
            No_of_FLTs__c=2,
            Financing_Method__c='Credit',
            Loan_Duration__c='Lease',
            Pit_Conversion__c=true,
            Existing_FLO__c=False,
            Existing_Location__c=False,
            Location__c=loc.get(0).id,
            FLTs_Approved__c=2
        );
        
        opList.add(opCommercialUpfrontNewFLO);
        insert opList;
        
        test.startTest();       

        AddCommercialResidentialProducts comResNF=new AddCommercialResidentialProducts(opCommercialUpfrontNewFLO);
        comResNF.addProducts();
        
        test.stopTest();
    }
}