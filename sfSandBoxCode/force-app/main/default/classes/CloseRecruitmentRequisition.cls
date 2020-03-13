public class CloseRecruitmentRequisition {
    private ApexPages.StandardController standardController;
    public Recruitment_Requisition__c rr {get;set;}
    public Recruitment_Requisition__c ReqRecToSave{get;set;}
    public List<candEvalWrapper> candEvalItems {get;set;}
    public List<Candidate_Requisition__c> CandEvalsList {get;set;}
    public List<Candidate_Requisition__c> CandEvalsListToSave {get;set;}
    public List<RecReqWrp> OpenRecReqs {get;set;}
    Public Boolean showRecords {get;set;}
    
    //Constructor
    public CloseRecruitmentRequisition(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.rr=(Recruitment_Requisition__c) standardController.getRecord();
        this.rr = [
            SELECT name, Employee_Role__c, Employee_Role__r.Name, Requestor__c, Request_Date__c, Job_Description__c,Stage__c,
            Requesting_Department__c, Number_of_Required_Staff__c,Justification_for_Additional_staff__c,Candidate_Specification__c,
            Duration_of_Fixed_term_Contract_Months__c,Is_recruitment_budgeted__c,Location__c, Proposed_Employee_required_Date__c
            FROM Recruitment_Requisition__c
            WHERE id =: this.rr.id
        ];
        if(rr.Stage__c == 'Closed'){
            showRecords = FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Requisition is already closed'));
        }else
        {
            showRecords = TRUE;
            getCandidateEvals();
            
            //Get open Recruitment Reqs
            OpenRecReqs = new List<RecReqWrp>();
            getOpenRecReqs();
        }
    }
    
    public List<RecReqWrp> getOpenRecReqs(){
        //get any open Recruitment Reqs that existing candidates can be re-assigned to
        List<Recruitment_Requisition__c> recReqList = [
            SELECT id, Name,Stage__c, CreatedDate
            FROM Recruitment_Requisition__c
            WHERE Stage__c <> 'Closed' AND Employee_Role__c =:  rr.Employee_Role__c
            ORDER BY CreatedDate DESC 
        ];
        //add to wrapper class list
        for(Recruitment_Requisition__c r:recReqList ){
            OpenRecReqs.add(new RecReqWrp (r));
        }
        
        for(RecReqWrp rec : OpenRecReqs){
            //disable current record and do not allow for selection
            if(rec.req.id == rr.id) {
                rec.selectedRecord = FALSE;
                rec.disableProcessChkBox = TRUE;
                rec.ceRowStyle = 'background:#ffe4e4;font-weight: bold;'; //Highlight selected row
            } 
        }
        return OpenRecReqs;
    }
    
    public List<candEvalWrapper> getCandidateEvals(){
        candEvalItems = new List<candEvalWrapper>();
        CandEvalsList = 
            [
                SELECT Candidate_Rating__c,Candidate_Star_Rating__c,Candidate__c,Candidate__r.Name,Comments__c,
                CreatedDate,Date_Available__c,Id,In_Offer__c,In_Review__c,Name,Recruitment_Requisition__c,Status__c,
                Years_Of_Experience__c 
                FROM Candidate_Requisition__c
                WHERE Recruitment_Requisition__c =: this.rr.id
                AND Status__c NOT IN ('Accepted','Declined')
                ORDER BY Candidate__r.Name 
            ];
        system.debug('CandEvalsList = ' + CandEvalsList);
        
        for(Candidate_Requisition__c item : CandEvalsList){
            candEvalWrapper wrapper = new candEvalWrapper(item);
            candEvalItems.add(wrapper);
        }
        return candEvalItems; 
    }
    
    public PageReference CloneAndSave(){
        //clone current Recruitment Req
        //check if existing recruitment reqs first and save to that
        Boolean saveRecord = false;
        Integer selectedRows = 0;
        string reqIdToUpdate = '';
        if(OpenRecReqs != NULL && OpenRecReqs.size()>0){
            for(RecReqWrp rec : OpenRecReqs){
                //disable current record and do not allow for selection
                if(rec.selectedRecord == TRUE) {
                    system.debug('rec.selectedRecord = ' + rec.selectedRecord);
                    selectedRows = selectedRows + 1;
                    if(selectedRows > 1){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Only one row can be selected for saving'));
                        return null;                        
                    }
                    reqIdToUpdate = rec.req.id;
                    saveRecord = TRUE;
                } 
            }
            system.debug ('selectedRows + reqIdToUpdate +  saveRecord = ' + selectedRows + ' ** ' + reqIdToUpdate + ' *** ' + saveRecord);
        }
        //determine to save to existing or create new Recruitment Req
        if(selectedRows == 1 && reqIdToUpdate != NULL && saveRecord == TRUE) {
            // use reqIdToUpdate
        } else
        {
            ReqRecToSave = new Recruitment_Requisition__c (
                name = rr.Employee_Role__r.Name + String.valueOf(datetime.now().format('YYYY-MM-dd')),
                Employee_Role__c = rr.Employee_Role__c,
                Requestor__c = rr.Requestor__c,
                Request_Date__c = Date.today(),
                Requesting_Department__c = rr.Requesting_Department__c,
                Number_of_Required_Staff__c = rr.Number_of_Required_Staff__c,
                Justification_for_Additional_staff__c = rr.Justification_for_Additional_staff__c,
                Candidate_Specification__c = rr.Candidate_Specification__c,
                Duration_of_Fixed_term_Contract_Months__c = rr.Duration_of_Fixed_term_Contract_Months__c,
                Is_recruitment_budgeted__c = rr.Is_recruitment_budgeted__c,
                Location__c = rr.Location__c,
                Proposed_Employee_required_Date__c = Date.today(),
                Job_Description__c = rr.Job_Description__c,
                Stage__c = 'Open'
            );
            
            INSERT ReqRecToSave;
            reqIdToUpdate = ReqRecToSave.id;
        }
        //For all selected items, add them to the new requisition created
        CandEvalsListToSave = new List<Candidate_Requisition__c>();
        
        for(candEvalWrapper ceItem : candEvalItems){
            if(ceItem.selected == TRUE){
                //if selected add to save list
                ceItem.candEvals.id = NULL;
                ceItem.candEvals.Recruitment_Requisition__c = reqIdToUpdate;
                CandEvalsListToSave.add(ceItem.candEvals);
            }
        }      
        if(CandEvalsListToSave == NULL || CandEvalsListToSave.size() == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No rows were selected for updating'));
            return null; 
        }else
        {
            //Loop through the list and find any candidates thatmight need to be upsee
            List<Candidate_Requisition__c> ceInReqToUpdate = 
                [
                    SELECT Candidate_Rating__c,Candidate_Star_Rating__c,Candidate__c,Candidate__r.Name,Comments__c,
                    CreatedDate,Date_Available__c,Id,In_Offer__c,In_Review__c,Name,Recruitment_Requisition__c,Status__c,
                    Years_Of_Experience__c 
                    FROM Candidate_Requisition__c
                    WHERE Recruitment_Requisition__c =: reqIdToUpdate
                    ORDER BY Candidate__r.Name 
                ];
            
            system.debug('CandEvalsListToSave = ' + CandEvalsListToSave);
            //upsert the candidate evaluations
            if(CandEvalsListToSave != NULL && CandEvalsListToSave.size() > 0){
                if(ceInReqToUpdate != NULL && ceInReqToUpdate.size() >0){
                    //Loop through and if we find the candidate, assign ther ID to that ofthislist so that an UPDATE instead of an INSERT can occur
                    for(Candidate_Requisition__c c: CandEvalsListToSave){
                        for(Candidate_Requisition__c ce: ceInReqToUpdate){
                            if(ce.Candidate__c == c.Candidate__c){
                                c.id = ce.id; //swapping the ids will force an upsert
                                break;
                            }
                        }
                    }
                }
                try{
                    UPSERT CandEvalsListToSave; 
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records successfully updated'));
                }
                catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                }
                return null;
            }
            
            return new PageReference('/'+ reqIdToUpdate);  //return to new recruitment req
        }
    }
    
    public PageReference CloseReq(){
        //close current req
        rr.Name = rr.Name + '***CLOSED***';
        rr.Stage__c = 'Closed';
        UPDATE rr;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Recruitment Req Closed'));
        return new PageReference('/'+ rr.id);
    }
    //Candidate Evaluation Line Items Wrapper Class 
    public class candEvalWrapper{
        public Candidate_Requisition__c candEvals{get;set;}
        
        public Boolean selected {get; set;}
        public Boolean disableProcessChkBox {get; set;}
        public Boolean disableLastVIChkBox {get; set;}
        
        
        public candEvalWrapper(Candidate_Requisition__c ce){
            //selected = true;
            disableProcessChkBox = false;
            disableLastVIChkBox = false;
            candEvals = ce;
        }
    }
    
    //Select All Items to Process
    public PageReference selectAll() {
        if(candEvalItems!=null){
            for(candEvalWrapper itm : candEvalItems){
                if(itm.disableProcessChkBox == false){
                    itm.selected=true; 
                } else {
                    itm.selected=false;
                }
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No items available to Select/UnSelect');
            ApexPages.addmessage(msg);
        }
        return null;
    }
    
    //Unselect All Items to Process
    public PageReference unselectAll() {
        if(candEvalItems!=null){
            for(candEvalWrapper itm : candEvalItems){
                if(itm.disableProcessChkBox == false){
                    itm.selected=false; 
                } 
            }
        } 
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No items available to Select/Unselect');
            ApexPages.addmessage(msg);
        }
        return null;
    }     
    
    //Recruitment_Requisition__c Wrapper Class
    Public class RecReqWrp {
        public Recruitment_Requisition__c req {get; set;}
        public Boolean selectedRecord {get; set;}
        public String ceRowStyle {get; set;}
        public Boolean disableProcessChkBox {get; set;}
        
        //constructor
        Public RecReqWrp(Recruitment_Requisition__c rr){
            req = rr;
        }
    }
}