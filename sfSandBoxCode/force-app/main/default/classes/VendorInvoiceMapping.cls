public class VendorInvoiceMapping {
    public ApexPages.StandardController standardController;
    private ApexPages.StandardSetController stdSetController;
    public Vendor_Invoice__c vi {get;set;}
    public Integer rowCount {get;set;}
    public String viGUID {get; set;}
    public String viAction {get; set;}
    
    public List<ItemWrapper> items {get;set;}
    public List<ItemWrapper> VIPOLIforPIN {get;set;}
    public Integer VIPOLIForPINRows {get;set;} //Num of Rows for VIPO LI
    public List<PoliWrapper> poItems {get;set;}
    public List<PoliClosedWrapper> poItemsClosed {get;set;}
    public List<Vendor_Invoice_Purchase_Order_Line_Item__c> VIPOitems {get;set;}
    public List<Vendor_Invoice_Purchase_Order_Line_Item__c> VIPOItemsToSave {get;set;}
    public List<Vendor_Invoice_Purchase_Order_Line_Item__c> VIPOitemsList {get;set;}
    public List<Vendor_Invoice_Purchase_Order_Line_Item__c> VIPOitemsListClosed {get;set;}
    public Purchase_Order_Line_Item__c poli {get;set;} 
    public List<Purchase_Order_Line_Item__c> poliToSave = new List<Purchase_Order_Line_Item__c>();
    public List<Purchase_Order_Line_Item__c> poliList;
    public List<Purchase_Order_Line_Item__c> poliListToSave = new List<Purchase_Order_Line_Item__c>();
    public List<Purchase_Order_Line_Item__c> poliListClosed;
    public List<Vendor_Invoice_Payment__c> vipmt {get;set;}
    public List<String> poliIds = new List<String>();
    public List<String> poliListIds = new List<String>();
    //public List<PINLineWrapper>  ReconPINLines {get; set;}
    Set<Id> poLIGUIDs  = new Set<Id>();
    public Integer selectedRows {get;set;}
    //create disabled
    public Boolean ishide {get; set;}
    public Boolean showButtons {get; set;}
    public Boolean showReconcileButton {get; set;}
    public Boolean allVIReconciled {get; set;}
    public String companyGUID {get; set;}
    public String companyName {get; set;}
    private String companyNameInitials {get; set;}
    
    public String ReconPINLineDesc {get; set;}
    public decimal ReconPINNetValue {get; set;}
    public decimal ReconPINTaxValue {get; set;}
    public LookupValue ReconPINGLA {get; set;} 
    public LookupValue ReconPINDIM1 {get; set;} 
    public LookupValue ReconPINDIM2 {get; set;} 
    public LookupValue ReconPINDIM3 {get; set;} 
    public LookupValue ReconPINDIM4 {get; set;} 
    
    public VendorInvoiceMapping(ApexPages.StandardController standardController){
        this.standardController = standardController;
        //ReconPINLines = new List<PINLineWrapper>();
        //CreatePINLine();
        // ApexPages.currentPage().getParameters().get('id')
        // get the vi  items of the current vendor invoice
        this.vi = (Vendor_Invoice__c)standardController.getRecord();
        //populate the VI
        requeryThisVI(this.vi.id);
            
        // Require invoice total to proceed
        if(this.vi.Invoice_Total__c == null || String.isBlank(String.valueOf(this.vi.Invoice_Total__c))){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Vendor Invoice Total Must Be Provided');
            ApexPages.addmessage(msg);
            showButtons = FALSE; //Hide Save/Reconcile Buttons
            showReconcileButton = FALSE;
        }
        else if(vi.Total_Payments__c == 0 && vi.Sum_VI_Items_Accepted__c == 0){
            //If no items have been received and payments made then we cannot reconcile the VI
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot reconcile a VI without any Payments and any Receipts');
            ApexPages.addmessage(msg); 
            showButtons = FALSE; //Hide Save/Reconcile Buttons
            showReconcileButton = FALSE;
        }
        else{
            poli = new Purchase_Order_Line_Item__c();
            getVendorInvoicePurchaseOrderLineItems();
            getpoItems();
            getpoItemsClosed();
            Rows(); 
            showButtons = TRUE; //Hide Save/Reconcile Buttons
            if (vi.Reconciled__c == TRUE) {
                //If the VI has already been reconciled - Just allow for POLI Recon
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'This VI has already been Reconciled. Reconcile the POLI');
                ApexPages.addmessage(msg); 
                showButtons = FALSE; //Hide Save/Reconcile Buttons
                showReconcileButton = TRUE;
            }
        }
        
        //if Invoice Received Total or Total Payments == 0, require receipts/payments to be made first
        if(this.vi.Total_Payments__c * this.vi.Invoice_Received_Value__c == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Receipts and/or Payments have been made for this VI. Complete these to FULLY RECONCILE this VI'));
        }
        system.debug('VENDOR iNVOICE' + this.vi);
    }
    
    public VendorInvoiceMapping(ApexPages.StandardSetController standardSetController){
        viGUID = apexpages.currentpage().getparameters().get('id');
        viAction = apexpages.currentpage().getparameters().get('action');
        //ReconPINLines = new List<PINLineWrapper>();
        ReconPINGLA = new LookupValue();
        ReconPINDIM1 = new LookupValue();
        ReconPINDIM2 = new LookupValue();
        ReconPINDIM3 = new LookupValue();
        ReconPINDIM4 = new LookupValue();
        
        if(String.isNotBlank(viGUID) ){
            //populate the VI
            requeryThisVI(viGUID);
            
            //choose action
            switch on viAction {
                when 'viFirm' {getVendorInvoicePurchaseOrderLineItems();}
                when 'CreatePIN' {
                    CheckFFAUserCompany();
                    getVIPOLIForPIN();
                    getVIPayments();
                    //CreatePINLine();
                }
                when else {getVIPOLIForPIN();}
            }
        }else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not find a VI with this ID'));
        } 
    }
   
    private Boolean CheckFFAUserCompany(){
        //check the Company associated with the VI
        AggregateResult [] aggComp = 
            [
                SELECT Purchase_Order_Line_Item__r.Requesting_Company__c CompanyGUID,
                Purchase_Order_Line_Item__r.Requesting_Company__r.Name CompanyName,
                COUNT(id)Rows
                FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                WHERE Vendor_Invoice__c =: this.vi.Id
                GROUP BY Purchase_Order_Line_Item__r.Requesting_Company__c,Purchase_Order_Line_Item__r.Requesting_Company__r.Name
            ];
        system.debug('aggComp = ' + aggComp);
        //system.debug('aggComp V = ' + aggComp[0].get('CompanyName')+ ' *** ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
        this.CompanyGUID = ''; 
        this.CompanyName = '';
        this.CompanyGUID = (String)aggComp[0].get('CompanyGUID');
        this.CompanyName = (String)aggComp[0].get('CompanyName');
        //proceed if one company found and company names are the same
        if(aggComp.size() == 1 && c2g.CODAAPICompany_2_0.GetCurrentCompanies(null).size() == 1 &&
          this.companyName == c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0] //check if Companies match
          ){
              return TRUE; //confirm current company is same as what user is currently in
        }
        else{
            //not Found
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot create PIN, ensure FFA Company selected is the same as that of the VI'));
            return FALSE;
        }
    }
    
    //requery the VI especially when the VI values have been updated and are required to be evaluated/used for next call 
    private void requeryThisVI(Id thisVIGUID){
        this.vi = [SELECT ID,Name, Vendor__c,Expected_Total__c,Receipt_Variance__c,Payment_Variance__c,Invoice_Number__c,
                   VI_Status__c,Invoice_Total__c,Reconciled__c,Total_Payments__c,Reconciled_Invoice_Total__c,
                   Reconciled_Received_Value__c, Comments__c, Contract_Number__c, Payment_Terms__c, Payment_Terms_Due_Date__c, 
                   Payment_Total_Reconciled_Total_Diff__c,Count_VIPOLI__c, Count_VIPOLI_Reconciled__c, Sum_VI_Items_Accepted__c, 
                   Invoice_Received_Value__c,RecordTypeId, Sum_VI_Items_Received_Value__c,Variance_Flag__c,Max_Price_Var__c,
                   Min_Price_Var__c, VI_PIN__c, Payment_Confirmed__c, VI_Receipt_Status__c, VI_Company__c 
                   FROM Vendor_Invoice__c
                   WHERE id =: thisVIGUID
                  ];
    }
    
    //get the list of vendor invoice purchase order line items
    public List<ItemWrapper> getVendorInvoicePurchaseOrderLineItems(){
        items = new List<ItemWrapper>();
        
        VIPOitems = 
            [
                SELECT ID,Name,Item_Received_Total__c, Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,
                Purchase_Order_Line_Item__r.Name, Vendor_Invoice__r.Vendor__c,
                Purchase_Order_Line_Item__r.Item__c, Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
                Purchase_Order_Line_Item__r.UoM__c,Purchase_Order_Line_Item__r.PTS_Line_Item__c, 
                Purchase_Order_Line_Item__r.PTS_Line_Item__r.Name,
                Purchase_Order_Line_Item__r.Purchase_Order__c,Purchase_Order_Line_Item__c,
                Purchase_Order_Line_Item__r.Quantity_Requested__c, Purchase_Order_Line_Item__r.Quantity_Accepted__c,
                Requested_Quantity__c,Status__c, Purchase_Order_Line_Item__r.Item_Type__c,
                Total_Cost__c,Vendor_Invoice__c,Purchase_Order_Line_Item__r.Unit_Gross_Price__c, 
                Purchase_Order_Line_Item__r.Total_Price__c, Purchase_Order_Line_Item__r.VAT_Amount__c, 
                Purchase_Order_Line_Item__r.Unit_Net_Price__c,
                Vendor_Invoice__r.Reconciled__c, Reconciled_Item_Quantity_Received__c,Vendor_Invoice__r.Invoice_Total__c,
                Vendor_Invoice__r.Count_VIPOLI__c, Vendor_Invoice__r.Count_VIPOLI_Reconciled__c,
                Last_Invoice__c, Reconciled_Line_Total__c, Reconciled_Line_VAT__c, Reconciled_Line_Net_Cost__c
                FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                WHERE Vendor_Invoice__c =: this.vi.Id
                //AND Vendor_Invoice__r.Reconciled__c = false
                AND Vendor_Invoice__r.Invoice_Total__c != null
                AND Vendor_Invoice__r.Count_VIPOLI__c > 0 
            ];
        system.debug('VIPOitems = ' + VIPOitems);
        //Clone
        VIPOItemsToSave = VIPOItems.clone();
        
        //loop through all the items   
        for(Vendor_Invoice_Purchase_Order_Line_Item__c item : VIPOitems){
            system.debug('item.Id' + item.Id);            
            poLIGUIDs.add(item.Purchase_Order_Line_Item__c); //get list of POLI GUIDs
            
            AggregateResult [] groupedResults = [SELECT SUM(Receive_Quantity__c)ReceivedQty
                                                 FROM Vendor_Invoice_Items__c
                                                 WHERE Vendor_Invoice_Purchase_Order_Line_Item__c =: item.Id
                                                 GROUP BY Vendor_Invoice_Purchase_Order_Line_Item__c
                                                ];
            system.debug('groupedResults' + groupedResults);
           
            if(groupedResults.size() > 0 ){
                item.Item_Received_Total__c = double.valueOf(groupedResults[0].get('ReceivedQty'));
            }
            else{
                item.Item_Received_Total__c = 0 ; 
            }
            
            // item.Item_Received_Total__c = double.valueOf(groupedResults[0].get('ReceivedQty') == NULL ? 0: groupedResults[0].get('ReceivedQty'));
            system.debug('Item_Received_Total__c' + item.Item_Received_Total__c);
            
            ItemWrapper wrapper = new ItemWrapper(item);
            //wrapper.selected = false;
            items.add(wrapper);
            
            //if all lines status = Reconciled, hide the button
            if(item.Status__c != 'Reconciled'){
                allVIReconciled = FALSE;
            }
        }
        
        if(allVIReconciled == TRUE){
            isHide = FALSE;
            showReconcileButton = FALSE;
            showButtons = FALSE;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'All records for this VI has already been Reconciled');
            ApexPages.addmessage(msg);
        } else
        {
            isHide = TRUE;
            showReconcileButton = TRUE;
            showButtons = TRUE;   
        }
        return items;   
    }
    
    //get the purchase order line items that have been selected for reconciliation 
    public List<PoliWrapper> getpoItems(){
        
        VIPOitemsList = 
            [SELECT ID,Name,Item_Received_Total__c,Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
             Purchase_Order_Line_Item__r.Quantity_Requested__c,Purchase_Order_Line_Item__r.Status__c,Purchase_Order_Line_Item__r.Item__c,
             Purchase_Order_Line_Item__r.Quantity_Accepted__c,Purchase_Order_Line_Item__c,Requested_Quantity__c,Status__c,
             Total_Cost__c,Vendor_Invoice__c,Reconciled_Item_Quantity_Received__c,Last_Invoice__c, 
             Reconciled_Line_VAT__c, Reconciled_Line_Net_Cost__c
             FROM Vendor_Invoice_Purchase_Order_Line_Item__c
             WHERE Vendor_Invoice__c =: this.vi.Id
             AND Last_Invoice__c =  true
             AND Purchase_Order_Line_Item__r.Status__c != 'Closed'
            ];
        
        
        system.debug('VIPOitemsList.size()' + VIPOitemsList.size());
        /*
        if(VIPOitemsList.size() > 0){
            ishide = true;
        }
        else if (VIPOitemsList.size() == 0){
            ishide = false;
        }*/
        for(Vendor_Invoice_Purchase_Order_Line_Item__c vendorInvoice: VIPOitemsList){
            poliIds.add(vendorInvoice.Purchase_Order_Line_Item__c);
        }
        
        poItems = new List<PoliWrapper>();
        
        poliList = [SELECT ID,Name,Last_Invoice__c,VI_Avg_Unit_Price__c,Item__c,Unit_Gross_Price__c,Payment_Variance__c,
                    Receipt_Variance__c,Purchase_Order_Item__r.Name,Quantity_Requested__c,Quantity_Accepted__c,
                    Po_line_Receipt_Status__c,Status__c,Variance_Flag__c,Max_Price_Var__c,Min_Price_Var__c
                    FROM Purchase_Order_Line_Item__c 
                    WHERE ID IN : poliIds
                    AND (Last_Invoice__c = TRUE AND Status__c != 'Closed')
                   ]; 
        
        for(Purchase_Order_Line_Item__c lst:poliList){
            poItems.add(new PoliWrapper(lst));    
        }

        system.debug('POITEMS' + poItems);
        return poItems;
    }
    
    //get the purchase order line items that hav ebeen selected for reconciliation and are Closed
    public List<PoliClosedWrapper> getpoItemsClosed(){
        
        VIPOitemsListClosed = [SELECT ID,Name,Item_Received_Total__c,
                               Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,
                               Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
                               Purchase_Order_Line_Item__r.Quantity_Requested__c,
                               Purchase_Order_Line_Item__r.Status__c,
                               Purchase_Order_Line_Item__r.Quantity_Accepted__c,
                               Purchase_Order_Line_Item__c,Requested_Quantity__c,Status__c,
                               Total_Cost__c,Vendor_Invoice__c,
                               Reconciled_Item_Quantity_Received__c,
                               Last_Invoice__c, Reconciled_Line_VAT__c, Reconciled_Line_Net_Cost__c
                               FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                               WHERE Vendor_Invoice__c =: this.vi.Id
                               AND Last_Invoice__c =  true
                               AND Purchase_Order_Line_Item__r.Status__c = 'Closed'
                              ];
        
        List<String> poliIdsClosed = new List<String>();
        
        for(Vendor_Invoice_Purchase_Order_Line_Item__c vendorInvoice: VIPOitemsListClosed){
            poliIdsClosed.add(vendorInvoice.Purchase_Order_Line_Item__c);
        }
        
        poItemsClosed = new List<PoliClosedWrapper>();
        
        poliListClosed = [SELECT ID,Name,Last_Invoice__c,VI_Avg_Unit_Price__c,Item__c,
                          Unit_Gross_Price__c,Payment_Variance__c,Receipt_Variance__c,Purchase_Order_Item__r.Name,
                          Quantity_Requested__c,Quantity_Accepted__c,Po_line_Receipt_Status__c,
                          Status__c,Variance_Flag__c,Max_Price_Var__c,Min_Price_Var__c
                          FROM Purchase_Order_Line_Item__c 
                          WHERE ID IN : poliIdsClosed
                          AND (Last_Invoice__c = TRUE AND Status__c = 'Closed')
                         ]; 
        
        for(Purchase_Order_Line_Item__c lst:poliListClosed){
            poItemsClosed.add(new PoliClosedWrapper(lst));    
        }
        
        return poItemsClosed;
        
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
    
    /*
    public List<PINLineWrapper> CreatePINLine(){
        //c2g__codaPurchaseInvoiceExpenseLineItem__c
        //ReconPINLines.add();
        return ReconPINLines;
    }
*/
    
    // Get the number of Rows 
    public Integer Rows(){
        AggregateResult [] Results = [SELECT COUNT(ID)no
                                      FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                      WHERE Vendor_Invoice__c =: this.vi.Id
                                     ];
        rowCount = integer.valueOf(Results[0].get('no'));
        return rowCount;
    }
    
    // Get the number of Rows 
    public Integer Ro(){
        AggregateResult [] Results = [SELECT COUNT(ID)no
                                      FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                      WHERE Vendor_Invoice__c =: this.vi.Id
                                     ];
        rowCount = integer.valueOf(Results[0].get('no'));
        return rowCount;
    }
  
    //save method - saves a draft and does not reconcile yet
    public PageReference saveVI(){
        //if VI Total not provided exit
        if(this.vi.Invoice_Total__c == null || String.isBlank(String.valueOf(this.vi.Invoice_Total__c))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Invoice amount (' + vi.Invoice_Total__c  +') has been provided'));
            return NULL;
        }
        
        //Set Default

        poliToSave.clear();
        if(VIPOItemsToSave != NULL){
          VIPOItemsToSave.clear();  
        }
    
        //Set Default
        showReconcileButton = TRUE;
        
        //get all the Reconciled VIPOLI Values that belong to the current VI. 
        AggregateResult [] groupedResults = 
            [
                SELECT Purchase_Order_Line_Item__c POLIGUID, Purchase_Order_Line_Item__r.Name POLIName, 
                SUM(Reconciled_Line_Total__c)ReconciledTotal,
                SUM(Reconciled_Item_Quantity_Received__c)ReconciledQty
                FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                WHERE Purchase_Order_Line_Item__c IN : poLIGUIDs
                GROUP BY Purchase_Order_Line_Item__c, Purchase_Order_Line_Item__r.Name
            ];
        system.debug('poliIds = ' + poliIds);
        system.debug('Agg groupedResults = ' + groupedResults);
        
        //Counter to store rows selected - to determine whether to save records
    selectedRows = 0;
        
        //Done this nested loop to avoid Too Many SOQL error.
        for(ItemWrapper item : items){
            if(item.selected ==true){
                selectedRows = selectedRows + 1; //update counter
                
                item.vipoli.Item_Received_Total__c = 0 ;
                //loop through and find required Line Record
                Boolean recFound = false;
                Double ReconTotal = 0.0;
                Double ReconQty = 0.0;
                for(AggregateResult ag : groupedResults){
                    system.debug ('ag = ' + ag);
                    ReconTotal = double.valueOf(ag.get('ReconciledTotal')) != NULL ? double.valueOf(ag.get('ReconciledTotal')) : item.vipoli.Reconciled_Line_Total__c;
                    ReconQty = double.valueOf(ag.get('ReconciledQty')) != NULL ? double.valueOf(ag.get('ReconciledQty')) : item.vipoli.Reconciled_Item_Quantity_Received__c;
                    if(ag.get('POLIName') == item.vipoli.Purchase_Order_Line_Item__r.Name){
                        poli = new Purchase_Order_Line_Item__c ();
                        poli.id = string.valueOf(ag.get('POLIGUID'));
                        poli.Name = string.valueOf(ag.get('POLIName'));
                        poli.Last_Invoice__c = item.vipoli.Last_Invoice__c;
                        poli.VI_Recon_Total__c  = ReconTotal;
                        poli.VI_Recon_Qty_s__c = ReconQty;  
                        
                        poliToSave.add(poli);
                        
                        //add to the VIPOItemsToSave List
                        VIPOItemsToSave.add(item.vipoli);
                        system.debug ('poli = ' + poli);
                        //exit loop and flag that we found record
                        recFound = true;
                        break;
                    }
                }
                //if record not found in Aggregate list means first time reconciling
                if(recFound == FALSE){
                    poli = new Purchase_Order_Line_Item__c ();
                    poli.id = item.vipoli.Purchase_Order_Line_Item__r.Id;
                    poli.Name = item.vipoli.Purchase_Order_Line_Item__r.Name;
                    poli.Last_Invoice__c = item.vipoli.Last_Invoice__c;
                    poli.VI_Recon_Total__c  = item.vipoli.Reconciled_Line_Total__c;
                    poli.VI_Recon_Qty_s__c = item.vipoli.Reconciled_Item_Quantity_Received__c;  
                    
                    system.debug ('New POLI = ' + poli);
                    system.debug ('New VIPOLI = ' + item);
                    poliToSave.add(poli);
                }
                
                item.vipoli.Status__c = 'Reconciled';
                //if an Item has Last VI not checked then we cannot Reconcile the VI
                if(item.vipoli.Last_Invoice__c == false){
                    showReconcileButton = false; 
                }
            }
        }

        try{
            if(selectedRows > 0 && groupedResults.size() > 0){
                //Update objects
                UPDATE VIPOItemsToSave;
                UPDATE poliToSave; 
                
                //update variance notes and requery the VI
                UPDATE vi;
                //Requery the VI
                requeryThisVI(this.vi.id);
                
                //Update VI Status if all VI lines have been closed and payments recon = 0
                if(vi.Count_VIPOLI__c == vi.Count_VIPOLI_Reconciled__c && vi.Count_VIPOLI__c != 0 && 
           vi.Payment_Total_Reconciled_Total_Diff__c == 0   //Payments reconciled
                  ){// 
                      vi.Reconciled__c = TRUE;
                      vi.VI_Status__c = 'Closed';
                      vi.Status__c = 'Closed';
                      //Get record type for VI Closed
                      RecordType rt = [SELECT id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'VI_Read_Only' AND SobjectType  = 'Vendor_Invoice__c' LIMIT 1];
                      vi.RecordTypeId = rt.id;
                      UPDATE vi;
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'To complete Reconciliation of this VI, ensure all payments have been requested'));
                }

                getVendorInvoicePurchaseOrderLineItems();
                //if successful confirm on page
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records Successfully Updated'));
            }else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Records have been selected for updating'));
            }
            return null;  
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            
      //return to same page to display error
            return null;
        } 
    }    
    
    public PageReference ReconcilePOLI(){
        if (poliList != NULL && poliList.size()>0){ //save only if values
            //clone schema and clear List
            poliListToSave = poliList.clone();
            poliListToSave.clear();
            
            //get all the VII that belong to the current VI. 
            AggregateResult [] groupedResults = 
                [
                    SELECT Purchase_Order_Line_Item__c POLIGUID, Purchase_Order_Line_Item__r.Name POLIName, 
                    SUM(Reconciled_Line_Total__c)ReconciledTotal,
                    SUM(Reconciled_Item_Quantity_Received__c)ReconciledQty
                    FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                    WHERE Purchase_Order_Line_Item__c IN : poliIds
                    GROUP BY Purchase_Order_Line_Item__c, Purchase_Order_Line_Item__r.Name
                ];
            system.debug('ReconcilePOLI groupedResults = ' + groupedResults);
            
            //Counter to store rows selected - to determine whether to save records
            selectedRows = 0;
            system.debug('poItems = ' + poItems);
            //Loop through and process selected lines only
            for(PoliWrapper wrpPOLI : poItems){
                if (wrpPOLI.selected == true){
                    selectedRows = selectedRows + 1; //update counter
                    system.debug('wrpPOLI = ' + wrpPOLI);
                    //if variance notes were provided update with text " **POLI CLOSE OVERRIDE**" to allow the POLI to Closed Status
                    system.debug('wrpPOLI.polineItems.Receipt_Variance__c = ' +wrpPOLI.polineItems.Receipt_Variance__c);
                    system.debug('wrpPOLI.polineItems.Payment_Variance__c = ' +wrpPOLI.polineItems.Payment_Variance__c);
                    if(wrpPOLI.polineItems.Last_Invoice__c == true && (String.isBlank(wrpPOLI.polineItems.Receipt_Variance__c) == FALSE && String.isBlank(wrpPOLI.polineItems.Payment_Variance__c) == FALSE)){
                        wrpPOLI.polineItems.Receipt_Variance__c = string.valueOf('**POLI CLOSE OVERRIDE**' + (string.valueOf(wrpPOLI.polineItems.Receipt_Variance__c)).replace('**POLI CLOSE OVERRIDE**',''));
                        wrpPOLI.polineItems.Payment_Variance__c = string.valueOf('**POLI CLOSE OVERRIDE**' + (string.valueOf(wrpPOLI.polineItems.Payment_Variance__c)).replace('**POLI CLOSE OVERRIDE**',''));
                    }
                    //loop through the Aggregate list and check for the value
                    for(AggregateResult ag : groupedResults){
                        if(wrpPOLI.polineItems.id == string.valueOf(ag.get('POLIGUID'))){
                            //update the POLI
                            wrpPOLI.polineItems.VI_Recon_Total__c  = double.valueOf(ag.get('ReconciledTotal'));
                            wrpPOLI.polineItems.VI_Recon_Qty_s__c = double.valueOf(ag.get('ReconciledQty')); 
                            //exit loop
                            system.debug('wrpPOLI.polineItems = ' + wrpPOLI.polineItems);
                            break;
                        }
                    }
                    
                    poliListToSave.add(wrpPOLI.polineItems);
                    //add id
                    poliListIds.add(wrpPOLI.polineItems.id);
                }
            }
            
            if(poliListToSave.size() > 0 && selectedRows > 0){
                UPDATE poliListToSave;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PO Line Items have been updated'));
            } else
            {
                System.debug('poliListToSave else' + poliListToSave.size());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are no PO Line Items to update'));
            }
             
            System.debug('qwwqeqweweqewqe ' + poliList);
            System.debug('poliListToSave ' + poliListToSave.size());
            
            //return to same VF page and refresh
            PageReference pageRef = new PageReference('/apex/POLIMapping');
            pageRef.getParameters().put('Id',vi.Id);
            pageRef.setRedirect(true);
            return pageRef;
              
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are no PO Line Items to update'));
            return null;
        } 
    }
    
    public PageReference CallReconcilePage(){
        //Call the POLI Recon Page
        PageReference pageRef = new PageReference('/apex/POLIMapping');
        pageRef.getParameters().put('Id',vi.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }   
    
    public List<ItemWrapper> getVIPOLIForPIN(){
        //Get VIPOLI that will get the PIN created for
        VIPOLIforPIN = new List<ItemWrapper>();
        VIPOLIForPINRows = 0;
        List <Vendor_Invoice_Purchase_Order_Line_Item__c> vipoliLst = new List<Vendor_Invoice_Purchase_Order_Line_Item__c>();
        vipoliLst = 
            [
                SELECT ID,Name,Item_Received_Total__c, Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,Purchase_Order_Line_Item__r.Name,
                Purchase_Order_Line_Item__r.Item__c, Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
                Purchase_Order_Line_Item__r.UoM__c,
                Purchase_Order_Line_Item__r.Quantity_Requested__c, Purchase_Order_Line_Item__r.Quantity_Accepted__c,
                Purchase_Order_Line_Item__c,Requested_Quantity__c,Status__c,Total_Cost__c,Vendor_Invoice__c,
                Vendor_Invoice__r.Reconciled__c, Reconciled_Item_Quantity_Received__c,Vendor_Invoice__r.Invoice_Total__c,
                Vendor_Invoice__r.Count_VIPOLI__c, Vendor_Invoice__r.Count_VIPOLI_Reconciled__c,
                Last_Invoice__c, Reconciled_Line_Total__c, Reconciled_Line_VAT__c, Reconciled_Line_Net_Cost__c,
                Purchase_Order_Line_Item__r.GLA__c, Purchase_Order_Line_Item__r.GLA__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_1__c,Purchase_Order_Line_Item__r.Dimension_1__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_2__c, Purchase_Order_Line_Item__r.Dimension_2__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_3__c, Purchase_Order_Line_Item__r.Dimension_3__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_4__c, Purchase_Order_Line_Item__r.Dimension_4__r.Lookup_Id__c
                FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                WHERE Vendor_Invoice__c =: this.vi.Id
                AND Vendor_Invoice__r.Reconciled__c = TRUE         //VI already reconciled
                AND Vendor_Invoice__r.Reconciled_Invoice_Total__c > 0  //Reconciled VI value is positive
                AND Vendor_Invoice__r.Count_VIPOLI__c > 0         //VIPOLI exist for this VI
                AND Vendor_Invoice__r.VI_PIN__c = NULL          //PIN Not yet created
                AND Vendor_Invoice__r.Total_Payments__c > 0        //Payments have already been made
            ];
        
        //loop through all the items and add to the wrapper
        for(Vendor_Invoice_Purchase_Order_Line_Item__c item : vipoliLst){ 
            ItemWrapper vipoliItem = new ItemWrapper(item);
            //calculate WHVAT Element
            if(this.companyName == 'Sanergy Limited' ){
                //round off to nearest whole number if > 0.01
                vipoliItem.WHVATAmount = SanergyUtils.KRARound(item.Reconciled_Line_VAT__c * 0.375) * -1; //negate WHVAT 
            }         
            
            VIPOLIforPIN.add(vipoliItem);
            VIPOLIForPINRows = VIPOLIForPINRows + 1; //Increment counter
        }
        return VIPOLIforPIN;
    }
    
    public PageReference CreatePIN(){
        //Confirm VI in reconciled status
        system.debug('VI in CreatePIN() = ' + vi);
        if(vi.VI_PIN__c == NULL && vi.VI_Status__c == 'Closed' && vi.Payment_Confirmed__c > 0){
             //Create PIN if company matches
            if(CheckFFAUserCompany() == TRUE){
                //this.CompanyGUID
                String bankName = '';
                switch on this.companyName {
                    when 'Sanergy Limited' { 
                        bankName = 'SL - SCB - KES'; 
                    }  
                    when 'Fresh Life Initiative Limited' { 
                        bankName='FLI - SCB - KES';
                    }
                    when 'Sanergy Inc (FP)' { 
                        bankName='FP Checking'; 
                    }
                    when 'Sanergy Inc (NP)' {
                        bankName='NP Checking'; 
                    } 
                    when else {  //Company not found  
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Bank Account not Found to Create PIN'));
                        return NULL;
                    }
                }            
                List<c2g__codaBankAccount__c > bankAcc=[SELECT Id,c2g__BankAccountCurrency__c 
                                                        FROM c2g__codaBankAccount__c
                                                        WHERE Name=:bankName];            

                if(bankAcc.size() > 0){
                    system.debug('BANK ACC' +' '+ bankAcc.get(0).c2g__BankAccountCurrency__c);
                    
                    c2g__codaPurchaseInvoice__c PIN=new c2g__codaPurchaseInvoice__c();
                    PIN.c2g__Account__c= vi.Vendor__c;
                    PIN.c2g__InvoiceDate__c = Date.Today();
                    PIN.c2g__DueDate__c= Date.Today() + 1;
                    PIN.c2g__AccountInvoiceNumber__c=vi.Name;
                    // PIN.c2g__InvoiceCurrency__c=bankAcc.get(0).c2g__BankAccountCurrency__c;
                    
                    INSERT PIN; 
                    
                    Id CreatedPINId = PIN.Id;
                    
                    List<c2g__codaPurchaseInvoiceExpenseLineItem__c> PIN_Line=new List<c2g__codaPurchaseInvoiceExpenseLineItem__c>();
                    VIPOItemsToSave = new List<Vendor_Invoice_Purchase_Order_Line_Item__c>();
                    Decimal WHVAT = 0.0;
                    Decimal WHTax = 0.0;
                    for(ItemWrapper poliItem : VIPOLIforPIN){ 
                        system.debug('PoliItemWrapper in PIN = ' + poliItem);
                        c2g__codaPurchaseInvoiceExpenseLineItem__c pinLine=new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                            c2g__PurchaseInvoice__c = CreatedPINId,
                            ffap__SetGLAToDefault__c=false,
                            c2g__LineDescription__c = poliItem.vipoli.Reconciled_Item_Quantity_Received__c  + ' ' 
                              + poliItem.vipoli.Purchase_Order_Line_Item__r.UoM__c + ' of ' 
                              + poliItem.vipoli.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name
                              + ' @' + poliItem.vipoli.Item_Unit_Cost__c + ' each'
                            ,
                            c2g__NetValue__c = poliItem.vipoli.Reconciled_Line_Net_Cost__c,
                            c2g__TaxValue1__c = poliItem.vipoli.Reconciled_Line_VAT__c,
                            ffap__SetTaxCodeToDefault__c = false,
                            ffap__CalculateTaxValueFromRate__c = true,
                            ffap__DeriveTaxRateFromCode__c = true,
                            c2g__GeneralLedgerAccount__c = poliItem.vipoli.Purchase_Order_Line_Item__r.GLA__r.Lookup_Id__c,
                            c2g__Dimension1__c= poliItem.vipoli.Purchase_Order_Line_Item__r.Dimension_1__r.Lookup_Id__c, //Whatever the user entered in the Recon
                            c2g__Dimension2__c= poliItem.vipoli.Purchase_Order_Line_Item__r.Dimension_2__r.Lookup_Id__c,
                            c2g__Dimension3__c= poliItem.vipoli.Purchase_Order_Line_Item__r.Dimension_3__r.Lookup_Id__c,
                            c2g__Dimension4__c= poliItem.vipoli.Purchase_Order_Line_Item__r.Dimension_4__r.Lookup_Id__c
                        );   
                        //Adding WHVAT
                        if(this.companyName == 'Sanergy Limited'){
                            WHVAT = WHVAT + (poliItem.vipoli.Reconciled_Line_VAT__c * 0.375);
                        }   
                        //Adding WithHolding Tax
                        if(poliItem.WHTaxAmount != 0){
                            system.debug('WHTax + poliItem.WHTaxAmount = ' + WHTax + ' ' + poliItem.WHTaxAmount + ' = ' + WHTax + poliItem.WHTaxAmount);
                            WHTax = WHTax + poliItem.WHTaxAmount;
                        }
                        PIN_Line.add(pinLine);
                          
                        poliItem.vipoli.Status__c = 'AP Matched';
                        VIPOItemsToSave.add(poliItem.vipoli);
                    }
                    
                    //if rounding of recon values entered, create another PIN Line
                    if(ReconPINNetValue != 0 || ReconPINTaxValue != 0.0){
                        system.debug('CreatedPINId = ' + ReconPINGLA.value + '***ReconPINDIM1.value**' + ReconPINDIM1.value);
                        c2g__codaPurchaseInvoiceExpenseLineItem__c pinLineReconAdj =new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                            c2g__PurchaseInvoice__c = CreatedPINId,
                            ffap__SetGLAToDefault__c=false,
                            c2g__LineDescription__c = 'PIN Rounding Off',
                            c2g__NetValue__c = ReconPINNetValue,
                            c2g__TaxValue1__c = ReconPINTaxValue,
                            ffap__SetTaxCodeToDefault__c = false,
                            ffap__CalculateTaxValueFromRate__c = true,
                            ffap__DeriveTaxRateFromCode__c = true,
                            c2g__GeneralLedgerAccount__c = ReconPINGLA.value,
                            c2g__Dimension1__c= ReconPINDIM1.value,
                            c2g__Dimension2__c= ReconPINDIM2.value,
                            c2g__Dimension3__c= ReconPINDIM3.value,
                            c2g__Dimension4__c= ReconPINDIM4.value
                        );  
                        //Add Adj PIN Line
                        PIN_Line.add(pinLineReconAdj);
                    }
                    
                    //Add PIN Line if WithHolding Tax
                     if(WHTax != 0){      
                        //create WHTax PIN Line
                        c2g__codaGeneralLedgerAccount__c WHTaxGLA = [SELECT id, Name FROM c2g__codaGeneralLedgerAccount__c WHERE c2g__ReportingCode__c = '2170' LIMIT 1];
                        c2g__codaPurchaseInvoiceExpenseLineItem__c pinLineWHTax =new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                            c2g__PurchaseInvoice__c = CreatedPINId,
                            ffap__SetGLAToDefault__c=false,
                            c2g__LineDescription__c = 'WHTaxAmount',
                            c2g__NetValue__c = WHTax,
                            c2g__GeneralLedgerAccount__c = WHTaxGLA.id
                        );     
                        
                        PIN_Line.add(pinLineWHTax);
                    }
                    
                    //if SLK - add WHVAT
                    if(this.companyName == 'Sanergy Limited' && WHVAT > 0){
                        //round off to nearest whole number if > 0.01
                        WHVAT = SanergyUtils.KRARound(WHVAT) * -1; //negate WHVAT
                        
                        //create WHVAT PIN Line
                        c2g__codaGeneralLedgerAccount__c WHVATGLA = [SELECT id, Name FROM c2g__codaGeneralLedgerAccount__c WHERE c2g__ReportingCode__c = '2162' LIMIT 1];
                        c2g__codaPurchaseInvoiceExpenseLineItem__c pinLineWHVAT = new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                            c2g__PurchaseInvoice__c = PIN.ID,
                            ffap__SetGLAToDefault__c=false,
                            c2g__LineDescription__c = 'WHVAT',
                            c2g__NetValue__c = WHVAT,
                            c2g__GeneralLedgerAccount__c = WHVATGLA.id
                        );     
                        
                        PIN_Line.add(pinLineWHVAT);
                    }
                    
                    INSERT PIN_LINE;
                    //update VIPOLI with matched status
                    UPDATE VIPOItemsToSave;
                          
                    //update statuses
                    vi.VI_Status__c = 'AP Matched';
                    vi.Status__c = 'PIN Created';
                    vi.VI_PIN__c = PIN.ID;
                    UPDATE vi;
                    
                    system.debug('SPRLINE' + PIN_LINE);
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Creating PIN Successful'));
                }else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot create a PIN for this VI at the moment')); 
                }
            }
            
            return NULL;
        }
        else {
            if(vi.VI_PIN__c != NULL) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This VI already has an existing PIN'));}
            else if(vi.VI_Status__c != 'Closed') {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This VI needs to be reconciled first'));}
            else if(vi.Payment_Confirmed__c <= 0) {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payments not yet confirmed for this VI'));}
            else {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This VI cannot be AP Matched'));}
            return NULL;
        }
    }     
    
    //Set VI to Firmed Status
    public PageReference FirmVI() {
        try{
            //if the first VII, set the VI company to the Company on the VII
            AggregateResult [] aggVI = 
                [SELECT Company__c, Company__r.Name CompanyName, COUNT(id)VICOs
                 FROM Vendor_Invoice_Items__c
                 WHERE Vendor_Invoice__c =: vi.Id
                 AND CreatedDate >= 2020-01-01T00:00:00Z
                 GROUP BY Company__c, Company__r.Name
                ];
            system.debug('aggVI = ' + aggVI);
            //if one record found and company matches vii company firm the VI
            if(aggVI.size() > 0 && aggVI.size() == 1 && ((Integer)aggVI[0].get('VICOs') == 0 || vi.VI_Company__c == NULL)){
                vi.VI_Company__c = (String)aggVI[0].get('Company__c');
                vi.Status__c = 'Firmed';
                //Get record type for VI Closed
                RecordType rt = [SELECT id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'After_Firm' AND SobjectType  = 'Vendor_Invoice__c' LIMIT 1];
                vi.RecordTypeId = rt.id;
                
                UPDATE vi;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'VI has been Firmed'));
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Company on the VI must match that of the VI Items'));
            }
        }
        catch(exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        return NULL;
    }
    //Close the VI
    public PageReference CloseVI(){
        //ensure receipts/payments made else require variance comment
        if((vi.VI_Receipt_Status__c != 'All Items Received' && String.isBlank(String.valueOf(this.vi.Receipt_Variance__c))) 
           || (vi.Total_Payments__c != vi.Invoice_Received_Value__c  &&   String.isBlank(String.valueOf(this.vi.Payment_Variance__c))//payments do not match receipts
          )){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payments/Receipts are incomplete and no Respective Variance notes have been provided'));
              return NULL;
        }
        
        //close if VI Reconciled. If not reconciled then we should be cancelling the VI
        if(vi.Reconciled__c == TRUE ||
          (vi.Count_VIPOLI__c == vi.Count_VIPOLI_Reconciled__c && vi.Count_VIPOLI__c != 0) //some reconcilitation has been done
          ){
            vi.VI_Status__c = 'Closed';
            vi.Reconciled__c = TRUE;
            //Get record type for VI Closed
            RecordType rt = [SELECT id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'VI_Read_Only' AND SobjectType  = 'Vendor_Invoice__c' LIMIT 1];
            vi.RecordTypeId = rt.id;
            
            UPDATE vi;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'VI has been closed'));
        }else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot close a VIN that has not been reconciled'));
        }
        return NULL;
    }
    
    //Discard the VI
    public PageReference DiscardVI(){
        //Only discard if in Open/Firmed status
        if(vi.VI_Status__c == 'Open' || vi.VI_Status__c == 'Firmed'){
            
        }
        //if any payments made
        return NULL;
    }
 /*   
    //Add VIPOLI lines to existing PIN
    public PageReference AddVIPOLIToExistingPIN(){
        //only if a PIN is existing and the PIN is in progress
        //search for PIN and status
        c2g__codaPurchaseInvoice__c VIPIN = 
            [
              SELECT id, Name, c2g__InvoiceStatus__c FROM c2g__codaPurchaseInvoice__c WHERE id =: this.vi.VI_PIN__c  
            ];
        
        if(VIPIN.c2g__InvoiceStatus__c == 'In Progress' ){
            //ok to add to PIN
            
        }else
        {
            //Do not allow any additions to this PIN
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No PIN in valid status has been selected')); 
        }
        return NULL;
    }
   */ 
    //wrapper class
    public PageReference CalculateTotals(){
        VIPOitems = [SELECT ID,Name,Item_Received_Total__c,
                     Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,
                     Purchase_Order_Line_Item__c,Requested_Quantity__c,
                     Reconciled_Line_Total__c,Last_Invoice__c,Status__c,
                     Total_Cost__c,Vendor_Invoice__c, Reconciled_Line_VAT__c, Reconciled_Line_Net_Cost__c
                     FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                     WHERE Vendor_Invoice__c =: vi.Id
                    ];       
        
        for (Vendor_Invoice_Purchase_Order_Line_Item__c item : VIPOitems){
            for(ItemWrapper itm : getVendorInvoicePurchaseOrderLineItems()){
                item.Item_Total__c = (itm.vipoli.Item_Unit_Cost__c);
            }
            ItemWrapper wrapper = new ItemWrapper(item);
            items.add(wrapper);
        }
        
        //getItems();
        return null;
    }
    
    //Vendor Invoice Purchase Order Line Items Wrapper Class 
    public class ItemWrapper{
        public Vendor_Invoice_Purchase_Order_Line_Item__c vipoli{get;set;}
        public Boolean selected {get; set;}
        public Boolean disableProcessChkBox {get; set;}
        public Boolean disableLastVIChkBox {get; set;}
        public decimal NetCost {get; set;}
        public decimal WHTaxRate {get; set;}  //Witholding Tax Rate
        public decimal WHTaxAmount {get; set;}  //Witholding Tax Amount
        public decimal WHVATAmount {get; set;}  //Witholding VAT Amount
        
        public ItemWrapper(Vendor_Invoice_Purchase_Order_Line_Item__c vipolitems){
            //selected = true;
            disableProcessChkBox = false;
            disableLastVIChkBox = false;
            WHTaxRate = 0.0;
            WHVATAmount = 0.0;
            vipoli = vipolitems;
            WHTaxAmount = 0.0;
           if (vipoli.Status__c != 'Open' && vipoli.Status__c != NULL){
                //disable process Checkbox
                disableProcessChkBox = true;
            }
            if (vipoli.Last_Invoice__c == TRUE){
                //disable process Checkbox
                disableLastVIChkBox = true;
            }
        } 
    }
    
    //Purchase Order line item wrapper class
    public class PoliWrapper{
        public Purchase_Order_Line_Item__c polineItems{get;set;}
        public Boolean selected {get; set;}
        public Boolean disableProcessChkBox {get; set;}
        public Boolean disableLastVIChkBox {get; set;}
        
        public PoliWrapper(Purchase_Order_Line_Item__c poL){
            //Set defaults
            disableProcessChkBox = false;
            disableLastVIChkBox = false;
            polineItems =  poL;
            if (polineItems.Status__c == 'Closed' || polineItems.Status__c == 'Cancelled'){
                //disable process Checkbox if POLI is closed/cancelled
                disableProcessChkBox = true;
                disableLastVIChkBox = true;
            }
            if (polineItems.Last_Invoice__c == TRUE){
                //disable Last VI Checkbox
                disableLastVIChkBox = true;
            }
        }
    }
    
    //Purchase Order line item wrapper class
    public class PoliClosedWrapper{
        public Purchase_Order_Line_Item__c polineItemsClosed{get;set;}
        
        public PoliClosedWrapper(Purchase_Order_Line_Item__c poL){
            polineItemsClosed =  poL;
        }
    }
    
    //PIN Line Item Wrapper
/*    public class PINLineWrapper{
        public String LineDesc {get; set;}
        public decimal NetValue {get; set;}
        public decimal TaxValue {get; set;}
        public LookupValue GLA {get; set;} 
        public LookupValue DIM1 {get; set;} 
        public LookupValue DIM2 {get; set;} 
        public LookupValue DIM3 {get; set;} 
        public LookupValue DIM4 {get; set;} 
        
        public PINLineWrapper(){

        }
    }
*/
    //Select All Items to Process
    public PageReference selectAll() {
        if(items!=null){
            for(ItemWrapper itm : items){
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
        if(items!=null){
            for(ItemWrapper itm : items){
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
    
    //Select All Items to Process
    public PageReference selectAllPOLI() {
        if(poItems!=null){
            for(PoliWrapper itm : poItems){
                itm.selected=true;
            }
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No items available to Select/UnSelect');
            ApexPages.addmessage(msg);
        }
        return null;
    }
    
    //Unselect All Items to Process
    public PageReference unselectAllPOLI() {
        if(poItems!=null){
            for(PoliWrapper itm : poItems){
                itm.selected=false;
            }
        } 
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No items available to Select/Unselect');
            ApexPages.addmessage(msg);
        }
        return null;
    }        
   
    public void testSelectUnselect(){
        selectAll();
        UnselectAll();
        selectAllPOLI();
        UnselectAllPOLI();
    }
    
    /*
    public PageReference saveAndReconcileVI(){
        //Save lines first and then reconcile
        //Save Lines - Call Save Method
    //saveVI();
        poliToSave.clear();
        
        //get all the VII that belong to the current VI. 
        AggregateResult [] groupedResults = 
            /*SELECT SUM(Reconciled_Item_Quantity_Received__c)ReconciledQty
                                                  FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                                  WHERE Purchase_Order_Line_Item__c =: poli.Id
                                                  GROUP BY Purchase_Order_Line_Item__c*++/
            [
                SELECT Purchase_Order_Line_Item__c POLIGUID, Purchase_Order_Line_Item__r.Name POLIName, 
                SUM(Reconciled_Line_Total__c)ReconciledTotal,
                SUM(Reconciled_Item_Quantity_Received__c)ReconciledQty
                FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                WHERE Vendor_Invoice__c IN : poliIds
                GROUP BY Purchase_Order_Line_Item__c, Purchase_Order_Line_Item__r.Name
            ];
        
        //Done this nested loop to avoid Too Many SOQL error.
        for(Vendor_Invoice_Purchase_Order_Line_Item__c item : VIPOitems){
            //system.debug('item.Id' + item);            
            item.Item_Received_Total__c = 0 ;
            //loop through and find required Line Record
            for(AggregateResult ag : groupedResults){
                //system.debug('AG = ' + ag.get('POLIName'));
                if(ag.get('POLIName') == item.Purchase_Order_Line_Item__r.Name){
                    poli = new Purchase_Order_Line_Item__c ();
                    poli.id = string.valueOf(ag.get('POLIGUID'));
                    poli.Name = string.valueOf(ag.get('POLIName'));
                    poli.Last_Invoice__c = item.Last_Invoice__c;
                    poli.VI_Recon_Total__c  = double.valueOf(ag.get('ReconciledTotal'));
                    poli.VI_Recon_Qty_s__c = double.valueOf(ag.get('ReconciledQty'));  
                    
                    poliToSave.add(poli);
                    system.debug ('poli = ' + poli);
                    //exit loop
                    break;
                }
            }
        }
        
        System.debug('poliToSave = ' +poliToSave);
        //Update 
        UPDATE poliToSave;
        getpoItems();
        getpoItemsClosed();
        return Page.POLIMapping;
    }
/*    
    //save method - NOT USING THIS METHOD HAS BEEN REPLACED WITH saveAndReconcileVI()
    public PageReference save(){
        //Set Default
        poliToSave.clear();
        vi.Reconciled__c = true;
        upsert vi;       
        upsert VIPOitems;
        system.debug('VIPOITEMS' + VIPOitems);
        
        for(Vendor_Invoice_Purchase_Order_Line_Item__c item: VIPOitems ){
            poli = new Purchase_Order_Line_Item__c (id = item.Purchase_Order_Line_Item__c,Last_Invoice__c = item.Last_Invoice__c );
            /*poli = [SELECT ID,Name,Last_Invoice__c 
                    FROM Purchase_Order_Line_Item__c
                    WHERE ID =: item.Purchase_Order_Line_Item__c
                   ]; 
            *++/
            AggregateResult [] groupedResults1 = [SELECT SUM(Reconciled_Line_Total__c)ReconciledTotal,
                                                  SUM(Reconciled_Item_Quantity_Received__c)ReconciledQty
                                                  FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                                  WHERE Purchase_Order_Line_Item__c =: poli.Id
                                                  GROUP BY Purchase_Order_Line_Item__c
                                                 ];
            /*
AggregateResult [] groupedResults2 = [SELECT SUM(Reconciled_Item_Quantity_Received__c)ReconciledQty
FROM Vendor_Invoice_Purchase_Order_Line_Item__c
WHERE Purchase_Order_Line_Item__c =: poli.Id
GROUP BY Purchase_Order_Line_Item__c
];   
*++/
            
            //poli.Last_Invoice__c = item.Last_Invoice__c;
            poli.VI_Recon_Total__c  = double.valueOf(groupedResults1[0].get('ReconciledTotal'));
            poli.VI_Recon_Qty_s__c = double.valueOf(groupedResults1[0].get('ReconciledQty'));            
            //UPSERT poli;  
      system.debug('poli == ' + poli);            
            poliToSave.add(poli);
        }
        update poliToSave;
        getpoItems();
        getpoItemsClosed();
        return Page.POLIMapping;
        //  return (new ApexPages.StandardController(vi)).view();
        //return new PageReference('/' + vi.Id);
        
    }
*/        
}