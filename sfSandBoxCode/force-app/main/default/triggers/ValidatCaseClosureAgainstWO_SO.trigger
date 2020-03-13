trigger ValidatCaseClosureAgainstWO_SO on Case (before update) {
    for(Case c:Trigger.New){
        if(Trigger.oldMap.get(c.id).Status!=null && c.Status!=Trigger.oldMap.get(c.id).Status && c.Status=='Resolved' && c.Case_Opportunity__c != null){
          
        }
    }
}