trigger CaseCreationCheckTrigger on Case (before insert) {
    for(Case newCase:Trigger.new){
        
        List<Case> listCases = [SELECT Id,Status,Case_Type__c,Toilet__c
                                FROM Case
                                WHERE Toilet__c =: newCase.Toilet__c
                                AND Status = 'Open'
                                AND Case_Type__c =: newCase.Case_Type__c
                               ];
        
        if(listCases.size() > 0){
            newCase.addError('There is similar Open Case for this Toilet');
        }
    }
}