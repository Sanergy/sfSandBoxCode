public class NotifyQHSEController {
    
    private ApexPages.StandardController standardController;
    private Vendor_Invoice__c invoice;
    private List<ItemWrapper> items {get; set;}
    
    public NotifyQHSEController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.invoice = (Vendor_Invoice__c)standardController.getRecord();
        getItems();
    }
    
    public List<ItemWrapper> getItems() {
        system.debug('Time Now = ' + datetime.now());
        items= new List<ItemWrapper>();
        
        List<Vendor_Invoice_Items__c> lineItems = [Select Id, Name,Company__c, Item_Description__c, Vendor_Invoice__c,
                                                   Quantity__c, Total_Received__c, Receive_Location__c,
                                                   Receive_Batch__c, Inventory_UOM__c, Purchase_UOM__c, 
                                                   Receive_Quantity__c, Closed__c, Item_Unit_Price__c,
                                                   Requires_Batch__c, Inventory_Item__c, Complete_Order__c, 
                                                   Dimension_1__c, Dimension_2__c, Dimension_3__c, Dimension_4__c,
                                                   Rejected_Quantity__c,
                                                   Purchase_Order_Line_Item__c,Invoice_Assigned__c,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.name,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Location__c, 
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Lot__c,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Group__c,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Name,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Type__c,
                                                   Accepted_Receive_Quantity__c,Status__c,Vendor_Invoice__r.Name,
                                                   Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Inventory_UoM__r.Name
                                                   From Vendor_Invoice_Items__c
                                                   WHERE Vendor_Invoice__c = :invoice.Id 
                                                   AND Status__c = 'Open' 
                                                   AND Closed__c = false
                                                  ];
        
        system.debug('lineItems'+ lineItems);
        for(Vendor_Invoice_Items__c lineItem : lineItems){
            ItemWrapper itm = new ItemWrapper(lineItem);
            items.add(itm);
            system.debug('items'+ itm);
        }
        
        return items;
    }
    public PageReference test() {
        selectAll(); 
        unselectAll();
        return null;
    }
       
    public PageReference receiveToInventory(){
        //update status to Pending GIGO Check
        if(items != null && items.size() > 0){
            integer received = 0;
            
            for(ItemWrapper item : items){
                if(item.selected == true){
                    item.item.Status__c = 'Pending GIGO Check';
                    update item.item;
                    received = received + 1;
                }
            }
            if(received >  0){
                //notify no items, remain on same page
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Selected records succesfully updated'));
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No records were updated'));
            }
        } else
        {
            //notify no items, remain on same page
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are no items to update'));
        }
        return null;
    }
    
    public class ItemWrapper{
        public Boolean selected {get; set;}
        public Vendor_Invoice_Items__c item {get; set;}
        
        public ItemWrapper(Vendor_Invoice_Items__c itm) {
            item = itm;
        }
    }
    
    public void selectAll() {
        if(items != null){
            for(ItemWrapper lg:items){
                lg.selected = true;     
            }
        }
    }
    
    public void unselectAll() {
        if(items != null){
            for(ItemWrapper lg:items){
                lg.selected = false;                
            }
        }
    }    
}