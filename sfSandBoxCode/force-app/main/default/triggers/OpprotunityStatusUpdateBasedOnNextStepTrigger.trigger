trigger OpprotunityStatusUpdateBasedOnNextStepTrigger on Opportunity (before update) {
    for(Opportunity opportunity :Trigger.new){
        if(opportunity.Ag_Sales_Dummy_Stage__c != trigger.oldMap.get(opportunity.Id).Ag_Sales_Dummy_Stage__c){
            if(opportunity.Ag_Sales_Dummy_Stage__c  == 'Close Sale'){
            opportunity.StageName = 'Sale Confirmed';
            }
            if(opportunity.Ag_Sales_Dummy_Stage__c  == 'Schedule Followup'){
                opportunity.StageName = 'Presented Sale Pending';
            }
            if(opportunity.Ag_Sales_Dummy_Stage__c  == 'Collect Deposit Balance'){
                opportunity.StageName = 'Deposit Collected';
            }
            if(opportunity.Ag_Sales_Dummy_Stage__c  == 'Lost'){
                opportunity.StageName = 'Closed and Lost';
        }
        }
       
    }

}