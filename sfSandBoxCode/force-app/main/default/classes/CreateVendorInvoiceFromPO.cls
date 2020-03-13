public with sharing class CreateVendorInvoiceFromPO {
    private ApexPages.StandardController standardController;
    private ApexPages.StandardSetController stdSetController;
    public Purchase_Order__c purchaseOrder;
    private Vendor_Invoice__c vendorInvoice;
    Procurement_Tracking_Sheet__c Pr;
    public Id invoice;
    private List<Purchase_Order_Line_Item__c> items {get; set;}
    private List<Vendor_Invoice__c > vins {get; set;}
    private List<Vendor_Invoice__c > viToAddPOLI {get; set;}
    public List<POLItem > wrpPOLI {get; set;}
    public String viGUID {get; set;}
    public Purchase_Order__c POName {get; set;}
    public String PONameToSearch {get; set;}
    public Integer CountSelectedRows {get; set;}
    public boolean viValidToProceed {get; set;}
    
    public CreateVendorInvoiceFromPO(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.purchaseOrder = (Purchase_Order__c)standardController.getRecord();
        this.purchaseOrder =[SELECT Company__c ,count_of_lines__c  , Delivery_Address__c   , Delivery_Date__c  ,Delivery_Mode__c,Order_Status__c   ,
                             Percentage_Being_Paid__c, PO_Currency__c,Total_Amount__c,   Total_Freshlife_Cost__c ,
                             Total_Net_Amount__c , Total_Sanergy_Cost__c, Total_SaneryFP_Cost__c, Total_SaneryNP_Cost__c ,
                             Total_VAT_Amount__c ,  Vendor_Account__c, Count_PO_Line_Items__c, Count_PO_Line_Items_Open__c
                             FROM Purchase_Order__c
                             WHERE ID=:purchaseOrder.id  
                            ];
        system.debug('PURCHASEOORDER' + purchaseOrder);
    }
    
    public CreateVendorInvoiceFromPO(ApexPages.StandardSetController standardSetController){
        POName = new Purchase_Order__c();
        //Run this when called from the AddPOLIToVI page
        viGUID = apexpages.currentpage().getparameters().get('id');
        if(viGUID != NULL && viGUID !=''){
            vendorInvoice =[
                SELECT id,Currency_Config_Currency__c, Delivery_Note_Number__c, Freshlife_Balance__c, Paid_Freshlife_Cost__c, Paid_Sanergy_Cost__c, Paid_SanergyFP_Cost__c, Vendor__c, Vendor_Invoice_date__c,
                Paid_SanergyNP_Cost__c, Invoice_Balance__c, Invoice_Number__c, Invoice_Received_Value__c, Prepayment_Freshlife_Amount__c, Prepayment_Sanergy_Amount__c, Prepayment_SanergyFP_Amount__c,
                Prepayment_SanergyNP_Amount__c, Proforma_Invoice__c, Received_Freshlife_Value__c, Received_SanergyFP_Value__c, Received_SanergyNP_Value__c, Received_Sanergy_Value__c, Sanergy_Balance__c,
                SanergyFP_Balance__c, SanergyNP_Balance__c, Status__c, Total_Freshlife_Cost__c, Total_Invoice_Cost_del__c, Total_Payments__c, Total_Sanergy_Cost__c, Total_SanergyFP_Cost__c, Total_SanergyNP_Cost__c,
                Name,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,	Actual_Date__c
                FROM Vendor_Invoice__c 
                WHERE id =: viGUID
            ];
            system.debug('vendorInvoice = ' + vendorInvoice);
            //if VI in open  status, show button to search for PO and proceed
            if(vendorInvoice.Status__c == 'Open'){
                viValidToProceed = TRUE;
            } else
            {
                viValidToProceed = FALSE;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'VI needs to be in an Open status to add PO Items'));
            }
        }else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Vendor Invoice has been provided'));
        }
    }
    
    public List<Purchase_Order_Line_Item__c> getItems() {
        items= new List<Purchase_Order_Line_Item__c>();
        if(this.purchaseOrder == NULL){
            SearchForPO();
        }
        
        System.debug('PO Order Status: ' + this.purchaseOrder.Order_Status__c); 

        if(this.purchaseOrder.Order_Status__c == 'Vendor Notified' || this.purchaseOrder.Order_Status__c == 'Items Partially Received'){
            List<Purchase_Order_Line_Item__c> lineItems = [SELECT id,Name , Company__c , Requesting_Company__c , CompanyName__c , Dimension_1__c  ,Dimension_2__c ,Dimension_3__c , Dimension_4__c,
                                                           Electronic_Payment_Request__c  ,EPR_Line_Item__c   ,GLA__c , Invoice_Assigned__c   ,Item_Type__c   , Item__c   ,Vatable__c, PIN__c  ,PIN_Line_Item__c   ,
                                                           PTS_Line_Item__c, PTS_Line_Item__r.Name  ,Purchase_Order__c, Purchase_Order_Item__c  ,Quantity_Accepted__c   ,Quantity_Remaining__c  ,Quantity_Requested__c  ,Quantity_RTV__c    ,
                                                           Status__c  ,Terms_Conditions__c    ,Total_Price__c ,Total_Item_Value__c ,Total_Net_Price__c  ,Total_VAT_Amount__c  , PTS_Line_Item__r.RequestType__c,
                                                           Unit_Net_Price__c  ,Unit_Price__c  ,VAT_Amount__c, VAT_inclusive__c, VAT_Percentage__c, Vendor_id__c,Variation_Notes__c
                                                           FROM Purchase_Order_Line_Item__c 
                                                           WHERE Purchase_Order__c =: purchaseOrder.Id 
                                                           //AND Invoice_Assigned__c = false
                                                           AND Po_line_Receipt_Status__c IN ('Open','Items Partially Received')
                                                           ORDER BY NAME DESC
                                                          ];
            
            System.debug('lineItems = : ' + lineItems);            
            wrpPOLI = new List<POLItem>();
            for(Purchase_Order_Line_Item__c lineItem : lineItems){
                items.add(lineItem);
                wrpPOLI.add(new POLItem(lineItem));
            }
            system.debug('wrpPOLI' + wrpPOLI);
        }
        return items;
    }

    public PageReference createInvoice(){
        List<Contract> contract = [SELECT Id,ContractNumber,AccountId,Primary_Contract__c
                                   FROM Contract
                                   WHERE AccountId =: purchaseOrder.Vendor_Account__c
                                   AND Primary_Contract__c = true
                                   AND Contract_Expired__c = FALSE];
        if(contract.size()>0){ 
            if(items != null && items.size() > 0){
                
                Double i = +1;
                
                Vendor_Invoice__c vi = new Vendor_Invoice__c ();
                
                vi.Vendor__c = purchaseOrder.Vendor_Account__c;
                vi.Currency_Config_Currency__c = purchaseOrder.PO_Currency__c;
                vi.Contract_Number__c = contract.get(0).Id;
                vi.Status__c = 'Open';
                vi.Invoice_Total__c = 0;
                vi.Reconciled_Invoice_Total__c = 0;
                vi.Payment_Status__c = 'No Payments Done';
                vi.VI_Receipt_Status__c =  'No Items Received';
                vi.VI_Status__c = 'Open';
                
                INSERT vi;
                
                invoice = vi.Id;
                
                //update PO Status
                purchaseOrder.Order_Status__c  = 'Vendor Invoice Generated';
                purchaseOrder.Next_Step__c = 'VI Generated';
                
                
                purchaseOrder.Vendor_Invoice__c = vi.Id;
                update purchaseOrder;
                system.debug('POID'+ purchaseOrder.Id);
                
                Vendor_Invoice_PO__c viPO = new Vendor_Invoice_PO__c();
                
                viPO.Purchase_Order__c = purchaseOrder.Id;
                system.debug('PURCHASE ORDER ID' + purchaseOrder.Id);
                system.debug('VIPO PO' + viPO.Purchase_Order__c);
                viPO.Vendor_Invoice__c = vi.Id;
                
                insert viPO;
                
                //List <Purchase_Order_Line_Item__c>lst = new List <Purchase_Order_Line_Item__c> ;
                for(Purchase_Order_Line_Item__c item : items){
                        Vendor_Invoice_Purchase_Order_Line_Item__c viPOLine = new Vendor_Invoice_Purchase_Order_Line_Item__c (
                            Vendor_Invoice__c = vi.Id,
                            Purchase_Order_Line_Item__c = item.Id,
                            Requested_Quantity__c = item.Quantity_Requested__c,
                            Total_Cost__c = (item.Quantity_Remaining__c * (item.Unit_Net_Price__c + item.VAT_Amount__c))
                            //Quantity__c = item.Quantity_Remaining__c,
                            //Total_Cost__c = (item.Quantity_Remaining__c * (item.Unit_Net_Price__c + item.VAT_Amount__c)),
                            //Company__c = item.Requesting_Company__c,
                            //Status__c = 'Pending GIGO Check'
                        );
                    insert viPOLine;
                    system.debug('viPOLine' + viPOLine);   
 
                    Vendor_Invoice_Items__c viLine = new Vendor_Invoice_Items__c (
                        Vendor_Invoice__c = vi.Id,
                        Purchase_Order_Line_Item__c = item.Id,
                        Vendor_Invoice_Purchase_Order_Line_Item__c = viPOLine.Id,
                        Quantity__c = item.Quantity_Remaining__c,
                        Accepted_Receive_Quantity__c = 0.00, 
                        Total_Cost__c = (item.Quantity_Remaining__c * (item.Unit_Net_Price__c + item.VAT_Amount__c)),
                        Company__c = item.Requesting_Company__c,
                        Status__c = 'Open'
                    );

                    //insert viPOLine;
                    insert viLine;                        
                        
                    item.Invoice_Assigned__c = true;
                    update item;
                }
                
                return Page.CreateVIFromPO2;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This PO does Not have Line Items'));
                return null;
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make sure a primary contract exists for the Vendor on the PO.'));
            return null;
        }
        
    }  
    
    public List<Vendor_Invoice__c > getVins() {
        if(vins == null) {
            vins = new List<Vendor_Invoice__c >();
            
            List< Vendor_Invoice__c > newVI= [SELECT id,Currency_Config_Currency__c, Delivery_Note_Number__c, Freshlife_Balance__c, Paid_Freshlife_Cost__c, Paid_Sanergy_Cost__c, Paid_SanergyFP_Cost__c, Vendor__c, Vendor_Invoice_date__c,
                                              Paid_SanergyNP_Cost__c, Invoice_Balance__c, Invoice_Number__c, Invoice_Received_Value__c, Prepayment_Freshlife_Amount__c, Prepayment_Sanergy_Amount__c, Prepayment_SanergyFP_Amount__c,
                                              Prepayment_SanergyNP_Amount__c, Proforma_Invoice__c, Received_Freshlife_Value__c, Received_SanergyFP_Value__c, Received_SanergyNP_Value__c, Received_Sanergy_Value__c, Sanergy_Balance__c,
                                              SanergyFP_Balance__c, SanergyNP_Balance__c, Status__c, Total_Freshlife_Cost__c, Total_Invoice_Cost_del__c, Total_Payments__c, Total_Sanergy_Cost__c, Total_SanergyFP_Cost__c, Total_SanergyNP_Cost__c,
                                              Name,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,	Actual_Date__c
                                              FROM Vendor_Invoice__c 
                                              WHERE id =: invoice]; 
            
            for(Vendor_Invoice__c newV: newVI){
                vins.add(newV);
                System.debug('Test 1' + vins);
            }
        }
        System.debug('Test 2 + Invoive' + vins + ' *** ' + invoice);
        return vins;
    }
    
    public PageReference editInvoice(){         
        if(vins != null && vins.size() > 0){
            for(Vendor_Invoice__c vin: vins){
                update vin;
            } 
        }
        else{           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Update Unsuccessful'));
            return null;            
        }  
        return new PageReference('/' + invoice);                                     
    }
    
    public List<Vendor_Invoice__c> getviToAddPOLI(){
        viToAddPOLI = 
            [
                SELECT id,Currency_Config_Currency__c, Delivery_Note_Number__c, Freshlife_Balance__c, Paid_Freshlife_Cost__c, Paid_Sanergy_Cost__c, Paid_SanergyFP_Cost__c, Vendor__c, Vendor_Invoice_date__c,
                Paid_SanergyNP_Cost__c, Invoice_Balance__c, Invoice_Number__c, Invoice_Received_Value__c, Prepayment_Freshlife_Amount__c, Prepayment_Sanergy_Amount__c, Prepayment_SanergyFP_Amount__c,
                Prepayment_SanergyNP_Amount__c, Proforma_Invoice__c, Received_Freshlife_Value__c, Received_SanergyFP_Value__c, Received_SanergyNP_Value__c, Received_Sanergy_Value__c, Sanergy_Balance__c,
                SanergyFP_Balance__c, SanergyNP_Balance__c, Status__c, Total_Freshlife_Cost__c, Total_Invoice_Cost_del__c, Total_Payments__c, Total_Sanergy_Cost__c, Total_SanergyFP_Cost__c, Total_SanergyNP_Cost__c,
                Name,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,	Actual_Date__c
                FROM Vendor_Invoice__c 
                WHERE id =: vendorInvoice.Id
            ]; 
        
        return viToAddPOLI;
    }
    
    public PageReference SearchForPO(){
        system.debug('PONameToSearch = ' + PONameToSearch +  ' *** this.purchaseOrder = ' + this.purchaseOrder);
        if(this.purchaseOrder == NULL && PONameToSearch != NULL){
            try {
                this.purchaseOrder =[SELECT Company__c ,count_of_lines__c  , Delivery_Address__c   , Delivery_Date__c  ,Delivery_Mode__c,Order_Status__c   ,
                                     Percentage_Being_Paid__c, PO_Currency__c,Total_Amount__c,   Total_Freshlife_Cost__c ,
                                     Total_Net_Amount__c , Total_Sanergy_Cost__c, Total_SaneryFP_Cost__c, Total_SaneryNP_Cost__c ,
                                     Total_VAT_Amount__c ,  Vendor_Account__c , Count_PO_Line_Items__c, Count_PO_Line_Items_Open__c
                                     FROM Purchase_Order__c
                                     WHERE Name =:  PONameToSearch
                                    ];
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No PO matching [' + PONameToSearch + '] was found, try again'));
                return null;
            }
        }
        if(this.purchaseOrder == NULL){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No PO matching [' + PONameToSearch + '] was found, try again'));
            return null; //Exit
        }
        //confirm the PO meets the necessary requirements
        system.debug('purchaseOrder.Vendor_Account__c & vendorInvoice.Vendor__c & purchaseOrder.Order_Status__c = ' + purchaseOrder.Vendor_Account__c + ' *** ' + vendorInvoice.Vendor__c + ' *** ' + purchaseOrder.Order_Status__c);
        if(purchaseOrder.Vendor_Account__c != vendorInvoice.Vendor__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Vendor on the VI and on the selected PO do not match'));
        } else if(purchaseOrder.Order_Status__c != 'Vendor Notified' && purchaseOrder.Order_Status__c != 'Vendor Invoice Generated'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This PO has an Invalid PO Status. Expected [Vendor Notified || Vendor Invoice Generated]'));
        } else if(purchaseOrder.Count_PO_Line_Items__c > 0 && purchaseOrder.Count_PO_Line_Items_Open__c > 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This PO does not have any valid PO Lines for adding to the VI'));
        } else
        {
            //get PO Line Items
            getItems();
        }
        
        return null;
    }
    
    private Integer getCountSelectedRows(){
        CountSelectedRows = 0;
        if(wrpPOLI != NULL && wrpPOLI.size() > 0){
            for(POLItem wrpItem : wrpPOLI){
                if(wrpItem.selectedRecord == TRUE){
                    CountSelectedRows = CountSelectedRows + 1;
                }
            }
        }
        return CountSelectedRows;
    }
    
    public PageReference AddPOLIToVI(){
        //Method to add POLI to VI from the AddPOLIToVI page if at least one row selected
        if(wrpPOLI != NULL && wrpPOLI.size() > 0 && getCountSelectedRows() > 0){ 
            //get VI and PO
            if(purchaseOrder != NULL && String.isNotBlank(viGUID) == TRUE){
                try{
                    //Check if a VIPO for the given PO exists
                    AggregateResult ag = [SELECT COUNT(Name) RecordCount FROM Vendor_Invoice_PO__c WHERE Purchase_Order__c =: purchaseOrder.id AND Vendor_Invoice__c =: viGUID];
                    
                    Vendor_Invoice_PO__c viPO = new Vendor_Invoice_PO__c();
                    //if VIPO not existing, add
                    if(ag == NULL || ag.get('RecordCount') == 0){
                        viPO.Purchase_Order__c = purchaseOrder.Id;
                        viPO.Vendor_Invoice__c = viGUID;
                        
                        INSERT viPO;
                    }
                    //Loop through the list and add VIPOLI and VII
                    //List <Purchase_Order_Line_Item__c>lst = new List <Purchase_Order_Line_Item__c> ;
                    List<Vendor_Invoice_Purchase_Order_Line_Item__c> viPOLIToSave = new List<Vendor_Invoice_Purchase_Order_Line_Item__c>();
                    List<Vendor_Invoice_Items__c> viiToSave = new List<Vendor_Invoice_Items__c>();
                    for(POLItem wrpItem : wrpPOLI){
                        if(wrpItem.selectedRecord == TRUE){
                            //Save VIPOLI
                            Vendor_Invoice_Purchase_Order_Line_Item__c viPOLI =  new Vendor_Invoice_Purchase_Order_Line_Item__c (
                                Vendor_Invoice__c = viGUID,
                                Purchase_Order_Line_Item__c = wrpItem.poli.Id,
                                Requested_Quantity__c = wrpItem.poli.Quantity_Requested__c,
                                Total_Cost__c = (wrpItem.poli.Quantity_Remaining__c * (wrpItem.poli.Unit_Net_Price__c + wrpItem.poli.VAT_Amount__c))
                            );
                            INSERT viPOLI;
                            
                            //add VII
                            Vendor_Invoice_Items__c vii = new Vendor_Invoice_Items__c (
                                Vendor_Invoice__c = viGUID,
                                Purchase_Order_Line_Item__c = wrpItem.poli.Id,
                                Vendor_Invoice_Purchase_Order_Line_Item__c = viPOLI.Id,
                                Quantity__c = wrpItem.poli.Quantity_Remaining__c,
                                Accepted_Receive_Quantity__c = 0.00, 
                                Total_Cost__c = (wrpItem.poli.Quantity_Remaining__c * (wrpItem.poli.Unit_Net_Price__c + wrpItem.poli.VAT_Amount__c)),
                                Company__c = wrpItem.poli.Requesting_Company__c,
                                Status__c = 'Open'
                            );
                            INSERT vii;
                            //Update PO Line Item
                            wrpItem.poli.Invoice_Assigned__c = true;
                            UPDATE wrpItem.poli;
                        }
                    }
                    
                    purchaseOrder.Order_Status__c  = 'Vendor Invoice Generated';
                    purchaseOrder.Next_Step__c = 'VI Generated';
                    
                    purchaseOrder.Vendor_Invoice__c = viGUID;
                    UPDATE purchaseOrder;
                    system.debug('POID'+ purchaseOrder.Id);    
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records successfully updated'));
                }
                catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                    system.debug('Error MEssage = ' + e.getMessage());
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A valid PO or VI has not been applied.'));
            }
        } 
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No rows have been selected for processing'));
        } 
        return null;
    }
     // POLI wrapper class
    public class POLItem{        
		public Purchase_Order_Line_Item__c poli {get; set;}
		public Boolean selectedRecord {get; set;}
       
		//Constructor
		public POLItem(Purchase_Order_Line_Item__c p) {
			poli = p;
            selectedRecord = false;
        }
    }
    
    public void selectAllRecords() {
        if(wrpPOLI != null){
            for(POLItem item : wrpPOLI){
                item.selectedRecord = true;                            
            }
        }               
    }  
    
    public void unSelectAllRecords() {
        if(wrpPOLI != null){
            for(POLItem item : wrpPOLI){
                item.selectedRecord = false;                            
            }
        }               
    } 
}