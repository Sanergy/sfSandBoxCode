@isTest(SeeAllData=true)
private class OpportunityTestClassAddProducts2Year {
/*
     static testMethod void CreateToiletSaleOpportunity_Add2YearPayment() {
           //insert Account
       Account Ac=new Account(
                              Name='Acc',
                              CurrencyIsoCode='KES' 
                               );                        
       insert Ac;
       Account AcRetrieved=[SELECT ID
                   FROM Account
                   WHERE Name='Acc'];
                   
                   
       //insert second Account
       Account AcNew=new Account(
                              
                              Name='AccNew',
                              CurrencyIsoCode='KES' 
                               );                        
       insert AcNew;
       Account AcNewRetrieved=[SELECT ID
                   FROM Account
                   WHERE Name='AccNew'];
                    
       
       
       //insert Contact
       Contact con=new Contact(
                              
                                 lastname='Onyando',
                                 Sex__c='Male'
                               );
      insert con;
      Contact conRetrieved=[SELECT ID
                            FROM Contact
                            WHERE lastname='Onyando'];
       
       Id standardpricebookId = Test.getStandardPricebookId();
        //create pricebook
       Pricebook2 pricebook=new Pricebook2(
                                   Name='FLT Sales - Credit 2 Year'
                                   );
       insert pricebook;

       
       //insert Opportunity
       Opportunity op=new Opportunity(
                                       Name='ops',
                                       AccountId=AcRetrieved.ID,
                                       StageName='Deposit Paid',
                                       CloseDate=Date.today(),
                                       Primary_Salesperson__c=conRetrieved.ID,
                                       GR_Approval_Status__c='Approved',
                                       AM_Approval_Status__c='Approved',
                                       Deposit_Paid_Date__c=Date.Today(),
                                       Financing_Method__c='Credit',
                                       Specific_Financing_Method__c='2 Year Loan',
                                       Expected_Deposit_Amount__c=12000,
                                       No_of_FLTs__c=2,
                                       CM_Deposit__c=true,
                                       Pricebook2Id=pricebook.ID,
                                       Existing_FLO__c=false);
                                       
       Insert op;
       String OpID=op.ID;
       
       
       //create products
       List<Product2> prod=new List<Product2>();
       Product2 prodToilet=new Product2(
                                Name='COMPLETE FLT',
                                IsActive=true
                               );
                               
       Product2 prodSeco2Year=new Product2(
                                Name='Supplementary-New FLO',
                                IsActive=true                               );
                               
    
       
       prod.add(prodToilet);
       prod.add(prodSeco2Year);
        
       
       insert prod;
       
       
       //create standard pricebook entries
       List<PricebookEntry> Standardpbentry=new List<PricebookEntry>();
       
       PricebookEntry StandardpbentryComplete=new PricebookEntry(
                                               UnitPrice=40000,
                                               Pricebook2Id=standardpricebookId,
                                               IsActive=true,
                                               Product2Id=prodToilet.ID,
                                               UseStandardPrice = false
                                           );
      PricebookEntry StandardpbentryprodSeco2Year=new PricebookEntry(
                                               UnitPrice=15000,
                                               Pricebook2Id=standardpricebookId,
                                               IsActive=true,
                                               Product2Id=prodSeco2Year.ID,
                                               UseStandardPrice = false
                                           );
      
        Standardpbentry.add(StandardpbentryComplete);
        Standardpbentry.add(StandardpbentryprodSeco2Year);
        insert Standardpbentry;

       
       //create pricebook entries
       List<PricebookEntry> pbentry=new List<PricebookEntry>();
       
       PricebookEntry pbentryComplete=new PricebookEntry(
                                               UnitPrice=40000,
                                               Pricebook2Id=pricebook.ID,
                                               IsActive=true,
                                               Product2Id=prodToilet.ID,
                                               UseStandardPrice = false
                                           );
      PricebookEntry pbentryprodSeco2Year=new PricebookEntry(
                                               UnitPrice=-5000,
                                               Pricebook2Id=pricebook.ID,
                                               IsActive=true,
                                               Product2Id=prodSeco2Year.ID,
                                               UseStandardPrice = false

                                           );
      
        pbentry.add(pbentryComplete);
        pbentry.add(pbentryprodSeco2Year);
        insert pbentry;
        
        Sub_Area__c sa=new Sub_Area__c(Name='SA1',
                                          Area__c='Tassia');
           insert sa;
           //insert Location
           Location__c loc=new Location__c(
                                           Name='KB1',
                                           Franchise_Type__c='Hybrid-Plot',
                                           CurrencyIsoCode='KES',
                                           Sub_Area__c=sa.ID);
           insert loc;
           Toilet__c toilet=new Toilet__c(
                                       Name='KB1.1',
                                       Location__c=loc.ID,
                                       Opening_Date__c=Date.today(),
                                       Opportunity__c=op.ID,
                                       Operational_Status__c='Open',
                                       Current_Specific_Status__c='Open - New',
                                       Collection_Route__c='KR Collection Center'
                                       );
          insert toilet;
           
       
        Test.startTest();
          Opportunity_Toilet_Location__c OTL1=new Opportunity_Toilet_Location__c(
           Opportunity__c=Op.ID,
           Location__c=loc.id,
           Payment_Option__c='Kiva',
           No_of_Toilets__c=2,
           No_of_Kiva_FLTs__c=2,
           No_of_FLI_FLTs__c=0);
           
           
          Opportunity_Toilet_Location__c OTL2=new Opportunity_Toilet_Location__c(
           Opportunity__c=Op.ID,
           Payment_Option__c='Kiva',
           Location__c=loc.id,
           No_of_Toilets__c=1,
           No_of_Kiva_FLTs__c=1,
           No_of_FLI_FLTs__c=0);

          List<Opportunity_Toilet_Location__c>  OTL_List=new List<Opportunity_Toilet_Location__c>();
          OTL_List.add(OTL1);    
          OTL_List.add(OTL2);   
             
          insert OTL_List;
          
          OTL1.Firm__c=true; 
          OTL2.Firm__c=true; 
          update OTL_List; 
          
           AggregateResult[] count=[SELECT SUM(Quantity) 
                         FROM OpportunityLineItem 
                         WHERE (Opportunity_Toilet_Location__c=:OTL1.ID OR Opportunity_Toilet_Location__c=:OTL2.ID)
                         AND is_a_toilet__c=true];
          
          for (AggregateResult ar : count)  {
                //System.debug('Before firming '+ ar.get('expr0'));
                System.Assert(ar.get('expr0')==3);
           }
                                     
           
        
        Test.stopTest() ;
  
     }
     
   static testMethod void CreateToiletSaleOpportunity_addProductsOneYear_ExistingFLO() {
                     //insert Account
       Account Ac=new Account(
                              Name='Acc',
                              CurrencyIsoCode='KES' 
                               );                        
       insert Ac;
       Account AcRetrieved=[SELECT ID
                   FROM Account
                   WHERE Name='Acc'];
                   
                   
       //insert second Account
       Account AcNew=new Account(
                              
                              Name='AccNew',
                              CurrencyIsoCode='KES' 
                               );                        
       insert AcNew;
       Account AcNewRetrieved=[SELECT ID
                   FROM Account
                   WHERE Name='AccNew'];
                    
       
       
       //insert Contact
       Contact con=new Contact(
                              
                                 lastname='Onyando',
                                 Sex__c='Male'
                               );
      insert con;
      Contact conRetrieved=[SELECT ID
                            FROM Contact
                            WHERE lastname='Onyando'];
       
       Id standardpricebookId = Test.getStandardPricebookId();
        //create pricebook
       Pricebook2 pricebook=new Pricebook2(
                                   Name='FLT Sales - Credit 1 Year'
                                   );
       insert pricebook;

       
       //insert Opportunity
       Opportunity op=new Opportunity(
                                       Name='ops',
                                       AccountId=AcRetrieved.ID,
                                       StageName='Deposit Paid',
                                       CloseDate=Date.today(),
                                       Primary_Salesperson__c=conRetrieved.ID,
                                       GR_Approval_Status__c='Approved',
                                       AM_Approval_Status__c='Approved',                                       
                                       Deposit_Paid_Date__c=Date.Today(),
                                       Financing_Method__c='Credit',
                                       Specific_Financing_Method__c='1 Year Loan',
                                       Expected_Deposit_Amount__c=12000,
                                       No_of_FLTs__c=2,
                                       CM_Deposit__c=true,
                                       Pricebook2Id=pricebook.ID,
                                       Existing_FLO__c=true);
                                       
       Insert op;
       String OpID=op.ID;
       
       
       
       
             
       
       //create products
       List<Product2> prod=new List<Product2>();
       Product2 prodToilet=new Product2(
                                Name='COMPLETE FLT',
                                IsActive=true
                               );
                               
       Product2 prodSecoNew=new Product2(
                                Name='Supplementary-New FLO',
                                IsActive=true                               );
                               
       Product2 prodSecoSame=new Product2(
                                Name='Supplementary-Existing FLO',
                                IsActive=true                               );
       
       prod.add(prodToilet);
       prod.add(prodSecoNew);
       prod.add(prodSecoSame);  
       
       insert prod;
       
       
       //create standard pricebook entries
       List<PricebookEntry> Standardpbentry=new List<PricebookEntry>();
       
       PricebookEntry StandardpbentryComplete=new PricebookEntry(
                                               UnitPrice=40000,
                                               Pricebook2Id=standardpricebookId,
                                               IsActive=true,
                                               Product2Id=prodToilet.ID,
                                               UseStandardPrice = false
                                           );
      PricebookEntry StandardpbentrySecoNew=new PricebookEntry(
                                               UnitPrice=15000,
                                               Pricebook2Id=standardpricebookId,
                                               IsActive=true,
                                               Product2Id=prodSecoNew.ID,
                                               UseStandardPrice = false

                                           );
      PricebookEntry StandardpbentrySecoSame=new PricebookEntry(
                                               UnitPrice=10000,
                                               Pricebook2Id=standardpricebookId,
                                               IsActive=true,
                                               Product2Id=prodSecoSame.ID,
                                               UseStandardPrice = false

                                           );
        Standardpbentry.add(StandardpbentryComplete);
        Standardpbentry.add(StandardpbentrySecoNew);
        Standardpbentry.add(StandardpbentrySecoSame);
        insert Standardpbentry;

       
       //create pricebook entries
       List<PricebookEntry> pbentry=new List<PricebookEntry>();
       
       PricebookEntry pbentryComplete=new PricebookEntry(
                                               UnitPrice=40000,
                                               Pricebook2Id=pricebook.ID,
                                               IsActive=true,
                                               Product2Id=prodToilet.ID,
                                               UseStandardPrice = false
                                           );
      PricebookEntry pbentrySecoNew=new PricebookEntry(
                                               UnitPrice=15000,
                                               Pricebook2Id=pricebook.ID,
                                               IsActive=true,
                                               Product2Id=prodSecoNew.ID,
                                               UseStandardPrice = false

                                           );
      PricebookEntry pbentrySecoSame=new PricebookEntry(
                                               UnitPrice=10000,
                                               Pricebook2Id=pricebook.ID,
                                               IsActive=true,
                                               Product2Id=prodSecoSame.ID,
                                               UseStandardPrice = false

                                           );
        pbentry.add(pbentryComplete);
        pbentry.add(pbentrySecoNew);
        pbentry.add(pbentrySecoSame);
        insert pbentry;
        Sub_Area__c sa=new Sub_Area__c(Name='SA1',
                                          Area__c='Tassia');
           insert sa;
           //insert Location
           Location__c loc=new Location__c(
                                           Name='KB1',
                                           Franchise_Type__c='Hybrid-Plot',
                                           CurrencyIsoCode='KES',
                                           Sub_Area__c=sa.ID);
           insert loc;
           Toilet__c toilet=new Toilet__c(
                                       Name='KB1.1',
                                       Location__c=loc.ID,
                                       Opening_Date__c=Date.today(),
                                       Opportunity__c=op.ID,
                                       Operational_Status__c='Open',
                                       Current_Specific_Status__c='Open - New',
                                       Collection_Route__c='KR Collection Center'
                                       );
          insert toilet;
           
       
        Test.startTest();
          Opportunity_Toilet_Location__c OTL1=new Opportunity_Toilet_Location__c(
           Opportunity__c=Op.ID,
           Payment_Option__c='Kiva',
           Location__c=loc.id,
           No_of_Toilets__c=2,
           No_of_Kiva_FLTs__c=2,
           No_of_FLI_FLTs__c=0);
           
           
          Opportunity_Toilet_Location__c OTL2=new Opportunity_Toilet_Location__c(
           Opportunity__c=Op.ID,
           Payment_Option__c='Kiva',
           Location__c=loc.id,
           No_of_Toilets__c=1,
           No_of_Kiva_FLTs__c=1,
           No_of_FLI_FLTs__c=0);

          List<Opportunity_Toilet_Location__c>  OTL_List=new List<Opportunity_Toilet_Location__c>();
          OTL_List.add(OTL1);    
          OTL_List.add(OTL2);   
             
          insert OTL_List;
          
          OTL1.Firm__c=true; 
          OTL2.Firm__c=true; 
          update OTL_List; 
          
           AggregateResult[] count=[SELECT SUM(Quantity) 
                         FROM OpportunityLineItem 
                         WHERE (Opportunity_Toilet_Location__c=:OTL1.ID OR Opportunity_Toilet_Location__c=:OTL2.ID)
                         AND is_a_toilet__c=true];
          
          for (AggregateResult ar : count)  {
                //System.debug('Before firming '+ ar.get('expr0'));
                System.Assert(ar.get('expr0')==3);
           }
        
        Test.stopTest() ;

       }
       
       */
     
}