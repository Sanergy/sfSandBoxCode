public class CreateEPRFromSpecialProcurement {
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    //Special Procurement
    public Special_Procurement__c sp {get; set;} 
    
    //Special Procurement Line Items
    private List<Special_Procurement_Line_Item__c> items {get; set;}
    public Boolean hideButtons {get; set;}
    public Integer totalCount {get;set;}
    /*public Integer rowIndex {get;set;}
    public Integer reconRowIndex {get;set;}
    public String reconRowID {get;set;}
    public List<ReconEPRWrp> wrpReconEPRs {get; set;}*/ 
    Public Decimal EPRValue {get;set;}

       
    // Constructor
    public CreateEPRFromSpecialProcurement(ApexPages.StandardController controller){               
        this.controller=controller; 
        sp=(Special_Procurement__c)controller.getRecord();
        
        sp=[SELECT Name,Requestor__c,Type__c,Required_Date__c,Comments__c,Requesting_Department__c, Approve_Reconciliation__c,
            Requesting_Department__r.Name,Vendor__c,Vendor__r.name,Total_Amount__c,Total_Amount_Requested__c,
            Requesting_Department_TL__c,Approval_Status__c,Stage__c,Dim_2__c,Dim_3__c,GLA__c,Grant__c, Total_Payments__c,
            Requesting_Company__c,Requesting_Company__r.Name,Status_Flag__c, Reconciled_Total__c, 
            Reconciled_Balance__c
            FROM Special_Procurement__c
            WHERE //(Approval_Status__c = 'Approved By Team Lead'OR Approval_Status__c = 'Approved By Director')AND 
            id =: sp.Id];  
        //Set Defaults
        //reconRowIndex = 0;
        //reconRowID = '';
        //wrpReconEPRs = new List<ReconEPRWrp>();
        
        EPRValue = 0;
        
        //check approval status
        if(sp.Approval_Status__c == 'Approved By Team Lead'|| sp.Approval_Status__c == 'Approved By Director'){
            hideButtons = false;
        }else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot generate an EPR for this SPR in this Approval Status'));
            hideButtons = true;
        }
    }
	
	// Get Line Items
    public List<Special_Procurement_Line_Item__c> getItems() {
        
        items= new List<Special_Procurement_Line_Item__c>();
        
        if(sp.Approval_Status__c == 'Approved By Director' || sp.Approval_Status__c == 'Approved By Team Lead'){
            
            List<Special_Procurement_Line_Item__c> lineItems = 
                [
                    SELECT Id,Name,Special_Procurement__c,Item__c,Status__c, Specifications__c,EPR_Created__c,Status_Flag__c,
                    Quantity_Requested__c,Unit_Price__c,Total_Price__c, Total_Unapproved_Value__c, Balance_Carried_Forward__c                                                   
                    FROM Special_Procurement_Line_Item__c
                    WHERE Status__c = 'Approved'
                    AND EPR_Created__c = False AND Balance_Carried_Forward__c = FALSE
                    AND Special_Procurement__c =: sp.Id
                    ORDER BY Name DESC
                ];
            //Check for line items
            if(lineItems != NULL && lineItems.size() > 0){
                for(Special_Procurement_Line_Item__c lineItem : lineItems){
                    items.add(lineItem);
                    if(lineItem.Item__c != 'Balance Carried Forward' ||
                       String.valueOf(lineItem.Item__c).startsWithIgnoreCase ('BCF From:') == FALSE || //Ignore any that is a BCF
                       lineItem.EPR_Created__c == FALSE  ||
                       lineItem.Balance_Carried_Forward__c == FALSE
                      ){
                        EPRValue = EPRValue + lineItem.Total_Price__c;
                    }
                }   
                //subtract any payments
                EPRValue = EPRValue - sp.Total_Payments__c;
            }else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No applicable SPR Line Items for this SPR Record'));
            }
        }
        return items;
    }  
    
    //Create EPR
    public PageReference createEPR(){
        System.debug('sp.Type__c' + sp.Type__c);
        System.debug('sp.Approval_Status__c' + sp.Approval_Status__c);       
		// Create an instance of EPR
        Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();         
        //Create only for Cash Advance and Reimbursement; FLO Reimbursement
        if(((sp.Type__c == 'Cash Advance' || sp.Type__c == 'Employee Reimbursement' || sp.Type__c == 'FLO Reimbursement') && 
           (sp.Approval_Status__c == 'Approved By Director' || sp.Approval_Status__c == 'Approved By Team Lead' ))
          )
        {
            // Select Special Procurement Line Items
            List<Special_Procurement_Line_Item__c> spLineItems = 
                [
                    SELECT Id,Name,Special_Procurement__c,Item__c,Status__c,Specifications__c,EPR_Created__c,Status_Flag__c,
                    Quantity_Requested__c,Unit_Price__c,Total_Price__c,Total_Unapproved_Value__c, Balance_Carried_Forward__c
                    FROM Special_Procurement_Line_Item__c
                    WHERE Status__c = 'Approved'                                                                  
                    AND EPR_Created__c = False
                    AND Special_Procurement__c =: sp.Id
                    ORDER BY Name DESC
                ];        
            //Check if rows have been returned
            if(spLineItems != NULL && spLineItems.size() > 0){
                    //Create EPR
                switch on sp.Requesting_Company__r.Name {
                    when 'Sanergy Limited' {epr.Company__c = 'Sanergy Ltd';}
                    when 'Fresh Life Initiative Limited' {epr.Company__c = 'Fresh Life Initiative Ltd';}
                    when 'Sanergy, Inc. (FP)' {epr.Company__c = 'Sanergy Inc (FP)';}
                    when 'Sanergy, Inc. (NP)' {epr.Company__c = 'Sanergy Inc (NP)';}
                }
                epr.Source_Doc_SPR__c = sp.id;
                epr.department__c = sp.Requesting_Department__c;
                epr.Vendor_Company__c = sp.Vendor__c;
                epr.Invoice_Number__c = sp.Name;                              
                epr.Scheduled_Payment_Date__c = date.today();                
                epr.Notes__c='Payment for items bought at '+ this.sp.Vendor__r.name +' as per Special Payment Request '+ this.sp.Name;
                epr.Payment_Type__c = sp.Type__c;
                
                INSERT epr;
                                
                // Loop through the list of Special Procurement Line Items
                for(Special_Procurement_Line_Item__c spli : spLineItems){               
                    if(spli.Balance_Carried_Forward__c == FALSE || 
                       String.valueOf(spli.Item__c).startsWithIgnoreCase ('BCF From:') == FALSE || //Ignore ny that is a BCF
                       spli.EPR_Created__c == FALSE //Ignore any line the EPR has already been generated
                      )
                    {
                        // Create EPR Payable Item if not a carry over balance
                        EPR_Payable_Item__c eprLineItems = new EPR_Payable_Item__c();            
                        eprLineItems.epr__c=epr.id;
                        eprLineItems.Department_dim1__c = epr.department__c;
                        eprLineItems.Item__c = spli.Item__c + ' (Qty = ' + spli.Quantity_Requested__c + ' @ ' + spli.Total_Price__c + ' each.)';
                        eprLineItems.Quantity__c = 1; //Force this as EPR calculates Qty * Price and doesn't have VAT if to be included
                        eprLineItems.Unit_Price__c = spli.Total_Price__c;
                        eprLineItems.Location_Dim2__c = sp.Dim_2__c;
                        eprLineItems.Dim_3__c = sp.Dim_3__c;                
                        eprLineItems.GLA__c = sp.GLA__c;
                        
                        INSERT eprLineItems;
                        
                        // Update Special Procurement Line Item
                        spli.EPR_Line_Item__c = eprLineItems.id;
                        spli.EPR_Created__c = True;
                        UPDATE spli;	
                    }
                }
                //Run SOQL to get EPR calculation of Gross Amount to pass down to SPP
                Electronic_Payment_Request__c eprSaved = 
                    [SELECT id, Gross_Payment_Amount__c FROM Electronic_Payment_Request__c WHERE id =: epr.id ];
                
                // Special Procurement Payment
                Special_Procurement_Payment__c spp = new Special_Procurement_Payment__c();
                spp.Company__c=sp.Requesting_Company__c;
                spp.EPR__c=epr.id;
                spp.Special_Procurement__c=this.sp.id;
                spp.Payment_Cost__c = eprSaved.Gross_Payment_Amount__c;   
                spp.Total_EPR__c= eprSaved.Gross_Payment_Amount__c;
                   
                INSERT spp;	            
                
                // Update Special Procurement
                sp.Stage__c = 'EPR Generated';  
                sp.EPR_Created__c = TRUE;
                UPDATE sp;
                
                // Create an approval request for the EPR
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for approval.');
                req.setObjectId(epr.Id);
                
                // Submit the EPR for approval
                Approval.ProcessResult result = Approval.process(req);            
                
                return new PageReference('/'+epr.id);
            }else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No applicable SPR Line Items for this SPR Record'));
            	return null;
            }
            
        }else if(sp.Stage__c == 'EPR Generated'){            
       		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'An EPR has already been created for this Special Payment Request record'));
            return null;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Special Payment Request needs to be approved by the Team Lead or Director.'));
            return null;
        }
       
    }
 /*   
    public void addRORow(){
		//add row to list
        reconRowIndex = reconRowIndex + 1;
        wrpReconEPRs.add(new ReconEPRWrp(reconRowIndex, new EPR_Payable_Item__c()));      
    }
    public void deleteRORow(){
        reconRowID = String.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        
        //search for Row based on index
        integer i = 0;
        integer delIndex = -1; //set to -1 to cater for zero-based index
        for(ReconEPRWrp item : wrpReconEPRs){
            if(item.rowID == reconRowID){
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
            wrpReconEPRs.remove(delIndex); 
        }    
        reconRowIndex = i; //Update number of rows
    }
    public void saveRORows(){
        
    }
	//display lines for Recon EPR if criteria is met
    public PageReference ReconEPR(){
        //if() {
            //create Wrapper class
            List<ReconEPRWrp> wrpReconEPRs = new List<ReconEPRWrp>();
            
        //}
        return NULL;
    }
	
    
    //Create an EPR to balance out payments
    public PageReference createReconEPR(){
        system.debug ('wrpReconEPRs = ' + wrpReconEPRs);
        //if the SPR Recons have already been approved by Finance
        if (sp.Approve_Reconciliation__c == TRUE && sp.Reconciled_Total__c > 0 && 	//make sure recon has been done and approved
            sp.Reconciled_Balance__c < 0 	&&										//Means we owe if negative
            (wrpReconEPRs != NULL && wrpReconEPRs.size() > 0)  && 					//check Recon Line(s) have been added
            (sp.Type__c == 'Cash Advance' || sp.Type__c == 'Employee Reimbursement'))
        {
            // Create an instance of EPR
            Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();
            //Create EPR
            switch on sp.Requesting_Company__r.Name {
                when 'Sanergy Limited' {epr.Company__c = 'Sanergy Ltd';}
                when 'Fresh Life Initiative Limited' {epr.Company__c = 'Fresh Life Initiative Ltd';}
                when 'Sanergy, Inc. (FP)' {epr.Company__c = 'Sanergy Inc (FP)';}
                when 'Sanergy, Inc. (NP)' {epr.Company__c = 'Sanergy Inc (NP)';}
            }
            epr.department__c = sp.Requesting_Department__c;
            epr.Vendor_Company__c = sp.Vendor__c;
            epr.Invoice_Number__c = sp.Name + ' [Recon]';                              
            epr.Scheduled_Payment_Date__c = date.today();                
            epr.Notes__c='Final Reconciliation for '+ this.sp.Vendor__r.name +' as per Special Payment Request ['+ this.sp.Name +']';
            epr.Payment_Type__c = sp.Type__c;
            
            INSERT epr;
            
            //insert Line Items
            List<EPR_Payable_Item__c> eprLIToSave = new List<EPR_Payable_Item__c>();   
            for(ReconEPRWrp item : wrpReconEPRs){
                item.eprLI.EPR__c = epr.id;
                item.eprLI.Quantity__c = 1; //default to 1
                eprLIToSave.add(item.eprLI);
                          
            }
            system.debug('eprLIToSave = ' + eprLIToSave);
            INSERT eprLIToSave;
            //Run SOQL to get EPR calculation of Gross Amount to pass down to SPP
            Electronic_Payment_Request__c eprSaved = 
                [SELECT id, Gross_Payment_Amount__c FROM Electronic_Payment_Request__c WHERE id =: epr.id ];
            
            //create SPR Payment record
            List<Special_Procurement_Payment__c> sppToSave = new List<Special_Procurement_Payment__c>();
            sppToSave.add (new Special_Procurement_Payment__c(
                Company__c = sp.Requesting_Company__c,
                EPR__c = eprSaved.id,
                Special_Procurement__c=this.sp.id,
                Payment_Cost__c= eprSaved.Gross_Payment_Amount__c
            ));  
            INSERT sppToSave;
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Reconciliation EPR has been created'));
            
            // Create an approval request for the EPR
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval.');
            req.setObjectId(epr.Id);
            
            // Submit the EPR for approval
            Approval.ProcessResult result = Approval.process(req);  
            return null;
        }else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No applicable Recon Line Items to generate the Recon EPR'));
            return null;
        }
    }
    
    public class ReconEPRWrp {
        public EPR_Payable_Item__c eprLI {get; set;}
        public String rowID {get; set;}
        public LookupValue lkpGLA {get; set;}
        public LookupValue lkpDIM {get; set;}
        public Integer reconIndex {get;set;}
        
        //Constructor
        public ReconEPRWrp(Integer reconRowIndex, EPR_Payable_Item__c e){
            rowID = SanergyUtils.generateOTP(6,TRUE); //Generate a random ID to be used to search for the record
            reconIndex = reconRowIndex;
            eprLI = e;
        }
    }
*/
}