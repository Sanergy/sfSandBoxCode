trigger validateMaintenanceCase on Opportunity (before update) {
    for(Opportunity op:Trigger.new){
    
       if(op.recordTypeId=='012D00000003H8DIAU'){
        
         
             if(op.StageName!=null && op.StageName=='Maintenance Case Closed' && 
                Trigger.oldMap.get(op.id).StageName!=op.StageName ){
                
                  //get count of cases which are not in 'Case Resolution Verified' stage
                    Integer countUnverifiedCases=[SELECT count()
                                                  FROM Case
                                                  WHERE Status!='Case Resolution Verified'
                                                  AND Status!='Resolved'
                                                  AND Case_Opportunity__c=:op.id];
                      
                     if(countUnverifiedCases>0){
                         op.addError('Cannot close opportunity: All its cases should be in "Case Resolution Verified" status'); 
                     }                           
                                   
                     
                      //close cases
                      List<Case> verifiedCases=[SELECT Status
                                                  FROM Case
                                                  WHERE Status='Case Resolution Verified'
                                                  AND Case_Opportunity__c=:op.id];
                      if(verifiedCases.size()>0){
                          for(Case vCases:verifiedCases){
                              vCases.Status='Resolved';
                          }
                          update verifiedCases;
                          
                      }
             }
        }
    }
}