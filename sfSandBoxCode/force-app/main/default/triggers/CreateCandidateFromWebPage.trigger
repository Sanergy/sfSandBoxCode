trigger CreateCandidateFromWebPage on Candidate__c (before insert) {
    for(Candidate__c candidate:Trigger.New){
        
        //Get Recruitment Requisition for this candidate
        List<Recruitment_Requisition__c> recruitmentRequisitions = [SELECT Id,Employee_Role__r.Company_Division__c,
                                                                    Employee_Role__r.Department__c,Employee_Role__r.Line_Manager__c,
                                                                    Requesting_Department_Team_Lead__c,Employee_Role__r.Sanergy_Department_Unit__c,
                                                                    Employee_Role__r.Sanergy_Department__c,Employee_Role__r.Id,                                                                    
                                                                    Requesting_Department__c,Requesting_Department__r.Teamlead__c,
                                                                    Location__c,Employee_Role__c                                                                    
                                                                    FROM Recruitment_Requisition__c
                                                                    WHERE Id =: candidate.Recruitment_Requisition__c ];
        
        if(recruitmentRequisitions.size()>0){
            candidate.Requesting_Department__c = recruitmentRequisitions.get(0).Requesting_Department__c;
            candidate.Requesting_Department_Team_Lead__c = recruitmentRequisitions.get(0).Requesting_Department__r.Teamlead__c;
        }
    }
}