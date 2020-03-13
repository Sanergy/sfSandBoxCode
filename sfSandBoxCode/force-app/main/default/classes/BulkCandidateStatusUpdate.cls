public class BulkCandidateStatusUpdate {
    
    //Create standard controller
    private ApexPages.StandardController controller;
    
    //Recruitment Requisition
    public Recruitment_Requisition__c recruitmentRequisition {get; set;}    
  	
    //Candidate Evaluation
    public Candidate_Requisition__c candidateEvaluation {get; set;}
    public List<Candidate_Requisition__c> candEvalList {get; set;}
    public List<CandidateEvaluation> candidateEvaluationList {get; set;}    
    Set<String> ceGUIDs  = new Set<String>();
	public String EvalAllStatus {get; set;}  
    public String newCandidateStatus {get; set;}
    public String selectedStatusOption {get; set;}
    public Boolean selectAllCheckbox {get; set;}
    public Boolean recordsUpdated {get; set;}
    Set<String> ceCachedGUIDs;
    public List<SelectOption> EvalAllStatusOptions {get; set;}
    public List<SelectOption> EvalStatusOptions {get; set;}
    public integer NoOfRequiredHires {get; set;}
    public integer NoOfAcceptedHires {get; set;}
    public integer NoOfAcceptedHiresInSave {get; set;} //number of accepted hires within this session
    public integer NoOfTotalApps {get; set;}
    public AggregateResult[] aggCE {get; set;}
    public Integer loopCounter {get; set;}
    public List<Candidate_Evaluation_Stage__c> evalStageHistory {get; set;}
    public List<Candidate_Evaluation_Stage__c> evalCandStageHistory {get; set;}
    
    // Get partition
        Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.sfOrgPartition');
    
    // Constructor
    public BulkCandidateStatusUpdate(ApexPages.StandardController controller){               
        this.controller = controller;
        recruitmentRequisition = (Recruitment_Requisition__c)controller.getRecord();
        candidateEvaluation = new Candidate_Requisition__c();
        //Aggregate results to list number of applications per status type
        updateApplicantNumbers();
        
        //Set dropdown options for VF page
        selectedStatusOption = '--None--';
        setDropDownOptions();

        //page coming from an update, confirm update was successful
        if(apexpages.currentpage().getparameters().get('updateAction') == 'Success') {

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records were successfully saved'));
            //get cached objects
            List<CandidateEvaluation> cachedEvals = (List<CandidateEvaluation>)Cache.Session.get('list');
            if(cachedEvals!= NULL && cachedEvals.size()>0){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records size =' + cachedEvals.size()));
            }
            
            ceCachedGUIDs = (Set<String>)Cache.Session.get('ceGUIDs');
            if(ceCachedGUIDs!= NULL && ceCachedGUIDs.size()>0){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records size ceCachedGUIDs =' + ceCachedGUIDs.size()));
            }            
            getUpdatedCandidateEvaluations();
            recordsUpdated = TRUE;
            getAllCandidates();
        }else {
            //New session
            //Cache.Session.remove('list');
            recordsUpdated = FALSE; //first time loading
            getCandidateEvaluations();
            getAllCandidates();
        }
        
    }

    public void setDropDownOptions(){
        //Set options for bulk Apply Status
        EvalAllStatusOptions=new List<SelectOption>();
        EvalAllStatusOptions.add(new SelectOption('--','--All Records--'));
        EvalAllStatusOptions.add(new SelectOption('Open','Open'));
        EvalAllStatusOptions.add(new SelectOption('Longlisted','Longlisted'));
        EvalAllStatusOptions.add(new SelectOption('Shortlisted','Shortlisted'));
        EvalAllStatusOptions.add(new SelectOption('Interview','Interview'));
        EvalAllStatusOptions.add(new SelectOption('Accepted','Accepted')); 
        EvalAllStatusOptions.add(new SelectOption('Declined','Declined'));
        
        //Set options for bulk Apply Status
        EvalStatusOptions=new List<SelectOption>();
        EvalStatusOptions.add(new SelectOption('--','--None--'));
        EvalStatusOptions.add(new SelectOption('Open','Open'));
        EvalStatusOptions.add(new SelectOption('Longlisted','Longlisted'));
        EvalStatusOptions.add(new SelectOption('Shortlisted','Shortlisted'));
        EvalStatusOptions.add(new SelectOption('Interview','Interview'));
        //EvalStatusOptions.add(new SelectOption('Accepted','Accepted')); //Avoid every one beng flagged as Accepted
        EvalStatusOptions.add(new SelectOption('Declined','Declined'));
    }
    
	// Get Candidate Requisition
    public List<CandidateEvaluation> getCandidateEvaluations(){ 
        if(recruitmentRequisition.Name != null && EvalAllStatus != null){
            candidateEvaluationList = new List<CandidateEvaluation>();
            List<Candidate_Requisition__c> candidateLineItems;
            if(EvalAllStatus == '--'){ 
                //List all records
                candidateLineItems = 
                    [	
                        SELECT Id,Name,Recruitment_Requisition__c,Recruitment_Requisition__r.Name,Expected_Salary__c,
                        Status__c,Candidate_Rating__c,Candidate_Star_Rating__c,Date_Available__c,In_Offer__c,In_Review__c,Years_Of_Experience__c,
                        Candidate__r.Highest_Education__c,Candidate__c,Candidate__r.Name, Comments__c,
                        Candidate__r.Cover_Letter__c, Candidate__r.Resume__c, CreatedDate, Recruitment_Requisition__r.Number_of_Required_Staff__c
                        FROM Candidate_Requisition__c 
                        WHERE Recruitment_Requisition__c =: recruitmentRequisition.Id
                        ORDER BY CreatedDate,Candidate__r.Name,Candidate_Rating__c DESC
                    ];
            }else
            {
                candidateLineItems = 
                    [SELECT Id,Name,Recruitment_Requisition__c,Recruitment_Requisition__r.Name,Expected_Salary__c,
                     Status__c,Candidate_Rating__c,Candidate_Star_Rating__c,Date_Available__c,In_Offer__c,In_Review__c,Years_Of_Experience__c,
                     Candidate__r.Highest_Education__c,Candidate__c,Candidate__r.Name, Comments__c,
                     Candidate__r.Cover_Letter__c, Candidate__r.Resume__c, CreatedDate, Recruitment_Requisition__r.Number_of_Required_Staff__c
                     FROM Candidate_Requisition__c 
                     WHERE Recruitment_Requisition__c =: recruitmentRequisition.Id
                     AND Status__c =: EvalAllStatus
                     ORDER BY CreatedDate,Candidate__r.Name,Candidate_Rating__c DESC];
            }
            
            //get Stage Histories
            getEvalStageHistory();
            for(Candidate_Requisition__c candidateLineItem : candidateLineItems){                
                //Add all records to the list
                List<Candidate_Evaluation_Stage__c> evalCandStageHistory = new List<Candidate_Evaluation_Stage__c>();
                for(Candidate_Evaluation_Stage__c es: evalStageHistory){
                    if(es.Candidate_Evaluation__c == candidateLineItem.id ){
                        evalCandStageHistory.add(es);
                    }
                }
                //Add to wrapper class
                candidateEvaluationList.add(new CandidateEvaluation(candidateLineItem, evalCandStageHistory));
                System.debug('CANDIDATE REQUISITION: ' + candidateEvaluationList);
            }
        }
        //Aggregate results to list number of applications per status type
        updateApplicantNumbers();
        return candidateEvaluationList;
    }
    
    public List<Candidate_Evaluation_Stage__c> getEvalStageHistory(){
        //get stage gistories for the evaluations
        evalStageHistory = 
            [
              SELECT Id,Name,Recruitment_Requisition__c,Recruitment_Requisition__r.Name,Candidate_Evaluation__c,
                     Evaluation_Status__c,Candidate_Rating__c,Candidate_Star_Rating__c,Date_Available__c,
                     In_Offer__c,In_Review__c,Years_Of_Experience__c,Candidate__c,Candidate__r.Name, Comments__c,
                     Candidate__r.Cover_Letter__c, Candidate__r.Resume__c, CreatedDate, Recruitment_Requisition__r.Number_of_Required_Staff__c
                     FROM Candidate_Evaluation_Stage__c
                     WHERE Recruitment_Requisition__c =:  recruitmentRequisition.Id
                     ORDER BY Candidate__c,CreatedDate,Candidate__r.Name,Candidate_Rating__c DESC  
            ];
        return evalStageHistory;
    }
	
    // Get Candidate Requisition
    public List<CandidateEvaluation> getUpdatedCandidateEvaluations(){ 
        //if(recruitmentRequisition.Name != null && candidateEvaluation.Status__c != null){
        candidateEvaluationList = new List<CandidateEvaluation>();
        
        List<Candidate_Requisition__c> candidateLineItems = 
            [
                SELECT Id,Name,Recruitment_Requisition__c,Recruitment_Requisition__r.Name,
                Status__c,Candidate_Rating__c,Candidate_Star_Rating__c,Date_Available__c,Expected_Salary__c,
                In_Offer__c,In_Review__c,Years_Of_Experience__c,Candidate__c,Candidate__r.Name, Comments__c,
                Candidate__r.Cover_Letter__c, Candidate__r.Resume__c, CreatedDate, Recruitment_Requisition__r.Number_of_Required_Staff__c
                FROM Candidate_Requisition__c 
                WHERE Recruitment_Requisition__c =: recruitmentRequisition.Id
                AND id IN : ceCachedGUIDs
                ORDER BY CreatedDate,Candidate__r.Name,Candidate_Rating__c DESC
            ];
        
        //get Stage Histories
        getEvalStageHistory();
        for(Candidate_Requisition__c candidateLineItem : candidateLineItems){                
            //Add all records to the list
            List<Candidate_Evaluation_Stage__c> evalCandStageHistory = new List<Candidate_Evaluation_Stage__c>();
            for(Candidate_Evaluation_Stage__c es: evalStageHistory){
                if(es.Candidate_Evaluation__c == candidateLineItem.id ){
                    evalCandStageHistory.add(es);
                }
            }
            //Add to wrapper class
            candidateEvaluationList.add(new CandidateEvaluation(candidateLineItem, evalCandStageHistory));
        }
        System.debug('CANDIDATE REQUISITION: ceGUIDs ' + ceGUIDs);
        
        //Aggregate results to list number of applications per status type
        updateApplicantNumbers();
        
        return candidateEvaluationList;
    }
    
    public PageReference getAllCandidates() {
        if(recordsUpdated == FALSE){
            getCandidateEvaluations();
        }else
        {
          getUpdatedCandidateEvaluations();  
        }
        return null;
    }    
   
    //Update Candidate Status
    public PageReference updateCandidateStatus(){   
        boolean saveRecords = false;
        candEvalList = new List<Candidate_Requisition__c>();
        system.debug ('candidateEvaluationList = ' + candidateEvaluationList);
        for(CandidateEvaluation ce : candidateEvaluationList){
            ceGUIDs.add(ce.evaluation.Id); //add ids to set to be looked up after the update
            system.debug ('CE = ' + ce);
            if(ce.selected == true) { //check if status updated
                if(ce.selectedOption != NULL && ce.selectedOption != '--' && ce.selectedOption != ce.evaluation.Status__c){
                    //if changed to accepted; confirm that we are not requesting more than the remaining required hires
                    if(ce.selectedOption == 'Accepted'){
                        NoOfAcceptedHiresInSave = NoOfAcceptedHiresInSave + 0;
                        if (NoOfAcceptedHires + NoOfAcceptedHiresInSave >= NoOfRequiredHires){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No of Accepted Hires will exceed number of Required Hires on the Requisition'));
                        }else
                        {
                            //Proceed with save
                            saveRecords = true; //at least one record updated
                            ce.evaluation.Status__c = ce.selectedOption;
                        }
                    }else
                    {
                        //Proceed with the save
                         saveRecords = true; //at least one record updated
                        ce.evaluation.Status__c = ce.selectedOption;
                    }
                    
                }
                /*
                //If Review Status Changed
                if(ce.selectedOptionReview != NULL && ce.selectedOptionReview != '--' && ce.selectedOptionReview != ce.evaluation.In_Review__c){
                    saveRecords = true; //at least one record updated
                    ce.evaluation.In_Review__c = ce.selectedOption; //update with same value as status as sharing same field
                }*/
          		//Rating Changed
                if(ce.newCandidateRating != NULL && ce.newCandidateRating != '--' && ce.newCandidateRating != ce.evaluation.Candidate_Rating__c){
                    saveRecords = true; //at least one record updated
                    ce.evaluation.Candidate_Rating__c = ce.newCandidateRating;
                }
                system.debug('ce.ReassignToNewRR.value = ' + ce.ReassignToNewRR.value);
                //Reassign to New Recruitment Req selected
                if(ce.ReassignToNewRR.value != NULL && String.valueOf(ce.ReassignToNewRR.value) != '' ){
                    saveRecords = true; //at least one record updated
                    system.debug('ce.ReassignToNewRR.value here = ' + ce.ReassignToNewRR.value);
                    //add to List
                    candEvalList.add(
                        new Candidate_Requisition__c(
                            Candidate__c = ce.evaluation.Candidate__c,
                            Status__c = 'Longlisted',
                            In_Review__c = 'Longlisted', //assuming that we are moving them to a Longlisted and not Open status
                            Candidate_Rating__c = '1', //give default rating
                            Comments__c = ce.evaluation.Candidate_Rating__c,
                            Date_Available__c = ce.evaluation.Date_Available__c,
                            Recruitment_Requisition__c = ce.ReassignToNewRR.value,
                            Years_Of_Experience__c = ce.evaluation.Years_Of_Experience__c
                        )
                    );
                }
                //add to list
                ce.evaluation.Comments__c = ce.evalComments;
                candEvalList.add(ce.evaluation);
            }
            system.debug('ce.evaluation = ' + ce.evalComments + ' **** ' + ce.evaluation);
        }
        //Update Candidate Requisition
        if(saveRecords == true){
            try{
                UPSERT candEvalList; //Doing UPSERT as new recruitment req might have been assigned
                if (!Cache.Session.contains('list')) {                   
                    // Add cache value to the partition
                    sessionPart.put('list', candidateEvaluationList); 
                    sessionPart.put('ceGUIDs', ceGUIDs); 
                }
                
                //update the wrapper list to return with the saved values
                for(CandidateEvaluation ce : candidateEvaluationList){
                    ce.ShowUpdatedRows();
                    ce.ReassignToNewRR.value = NULL;
                }
                //return to same VF page and refresh
                PageReference pageRef = new PageReference('/apex/BulkCandidateStatusUpdate');
                pageRef.getParameters().put('Id',recruitmentRequisition.Id);
                pageRef.getParameters().put('updateAction','Success');
                pageRef.getParameters().put('list',String.valueOf(ceGUIDs));
                pageRef.setRedirect(true);
                return pageRef;
                //return null;
            }        
            
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getTypeName()));
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getCause()));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getLineNumber()));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getStackTraceString()));
                system.debug('Update Status Error = ' + e.getMessage());
                
                //update the wrapper list to return with the saved values
                for(CandidateEvaluation ce : candidateEvaluationList){
                    //ce.ShowUpdatedRows();
                    ce.ReassignToNewRR.value = '';
                }
                
                //return to same page to display error
                return null;
            }
        }
        else{
            //Nothing was saved
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No records were selected for updating.'));
            return null;
        }
        
        //return new PageReference('/'+ recruitmentRequisition.Id);
        
    }
    
    public void updateApplicantNumbers(){
        //update the application status numbers
        aggCE = 
            [
                SELECT Status__c CEStatus, COUNT(id) Candidates, AVG(Recruitment_Requisition__r.Number_of_Required_Staff__c) ReqHires
                FROM Candidate_Requisition__c 
                WHERE Recruitment_Requisition__c =: recruitmentRequisition.id 
                GROUP BY Status__c
            ];
        NoOfRequiredHires = 0;
        NoOfAcceptedHires = 0; 
        NoOfRequiredHires = Integer.valueOf(aggCE[0].get('ReqHires'));
        NoOfTotalApps = 0;
        loopCounter = 0;
        NoOfAcceptedHiresInSave = 0;
        for(AggregateResult ag : aggCE){
            NoOfTotalApps = NoOfTotalApps + Integer.valueOf(aggCE[loopCounter].get('Candidates'));
            if(String.valueOf(aggCE[loopCounter].get('CEStatus')) == 'Accepted'){
                NoOfAcceptedHires = NoOfAcceptedHires + Integer.valueOf(aggCE[loopCounter].get('Candidates'));
            }
            loopCounter = loopCounter + 1;
        }
    }
    
    public void updateCandidateStatusDropDown() {        
        if(candidateEvaluationList!=null){
            for(CandidateEvaluation e: candidateEvaluationList){
                if(newCandidateStatus != null && e.selected == TRUE){
                    e.selectedOption = newCandidateStatus;
                }                               
            }
        }        
    }
    
    public void selectUnselectAll() {
        if(candidateEvaluationList!=null){
            for(CandidateEvaluation e:candidateEvaluationList){
                if(selectAllCheckbox==true){
                    e.selected=true;
                }else{
                    e.selected=false;
                }                             
            }
        }               
    }   

    // Candidate Requisition wrapper class
    public class CandidateEvaluation{        
		public Candidate_Requisition__c evaluation {get; set;}
        public List<Candidate_Evaluation_Stage__c> evaluationStages {get; set;}
		public Boolean selected {get; set;}
        public List<SelectOption> options {get; set;}
        public List<SelectOption> optionsReview {get; set;}
        public List<SelectOption> optionsRating {get; set;}
        public String selectedOption {get; set;}
        public String selectedOptionReview {get; set;}
        public String newCandidateRating {get; set;}
        public String evalComments {get; set;}
        public String ceRowStyle {get; set;}
        public String urlCVLoc {get; set;}
        public String urlCLLoc {get; set;}
        public LookupValue ReassignToNewRR {get; set;} 
        public Boolean recordLocked {get; set;}
        public Boolean evalStagesRendered {get; set;}
		//Constructor
		public CandidateEvaluation(Candidate_Requisition__c e, List<Candidate_Evaluation_Stage__c> es) {
			evaluation = e;
            evaluationStages = es;
            selected = false;
            evalStagesRendered = false;
            this.ReassignToNewRR = new LookupValue();
            if(evaluation.Status__c == 'Accepted'){
                //disable this record
                recordLocked = TRUE;
                ceRowStyle = 'background:#def0ac;font-weight: normal; vertical-align: middle;text-align: center;'; //Highlight selected row
            }else if(evaluation.Status__c == 'Declined'){
                recordLocked = TRUE;
                ceRowStyle = 'background:#ffe4e4;font-weight: normal; vertical-align: middle;text-align: center;'; //Highlight selected row
            }
            else
            {
                recordLocked = FALSE;
                ceRowStyle = 'background:#ffffff;font-weight: normal;vertical-align: middle;text-align: center;'; //Highlight selected row
            }
            
            selectedOption = '--None--';
            options=new List<SelectOption>();
            options.add(new SelectOption('--','--None--'));
            options.add(new SelectOption('Open','Open'));
            options.add(new SelectOption('Longlisted','Longlisted'));
            options.add(new SelectOption('Shortlisted','Shortlisted'));
            options.add(new SelectOption('Interview','Interview'));
            options.add(new SelectOption('Accepted','Accepted'));
            options.add(new SelectOption('Declined','Declined'));
            
            selectedOptionReview = '--None--';
            optionsReview=new List<SelectOption>();
            optionsReview.add(new SelectOption('--','--None--'));
            optionsReview.add(new SelectOption('Open','Open'));
            optionsReview.add(new SelectOption('Longlisted','Longlisted'));
            optionsReview.add(new SelectOption('Shortlisted','Shortlisted'));
            //optionsReview.add(new SelectOption('Phone Interview','Phone Interview'));
            //optionsReview.add(new SelectOption('Face to Face Interview','Face to Face Interview'));
            optionsReview.add(new SelectOption('Interview','Interview'));
            optionsReview.add(new SelectOption('Accepted','Accepted'));
            optionsReview.add(new SelectOption('Declined','Declined'));
            
            //Candidate Ratings
            newCandidateRating = '--None--';
            optionsRating=new List<SelectOption>();
            optionsRating.add(new SelectOption('--','--None--'));
            optionsRating.add(new SelectOption('1','1'));
            optionsRating.add(new SelectOption('2','2'));
            optionsRating.add(new SelectOption('3','3'));
            optionsRating.add(new SelectOption('4','4'));
            optionsRating.add(new SelectOption('5','5'));
		}
        
        public void RenderEvalStages(){
            if(evalStagesRendered == TRUE){
                evalStagesRendered = FALSE;
            }else
            {
                evalStagesRendered = TRUE;
            }
        }
        
        public PageReference ConvertToEmp(){
            PageReference pageRef = new PageReference('/apex/ConvertCandidateToEmployee');
                pageRef.getParameters().put('Id', evaluation.Candidate__c);
                pageRef.getParameters().put('RecReqId', evaluation.Recruitment_Requisition__c);
                pageRef.setRedirect(true);
                return pageRef;
        }
        
        public void ShowUpdatedRows(){
            if(selected == TRUE){
                selected = false;
                ceRowStyle = 'background:#def0ac;font-weight: normal;vertical-align: middle;text-align: center;'; //Highlight selected row
                evaluation.Comments__c = evalComments;
                evalComments = '';
                //evaluation.In_Review__c = selectedOptionReview;
                //selectedOptionReview = '--';
                selectedOption = '--None--';
                evaluation.Candidate_Rating__c = newCandidateRating;
                newCandidateRating = '--';
            } else
            {
                //default color/style
                ceRowStyle = 'background:#ffffff;font-weight: normal;vertical-align: middle; text-align: center;'; //Highlight selected row
            }
        }
    }    
}