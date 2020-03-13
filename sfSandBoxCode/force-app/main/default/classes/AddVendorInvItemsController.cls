public class AddVendorInvItemsController{
    
    private ApexPages.StandardController standardController;
    private Vendor_Invoice__c invoice;
    private List<ItemWrapper> items {get; set;}
    
    public AddVendorInvItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.invoice = (Vendor_Invoice__c)standardController.getRecord();
    }
    
    public List<ItemWrapper> getItems() {
        
        if(items == null) {
            
            items = new List<ItemWrapper>();
            
            /* List<Vendor_Invoice_PO__c> vendorInvoices = [SELECT Id, Name, Purchase_Order__c
FROM Vendor_Invoice_PO__c
WHERE Vendor_Invoice__c = :invoice.Id
];*/
            List<Vendor_Invoice_Purchase_Order_Line_Item__c> vendorInvoicesPOline = [SELECT Vendor_Invoice__c,	Purchase_Order_Line_Item__c,
                                                                                     Total_Cost__c,Requested_Quantity__c
                                                                                     FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                                                                     WHERE Vendor_Invoice__c = :invoice.Id
                                                                                    ];
            List<String> poIds = new List<String>();
            
            /*for(Vendor_Invoice_PO__c vendorInvoice: vendorInvoices){
poIds.add(vendorInvoice.Purchase_Order__c);
}*/
            for(Vendor_Invoice_Purchase_Order_Line_Item__c vendorInvoice: vendorInvoicesPOline){
                poIds.add(vendorInvoice.Purchase_Order_Line_Item__c);
            }
            System.debug('poIds = ' + poIds);
            System.debug('poIds = ' + poIds);            
            if(poIds.size() > 0){
                
                List<Purchase_Order_Line_Item__c> lineItems = [Select Id, Name, Purchase_Order_Item__r.Name, Quantity_Requested__c,
                                                               Quantity_Remaining__c, Requesting_Company__r.Name,Po_line_Receipt_Status__c,
                                                               Unit_Net_Price__c, VAT_Amount__c
                                                               From Purchase_Order_Line_Item__c
                                                               WHERE ID IN : poIds 
                                                               AND (Status__c = 'Open'
                                                                    OR  Po_line_Receipt_Status__c = 'Items Partially Received')
                                                               AND Invoice_Assigned__c = false
                                                               AND Purchase_Order__r.Approved__c = true
                                                              ];
             system.debug('LineItems' + lineItems);   
                for(Purchase_Order_Line_Item__c lineItem : lineItems){
                    ItemWrapper wrapper = new ItemWrapper(lineItem);
                    items.add(wrapper);
                }
            }
        }
        return items;
    }
    
    public PageReference selectAll() {
        if(items!=null){
            for(ItemWrapper lg:items){
                lg.selected=true;
                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(items!=null){
            for(ItemWrapper lg:items){
                lg.selected=false; 
            }
        }        
        return null;
    }
    
    public PageReference addInvoiceItems(){
        
        if(items != null && items.size() > 0){
            
            integer selected = 0;
            
            for(ItemWrapper item : items){
                Vendor_Invoice_Purchase_Order_Line_Item__c vipo = [SELECT ID,NAME,Purchase_Order_Line_Item__c
                                                                   FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                                                   WHERE Purchase_Order_Line_Item__c =: item.item.Id
                                                                  ];
                system.debug('vipo  '+ vipo);
                system.debug('item.item.Id  '+ item.item.Id);
                if(item.selected){
                    
                      Vendor_Invoice_Items__c invoiceLine = new Vendor_Invoice_Items__c(
                        Vendor_Invoice__c = invoice.Id,
                        Purchase_Order_Line_Item__c = item.item.Id,
                        Vendor_Invoice_Purchase_Order_Line_Item__c = vipo.Id,
                        Accepted_Receive_Quantity__c = 0.00,
                        Quantity__c = item.item.Quantity_Remaining__c,
                        Total_Cost__c = (item.item.Quantity_Remaining__c * (item.item.Unit_Net_Price__c + item.item.VAT_Amount__c)),
                        Company__c = item.item.Requesting_Company__c,
                        Status__c = 'Open'                                       
                        
                    ); 
                    
                    insert invoiceLine;
                    system.debug('invoiceLine   ' +invoiceLine); 
        
                    
                    item.item.Invoice_Assigned__c = true;
                    
                    update item.item;
                    
                    selected +=1;
                }
                system.debug('vipo.id   ' +vipo.Id );
                
                
                
                
            }
            
            if(selected > 0){
                return new PageReference('/' + invoice.Id);  
            } else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Items Were Added');
                ApexPages.addmessage(msg);
            }
        }
        return null;
    }
    
    public class ItemWrapper{
        public Purchase_Order_Line_Item__c item {get; set;}
        public Boolean selected {get; set;}
        
        public ItemWrapper(Purchase_Order_Line_Item__c itm) {
            item = itm;
            selected = true;
        }
    } 
}