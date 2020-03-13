@isTest(seeAllData=true)
private class validateMaintenanceCaseTest  {
  
      static testMethod void validateMaintenanceCaseTester() {
        //get a maintenance case opportunity with a case not at 'case resolution verified' status
        
        List<Opportunity> opUnverified=[SELECT id, StageName 
                              FROM Opportunity 
                              WHERE StageName!='Maintenance Case Closed'
                              AND id IN (SELECT Case_Opportunity__c
                                         FROM Case
                                         WHERE Status!='Case Resolution Verified'
                                         AND Case_Opportunity__c!=null)
                              LIMIT 1];
                              
        List<Opportunity> opVerified=[SELECT id, StageName 
                              FROM Opportunity 
                              WHERE StageName!='Maintenance Case Closed'
                              AND id IN (SELECT Case_Opportunity__c
                                         FROM Case
                                         WHERE Status='Case Resolution Verified'
                                         AND Case_Opportunity__c!=null)
                              AND id NOT IN(SELECT Case_Opportunity__c
                                         FROM Case
                                         WHERE Status!='Case Resolution Verified'
                                         AND Case_Opportunity__c!=null 
                                          )
                              LIMIT 1];
         if(opUnverified.size()>0){
             try{
                 opUnverified.get(0).StageName='Maintenance Case Closed';
                 update opUnverified;
                 System.debug('Stage changed to Maintenance Case Closed [CASE]');
             }catch(exception e){
                 System.debug('Stage not changed to Maintenance Case Closed [CASE]');
             }
         }
         
         if(opVerified.size()>0){
                 opVerified.get(0).StageName='Maintenance Case Closed';
                 update opVerified;
         }
         
         
         
         /*
         op=[SELECT id, StageName
              FROM Opportunity
              WHERE ID IN(SELECT rstk__sohdr_opportunity__c
                          FROM rstk__sohdr__c
                          WHERE rstk__sohdr_opportunity__c!=null
                          AND rstk__sohdr_closed__c!=true)
              LIMIT 1];
              
         if(op.size()>0){
             try{
                 op.get(0).StageName='Maintenance Case Closed';
                 update op;
                 System.debug('Stage changed to Maintenance Case Closed [SO]');
             }catch(exception e){
                 System.debug('Stage not changed to Maintenance Case Closed [SO]');
             }
         }
         */
         
       }
}