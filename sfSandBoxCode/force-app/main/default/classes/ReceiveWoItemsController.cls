public class ReceiveWoItemsController{
    
    @TestVisible private ApexPages.StandardController standardController;
    @TestVisible private Work_Order__c workOrder {get; set;}
    @TestVisible private List<ItemWrapper> workOrderByProducts {get; set;}    
    @TestVisible public String reasonForIssueVariance {get; set;}    
    @TestVisible public String reasonForReceiptVariance {get; set;}
    @TestVisible public Double receiveQuantity1 {get; set;}
    @TestVisible public Double pendingQuantity {get; set;}  
    @TestVisible public Double ReceivedCost {get; set;}  
    @TestVisible public Double quantityToManufacture {get; set;}  
    @TestVisible public String transactionType {get; set;}    
    @TestVisible public String site {get; set;}
    @TestVisible public String location {get; set;}
    @TestVisible public String lot {get; set;}   
    @TestVisible public Work_Order_Receipts__c receipt {get; set;}
    @TestVisible public Boolean serviceWO {get; set;}	//Service WO	---was installationWo	
    @TestVisible public Boolean manufacturedWO {get; set;}	// Manufactured WO		---was otherWo
    @TestVisible public Boolean disassemblyWO {get; set;}	// Disassembly WO		---disassemblyWo    
    @TestVisible List<Work_Order_Item__c> workOrderItems {get; set;}
    @TestVisible List<Work_Order_Item_Issue__c> issuances {get; set;}
    @TestVisible public List<Group_Details__c> glas{get; set;}
    @TestVisible public Decimal unitCost;
    
    
    public ReceiveWoItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.workOrder = (Work_Order__c)standardController.getRecord();
        
        this.workOrder = [SELECT Id, Name, Inventory_Item__c, Inventory_Item_Quantity__c, Status__c,
                          Material_Cost__c, Inventory_Item__r.Default_Site__c,Pending_Quantity__c, 
                          Inventory_Item__r.Default_Location__c, Inventory_Item__r.Name,Unit_Cost__c,
                          UOM__c, Inventory_Item__r.Default_Lot__c, Inventory_Item__r.unit_cost__c,
                          Inventory_Item__r.Inventory_UoM__c, Inventory_Item__r.Item_Group__c,
                          Issue_Variance__c,Receipt_Variance__c, Work_Order_Type__c,Total_Cost__c,Received_Quantity__c,
                          Dimension_1__c,Dimension_2__c,Dimension_3__c,Dimension_4__c,Actual_Issued_Material_Cost__c,
                          Inventory_Item__r.WO_Receipt_Variance_Acceptable__c,Work_Order__c
                          FROM Work_Order__c
                          WHERE Id = :this.workOrder.Id
                         ];
        
        this.receiveQuantity1 = this.workOrder.Pending_Quantity__c;
        this.site = this.workOrder.Inventory_Item__r.Default_Site__c;
        this.location = this.workOrder.Inventory_Item__r.Default_Location__c;
        this.lot = this.workOrder.Inventory_Item__r.Default_Lot__c;
        this.receipt = new Work_Order_Receipts__c();
        this.serviceWO = this.workOrder.Work_Order_Type__c == 'WO-Service' ? true : false;        
        this.manufacturedWO = this.workOrder.Work_Order_Type__c == 'WO-Manufactured' ? true : false;
        this.disassemblyWO = this.workOrder.Work_Order_Type__c == 'WO-Disassembly' ? true : false; 
        
        this.pendingQuantity = this.workOrder.Pending_Quantity__c;
        this.quantityToManufacture = this.workOrder.Inventory_Item_Quantity__c;
        this.ReceivedCost = 0.00;
        
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
    
    @TestVisible public List<Work_Order_Item__c> getWorkOrderItems() {
        
        this.workOrderItems = [SELECT Id, Name, Inventory_Item__r.Name,Inventory_UoM__c,Percentage_Variance__c,
                               BOM_Quantity__c,Issued_Quantity__c,Pending_Quantity__c,Completed_Issuance__c
                               FROM Work_Order_Item__c
                               WHERE Work_Order__c = :this.workOrder.Id
                               AND Pending_Quantity__c > 0
                              ];
        return this.workOrderItems;
    }
    
    public List<ItemWrapper> getWorkOrderByProducts(){
        
        if(workOrderByProducts == null) {
            
            workOrderByProducts = new List<ItemWrapper>();
            
            List<Work_Order_By_product__c> lineItems = [SELECT Id, Name, Parent_Item__c,By_product_Item__c,
                                                        By_product_Item__r.Name,By_product_Item__r.Default_Site__c,
                                                        By_product_Item__r.Inventory_UoM__r.Name,
                                                        By_product_Item__r.Item_Group__c,
                                                        By_product_Item__r.unit_cost__c,
                                                        By_product_Item__r.Default_Site__r.Name,
                                                        By_product_Item__r.Default_Location__c,
                                                        By_product_Item__r.Default_Lot__c
                                                        FROM Work_Order_By_product__c
                                                        WHERE Parent_Item__c =: this.workOrder.Inventory_Item__c
                                                       ];
            
            for(Work_Order_By_product__c lineItem : lineItems){
                ItemWrapper wrapper = new ItemWrapper(lineItem);
                workOrderByProducts.add(wrapper);
            }
            
        } 
        system.debug('+++++++++++++++++++++getWorkOrderByProducts+++++++++++++++' + workOrderByProducts);
        
        return workOrderByProducts;
    }       
    
    
    
    @TestVisible public List<Work_Order_Item_Issue__c> getIssuedItems() {
        
        this.issuances = [Select Id, Name, Inventory_UoM__r.Name, Issued_Quantity__c,
                          Issued_Value__c, Unit_Value__c,
                          Work_Order_Item__r.Inventory_Item__r.Name
                          From Work_Order_Item_Issue__c
                          WHERE Work_Order__c = :this.workOrder.Id
                         ];
        return this.issuances;
    }
    
    
    //Receive WO-Manufactured
    public PageReference ReceivingInventory(){
        this.transactionType = 'WORCPT';
        System.debug('RECEIVE QUANTITYxxx: ' );
        //Receive to Inventory
        // Create Inventory_Transaction__c
        
        if((quantityToManufacture == pendingQuantity) && (receiveQuantity1 == quantityToManufacture)){
            //check if the issuance is partial 
            //if its partial request for Issuance Variance 
            system.debug('Actual_Issued_Material_Cost__c'+this.workOrder.Actual_Issued_Material_Cost__c );
            if((this.workOrder.Actual_Issued_Material_Cost__c != this.workOrder.Work_Order__c) && ((reasonForIssueVariance == null) || (reasonForIssueVariance == ''))){
                system.debug('reasonForIssueVariance' + reasonForIssueVariance);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide the Issuance Variance');
                ApexPages.addmessage(msg); 
                system.debug('msg' + msg);
                return null;
            }
            
            else{
                //unit cost for a full receipt
                unitCost= this.workOrder.Actual_Issued_Material_Cost__c / quantityToManufacture;
            }
        }
        else if((quantityToManufacture != pendingQuantity) && (receiveQuantity1 == pendingQuantity)){
            //unit cost for the last receipt in a partial receipt
            
            
            //check if the issuance is partial 
            //if its partial request for Issuance Variance                        
            if((this.workOrder.Actual_Issued_Material_Cost__c != this.workOrder.Work_Order__c) && ((reasonForIssueVariance == null) || (reasonForIssueVariance == ''))){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide the Issuance Variance');
                ApexPages.addmessage(msg); 
                return null;
            } 
            
            else{
                double ReceivedCost = (this.workOrder.Work_Order__c / quantityToManufacture) * this.workOrder.Received_Quantity__c;
                unitCost = (this.workOrder.Actual_Issued_Material_Cost__c  - ReceivedCost) / receiveQuantity1;
            }
            
        }
        else{
            //unit cost for partial receipt which is not the last receipt
            unitCost= this.workOrder.Work_Order__c / quantityToManufacture;   
        }
        if(unitCost != null){
            receiveToInventory();
        }
        
        // Check if workOrderByProducts!=null
        if(workOrderByProducts!=null && workOrderByProducts.size()>0){
            receiveByProductsToInventory();
        }
        
        return new PageReference('/' + workOrder.Id); 
    }
    
    public void receiveToInventory(){
        System.debug('RECEIVE QUANTITY: ' + this.receiveQuantity1);
        
        if(this.receiveQuantity1 == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Manufactured quantity is Zero'));
            //return null;
        }
        
        if(this.receiveQuantity1 <= this.workOrder.Inventory_Item_Quantity__c && this.receiveQuantity1 != null && this.site != null && this.location != null && this.lot != null){
            System.debug('RECEIVE QUANTITYXXXXXXXXXXXXXXXXXXXXXX: ' + receiveQuantity1 );
            System.debug('InventoryItemQuantityXXXXXXXXXXXXXXXXXXXXXX: ' + this.workOrder.Inventory_Item_Quantity__c );
            System.debug('locationXXXXXXXXXXXXXXXXXXXXXX: ' + this.location );
            System.debug('siteXXXXXXXXXXXXXXXXXXXXXX: ' + this.site );
            System.debug('lotXXXXXXXXXXXXXXXXXXXXXX: ' + this.lot );
            
            
            
            if(this.workOrder.Inventory_Item__r.Inventory_UoM__c != null) {
                System.debug('RECEIVE QUANTITYfff: ');
                String locationId = null;
                String lotId = null;
                
                List<Inventory_Item_Location__c> locs = [SELECT Id, Name FROM Inventory_Item_Location__c
                                                         WHERE Inventory_Item__c = :workOrder.Inventory_Item__c
                                                         AND Location_Name__c = :this.location
                                                         AND Location__c = :site
                                                        ];
                
                if(locs.size() > 0){
                    locationId = locs.get(0).Id;
                } else{
                    Inventory_Item_Location__c loc =new Inventory_Item_Location__c(
                        Inventory_Item__c = workOrder.Inventory_Item__c,
                        Location_Name__c = location,
                        Location__c = site
                    );
                    insert loc;
                    locationId = loc.Id;
                }
                
                List<Item_Location_Lot__c> lots = [SELECT Id, Name FROM Item_Location_Lot__c
                                                   WHERE Name = : this.lot
                                                   AND Item_Location__c = :locationId
                                                  ];
                
                if(lots.size() > 0){
                    lotId = lots.get(0).Id;
                } else{
                    Item_Location_Lot__c lot =new Item_Location_Lot__c(
                        Item_Location__c = locationId,
                        Lot_Name__c = lot,
                        Quantity__c = 0
                    );
                    insert lot;
                    lotId = lot.Id;
                }
                
                //check transaction Type
                System.debug('RECEIVE QUANTITfgggg: ' + this.transactionType );
                List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                               FROM Group_Details__c
                                               WHERE Inventory_Item_Group__c = :this.workOrder.Inventory_Item__r.Item_Group__c
                                               AND Transaction_ID__c =: this.transactionType
                                               AND Is_GL_Account__c = true
                                              ];
                if(glas.size() == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The item configuration is missing either credit or debit GL Accounts'));
                    //return null;                       
                }
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
                    
                    System.debug('TOTAL COST: ' + this.workOrder.Total_Cost__c);
                    system.debug('Unit Cost Name' + this.workOrder.Inventory_Item__r.Name);
                    System.debug('RECEIVE QUANTITY: ' + receiveQuantity1);
                    
                    
                    
                    Inventory_Transaction__c trans = new Inventory_Transaction__c();
                    trans.Item__c = workOrder.Inventory_Item__c;
                    trans.Transaction_ID__c = this.transactionType;
                    trans.Location__c = locationId;
                    trans.Location_Lot__c = lotId;
                    trans.Transaction_Quantity__c = receiveQuantity1;
                    //trans.Item_Unit_Price__c = this.workOrder.Unit_Cost__c  
                    trans.Item_Unit_Price__c =  unitCost;                
                    trans.Quantity_Impact__c = 'I';
                    trans.Debit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;
                    trans.Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                    trans.Dimension_1__c = this.workOrder.Dimension_1__c;
                    trans.Dimension_2__c = this.workOrder.Dimension_2__c;
                    trans.Dimension_3__c = this.workOrder.Dimension_3__c;
                    trans.Dimension_4__c = this.workOrder.Dimension_4__c;
                    trans.Comments__c = workOrder.Inventory_Item__r.Name;
                    trans.Work_Order__c = workOrder.Id;
                    INSERT trans;
                    
                    //ONly insert receipt record if receiving items
                    if(this.transactionType =='WORCPT' && trans.Id != null){
                        
                        this.receipt.Work_Order__c = workOrder.Id;
                        this.receipt.Receive_Site__c = site;
                        this.receipt.Receive_Location__c = locationId;
                        this.receipt.Receive_Lot__c = lotId;
                        this.receipt.Receive_Quantity__c = receiveQuantity1;
                        this.receipt.Inventory_Transaction__c = trans.Id;
                        this.receipt.Total_Cost__c = trans.Item_Unit_Price__c * receiveQuantity1;
                        this.receipt.Primary_Item_in_Work_Order__c = true;                        
                        INSERT receipt;
                        
                        /*Double d = workOrder.Inventory_Item_Quantity__c - this.receipt.Receive_Quantity__c;
workOrder.Inventory_Item_Quantity__c = d;
update workOrder;*/
                        
                        
                        
                        
                    } 
                    else {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The Work Order receipt was not successful');
                        ApexPages.addmessage(msg);
                    }
                    
                }else {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts');
                    ApexPages.addmessage(msg);
                }
                
                
            }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The UOM Conversion is incorrect for the item being received');
                ApexPages.addmessage(msg);
            }              
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Your Receive Quantity is more than the Manufactured Quantity. Please adjust'));
            
        }
        
        this.workOrder.Issue_Variance__c = reasonForIssueVariance;
        update this.workOrder;
        // return new PageReference('/' + workOrder.Id); 
    }// End receiveToInventory()
    
    public void receiveByProductsToInventory(){
        
        // Check if workOrderByProducts!=null
        if(workOrderByProducts!=null && workOrderByProducts.size()>0){
            system.debug('workOrderByProducts' + workOrderByProducts);
            for(ItemWrapper woBp: workOrderByProducts){
                System.debug('INSIDE workOrderByProducts LOOP: ' + woBp.receiveQuantity2 );
                //Only process By-products whose receive quantity is greater than 0  
                if(woBp.receiveQuantity2 > 0){
                    
                    System.debug('BY PRODUCT ITEM DEFAULT SITE : ' + woBp.item.By_product_Item__r.Default_Site__r.Name);                
                    
                    //*******************************************************************************
                    List<Inventory_Item_Location__c> locs = [SELECT Id, Name 
                                                             FROM Inventory_Item_Location__c
                                                             WHERE Inventory_Item__c =:woBp.item.By_product_Item__c
                                                             AND Location_Name__c =:woBp.location2
                                                             AND Location__c = :woBp.item.By_product_Item__r.Default_Site__c
                                                            ];
                    
                    System.debug('BY PRODUCT ITEM location2: '+ woBp.location2 +  + 'BY PRODUCT ITEM: '+ woBp.item.By_product_Item__r.Name);
                    System.debug('Inventory_Item_Location__c ' + locs);
                    
                    if(locs.size() > 0){
                        woBp.locationId2 = locs.get(0).Id;
                    } else{
                        
                        Inventory_Item_Location__c loc =new Inventory_Item_Location__c(
                            Inventory_Item__c = woBp.item.By_product_Item__c,
                            Location_Name__c = woBp.location2,
                            Location__c = woBp.site2
                        );
                        
                        INSERT loc;
                        woBp.locationId2 = loc.Id;
                        // Location__c = woBp.item.By_product_Item__r.Default_Site__c
                        
                        //System.debug('locationId2: ' + woBp.locationId2 + 'BY PRODUCT ITEM: '+ woBp.item.By_product_Item__r.Name);
                    }
                    
                    System.debug('BY PRODUCT ITEM locationId2: ' + woBp.locationId2 + 'BY PRODUCT ITEM: '+ woBp.item.By_product_Item__r.Name);
                    
                    System.debug('BY PRODUCT ITEM lot2: '+ woBp.lot2 +  + 'BY PRODUCT ITEM: '+ woBp.item.By_product_Item__r.Name);
                    
                    List<Item_Location_Lot__c> lots = [SELECT Id, Name 
                                                       FROM Item_Location_Lot__c
                                                       WHERE Name = :woBp.lot2
                                                       AND Item_Location__c = :woBp.locationId2
                                                      ];
                    
                    System.debug('Item_Location_Lot__c ' + lots);
                    
                    if(lots.size() > 0){
                        woBp.lotId2 = lots.get(0).Id;
                    } else{
                        
                        Item_Location_Lot__c lot =new Item_Location_Lot__c(
                            Item_Location__c = woBp.locationId2,
                            Lot_Name__c = woBp.lot2,
                            Quantity__c = 0
                        );
                        INSERT lot;
                        woBp.lotId2 = lot.Id;
                        //System.debug('lotId2: ' + woBp.lotId2);
                    } 
                    
                    System.debug('BY PRODUCT ITEM lotId2: ' + woBp.lotId2 + 'BY PRODUCT ITEM: '+ woBp.item.By_product_Item__r.Name);
                    //*******************************************************************************
                    
                    glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                            FROM Group_Details__c
                            WHERE Inventory_Item_Group__c =:woBp.item.By_product_Item__r.Item_Group__c
                            AND Transaction_ID__c =:this.transactionType
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
                    System.debug('$$$$$$$$$$$$$$$$$woBp.Credit_Debit__c: ' + creditGl);
                    System.debug('woBp.item.Credit_Debit__c' + debitGl);
                    
                    // Check if debitGl != null && creditGl != null
                    if(debitGl != null && creditGl != null){
                        
                        
                        // Create Inventory_Transaction__c
                        Inventory_Transaction__c trans2 = new Inventory_Transaction__c();
                        trans2.Item__c = woBp.item.By_product_Item__c;
                        trans2.Transaction_ID__c = this.transactionType;
                        trans2.Location__c = woBp.locationId2;
                        trans2.Location_Lot__c = woBp.lotId2;
                        trans2.Transaction_Quantity__c = woBp.receiveQuantity2;
                        trans2.Item_Unit_Price__c = woBp.item.By_product_Item__r.unit_cost__c;
                        trans2.Quantity_Impact__c = 'I';
                        trans2.Debit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;
                        trans2.Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                        trans2.Dimension_1__c = this.workOrder.Dimension_1__c;
                        trans2.Dimension_2__c = this.workOrder.Dimension_2__c;
                        trans2.Dimension_3__c = this.workOrder.Dimension_3__c;
                        trans2.Dimension_4__c = this.workOrder.Dimension_4__c;
                        trans2.Comments__c = woBp.item.By_product_Item__r.Name;
                        trans2.Work_Order__c = workOrder.Id;
                        INSERT trans2;
                        
                        //ONly insert receipt record if receiving items
                        if(this.transactionType =='WORCPT' && trans2.Id != null){
                            
                            //Create Work_Order_Receipts__c
                            Work_Order_Receipts__c woReceipt = new Work_Order_Receipts__c();
                            woReceipt.Work_Order__c = workOrder.Id;
                            woReceipt.Receive_Site__c = woBp.item.By_product_Item__r.Default_Site__c;
                            woReceipt.Receive_Location__c = woBp.locationId2;
                            woReceipt.Receive_Lot__c = woBp.lotId2;
                            woReceipt.Receive_Quantity__c = woBp.receiveQuantity2;
                            woReceipt.Inventory_Transaction__c = trans2.Id;                                
                            INSERT woReceipt;
                            
                        } 
                        
                        else {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The Work Order receipt was not successful');
                            ApexPages.addmessage(msg);
                        }
                        
                    }else {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts');
                        ApexPages.addmessage(msg);
                    }// End if debitGl != null && creditGl != null
                    
                }//End if(woBp.receiveQuantity2 > 0)                
                
            }//End for() 
        }// End if workOrderByProducts!=null        
        
    }
    
    //Close - WO Service
    public PageReference closeInstallationWo(){
        //this.transactionType = 'WOCLOSE';
        //Receive to Inventory
        //receiveToInventory(); 
        //String varianceReason = this.workOrder.Receipt_Variance__c;
        
        if(this.workOrder.Status__c != 'Closed'){            
            System.debug('workOrder.Work_Order_Type__c: ' + workOrder.Work_Order_Type__c);
            System.debug('workOrder.Pending_Quantity__c: ' + workOrder.Pending_Quantity__c);
            System.debug('reasonForIssueVariance: ' + reasonForIssueVariance);
            System.debug('reasonForReceiptVariance: ' + reasonForReceiptVariance);
            
            if(workOrder.Work_Order_Type__c=='WO-Manufactured' && workOrderItems.size() > 0
               && String.isEmpty(reasonForIssueVariance)){
                   
                   ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Provide a reason for the Issue Variance.');
                   ApexPages.addmessage(msg);
                   return null;
               }else if(workOrder.Work_Order_Type__c=='WO-Manufactured' && workOrder.Pending_Quantity__c > 0 
                        && String.isEmpty(reasonForReceiptVariance) 
                        && workOrder.Inventory_Item__r.WO_Receipt_Variance_Acceptable__c==false){
                            
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Provide a reason for the Receipt Variance.');
                            ApexPages.addmessage(msg);
                            return null;                
                        }
            else{
                workOrder.Status__c = 'Closed';                
                workOrder.Issue_Variance__c= reasonForIssueVariance;
                workOrder.Receipt_Variance__c = reasonForReceiptVariance;
                UPDATE workOrder;
                
                //Redirect user to the next page
                return new PageReference('/' + workOrder.Id);
            }                        
        } else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'This Work Order is already Closed');
            ApexPages.addmessage(msg);
        }
        
        return null;
    }
    
    public class ItemWrapper{
        
        @TestVisible public Work_Order_By_product__c item {get; set;}
        @TestVisible public String site2 {get; set;}
        @TestVisible public String location2 {get; set;}
        @TestVisible public String lot2 {get; set;}        
        @TestVisible public Double receiveQuantity2 {get; set;}
        @TestVisible public String locationId2 {get; set;}
        @TestVisible public String lotId2 {get; set;}        
        @TestVisible public List<SelectOption> locations {get; set;}
        
        
        public ItemWrapper(Work_Order_By_product__c itm) {
            item = itm;
            site2 = item.By_product_Item__r.Default_Site__c;
            location2 = item.By_product_Item__r.Default_Location__c;
            lot2 = item.By_product_Item__r.Default_Lot__c;
            receiveQuantity2 = 0;
        }
        
        @TestVisible public void setItemLocations() {
            this.locations = new List<SelectOption>();
            SelectOption defopt = new SelectOption('NA', '----------');
            locations.add(defopt);
            
            if(site2 != null && !site2.equals('NA')){
                List<Inventory_Item_Location__c> locs = [Select Id, Name
                                                         From Inventory_Item_Location__c
                                                         WHERE Inventory_Item__c =: this.item.By_product_Item__c
                                                         AND Location__c = :this.site2
                                                        ];                
                
                for(Inventory_Item_Location__c location : locs){
                    SelectOption option = new SelectOption(location.Id, location.Name);
                    locations.add(option);
                }
            }
        }        
    }// ItemWrapper
    
    public class TestWrapper{
        @TestVisible public Work_Order_By_product__c item1 {get; set;}
        @TestVisible public Double x {get; set;}
        @TestVisible public Double y {get; set;}
        @TestVisible public Double z {get; set;}        
        
        
        
        public TestWrapper(Work_Order_By_product__c it) {
            item1 = it;
            x = 6;
            y = 4;
            z = 7;
        }
    }
}