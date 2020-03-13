trigger UpdateOpportunityLocationField on OpportunityLineItem (after insert) {
    for(OpportunityLineItem oli:Trigger.new){
    
       if(oli.is_a_toilet__c==true){
           List<Opportunity> opList=[SELECT Location__c
                              FROM Opportunity
                              WHERE ID=:oli.opportunityId];
                              
        if(opList.size()>0){
            opList.get(0).Location__c= oli.Location__c;
            update opList;
        
        }
       }       
    }
}