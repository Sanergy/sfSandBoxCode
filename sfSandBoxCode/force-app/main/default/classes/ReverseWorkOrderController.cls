public class ReverseWorkOrderController {
    
    @TestVisible private ApexPages.StandardController standardController;
    
    @TestVisible private Work_Order__c workOrder {get; set;}    
    @TestVisible private List<ItemWrapper> inventoryTransactions {get; set;}
    @TestVisible List<Work_Order_Item__c> workOrderItems {get; set;}     
    @TestVisible List<Work_Order_Item_Issue__c> issuances;
    @TestVisible List<Work_Order_Receipts__c> receipts;   
    @TestVisible public Boolean serviceWO {get; set;}	//Service WO	---was installationWo	
    @TestVisible public Boolean manufacturedWO {get; set;}	// Manufactured WO		---was otherWo    
    
    @TestVisible public ReverseWorkOrderController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.workOrder = (Work_Order__c)standardController.getRecord();
        
        this.workOrder = [SELECT Id, Name, Inventory_Item__c, Inventory_Item_Quantity__c, Status__c,
                          Material_Cost__c, Inventory_Item__r.Default_Site__c,Pending_Quantity__c, 
                          Inventory_Item__r.Default_Location__c, Inventory_Item__r.Name,Unit_Cost__c,
                          UOM__c, Inventory_Item__r.Default_Lot__c, Inventory_Item__r.unit_cost__c,
                          Inventory_Item__r.Inventory_UoM__c, Inventory_Item__r.Item_Group__c,
                          Issue_Variance__c,Receipt_Variance__c, Work_Order_Type__c,
                          Dimension_1__c,Dimension_2__c,Dimension_3__c,Dimension_4__c,
                          Inventory_Item__r.WO_Receipt_Variance_Acceptable__c
                          FROM Work_Order__c
                          WHERE Id = :this.workOrder.Id
                         ];
        
        
        this.serviceWO = this.workOrder.Work_Order_Type__c == 'WO-Service' ? true : false;        
        this.manufacturedWO = this.workOrder.Work_Order_Type__c == 'WO-Manufactured' ? true : false;
    }
    
    @TestVisible public List<ItemWrapper> getWorkOrderReceiptInventoryTransactions(){
        
        if(inventoryTransactions == null) {
            
            inventoryTransactions = new List<ItemWrapper>();
            
            List<Inventory_Transaction__c> lineItems = [SELECT Id, Name, Item__c,Transaction_ID__c,Location_Lot__r.Name,
                                                        Item__r.Name ,Item__r.Inventory_UoM__r.Name,Location__r.Location__r.Name,
                                                        Transaction_Quantity__c,Quantity_Impact__c,Reversed_Transaction_ID__c,
                                                        Location__c,Location_Lot__c,Quantity_At_Location__c,Location_Lot__r.Quantity__c,
                                                        Work_Order__c,Vendor_Invoice__c,Item__r.Default_Lot__c,
                                                        Purchase_Order_Line__c,Credit_Account__c,Item__r.Item_Group__c,
                                                        Debit_Account__c,Dimension_1__c,Transaction_Value__c,
                                                        Item__r.Default_Site__c,Item__r.Default_Location__c,
                                                        Item__r.Default_Site__r.Name,Location__r.Location__c,
                                                        Item__r.unit_cost__c,Location__r.Location_Name__c,Location_Lot__r.Lot_Name__c                                                        
                                                        FROM Inventory_Transaction__c
                                                        WHERE Work_Order__c =: this.workOrder.Id
                                                        AND Transaction_Reversed__c = false
                                                        AND Transaction_ID__c = 'WORCPT'
														AND Reversed_Transaction_ID__c=NULL                                                        
                                                       ];
            
            if(lineItems.size() > 0 && lineItems!=null){
                
                for(Inventory_Transaction__c lineItem : lineItems){
                    ItemWrapper wrapper = new ItemWrapper(lineItem);
                    inventoryTransactions.add(wrapper);
                }
                
            }else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Transactions were found!');
                ApexPages.addmessage(msg);
                return null;
            }//End if(lineItems.size() > 0 && lineItems!=null)
            
        }
        
        //Warn the User before reversing the transaction
        ApexPages.Message warningMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You can only reverse these transactions once!');
        ApexPages.addmessage(warningMessage);
        
        return inventoryTransactions;
    }///End getWorkOrderReceiptInventoryTransactions()
    
    @TestVisible public List<ItemWrapper> getWorkOrderIssuanceWOISSInventoryTransactions(){
        
        if(inventoryTransactions == null) {
            
            inventoryTransactions = new List<ItemWrapper>();
            
            List<Inventory_Transaction__c> lineItems = [SELECT Id, Name, Item__c,Transaction_ID__c,Location_Lot__r.Name,
                                                        Item__r.Name ,Item__r.Inventory_UoM__r.Name,Location__r.Location__r.Name,
                                                        Transaction_Quantity__c,Quantity_Impact__c,Reversed_Transaction_ID__c,
                                                        Location__c,Location_Lot__c,Quantity_At_Location__c,Location_Lot__r.Quantity__c,
                                                        Work_Order__c,Vendor_Invoice__c,Item__r.Default_Lot__c,
                                                        Purchase_Order_Line__c,Credit_Account__c,Item__r.Item_Group__c,
                                                        Debit_Account__c,Dimension_1__c,Transaction_Value__c,
                                                        Item__r.Default_Site__c,Item__r.Default_Location__c,
                                                        Item__r.Default_Site__r.Name,Location__r.Location__c,
                                                        Item__r.unit_cost__c,Location__r.Location_Name__c,Location_Lot__r.Lot_Name__c                                                        
                                                        FROM Inventory_Transaction__c
                                                        WHERE Work_Order__c =: this.workOrder.Id
                                                        AND Transaction_Reversed__c = false
                                                        AND Transaction_ID__c = 'WOISS'
														AND Reversed_Transaction_ID__c=NULL                                                        
                                                       ];
            
            if(lineItems.size() > 0 && lineItems!=null){
                
                for(Inventory_Transaction__c lineItem : lineItems){
                    ItemWrapper wrapper = new ItemWrapper(lineItem);
                    inventoryTransactions.add(wrapper);
                }
                
            }else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Transactions were found!');
                ApexPages.addmessage(msg);
                return null;
            }//End if(lineItems.size() > 0 && lineItems!=null)
            
        }
        
        //Warn the User before reversing the transaction
        ApexPages.Message warningMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You can only reverse these transactions once!');
        ApexPages.addmessage(warningMessage);
               
        return inventoryTransactions;
    }//End getWorkOrderIssuanceWOISSInventoryTransactions()

    @TestVisible public List<ItemWrapper> getWorkOrderIssuanceWOISSEXPInventoryTransactions(){
        
        if(inventoryTransactions == null) {
            
            inventoryTransactions = new List<ItemWrapper>();
            
            List<Inventory_Transaction__c> lineItems = [SELECT Id, Name, Item__c,Transaction_ID__c,Location_Lot__r.Name,
                                                        Item__r.Name ,Item__r.Inventory_UoM__r.Name,Location__r.Location__r.Name,
                                                        Transaction_Quantity__c,Quantity_Impact__c,Reversed_Transaction_ID__c,
                                                        Location__c,Location_Lot__c,Quantity_At_Location__c,Location_Lot__r.Quantity__c,
                                                        Work_Order__c,Vendor_Invoice__c,Item__r.Default_Lot__c,
                                                        Purchase_Order_Line__c,Credit_Account__c,Item__r.Item_Group__c,
                                                        Debit_Account__c,Dimension_1__c,Transaction_Value__c,
                                                        Item__r.Default_Site__c,Item__r.Default_Location__c,
                                                        Item__r.Default_Site__r.Name,Location__r.Location__c,
                                                        Item__r.unit_cost__c,Location__r.Location_Name__c,Location_Lot__r.Lot_Name__c                                                        
                                                        FROM Inventory_Transaction__c
                                                        WHERE Work_Order__c =: this.workOrder.Id
                                                        AND Transaction_Reversed__c = false
                                                        AND Transaction_ID__c = 'WOISSEXP'
														AND Reversed_Transaction_ID__c=NULL                                                        
                                                       ];
            
            if(lineItems.size() > 0 && lineItems!=null){
                
                for(Inventory_Transaction__c lineItem : lineItems){
                    ItemWrapper wrapper = new ItemWrapper(lineItem);
                    inventoryTransactions.add(wrapper);
                }
                
            }else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Transactions were found!');
                ApexPages.addmessage(msg);
                return null;
            }//End if(lineItems.size() > 0 && lineItems!=null)
        }
        
        //Warn the User before reversing the transaction
        ApexPages.Message warningMessage = new ApexPages.Message(ApexPages.Severity.WARNING,'You can only reverse these transactions once!');
        ApexPages.addmessage(warningMessage);
        
        return inventoryTransactions;
    }//End getWorkOrderIssuanceWOISSEXPInventoryTransactions()        
    
    @TestVisible public PageReference reverseWorkOrderReceipt(){
        
        //Check if this Work Order is 'Closed' for you to be able to reverse it
        if(this.workOrder.Status__c == 'Closed'){
        
            //Create an instance of the list
            receipts = new List<Work_Order_Receipts__c>();
            
            if(inventoryTransactions != null && inventoryTransactions.size() > 0){
                for(ItemWrapper item : inventoryTransactions){
                    
                    //Check if the 'WORCPT' Inventory Transaction has been selected
                    if(item.selected==true){
                        
                        //Check if the quantity reversed is correct
                        if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c){
                            
                            if(item.lot != null){
                                
                                String woTransaction = 'WORCPT';
                                
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
                                    
                                    // Create Inventory_Transaction__c
                                    Inventory_Transaction__c newTransaction = new Inventory_Transaction__c();
                                    newTransaction.Item__c = item.item.Item__c;
                                    newTransaction.Transaction_ID__c = 'WORCPTRVS';
                                    newTransaction.Location__c = item.item.Location__c;
                                    newTransaction.Location_Lot__c = item.item.Location_Lot__c;
                                    newTransaction.Transaction_Quantity__c = item.reverseQuantity;
                                    newTransaction.Item_Unit_Price__c = item.item.Item__r.unit_cost__c;
                                    newTransaction.Quantity_Impact__c = 'D';
                                    newTransaction.Debit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                                    newTransaction.Credit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;                    
                                    newTransaction.Dimension_1__c = this.workOrder.Dimension_1__c;
                                    newTransaction.Dimension_2__c = this.workOrder.Dimension_2__c;
                                    newTransaction.Dimension_3__c = this.workOrder.Dimension_3__c;
                                    newTransaction.Dimension_4__c = this.workOrder.Dimension_4__c;
                                    newTransaction.Comments__c = 'Reversal of Work Order - '+ workOrder.Name + ' and Transaction - ' + item.item.Name;
                                    newTransaction.Work_Order__c = workOrder.Id;
                                    INSERT newTransaction;
                                    
                                    //Check if Transaction has been reversed
                                    if(newTransaction.Transaction_ID__c=='WORCPTRVS'){
                                        
                                        // Get the Inventory Item that has been received
                                        List<Work_Order_Receipts__c> workOrderItemReceipt  = [Select Id, Name, Work_Order__c,Receive_Site__c,
                                                                                              Receive_Location__c,Receive_Lot__c,Receive_Quantity__c,
                                                                                              Inventory_Transaction__c,Inventory_Item__c
                                                                                              From Work_Order_Receipts__c
                                                                                              WHERE Work_Order__c =: this.workOrder.Id
                                                                                              AND Inventory_Item__c =: item.item.Item__r.Name
                                                                                              LIMIT 1
                                                                                             ];
                                        
                                        if(workOrderItemReceipt.size() > 0 && workOrderItemReceipt != null){
                                            
                                            //Create Work_Order_Receipts__c
                                            Work_Order_Receipts__c woReceipt = new Work_Order_Receipts__c();
                                            woReceipt.Work_Order__c = workOrder.Id;
                                            woReceipt.Receive_Site__c = item.item.Location__r.Location__c;
                                            woReceipt.Receive_Location__c = item.item.Location__c;
                                            woReceipt.Receive_Lot__c = item.item.Location_Lot__c;
                                            woReceipt.Receive_Quantity__c = item.reverseQuantity * -1;
                                            woReceipt.Inventory_Transaction__c = newTransaction.Id;
                                            
                                            //Check if this is the primary item in the work order and set it to true
                                            if(item.item.Item__c == workOrder.Inventory_Item__c){
                                                woReceipt.Primary_Item_in_Work_Order__c = true;
                                            }
                                            
                                            //Add Work Order Receipts to the list
                                            receipts.add(woReceipt);
                                            
                                        }//End if(workOrderItemReceipt.size() > 0 && workOrderItemReceipt != null)
                                        
                                    }else{
                                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The Work Order Receipt reversal was not successful');
                                        ApexPages.addmessage(msg);
                                        return null;
                                    }//End if(newTransaction.Transaction_ID__c=='WORCPTRVS')
                                    
                                    
                                    //UPDATE the new Inventory Transaction created 
                                    newTransaction.Transaction_Reversed__c=true;
                                    UPDATE newTransaction;                             
                                    
                                    //UPDATE the Inventory Transaction selected by the user from the Visual Force Page
                                    item.item.Reversed_Transaction_ID__c=newTransaction.Id;
                                    UPDATE item.item;
                                    
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
                
                //Insert Work Order Item Issuances
                INSERT receipts;
                
            }// End if(inventoryTransactions != null && inventoryTransactions.size() > 0)           
               
        }else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'This Work Order has to be closed for you to reverse it!');
            ApexPages.addmessage(msg);
            return null;            
        }
        
        return new PageReference('/' + workOrder.Id);
    }// End reverseWorkOrderReceipt()
    
    @TestVisible public PageReference reverseWorkOrderIssuanceWOISS(){
        
        //Ensure this Work Order has not been 'Closed'for you to be able to reverse it
        if(this.workOrder.Status__c != 'Closed'){
            
            //Create an instance of the list
            issuances = new List<Work_Order_Item_Issue__c>();
            workOrderItems = new List<Work_Order_Item__c>();
            
            if(inventoryTransactions != null && inventoryTransactions.size() > 0){
                for(ItemWrapper item : inventoryTransactions){
                    
                    //Check if the 'WOISS' Inventory Transaction has been selected
                    if(item.selected==true){
                        
                        //Check if the quantity reversed is correct
                        if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c){
                            
                            String woTransaction = 'WOISS';          
                            
                            List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                           FROM Group_Details__c
                                                           WHERE Inventory_Item_Group__c =:item.item.Item__r.Item_Group__c
                                                           AND Transaction_ID__c =:woTransaction
                                                           AND Is_GL_Account__c = true
                                                          ];
                            
                            System.debug('Group_Details__c' + glas);                
                            
                            Group_Details__c creditGl = null;
                            Group_Details__c debitGl = null;
                            
                            for(Group_Details__c gla : glas){
                                if(gla.Credit_Debit__c == 'Credit'){
                                    creditGl = gla;
                                } else if(gla.Credit_Debit__c == 'Debit'){
                                    debitGl = gla;
                                }
                            }// End for Group_Details__c
                            
                            // Check if debitGl != null && creditGl != null
                            if(debitGl != null && creditGl != null){
                                
                                // Create Inventory_Transaction__c
                                Inventory_Transaction__c newTransaction = new Inventory_Transaction__c();
                                newTransaction.Item__c = item.item.Item__c;
                                newTransaction.Transaction_ID__c = 'WOISSRVS';
                                newTransaction.Location__c = item.item.Location__c;
                                newTransaction.Location_Lot__c = item.item.Location_Lot__c;
                                newTransaction.Transaction_Quantity__c = item.reverseQuantity;
                                newTransaction.Item_Unit_Price__c = item.item.Item__r.unit_cost__c;
                                newTransaction.Quantity_Impact__c = 'I';
                                newTransaction.Debit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                                newTransaction.Credit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;                    
                                newTransaction.Dimension_1__c = this.workOrder.Dimension_1__c;
                                newTransaction.Dimension_2__c = this.workOrder.Dimension_2__c;
                                newTransaction.Dimension_3__c = this.workOrder.Dimension_3__c;
                                newTransaction.Dimension_4__c = this.workOrder.Dimension_4__c;
                                newTransaction.Comments__c = 'Reversal of Work Order - '+ workOrder.Name + ' and Transaction - ' + item.item.Name;
                                newTransaction.Work_Order__c = workOrder.Id;
                                INSERT newTransaction;
                                
                                //Check if Transaction has ben reversed
                                if(newTransaction.Transaction_ID__c == 'WOISSRVS'){
                                    //System.debug('workOrderItemIssuances: ' + this.workOrderItemIssuances);
                                    
                                    // Get the Inventory Item that has been issued
                                    List<Work_Order_Item_Issue__c> workOrderItemIssuance  = [Select Id, Name, Inventory_UoM__r.Name, Issued_Quantity__c,
                                                                                             Issued_Value__c, Unit_Value__c,Work_Order_Item__c,
                                                                                             Work_Order_Item__r.Inventory_Item__c,Work_Order_Item__r.Completed_Issuance__c,
                                                                                             Work_Order_Item__r.Inventory_Item__r.Name
                                                                                             From Work_Order_Item_Issue__c
                                                                                             WHERE Work_Order__c =: this.workOrder.Id
                                                                                             AND Work_Order_Item__r.Inventory_Item__c =: item.item.Item__c
                                                                                             LIMIT 1
                                                                                            ];
                                    
                                    System.debug('workOrderItemIssuance: ' + workOrderItemIssuance);
                                    
                                    if(workOrderItemIssuance.size() > 0 && workOrderItemIssuance != null){
                                        
                                        //Create Work_Order_Item_Issue__c
                                        Work_Order_Item_Issue__c woiss = new Work_Order_Item_Issue__c();
                                        woiss.Work_Order__c = workOrder.Id;
                                        woiss.Work_Order_Item__c = workOrderItemIssuance.get(0).Work_Order_Item__c;
                                        woiss.Issued_Quantity__c = item.reverseQuantity * -1;
                                        woiss.Unit_Value__c = item.item.Item__r.unit_cost__c;
                                        woiss.Inventory_UoM__c = item.item.Item__r.Inventory_UoM__c;
                                        woiss.Reversed_Transaction_ID__c = newTransaction.Id;
                                        woiss.Work_Order_Issuance_Reversal__c = true;
                                        
                                        //Add Work Order Item Issuances to the list
                                        issuances.add(woiss);
                                        
                                    }//End if(lineItems.size()>0 && lineItems!=null)
                                    
                                    //Get the Work Order Item
                                    Work_Order_Item__c workOrderItem = [SELECT id,Name ,BOM_Name__c,Inventory_Item__r.Inventory_UoM__c, Work_Order__c, 
                                                                        Inventory_Item__c,Inventory_Item__r.unit_cost__c ,Inventory_Item__r.Item_Group__c,
                                                                        BOM_Quantity__c, Currency__c,Lot__c,Inventory_Item__r.Name,
                                                                        Issued_Quantity__c, Pending_Quantity__c,unit_cost__c,Completed_Issuance__c                                                  
                                                                        FROM Work_Order_Item__c 
                                                                        WHERE  Work_Order__c =: this.workOrder.Id
                                                                        AND Inventory_Item__c =: item.item.Item__c
                                                                        LIMIT 1
                                                                       ];
                                    
                                    //UPDATE Work_Order_Item__c
                                    workOrderItem.Completed_Issuance__c = false;
                                    
                                    //Add Work_Order_Item__c to the list
                                    workOrderItems.add(workOrderItem);
                                    
                                }else{
                                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The Work Order Issuance reversal was not successful');
                                    ApexPages.addmessage(msg);
                                    return null;
                                }//End if(newTransaction.Transaction_ID__c=='WOISSRVS')
                                
                                //UPDATE the new Inventory Transaction created 
                                newTransaction.Transaction_Reversed__c = true;
                                UPDATE newTransaction;
                                
                                //UPDATE the Inventory Transaction selected by the user from the Visual Force Page
                                item.item.Reversed_Transaction_ID__c=newTransaction.Id;
                                UPDATE item.item;
                                
                            } else {
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts for ' + woTransaction);
                                ApexPages.addmessage(msg);
                                return null;
                            }//End if(debitGl != null && creditGl != null)
                            
                        }else{
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The quantity reversed is incorrect!');
                            ApexPages.addmessage(msg);
                            return null;
                        }//End if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c)
                        
                    }//End if(item.selected==true)
                    
                }//End for(ItemWrapper item : inventoryTransactions)
                
                //Insert Work Order Item Issuances
                INSERT issuances;
                
                //UPDATE Work Order Item        
                UPDATE workOrderItems;
    
                Double quantityIssued;
                Double quantityPending;
                
                //Check if any issuances have been done, if none set no Issuance
                AggregateResult[] QtyIssuedResults = 
                    [SELECT SUM(Issued_Quantity__c)IssuedQty FROM Work_Order_Item__c WHERE Work_Order__c =: workOrder.Id];     
                
                quantityIssued = double.valueOf(QtyIssuedResults[0].get('IssuedQty'));
                
                System.debug('Issued_Quantity__c: '+quantityIssued);            
                
                //Check if Quantity Issued > 0
                if(quantityIssued == NULL || quantityIssued == 0){
                    workOrder.Issue_Status__c = 'Unissued';
                }else{
                    //issuance records exist, check if sum of pending qty > 0
                    AggregateResult[] QtyPendingResults = 
                        [SELECT SUM(Pending_Quantity__c)PendingQty FROM Work_Order_Item__c WHERE Work_Order__c =: workOrder.Id AND Completed_Issuance__c = false ];
                    
                    quantityPending  = double.valueOf(QtyPendingResults[0].get('PendingQty'));
                    
                    System.debug('Pending_Quantity__c: '+quantityPending);
                    
                    //Check if Quantity Pending > 0
                    if(quantityPending == NULL || quantityPending > 0 ){
                        workOrder.Issue_Status__c = 'Partial Issuance';
                    }else{
                        workOrder.Issue_Status__c = 'Complete Issuance';
                    }//End if(quantityPending == NULL || quantityPending > 0 )               
                }//End if(quantityIssued == NULL || quantityIssued == 0)
                
                UPDATE workOrder;            
                            
            }//End if(inventoryTransactions != null && inventoryTransactions.size() > 0)            
            
        }else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'This Work Order is already closed. You can\'t reverse Work Order Issuance(s)');
            ApexPages.addmessage(msg);
            return null;            
        }
        
        return new PageReference('/' + workOrder.Id);
    }// End reverseWorkOrderIssuanceWOISS()
    
    @TestVisible public PageReference reverseWorkOrderIssuanceWOISSEXP(){
        
        //Create an instance of the list
        issuances = new List<Work_Order_Item_Issue__c>();        
		workOrderItems = new List<Work_Order_Item__c>();
        
        if(inventoryTransactions != null && inventoryTransactions.size() > 0){
            for(ItemWrapper item : inventoryTransactions){
                
                //Check if the 'WOISSEXP' Inventory Transaction has been selected
                if(item.selected==true){
                    
                    //Check if the quantity reversed is correct
                    if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c){                    
                        
                        String woTransaction = 'WOISSEXP';
                        
                        List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                       FROM Group_Details__c
                                                       WHERE Inventory_Item_Group__c =:item.item.Item__r.Item_Group__c
                                                       AND Transaction_ID__c =:woTransaction
                                                       AND Is_GL_Account__c = true
                                                      ];
                        
                        System.debug('Group_Details__c' + glas);                
                        
                        Group_Details__c creditGl = null;
                        Group_Details__c debitGl = null;
                        
                        for(Group_Details__c gla : glas){
                            if(gla.Credit_Debit__c == 'Credit'){
                                creditGl = gla;
                            } else if(gla.Credit_Debit__c == 'Debit'){
                                debitGl = gla;
                            }
                        }// End for Group_Details__c
                        
                        // Check if debitGl != null && creditGl != null
                        if(debitGl != null && creditGl != null){
                            
                            // Create Inventory_Transaction__c
                            Inventory_Transaction__c newTransaction = new Inventory_Transaction__c();
                            newTransaction.Item__c = item.item.Item__c;
                            newTransaction.Transaction_ID__c = 'WOISSEXPRVS';
                            newTransaction.Location__c = item.item.Location__c;
                            newTransaction.Location_Lot__c = item.item.Location_Lot__c;
                            newTransaction.Transaction_Quantity__c = item.reverseQuantity;
                            newTransaction.Item_Unit_Price__c = item.item.Item__r.unit_cost__c;
                            newTransaction.Quantity_Impact__c = 'I';
                            newTransaction.Debit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                            newTransaction.Credit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;                    
                            newTransaction.Dimension_1__c = this.workOrder.Dimension_1__c;
                            newTransaction.Dimension_2__c = this.workOrder.Dimension_2__c;
                            newTransaction.Dimension_3__c = this.workOrder.Dimension_3__c;
                            newTransaction.Dimension_4__c = this.workOrder.Dimension_4__c;
                            newTransaction.Comments__c = 'Reversal of Work Order - '+ workOrder.Name + ' and Transaction - ' + item.item.Name;
                            newTransaction.Work_Order__c = workOrder.Id;
                            INSERT newTransaction;
                            
                            //Check if Transaction has ben reversed
                            if(newTransaction.Transaction_ID__c == 'WOISSEXPRVS'){                            
                                
                                // Get the Inventory Item that has been issued
                                List<Work_Order_Item_Issue__c> workOrderItemIssuance  = [Select Id, Name, Inventory_UoM__r.Name, Issued_Quantity__c,
                                                                                         Issued_Value__c, Unit_Value__c,Work_Order_Item__c,
                                                                                         Work_Order_Item__r.Inventory_Item__c,
                                                                                         Work_Order_Item__r.Inventory_Item__r.Name
                                                                                         From Work_Order_Item_Issue__c
                                                                                         WHERE Work_Order__c =: this.workOrder.Id
                                                                                         AND Work_Order_Item__r.Inventory_Item__c =: item.item.Item__c
                                                                                         LIMIT 1
                                                                                        ];
                                
                                System.debug('workOrderItemIssuance: ' + workOrderItemIssuance);
                                
                                if(workOrderItemIssuance.size() > 0 && workOrderItemIssuance != null){
                                    
                                    //Create Work_Order_Item_Issue__c
                                    Work_Order_Item_Issue__c woiss = new Work_Order_Item_Issue__c();
                                    woiss.Work_Order__c = workOrder.Id;
                                    woiss.Work_Order_Item__c = workOrderItemIssuance.get(0).Work_Order_Item__c;
                                    woiss.Issued_Quantity__c = item.reverseQuantity;
                                    woiss.Unit_Value__c = item.item.Item__r.unit_cost__c;
                                    woiss.Inventory_UoM__c = item.item.Item__r.Inventory_UoM__c;
                                    woiss.Reversed_Transaction_ID__c = newTransaction.Id;
                                    woiss.Work_Order_Issuance_Reversal__c = true;                             
                                    //woiss.Work_Order_Item__r.Completed_Issuance__c = false;
                                    
                                    //Add Work Order Item Issuances to the list
                                    issuances.add(woiss);
                                    
                                }//End if(lineItems.size()>0 && lineItems!=null)
                                
                                //Get the Work Order Item
                                Work_Order_Item__c workOrderItem = [SELECT id,Name ,BOM_Name__c,Inventory_Item__r.Inventory_UoM__c, Work_Order__c, 
                                                                    Inventory_Item__c,Inventory_Item__r.unit_cost__c ,Inventory_Item__r.Item_Group__c,
                                                                    BOM_Quantity__c, Currency__c,Lot__c,Inventory_Item__r.Name,
                                                                    Issued_Quantity__c, Pending_Quantity__c,unit_cost__c,Completed_Issuance__c                                                  
                                                                    FROM Work_Order_Item__c 
                                                                    WHERE  Work_Order__c =: this.workOrder.Id
                                                                    AND Inventory_Item__c =: item.item.Item__c
                                                                    LIMIT 1
                                                                   ];
                                
                                //UPDATE Work_Order_Item__c
                                workOrderItem.Completed_Issuance__c = false;
                                
                                //Add Work_Order_Item__c to the list
                                workOrderItems.add(workOrderItem);                                
                                
                            }else{
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The Work Order Issuance reversal was not successful');
                                ApexPages.addmessage(msg);
                                return null;
                            }//End if(newTransaction.Transaction_ID__c=='WOISSEXPRVS')                    
                            
                            //UPDATE the new Inventory Transaction created 
                            newTransaction.Transaction_Reversed__c = true;
                            UPDATE newTransaction;
                            
                            //UPDATE the Inventory Transaction selected by the user from the Visual Force Page
                            item.item.Reversed_Transaction_ID__c=newTransaction.Id;
                            UPDATE item.item;
                            
                        } else {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts for ' + woTransaction);
                            ApexPages.addmessage(msg);
                            return null;
                        }//End if(debitGl != null && creditGl != null)
                        
                    }else{
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The quantity reversed is incorrect!');
                        ApexPages.addmessage(msg);
                        return null;
                    }//End if(item.reverseQuantity > 0 && item.reverseQuantity <= item.item.Transaction_Quantity__c)
                    
                }//End if(item.selected==true)
                
            }//End for(ItemWrapper item : inventoryTransactions)
            
            //Insert Work Order Item Issuances
            INSERT issuances;
            
            //UPDATE Work Order Item        
            UPDATE workOrderItems;            
            
            //***********************
            Double quantityIssued;
            Double quantityPending;            
            
            //Check if any issuances have been done, if none set no Issuance
            AggregateResult[] QtyIssuedResults = 
                [SELECT SUM(Issued_Quantity__c)IssuedQty FROM Work_Order_Item__c WHERE Work_Order__c =: workOrder.Id];     
            
            quantityIssued = double.valueOf(QtyIssuedResults[0].get('IssuedQty'));
            
            System.debug('Issued_Quantity__c: '+quantityIssued);
            
            //Check if Quantity Issued > 0
            if(quantityIssued == NULL || quantityIssued == 0){
                workOrder.Issue_Status__c = 'Unissued';
            }else{
                //issuance records exist, check if sum of pending qty > 0
                AggregateResult[] QtyPendingResults = 
                    [SELECT SUM(Pending_Quantity__c)PendingQty FROM Work_Order_Item__c WHERE Work_Order__c =: workOrder.Id AND Completed_Issuance__c = false ];
                
                quantityPending  = double.valueOf(QtyPendingResults[0].get('PendingQty'));
                
                System.debug('Pending_Quantity__c: '+quantityPending);                
                
                //Check if Quantity Pending > 0
                if(quantityPending == NULL || quantityPending > 0 ){
                    workOrder.Issue_Status__c = 'Partial Issuance';
                }else{
                    workOrder.Issue_Status__c = 'Complete Issuance';
                }//End if(quantityPending == NULL || quantityPending > 0 )               
            }//End if(quantityIssued == NULL || quantityIssued == 0)
            
            UPDATE workOrder; 
            //************************            
            
        }//End if(inventoryTransactions != null && inventoryTransactions.size() > 0)       
        
        return new PageReference('/' + workOrder.Id);
    }// End reverseWorkOrderIssuanceWOISSEXP()    
    
    public class ItemWrapper{
        
        @TestVisible public Inventory_Transaction__c item {get; set;}      
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