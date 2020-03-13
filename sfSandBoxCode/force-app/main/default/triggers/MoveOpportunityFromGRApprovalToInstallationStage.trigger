trigger MoveOpportunityFromGRApprovalToInstallationStage on Opportunity (before update) {
        
    for(Opportunity opp: Trigger.new){
        
        //Change Opportunity Stage from 'Pending Govt Approval' to 'Installation'
        if(opp.StageName == 'Pending Govt Approval' && opp.GR_Checklist_signed_by_AGRO__c == true && 
           opp.Government_Signatures_Received__c == true && opp.GR_Checklist_signed_Date__c != null){
               
            //Change stage to Installation
            opp.StageName = 'Installation';
        }
        
        //Change Opportunity Stage from 'Installation' to 'Pending Launch'
        if(opp.StageName == 'Installation' && opp.Structure_finished_and_handed_over__c == true && opp.Painting_finished_and_Handed_over__c == true 
           && opp.Items_Delivered__c == true && opp.Total_Number_of_Products__c > 0){
               
            //Change stage to Pending Launch
            opp.StageName = 'Pending Launch';
        }        
    }

}