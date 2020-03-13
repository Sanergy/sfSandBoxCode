public class Reimbursement {
    public Special_Payment_Request_Recon__c accounts {get; set;}
    public Special_Payment_Request_Recon__c del;
    public Special_Procurement__c spr1 {get;set;}
    public List<Special_Payment_Request_Recon__c> addattendeeList  {get;set;}
    public List<Special_Payment_Request_Recon__c> delattendeeList {get;set;}
    public List<Special_Payment_Request_Recon__c> attendeeList  {get;set;}
    public Integer totalCount {get;set;}
    public Integer rowIndex {get;set;}
    public Integer reconRowIndex {get;set;}
    public String reconRowID {get;set;}
    public Boolean hideApprovalButtons {get;set;}
    public Boolean createReconEPR {get;set;} //if Recon EPR should be created immediately or later
    //String strId = apexpages.currentpage().getparameters().get('id');
        
    public List<ReconWrp> wrpReconItems {get;set;}
    public List<Special_Payment_Request_Recon__c> reconList  {get;set;}    
    public List<Special_Payment_Request_Recon__c> delRecons {get;set;}
    public List<Special_Procurement_Line_Item__c> SPRLI {get;set;}
    //create standard controller
    private ApexPages.StandardController controller;
    
    public List<Special_Payment_Request_Recon__c> delAttendees {get; set;} 
    public List<Special_Procurement_Payment__c> sppList {get; set;} 
    public Blob document {get; set;}
    
    //Constructor
    public Reimbursement(ApexPages.StandardController controller) {
        this.controller=controller; 
        spr1 = (Special_Procurement__c)controller.getRecord();
        spr1 = [SELECT Id, Name,Requestor__c,Requestor__r.Name,Requestor__r.Sanergy_Department__r.Name,
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
                WHERE id =: spr1.Id];

        //Set defaults
        hideApprovalButtons = !spr1.Approve_Reconciliation__c;
        createReconEPR = TRUE; //default is to create the recon EPR immediately
        
        attendeeList = [Select id, Date__c, Expense_Description__c, GLA__c,GLA__r.lookup_ID__c,Total_Reconciled__c, 
                        Recon_Approved__c,
                        DIM_1__c,Item_Amount__c,Supplier__c,Special_Payment_Request__c,Special_Payment_Request__r.Reconciled_Balance__c,
                        Transaction_Charge__c,VAT__c,KRA_Pin__c,Special_Payment_Request__r.Total_Amount_Requested__c	 
                        from Special_Payment_Request_Recon__c 
                        where Special_Payment_Request__c  =: spr1.Id
                       ];
        
        totalCount = attendeeList.size();
        
        delattendeeList = new List<Special_Payment_Request_Recon__c>();
        delattendees = new List<Special_Payment_Request_Recon__c>();
        
        //start
        wrpReconItems = new List<ReconWrp>();
        reconList = new List<Special_Payment_Request_Recon__c>();
        reconRowIndex = 0;
        reconRowID = '';
        delRecons = new List<Special_Payment_Request_Recon__c>();
        getRecons();
        sppList = new List<Special_Procurement_Payment__c>();
        getSPRPayments();
        SPRLI = new List<Special_Procurement_Line_Item__c>();
        getSPRLineItems();
    }
    
    public void getSPRLineItems(){
        SPRLI = 
            [
                SELECT Id, Name, Item__c, Specifications__c, Quantity_Requested__c, Status__c, Net_Total_Amount__c,
                Total_VAT__c, Total_Price__c, Request_Type__c
                FROM Special_Procurement_Line_Item__c
                WHERE Special_Procurement__c = : spr1.Id
                ORDER BY Name
            ];
    }
    
    public void getRecons(){
        reconList = 
            [
                Select id,Name, Date__c, Expense_Description__c, GLA__c,GLA__r.lookup_ID__c,Total_Reconciled__c, 
                Recon_Approved__c,Comments__c,
                DIM_1__c,Item_Amount__c,Supplier__c,Special_Payment_Request__c,Special_Payment_Request__r.Reconciled_Balance__c,
                Transaction_Charge__c,VAT__c,KRA_Pin__c,Special_Payment_Request__r.Total_Amount_Requested__c	 
                from Special_Payment_Request_Recon__c 
                where Special_Payment_Request__c  =: spr1.Id
            ];
        //loop through and add to wrapper class
        if(reconList != NULL && reconList.size() > 0){
            reconRowIndex = 0;
            for(Special_Payment_Request_Recon__c item : reconList){
                reconRowIndex = reconRowIndex + 1;
                wrpReconItems.add(new ReconWrp(item,reconRowIndex,spr1.Id));
            }
        }
    }
    
    //Get SPR Payments
    public void getSPRPayments(){
        sppList = 
            [
                SELECT id, Name, EPR__c, EPR__r.Name, EPR_Gross_Value__c, EPR__r.Status__c, EPR__r.Cash_Entry__c, EPR__r.Cash_Entry__r.Name,
                EPR__r.Confirmation_Number__c, EPR__r.EPR_Processed__c, Payment_Type__c, CreatedDate, Payment_Cost__c
                FROM Special_Procurement_Payment__c
                WHERE Special_Procurement__c =: spr1.id
            ];
    }
    // Add a new row to list down the Items that are being reconciled
    public void addRow(){
        addattendeeList = new List<Special_Payment_Request_Recon__c>();
        attendeeList.add(new Special_Payment_Request_Recon__c(Special_Payment_Request__c = spr1.Id));
        
        //system.debug('ATTENDEE KIST'+ attendeeList);       
    }
    //saving the list of items
    public PageReference save(){
        system.debug('ATTENDEE KIST'+ attendeeList);
        
        upsert attendeeList;
        delete delattendeeList;
        return (new ApexPages.StandardController(spr1)).view();
        //return new PageReference('/'+ Special_Payment_Request__c.Id);
    } 
    //Delete a row from the added items
    
    public void deleteRow(){
        
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        System.debug('rowbe deleted ' + rowIndex );
        //System.debug('rowm to be deleted '+attendeeList[rowIndex]);
        
        //del = wrpReconItems.remove(rowIndex);
        //delattendeeList.add(del);
        
    }
    
    public void addRORow(){
		//add row to list
        reconRowIndex = reconRowIndex + 1;
        wrpReconItems.add(new ReconWrp(new Special_Payment_Request_Recon__c(Special_Payment_Request__c = spr1.Id),reconRowIndex,spr1.Id));      
    }
        
    public void deleteRORow(){
        del = new Special_Payment_Request_Recon__c();
        reconRowID = String.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        
        //search for Row based on index
        integer i = 0;
        integer delIndex = -1; //set to -1 to cater for zero-based index
        for(ReconWrp item : wrpReconItems){
            if(item.rowID == reconRowID){
                //add to delete list only if has an existing recon that had been saved in SF
                if(item.recon.id != NULL){
                    //add existing item to be Deleted
                    delRecons.add(wrpReconItems.get(i).recon);
                }
                //add item to be removed
                delIndex = i;
                i = i - 1;
            }
            
            //increment counter
            i = i + 1;
            item.reconIndex = i; //reset the index numbers
        }
        if(delIndex > -1) {
            //remove from wrapper class
            wrpReconItems.remove(delIndex); 
        }
        
        reconRowIndex = i; //Update number of rows
        system.debug('recon Wrp List =' + wrpReconItems);
    }
    
    public void saveReconRows(){
        try {
            //Upsert any Recons
            if(wrpReconItems != NULL && wrpReconItems.size() > 0){
                reconList.clear(); 
                List <Attachment> reconAttachLst = new List <Attachment>();
                for(ReconWrp item : wrpReconItems){
                    reconList.add(item.recon);
                }
                UPSERT reconList;
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Recon Line Item Records successfully updated'));
            }
            
            //delete
            if(delRecons != NULL && delRecons.size() > 0){
                system.debug('delRecons = ' + delRecons);
                DELETE delRecons;  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records successfully DELETED'));
            }
        }
        catch (Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }

    //Save Reconciliations
    public PageReference saveRORows(){
        saveReconRows();
        pageReference pr = Page.Reimbursement;
        pr.setRedirect (TRUE);
        pr.getParameters().put('id', spr1.Id);
        return pr;
        //return 'apex/Reimbursement?id=';
    }

    //Save Reconciliations and Submit reconciliation for processing
    public PageReference SubmitRecon(){
        try{
            saveReconRows();
            
            spr1.Reconciliation_Submitted__c = TRUE;
            UPDATE spr1;
            
            //send SPR for SPR_Recon_Submitted approval
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval.');
            req.setObjectId(spr1.Id);
            
            // Submit the EPR for approval
            Approval.ProcessResult result = Approval.process(req);          
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reconciliation Submitted for Approval'));
            
            
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
        return NULL;
    }    
    //Save Reconciliations and create final EPR
    public pageReference CompleteRecon(){
        try{
            createReconEPR();
            CreatePIN();
            CreateReconSPR();
                        
            //Update SPR to show recon complete
            spr1.Reconciliation_Completed__c = TRUE;
            UPDATE spr1;
            
            //Lock Record
            //Approval.LockResult[] lrList = Approval.lock(cases, false);
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reconciliation for this SPR has been successfully completed'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        
        return NULL;
    }
    //Create an EPR to balance out payments
    public void createReconEPR(){
        //if the SPR Recons have already been approved by Finance
        if (spr1.Approve_Reconciliation__c == TRUE && spr1.Reconciled_Total__c > 0 && 	//make sure recon has been done and approved										
            (spr1.Type__c == 'Cash Advance' || spr1.Type__c == 'Employee Reimbursement'))
        {
            saveReconRows();
            if(spr1.Reconciled_Balance__c < 0 && createReconEPR == TRUE){//Means we owe if negative, Create Recon EPR
                try{
                    // Create an instance of EPR
                    Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();
                    //Create EPR
                    switch on spr1.Requesting_Company__r.Name {
                        when 'Sanergy Limited' {epr.Company__c = 'Sanergy Ltd';}
                        when 'Fresh Life Initiative Limited' {epr.Company__c = 'Fresh Life Initiative Ltd';}
                        when 'Sanergy, Inc. (FP)' {epr.Company__c = 'Sanergy Inc (FP)';}
                        when 'Sanergy, Inc. (NP)' {epr.Company__c = 'Sanergy Inc (NP)';}
                    }
                    epr.department__c = spr1.Requesting_Department__c;
                    epr.Vendor_Company__c = spr1.Vendor__c;
                    epr.Invoice_Number__c = spr1.Name + ' [Recon]';                              
                    epr.Scheduled_Payment_Date__c = date.today();                
                    epr.Notes__c='Final Reconciliation for '+ this.spr1.Vendor__r.name +' as per Special Payment Request ['+ this.spr1.Name +']';
                    epr.Payment_Type__c = 'Employee Reimbursement'; //Set to Reimbursement
                    
                    INSERT epr;
                    
                    //insert Line Items               
                    EPR_Payable_Item__c eprLIToSave = new EPR_Payable_Item__c
                        (
                            EPR__c = epr.id,
                            Department_dim1__c = spr1.Requesting_Department__c,
                            Location_Dim2__c = spr1.Dim_2__c,
                            Dim_3__c = spr1.Dim_3__c,
                            Grant_Funding_Availale_dim4__c = spr1.Grant__c,
                            GLA__c = spr1.GLA__c,
                            Quantity__c = 1,
                            Unit_Price__c = spr1.Reconciled_Balance__c *-1, //Negate balance
                            Item__c = 'Final Reconciliation for '+ this.spr1.Vendor__r.name +' as per Special Payment Request ['+ this.spr1.Name +']'
                        );   
                    
                    INSERT eprLIToSave;
                    //Run SOQL to get EPR calculation of Gross Amount to pass down to SPP
                    Electronic_Payment_Request__c eprSaved = 
                        [SELECT id, Gross_Payment_Amount__c FROM Electronic_Payment_Request__c WHERE id =: epr.id ];
                    
                    //create SPR Payment record
                    List<Special_Procurement_Payment__c> sppToSave = new List<Special_Procurement_Payment__c>();
                    sppToSave.add (new Special_Procurement_Payment__c(
                        Company__c = spr1.Requesting_Company__c,
                        EPR__c = eprSaved.id,
                        Special_Procurement__c=this.spr1.id,
                        Payment_Cost__c= eprSaved.Gross_Payment_Amount__c,
                        Total_EPR__c = eprSaved.Gross_Payment_Amount__c
                    ));  
                    INSERT sppToSave;
                    
                    //Update SPR to show Recon EPR has been generated
                    spr1.Recon_EPR_Generated__c = TRUE;
                    spr1.Recon_EPR__c = epr.id;
                    UPDATE spr1;
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reconciliation EPR has been created'));
                    
                    // Create an approval request for the EPR
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting request for approval.');
                    req.setObjectId(epr.Id);
                    
                    // Submit the EPR for approval
                    Approval.ProcessResult result = Approval.process(req);  
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reconciliation Complete'));
                }
                catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not complete the EPR Creation for [' + spr1.Name + ']: ' + e.getMessage()));
                }
            }

        }else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No applicable Recon Line Items to generate the Recon EPR'));
        }
    }
    
    public void CreatePIN(){
        if (spr1.Payable_Invoice__c == NULL && 
            spr1.Approve_Reconciliation__c == TRUE && spr1.Reconciliation_Submitted__c == TRUE && //Recons submitted and approved
            spr1.Payment_Method__c != ''){
            
            String company= spr1.Requesting_Company__r.Name;
            String bankName;
            
            //If company is Sanergy
            if(company=='Sanergy Limited'){
                system.debug('CooOMPANY' + company + ' '+ bankName);
                
                //if payment is Check or EFT
                if(spr1.Payment_Method__c=='Check' || spr1.Payment_Method__c=='EFT'){
                    system.debug('Bank Name' + company + ' '+ bankName);
                    if(spr1.Vendor_Currency__c=='KES'){
                        bankName='SL - PBH - KES';
                    }
                    else if(spr1.Vendor_Currency__c=='USD'){
                        bankName='SL - PBR - USD';
                    }
                    else if(spr1.Vendor_Currency__c=='EUR'){
                        bankName='SL - PBR - EUR';
                    }
                    else if(spr1.Vendor_Currency__c=='GBP'){
                        bankName='SL - PBR - GBP';
                    }
                }
                //if payment is Electronic.
                else {//if(spr1.Payment_Method__c=='Electronic'){
                    bankName='SL - SCB - KES';
                    system.debug('Bank Name' + company + ' '+ bankName);
                }   
            }
            
            //If company is Fresh Life
            else if(company=='Fresh Life Initiative Limited'){
                //if payment is Check or EFT
                if(spr1.Payment_Method__c=='Check' || spr1.Payment_Method__c=='EFT'){
                    if(spr1.Vendor_Currency__c=='KES'){
                        bankName='FLI - PBH - KES';
                    }
                    else if(spr1.Vendor_Currency__c=='USD'){
                        bankName='FLI - PBR - USD';
                    }
                    else if(spr1.Vendor_Currency__c=='EUR'){
                        bankName='FLI - PBR - EUR';
                    }
                    else if(spr1.Vendor_Currency__c=='GBP'){
                        bankName='FLI - PBR - GBP';
                    }
                }
                //if payment is Electronic.
                else { //if(spr1.Payment_Method__c=='Electronic'){
                    bankName='FLI - SCB - KES';
                }  
            }  
            
            //If company is Sanergy FP
            else if(company=='Sanergy Inc (FP)'){
                bankName='FP Checking';
            }
            
            //If company is Sanergy NP
            else if(company=='Sanergy Inc (NP)'){
                bankName='NP Checking';
            }   
            
            List<c2g__codaBankAccount__c > bankAcc=[SELECT Id,c2g__BankAccountCurrency__c 
                                                    FROM c2g__codaBankAccount__c
                                                    WHERE Name=:bankName];            
            
            
            if(bankAcc.size() > 0){
                system.debug('BANK ACC' +' '+ bankAcc.get(0).c2g__BankAccountCurrency__c);
                
                c2g__codaPurchaseInvoice__c PIN=new c2g__codaPurchaseInvoice__c();
                PIN.c2g__Account__c= spr1.Vendor__c;
                PIN.c2g__InvoiceDate__c = Date.Today();
                PIN.c2g__DueDate__c= Date.Today() + 1;
                PIN.c2g__AccountInvoiceNumber__c=spr1.Name;
                // PIN.c2g__InvoiceCurrency__c=bankAcc.get(0).c2g__BankAccountCurrency__c;
                
                INSERT PIN; 
                
                spr1.Payable_Invoice__c = PIN.ID;
                UPDATE spr1;
                
                system.debug('PIN' + spr1.Payable_Invoice__c);
                system.debug('SPR' + spr1);
                
                List<Special_Payment_Request_Recon__c> sprRecon = 
                    [
                        SELECT id, Date__c, Expense_Description__c, 
                        GLA__c, GLA__r.lookup_ID__c, Total_Reconciled__c,
                        DIM_1__c,DIM_1__r.lookup_ID__c,
                        Item_Amount__c,Supplier__c,Special_Payment_Request__c,Special_Payment_Request__r.Reconciled_Balance__c,
                        Transaction_Charge__c,VAT__c,KRA_Pin__c,Special_Payment_Request__r.Total_Amount_Requested__c,Special_Payment_Request__r.Dim_2__c,
                        Special_Payment_Request__r.Dim_3__c,Special_Payment_Request__r.Total_Approved_EPR_Value__c
                        FROM Special_Payment_Request_Recon__c 
                        WHERE Special_Payment_Request__c  =: spr1.Id
                    ];
                
                List<c2g__codaPurchaseInvoiceExpenseLineItem__c> PIN_Line=new List<c2g__codaPurchaseInvoiceExpenseLineItem__c>();
                system.debug('Here ' + sprRecon );
                system.debug('spr1.Requesting_Department__r.lookup_ID__c = ' + spr1.Requesting_Department__r.lookup_ID__c );
                Decimal transactionCharge = 0.0;
                
                for(Special_Payment_Request_Recon__c sprR: sprRecon){  
                    c2g__codaPurchaseInvoiceExpenseLineItem__c pinLine=new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                        c2g__PurchaseInvoice__c=PIN.ID,
                        ffap__SetGLAToDefault__c=false,
                        c2g__LineDescription__c=sprR.Expense_Description__c,
                        c2g__NetValue__c=sprR.Item_Amount__c,
                        c2g__TaxValue1__c = sprR.VAT__c,
                        ffap__SetTaxCodeToDefault__c=false,
                        ffap__CalculateTaxValueFromRate__c=true,
                        ffap__DeriveTaxRateFromCode__c=true,
                        c2g__GeneralLedgerAccount__c=sprR.GLA__r.lookup_ID__c,
                        c2g__Dimension1__c=sprR.DIM_1__r.lookup_ID__c //Whatever the user entered in the Recon
                    );
                    if(sprR.Transaction_Charge__c != NULL && sprR.Transaction_Charge__c > 0){
                        transactionCharge = transactionCharge + sprR.Transaction_Charge__c;
                    }
                    
                    PIN_Line.add(pinLine);
                }
                system.debug('PIN_Line = ' + PIN_Line );
                system.debug('spr1.Requesting_Department__r.lookup_ID__c = ' + spr1.Requesting_Department__r.lookup_ID__c );
                system.debug('transactionCharge ' + transactionCharge );
                
                //add Transaction line charges
                if(transactionCharge > 0){
                    PIN_Line.add(
                        new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                        c2g__PurchaseInvoice__c=PIN.ID,
                        ffap__SetGLAToDefault__c=false,
                        c2g__LineDescription__c= 'Transation Charges',
                        c2g__NetValue__c = transactionCharge,
                        c2g__TaxValue1__c = 0,
                        ffap__SetTaxCodeToDefault__c=false,
                        ffap__CalculateTaxValueFromRate__c=true,
                        ffap__DeriveTaxRateFromCode__c=true,
                        c2g__GeneralLedgerAccount__c = 'a1QD000000BVON9', //6010 - Bank Charges
                        c2g__Dimension1__c = spr1.Requesting_Department__r.lookup_ID__c //Should go to the SPR Department
                        )
                    );
                }

                INSERT PIN_LINE;
                system.debug('SPRLINE' + PIN_LINE);
                
                
                spr1.Payable_Invoice__c=PIN.ID;
                UPDATE spr1;
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PIN Successfully Created'));                
            }      
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'To create the PIN; PIN = NULL, EPR Created = TRUE, Payment Method = Selected, Approve Reconciliation = TRUE'));
        }
    }
    
    public void CreateReconSPR(){
        //Create a new SPR if the user had a pending Recon Balance ie they owe us
        if(spr1.Reconciled_Balance__c > 0 ){//Means they owe us, Create Recon SPR
            try{               
                //Step 1: Create Reconciliation line for the CURRENT SPR
                Special_Payment_Request_Recon__c ro = new Special_Payment_Request_Recon__c (
                    Special_Payment_Request__c = spr1.id,
                    Supplier__c = spr1.Name,
                    Date__c = System.date.today(),
                    Expense_Description__c = '',
                    Item_Amount__c = spr1.Reconciled_Balance__c,
                    Recon_Approved__c = TRUE
                );
                INSERT ro;
                
                //Step 2: Update SPR to show recon complete. Need to do this here to avoid duplicate Open SPR on trigger
                //Doing this to ensure Recon Balance = 0
                spr1.Reconciliation_Completed__c = TRUE;
                UPDATE spr1;
                
                //Step 3: Clone current SP
                //Only clone after the CURRENT SPR has been reconciled to avoid requiring completion of previous SPRs error
                Special_Procurement__c sp = new Special_Procurement__c ();
                sp = spr1.clone();
                //set defaults
                sp.stage__c = 'Open';
                sp.Type__c = 'Cash Advance'; //Technically an advance as the employee now owes us
                sp.Approval_Status__c = 'Pending Approval';
                sp.Approve_Reconciliation__c = FALSE;
                sp.Recon_EPR_Generated__c = FALSE;
                sp.Reconciliation_Submitted__c = FALSE;
                sp.Reconciliation_Completed__c = FALSE;
                sp.Payable_Invoice__c = NULL;
                sp.EPR_Created__c = FALSE;
                sp.Generate_EPR__c = FALSE;
                sp.Comments__c = 'BCF From: ' + spr1.Name;
                sp.Recon_EPR__c = NULL;
                sp.Recon_SPR__c = NULL;
                sp.OwnerId = spr1.OwnerId; //To allow for SPR Sharing
                
                INSERT sp;
                sp = [SELECT id, Name FROM Special_Procurement__c WHERE Id =: sp.id];
                
                //Step 4: Insert SPR Line Item
                Special_Procurement_Line_Item__c sprline = new Special_Procurement_Line_Item__c();
                sprline.Special_Procurement__c = sp.ID;
                sprline.Item__c ='BCF From: ' + spr1.Name;
                sprline.Specifications__c = 'BCF From: ' + spr1.Name;
                sprline.Request_Type__c = 'Not Applicable';
                sprline.Currency__c = 'aHQD0000000blJJ';
                sprline.Create_PR_Line_Item__c = false;
                sprline.Quantity_Requested__c = 1;
                sprline.Unit_Price__c = spr1.Reconciled_Balance__c;
                sprline.EPR_Created__c = TRUE; //To stop creation of a new EPR as this is from a carried over EPR
                sprline.Balance_Carried_Forward__c = TRUE; //Flag as Carry over SPR
                INSERT sprline;
                
                //Step 5: Insert SPR Payment in new SP
                Special_Procurement_Payment__c spp = new Special_Procurement_Payment__c (
                    Special_Procurement__c = sp.ID,
                    Payment_Cost__c = spr1.Reconciled_Balance__c,
                    Balance_Carried_Forward__c = TRUE,
                    Company__c = spr1.Requesting_Company__c,
                    Total_EPR__c = spr1.Reconciled_Balance__c,
                    Comments__c = 'BCF From: ' + spr1.Name
                );
                INSERT spp;
                
                //Step 6: UPDATE SPR
                spr1.Recon_SPR__c = sp.id;
                UPDATE spr1;
                
                //Step 7: Update Recon Object
                ro.Expense_Description__c = 'Balance Carried over to SPR ' + sp.Name; //Update with the new SPR
                UPDATE ro;
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Could not complete the Recon SPR Creation for [' + spr1.Name + ']: ' + e.getMessage()));
            }
            
        }
    }
    
    public pageReference CreateSPRTest(){
         Special_Procurement__c sp = new Special_Procurement__c ();
                sp = spr1.clone();
                //set defaults
                sp.stage__c = 'Open';
                sp.Type__c = 'Special Procurement'; //Technically an advance as the employee now owes us
                sp.Approval_Status__c = 'Pending Approval';
                sp.Approve_Reconciliation__c = FALSE;
                sp.Recon_EPR_Generated__c = FALSE;
                sp.Reconciliation_Submitted__c = FALSE;
                sp.Reconciliation_Completed__c = FALSE;
                sp.Payable_Invoice__c = NULL;
                sp.EPR_Created__c = FALSE;
                sp.Generate_EPR__c = FALSE;
                sp.Comments__c = 'BCF From: ' + spr1.Name;
                sp.Recon_EPR__c = NULL;
                sp.Recon_SPR__c = NULL;
                sp.OwnerId = spr1.OwnerId; //To allow for SPR Sharing
                
                INSERT sp;
        
        return NULL;
    }
    
    public PageReference RejectRecon(){
        //decline approval
        saveReconRows();
        spr1.Reconciliation_Submitted__c = FALSE;
        spr1.Reconciliation_Completed__c = FALSE;
        spr1.Approve_Reconciliation__c = FALSE;
        UPDATE spr1;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reconciliation has been returned to the user for further action'));
        return NULL;
    }
    
    public class ReconWrp {
        public Special_Payment_Request_Recon__c recon  {get;set;}
        public Id SPRID{get;set;}
        public Integer reconIndex {get;set;}
        public Attachment reconAttach {get;set;}
        public String rowID {get; set;}
        public List<Attachment> currAttachments {get; set;}
        public Blob attachBody {get; set;}
        public String contentType {get; set;}
        public String fileName {get; set;}
        public String attMsg {get; set;}
        public Attachment attachToDel {get; set;}
        //Constructor
        public ReconWrp(Special_Payment_Request_Recon__c ro, Integer rowIndex, Id sprGUID){
            rowID = SanergyUtils.generateOTP(6,TRUE); //Generate a random ID to be used to search for the record
            SPRID = sprGUID;
            recon = ro;
            reconIndex = rowIndex;
            reconAttach = new Attachment();
            fileName = ' *** ';
            attMsg = '';
            attachToDel = new Attachment();
            //Get any attachments
            currAttachments = [SELECT Id, Name, ParentId, Parent.Type FROM Attachment where ParentId =: recon.id];
        }
        public PageReference AttachFile(){
            if(recon.id != NULL){
                reconAttach.ParentId = recon.id;
                reconAttach.Name = '[' + recon.Name + '] ' + fileName;
                reconAttach.Body = attachBody;
                reconAttach.ContentType = contentType;
                system.debug('reconAttach = ' + reconAttach);
                attMsg = 'Success: File [' + fileName + '] has been uploaded';
                UPSERT reconAttach;
                //To clear viewstate
                reconAttach.Body = NULL;
            }
            else{
                attMsg = 'Failed: Save the reconciliation first';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Recon ID Missing'));
            }
            pageReference pr = Page.Reimbursement;
            pr.setRedirect (FALSE);
            pr.getParameters().put('id', SPRID);
            return pr;
            //return NULL;
        }
        
        public pageReference DeleteAttach(){
            try{
                system.debug('attachToDel = ' + attachToDel);
                DELETE attachToDel; 
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            }
            
            return NULL;
        }
    }
}