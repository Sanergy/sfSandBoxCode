public class CreatePINFromVendorInvoice {
    
    private ApexPages.StandardController standardController;
    public Vendor_Invoice__c invoice;
    public List<ItemWrapper> items {get; set;}
    private c2g__codaAccountingCurrency__c cur; 
    public String companyName {get; set;}
    private String companyNameInitials {get; set;}
    private Map<Integer, id> taxcodeMap;
    
    public CreatePINFromVendorInvoice(ApexPages.StandardController standardController){
        
        this.standardController = standardController;
        this.invoice = (Vendor_Invoice__c)standardController.getRecord();
        /*
         * THIS CLASS HAS BEEN REDONE IN VendorInvoiceMapping Class
        this.invoice = [SELECT Name,Total_Invoice_Cost_del__c, Vendor__c, Currency_Config_Currency__r.name
                        FROM Vendor_Invoice__c
                        WHERE id = :invoice.id];
        
        this.companyName ='';
        items = new List<ItemWrapper>();
        String MANY_CURRENT_COMPANY_EXCEPTION = 'Please switch to only one company before proceeding';
        Id currentUserCompany = null;
        List<c2g__codaCompany__c > currentCompanyList = [SELECT Id, name, Company_Initials__c   FROM c2g__codaCompany__c
                                                         WHERE OwnerId IN (SELECT GroupId FROM GroupMember WHERE userorgroupid = :UserInfo.getUserId())];
        
        if (currentCompanyList != null && currentCompanyList.size() == 1) {
            
            currentUserCompany = currentCompanyList.get(0).Id;
            this.companyName=  currentCompanyList .get(0).Name;
            this.companyNameInitials  = currentCompanyList.get(0).Company_Initials__c;
            
            List<Vendor_Invoice_Items__c> viItems= [SELECT id,name, Closed__c, Received_Value__c, Company__c, Company__r.Name, Purchase_Order_Line_Item__r.Dimension_1__c, 
                                                    Purchase_Order_Line_Item__r.Dimension_2__c, Purchase_Order_Line_Item__r.Dimension_3__c, Purchase_Order_Line_Item__r.Item__c,
                                                    Purchase_Order_Line_Item__r.Dimension_4__c,Purchase_Order_Line_Item__r.Name , Purchase_Order_Line_Item__r.Vatable__c,
                                                    Vendor_Invoice__c, Item_Description__c,Pin_Created__c, Purchase_Order_Line_Item__r.VAT_Percentage__c,
                                                    Purchase_Order_Line_Item__c, Quantity__c, Receive_Batch__c, Receive_Location__c, Receive_Quantity__c, 
                                                    Total_Cost__c,
                                                    Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Group__c
                                                    FROM Vendor_Invoice_Items__c
                                                    WHERE Vendor_Invoice__c =: this.invoice.id 
                                                    AND Pin_Created__c=false
                                                    AND Company__r.name=: currentCompanyList.get(0).name
                                                   ];
            
            if(viItems.size()>0) {
                
                System.debug('Currency Name : '+invoice.Currency_Config_Currency__r.Name);
                System.debug('Company : '+viItems.get(0).Company__c);
                    
                this.cur = [SELECT Name, Id, FFA_Config_Company__c FROM c2g__codaAccountingCurrency__c 
                            WHERE Name =: invoice.Currency_Config_Currency__r.Name
                            AND FFA_Config_Company__c =: viItems.get(0).Company__c];
                
                for(Vendor_Invoice_Items__c itms : viItems){
                    ItemWrapper wrapper=new ItemWrapper(itms);
                    items.add(wrapper);
                }
                
            } else {
                //no items in current company
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'There are no items for your current company' ));
            }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,MANY_CURRENT_COMPANY_EXCEPTION ));
        }
*/
    }
    
    public PageReference CreatePINFromVendorInvoice(){
        /*
        if(items != null && items.size() > 0){
            
            Vendor_Invoice__c vi=[SELECT Vendor__c,Invoice_Number__c
                                  FROM Vendor_Invoice__c
                                  WHERE id=:this.invoice.id];
            integer selected = 0;
            
             //create a pin
             c2g__codaPurchaseInvoice__c PIN=new c2g__codaPurchaseInvoice__c(
                c2g__Account__c=vi.Vendor__c,
                c2g__InvoiceDate__c=Date.Today(),
                c2g__DueDate__c=Date.Today()+7,
                c2g__AccountInvoiceNumber__c=vi.Invoice_Number__c,
                c2g__InvoiceCurrency__c=this.cur.id
             );
            
            insert pin;
            
            //list of PIN Items
            List<c2g__codaPurchaseInvoiceExpenseLineItem__c> pinLineList=new List<c2g__codaPurchaseInvoiceExpenseLineItem__c>();
            List<Vendor_Invoice_Items__c> viList=new List<Vendor_Invoice_Items__c>();
            
            for(ItemWrapper item : items){
                
                item.item.Pin_Created__c=true;
                viList.add(item.item);
                     
                //List to hold new PIN Line Items
                List<String> idStr = new List<String>();
                                        
                //loop through INVOICE invoiceLine line items and create array of strings
                
                idStr.add(item.item.Purchase_Order_Line_Item__r.Dimension_4__c);
                idStr.add(item.item.Purchase_Order_Line_Item__r.Dimension_2__c);
                idStr.add(item.item.Purchase_Order_Line_Item__r.Dimension_1__c);
                idStr.add(item.item.Purchase_Order_Line_Item__r.Dimension_3__c);                        
                                                
                List<FFA_Config_Object__c> ECO = [SELECT ID,lookup_ID__c FROM FFA_Config_Object__c WHERE ID IN :idStr];
                
                //Create a map of the records
                Map<String, String> ECO_Map=new Map<String, String>();
                
                for(FFA_Config_Object__c ecoLine:ECO){
                    ECO_Map.put(ecoLine.ID, ecoLine.lookup_ID__c);
                }
                        
                //loop through INVOICE Line items and create corresponding line items
                
                String Location = ECO_Map.get(item.item.Purchase_Order_Line_Item__r.Dimension_2__c);
                String Department = ECO_Map.get(item.item.Purchase_Order_Line_Item__r.Dimension_1__c);
                String dim3 = ECO_Map.get(item.item.Purchase_Order_Line_Item__r.Dimension_3__c);
                String GrantFunding = ECO_Map.get(item.item.Purchase_Order_Line_Item__r.Dimension_4__c);
                
                List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                               FROM Group_Details__c
                                               WHERE Inventory_Item_Group__c = :item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Group__c
                                               AND Transaction_ID__c = 'PORCPT'
                                               AND Is_GL_Account__c = true
                                              ];
                
                Group_Details__c creditGl = null;
                Group_Details__c debitGl = null;
                
                for(Group_Details__c gla : glas){
                    if(gla.Credit_Debit__c == 'Credit'){
                        creditGl = gla;
                    } else if(gla.Credit_Debit__c == 'Debit'){
                        debitGl = gla;
                    }
                }
                
                c2g__codaPurchaseInvoiceExpenseLineItem__c pinLine = new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                    c2g__PurchaseInvoice__c = pin.id,
                    c2g__GeneralLedgerAccount__c = creditGl.Config_Account__r.Lookup_Id__c,
                    ffap__SetGLAToDefault__c = false,
                    c2g__NetValue__c = item.item.Received_Value__c,
                    ffap__SetTaxCodeToDefault__c = false,
                    ffap__CalculateTaxValueFromRate__c = true,
                    ffap__DeriveTaxRateFromCode__c = true,
                    c2g__Dimension1__c = Department,
                    c2g__Dimension2__c = Location,
                    c2g__Dimension3__c = dim3,
                    c2g__Dimension4__c = GrantFunding
                );
                
                pinLineList.add(pinLine);
            }
            
            insert pinLineList;
            
            Vendor_Invoice_PINs__c vips=new Vendor_Invoice_PINs__c(
                Vendor_Invoice__c=this.invoice.id,
                PIN__c=pin.id
            );
            
            insert vips;            
            update viList;
            
            return new PageReference('/'+pin.id);
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This Vendor Invoice has no items for your current company.' ));
            return null;
        }
*/
        RETURN NULL;
    }
    
    public class ItemWrapper{
        public Vendor_Invoice_Items__c item {get; set;}
           
        public ItemWrapper(Vendor_Invoice_Items__c itm) {
            item = itm;
        }
    } 
}