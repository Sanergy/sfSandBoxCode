trigger CandidateDelete on Candidate__c (before delete) {
    for(Candidate__c cand: Trigger.old){
        AggregateResult [] candEvals = [SELECT COUNT(ID)no
                                        FROM Candidate_Requisition__c
                                        WHERE Candidate__c =: cand.Id
                                        GROUP BY Candidate__c
                                       ];
        
        if(candEvals.size() > 0) {
            cand.First_Name__c.adderror('You are not permitted to delete this record. One or more Candidate Evaluations exist for this Candidate');
        } 
        else {
            //delete any other related records eg references
            
            //Delete related candidate reference records if they exist
            List<Candidate_Reference__c> candRef  = [
                SELECT id 
                FROM Candidate_Reference__c 
                WHERE Candidate__c =: cand.id  ALL ROWS
            ];
            if(candRef.size()>0){
                delete candRef;
            }      
        }
    }        
}