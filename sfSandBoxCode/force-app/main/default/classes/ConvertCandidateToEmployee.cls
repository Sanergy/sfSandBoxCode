public class ConvertCandidateToEmployee {
    //create standard controller
    private ApexPages.StandardController controller;
    
    public Candidate__c candidate {get; set;}
    public Employee__c employee {get; set;}
    public String RecReqId {get; set;}
    public Recruitment_Requisition__c RecReq {get; set;}
    public List <RecReqLineItems> wrpRecReqLineItems {get; set;}
    
    public ConvertCandidateToEmployee(ApexPages.StandardController controller){  
        RecReqId = apexpages.currentpage().getparameters().get('RecReqId');
        //get Recruitment Requisition
        RecReq = 
            [
                SELECT ID,Employee_Role__r.Company_Division__c,Employee_Role__r.Department__c,Employee_Role__r.Line_Manager__c,
                Requesting_Department_Team_Lead__c,Employee_Role__r.Sanergy_Department_Unit__c,
                Employee_Role__r.Sanergy_Department__c,Employee_Role__r.Id, Type_of_employment__c,
                Requesting_Department__c,Location__c,Employee_Role__c, Employee_Role__r.Name
                FROM Recruitment_Requisition__c
                WHERE id =: RecReqId
                LIMIT 1
            ];
        //if no RecReq found throw error
        if(RecReq != NULL && RecReq.Id != NULL){
            this.controller = controller;                
            candidate = (Candidate__c) controller.getRecord();
            candidate = 
                [
                    SELECT Id, Name, First_Name__c, Middle_Name__c, Last_Name__c,Employee_Id__c, Recruitment_Requisition__c, 
                    Recruitment_Requisition__r.Name, Recruitment_Requisition__r.Employee_Role__c,
                    Recruitment_Requisition__r.Employee_Role__r.Name, 
                    Email__c,Candidate_Status__c,
                    ID_Number__c, Phone_Number__c,Highest_Education__c
                    FROM Candidate__c
                    WHERE Id =: candidate.Id
                    LIMIT 1
                ];
            wrpRecReqLineItems = new List<RecReqLineItems>();
            returnRecReqLineItems();
            
            //check if the Candidate has already been converted
            if(candidate.Employee_Id__c == NULL){
                //check if user is allowed to Convert the employee
                if(VerifyUser() == TRUE){
                    
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have permissions to Convert the Candidate to and Employee')); 
                } 
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Candidate has already been converted to an Employee')); 
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Recruitment Requisition Found Matching the supplied Id')); 
        }
    }
    
    private Boolean VerifyUser(){
        //check current user is part of BambooHR Admin Team
        AggregateResult[] agg = 
            [
                SELECT count(Id) userCount FROM PermissionSetAssignment 
                WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'BambooHR_Admin'
            ];
        integer n = (integer) agg[0].get('userCount');
        
        //If found return true
        if(n == 1){return TRUE; } else {return FALSE;}
    }
    
    public void returnRecReqLineItems(){
        List<Recruitment_Request_Config__c> roleConfig = 
            [
                SELECT Id,Name,Employee_Role__c,Type__c, Description__c,Returnable__c,Maximum__c,Amount__c, 
                RecordType.Name
                FROM Recruitment_Request_Config__c 
                WHERE Employee_Role__c =: RecReq.Employee_Role__c
                ORDER BY RecordType.Name, Type__c
            ];
        //loop through and add to wrapper class
        //wrpRecReqLineItems.clear();
        if(roleConfig != NULL && roleConfig.size() > 0){
            for(Recruitment_Request_Config__c rc:roleConfig){
                wrpRecReqLineItems.add(new RecReqLineItems(rc));
            }
        }
    }
    //convert candidate to Employee
    Public PageReference ConvertCandidate(){
        /*This code works, commented out as we are not initially doing this - James 2020-02-18
        if(candidate.Candidate_Status__c == 'Offer Accepted'){
            Double hrNumber = 0;
            //create Employee Record
            if(RecReq != NULL){
                Employee__c employee = new Employee__c();
                employee.Employee_First_Name__c = candidate.First_Name__c;
                employee.Employee_Last_Name__c = candidate.Last_Name__c;
                employee.Employee_Middle_Name__c = candidate.Middle_Name__c;
                employee.Employee_Role__c = RecReq.Employee_Role__c;
                employee.Employment_Start_Date__c = Date.today();
                employee.Employment_Status__c = RecReq.Type_of_employment__c;
                employee.Identification_Document__c = 'National ID';
                employee.Identification_Number__c = candidate.ID_Number__c;
                employee.Job_Title__c = null;
                employee.Line_Manager__c = RecReq.Employee_Role__r.Line_Manager__c;
                employee.Primary_Phone__c = candidate.Phone_Number__c;
                employee.Recruitment_Requisition__c = RecReq.Id;
                employee.Sanergy_Department__c = RecReq.Employee_Role__r.Department__c;
                employee.Sanergy_Department_Unit__c = RecReq.Employee_Role__r.Sanergy_Department_Unit__c;
                employee.Company_Division__c = RecReq.Employee_Role__r.Company_Division__c;
                employee.Tickets_Created__c = false;                
                INSERT employee;
                
                //Update Candidate
                candidate.Employee_Id__c = employee.Id;
                UPDATE candidate;
                
                List<Recruitment_Requisition_Line_Item__c> recReqItems = new List<Recruitment_Requisition_Line_Item__c>();
                List <Staff_Allowances__c> staffAllowances = new List<Staff_Allowances__c>();
                
                //insert selected Role allowances, assets
                for(RecReqLineItems rrConfig: wrpRecReqLineItems){
                    if(rrConfig.itemSelected == TRUE){
                        Recruitment_Requisition_Line_Item__c recReqLineItem = new Recruitment_Requisition_Line_Item__c();
                        recReqLineItem.Type__c = rrConfig.recReq.Type__c;
                        recReqLineItem.Employee__c = employee.Id;
                        recReqLineItem.Recruitment_Requisition__c = employee.Recruitment_Requisition__c;
                        recReqLineItem.Status__c = 'Pending';
                        switch on rrConfig.recReq.RecordType.Name{
                            when 'Account'{
                                
                            }
                            when 'Asset' {
                                recReqLineItem.Asset_is_Returnable__c = rrConfig.recReq.Returnable__c;
                            }
                            when 'Allowance' {
                                recReqLineItem.Maximum_amount__c = rrConfig.recReq.Maximum__c;
                                //add Allowance record for approvals
                                Staff_Allowances__c staffAllowanceItem = new Staff_Allowances__c
                                    (
                                        RecordTypeId = '012D0000000caMQ', //Allowance Record Type
                                        Allowance_Type__c = rrConfig.recReq.Type__c,                           
                                        Employee__c = employee.Id,
                                        Allowance_Description__c = rrConfig.recReq.Type__c,
                                        Start_Date__c = employee.Employment_Start_Date__c,
                                        Department_Unit__c = employee.Sanergy_Department_Unit__c,
                                        Allowance_Frequency__c = 'Monthly',
                                        End_Date__c = employee.Employment_Start_Date__c,
                                        Sanergy_Department__c = employee.Sanergy_Department__c
                                    );
                                staffAllowances.add(staffAllowanceItem);
                            }
                        }
                        //add to recReqItems List
                        recReqItems.add(recReqLineItem);
                    }
                   
                    
                }
                //Insert records
                if(recReqItems!= NULL && recReqItems.size() > 0) {
                    INSERT recReqItems;
                }
                if(staffAllowances != NULL && staffAllowances.size() > 0){
                    INSERT staffAllowances;
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Role Assets and Allowances have been successfully Updated')); 
            }
        }
*/
        RETURN NULL;
    }
    
    //wrapper class for Recruitment Requisition Line Items to be added
    public class RecReqLineItems{
        public Recruitment_Request_Config__c recReq {get; set;}
        public Boolean itemSelected {get; set;}
        public RecReqLineItems( Recruitment_Request_Config__c rr){
            recReq = rr;
            itemSelected = TRUE;
        }
    }
}