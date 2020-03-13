trigger DecisionIfOppStageIsBillingOrClosed on Case (after update)
{
    for(Case c : trigger.new)
    {
         List<Opportunity> opp=[SELECT StageName,Billed_Entity__c FROM Opportunity WHERE ID=:c.Case_Opportunity__c];
         
             if(opp.size()>0){
             
                     Case caseOldStage=Trigger.oldMap.get(c.Id);
                     
                      if(caseOldStage.Status!=c.Status && c.Status=='Closed')
                      {
                                   
                             if(opp.get(0).Billed_Entity__c=='FLO')
                                {
                                opp.get(0).StageName='Billing';
                                }
                            else
                                {
                                opp.get(0).StageName='Closed';
                                }
                        update opp;
                       }  
                 }
        
    }
    
}