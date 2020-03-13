trigger CandidateEvaluationTrigger on Candidate_Requisition__c (before update, before delete, before insert) {
    
    
    if(Trigger.isDelete){
        for(Candidate_Requisition__c ce: Trigger.old){
            ce.adderror('You are not permitted to delete a Candidate Evaluation once created');
        } 
    }else if(Trigger.isInsert){
        for(Candidate_Requisition__c candidateReq: Trigger.new){
            
            AggregateResult[] aggReq = [SELECT COUNT(id)ReqCount, MAX(Candidate__r.Name) CandidateName, MAX(Recruitment_Requisition__r.Name)ReqName
                                        FROM Candidate_Requisition__c
                                        WHERE Recruitment_Requisition__c =: candidateReq.Recruitment_Requisition__c
                                        AND Candidate__c =: candidateReq.Candidate__c];
            
            if(Integer.valueOf(aggReq[0].get('ReqCount'))>0){
                
                candidateReq.adderror('Candidate '+ String.valueOf(aggReq[0].get('CandidateName')) + ' already has an existing requisition: ' + String.valueOf(aggReq[0].get('ReqName')));
                
            }// End if(Integer.valueOf(aggReq[0].get('ReqCount'))>0)
            
        }// End for(Candidate_Requisition__c candidateReq: Trigger.new)        
        
    }else{    
        
        for(Candidate_Requisition__c candidateEvaluation: Trigger.new){
            
            System.debug('Trigger.oldMap.get(candidateEvaluation.id) === ' + Trigger.oldMap.get(candidateEvaluation.id));
            System.debug('candidateEvaluation === ' + candidateEvaluation);
            
            // Check if any of the values have changed
            if(Trigger.oldMap.get(candidateEvaluation.id).Candidate_Rating__c != candidateEvaluation.Candidate_Rating__c || 
               Trigger.oldMap.get(candidateEvaluation.id).Status__c != candidateEvaluation.Status__c || 
               Trigger.oldMap.get(candidateEvaluation.id).In_Review__c != candidateEvaluation.In_Review__c ||
               Trigger.oldMap.get(candidateEvaluation.id).In_Offer__c != candidateEvaluation.In_Offer__c ||
               Trigger.oldMap.get(candidateEvaluation.id).Recruitment_Requisition__c != candidateEvaluation.Recruitment_Requisition__c){
                   
                   //Create Candidate Evaluation Stage
                   Candidate_Evaluation_Stage__c evaluationStage  = new Candidate_Evaluation_Stage__c(); 
                   evaluationStage.Recruitment_Requisition__c = Trigger.oldMap.get(candidateEvaluation.id).Recruitment_Requisition__c;                
                   evaluationStage.Candidate_Evaluation__c = candidateEvaluation.Id;
                   evaluationStage.Candidate__c = Trigger.oldMap.get(candidateEvaluation.id).Candidate__c;
                   evaluationStage.Candidate_Rating__c = Trigger.oldMap.get(candidateEvaluation.id).Candidate_Rating__c;
                   evaluationStage.Date_Available__c = Trigger.oldMap.get(candidateEvaluation.id).Date_Available__c;
                   evaluationStage.Years_Of_Experience__c = Trigger.oldMap.get(candidateEvaluation.id).Years_Of_Experience__c;
                   evaluationStage.Evaluation_Status__c = Trigger.oldMap.get(candidateEvaluation.id).Status__c;
                   evaluationStage.In_Review__c = Trigger.oldMap.get(candidateEvaluation.id).In_Review__c;
                   evaluationStage.In_Offer__c = Trigger.oldMap.get(candidateEvaluation.id).In_Offer__c;
                   evaluationStage.Comments__c = Trigger.oldMap.get(candidateEvaluation.id).Comments__c;
                   INSERT evaluationStage;                   
               }  
        }
    }
}