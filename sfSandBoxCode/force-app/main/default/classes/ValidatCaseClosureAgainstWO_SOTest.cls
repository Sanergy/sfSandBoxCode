@isTest(SeeAllData=true)
private class ValidatCaseClosureAgainstWO_SOTest {


     /*------------------Test Class for ValidatCaseClosureAgainstWO_SO Trigger------------------------- */  
      static testMethod void ValidatCaseClosureAgainstWO_SO() {
      
      /*
      //get an opportunity tagged to a Sales Order and Work Order
      
      //get unclosed Work Order
      List<rstk__soline__c > opWO=[Select rstk__soline_sohdr__r.rstk__sohdr_opportunity__c 
                            FROM rstk__soline__c 
                            WHERE rstk__soline_sohdr__r.rstk__sohdr_closed__c = false AND
                            ID IN (SELECT rstk__wocst_soline__c
                                         FROM rstk__wocst__c
                                         WHERE rstk__wocst_ordsts_pl__c <> '9') LIMIT 1];
                                         
      //get unclosed Sales Order
      List<rstk__soline__c > opSO=[Select rstk__soline_sohdr__r.rstk__sohdr_opportunity__c 
                            FROM rstk__soline__c 
                            WHERE rstk__soline_sohdr__r.rstk__sohdr_closed__c = false  AND
                            ID NOT IN (SELECT rstk__wocst_soline__c
                                         FROM rstk__wocst__c
                                         WHERE rstk__wocst_ordsts_pl__c <> '9') LIMIT 1];
                            
      
      
     
      //get a location
      List<Location__c> loc=[SELECT id FROM Location__c WHERE of_toilets_OPEN__c > 0 LIMIT 1];
      
      
      
      
      List<Toilet__c> toilet=[SELECT id FROM Toilet__c WHERE Location__c =:loc.get(0).id LIMIT 1];
      
      //Create a Case
      Case c=new Case(
          Case_ID__c='031 - Squat Support',
          Type='Feature Request',
          Reason='Other',
          Origin='Fresh Life Operator',
          Location__c=loc.get(0).id,
          Toilet__c=toilet.get(0).id,
          Date_Reported__c=Date.today(),
          Status='New',
          Priority='Medium'
      );
      
      insert c;
      
      
       //Link Case to Opportunity
      test.startTest();
      if(opWO.size()>0){
              try
              {
                c.Case_Opportunity__c=opWO.get(0).rstk__soline_sohdr__r.rstk__sohdr_opportunity__c;
                c.Status='Resolved';
                update c;
                //throw new MyException('An exception should have been thrown by the trigger but was not.'); // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 2. MyException class extends Exception.
                System.debug('Error not thrown');
              }
                catch(Exception e) {
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                 System.debug('Error message thrown: '+e.getMessage());
              }
         }
         
         if(opSO.size()>0){
              try
              {
                c.Case_Opportunity__c=opSO.get(0).rstk__soline_sohdr__r.rstk__sohdr_opportunity__c;
                c.Status='Resolved';
                update c;
                //throw new MyException('An exception should have been thrown by the trigger but was not.'); // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 2. MyException class extends Exception.
                System.debug('Error not thrown');
              }
                catch(Exception e) {
                 System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                 System.debug('Error message thrown: '+e.getMessage());
              }
         }
     
      
      test.stopTest();
     
      */
      
      }
}