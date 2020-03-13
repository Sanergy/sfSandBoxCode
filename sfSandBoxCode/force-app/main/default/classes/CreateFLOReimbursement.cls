public class CreateFLOReimbursement {
    //create standard controller
    private ApexPages.StandardController controller;
    
    public Account acc {get; set;} 
    public Opportunity opp {get; set;} 
    
    public List<Toilet__c> flts {get; set;}
    public List<Electronic_Payment_Request__c> EPRs {get; set;}
    public List<OpportunityLineItem> oppProducts {get; set;}
    public List<Special_Procurement__c> sprs {get; set;}
    public List<Attachment> currAttachments {get; set;}
    public Employee__c emp = new Employee__c();
    
    Public Decimal EPRValue {get;set;}
    public String EPRItemFLT {get;set;}
    public String EPRItemNotes {get;set;}
    public Toilet__c fltToUpdate = new Toilet__c();
    
    public Boolean hideButtons {get; set;}
    public Integer totalCount {get;set;}
    
    public Integer reconRowIndex {get;set;}
    public Attachment oppAttach = new Attachment();
    
    public Blob attachBody {get; set;}
    public String contentType {get; set;}
    public String fileName {get; set;}
    public String attMsg {get; set;}
    
    // Constructor
    public CreateFLOReimbursement(ApexPages.StandardController controller){               
        this.controller=controller; 
        opp=(Opportunity)controller.getRecord();
        
        opp = [
            SELECT Id, Name, Account.Id, Account.Name, Primary_Salesperson__c, Primary_Salesperson__r.Name,StageName,
            Stage_Date__c, CloseDate, RecordType.Name,Account.Mobile_Payment_Phone_Number__c, Amount, Deposit_Amount_Received__c,
            Sub_Area_Lookup__c, Sub_Area_Lookup__r.Name, Deposit_Paid_Date__c, Location__c, Location__r.Name, M_Pesa_Code__c,
            Reason_Why_Lost__c, Reason_Why_Lost_other__c
            FROM Opportunity
            WHERE id =: Opp.Id 
        ];
        
        //set Defaults
        flts = new List<Toilet__c>();
        getFLTs();
        EPRS = new List<Electronic_Payment_Request__c>();
        getEPRs();
        EPRValue = 0;
        EPRItemFLT = ''; //FLT Name to be inserted in the EPR Line Item
        EPRItemNotes = opp.Reason_Why_Lost__c != NULL ? opp.Reason_Why_Lost__c : '' + ' [' + 
            opp.Reason_Why_Lost_other__c != NULL ? opp.Reason_Why_Lost_other__c : '' +']'; //save Reason why lost from Opp
        oppProducts = new List<OpportunityLineItem>();
        getOppProducts();
        getEmployee();
        getSPRs();
        getAttachments();
        fileName = '***';
        
        if(opp.M_Pesa_Code__c == NULL || opp.Deposit_Amount_Received__c == NULL || opp.Account.Mobile_Payment_Phone_Number__c == NULL){
            hideButtons = TRUE;
        }
    }
    
    public void getEmployee(){
        //get employee Record ID
        emp = [SELECT id, Name FROM Employee__c WHERE Employee_SF_Account__c =: UserInfo.getUserId()  LIMIT 1];
      
    }
    
    public void getFLTs(){
        //get FLTs for this FLO
        flts = [
            SELECT Id, Name, Operational_Status__c, Current_Specific_Status__c, Opening_Date__c ,FLO_Reimbursed__c
            FROM Toilet__c
            WHERE Opportunity__c = : opp.Id
        ];
    }
    
    public void getEPRs(){
        EPRs = [
            SELECT Id, Name, Company__c, Cash_Entry__c, Cash_Entry__r.Name, Comments__c, Confirmation_Number__c, EPR_Type__c,
            Gross_Payment_Amount__c, Mobile_Number__c, Payment_Type__c, department__c, department__r.Name,Notes__c,
            Payment_Date__c, MPESA_payment_number__c
            FROM Electronic_Payment_Request__c
            WHERE Vendor_Company__c =: opp.AccountId
        ];
    }
    
    public void getOppProducts(){
        oppProducts = 
            [SELECT Product2.Name, UnitPrice, Quantity , TotalPrice
             FROM OpportunityLineItem
             WHERE Opportunity.Id =: opp.Id];
    }
    
    public void getSPRs(){
        sprs = [SELECT Id, Name,Requestor__c,Requestor__r.Name,Requestor__r.Sanergy_Department__r.Name,
                Requestor__r.Sanergy_Department_Unit__r.Name,Requestor__r.Employee_Role__r.Name,
                Type__c,Required_Date__c,Comments__c,Requesting_Department__c, Requestor__r.Team_Lead__r.Name,
                Requesting_Department__r.lookup_ID__c,Payable_Invoice__c, Payable_Invoice__r.Name,
                Approve_Reconciliation__c, Requesting_Department__r.Name,Vendor__c,Vendor__r.name,Vendor_Currency__c,Total_Amount__c,Payment_Method__c,
                Total_Amount_Requested__c, Total_Payments__c,Requesting_Department_TL__c,Approval_Status__c,Stage__c,Dim_2__c,
                Dim_3__c, GLA__c, GLA__r.lookup_ID__c,Grant__c, Reconciliation_Submitted__c,Requesting_Company__c,Requesting_Company__r.Name,
                Status_Flag__c,Reconciled_Balance__c,Reconciled_Total__c,
                Reconciliation_Completed__c,Recon_EPR_Generated__c,Recon_EPR__c, Recon_SPR__c, Recon_SPR__r.Name, 
                Recon_EPR__r.Name, OwnerId
                FROM Special_Procurement__c
                WHERE Opportunity__c =: opp.Id];
    }
    
    public void getAttachments(){
        currAttachments = 
            [
                SELECT Id, Name, ParentId, Parent.Type 
                FROM Attachment 
                WHERE ParentId =: opp.id
            ];
        system.debug ('getAttachments() = ' + opp.id + ' *** ' + currAttachments);
    }
    /*
    //Create EPR
    public PageReference createEPR(){    
        //If M_Pesa_Code__c missing, exit
        if(opp.M_Pesa_Code__c == NULL || opp.M_Pesa_Code__c == '--' || opp.Deposit_Amount_Received__c <= 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select an Opportunity with a Valid MPesa code/Deposit to complete reimburse'));
            return NULL;
        }else
        {
            fltToUpdate = [SELECT id, Name, FLO_Reimbursed__c FROM Toilet__c WHERE Id =: EPRItemFLT LIMIT 1];
        }
        
        if(fltToUpdate != NULL){
            //Check amounts
            if(EPRValue < 1 || EPRValue > opp.Amount){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Reimbursement amount cannot be less than 0 or greater than ' + opp.Amount));
            }
            //check valid FLT
            else if (EPRItemFLT == NULL || EPRItemFLT == '--' || fltToUpdate.FLO_Reimbursed__c == TRUE)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a valid FLT to reimburse'));
            }
            else 
            {
                try{
                    // Create an instance of EPR
                    Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();         
                    
                    //Create EPR
                    epr.Company__c = 'Fresh Life Initiative Ltd';
                    epr.department__c = Id.valueOf('aEBD00000008SEk'); //Fresh Life - Sales FFA Config
                    epr.Vendor_Company__c = opp.Account.Id;
                    epr.Invoice_Number__c = String.valueOf(opp.Account.Mobile_Payment_Phone_Number__c);                              
                    epr.Scheduled_Payment_Date__c = date.today();                
                    epr.Notes__c= EprItemNotes;
                    epr.Comments__c ='FLO Reimbursement for '+ this.opp.Account.name +' as per Opportunity '+ this.opp.Name;
                    
                    switch on spr1.Requesting_Company__r.Name {
                        when 'Sanergy Limited' {epr.Payment_Type__c  = 'Payment on Invoice';}
                        when 'Fresh Life Initiative Limited' {epr.Company__c = 'Fresh Life Initiative Ltd';}
                        when 'Sanergy, Inc. (FP)' {epr.Company__c = 'Sanergy Inc (FP)';}
                        when 'Sanergy, Inc. (NP)' {epr.Company__c = 'Sanergy Inc (NP)';}
else {epr.Payment_Type__c  = 'Payment on Invoice';}
                    }
                    
                    epr.Payment_Type__c = 'FLO Reimbursement';
                    epr.Preferred_Payment_Method__c = 'Electronic';
                    epr.Source_Doc_Opportunity__c = opp.id;
                    
                    INSERT epr;
                    
                    // Create EPR Payable Item if not a carry over balance
                    EPR_Payable_Item__c eprLineItems = new EPR_Payable_Item__c();            
                    eprLineItems.epr__c=epr.id;
                    eprLineItems.Department_dim1__c = epr.department__c;
                    eprLineItems.Item__c = fltToUpdate.Name + ' [FLO Reimbursement]';
                    eprLineItems.Quantity__c = 1;
                    eprLineItems.Unit_Price__c = EPRValue;
                    eprLineItems.Location_Dim2__c = 'aEBD00000008SFG'; //Mukuru FFA Config
                    eprLineItems.Dim_3__c = 'aEBD00000008SGk';  //Not Applicable FFA Config              
                    eprLineItems.GLA__c = 'aEBD00000008SJ1'; //1200 - Accounts Receivable Control/
                    
                    INSERT eprLineItems;
                    
                    // Create an approval request for the EPR
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting request for approval.');
                    req.setObjectId(epr.Id);
                    
                    // Submit the EPR for approval
                    Approval.ProcessResult result = Approval.process(req);            
                    
                    //Update FLT
                    fltToUpdate.FLO_Reimbursed__c = TRUE;
                    UPDATE fltToUpdate;
                    
                    return new PageReference('/'+epr.id);
                }
                catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                }
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a valid FLT to reimburse'));
        }
        return NULL;
    }
    */
    public PageReference CreateFLOReimbursementSPR(){
        //check if Confirmation code exists
        if(opp.M_Pesa_Code__c == '' || String.valueOf(opp.Account.Mobile_Payment_Phone_Number__c) =='' || 
           EPRValue < 1 || EPRValue > opp.Deposit_Amount_Received__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'MPesa details or Reimbursement Values are invalid'));
            return NULL;
        } 
        else 
        {
            //check if MPesa Code has already been applied
            List <Special_Procurement_Line_Item__c> SPRLI = 
                [
                    SELECT Id, Name, Item__c, Specifications__c, Quantity_Requested__c, Status__c, Net_Total_Amount__c,
                    Total_VAT__c, Total_Price__c, Request_Type__c
                    FROM Special_Procurement_Line_Item__c
                    WHERE item__c =: opp.M_Pesa_Code__c
                    ORDER BY Name
                ];
            if(SPRLI != NULL && SPRLI.size() > 0){
                //means MPESA code has already been applied
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Reimbursement has already been applied to this MPESA Code'));
            }
            else
            {
                try
                {
                    Special_Procurement__c sp = new Special_Procurement__c ();
                    //set defaults
                    sp.Requesting_Company__c = 'aEBD0000000kA4j';// 'Fresh Life Initiative Ltd' FFA Config;
                    sp.Vendor__c = opp.Account.Id;
                    sp.Opportunity__c = opp.Id;
                    sp.requestor__c = emp!=NULL ? emp.Id : '005D0000003Ykhb'; //default to TempRS if no emp found
                    sp.Requesting_Department__c = Id.valueOf('aEBD00000008SEk'); //Fresh Life - Sales FFA Config
                    sp.Dim_2__c = 'aEBD00000008SFG'; //Mukuru FFA Config
                    sp.Dim_3__c = 'aEBD00000008SGk';  //Not Applicable FFA Config
                    sp.Grant__c = 'aEBD00000008SHk'; //Not Applicable FFA Config Grant
                    sp.GLA__c = 'aEBD00000008SJ1'; //1200 - Accounts Receivable Control
                    sp.Required_Date__c = date.today()+1;
                    sp.Payment_Method__c = 'Electronic';
                    
                    sp.stage__c = 'Open';
                    sp.Type__c = 'FLO Reimbursement'; 
                    sp.Approval_Status__c = 'Pending Approval';
                    sp.Approve_Reconciliation__c = FALSE;
                    sp.Recon_EPR_Generated__c = FALSE;
                    sp.Reconciliation_Submitted__c = FALSE;
                    sp.Reconciliation_Completed__c = FALSE;
                    sp.Payable_Invoice__c = NULL;
                    sp.EPR_Created__c = FALSE;
                    sp.Generate_EPR__c = FALSE;
                    sp.Comments__c = 'FLO Reimbursement: ' + opp.M_Pesa_Code__c;
                    sp.Recon_EPR__c = NULL;
                    sp.Recon_SPR__c = NULL;
                    
                    INSERT sp;
                    sp = [SELECT id, Name FROM Special_Procurement__c WHERE Id =: sp.id];
                    
                    //Insert SPR Line Item
                    Special_Procurement_Line_Item__c sprline = new Special_Procurement_Line_Item__c();
                    sprline.Special_Procurement__c = sp.ID;
                    sprline.Item__c = opp.M_Pesa_Code__c;
                    sprline.Specifications__c = 'FLO Reimbursement: ' + opp.Name;
                    sprline.Request_Type__c = 'Not Applicable';
                    sprline.Currency__c = 'aHQD0000000blJJ';
                    sprline.Create_PR_Line_Item__c = false;
                    sprline.Quantity_Requested__c = 1;
                    sprline.Unit_Price__c = EPRValue;
                    sprline.EPR_Created__c = FALSE;
                    sprline.Balance_Carried_Forward__c = FALSE;
                    INSERT sprline;
                    
                    // Create an approval request for the SPR
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting request for approval.');
                    req.setObjectId(sp.Id);
                    
                    // Submit the EPR for approval
                    Approval.ProcessResult result = Approval.process(req);            

                    //Display SPRs
                    getSPRs();
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reimbursement SPR has been successfully generated'));
                }
                catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                }
            }
        }
        return NULL;
    }
    
    public PageReference CreateFLTCommission(){
        /*
        Special_Procurement__c sp = new Special_Procurement__c ();
        //set defaults
        sp.stage__c = 'Open';
        sp.Type__c = 'FLT Commissions'; 
        sp.Approval_Status__c = 'Pending Approval';
        sp.Approve_Reconciliation__c = FALSE;
        sp.Recon_EPR_Generated__c = FALSE;
        sp.Reconciliation_Submitted__c = FALSE;
        sp.Reconciliation_Completed__c = FALSE;
        sp.Payable_Invoice__c = NULL;
        sp.EPR_Created__c = FALSE;
        sp.Generate_EPR__c = FALSE;
        sp.Comments__c = 'FLT Commissions';
        sp.Recon_EPR__c = NULL;
        sp.Recon_SPR__c = NULL;
        
        INSERT sp;
        sp = [SELECT id, Name FROM Special_Procurement__c WHERE Id =: sp.id];
        
        //Insert SPR Line Item
        Special_Procurement_Line_Item__c sprline = new Special_Procurement_Line_Item__c();
        sprline.Special_Procurement__c = sp.ID;
        sprline.Item__c = '';
        sprline.Specifications__c = '';
        sprline.Request_Type__c = 'Not Applicable';
        sprline.Currency__c = 'aHQD0000000blJJ';
        sprline.Create_PR_Line_Item__c = false;
        sprline.Quantity_Requested__c = 1;
        sprline.Unit_Price__c = EPRValue;
        sprline.EPR_Created__c = FALSE;
        sprline.Balance_Carried_Forward__c = FALSE;
        INSERT sprline;
        
*/
        RETURN NULL;
    }
    //FLT Drop Down List
    public List<SelectOption> oppFLTs {
        get{
            oppFLTs = new List<SelectOption>();
            oppFLTs.add(new SelectOption('--', '--Select FLT--'));
            for(Toilet__c flt : flts)
            {
                //Add only eligible FLTs
                if(flt.FLO_Reimbursed__c == FALSE){
                    oppFLTs.add(new SelectOption(flt.Id, flt.Name));
                }
            }
            return oppFLTs;
        }
        set;
    }
    
    public PageReference AttachFile(){
        if(opp.id != NULL){
            oppAttach.ParentId = opp.id;
            oppAttach.Name = '[' + opp.Name + '] ' + fileName;
            oppAttach.Body = attachBody;
            oppAttach.ContentType = contentType;
            
            attMsg = 'Success: File [' + fileName + '] has been uploaded';
            UPSERT oppAttach;
        }
        else{
            attMsg = 'Failed to save the Atachment';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Opportunity ID Missing'));
        }
        pageReference pr = Page.CreateFLOReimbursement;
        pr.setRedirect (FALSE);
        pr.getParameters().put('id', opp.Id);
        return pr;
        //return NULL;
    }
}