@isTest(SeeAllData=true)
public class FFACapitalisation_Test {
    //ffaCap.periodSearchText= Make sure you update the current period to make sure the code coverage passes
    
    private static TestMethod void createJournal() {
        // Setup Company and User association within runAs to avoid mixed DML restriction
        Group companyGroup = null;
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u.get(0)) {
            
            Test.startTest();
            
            //Get Company
            c2g__codaCompany__c company = [SELECT Id, Name FROM c2g__codaCompany__c WHERE id = 'a19D00000026xHv' LIMIT 1];//Fresh Life
            
            // Create Company Queue
            c2g.CODACompanyWebService.createQueue(company.Id, 'USD', company.Name);
            // Activate the Company
            c2g.CODAYearWebService.calculatePeriods(null); // Workaround to bug in company API's, safe to remain once fixed
            c2g.CODACompanyWebService.activateCompany(company.Id, 'USD', company.Name); 
            
            // Assign the User to the Company Queue
            String queueName = 'FF ' + company.Name;
            companyGroup = [select Id from Group where Name = :queueName And Type = 'Queue'];
            insert new GroupMember( GroupId = companyGroup.Id, UseroRGroupId = UserInfo.getUserId());
            //Test.stopTest(); 
        
        // Assert user logged into the company
       // System.assertEquals('Fresh Life Initiative Limited', c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
            
            //To test FLI Company
            List<String> fliCo = new List<String>();
            fliCo.add('Fresh Life Initiative Limited');
            system.debug('FFA Co Current = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
            c2g.CODAAPICompany_2_0.SetCurrentCompanies(fliCo);
            System.assertEquals('Fresh Life Initiative Limited', c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
            system.debug('FFA Co New = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);  
            
            Account acc = new Account();
            acc.Name = 'Unilever';
            acc.CurrencyIsoCode = 'KES';
            acc.c2g__CODAAccountTradingCurrency__c = 'KES';
            insert acc;
            
            system.debug('Test Account'+ acc); 
            
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
            journal.Product_Type__c = 'Fee for Service FLT - "FFS FLT",';        
            insert journal;
            
            c2g__codaJournalLineItem__c journalLine1 = new c2g__codaJournalLineItem__c();
            journalLine1.c2g__LineType__c = 'General Ledger Account';
            journalLine1.c2g__DebitCredit__c ='Debit';
            journalLine1.c2g__Journal__c = journal.Id;
            journalLine1.c2g__GeneralLedgerAccount__c = 'a1QD000003EPGFc' ;//5104 - Materials - Toilets
            journalLine1.c2g__Dimension1__c = 'a1ID0000008zZCd'; // DIM 1 'Fresh Life Operations - Installation';
            journalLine1.c2g__LineDescription__c = '';
            journalLine1.c2g__Value__c = 42;
            
            c2g__codaJournalLineItem__c journalLine2 = new c2g__codaJournalLineItem__c();
            journalLine2.c2g__LineType__c = 'General Ledger Account';
            journalLine2.c2g__DebitCredit__c ='Credit';
            journalLine2.c2g__Journal__c = journal.Id;
            journalLine2.c2g__GeneralLedgerAccount__c = 'a1QD000000BVOLp' ;//1410 - Inventory - Raw Material
            journalLine2.c2g__Dimension1__c = 'a1ID0000008zZCd'; // DIM 1 'Fresh Life Operations - Installation';	
            journalLine2.c2g__LineDescription__c = '';
            journalLine2.c2g__Value__c = -42;      
            
            c2g__codaJournalLineItem__c journalLine3 = new c2g__codaJournalLineItem__c();
            journalLine3.c2g__LineType__c = 'General Ledger Account';
            journalLine3.c2g__DebitCredit__c ='Debit';
            journalLine3.c2g__Journal__c = journal.Id;
            journalLine3.c2g__GeneralLedgerAccount__c = 'a1QD000003EPGFc' ;//5104 - Materials - Toilets
            journalLine3.c2g__Dimension1__c = 'a1ID0000008zZCd'; // DIM 1 'Fresh Life Operations - Installation';
            journalLine3.c2g__LineDescription__c = '';
            journalLine3.c2g__Value__c = 5550;
            
            c2g__codaJournalLineItem__c journalLine4 = new c2g__codaJournalLineItem__c();
            journalLine4.c2g__LineType__c = 'General Ledger Account';
            journalLine4.c2g__DebitCredit__c ='Credit';
            journalLine4.c2g__Journal__c = journal.Id;
            journalLine4.c2g__GeneralLedgerAccount__c = 'a1QD000000BVOLp' ;//1410 - Inventory - Raw Material
            journalLine4.c2g__Dimension1__c = 'a1ID0000008zZCd'; // DIM 1 'Fresh Life Operations - Installation';	
            journalLine4.c2g__LineDescription__c = '';
            journalLine4.c2g__Value__c = -5550;      
            
            //insert to non 5102-4 GLA 
            c2g__codaJournalLineItem__c journalLine5 = new c2g__codaJournalLineItem__c();
            journalLine5.c2g__LineType__c = 'General Ledger Account';
            journalLine5.c2g__DebitCredit__c ='Debit';
            journalLine5.c2g__Journal__c = journal.Id;
            journalLine5.c2g__GeneralLedgerAccount__c = 'a1QD000003EOASj' ;//1560 - Computer Software
            journalLine5.c2g__Dimension1__c = 'a1ID0000008zZCd'; // DIM 1 'Fresh Life Operations - Installation';
            journalLine5.c2g__LineDescription__c = '';
            journalLine5.c2g__Value__c = 5550;
            
            c2g__codaJournalLineItem__c journalLine6 = new c2g__codaJournalLineItem__c();
            journalLine6.c2g__LineType__c = 'General Ledger Account';
            journalLine6.c2g__DebitCredit__c ='Credit';
            journalLine6.c2g__Journal__c = journal.Id;
            journalLine6.c2g__GeneralLedgerAccount__c = 'a1QD000000BVOLp' ;//1410 - Inventory - Raw Material
            journalLine6.c2g__Dimension1__c = 'a1ID0000008zZCd'; // DIM 1 'Fresh Life Operations - Installation';	
            journalLine6.c2g__LineDescription__c = '';
            journalLine6.c2g__Value__c = -5550;   
            
            //insert journal line items
            insert new List<c2g__codaJournalLineItem__c> { journalLine1, journalLine2, journalLine3, journalLine4, journalLine5, journalLine6 }; 
                //c2g.CODAAPIJournal_12_0.PostJournal(null, c2g.CODAAPICommon.getRef(journal.Id, null));
                //Call Object Methods
                
                //Get current period
                String ffaPeriod = '000' + String.valueOf(Date.today().month());
            ffaPeriod = String.valueOf(Date.today().year()) + '/' + ffaPeriod.Right(3);
            
            FFSCapitalisation ffaCap = new FFSCapitalisation();
            ffaCap.periodSearchText= '2019/007';//ffaPeriod; //Make sure you enter current period
            ffaCap.noOfLineItemsToProcess = 50; //No of JNL Line Items to Process
            System.debug('ffaPeriod = ' + ffaPeriod);
            System.debug('ffaCap.SearchJournals() = ' + ffaCap.SearchJournals());
            System.debug('ffaCap.CreateJournal() = ' + ffaCap.CreateJournal());
            test.stopTest();
        }
    }
}