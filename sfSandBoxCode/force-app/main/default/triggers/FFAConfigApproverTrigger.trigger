trigger FFAConfigApproverTrigger on FFA_Config_Object__c (before insert, before update) {
    //Update Approver and EPR approval Field to be the same and updated from the Employee Field
    if(Trigger.isInsert){
        for(FFA_Config_Object__c ffaConfig: Trigger.new){
            if(ffaConfig.Team_Lead_Employee_Account__c != NULL ){
                Employee__c TeamLeadSfAc = 
                    [SELECT Id,Employee_SF_Account__c,Employee_Active__c FROM Employee__c WHERE Id =: ffaConfig.Team_Lead_Employee_Account__c];
                //only select an active employee
                if(TeamLeadSfAc != NULL && TeamLeadSfAc.Employee_SF_Account__c != NULL && TeamLeadSfAc.Employee_Active__c == TRUE){
                    ffaConfig.Team_Lead_Employee_Account__c = TeamLeadSfAc.Id;
                    ffaConfig.Delegated_approver__c = TeamLeadSfAc.Employee_SF_Account__c;
                    ffaConfig.Teamlead__c = TeamLeadSfAc.Employee_SF_Account__c;
                }else
                {
                    ffaConfig.adderror('No Valid or Active SF Account found for the Team Lead [' + ffaConfig.Teamlead__c + ']');
                }
            } else{
                //since no approver inserted, set isActive to FALSE
                ffaConfig.isActive__c = FALSE;
            }
        }
    }
    
    //Update trigger
    if(Trigger.isUpdate && Trigger.isBefore){
        for(FFA_Config_Object__c ffaConfig: Trigger.new){
            if(Trigger.oldMap.get(ffaConfig.id).Team_Lead_Employee_Account__c != ffaConfig.Team_Lead_Employee_Account__c){//Update if TL Emp Account Changed
                Employee__c TeamLeadSfAc = 
                    [SELECT Id,Employee_SF_Account__c,Employee_Active__c FROM Employee__c WHERE Id =: ffaConfig.Team_Lead_Employee_Account__c];
                //only select an active employee
                if(TeamLeadSfAc != NULL && TeamLeadSfAc.Employee_SF_Account__c != NULL && TeamLeadSfAc.Employee_Active__c == TRUE){
                    ffaConfig.Delegated_approver__c = TeamLeadSfAc.Employee_SF_Account__c;
                    ffaConfig.Teamlead__c = TeamLeadSfAc.Employee_SF_Account__c;
                }else
                {
                    ffaConfig.adderror('No Valid or Active SF Account found for the Team Lead [' + ffaConfig.Teamlead__c + ']');
                } 
            }
        }
    }
}