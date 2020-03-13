trigger UpdateTrialField on OpportunityLineItem (before insert, before update) {
  for(OpportunityLineItem oli:Trigger.new){
    
       if(Trigger.isInsert ||
         (Trigger.isUpdate && Trigger.oldMap.get(oli.id).Trial__c!=oli.Trial__c)){
          //get the opportunity trial field
           
           List<Opportunity> op=[SELECT Trial__c
                                 FROM Opportunity
                                 WHERE ID=:oli.OpportunityId];
                                 
             if(op.size()>0){
                 oli.Trial__c=op.get(0).Trial__c;
             }
           
       }
  }
}