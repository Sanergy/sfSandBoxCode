public class CandidateEvaluation {
    
    //Create standard controller
    private ApexPages.StandardController controller;
    
    //Candidate Evaluation
    public Candidate_Requisition__c candidateEvaluation {get; set;} 
    
    //Candidate Evaluation Stage
    public Candidate_Evaluation_Stage__c candidateEvaluationStage {get; set;}
    public List<CandidateEvaluationStage> candidateEvaluationStageList {get; set;}     
    
    // Constructor
    public CandidateEvaluation(ApexPages.StandardController controller){               
        this.controller = controller;
        candidateEvaluation = (Candidate_Requisition__c)controller.getRecord();
        candidateEvaluationStage = new Candidate_Evaluation_Stage__c();
        getCandidateEvaluationStages();
        getAllEvaluationStages();        
    }
    
    //Update Candidate Evaluation
    public PageReference updateCandidateEvaluation(){
        
        //Create Instance of Candidate Requisition
        candidateEvaluation.Recruitment_Requisition__c = candidateEvaluation.Recruitment_Requisition__c;
        candidateEvaluation.Candidate_Rating__c = candidateEvaluation.Candidate_Rating__c;
        candidateEvaluation.Date_Available__c = candidateEvaluation.Date_Available__c;
        candidateEvaluation.Years_Of_Experience__c = candidateEvaluation.Years_Of_Experience__c;
        candidateEvaluation.Status__c = candidateEvaluation.Status__c;
        candidateEvaluation.In_Review__c = candidateEvaluation.In_Review__c;
        candidateEvaluation.In_Offer__c = candidateEvaluation.In_Offer__c;
        candidateEvaluation.Comments__c = candidateEvaluation.Comments__c;
        UPDATE candidateEvaluation;
        
        return new PageReference('/'+ candidateEvaluation.Id);
    }
    
    // Get Candidate Evaluation Stage
    public List<CandidateEvaluationStage> getCandidateEvaluationStages(){
        System.debug('candidateEvaluation.Name: '+ candidateEvaluation.Name);
        
        if(candidateEvaluation.Name != null){
            
            candidateEvaluationStageList = new List<CandidateEvaluationStage>();
            
            List<Candidate_Evaluation_Stage__c> lineItems = [SELECT Id,Name,Recruitment_Requisition__c,Recruitment_Requisition__r.Name,
                                                             Evaluation_Status__c,Candidate_Rating__c,Candidate_Star_Rating__c,Date_Available__c,
                                                             In_Offer__c,In_Review__c,Years_Of_Experience__c,Candidate__c,Candidate__r.Name,
                                                             Comments__c
                                                             FROM Candidate_Evaluation_Stage__c 
                                                             WHERE Candidate_Evaluation__c =: candidateEvaluation.Id
                                                             ORDER BY Name ASC];
            
            for(Candidate_Evaluation_Stage__c lineItem : lineItems){                
                //Add all records to the list
                candidateEvaluationStageList.add(new CandidateEvaluationStage(lineItem));
            }
            System.debug('CANDIDATE EVALUATION STAGE: ' + candidateEvaluationStageList);
        }
        return candidateEvaluationStageList;
    }
    
    public PageReference getAllEvaluationStages() {
        getCandidateEvaluationStages();     
        return null;
    }    
    
    // Candidate Evaluation Stage wrapper class
    public class CandidateEvaluationStage{        
        public Candidate_Evaluation_Stage__c evaluationStage {get; set;}
        
        //Constructor
        public CandidateEvaluationStage(Candidate_Evaluation_Stage__c stage) {
            evaluationStage = stage;
        }
    }    
}