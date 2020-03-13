public class CreatePaymentsFromVendorInvoice{
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    //EPR
    public Electronic_Payment_Request__c eprM {get; set;}
    public EPR_Payable_Item__c eprLine {get; set;}
    List<Electronic_Payment_Request__c> eprs;
    public List<Vendor_Invoice_Payment__c> vipmt {get;set;}
    public Date EPRScheduledDate {get;set;}
    public String EPRPaymentTerms {get;set;}
    //  public Vendor_Invoice_Items__c>VInvoiceItems;
    
    //Vendor Invoice
    public Vendor_Invoice__c vi {get; set;}
    
    private List<String> sanergyLtd= new List<String> {};
        private List<String> sanergyFP=new List<String>  {};
            private List<String> sanergyNP=new List<String>  {};
                private List<String> freshLife=new List<String>  {};
                    
                    Map<String, Sanergy_Settings__c> settings;
    
    
    public CreatePaymentsFromVendorInvoice(ApexPages.StandardController controller){
        this.controller=controller;
        eprM=new Electronic_Payment_Request__c();   
        eprLine =new EPR_Payable_Item__c();
        eprs=new List<Electronic_Payment_Request__c>();
        vi=(Vendor_Invoice__c)controller.getRecord(); 
        vi =[SELECT Paid_Freshlife_Cost__c,Total_Freshlife_Cost__c,Paid_Sanergy_Cost__c,Total_Sanergy_Cost__c,
             Paid_SanergyFP_Cost__c,Total_SanergyFP_Cost__c,Paid_SanergyNP_Cost__c,Total_SanergyNP_Cost__c,
             Vendor__c,vendor__r.name, Vendor__r.c2g__CODABaseDate1__c, Vendor__r.c2g__CODADaysOffset1__c,
             Prepayment_Sanergy_Amount__c,Prepayment_Freshlife_Amount__c,Prepayment_SanergyFP_Amount__c,Prepayment_SanergyNP_Amount__c,
             Received_Sanergy_Value__c, Received_Freshlife_Value__c, Received_SanergyNP_Value__c, Received_SanergyFP_Value__c,
             Invoice_Number__c,Proforma_Invoice__c,id,Contract_Number__c,Payment_Terms__c,
             Payment_Terms_Due_Date__c,Actual_Date__c, Vendor_Invoice_date__c, Invoice_Total__c
             FROM Vendor_Invoice__c 
             WHERE id= :vi.id
            ]; 
        //set payment terms
        Date VIDate;
        //if VI has no date, set today as date
        VIDate = vi.Vendor_Invoice_date__c != NULL ? vi.Vendor_Invoice_date__c  : system.today();
        
        if(vi.Vendor__r.c2g__CODADaysOffset1__c == -2){
            //allow for Pre and Post Payments
            EPRScheduledDate = system.today();
            EPRPaymentTerms = 'Pre-Payment Vendor';
        }else if(vi.Vendor__r.c2g__CODADaysOffset1__c == -1){
            //allow for Prepayment
            EPRScheduledDate = system.today();
            EPRPaymentTerms = 'Pre-Payment Vendor';
        }else if(vi.Vendor__r.c2g__CODADaysOffset1__c > 0){
            //post payment by offset days
            EPRScheduledDate = VIDate + (Integer)vi.Vendor__r.c2g__CODADaysOffset1__c;
            EPRPaymentTerms = 'Post-Payment Vendor';
            //if expected date is within 3 days, set to today
            if(EPRScheduledDate < system.today() + 3){
                EPRScheduledDate = system.today();
            }
        }else {
            EPRScheduledDate = VIDate + 30;
            EPRPaymentTerms = 'NOT SET - DEFAULT 30 Days';
        }
        
        //get VI Payments
        getVIPayments();
        SYSTEM.debug('VI' + '' + vi);
        settings=Sanergy_Settings__c.getAll();
        
        vi.Prepayment_Sanergy_Amount__c=0;
        vi.Prepayment_Freshlife_Amount__c=0;
        vi.Prepayment_SanergyFP_Amount__c=0;
        vi.Prepayment_SanergyNP_Amount__c=0;
        
        //Get Companies
        List<FFA_Config_Object__c> company= [SELECT name, id, lookup_ID__c FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true];
        
        //loop through, assign ID to corresponding variable
        for(FFA_Config_Object__c c : company){
            if(c.name == 'Sanergy Limited'){
                this.sanergyLtd =new List<String> {'Sanergy Ltd', c.id, c.lookup_ID__c};
                    }
            else if(c.name == 'Sanergy, Inc. (FP)'){
                this.sanergyFP=new List<String> {'Sanergy Inc (FP)', c.id, c.lookup_ID__c};
                    }
            else if(c.name == 'Sanergy, Inc. (NP)'){
                this.sanergyNP=new List<String> {'Sanergy Inc (NP)', c.id, c.lookup_ID__c};
                    }
            else if(c.name == 'Fresh Life Initiative Limited'){
                this.freshLife=new List<String> {'Fresh Life Initiative Ltd', c.id, c.lookup_ID__c};
                    }
        }
        
        //if INvoice total/Date have been provided throuw error and exit
        if(vi.Vendor_Invoice_date__c == NULL ||  vi.Invoice_Total__c == NULL || vi.Invoice_Total__c == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Invoice Date (' + vi.Vendor_Invoice_date__c +') or Invoice amount (' + vi.Invoice_Total__c  +') has been provided'));
        }
    } 
    
    //Get VI Payments made
    public List<Vendor_Invoice_Payment__c> getVIPayments(){
        vipmt = [
            SELECT id, Name, EPR__c, EPR__r.Name, Payment_Made__c, Payment_Cost__c, EPR__r.Confirmation_Number__c,
            EPR__r.Cash_Entry__c, EPR__r.Cash_Entry__r.Name, EPR__r.Cash_Entry__r.c2g__Status__c
            FROM Vendor_Invoice_Payment__c
            WHERE Vendor_Invoice__c =: this.vi.id
        ];
        return vipmt;
    }
    
    public void createEPR(String companyName, Decimal amount, Id CompanyId, Id FFACompanyID){
        //CODE TO BE USED ON THE ERP WHEN WE DO SPR reimbursement ***********FROM HERE ******************
        /* Vendor_Invoice_Items__c VInvoiceItems = [SELECT Vendor_Invoice__c,Purchase_Order_Line_Item__c,Purchase_Order_Line_Item__r.PTS_Line_Item__c,
Purchase_Order_Line_Item__r.PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Special_Payment_Request__c
FROM Vendor_Invoice_Items__c
WHERE Vendor_Invoice__c =: vi.id
LIMIT 1
];
string x = VInvoiceItems.Purchase_Order_Line_Item__r.PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Special_Payment_Request__c;

if( x != null){

SYSTEM.debug('VINVOICEITEMS' + ' ' + VInvoiceItems);
Purchase_Order_Line_Item__c poLine = [SELECT PTS_Line_Item__r.Procurement_Tracking_Sheet__c,PTS_Line_Item__c,Notes__c
FROM Purchase_Order_Line_Item__c 
WHERE id =: VInvoiceItems.Purchase_Order_Line_Item__c
];
SYSTEM.debug('PTSLINE'+ ' ' + poLine);

Procurement_Tracking_Sheet__c pr =  [SELECT  Special_Payment_Request__c
FROM Procurement_Tracking_Sheet__c
WHERE id =: poLine.PTS_Line_Item__r.Procurement_Tracking_Sheet__c
];

PTS_Line_Item__c ptsLine = [SELECT Procurement_Tracking_Sheet__r.Special_Payment_Request__c,Comments__c,Payment_Status__c
FROM PTS_Line_Item__c 
WHERE id =: poLine.PTS_Line_Item__c
];
ptsLine.Comments__c = 'xxx';
poLine.Notes__c = 'Notes';
update poLine;
update ptsLine;

List <Special_Procurement_Payment__c> spp = [SELECT EPR__c
FROM Special_Procurement_Payment__c
WHERE Special_Procurement__c =: pr.Special_Payment_Request__c
];
SYSTEM.debug('SPP' + spp);   
if(spp.size() > 0){
Vendor_Invoice_Payment__c vip=new Vendor_Invoice_Payment__c(
Company__c=CompanyId,
EPR__c=spp.get(0).EPR__c,
Vendor_Invoice__c=this.vi.id,
Payment_Cost__c=amount

);
insert vip;


}




}
*///////////////////////////////////////////*****************************TO HERE **********************
        
        /* else {}*/
        Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c(
            department__c=settings.get('Supply Chain Department id').value__c,
            Company__c=companyName,
            RespectiveCompany__c= FFACompanyID, //FFA GUID
            Vendor_Company__c=this.vi.Vendor__c,
            Vendor_Invoice_Number__c = vi.Id,
            Scheduled_Payment_Date__c= EPRScheduledDate, //eprM.Scheduled_Payment_Date__c,
            Expected_Payment_Date__c = EPRScheduledDate,
            Status__c='Open',
            Team_Lead_Approval_Status__c='Pending',
            EPR_Type__c = 'Procurement',
            Notes__c='Payment for items bought at '+this.vi.Vendor__r.name+' as Per Vendor Invoice '+this.vi.Invoice_Number__c
        );
        
        if(this.vi.Invoice_Number__c==null){
            epr.Payment_Type__c='Prepayment';
            epr.Invoice_Number__c=this.vi.Proforma_Invoice__c;
        }
        else{
            epr.Payment_Type__c='Payment on Invoice';
            epr.Invoice_Number__c=this.vi.Invoice_Number__c;
        }
        
        INSERT epr;
        eprs.add(epr);
        
        //create EPR Line items
        EPR_Payable_Item__c eprLine=new EPR_Payable_Item__c(
            Department_dim1__c=epr.department__c,
            Item__c=epr.Notes__c,
            Quantity__c=1,
            Unit_Price__c=amount,
            EPR__c=epr.id
        );
        
        INSERT eprLine;
        
        /*
         //Do not Auto Submit EPR for approval as PPs need to attach docs to EPR and change Requesting Department
        // Create an approval request for the SPR
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setObjectId(epr.Id);
        
        // Submit the EPR for approval
        Approval.ProcessResult result = Approval.process(req);            
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'VI Payment EPR has been submitted for approval'));
        */
        Vendor_Invoice_Payment__c vip=new Vendor_Invoice_Payment__c(
            Company__c = CompanyId,
            EPR__c=epr.id,
            Vendor_Invoice__c=this.vi.id,
            Payment_Cost__c=amount
        ); 
        insert vip;
    }
    
    public PageReference createPrePaymentRequest(){
        
        List<String> errorMsg=new List<String>();
        //if no values entered, throw error and exit
        if(vi.Prepayment_Sanergy_Amount__c + vi.Prepayment_Freshlife_Amount__c + vi.Prepayment_SanergyFP_Amount__c + vi.Prepayment_SanergyNP_Amount__c == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No payment amounts have been entered for either companies'));
            return NULL;
        }
        //if INvoice total/Date have been provided throuw error and exit
        if(vi.Vendor_Invoice_date__c == NULL|| vi.Invoice_Total__c == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Invoice date (' + vi.Vendor_Invoice_date__c +') or Invoice amount (' + vi.Invoice_Total__c  +') has been provided'));
            return NULL;
        }
        //set any vendor without a set payment Term to 30 days
        if(EPRPaymentTerms == 'NOT SET - DEFAULT 30 Days') {EPRPaymentTerms = 'Post-Payment Vendor';}
        
        //Sanergy
        if(vi.Prepayment_Sanergy_Amount__c!=null && vi.Prepayment_Sanergy_Amount__c > 0){
            System.debug('Prepayment_Sanergy_Amount__c: '+vi.Prepayment_Sanergy_Amount__c);
            System.debug('Paid_Sanergy_Cost__c : '+vi.Paid_Sanergy_Cost__c );
            System.debug('Total_Sanergy_Cost__c: '+vi.Total_Sanergy_Cost__c);
            
            if(vi.Prepayment_Sanergy_Amount__c + vi.Paid_Sanergy_Cost__c <= vi.Total_Sanergy_Cost__c  ){
                switch on EPRPaymentTerms{
                    when 'Pre-Payment Vendor' {
                        createEPR(this.sanergyLtd.get(0), vi.Prepayment_Sanergy_Amount__c, this.sanergyLtd.get(1), this.sanergyLtd[2]);   
                    }
                    when 'Post-Payment Vendor' {
                        //pay only upto max received value
                        if(vi.Prepayment_Sanergy_Amount__c + vi.Paid_Sanergy_Cost__c <= vi.Received_Sanergy_Value__c){
                            createEPR(this.sanergyLtd.get(0), vi.Prepayment_Sanergy_Amount__c, this.sanergyLtd.get(1), this.sanergyLtd[2]);   
                        }else{
                            vi.Prepayment_Sanergy_Amount__c.addError('This value is more than the maximum payable for the Total Received Value = ' + 
                                                                    vi.Prepayment_Sanergy_Amount__c + ' + ' + vi.Paid_Sanergy_Cost__c + ' + ' + vi.Received_Sanergy_Value__c);
                            return null;
                        }   
                    }
                }
            }
            else{
                vi.Prepayment_Sanergy_Amount__c.addError('This value is more than the maximum payable');
                return null;
            }
        }
        
        //freshlife
        System.debug('Prepayment_Freshlife_Amount__c: '+vi.Prepayment_Freshlife_Amount__c);
        System.debug('Paid_Freshlife_Cost__c : '+vi.Paid_Freshlife_Cost__c );
        System.debug('Total_Freshlife_Cost__c: '+vi.Total_Freshlife_Cost__c);
        System.debug('Received_Freshlife_Value__c: '+vi.Received_Freshlife_Value__c);
        if(vi.Prepayment_Freshlife_Amount__c!=null && vi.Prepayment_Freshlife_Amount__c> 0){
            if(vi.Prepayment_Freshlife_Amount__c+ vi.Paid_Freshlife_Cost__c <= vi.Total_Freshlife_Cost__c  ){
                system.debug('this.freshLife = ' + this.freshLife);
                switch on EPRPaymentTerms{
                    when 'Pre-Payment Vendor' {
                        createEPR(this.freshLife.get(0), vi.Prepayment_Freshlife_Amount__c, this.freshLife.get(1), this.freshLife[2]);  
                    }
                    when 'Post-Payment Vendor' {
                        //pay only upto max received value
                        if(vi.Prepayment_Freshlife_Amount__c + vi.Paid_Freshlife_Cost__c <= vi.Received_Freshlife_Value__c){
                            createEPR(this.freshLife.get(0), vi.Prepayment_Freshlife_Amount__c, this.freshLife.get(1), this.freshLife[2]);   
                        }else{
                            vi.Prepayment_Freshlife_Amount__c.addError('This value is more than the maximum payable for the Total Received Value = ' + 
                                                                       vi.Prepayment_Freshlife_Amount__c + ' + ' + vi.Paid_Freshlife_Cost__c + ' + ' + vi.Received_Freshlife_Value__c);
                            return null;
                        }   
                    }
                }
            }
            else{
                vi.Prepayment_Sanergy_Amount__c.addError('This value is more than the maximum payable');
                return null;
            }
        } 
  
        //SanergyFP
        if(vi.Prepayment_SanergyFP_Amount__c!=null && vi.Prepayment_SanergyFP_Amount__c> 0){
            if(vi.Prepayment_SanergyFP_Amount__c+ vi.Paid_SanergyFP_Cost__c <= vi.Total_SanergyFP_Cost__c  ){
                system.debug('this.SanergyFP = ' + this.SanergyFP);
                switch on EPRPaymentTerms{
                    when 'Pre-Payment Vendor' {
                        createEPR(this.SanergyFP.get(0), vi.Prepayment_SanergyFP_Amount__c, this.SanergyFP.get(1), this.SanergyFP[2]);  
                    }
                    when 'Post-Payment Vendor' {
                        //pay only upto max received value
                        if(vi.Prepayment_SanergyFP_Amount__c + vi.Paid_SanergyFP_Cost__c <= vi.Received_SanergyFP_Value__c){
                            createEPR(this.SanergyFP.get(0), vi.Prepayment_SanergyFP_Amount__c, this.SanergyFP.get(1), this.SanergyFP[2]);   
                        }else{
                            vi.Prepayment_SanergyFP_Amount__c.addError('This value is more than the maximum payable for the Total Received Value = ' + 
                                                                       vi.Prepayment_SanergyFP_Amount__c + ' + ' + vi.Paid_SanergyFP_Cost__c + ' + ' + vi.Received_SanergyFP_Value__c);
                            return null;
                        }   
                    }
                }
            }
            else{
                vi.Prepayment_Sanergy_Amount__c.addError('This value is more than the maximum payable');
                return null;
            }
        }        
        
        //SanergyNP
        if(vi.Prepayment_SanergyNP_Amount__c!=null && vi.Prepayment_SanergyNP_Amount__c> 0){
            if(vi.Prepayment_SanergyNP_Amount__c+ vi.Paid_SanergyNP_Cost__c <= vi.Total_SanergyNP_Cost__c  ){
                system.debug('this.SanergyNP = ' + this.SanergyNP);
                switch on EPRPaymentTerms{
                    when 'Pre-Payment Vendor' {
                        createEPR(this.SanergyNP.get(0), vi.Prepayment_SanergyNP_Amount__c, this.SanergyNP.get(1), this.SanergyNP[2]);  
                    }
                    when 'Post-Payment Vendor' {
                        //pay only upto max received value
                        if(vi.Prepayment_SanergyNP_Amount__c + vi.Paid_SanergyNP_Cost__c <= vi.Received_SanergyNP_Value__c){
                            createEPR(this.SanergyNP.get(0), vi.Prepayment_SanergyNP_Amount__c, this.SanergyNP.get(1), this.SanergyNP[2]);   
                        }else{
                            vi.Prepayment_SanergyNP_Amount__c.addError('This value is more than the maximum payable for the Total Received Value = ' + 
                                                                       vi.Prepayment_SanergyNP_Amount__c + ' + ' + vi.Paid_SanergyNP_Cost__c + ' + ' + vi.Received_SanergyNP_Value__c);
                            return null;
                        }   
                    }
                }
            }
            else{
                vi.Prepayment_Sanergy_Amount__c.addError('This value is more than the maximum payable');
                return null;
            }
        }   
                
        /* if(vi.Prepayment_SanergyFP_Amount__c!=null && vi.Prepayment_SanergyFP_Amount__c> 0  ){
createEPR(this.sanergyFP.get(0), vi.Prepayment_SanergyFP_Amount__c, this.sanergyFP.get(1), true);
}
if(vi.Prepayment_SanergyNP_Amount__c!=null && vi.Prepayment_SanergyNP_Amount__c> 0  ){
createEPR(this.sanergyNP.get(0), vi.Prepayment_SanergyNP_Amount__c, this.sanergyNP.get(1), true);
}
if(vi.Prepayment_Freshlife_Amount__c!=null && vi.Prepayment_Freshlife_Amount__c> 0  ){
createEPR(this.freshLife.get(0),vi.Prepayment_Freshlife_Amount__c, this.freshLife.get(1), true);
}
*/
        return new PageReference('/'+vi.id);  
    }
    
}