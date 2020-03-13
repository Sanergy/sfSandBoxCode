trigger PreventWoItemChange on Opportunity_WO_Item__c (before update, before delete) {
    
    if(Trigger.isDelete){
        for(Opportunity_WO_Item__c oppWOItem: Trigger.old){
            if(oppWOItem.Approved__c == true){
                oppWOItem.adderror('You are not permitted to delete an Engineering Item once it has been approved!');
            }//End if(oppWOItem.Approved__c == true)   
        }//End for(Opportunity_WO_Item__c oppWOItem: Trigger.old) 
    }
}