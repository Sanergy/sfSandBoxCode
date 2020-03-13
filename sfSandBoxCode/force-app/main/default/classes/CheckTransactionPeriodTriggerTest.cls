@IsTest
private class CheckTransactionPeriodTriggerTest {
    @IsTest
    private static void createTransaction() {
        // Setup Company and User association within runAs to avoid mixed DML restriction
        Group companyGroup = null;
        System.runAs([select Id from User where Id = :UserInfo.getUserId()][0]) {
            Test.startTest(); 
            // Create Company
            c2g__codaCompany__c company = new c2g__codaCompany__c();
            company.Name = 'ApexTestCompany';
            company.RecordTypeId = Schema.SObjectType.c2g__codaCompany__c.RecordTypeInfosByName.get('VAT').RecordTypeId;
            insert company; 
            // Create Company Queue
            c2g.CODACompanyWebService.createQueue(company.Id, 'USD', company.Name);
            // Activate the Company
            c2g.CODAYearWebService.calculatePeriods(null); // Workaround to bug in company API's, safe to remain once fixed
            c2g.CODACompanyWebService.activateCompany(company.Id, 'USD', company.Name); 
            // Assign the User to the Company
            c2g__codaUserCompany__c userCompany = new c2g__codaUserCompany__c();
            userCompany.c2g__Company__c = company.Id;
            userCompany.c2g__User__c = UserInfo.getUserId();
            insert userCompany; 
            // Assign the User to the Company Queue
            String queueName = 'FF ' + company.Name;
            companyGroup = [select Id from Group where Name = :queueName And Type = 'Queue'];
            insert new GroupMember( GroupId = companyGroup.Id, UseroRGroupId = UserInfo.getUserId());
            Test.stopTest(); 
        }
        // Assert user logged into the company
        System.assertEquals('ApexTestCompany', c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
        
        //Create Year and Periods
        c2g__codaYear__c yr = new c2g__codaYear__c();
        yr.Name = String.valueOf(Date.today().year());
        yr.OwnerId = companyGroup.Id;
        yr.c2g__NumberOfPeriods__c = 12;
        yr.c2g__AutomaticPeriodList__c = true;
        yr.c2g__StartDate__c = Date.valueOf(Date.today().year() + '-01-01 00:00:00');
        yr.c2g__EndDate__c = Date.valueOf(Date.today().year() + '-12-31 00:00:00');
        yr.c2g__PeriodCalculationBasis__c = 'Month End';
        insert yr;
        c2g.CODAYearWebService.calculatePeriods(yr.Id);
        
        
        // Create Accounting Currency?
        if(UserInfo.isMultiCurrencyOrganization()) {
            c2g__codaAccountingCurrency__c testCurrency = new c2g__codaAccountingCurrency__c();
            testCurrency.Name = 'USD';
            testCurrency.c2g__DecimalPlaces__c = 2;
            testCurrency.c2g__Home__c = true;
            testCurrency.c2g__Dual__c = true;
            insert testCurrency; 
        }
        
        Account acc = new Account();
        acc.Name = 'Unilever';
        acc.CurrencyIsoCode = 'KES';
        acc.c2g__CODAAccountTradingCurrency__c = 'KES';
        insert acc;
        
          system.debug('Test Account'+ acc); 
       // system.debug('Accou'+ ac.get(0).Id);
        // Create General Ledger Account
        c2g__codaGeneralLedgerAccount__c gla = new c2g__codaGeneralLedgerAccount__c();
        gla.Name = 'Brochures';
        gla.c2g__ReportingCode__c = 'xyz1';
        gla.c2g__Type__c = 'Balance Sheet';
        insert gla;
        // Create and Post a test Journal
        c2g__codaJournal__c journal = new c2g__codaJournal__c();
        journal.c2g__JournalDate__c = Date.today();
        journal.OwnerId = companyGroup.Id;
        insert journal;
        c2g__codaJournalLineItem__c journalLine1 = new c2g__codaJournalLineItem__c();
        journalLine1.c2g__LineType__c = 'General Ledger Account';
        journalLine1.c2g__Journal__c = journal.Id;
        journalLine1.c2g__GeneralLedgerAccount__c = gla.Id;
        journalLine1.c2g__Value__c = 42;
        c2g__codaJournalLineItem__c journalLine2 = new c2g__codaJournalLineItem__c();
        journalLine2.c2g__LineType__c = 'General Ledger Account'; 
        journalLine2.c2g__Journal__c = journal.Id;
        journalLine2.c2g__GeneralLedgerAccount__c = gla.Id;
        journalLine2.c2g__Value__c = -42;
        c2g__codaJournalLineItem__c journalLine3 = new c2g__codaJournalLineItem__c();
        journalLine3.c2g__LineType__c = 'Account - Vendor'; 
        journalLine3.c2g__DebitCredit__c = 'Debit'; 
        journalLine3.c2g__Account__c = acc.Id; 
        journalLine3.c2g__Journal__c = journal.Id;
        journalLine3.c2g__GeneralLedgerAccount__c = gla.Id;
        journalLine3.c2g__Value__c = -52;
        c2g__codaJournalLineItem__c journalLine4 = new c2g__codaJournalLineItem__c();
        journalLine4.c2g__LineType__c = 'Account - Vendor'; 
        journalLine4.c2g__DebitCredit__c = 'Credit'; 
        journalLine4.c2g__Account__c = acc.Id; 
        journalLine4.c2g__Journal__c = journal.Id;
        journalLine4.c2g__GeneralLedgerAccount__c = gla.Id;
        journalLine4.c2g__Value__c = 52;
        insert new List<c2g__codaJournalLineItem__c> { journalLine1, journalLine2, journalLine3, journalLine4 }; 
            c2g.CODAAPIJournal_12_0.PostJournal(null, c2g.CODAAPICommon.getRef(journal.Id, null));
        System.assertEquals(0, [select c2g__DocumentTotal__c from c2g__codaTransaction__c LIMIT 1][0].c2g__DocumentTotal__c);
    } }