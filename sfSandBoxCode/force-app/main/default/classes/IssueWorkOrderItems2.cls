public class IssueWorkOrderItems2 {
    
    public ApexPages.StandardController standardController;
    public Work_Order__c workOrder;
    public Id inventoryItem;
    private List<ItemWrapper> items {get; set;}
    public List<Item_Location_Lot__c>  itemLoca;
    
    public IssueWorkOrderItems2(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.workOrder = (Work_Order__c)standardController.getRecord();
        this.workOrder =[SELECT Id,Inventory_Item__r.Id,Actual_End_Date__c ,Expected_End_Date__c, 
                         Inventory_Item__c ,Labor_Cost__c , Material_Cost__c, Work_Order_Type__c,
                         Site__c, Start_Date__c,Status__c, Inventory_Item__r.Currency_Config__c ,
                         Inventory_Item__r.unit_cost__c,Dimension_1__c,
                         Dimension_2__c,Dimension_3__c,Dimension_4__c
                         FROM Work_Order__c
                         WHERE Id =: this.workOrder.Id ];
        
    }
    
    public PageReference selectAll() {
        if(items!=null){
            for(ItemWrapper itm : items){
                itm.selected=true;
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(items!=null){
            for(ItemWrapper itm : items){
                itm.selected=false;
            }
        }
        return null;
    }
    
    
    public List<ItemWrapper> getItems(){
        
        if(items == null) {
            
            items = new List<ItemWrapper>();
            
            List<Work_Order_Item__c> lineItems = [SELECT id,Name ,BOM_Name__c,Inventory_Item__r.Inventory_UoM__c, Work_Order__c, 
                                                  Inventory_Item__c,Inventory_Item__r.unit_cost__c ,Inventory_Item__r.Item_Group__c,
                                                  BOM_Quantity__c, Currency__c,Lot__c,Inventory_Item__r.Name,
                                                  Issued_Quantity__c, Pending_Quantity__c,unit_cost__c                                                  
                                                  FROM Work_Order_Item__c 
                                                  WHERE  Work_Order__c =: workOrder.Id
                                                  AND Pending_Quantity__c > 0
                                                 ];
            
            
            if(lineItems.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Work Order does not have Items to Issue'));
                return null;
            }
            for(Work_Order_Item__c lineItem : lineItems){
                ItemWrapper wrapper = new ItemWrapper(lineItem);
                items.add(wrapper);
            }
            
        }
        return items;
    }
    
    public PageReference issueItems(){  
        if(items != null && items.size() > 0){
            System.debug('DFGHJHJ' +items.size());
            integer issued = 0;
            integer expected = 0;
            
            for(ItemWrapper item : items){
                System.debug('IQ' + item + 'WOT' +  this.workOrder.Work_Order_Type__c);
                System.debug('ITEM LOCATION: ' + item.selectedLot + 'PENDING QUANTITY: ' + item.item.Pending_Quantity__c + 'ISSUE QUANTITY: ' + item.issueQuantity + 'SELECTED LOT QUANTITY: ' + item.selectedLot.Quantity__c);                
                if(item.selected ==true && item.issueQuantity > 0 && this.workOrder.Work_Order_Type__c != null){                    
                    expected +=1;
                    
                    if(item.selectedLot != null && item.item.Pending_Quantity__c >= item.issueQuantity && item.issueQuantity <= item.selectedLot.Quantity__c){
                        
                        String woTransaction = 'WOISS';
                        
                        //Expensing Serice Items Immediately
                        if(this.workOrder.Work_Order_Type__c == 'WO-Service'){
                            woTransaction = 'WOISSEXP';
                        }
                        
                        List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                       FROM Group_Details__c
                                                       WHERE Inventory_Item_Group__c = :item.item.Inventory_Item__r.Item_Group__c
                                                       AND Transaction_ID__c = :woTransaction
                                                       AND Is_GL_Account__c = true
                                                      ];
                        System.debug(' >> ItemGroup: ' + item.item.Inventory_Item__r.Item_Group__c + '  >>WOTran' + woTransaction + '  >>GLA. ' + glas );
                        Group_Details__c creditGl = null;
                        Group_Details__c debitGl = null;
                        
                        for(Group_Details__c gla : glas){
                            if(gla.Credit_Debit__c == 'Credit'){
                                creditGl = gla;
                            } else if(gla.Credit_Debit__c == 'Debit'){
                                debitGl = gla;
                            }
                        }
                        system.debug('item.item.Inventory_Item__r.unit_cost__c' + item.item.Inventory_Item__r.unit_cost__c);
                        if(debitGl != null && creditGl != null){
                            system.debug('ISSUE QUANTITY' + item.issueQuantity);                               
                            Inventory_Transaction__c trans = new Inventory_Transaction__c();
                            trans.Item__c = item.item.Inventory_Item__c;
                            trans.Transaction_ID__c = woTransaction;
                            trans.Location__c = item.selectedLot.Item_Location__r.Id;
                            trans.Location_Lot__c = item.selectedLot.Id;
                            trans.Transaction_Quantity__c = item.issueQuantity;
                            trans.Item_Unit_Price__c = item.item.Inventory_Item__r.unit_cost__c;
                            trans.Quantity_Impact__c = 'D';
                            trans.Debit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;
                            trans.Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                            trans.Dimension_1__c = this.workOrder.Dimension_1__c;
                            trans.Dimension_2__c = this.workOrder.Dimension_2__c;
                            trans.Dimension_3__c = this.workOrder.Dimension_3__c;
                            trans.Dimension_4__c = this.workOrder.Dimension_4__c;
                            trans.Comments__c = item.item.Inventory_Item__r.Name;
                            trans.Work_Order__c = this.workOrder.Id;                            
                            INSERT trans;                           
                            
                            // Create Work Order Item Issue
                            Work_Order_Item_Issue__c woiss = new Work_Order_Item_Issue__c(
                                Work_Order__c = workOrder.Id,
                                Work_Order_Item__c = item.item.Id,
                                Issued_Quantity__c = item.issueQuantity,
                                Unit_Value__c = item.item.Inventory_Item__r.unit_cost__c,
                                Inventory_UoM__c = item.item.Inventory_Item__r.Inventory_UoM__c
                            );
                            INSERT woiss;                            
                            
                            //Add the current issued quantity to the previous rollup value of issued quantity
                            //This will get the total quantity that has been issued so far for each item
                            Decimal sumOfIssuedQuantity = item.issueQuantity + item.item.Issued_Quantity__c;                            
                            
                            //Check if BOM_Quantity is == Issued_Quantity
                            if(item.item.BOM_Quantity__c==sumOfIssuedQuantity && item.item.BOM_Quantity__c>0){
                                System.debug('BOM_QUANTITY: ' + item.item.BOM_Quantity__c + 'ISSUED_QUANTITY: '+ item.item.Issued_Quantity__c);
                                
                                //Update Work Order Item
                                item.item.Completed_Issuance__c=true;
                                UPDATE item.item;
                            }
                            
                        } else {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts for ' + woTransaction);
                            ApexPages.addmessage(msg);
                            return null;
                        }
                        issued +=1;
                    } else {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item is either missing a location or the issue quantity is incorrect');
                        ApexPages.addmessage(msg);
                        return null;
                    }
                }
            }//end for loop
            
            double quantityIssued = -1;
            double quantityPending = -1;
            
            //Check if any issuances have been done, if none set no Issuance
            AggregateResult[] QtyIssuedResults = 
                [SELECT SUM(Issued_Quantity__c)IssuedQty FROM Work_Order_Item__c WHERE Work_Order__c =: workOrder.Id];     
            
            quantityIssued = double.valueOf(QtyIssuedResults[0].get('IssuedQty'));
            //Check if Quantity Issued > 0
            if(quantityIssued == NULL || quantityIssued == 0){
                workOrder.Issue_Status__c = 'Unissued';
            }else{
                //issuance records exist, check if sum of pending qty > 0
                AggregateResult[] QtyPendingResults = 
                    [SELECT SUM(Pending_Quantity__c)PendingQty FROM Work_Order_Item__c WHERE Work_Order__c =: workOrder.Id AND Completed_Issuance__c = false ];
                
                quantityPending  = double.valueOf(QtyPendingResults[0].get('PendingQty'));
                
                //Check if Quantity Pending > 0
                if(quantityPending == NULL || quantityPending > 0 ){
                    workOrder.Issue_Status__c = 'Partial Issuance';
                }else{
                    workOrder.Issue_Status__c = 'Complete Issuance';
                }               
            }
            
            UPDATE workOrder;         
            
            if(expected == issued){
                return new PageReference('/' + workOrder.Id);
            } else {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Some Items Were not Issued');
                ApexPages.addmessage(msg);
                return null;
            }
            
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly confirm that the selected batch has enough quantities and the issue quantity is correct and that the Work order Type is set'));
            //return null;
        }
        return null; 
    }
    
    public class ItemWrapper{
        public Work_Order_Item__c item {get; set;}
        public Double issueQuantity {get; set;}
        //public String site {get; set;}
        public String location {get; set;}
        public String lot {get; set;}
        public Item_Location_Lot__c selectedLot {get; set;}
        public Boolean selected {get; set;}
        public List<SelectOption> locations {get; set;}
        public List<SelectOption> lots {get; set;}
        public List<Item_Location_Lot__c> ItemSelected {get; set;}  
        public ItemWrapper(Work_Order_Item__c itm) {
            item = itm;
            selected = false;
        }
        
        public void selectLotnew() {
            try {
                selected = true;
                issueQuantity = this.item.Pending_Quantity__c;
                String itemId = this.item.Inventory_Item__c;
                itemId = itemId.left(15);    
                selectedLot = [Select Id, Name,Quantity__c,Item_Location__r.Name,Item_Location__r.Id,Item_Location__r.Location__r.Name,Item_Location__r.Location__r.Id
                               From Item_Location_Lot__c
                               WHERE Inventory_Item_Id__c =: itemId
                               ORDER BY Quantity__c DESC
                               LIMIT 1
                              ];
                
                List<Work_Order_Item__c> lineItems = [SELECT id,Name, Lot__c,Work_Order__c, 
                                                      Issued_Quantity__c, Pending_Quantity__c
                                                      FROM Work_Order_Item__c 
                                                      WHERE  Lot__c =: selectedLot.Id
                                                      AND Pending_Quantity__c > 0
                                                     ];
                
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not get Location Values'));
                selected = false;
            } 
            
        }        
    }
}