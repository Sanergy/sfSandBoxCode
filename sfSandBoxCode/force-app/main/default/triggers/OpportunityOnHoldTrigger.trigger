trigger OpportunityOnHoldTrigger on Opportunity (after update) {
    
    List<Opportunity> onholdList = [SELECT ID,On_Hold__c,On_Hold_Date__c,LastModifiedDate
                                    FROM Opportunity 
                                    WHERE On_Hold__c = true
                                    AND LastModifiedDate = today
                                   ];
    
    for(Opportunity opp:Trigger.new){
        
        for(Opportunity dt: onholdList){
            opp.On_Hold_Date__c = dt.LastModifiedDate;
        }
        
        if(opp.On_Hold__c == false){
            //  opp.On_Hold_Date__c = null;
        }
    }
}