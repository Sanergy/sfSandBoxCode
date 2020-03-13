trigger CreateHarvestLookupToTrial on Trial_Harvest__c (before insert) {
    for(Trial_Harvest__c th:Trigger.new){
    
        if(Trigger.isInsert){
           List<Treatment_Block__c> tb=[SELECT Trial__c
                                        FROM Treatment_Block__c
                                        WHERE ID=:th.Treatment_Block__c];
                                        
           if(tb.get(0).Trial__c!=null){
               th.Trial__c=tb.get(0).Trial__c;
           }
        }
    }
}