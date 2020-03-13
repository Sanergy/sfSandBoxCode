public class CaseOppWorkOrdersController{
    
    private ApexPages.StandardController standardController;
    
    public CaseOppWorkOrdersController(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
    public PageReference createOrders() {
        
        Opportunity opp = (Opportunity) standardController.getRecord();
        
        Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
        //String slkDivision = settings.get('SLK Division Id').Value__c;
        String fliDivision = settings.get('FLIK Division Id').Value__c;
        String flimaintenanceCaseItem = settings.get('FLI Maintenance Cases').Value__c;
        //String slkmaintenanceCaseItem = settings.get('SLK Maintenance Cases').Value__c;
        String inventorySiteMukuru = settings.get('Inventory Site - Mukuru').Value__c;        
        String dimension1;
        
        // Get Dimension 1
        List<c2g__codaDimension1__c> dimensions = [SELECT Id,Name
                                                   FROM c2g__codaDimension1__c
                                                   WHERE Name='Fresh Life Operations- Maintenance'
                                                  ];
        
        // Get Case Opportunity Items
        List<Case_Opportunity_Item__c> items = [SELECT Id, Name,Rstk_Inventory_Item__r.Company_Id__c,
                                                Rstk_Inventory_Item__r.InventoryItem__c, Item_Division__c,
                                                Quantity__c
                                                FROM Case_Opportunity_Item__c
                                                WHERE Opportunity__c = :opp.Id 
                                                AND Work_Order_Created__c=false
                                                AND Item_Division__c='Fresh Life Initiative Limited'];
        
        if(items.size() > 0){
            
            Map<String, List<Case_Opportunity_Item__c>> itemMap = new Map<String, List<Case_Opportunity_Item__c>>();
            
            for(Case_Opportunity_Item__c item : items){
                List<Case_Opportunity_Item__c> itemList = itemMap.get(item.Rstk_Inventory_Item__r.Company_Id__c);
                
                if(itemList != null){
                    itemList.add(item);
                } else {
                    itemList = new  List<Case_Opportunity_Item__c>();
                    itemList.add(item);
                    itemMap.put(item.Rstk_Inventory_Item__r.Company_Id__c, itemList);
                }
                
                item.Work_Order_Created__c=true;
            }
            
            if(itemMap.size() > 0){
                
                Set<String> keys = itemMap.keySet();
                
                for(String key: keys){
                    
                    List<Case_Opportunity_Item__c> itemList = itemMap.get(key);
                    
                    if(itemList.size() > 0){
                        String itemId = flimaintenanceCaseItem;
                        
                        if(key.equals(fliDivision)){
                            itemId = flimaintenanceCaseItem;
                        }
                        
                        // Create Work Order
                        Work_Order__c wo = new Work_Order__c();
                        wo.Inventory_Item__c = itemId;
                        wo.Site__c = inventorySiteMukuru;
                        wo.Inventory_Item_Quantity__c = 1;
                        wo.Company__c= key;
                        wo.Status__c = 'Planned';
                        INSERT wo;
                        
                        
                        List<Work_Order_Item__c> wo_comps = new List<Work_Order_Item__c>();
                        Map<String, Double> mergedItems = new Map<String, Double>();
                        
                        for(Case_Opportunity_Item__c itms : itemList){
                            
                            Double qty = mergedItems.get(itms.Rstk_Inventory_Item__r.InventoryItem__c);
                            
                            if(qty == null){
                                qty = itms.Quantity__c;
                            } else{
                                qty = qty + itms.Quantity__c;
                            }
                            
                            mergedItems.put(itms.Rstk_Inventory_Item__r.InventoryItem__c, qty);
                        }
                        
                        if(mergedItems != null && mergedItems.size()> 0){
                            
                            Set<String> ids = mergedItems.keySet();
                            
                            for(String itmid: ids){
                                
                                Double quantity = mergedItems.get(itmid);
                                
                                if(quantity != null && quantity > 0){
                                    
                                    // Create Work Order Item
                                    Work_Order_Item__c cmp = new Work_Order_Item__c();
                                    cmp.Work_Order__c = wo.Id;
                                    cmp.Inventory_Item__c = itmid;
                                    cmp.BOM_Quantity__c = quantity;
                                    
                                    wo_comps.add(cmp);
                                }
                            }
                        }
                        
                        if(wo_comps.size() > 0){
                            System.debug(JSON.serialize(wo_comps));
                            INSERT wo_comps;
                        }
                        
                        //Create Opportunity_Work_Order__c
                        Opportunity_Work_Order__c wOrder = new Opportunity_Work_Order__c();
                        wOrder.Opportunity__c = opp.Id;
                        wOrder.WorkOrder__c= wo.Id;
                        wOrder.Work_Order_Type__c = 'Structure';
                        INSERT wOrder;
                        
                        // Loop through c2g__codaDimension1__c
                        for(c2g__codaDimension1__c dimension : dimensions){
                            // Check if Work order type = Structure                                    
                            if(dimension.Name=='Fresh Life Operations- Maintenance' && wOrder.Work_Order_Type__c=='Structure'){
                                dimension1 = dimension.Id;                    
                            }
                        }                                    
                        
                        //Update Work Order
                        wo.Dimension_1__c=dimension1;
                        UPDATE wo;                        
                        
                    }
                }// End for loop
                
                opp.StageName='Work Order Created';
                UPDATE opp;
                UPDATE items;
            }
            
            // Redirect to the opportunity Record
            return new PageReference('/' + opp.Id);
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are no Case Opportunity Items to create Work Orders for.'));
        }        
        return null;
    }
    
}