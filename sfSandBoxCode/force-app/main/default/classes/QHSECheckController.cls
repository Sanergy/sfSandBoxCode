public class QHSECheckController {
    
    private ApexPages.StandardController standardController;
    private Vendor_Invoice__c invoice;
    private List<ItemWrapper> items {get; set;}
    
    public QHSECheckController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.invoice = (Vendor_Invoice__c)standardController.getRecord();
    }
    
    public List<ItemWrapper> getItems() {
        
        if(items == null) {
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
                                                                    AND Status__c = 'Pending GIGO Check' 
                                                                    AND Invoice_Assigned__c = true 
                                                                    AND Closed__c = false
                                                                   ];
            
            for(Vendor_Invoice_Items__c lineItem : lineItems){
                ItemWrapper itm = new ItemWrapper(lineItem);
                items.add(itm);
            }
            
        }
        return items;
    }
    
    public PageReference selectAll() {
        if(items != null){
            for(ItemWrapper lg:items){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(items != null){
            for(ItemWrapper lg:items){
                lg.selected=false;                
            }
        }
        return null;
    }
  
    public PageReference receiveToInventory(){
        
        if(items != null && items.size() > 0){

            integer received = 0;
            
            for(ItemWrapper item : items){
                if(item.selected == true){
                    if(item.item.Accepted_Receive_Quantity__c <= item.item.Quantity__c){
                        item.item.Status__c = 'GIGO Checked';
                        update item.item;
                        received +=1;
                    }else {
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have exceeded the Pending Quantity')); 
                       return null;
                    }
              
                }
            }
            
            if(received > 0 ){
                return new PageReference('/' + invoice.Id); 
            } else {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Items were Received')); 
               return null;
            }
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
}