trigger verifyCaseTypesForToilet on Case (before insert) {
    for(Case c: Trigger.new){
       List<Case> cases=[SELECT CaseNumber FROM Case 
                           WHERE Case_Type__c=:c.Case_Type__c
                           AND Toilet__c=:c.Toilet__c
                           AND ClosedDate = null] ;
                           
       if(cases.size() > 0){
           String casesNumbers='';
           
           for(Case cs:cases){
               casesNumbers+=cs.CaseNumber+', ';
           }
           
           c.addError('This toilet has other non-closed cases of the same type: '+casesNumbers);
       }
    }
}