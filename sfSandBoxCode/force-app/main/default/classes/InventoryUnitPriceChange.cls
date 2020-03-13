public class InventoryUnitPriceChange {
    //create standard controller
    private ApexPages.StandardController controller;
    
    private Inventory_Item__c inv{get;set;}
    private Inventory_Item_BOM__c invBom{get;set;}
    private List<WrapperItems>items{get;set;}
    public Decimal newPrice{get;set;}
    public String Comments{get;set;}
    private List<BOMWrapper>listBOMItems{get;set;}
    
    // Constructor
    public InventoryUnitPriceChange(ApexPages.StandardController controller){               
        this.controller = controller;
        inv = (Inventory_Item__c)controller.getRecord();
        

    }
    
    public List<WrapperItems> getItems(){
        items = new List<WrapperItems>();
        
        List<Inventory_Item__c> InventoryItems = [SELECT Id,Name, Item_Type__c,Inventory_Stock__c,Currency_Config__c,Currency_Config__r.Name,
                                                  Item_Company__c,Item_Company__r.lookup_ID__c,Item_Company__r.Name,Default_Site__c,unit_cost__c
                                                  FROM Inventory_Item__c
                                                  WHERE Id =:inv.Id
                                                 ];
        
        for(Inventory_Item__c itm: InventoryItems){
            WrapperItems itms = new WrapperItems(itm);
            items.add(itms);
            
        }
        
        system.debug('Items' + items); 
        getBom();
        return items; 
        
    }
    
    public List<BOMWrapper>getBom(){
        listBOMItems = new List<BOMWrapper>();
        
        List<Inventory_Item_BOM__c> listBOM =[SELECT Parent_Item__c,Parent_Item__r.Name,Parent_Item__r.Inventory_Stock__c,Parent_Item__r.unit_cost__c
                                              FROM Inventory_Item_BOM__c
                                              WHERE BOM_Item__c =: inv.ID
                                             ];
        
        for(Inventory_Item_BOM__c bom:listBOM){
           BOMWrapper bomwrap = new BOMWrapper(bom);
            listBOMItems.add(bomwrap);
        }
        return listBOMItems;
    }
    
    
    public pageReference CreateInventoryTransaction(){
        
        List<Inventory_Item_Location__c> ItemLocations = [Select id,Name,Inventory_Item__c	 
                                                          From Inventory_Item_Location__c 
                                                          WHERE Inventory_Item__c =: inv.id
                                                         ];
        
        List<Item_Location_Lot__c> ItemLoc = [SELECT ID,Name,Item_Location__c 
                                              FROM Item_Location_Lot__c 
                                              WHERE Item_Location__c =: ItemLocations.get(0).Id
                                             ];
        
        //Create  a Transaction when one tries to edit the unit value of an item 
        Inventory_Transaction__c trans = new Inventory_Transaction__c(
            Item__c = inv.id,
            Transaction_ID__c = 'UNITPRICECHANGE',
            Location__c = ItemLocations.get(0).Id,
            Location_Lot__c = ItemLoc.get(0).Id,
            Transaction_Quantity__c = 0.00,
            Item_Unit_Price__c = newPrice,
            Comments__c = Comments,
            Quantity_Impact__c = 'U'
        );
        insert trans;  
        system.debug('Transaction Created' + trans);
        
        return new PageReference('/' + inv.Id); 
    }
    
    public Class WrapperItems{
        public Inventory_Item__c item{get;set;}
        
        public WrapperItems(Inventory_Item__c itm){
            item = itm;
        }
    }
    
    public Class BOMWrapper{
        
        public Inventory_Item_BOM__c BomItem{get;set;}
        
        public BOMWrapper(Inventory_Item_BOM__c Bomitm){
            BomItem = Bomitm;
        }
    }
    
    
}