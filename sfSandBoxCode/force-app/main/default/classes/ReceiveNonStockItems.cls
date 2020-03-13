public class ReceiveNonStockItems {
    
    private ApexPages.StandardController standardController;
    private Vendor_Invoice__c invoice;
    public  List<Vendor_Invoice_Items__c> lineItems;
    private List<ItemWrapper> items {get; set;}
    Set<String> poList = new Set<String> ();
    
    
    public ReceiveNonStockItems(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.invoice = (Vendor_Invoice__c)standardController.getRecord();
        system.debug('Invoice' + invoice);
    }
    
    public List<ItemWrapper> getItems() {
        
        if(items == null) {
            items= new List<ItemWrapper>();
            
            lineItems = [Select Id, Name,Company__c, Vendor_Invoice__r.Vendor__c, 
                         Vendor_Invoice__r.Vendor__r.Name,Item_Description__c, 
                         Quantity__c, Total_Received__c, Receive_Location__c,
                         Receive_Batch__c, Inventory_UOM__c, Purchase_UOM__c, 
                         Receive_Quantity__c, Closed__c, Item_Unit_Price__c,Rejected_Quantity__c,
                         Requires_Batch__c, Inventory_Item__c, Complete_Order__c, 
                         Dimension_1__c, Dimension_2__c, Dimension_3__c, Dimension_4__c,
                         Purchase_Order_Line_Item__c,Invoice_Assigned__c,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.name,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Net_VAT__c,
                         Purchase_Order_Line_Item__r.Po_line_Receipt_Status__c,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Location__c, 
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Lot__c,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Group__c,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Name,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Type__c,
                         Purchase_Order_Line_Item__r.GLA__r.Lookup_Id__c,Purchase_Order_Line_Item__r.GLA__c,
                         Purchase_Order_Line_Item__r.Total_Price__c,
                         Purchase_Order_Line_Item__r.Dimension_1__r.Lookup_Id__c, Purchase_Order_Line_Item__r.Dimension_2__r.Lookup_Id__c,
                         Purchase_Order_Line_Item__r.Dimension_3__r.Lookup_Id__c, Purchase_Order_Line_Item__r.Dimension_4__r.Lookup_Id__c,
                         Accepted_Receive_Quantity__c,QHSE__c,Purchase_Order_Line_Item__r.Unit_Net_Price__c,
                         Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Inventory_UoM__r.Name
                         From Vendor_Invoice_Items__c
                         WHERE Vendor_Invoice__c = :invoice.Id
                         AND Accepted_Receive_Quantity__c = 0
                         AND Purchase_Order_Line_Item__r.Po_line_Receipt_Status__c != 'All items Received'
                         AND QHSE__c = false
                         
                        ]; 
            system.debug('Here' + lineItems);
            
            for(Vendor_Invoice_Items__c lineItem : lineItems){
                lineItem.Accepted_Receive_Quantity__c = lineItem.Receive_Quantity__c;
                
                ItemWrapper itm = new ItemWrapper(lineItem);
                items.add(itm);
            }                            
        }
        return items;
    }
    
    public PageReference verifyItems(){           
        Integer count=0;
        update lineItems;
        
        system.debug('lineItems' + lineItems);
        system.debug('items' + items);
        
        for(ItemWrapper lw : items){
            
            if(lw.selected=true){
                
                Decimal conversionFactor = lw.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c;
                
                if(lw.item.Accepted_Receive_Quantity__c <= lw.item.Quantity__c){
                    if(conversionFactor != null && conversionFactor > 0){
                        count++;
                        lw.inventoryQuantity = lw.item.Accepted_Receive_Quantity__c * conversionFactor;
                        lw.invUnitPrice = lw.item.Purchase_Order_Line_Item__r.Unit_Net_Price__c / conversionFactor;
                    } else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'One or more items are missing the conversion factor'));
                        return null;
                    }
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'invalid Receive Quantity for item ' + lw.item.Name));
                    return null;
                }
            }
        }
        
        if(count > 0){
            return Page.VerifyReceiveNonStockItems;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have to set the quantity to receive for at least one Item'));
            return null;
        } 
    }
    
    public PageReference receiveToInventory(){   
        if(items != null && items.size() > 0){
            integer received = 0;
            
            for(ItemWrapper item : items){
                item.item.Receive_Quantity__c = item.item.Accepted_Receive_Quantity__c;
                
                String itemType = item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Item_Type__c;
                system.debug('itemType' + itemType);
                system.debug('Receive_Quantity'+ item.item.Receive_Quantity__c);
                if(itemType != null  && item.item.Receive_Quantity__c != null && item.item.Receive_Quantity__c > 0){
                    Double conversionFactor = item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c;
                    system.debug('conversionFactor' + conversionFactor);
                    if(conversionFactor != null && conversionFactor > 0 && item.item.Inventory_Item__c != null) {
                        
                        String transactionId = null;
                        
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
                        
                        if((itemType != 'Stock' && item.site != 'NA') || (debitGl != null && creditGl != null && item.site != 'NA')){
                            
                            String location =  item.location == null ? 'NA' : item.location;
                            String lotId = item.lot == null ? 'NA' : item.lot;
                            
                            if(location == 'NA' && item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Location__c != null){
                                
                                List<Inventory_Item_Location__c> locs = [SELECT Id, Name FROM Inventory_Item_Location__c
                                                                         WHERE Inventory_Item__c = :item.item.Inventory_Item__c
                                                                         AND Location_Name__c = :item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Location__c
                                                                         AND Location__c = :item.site
                                                                        ];
                                
                                if(locs.size() > 0){
                                    location = locs.get(0).Id;
                                } else{
                                    Inventory_Item_Location__c loc =new Inventory_Item_Location__c(
                                        Inventory_Item__c = item.item.Inventory_Item__c,
                                        Location_Name__c = item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Location__c,
                                        Location__c = item.site
                                    );
                                    insert loc;
                                    location = loc.Id;
                                }
                            }
                            
                            if(lotId == 'NA' && location != 'NA' && item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Lot__c != null){
                                List<Item_Location_Lot__c> lots = [SELECT Id, Name FROM Item_Location_Lot__c
                                                                   WHERE Lot_Name__c = :item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Lot__c
                                                                   AND Item_Location__c = :location
                                                                  ];
                                
                                if(lots.size() > 0){
                                    lotId = lots.get(0).Id;
                                } else{
                                    Item_Location_Lot__c lot =new Item_Location_Lot__c(
                                        Item_Location__c = location,
                                        Lot_Name__c = item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Default_Receive_Lot__c,
                                        Quantity__c = 0
                                    );
                                    insert lot;
                                    lotId = lot.Id;
                                }
                            }
                            
                            if(location != 'NA' && lotId != 'NA'){
                                Inventory_Transaction__c trans = new Inventory_Transaction__c(
                                    Item__c = item.item.Inventory_Item__c,
                                    Transaction_ID__c = 'PORCPT',
                                    Location__c = location,
                                    Location_Lot__c = lotId,
                                    Transaction_Quantity__c = item.inventoryQuantity,
                                    Item_Unit_Price__c = item.invUnitPrice,
                                    VAT_Amount__c = item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Net_VAT__c,
                                    Quantity_Impact__c = 'I',
                                    Document_Value__c = item.item.Purchase_Order_Line_Item__r.Total_Price__c,
                                    Debit_Account__c = item.POGla,
                                    Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c,
                                    Dimension_1__c = item.PODIM1,
                                    Dimension_2__c = item.PODIM2,
                                    Dimension_3__c = item.PODIM3,
                                    Dimension_4__c = item.PODIM4,
                                    Comments__c = item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Name,
                                    Purchase_Order_Line__c = item.item.Purchase_Order_Line_Item__c,
                                    Vendor_Invoice__c = invoice.Id,
                                    Vendor_Account__c = item.item.Vendor_Invoice__r.Vendor__c
                                );
                                
                                insert trans;
                                
                                transactionId = trans.Id;
                            }else {
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item is missing the default receive location and or Lot');
                                ApexPages.addmessage(msg);
                                return null;
                            }
                        } else {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts');
                            ApexPages.addmessage(msg);
                            return null;
                        }
                        
                        if(transactionId != null){
                            List<Purchase_Order_Line_Item__c> poItems = [SELECT Id, Name, Status__c, Quantity_Accepted__c, Invoice_Assigned__c,Notes__c,
                                                                         Purchase_Order__c,Quantity_Requested__c,Quantity_Remaining__c,
                                                                         Unit_Net_Price__c, VAT_Amount__c,PTS_Line_Item__r.Status__c,PTS_Line_Item__c,PTS_Line_Item__r.Name
                                                                         FROM Purchase_Order_Line_Item__c
                                                                         WHERE Id = :item.item.Purchase_Order_Line_Item__c
                                                                        ];
                            if(poItems.size() > 0){
                                for(Purchase_Order_Line_Item__c poItem:poItems){
                                    Double totalAccepted = (item.item.Total_Received__c == null ? 0 : item.item.Total_Received__c) + item.item.Receive_Quantity__c;
                                    
                                    //Purchase_Order_Line_Item__c poItem = poItems.get(0);
                                    
                                    poItem.Quantity_Accepted__c = totalAccepted;
                                    poItem.Invoice_Assigned__c = false;
                                    
                                    //GET the procurement  Request  from the purchase order                        
                                    PTS_Line_Item__c ptItems = [SELECT Id, Name, Status__c,Comments__c
                                                                FROM PTS_Line_Item__c
                                                                WHERE Id =: poItem.PTS_Line_Item__r.Id
                                                                LIMIT 1
                                                               ];                                 
                                    //Update the status for the PO and PR dependiong on the quantity that has been accepted.       
                                    system.debug('ITEMS' + poItem);
                                    if(poItem.Quantity_Requested__c == poItem.Quantity_Accepted__c && poItem.Quantity_Remaining__c == 0.00 || item.item.Complete_Order__c == true){
                                        item.item.Complete_Order__c = true;
                                        ptItems.Status__c = 'Received';  
                                        poItem.Status__c = 'All items Received';
                                        
                                    }
                                    
                                    else if(poItem.Quantity_Requested__c != poItem.Quantity_Accepted__c && poItem.Quantity_Remaining__c > 0.00 && poItem.Quantity_Accepted__c != 0.00)
                                    {
                                        poItem.Status__c = 'Items Partially Received';
                                        poItem.Notes__c = 'Items Partially Received ' + poItem.Notes__c;
                                        ptItems.Comments__c = 'xx';  
                                    }
                                    
                                    //Do the actual update
                                    update poItem;
                                    update ptItems; 
                                    
                                    item.item.Closed__c = true;
                                    item.item.Receipt_Unit_Gross_Value__c = poItem.Unit_Net_Price__c + poItem.VAT_Amount__c;
                                    item.item.Receipt_Unit_Net_Value__c = poItem.Unit_Net_Price__c;
                                    item.item.Receipt_Unit_Tax_Value__c = poItem.VAT_Amount__c;
                                    item.item.Total_Cost__c = ((poItem.Unit_Net_Price__c + poItem.VAT_Amount__c) * item.item.Receive_Quantity__c);
                                    
                                    update item.item;
                                } 
                            }
                            received +=1;
                        }                        
                    }
                    
                    else{
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'UOM conversion factor for Purchase Order Item [' + item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.name + '] has not been set.');
                        ApexPages.addmessage(msg);
                    }   
                } else {
                    if(itemType == null){
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Item Type is not set for inventory Item [' + item.item.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Name + '] Update item before proceeding'));
                    }
                }
            }
            
            if(received > 0){
                return new PageReference('/' + invoice.Id); 
            } else {
                List<Vendor_Invoice_Items__c> VIILst = new List<Vendor_Invoice_Items__c>();
                for(ItemWrapper itm : items){
                    itm.item.Accepted_Receive_Quantity__c = 0.00;
                    VIILst.add(itm.item);
                }
                update VIILst;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Items were Received')); 
                return null;
            }
        }
        return null;
    }
    /* public PageReference testa(){
getItems();
return null;
}  */
    
    public class ItemWrapper{
        public boolean selected {get; set;}
        public Vendor_Invoice_Items__c item {get; set;}
        public String site {get; set;}
        public String siteName {get; set;}
        public String location {get; set;}
        public String locationName {get; set;}
        public String lot {get; set;}
        public String lotName {get; set;}
        public List<SelectOption> sites {get; set;}
        public List<SelectOption> locations {get; set;}
        public List<SelectOption> lots {get; set;}
        public String inventoryUom {get; set;}
        public Decimal inventoryQuantity {get; set;}
        public Decimal invUnitPrice {get; set;}
        public String POGla{get; set;}
        public String PODIM1{get; set;}
        public String PODIM2{get; set;}
        public String PODIM3{get; set;}
        public String PODIM4{get; set;}
        
        public ItemWrapper(Vendor_Invoice_Items__c itm) {
            item = itm;
            inventoryUom = itm.Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Inventory_Item__r.Inventory_UoM__r.Name;
            POGla = itm.Purchase_Order_Line_Item__r.GLA__r.Lookup_Id__c;
            PODIM1 = itm.Purchase_Order_Line_Item__r.Dimension_1__r.Lookup_Id__c;
            PODIM2 = itm.Purchase_Order_Line_Item__r.Dimension_2__r.Lookup_Id__c;
            PODIM3 = itm.Purchase_Order_Line_Item__r.Dimension_3__r.Lookup_Id__c;
            PODIM4 = itm.Purchase_Order_Line_Item__r.Dimension_4__r.Lookup_Id__c;
            itm.Receive_Quantity__c = itm.Accepted_Receive_Quantity__c;
            sites= new List<SelectOption>();
            SelectOption defopt = new SelectOption('NA', '----------');
            sites.add(defopt);
            
            List<Inventory_Location__c> locations = [Select Id, Name, Description__c
                                                     From Inventory_Location__c
                                                    ];
            for(Inventory_Location__c location : locations){
                SelectOption option = new SelectOption(location.Id, location.Name);
                sites.add(option);
            }
        }
        
        public void setLocations() {
            locations = new List<SelectOption>();
            SelectOption defopt = new SelectOption('NA', '----------');
            locations.add(defopt);
            
            if(site != null && !site.equals('NA')){
                
                for(SelectOption s : sites){                    
                    if(s.getValue()  == site){
                        siteName = s.getLabel();
                        break;
                    }
                }
                
                List<Inventory_Item_Location__c> locs = [Select Id, Name
                                                         From Inventory_Item_Location__c
                                                         WHERE Inventory_Item__c = :this.item.Inventory_Item__c
                                                         AND Location__c = :this.site
                                                        ];
                
                for(Inventory_Item_Location__c location : locs){
                    SelectOption option = new SelectOption(location.Id, location.Name);
                    locations.add(option);
                }
            }
        }
        
        public void setLots() {
            
            for(SelectOption l : locations){                    
                if(l.getValue()  == location){
                    locationName = l.getLabel();
                    break;
                }
            }
            
            lots = new List<SelectOption>();
            SelectOption defopt = new SelectOption('NA', '----------');
            lots.add(defopt);
            
            if(location != null && !location.equals('NA')){
                List<Item_Location_Lot__c> lts = [Select Id, Name
                                                  From Item_Location_Lot__c
                                                  WHERE Item_Location__c = :this.location
                                                 ];
                
                for(Item_Location_Lot__c lot : lts){
                    SelectOption option = new SelectOption(lot.Id, lot.Name);
                    lots.add(option);
                }
            }
        }
        
        public void setLotName() {
            
            for(SelectOption l : lots){                    
                if(l.getValue()  == lot){
                    lotName = l.getLabel();
                    break;
                }
            }
        }
        public void a(){
            
        }
    }
    
}