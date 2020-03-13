public class ProcessCountVarianceController{

    private ApexPages.StandardController standardController;
    private Inventory_Count__c inventoryCount;
    private List<CountWrapper> items {get; set;}

    public ProcessCountVarianceController(ApexPages.StandardController controller) {
        this.standardController = controller;
        this.inventoryCount = (Inventory_Count__c )standardController.getRecord();
    }
    
    public List<CountWrapper> getItems() {
        
        if(items == null) {
            items= new List<CountWrapper>();
            
            List<Item_Inventory_Count__c> counts = [Select Id, Name,Inventory_Item__c, Inventory_Stock__c, Physical_Count__c,
                                                    Quantity_Variance__c, UoM__c, Currency__c, Unit_Price__c, Stock_Value__c, 
                                                    Count_Value__c, Value_Variance__c, Item_Location__c, Item_Lot__c,
                                                    Inventory_Item__r.Name,
                                                    Inventory_Item__r.Item_Group__c
                                                    From Item_Inventory_Count__c
                                                    WHERE Inventory_Count__c = :inventoryCount.Id
                                                    AND Variance_Check__c >= 0
                                                    AND Processed__c = false
                                                   ];
            
            for(Item_Inventory_Count__c count : counts){
                CountWrapper itm = new CountWrapper(count);
                items.add(itm);
            }
        }
        return items;
    }
    
     public PageReference selectAll() {
         
        if(items != null){
            for(CountWrapper lg:items){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(items != null){
            for(CountWrapper lg:items){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    public PageReference updateInventoryCounts(){
        
        if(items != null && items.size() > 0){

            integer processed = 0;
            
            for(CountWrapper item : items){
                
                if(item.selected){
                    String transactionId = null;
                        						
                    List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                   FROM Group_Details__c
                                                   WHERE Inventory_Item_Group__c = :item.item.Inventory_Item__r.Item_Group__c
                                                   AND Transaction_ID__c = 'CYCLECNT'
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
                        
                        String impact = 'I';
                        Group_Details__c glCred = creditGl;
                        Group_Details__c glDebit = debitGl;
                        Double quantity = item.item.Quantity_Variance__c;
                            
                        if(item.item.Quantity_Variance__c > 0){
                            impact = 'D';
                            glCred = debitGl;
                            glDebit = creditGl;
                        } else {
                            quantity = item.item.Quantity_Variance__c * -1;
                        }
                        
                        if(quantity > 0){
                            
                            Inventory_Transaction__c trans = new Inventory_Transaction__c(
                                Item__c = item.item.Inventory_Item__c,
                                Transaction_ID__c = 'CYCLECNT',
                                Transaction_Quantity__c = quantity,
                                Quantity_Impact__c = impact,
                                Location__c = item.item.Item_Location__c,
                                Location_Lot__c = item.item.Item_Lot__c,                        
                                Item_Unit_Price__c = item.item.Unit_Price__c,                        
                                Debit_Account__c = glDebit.Config_Account__r.Lookup_Id__c,
                                Credit_Account__c = glCred.Config_Account__r.Lookup_Id__c
                            );
                            
                        	insert trans;
                        }
                                                
                        item.item.Processed__c = true;
                        update item.item;
                        
                        processed ++;
                    } else {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration for ' + item.item.Inventory_Item__c + ' is missing either credit or debit GL Accounts');
                        ApexPages.addmessage(msg);
                        return null;
                    }
                }
            }
            
            if(processed > 0){
                return new PageReference('/' + inventoryCount.Id); 
            } else {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Items were Processed')); 
               return null;
            }
        }
         return null;
    }
        
    public class CountWrapper{
        
        public Boolean selected {get; set;}
        public Item_Inventory_Count__c item {get; set;}              
        
        public CountWrapper(Item_Inventory_Count__c itm) {
            item = itm;
        }
    }
}