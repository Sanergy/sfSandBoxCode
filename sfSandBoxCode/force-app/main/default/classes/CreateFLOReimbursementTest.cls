@isTest(seeAllData = true)
public class CreateFLOReimbursementTest {
    static testMethod void CreateFLOReimbursementTest(){
            //create two accounts
        List <Account> accountList=new List<Account>();
        Account Ac=new Account(Name='Acc',CurrencyIsoCode='KES', Mobile_Payment_Phone_Number__c = 254712345678.0 );                        
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
        PageReference pageRef = Page.CreateFLOReimbursement;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opSchool);
        CreateFLOReimbursement oppController = new CreateFLOReimbursement(sc);
        oppController.CreateFLOReimbursementSPR();
        
        opSchool.CM__c=true;
        update opSchool;
        
        //Update MPEsa Code
        opSchool.M_Pesa_Code__c = 'M12345';
        opSchool.Deposit_Amount_Received__c = 230;
        update opSchool;
        oppController.EPRValue = 200;
        oppController.CreateFLOReimbursementSPR();
        oppController.CreateFLTCommission();
        
        //Test Attachments
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=opSchool.id); 
        insert attach;
        oppController.attachBody = bodyBlob;
        oppController.AttachFile();
        
        test.stopTest();
        
    }
}