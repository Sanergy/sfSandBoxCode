@isTest(SeeAllData=true)
private class CreateDimension4FromOpportunityTest{
    static testMethod void CreateDimension4() {
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
                                       recordTypeId='012D0000000KFArIAO',
                                       AccountId=AcRetrieved.ID,
                                       StageName='Grant/Contract Active',
                                       CloseDate=Date.today()
                                      );  
       Insert op;   
       
        Integer dimCount=[SELECT  count()
                                     FROM c2g__codaDimension4__c]; 
        
       System.debug(dimCount);
       
       op.DIM_4_Reporting_Code__c='test code';
       op.Create_DIM4__c=true;
       
       update op;
       
       Integer dimCount2=[SELECT  count()
                                     FROM c2g__codaDimension4__c]; 
       System.debug(dimCount2);
       
      // System.assert(op.Dimension_4__c!=null);
       
    }
}