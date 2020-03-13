@isTest(SeeAllData=true)
private class DecisionIfOppStageIsBillingOrClosedtest{


     /*------------------Test Class for ValidatCaseClosureAgainstWO_SO Trigger------------------------- */  
      static testMethod void DecisionIfOppStageIsBillingOrClosedtest() {
      
          //get maintenence case recordtype
          List<RecordType> rType=[SELECT ID FROM RecordType
                                            WHERE Name='Maintenance Cases'];
          
          
          //get an account                                  
          List<Account> acc=[SELECT ID FROM Account WHERE Type='Customer' LIMIT 1];
          
          //get a location and a toilet
          List<Toilet__c> toilet=[SELECT Id, Location__c FROM Toilet__c LIMIT 1];
           
          List<Toilet__c> t = [SELECT id,Name,Location__c,location__r.name,Opportunity__r.AccountId
                                           FROM Toilet__c 
                         WHERE Location__c !='' Limit 1];
     System.debug('Toilet: '+t.get(0).name+'  Location: '+t.get(0).location__r.name);
     
          List<Case_Timeliness__c> tm = [SELECT Name,Agreed_Upon_Time_For_Resolution__c,Priority_Level__c,Case_Category__c
                                           FROM Case_Timeliness__c
                                    WHERE Case_Category__c='Logistics' Limit 1];
          
          //create a maintenance case opportunity
          Opportunity op=new Opportunity(
              name='x',
              AccountId=t.get(0).Opportunity__r.AccountId,
              recordTypeId=rType.get(0).id,
              CloseDate=Date.today(),
              StageName='Open',
              Billed_Entity__c='FLO'
              
          );
          
          insert op;
          
           //Create a Case
           Case ces=new Case(); 
     ces.Case_Type__c=tm.get(0).Id;    
     ces.Status='Open';
     ces.Case_Root_Cause__c='Logistics error'; 
     ces.Toilet__c=t.get(0).Id;
     ces.Location__c=t.get(0).Location__c;
   //ces.Date_Reported__c=DateTime.now(); 
     ces.Case_Opportunity__c=op.Id;  
     insert ces;  
         /* Case c=new Case(
              Case_ID__c='031 - Squat Support',
              Type='Feature Request',
              Reason='Other',
              Origin='Fresh Life Operator',
              Location__c=toilet.get(0).location__c,
              Toilet__c=toilet.get(0).id,
             // Date_Reported__c=Date.today(),
              Status='Open',
              Priority='Medium',
              Case_opportunity__c=op.id
          );
          
          insert c; */
           
   
          ces.Status='Closed';
          update ces;
                                      
             
      }
}