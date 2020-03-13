@isTest(SeeAllData=true)
private class CreateNewAGSaleOpportunityTriggerTest {
    static testMethod void CreateNewAGSaleOpportunity() {
        
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
        
        Id standardpricebookId = Test.getStandardPricebookId();
        //create pricebook
        Pricebook2 pricebook=new Pricebook2(
            Name='Agricultural Products Sales'
        );
        insert pricebook;
        
        
        //insert Opportunity
        Opportunity op=new Opportunity(
            Name='x',
            RecordTypeId='012D0000000KGB7IAO',
            Opportunity_Type__c = 'Fertilizer Sale',
            StageName='Pending Resale',
            AccountId=Ac.id,
            CloseDate=Date.today().addMonths(3),
            Phone_Number__c='254700000000',
            Free_or_Discounted_Trial__c='No',
            Sales_Order_Signed__c='No',
            Payment_Method__c='Cash',
            Payment_Schedule__c='Upfront',
            Delivery__c='Delivery instructions',
            Delivery_Method__c='Delivery',
            Preferred_Delivery_Pickup_Date_Time__c=Datetime.now()
        );
        
        Insert op;
        String OpID=op.ID;
        
        
        //create products
        List<Product2> prod=new List<Product2>();
        Product2 evergrow=new Product2(
            Name='Evergrow - [35Kg]',
            IsActive=true
        );
        
        prod.add(evergrow);
        
        insert prod;
        
        
        //create standard pricebook entries
        List<PricebookEntry> Standardpbentry=new List<PricebookEntry>();
        
        PricebookEntry StandardpbentryEvergrow=new PricebookEntry(
            UnitPrice=40000,
            Pricebook2Id=standardpricebookId,
            IsActive=true,
            Product2Id=evergrow.ID,
            UseStandardPrice = false
        );
        
        
        Standardpbentry.add(StandardpbentryEvergrow);
        insert Standardpbentry;
        
        
        //create pricebook entries
        List<PricebookEntry> pbentry=new List<PricebookEntry>();
        
        PricebookEntry pbentryEvergrow=new PricebookEntry(
            UnitPrice=40000,
            Pricebook2Id=pricebook.ID,
            IsActive=true,
            Product2Id=evergrow.ID,
            UseStandardPrice = false
        );
        
        pbentry.add(pbentryEvergrow);
        insert pbentry;
        
        //add opportunity line item
        OpportunityLineItem OLI=new OpportunityLineItem(
            OpportunityId=op.id,
            Quantity=1,
            PricebookEntryId = pbentry.get(0).id,
            UnitPrice = pbentry.get(0).UnitPrice
        ); 
        
        insert OLI;
        
        Test.startTest();
        op.StageName='Sale Confirmed';
        update op;
        
        Test.stopTest();
        
    }
}