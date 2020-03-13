trigger UdpateAccountOnTrialObservation on Trial_Observation__c (before insert) {
    for(Trial_Observation__c  to:Trigger.new){
        
        List<Trial__c> trial=[SELECT Account__c
                              FROM Trial__c
                              WHERE ID=:to.Trial__c
                              ];
          if(trial.size()>0){
              to.Account__c=trial.get(0).Account__c;
          }
    
    
    }
}