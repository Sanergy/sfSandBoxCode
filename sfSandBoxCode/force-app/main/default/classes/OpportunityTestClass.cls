@isTest(seeAllData=true)
public class OpportunityTestClass {    
    
    /*---------------------------------Test for the Application management----------------------------------*/
    static testMethod void CreateToiletSaleOpportunity_ApplicationManagement() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                        
        Account AcNew=new Account(Name='AccNew', CurrencyIsoCode='KES');            
        accountList.add(Ac);            
        accountList.add(AcNew);
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
        List<Opportunity> opList=new List<Opportunity>();
        //Create two Opportunities
        Opportunity opSchool=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='School'
        );
        
        Opportunity opCommercial=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial'
        );
        
        opList.add(opSchool);
        opList.add(opCommercial);
        
        //start test
        test.startTest();
        
        Insert opList;
        
        /*-----------------------Application Management fields-------------------------*/
        
        //change Id
        opSchool.AccountId=AcNew.id;
        opSchool.Primary_Salesperson__c=con2.id;
        
        //GR STUFF
        opSchool.Location_confirmed_date__c=Date.today();
        opSchool.GR_Checklist_signed_Date__c=Date.today();
        opSchool.Government_Signatures_Received__c=true;
        opSchool.GR_Checklist_signed_by_AGRO__c=true;
        
        
        //APPLICATION STUFF
        opSchool.No_of_FLTs__c=2;
        opSchool.Financing_Method__c='Upfront';
        opSchool.GPS_Latitude__c=1.000000;
        opSchool.GPS_Longitude__c=10.000000;
        opSchool.Pre_app_Signed_Date__c=Date.today();
        opSchool.SA_Approved_Land__c=true;
        opSchool.Pre_app_Submitted_and_Signed__c=true;
        opSchool.Initial_Land_review_Submitted_and_Signed__c=true;
        opSchool.Location_Within_Operational_Areas__c=true;
        opSchool.App_Pt_2_received__c=true;
        opSchool.Expected_Deposit_Amount__c=10000;
        opSchool.Expected_Deposit_Payment_date__c=Date.today();
        opSchool.App2_date__c=Date.today();
        
        //DEPOSIT STUFF
        opSchool.Deposit_Amount_Received__c=10000;
        opSchool.Deposit_Paid_Date__c=Date.today();
        opSchool.CM_Deposit__c=true;
        
        update opSchool;
        
        System.debug(opSchool.recordTypeId);
        System.debug(opSchool.stageName);
        
        List<Opportunity_History_Records__c> ohrList=[SELECT Event__c FROM Opportunity_History_Records__c WHERE Opportunity__c=:opSchool.id];
        
        for(Opportunity_History_Records__c ohr:ohrList ){
            System.debug(ohr.Event__c ); 
        }    
        
        test.stopTest();
    }
    

    /*---------------------------------Test for the Deposit management----------------------------------*/
    static testMethod void CreateToiletSaleOpportunity_DepositManagement() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                        
        Account AcNew=new Account(Name='AccNew', CurrencyIsoCode='KES');            
        accountList.add(Ac);            
        accountList.add(AcNew);
        insert accountList;
        
        //create Contact
        List<Contact> conList=new List<Contact>();
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        Contact con2=new Contact(lastname='Onyando',Sex__c='Male');
        conList.add(con);
        conList.add(con2);
        insert conList;
        
        //Test ContactCtrl Class
		ApexPages.Standardcontroller scCon = new ApexPages.Standardcontroller(con);
        ContactCtrl conController = new ContactCtrl(scCon);
        conController.refresh();
        
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get a subarea
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];
        
        List<Opportunity> opList=new List<Opportunity>();
        //Create two Opportunities
        Opportunity opSchool=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='School'
        );
        
        Opportunity opCommercial=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial'
        );
        
        opList.add(opSchool);
        opList.add(opCommercial);
        
        Insert opList;
        
        /*-----------------------Application Management fields-------------------------*/
        
        //GR STUFF
        opSchool.Location_confirmed_date__c=Date.today();
        opSchool.GR_Checklist_signed_Date__c=Date.today();
        opSchool.Government_Signatures_Received__c=true;
        opSchool.GR_Checklist_signed_by_AGRO__c=true;
        
        
        //APPLICATION STUFF
        opSchool.No_of_FLTs__c=2;
        opSchool.Financing_Method__c='Upfront';
        opSchool.GPS_Latitude__c=1.000000;
        opSchool.GPS_Longitude__c=10.000000;
        opSchool.Pre_app_Signed_Date__c=Date.today();
        opSchool.SA_Approved_Land__c=true;
        opSchool.Pre_app_Submitted_and_Signed__c=true;
        opSchool.Initial_Land_review_Submitted_and_Signed__c=true;
        opSchool.Location_Within_Operational_Areas__c=true;
        opSchool.App_Pt_2_received__c=true;
        opSchool.Expected_Deposit_Amount__c=10000;
        opSchool.Expected_Deposit_Payment_date__c=Date.today();
        opSchool.App2_date__c=Date.today();
        
        //DEPOSIT STUFF
        opSchool.Deposit_Amount_Received__c=10000;
        opSchool.Deposit_Paid_Date__c=Date.today();
        opSchool.CM_Deposit__c=true;
        
        //FINANCE STUFF
        opSchool.Loan_Duration__c='Upfront payment';
        opSchool.FLTs_Approved__c=2;
        
        update opSchool;
        
        test.startTest();
        
        opSchool.Franchise_Type__c='Commercial';
        update opSchool;
        opSchool.Franchise_Type__c='School';
        update opSchool;
        
        //add products
        PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchool);
        OpportunityProductsController oppController = new OpportunityProductsController(sc);
        oppController.addProducts();
        
        opSchool.CM__c=true;
        update opSchool;
        
        test.stopTest();    
    }
    
    
    /*---------------------------------Test for the Launch management----------------------------------*/
    static testMethod void CreateToiletSaleOpportunity_LaunchManagement() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                        
        Account AcNew=new Account(Name='AccNew', CurrencyIsoCode='KES');            
        accountList.add(Ac);            
        accountList.add(AcNew);
        insert accountList;
        
        //create Contact
        List<Contact> conList=new List<Contact>();
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        Contact con2=new Contact(lastname='Onyando',Sex__c='Male');
        conList.add(con);
        conList.add(con2);
        insert conList;
        
        List<Location__c> loc=[SELECT id FROM Location__c LIMIT 1];
        
        
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get a subarea
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];
        
        List<Opportunity> opList=new List<Opportunity>();
        //Create two Opportunities
        Opportunity opSchool=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='School'
        );
        
        Opportunity opCommercial=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Pending Credit Approval',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial'
        );
        
        opList.add(opSchool);
        opList.add(opCommercial);
        
        Insert opList;
        
        /*-----------------------Application Management fields-------------------------*/
        
        //GR STUFF
        opSchool.Location_confirmed_date__c=Date.today();
        opSchool.GR_Checklist_signed_Date__c=Date.today();
        opSchool.Government_Signatures_Received__c=true;
        opSchool.GR_Checklist_signed_by_AGRO__c=true;
        
        
        //APPLICATION STUFF
        opSchool.No_of_FLTs__c=2;
        opSchool.Financing_Method__c='Upfront';
        opSchool.GPS_Latitude__c=1.000000;
        opSchool.GPS_Longitude__c=10.000000;
        opSchool.Pre_app_Signed_Date__c=Date.today();
        opSchool.SA_Approved_Land__c=true;
        opSchool.Pre_app_Submitted_and_Signed__c=true;
        opSchool.Initial_Land_review_Submitted_and_Signed__c=true;
        opSchool.Location_Within_Operational_Areas__c=true;
        opSchool.App_Pt_2_received__c=true;
        opSchool.Expected_Deposit_Amount__c=10000;
        opSchool.Expected_Deposit_Payment_date__c=Date.today();
        opSchool.App2_date__c=Date.today();
        
        //DEPOSIT STUFF
        opSchool.Deposit_Amount_Received__c=10000;
        opSchool.Deposit_Paid_Date__c=Date.today();
        opSchool.CM_Deposit__c=true;
        
        /*-----------------------Deposit Management fields-------------------------*/
        //FINANCE STUFF
        opSchool.Loan_Duration__c='Upfront payment';
        opSchool.FLTs_Approved__c=2;
        
        update opSchool;
        
        //add products
        PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchool);
        OpportunityProductsController oppController = new OpportunityProductsController(sc);
        oppController.addProducts();
        
        opSchool.CM__c=true;
        update opSchool;

        test.startTest();
        //INSTALLATION STUFF
        
        opSchool.FLR_Date__c=Date.today();
        opSchool.Upstructures_Required__c=2.0;
        opSchool.Location__c=loc.get(0).id;
        opSchool.Installation_Checklist_Signed_date__c=Date.today();
        opSchool.Installation_Checklist_Signed__c=true;
        opSchool.CM_Install_Approved__c=true;
        opSchool.Installation_Scheduled_Stage_Entry_Date__c=Date.today();
        opSchool.Planned_Installation_End_date__c=Date.today();
        opSchool.Existing_Location__c=true;
        opSchool.Existing_FLO__c=true;
        update opSchool;
        
        //add engineering Items
        pageRef = Page.AddOpportunityItems;
        Test.setCurrentPage(pageRef);
        sc = new ApexPages.Standardcontroller(opSchool);
        AddOppItemsController oppIemsController = new AddOppItemsController(sc);
        oppIemsController.fltVersion='V2';
        oppIemsController.createItems();

        //add engineering Items
        pageRef = Page.AddOpportunityItems;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller scV2V3 = new ApexPages.Standardcontroller(opSchool);
        AddOppItemsController oppIemsControllerV2V3 = new AddOppItemsController(scV2V3);
        oppIemsControllerV2V3.fltVersion='V2-V3 Hybrid';
        oppIemsControllerV2V3.createItems();        
        List<SelectOption> fltVersions = new List<SelectOption>();
        System.debug(oppIemsControllerV2V3.fltVersions);
        
        //add engineering Items
        pageRef = Page.AddOpportunityItems;
        Test.setCurrentPage(pageRef);
        sc = new ApexPages.Standardcontroller(opSchool);
        AddOppItemsController oppIemsControllerBFLT = new AddOppItemsController(sc);
        oppIemsControllerBFLT.fltVersion='Basic FLT';
        oppIemsControllerBFLT.createItems();    
        
        //add BiB Items
        pageRef = Page.AddLaunchItems;
        Test.setCurrentPage(pageRef);
        sc = new ApexPages.Standardcontroller(opSchool);
        AddLaunchItemsController oppLaunchIemsController = new AddLaunchItemsController(sc);
        oppLaunchIemsController.createItems();
        
        
        opSchool.BIB_Items_Approved__c=true;
        opSchool.Engineering_Items_Approved__c=true;
        opSchool.Marketing_Items_Approved__c=true;
        
        
        
        opSchool.First_day_of_Actual_Installation__c=Date.today();
        opSchool.Installation_Complete_Date__c=Date.today();
        opSchool.Actual_Launch_Date__c=Date.today();
        opSchool.Training_Scheduled_Date__c=Date.today();
        opSchool.Training_date__c=Date.today();
        
        // Get user Temp RS Account
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u) {
            // Launch FLO
            opSchool.stageName='Launched';
            UPDATE opSchool;
        }
        //launch FLO
        //opSchool.stageName='Launched';
        //UPDATE opSchool;
        
        //attempt to delete items after approval
        List<Opportunity_WO_Item__c> opItemList=[SELECT ID FROM Opportunity_WO_Item__c WHERE Opportunity__c=:opSchool.id];
        List<Opportunity_BIB_Item__c> opBibItemList=[SELECT ID FROM Opportunity_BIB_Item__c WHERE Opportunity__c=:opSchool.id];
        
        //remove engineering items
        if(opItemList.size()>0){
            try{
                delete opItemList.get(0);
            }catch(Exception e){}          
        }
        
        //remove bib items
        if(opBibItemList.size()>0){
            try{
                delete opBibItemList.get(0);
            }catch(Exception e){}          
        }
        
        
        
        test.stopTest();
        
    }
    
        /*---------------------------------Test for the Launch management----------------------------------*/
    static testMethod void CreateToiletSaleOpportunity_LaunchManagemenBasicFLT() {
        //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                        
        Account AcNew=new Account(Name='AccNew', CurrencyIsoCode='KES');            
        accountList.add(Ac);            
        accountList.add(AcNew);
        insert accountList;
        
        //create Contact
        List<Contact> conList=new List<Contact>();
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        Contact con2=new Contact(lastname='Onyando',Sex__c='Male');
        conList.add(con);
        conList.add(con2);
        insert conList;
        
        List<Location__c> loc=[SELECT id FROM Location__c LIMIT 1];
        
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get a subarea
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];
        
        List<Opportunity> opList=new List<Opportunity>();
        //Create two Opportunities
        Opportunity opSchool=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='School'
        );
        
        Opportunity opCommercial=new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=Ac.ID,
            StageName='Pending Credit Approval',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID,
            Sub_Area_Lookup__c=subArea.get(0).id,
            Franchise_Type__c='Commercial'
        );
        
        opList.add(opSchool);
        opList.add(opCommercial);
        
        Insert opList;
        
        /*-----------------------Application Management fields-------------------------*/
        
        //GR STUFF
        opSchool.Location_confirmed_date__c=Date.today();
        opSchool.GR_Checklist_signed_Date__c=Date.today();
        opSchool.Government_Signatures_Received__c=true;
        opSchool.GR_Checklist_signed_by_AGRO__c=true;
        
        
        //APPLICATION STUFF
        opSchool.No_of_FLTs__c=2;
        opSchool.Financing_Method__c='Upfront';
        opSchool.GPS_Latitude__c=1.000000;
        opSchool.GPS_Longitude__c=10.000000;
        opSchool.Pre_app_Signed_Date__c=Date.today();
        opSchool.SA_Approved_Land__c=true;
        opSchool.Pre_app_Submitted_and_Signed__c=true;
        opSchool.Initial_Land_review_Submitted_and_Signed__c=true;
        opSchool.Location_Within_Operational_Areas__c=true;
        opSchool.App_Pt_2_received__c=true;
        opSchool.Expected_Deposit_Amount__c=10000;
        opSchool.Expected_Deposit_Payment_date__c=Date.today();
        opSchool.App2_date__c=Date.today();
        
        //DEPOSIT STUFF
        opSchool.Deposit_Amount_Received__c=10000;
        opSchool.Deposit_Paid_Date__c=Date.today();
        opSchool.CM_Deposit__c=true;
        
        /*-----------------------Deposit Management fields-------------------------*/
        //FINANCE STUFF
        opSchool.Loan_Duration__c='Upfront payment';
        opSchool.FLTs_Approved__c=2;
        
        update opSchool;
        
        //add products
        PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchool);
        OpportunityProductsController oppController = new OpportunityProductsController(sc);
        oppController.addProducts();
        
        opSchool.CM__c=true;
        update opSchool;

        test.startTest();
        //INSTALLATION STUFF
        
        opSchool.FLR_Date__c=Date.today();
        opSchool.Upstructures_Required__c=2.0;
        opSchool.Location__c=loc.get(0).id;
        opSchool.Installation_Checklist_Signed_date__c=Date.today();
        opSchool.Installation_Checklist_Signed__c=true;
        opSchool.CM_Install_Approved__c=true;
        opSchool.Installation_Scheduled_Stage_Entry_Date__c=Date.today();
        opSchool.Planned_Installation_End_date__c=Date.today();
        opSchool.Existing_Location__c=true;
        opSchool.Existing_FLO__c=true;
        update opSchool;
        /*
        //add engineering Items
        pageRef = Page.AddOpportunityItems;
        Test.setCurrentPage(pageRef);
        sc = new ApexPages.Standardcontroller(opSchool);
        AddOppItemsController oppIemsController = new AddOppItemsController(sc);
        oppIemsController.fltVersion='V2';
        oppIemsController.createItems();

        //add engineering Items
        pageRef = Page.AddOpportunityItems;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller scV2V3 = new ApexPages.Standardcontroller(opSchool);
        AddOppItemsController oppIemsControllerV2V3 = new AddOppItemsController(scV2V3);
        oppIemsControllerV2V3.fltVersion='V2-V3 Hybrid';
        oppIemsControllerV2V3.createItems();        
        List<SelectOption> fltVersions = new List<SelectOption>();
        System.debug(oppIemsControllerV2V3.fltVersions);
        */
        //add engineering Items
        pageRef = Page.AddOpportunityItems;
        Test.setCurrentPage(pageRef);
        sc = new ApexPages.Standardcontroller(opSchool);
        AddOppItemsController oppIemsControllerBFLT = new AddOppItemsController(sc);
        oppIemsControllerBFLT.fltVersion='Basic FLT';
        oppIemsControllerBFLT.createItems();    
        
        //add BiB Items
        pageRef = Page.AddLaunchItems;
        Test.setCurrentPage(pageRef);
        sc = new ApexPages.Standardcontroller(opSchool);
        AddLaunchItemsController oppLaunchIemsController = new AddLaunchItemsController(sc);
        oppLaunchIemsController.createItems(); 
        
        opSchool.BIB_Items_Approved__c=true;
        opSchool.Engineering_Items_Approved__c=true;
        opSchool.Marketing_Items_Approved__c=true;

        opSchool.First_day_of_Actual_Installation__c=Date.today();
        opSchool.Installation_Complete_Date__c=Date.today();
        opSchool.Actual_Launch_Date__c=Date.today();
        opSchool.Training_Scheduled_Date__c=Date.today();
        opSchool.Training_date__c=Date.today();
        
        // Get user Temp RS Account
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u) {
            // Launch FLO
            opSchool.stageName='Launched';
            UPDATE opSchool;
        }
        //launch FLO
        //opSchool.stageName='Launched';
        //UPDATE opSchool;
        
        //attempt to delete items after approval
        List<Opportunity_WO_Item__c> opItemList=[SELECT ID FROM Opportunity_WO_Item__c WHERE Opportunity__c=:opSchool.id];
        List<Opportunity_BIB_Item__c> opBibItemList=[SELECT ID FROM Opportunity_BIB_Item__c WHERE Opportunity__c=:opSchool.id];
        
        //remove engineering items
        if(opItemList.size()>0){
            try{
                delete opItemList.get(0);
            }catch(Exception e){}          
        }
        
        //remove bib items
        if(opBibItemList.size()>0){
            try{
                delete opBibItemList.get(0);
            }catch(Exception e){}          
        }
        test.stopTest();
        
    }
    
    static testMethod void CreatePitConversionWorkOrder(){
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            //Create Account
            Account account1 = new Account();
            account1.Name='John Doe';
            account1.CurrencyIsoCode = 'KES';
            INSERT account1;
            
            System.debug('account1 = ' + account1);          
            
            //Create a Contact
            Contact salesPerson = new Contact();
            salesPerson.FirstName = 'Jane';
            salesPerson.LastName = 'Doe';
            salesPerson.Sex__c = 'Female';
            salesPerson.AccountId = account1.Id;
            INSERT salesPerson;
            
            System.debug('salesPerson = ' + salesPerson);
            
            //Create Toilet Sale Opportunity 
            Opportunity toiletSaleOpportunity = new Opportunity();
            toiletSaleOpportunity.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management 
            toiletSaleOpportunity.StageName ='Pending Govt Approval';          
            toiletSaleOpportunity.AccountId = account1.Id;
            toiletSaleOpportunity.Name = account1.Name;
            toiletSaleOpportunity.Primary_Salesperson__c = salesPerson.Id;
            toiletSaleOpportunity.CloseDate =  date.today() + 30;
            toiletSaleOpportunity.FLTs_Approved__c = 1;
            toiletSaleOpportunity.Pit_Conversion__c = true;
            toiletSaleOpportunity.Basic_FLT__c = false;
            toiletSaleOpportunity.No_of_approved_pit_s_to_be_converted__c = 1;
            
            INSERT toiletSaleOpportunity;
            
            System.debug('toiletSaleOpportunity = ' + toiletSaleOpportunity);        
            
            //Create Pit Conversion Items
            PageReference pageRef = Page.PitConversionItems;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(toiletSaleOpportunity);
            PitConversionItems pitConversionItems = new PitConversionItems(sc);
            pitConversionItems.createPitConversionItems();
            
            //Create Engineering Items for V2
            pageRef = Page.AddOpportunityItems;
            Test.setCurrentPage(pageRef);
            sc = new ApexPages.Standardcontroller(toiletSaleOpportunity);
            AddOppItemsController oppIemsController = new AddOppItemsController(sc);
            oppIemsController.fltVersion='V2';
            oppIemsController.createItems();       
            
            //Create BiB Items
            pageRef = Page.AddLaunchItems;
            Test.setCurrentPage(pageRef);
            sc = new ApexPages.Standardcontroller(toiletSaleOpportunity);
            AddLaunchItemsController oppLaunchIemsController = new AddLaunchItemsController(sc);
            oppLaunchIemsController.createItems();        
            
            toiletSaleOpportunity.BIB_Items_Approved__c=true;
            toiletSaleOpportunity.Engineering_Items_Approved__c=true;
            toiletSaleOpportunity.Marketing_Items_Approved__c=true;
            toiletSaleOpportunity.Pit_Conversion_Items_Approved__c=true;
            UPDATE toiletSaleOpportunity;        
            
            Test.startTest();
            
            //Create BIB, Structure ,Pit Conversion,Basic FLT Work Orders
            pageRef = Page.CreateOppWorkOrders;
            Test.setCurrentPage(pageRef);
            sc = new ApexPages.Standardcontroller(toiletSaleOpportunity);
            OppWorkOrdersController oppWOController = new OppWorkOrdersController(sc);
            oppWOController.createOrders();
            
            Test.stopTest();
            
            //Update Opportunity
            toiletSaleOpportunity.Basic_FLT__c = true;
            UPDATE toiletSaleOpportunity;        
            
            //Create Engineering Items      
            PageReference pageRef2 = Page.AddOpportunityItems;
            Test.setCurrentPage(pageRef2);
            ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(toiletSaleOpportunity);
            AddOppItemsController oppIemsController2 = new AddOppItemsController(sc2);
            oppIemsController2.fltVersion='Basic FLT';
            oppIemsController2.createItems(); 
            
            //Create Structure Work Order
            pageRef2 = Page.CreateOppWorkOrders;
            Test.setCurrentPage(pageRef2);
            sc2 = new ApexPages.Standardcontroller(toiletSaleOpportunity);
            OppWorkOrdersController oppWOController2 = new OppWorkOrdersController(sc2);
            oppWOController2.createOrders();       
            
            //Test if Work orders have already been created
            oppWOController2.createOrders();      
        }
    }
        
        /*---------------------------------Test for the Adding School upfront products---------------------------------*/
        static testMethod void CreateToiletSaleOpportunity_SchoolProducts() {
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
            
            
            
            Opportunity opSchoolUpfront=new Opportunity(
                RecordTypeId=rt.get(0).id,
                Name='x',
                AccountId=Ac.ID,
                StageName='Sale Open',
                CloseDate=Date.today(),
                Primary_Salesperson__c=con.ID,
                Sub_Area_Lookup__c=subArea.get(0).id,
                Franchise_Type__c='School',
                No_of_FLTs__c=2,
                Financing_Method__c='Credit',
                Loan_Duration__c='6 Months',
                Pit_Conversion__c=true,
                Existing_FLO__c=true,
                Existing_Location__c=true,
                Location__c=loc.get(0).id,
                FLTs_Approved__c=2
            );
            opList.add(opSchoolUpfront);
            insert opList;
            
            
            test.startTest();       
            
            
            //add products(Upfront, existing location=true)
            PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchoolUpfront);
            OpportunityProductsController oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            opSchoolUpfront.Existing_Location__c=false;
            update opSchoolUpfront;
            
            //add products(Upfront, existing location=false)
            pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            sc = new ApexPages.Standardcontroller(opSchoolUpfront);
            oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            
            //remove all products
            oppController.removeAllProducts();
            
            
            
            test.stopTest();
            
        }
        
        /*---------------------------------Test for the Adding Residential products---------------------------------*/
        static testMethod void CreateToiletSaleOpportunity_ResidentialProducts() {
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
            
            
            
            Opportunity opSchoolUpfront=new Opportunity(
                RecordTypeId=rt.get(0).id,
                Name='x',
                AccountId=Ac.ID,
                StageName='Sale Open',
                CloseDate=Date.today(),
                Primary_Salesperson__c=con.ID,
                Sub_Area_Lookup__c=subArea.get(0).id,
                Franchise_Type__c='Residential',
                No_of_FLTs__c=2,
                Financing_Method__c='Credit',
                Loan_Duration__c='6 Months',
                Pit_Conversion__c=true,
                Existing_FLO__c=true,
                Existing_Location__c=true,
                Location__c=loc.get(0).id,
                FLTs_Approved__c=2
            );
            opList.add(opSchoolUpfront);
            insert opList;
            
            
            test.startTest();       
            
            
            //add products(Upfront, existing location=true)
            PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchoolUpfront);
            OpportunityProductsController oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            opSchoolUpfront.Existing_Location__c=false;
            update opSchoolUpfront;
            
            //add products(Upfront, existing location=false)
            pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            sc = new ApexPages.Standardcontroller(opSchoolUpfront);
            oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            
            //remove all products
            oppController.removeAllProducts();
            
            
            
            test.stopTest();
            
        }
        
        /*---------------------------------Test for the Adding Commercial products---------------------------------*/
        static testMethod void CreateToiletSaleOpportunity_CommercialProducts() {
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
            
            
            
            Opportunity opSchoolUpfront=new Opportunity(
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
                Loan_Duration__c='6 Months',
                Pit_Conversion__c=true,
                Existing_FLO__c=true,
                Existing_Location__c=true,
                Location__c=loc.get(0).id,
                FLTs_Approved__c=2
            );
            opList.add(opSchoolUpfront);
            insert opList;
            
            
            test.startTest();       
            
            
            //add products(Upfront, existing location=true)
            PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchoolUpfront);
            OpportunityProductsController oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            opSchoolUpfront.Existing_Location__c=false;
            update opSchoolUpfront;
            
            //add products(Upfront, existing location=false)
            pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            sc = new ApexPages.Standardcontroller(opSchoolUpfront);
            oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            
            //remove all products
            oppController.removeAllProducts();
            
            
            
            test.stopTest();
            
        }
        
        
        /*---------------------------------Test for the Adding Commercial lease products---------------------------------*/
        static testMethod void CreateToiletSaleOpportunity_AddLeaseCommProducts() {
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
            //Create two Opportunities
            Opportunity opCommercialCredit=new Opportunity(
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
                FLTs_Approved__c=1
            );

            opList.add(opCommercialCredit);
            insert opList;
            
            test.startTest();       
            
            //add products(Upfront, existing FLO=false, existing location=true)
            PageReference pageRef = Page.ToiletSale_Opportunity_Add_Products;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opCommercialCredit);
            OpportunityProductsController oppController = new OpportunityProductsController(sc);
            oppController.addProducts();
            
            test.stopTest();
            
        }
        
        
    }