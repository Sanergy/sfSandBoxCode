public class ReversePurchaseOrderController {
    
    @TestVisible private ApexPages.StandardController standardController;
    
    @TestVisible private Purchase_Order__c purchaseOrder {get; set;}
    @TestVisible private List<Purchase_Order_Line_Item__c> purchaseOrderLineItems {get; set;}
    @TestVisible List<Inventory_Transaction__c> transactions;    
    @TestVisible public List<ItemWrapper> inventoryTransactions {get; set;} 
    public String strApexMessage;
    
    @TestVisible public ReversePurchaseOrderController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.purchaseOrder = (Purchase_Order__c)standardController.getRecord();
        this.purchaseOrder = [SELECT Id,Name
                              FROM Purchase_Order__c
                              WHERE Id =: this.purchaseOrder.Id
                             ];
        
        this.purchaseOrderLineItems = [SELECT Id,Name,Dimension_1__c,Dimension_2__c,Dimension_3__c,Dimension_4__c
                                       FROM Purchase_Order_Line_Item__c
                                       WHERE Purchase_Order__c =: this.purchaseOrder.Id
                                      ];
        
    }
    
    @TestVisible public List<Purchase_Order_Line_Item__c> getPurchaseOrderLineItems() {
        
        //Get all Purchase Order Line Items for the specified PO
        purchaseOrderLineItems = [SELECT Id,Name,Dimension_1__c,Dimension_1__r.lookup_ID__c,
                                  Dimension_2__c, Dimension_2__r.lookup_ID__c, 
                                  Dimension_3__c,Dimension_3__r.lookup_ID__c,
                                  Dimension_4__c, Dimension_4__r.lookup_ID__c
                                  FROM Purchase_Order_Line_Item__c
                                  WHERE Purchase_Order__c =: this.purchaseOrder.Id];
        
        //System.debug('PO LONE ITEMS: ' + this.purchaseOrderLineItems);
        return purchaseOrderLineItems;
    }    
    
    @TestVisible public List<ItemWrapper> getPurchaseOrderReceiptInventoryTransactions(){
        
        if(inventoryTransactions == null) {
            
            inventoryTransactions = new List<ItemWrapper>();
            System.debug('PO LONE ITEMS: ' + purchaseOrderLineItems);
            for(Purchase_Order_Line_Item__c poLineItem: purchaseOrderLineItems){
                
                //Get all Inventory Transactions for the specified Purchase Order Line Item
                List<Inventory_Transaction__c> invTransactions = [SELECT Id, Name, Item__c,Transaction_ID__c,Location_Lot__r.Name,
                                                                  Item__r.Name ,Item__r.Inventory_UoM__r.Name,Location__r.Location__r.Name,
                                                                  Transaction_Quantity__c,Quantity_Impact__c,Reversed_Transaction_ID__c,
                                                                  Location__c,Location_Lot__c,Quantity_At_Location__c,Location_Lot__r.Quantity__c,
                                                                  Vendor_Invoice__c,Item__r.Default_Lot__c,Purchase_Order_Line__c,Credit_Account__c,
                                                                  Purchase_Order_Line__r.Purchase_Order__c, Purchase_Order_Line__r.Purchase_Order__r.Name,
                                                                  Debit_Account__c,Dimension_1__c,Transaction_Value__c,Item__r.Item_Group__c,
                                                                  Item__r.Default_Site__c,Item__r.Default_Location__c,
                                                                  Item__r.Default_Site__r.Name,Location__r.Location__c,
                                                                  Item__r.unit_cost__c,Location__r.Location_Name__c,Location_Lot__r.Lot_Name__c                                                        
                                                                  FROM Inventory_Transaction__c
                                                                  WHERE Purchase_Order_Line__c =: poLineItem.Id
                                                                  AND Transaction_Reversed__c = false
                                                                  AND Transaction_ID__c = 'PORCPT'
                                                                  AND Reversed_Transaction_ID__c=NULL                                                        
                                                                 ];
                
                if(invTransactions.size() > 0 && invTransactions!=null){
                    
                    for(Inventory_Transaction__c invTransaction : invTransactions){
                        ItemWrapper wrapper = new ItemWrapper(invTransaction);
                        inventoryTransactions.add(wrapper);
                    }
                    
                }else{
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Transactions were found!');
                    ApexPages.addmessage(msg);
                    return null;
                }//End if(lineItems.size() > 0 && lineItems!=null)                
                
            }
        }//End if(inventoryTransactions == null)
        
        System.debug('Inventory_Transaction__c: ' + inventoryTransactions);
        return inventoryTransactions;
    }///End getPurchaseOrderReceiptInventoryTransactions()
    
    @TestVisible public PageReference reversePurchaseOrderReceipt(){
        getPurchaseOrderLineItems();
        getPurchaseOrderReceiptInventoryTransactions();
        //Create an instance of the list
        transactions = new List<Inventory_Transaction__c>();
        
        if(inventoryTransactions != null && inventoryTransactions.size() > 0){
            for(ItemWrapper item : inventoryTransactions){
                
                //Check if the 'PORCPT' Inventory Transaction has been selected
                if(item.selected==true){
                    
                    //Check if the quantity reversed is correct
                    if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c){
                        
                        if(item.lot != null){
                            
                            String woTransaction = 'PORCPT';
                            
                            List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                           FROM Group_Details__c
                                                           WHERE Inventory_Item_Group__c = :item.item.Item__r.Item_Group__c
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
                            }// End for(Group_Details__c gla : glas)
                            
                            // Check if debitGl != null && creditGl != null
                            if(debitGl != null && creditGl != null){
                                
                                for(Purchase_Order_Line_Item__c poLineItem: this.purchaseOrderLineItems){
                                    try{
                                        //Check if this PO Line Item has a transaction
                                        if(poLineItem.Id == item.item.Purchase_Order_Line__c){
                                            
                                            // Create Inventory_Transaction__c
                                            Inventory_Transaction__c newTransaction = new Inventory_Transaction__c();
                                            newTransaction.Item__c = item.item.Item__c;
                                            newTransaction.Transaction_ID__c = 'PORCPTRVS';
                                            newTransaction.Location__c = item.item.Location__c;
                                            newTransaction.Location_Lot__c = item.item.Location_Lot__c;
                                            newTransaction.Transaction_Quantity__c = item.reverseQuantity;
                                            newTransaction.Item_Unit_Price__c = item.item.Item__r.unit_cost__c;
                                            newTransaction.Quantity_Impact__c = 'D';
                                            newTransaction.Debit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                                            newTransaction.Credit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;                    
                                            newTransaction.Dimension_1__c = poLineItem.Dimension_1__r.lookup_ID__c;
                                            newTransaction.Dimension_2__c = poLineItem.Dimension_2__r.lookup_ID__c;
                                            newTransaction.Dimension_3__c = poLineItem.Dimension_3__r.lookup_ID__c;
                                            newTransaction.Dimension_4__c = poLineItem.Dimension_4__r.lookup_ID__c;
                                            newTransaction.Comments__c = 'Reversal of Purchase Order - '+ purchaseOrder.Name + ' and Transaction - ' + item.item.Name;
                                            newTransaction.Purchase_Order_Line__c = poLineItem.Id;
                                            INSERT newTransaction;
                                            //Add Inventory Transactions to the list
                                            // transactions.add(newTransaction);
                                            
                                            //UPDATE the new Inventory Transaction created 
                                            newTransaction.Transaction_Reversed__c = true;
                                            UPDATE newTransaction;
                                            
                                            //UPDATE the Inventory Transaction selected by the user from the Visual Force Page
                                            item.item.Reversed_Transaction_ID__c=newTransaction.Id;
                                            UPDATE item.item;                                        
                                            
                                        }//End if(poLineItem.Id == item.item.Purchase_Order_Line__c)
                                    }
                                    catch(Exception e){
                                        strApexMessage += 'Could not complete the Reversal for  ' +  purchaseOrder.Name + ' and Transaction - ' + item.item.Name;
                                    }
                                }//End for(Purchase_Order_Line_Item__c poLineItem: this.purchaseOrderLineItems)
                                
                                
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,strApexMessage);
                                ApexPages.addmessage(msg);
                            } else {
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts for ' + woTransaction);
                                ApexPages.addmessage(msg);
                                return null;
                            }//End if(debitGl != null && creditGl != null)                        
                            
                        }//End if(item.lot != null) 
                        
                    }else{
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The quantity reversed is incorrect!');
                        ApexPages.addmessage(msg);
                        return null;
                    }//End if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c)
                    
                }//End if(item.selected==true)
                
            }//End for(ItemWrapper item : inventoryTransactions)
            
            //Insert Inventory Transactions
            INSERT transactions;
            
        }// End if(inventoryTransactions != null && inventoryTransactions.size() > 0)
        
        return new PageReference('/' + purchaseOrder.Id);
    }// End reversePurchaseOrderReceipt()    
    
    public class ItemWrapper{
        
        @TestVisible public Inventory_Transaction__c item {get; set;}
        @TestVisible public Purchase_Order_Line_Item__c purchaseOrderItem {get; set;}        
        @TestVisible public String location {get; set;}
        @TestVisible public String lot {get; set;}        
        @TestVisible public Double reverseQuantity {get; set;}
        @TestVisible public Boolean selected {get; set;}      
        @TestVisible public String site {get; set;}      
        
        public ItemWrapper(Inventory_Transaction__c itm) {
            item = itm;
            selected = false;
            site = item.Location__r.Location__r.Name;
            location = item.Location__r.Location_Name__c;
            lot = item.Location_Lot__r.Lot_Name__c;
            reverseQuantity = item.Transaction_Quantity__c;
        }    
    }    
    
}