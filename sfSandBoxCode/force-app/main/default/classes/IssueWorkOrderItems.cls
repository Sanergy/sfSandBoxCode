public class IssueWorkOrderItems {
    
    @TestVisible public ApexPages.StandardController standardController;
    @TestVisible public Work_Order__c workOrder;
    @TestVisible  public Id inventoryItem;
    @TestVisible private List<ItemWrapper> items {get; set;}
        
    public IssueWorkOrderItems(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.workOrder = (Work_Order__c)standardController.getRecord();
        this.workOrder =[SELECT Id,Inventory_Item__r.Id,Actual_End_Date__c ,Expected_End_Date__c  , 
                         Inventory_Item__c ,Labor_Cost__c  , Material_Cost__c, Work_Order_Type__c,
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
    
    
    @TestVisible public List<ItemWrapper> getItems(){
        
        if(items == null) {
            
            items = new List<ItemWrapper>();
            
            @TestVisible List<Work_Order_Item__c> lineItems = [SELECT id,Name ,BOM_Name__c,Inventory_Item__r.Inventory_UoM__c,Work_Order__c,
                                                               Inventory_Item__c,Inventory_Item__r.unit_cost__c,
                                                               BOM_Quantity__c, Currency__c,Lot__c,Inventory_Item__r.Name,
                                                               Issued_Quantity__c, Pending_Quantity__c,
                                                               unit_cost__c,Inventory_Item__r.Item_Group__c
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
            
            integer issued = 0;
            integer expected = 0;
            
            for(ItemWrapper item : items){
                
                if(item.issueQuantity > 0 && this.workOrder.Work_Order_Type__c != null){
                    
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
                                                            
                            Inventory_Transaction__c trans = new Inventory_Transaction__c();
                            trans.Item__c = item.item.Inventory_Item__c;
                            trans.Transaction_ID__c = woTransaction;
                            trans.Location__c = item.location;
                            trans.Location_Lot__c = item.lot;
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
            return null;
        }
        return null;
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
    
    @TestVisible public class ItemWrapper{
       @TestVisible public Work_Order_Item__c item {get; set;}
       @TestVisible public Double issueQuantity {get; set;}
       @TestVisible public String site {get; set;}
       @TestVisible public String location {get; set;}
       @TestVisible public String lot {get; set;}
       @TestVisible public Item_Location_Lot__c selectedLot {get; set;}
       @TestVisible public Boolean selected {get; set;}
       @TestVisible public List<SelectOption> locations {get; set;}
       @TestVisible public List<SelectOption> lots {get; set;}
       
       @TestVisible public ItemWrapper(Work_Order_Item__c itm) {
            item = itm;
            selected = true;
       }
        
        @TestVisible public void setLocs() {
            this.locations = new List<SelectOption>();
            SelectOption defopt = new SelectOption('NA', '----------');
            locations.add(defopt);
            
            if(site != null && !site.equals('NA')){
                List<Inventory_Item_Location__c> locs = [Select Id, Name
                                                         From Inventory_Item_Location__c
                                                         WHERE Inventory_Item__c =: this.item.Inventory_Item__c
                                                         AND Location__c = :this.site
                                                        ];
                
                
                for(Inventory_Item_Location__c location : locs){
                    SelectOption option = new SelectOption(location.Id, location.Name);
                    locations.add(option);
                }
            }
        }
        
        @TestVisible public void setLots() {
            this.lots  = new List<SelectOption>();
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
            issueQuantity = this.item.Pending_Quantity__c;
            
            if(lot != null && !lot.equals('NA')){
                selectedLot = [Select Id, Name,Quantity__c
                               From Item_Location_Lot__c
                               WHERE id = :this.lot
                              ];
            }
        }
    }
}