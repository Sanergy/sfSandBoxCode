public class OpportunityShipController {
    
    @TestVisible  private ApexPages.StandardController standardController;
    @TestVisible  private Opportunity opportunity;
    @TestVisible public List<DeliveryNoteWrapper> wrpDeliveryItems {get; set;}
    Public List<ProductWrapper> products {get; set;}
    public List<Inventory_Transaction__c> invItems {get; set;}
    public OpportunityShipController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.opportunity = (Opportunity)standardController.getRecord();
        getProducts();
        getInvItemsForDeliveryNote();
        /*
this.opportunity = 
[
SELECT Id, Name, Account, CloseDate
FROM Opportunity
WHERE Id := opportunity.Id
];
*/
    }
    
    public PageReference selectAll() {
        if(products!=null){
            for(ProductWrapper prod : products){
                prod.selected=true;
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(products!=null){
            for(ProductWrapper prod : products){
                prod.selected=false;
            }
        }
        return null;
    }
    
    @TestVisible public List<ProductWrapper> getProducts() {
        if(products == null) {
            products= new List<ProductWrapper>();
            
            @TestVisible List<OpportunityLineItem> lineItems = 
                [
                    SELECT Id, Name, Inventory_Item_Location__c, Quantity,
                    UnitPrice, TotalPrice, Product2Id, Issued__c, Quantity_Shipped__c
                    From OpportunityLineItem
                    WHERE OpportunityId = :opportunity.Id AND Issued__c = false
                ];
            
            for(OpportunityLineItem lineItem : lineItems){
                ProductWrapper wrapper = new ProductWrapper(lineItem);
                products.add(wrapper);
            } 
        }
        return products;
    }
    
    public PageReference shipFromInventory(){
        if(products != null && products.size() > 0){
            integer selected = 0;
            
            for(ProductWrapper prod : products){
                if(prod.selected && !prod.product.Issued__c){
                    if(prod.product2 != null && prod.product2.Use_Inventory__c == true && prod.product2.Inventory_Product__c != null){
                        List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                       FROM Group_Details__c
                                                       WHERE Inventory_Item_Group__c = :prod.product2.Inventory_Product__r.Item_Group__c
                                                       AND Transaction_ID__c = 'SOSHIP'
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
                        
                        if(debitGl != null && creditGl != null){
                            @TestVisible Inventory_Transaction__c trans = new Inventory_Transaction__c(
                                Item__c = prod.product2.Inventory_Product__c,
                                Opportunity__C = opportunity.Id,
                                Transaction_ID__c = 'SOSHIP',
                                Location__c = prod.location,
                                Location_Lot__c = prod.lot,
                                Transaction_Quantity__c = prod.shipQuantity,
                                Item_Unit_Price__c = prod.product2.Inventory_Product__r.unit_cost__c,
                                Quantity_Impact__c = 'D',
                                Debit_Account__c = debitGl.Config_Account__r.Lookup_Id__c,
                                Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c,
                                Dimension_1__c = prod.product2.Inventory_Product__r.Item_Group__r.Dimension_1__r.lookup_ID__c,
                                Dimension_2__c = prod.product2.Inventory_Product__r.Item_Group__r.Dimension_2__r.lookup_ID__c,
                                Dimension_3__c = prod.product2.Inventory_Product__r.Item_Group__r.Dimension_3__r.lookup_ID__c,
                                Dimension_4__c = prod.product2.Inventory_Product__r.Item_Group__r.Dimension_4__r.lookup_ID__c,
                                Comments__c = opportunity.Name
                            );
                            
                            try{
                                insert trans;
                            }catch(Exception e){
                                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                                return null;
                            }
                            
                            prod.product.Quantity_Shipped__c += prod.shipQuantity;
                            if(prod.product.Quantity_Shipped__c == prod.product.Quantity){
                                prod.product.Issued__c = true;
                            }
                            
                            update prod.product;
                            
                            selected ++;
                        } else {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration does not have both credit and debit GL Accounts');
                            ApexPages.addmessage(msg);
                        }
                        
                    } else {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item is not an inventory item');
                        ApexPages.addmessage(msg);
                    }
                }
            }
            
            if(selected > 0){
                return new PageReference('/' + opportunity.Id);  
            } else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'None of the items selected were issued');
                ApexPages.addmessage(msg);
            }
        }
        return null;
    }
    
    public List<DeliveryNoteWrapper> getInvItemsForDeliveryNote(){
        //get Items that have been Issued to shipped
        wrpDeliveryItems = new List<DeliveryNoteWrapper>();
        invItems = new List<Inventory_Transaction__c>();
        invItems =
            [
                SELECT Id, Name, CreatedDate, Item__r.Name,Transaction_Quantity__c,Item__r.Inventory_UoM__r.Name
                FROM Inventory_Transaction__c
                WHERE Opportunity__C =: opportunity.Id
            ];
        system.debug('invItems = ' + invItems);
        Integer intCounter = 0;
        for(Inventory_Transaction__c item : invItems){
            intCounter = intCounter + 1;
            wrpDeliveryItems.add(new DeliveryNoteWrapper(intCounter, item));
        }
        return wrpDeliveryItems;
    }
    
    @TestVisible public List<SelectOption> getSites() {
        List<SelectOption> sites= new List<SelectOption>();
        SelectOption defopt = new SelectOption('NA', '----------');
        sites.add(defopt);
        
        @TestVisible List<Inventory_Location__c> locations = [Select Id, Name, Description__c
                                                              From Inventory_Location__c
                                                             ];
        for(Inventory_Location__c location : locations){
            SelectOption option = new SelectOption(location.Id, location.Name);
            sites.add(option);
        }
        
        return sites;
    }
    
    @TestVisible public class ProductWrapper{
        @TestVisible public OpportunityLineItem product {get; set;}
        @TestVisible public Product2 product2 {get; set;}
        @TestVisible public String site {get; set;}
        @TestVisible public String location {get; set;}
        @TestVisible public String lot {get; set;}
        @TestVisible public Item_Location_Lot__c selectedLot {get; set;}
        @TestVisible public Boolean selected {get; set;}
        @TestVisible public List<SelectOption> locations {get; set;}
        @TestVisible public List<SelectOption> lots {get; set;}
        @TestVisible public Decimal pendingQuantity {get; set;}
        @TestVisible public Decimal shipQuantity {get; set;}
        
        @TestVisible public ProductWrapper(OpportunityLineItem prod) {
            product = prod;
            selected = true;
            
            product2 = [SELECT Id, Name, Use_Inventory__c, Inventory_Product__c, Inventory_Product__r.Name,
                        Inventory_Product__r.unit_cost__c,Inventory_Product__r.Item_Group__c,
                        Inventory_Product__r.Item_Group__r.Dimension_1__r.lookup_ID__c,
                        Inventory_Product__r.Item_Group__r.Dimension_2__r.lookup_ID__c,
                        Inventory_Product__r.Item_Group__r.Dimension_3__r.lookup_ID__c,
                        Inventory_Product__r.Item_Group__r.Dimension_4__r.lookup_ID__c
                        FROM Product2
                        WHERE Id = :prod.Product2Id
                       ];
            
            if(prod.Quantity_Shipped__c == null){
                prod.Quantity_Shipped__c = 0;
            }    
            this.pendingQuantity = prod.Quantity - prod.Quantity_Shipped__c;            
            this.shipQuantity = this.pendingQuantity;
        }
        
        @TestVisible public void setLocations() {
            locations = new List<SelectOption>();
            SelectOption defopt = new SelectOption('NA', '----------');
            locations.add(defopt);
            
            if(site != null && !site.equals('NA')){
                List<Inventory_Item_Location__c> locs = [Select Id, Name
                                                         From Inventory_Item_Location__c
                                                         WHERE Inventory_Item__c = :this.product2.Inventory_Product__c
                                                         AND Location__c = :this.site
                                                        ];
                
                for(Inventory_Item_Location__c location : locs){
                    SelectOption option = new SelectOption(location.Id, location.Name);
                    locations.add(option);
                }
            }
        }
        
        @TestVisible public void setLots() {
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
        
        @TestVisible public void selectLot() {
            if(lot != null && !lot.equals('NA')){
                selectedLot = [Select Id, Name,Quantity__c
                               From Item_Location_Lot__c
                               WHERE id = :this.lot
                              ];
            }
        }
    }    
    
    public class DeliveryNoteWrapper{
        //Inventory Items to be delivered
        public Integer invItemIndex {get; set;}
        public Inventory_Transaction__c invItem {get; set;}
        public DeliveryNoteWrapper(Integer intIndex, Inventory_Transaction__c inv){
            invItemIndex = intIndex;
            invItem = inv;
        }
    }
}