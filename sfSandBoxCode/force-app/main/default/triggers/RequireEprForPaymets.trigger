trigger RequireEprForPaymets on c2g__codaCashEntry__c (before insert, before update) {

    for(c2g__codaCashEntry__c entry :Trigger.new){
        
        if(entry.c2g__Type__c == 'Payment'){
            
            if(entry.EPR__c == null){
                 entry.addError('This type of Entry requires a valid EPR');
            } else {
                Electronic_Payment_Request__c epr = [SELECT Name, Status__c
                                                       FROM Electronic_Payment_Request__c
                                                       WHERE Id = :entry.EPR__c];
                                                       
                if(epr == null || epr.Status__c != 'Line Manager Approved'){
                   entry.addError('The EPR Status should be Line Manager Approved');
                }
            }
        }
    }
}