public class RecurringService {
	public String inputText{get;set;}    
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    //Recurring Service
    public Recurring_Service__c recurringService {get; set;} 
    
    //Recurring Service Line Items
    public Recurring_Service_Line_Item__c recurringServiceItem {get; set;}
    public Recurring_Service_Line_Item__c recurringServiceItemSLK {get; set;}
    public Recurring_Service_Line_Item__c recurringServiceItemFLI {get; set;}    
    public List<RecurringServiceLineItem> recurringServiceLineItemListSLK {get; set;}
    public List<RecurringServiceLineItem> recurringServiceLineItemListFLI {get; set;}
    public List<RecurringServiceLineItem> allRecurringServiceLineItemList {get; set;}    
    
    //Recurring Service Line Items PR Line Items
    public List<Recurring_Service_PR_Item__c> addRSPRListSLK  {get;set;}
    public List<Recurring_Service_PR_Item__c> addRSPRListFLI  {get;set;}    
    public List<Recurring_Service_PR_Item__c> delRSPRListSLK {get;set;}
    public List<Recurring_Service_PR_Item__c> delRSPRListFLI {get;set;}    
    public List<Recurring_Service_PR_Item__c> RSPRListSLK  {get;set;}
    public List<Recurring_Service_PR_Item__c> RSPRListFLI  {get;set;}     
    public Recurring_Service_PR_Item__c recurringServicePRItemSLK {get; set;}
    public Recurring_Service_PR_Item__c recurringServicePRItemFLI {get; set;}
    public Recurring_Service_PR_Item__c recurringServicePRItem {get; set;}    
     
    public Recurring_Service_PR_Item__c del;
    public ID RSLineItemId {get; set;}    
    public ID RSLineItemIdSLK {get; set;}
    public ID RSLineItemIdFLI {get; set;}
    public Integer rowIndexSLK {get;set;}  
    public Integer rowIndexFLI {get;set;}
       
    //@TestVisible public String company {get; set;}
    @TestVisible public Boolean sharedService {get; set;}
    @TestVisible public Boolean consumptionUnits {get; set;}
    @TestVisible public Boolean showStep2Button {get; set;}
    @TestVisible public Boolean showStep3Button {get; set;}
    
    @TestVisible public Date billingDate {get; set;}
    //@TestVisible public Integer quantity {get;set;}
    //@TestVisible public Integer unitPrice {get;set;}
    //@TestVisible public Integer sum {get;set;}    
    //@TestVisible public Integer price {get; set;}       
    //@TestVisible public Integer totalPrice {get; set;}

    private String RSTagId;    
    
    // Constructor
    public RecurringService(ApexPages.StandardController controller){               
        this.controller=controller; 
        rowIndexSLK = 0;
        rowIndexFLI = 0;
        
        recurringService = [SELECT Id,Name,Purchase_Order_Item_SLK__c,Purchase_Order_Item_FLI__c,
                            Cost_Per_Unit__c,Vatable__c,VAT_Inclusive__c,VAT_Percentage__c,
                            Shared_service__c,Consumption_Units__c,SLK_percentage_value__c,
                            FLI_percentage_value__c,Dim_2__c,Dim_3__c,Grant__c,GLA__c,Billing_Units__c,
                            Vendor__c,Requestor__c,Requesting_Department__c,Billing_Type__c,Service_Name__c,
                            Maintenance_Department__c,SLK_Total_Price__c,FLI_Total_Price__c,FLI_SLK_Total_Price__c                            
                            FROM Recurring_Service__c
                            WHERE Id =: getRSId()];
        
        recurringServiceItem = new Recurring_Service_Line_Item__c();
        getRecurringServiceLineItemsSLK();
        getRecurringServiceLineItemsFLI();
        getRSLIPRRows();
        
		//Check if this is a shared Recurring Service 
        this.sharedService = this.recurringService.Shared_service__c == true ? true : false;
        
		//Check if the consumption units are fixed or variable
        this.consumptionUnits = this.recurringService.Consumption_Units__c == 'Variable' ? true : false;       
        
        if(this.recurringService.Billing_Type__c == 'Fixed value' && this.recurringService.Consumption_Units__c == 'Fixed value'){
            //Activate Create PR Button
            this.showStep3Button = true;  
        }else{            
            //Activate Create Recurring Service PR Item Button
            this.showStep2Button = true;              
        }  
        
        delRSPRListSLK = new List<Recurring_Service_PR_Item__c>();
        delRSPRListFLI = new List<Recurring_Service_PR_Item__c>();
        
        //Get Recurring Service Line Items
        //getRecurringServiceLineItems();
    }
    
    //method to set the RSId
    public String getRSId(){
        
        String RSId = ''; 
        String strRSTagId = apexpages.currentpage().getparameters().get('RSTag');
        RSLineItemIdFLI = NULL;
        RSLineItemIdSLK = NULL;
        
        if(strRSTagId == null || strRSTagId == '' || strRSTagId == ' '){
            RSId = apexpages.currentpage().getParameters().get('id');
            System.debug('INSIDE IF STATEMENT:' + RSId);
        }else{
            
            List<Recurring_Service_Line_Item__c> RSLI = [SELECT ID,Recurring_Service__c,Requesting_Company__c
                                                         FROM Recurring_Service_Line_Item__c 
                                                         WHERE RS_Tag__c =: strRSTagId
                                                        ];
            
            if(RSLI.size() > 0){
                
                //Set RSId
                RSId = RSLI.get(0).Recurring_Service__c;
                
                // Loop through the list
                for(Recurring_Service_Line_Item__c lineItem: RSLI){                    
                    
                    if(lineItem.Requesting_Company__c == 'aEBD0000000kA4j'){
                        //FLI
                        RSLineItemIdFLI = lineItem.Id;
                        System.debug('getRSIdFLI(): ' + RSLineItemIdFLI);
                    }
                    
                    if(lineItem.Requesting_Company__c == 'aEBD0000000k9yM'){
                        //SLK
                        RSLineItemIdSLK = lineItem.Id;
                        System.debug('getRSIdSLK(): ' + RSLineItemIdSLK);
                    }                    
                }
                
            }            
            //RSId = RSLI.Recurring_Service__c;
            System.debug('RSId: ' + RSId);
        }         

        return RSId;
    }    
    
    //Create Recurring Service Line Item
    public PageReference createRecurringServiceLineItem(){
        Purchase_Order_Item__c poItemSLK;
        Purchase_Order_Item__c poItemFLI;
        
        datetime dt = datetime.now();
        String formattedDate = dt.format('YYYYMMdd-HHmmss');
        
        String RSTag = recurringService.Name + '-' + formattedDate;
        
        //Get SLK PO Item        
        if(recurringService.Purchase_Order_Item_SLK__c != NULL){
            poItemSLK = [SELECT Id,Name,Inventory_Item__c,Inventory_Item__r.Item_Description__c,
                         Contract_Number__c
                         FROM Purchase_Order_Item__c
                         WHERE Id =: recurringService.Purchase_Order_Item_SLK__c
                         LIMIT 1]; 
        }
        
        //Get FLI PO Item
        if(recurringService.Purchase_Order_Item_FLI__c != NULL){
            poItemFLI = [SELECT Id,Name,Inventory_Item__c,Inventory_Item__r.Item_Description__c,
                         Contract_Number__c
                         FROM Purchase_Order_Item__c
                         WHERE Id =: recurringService.Purchase_Order_Item_FLI__c
                         LIMIT 1];
        }
        
        //Check if the Recurring Service is shared
        if(this.sharedService){
            //*********************************************START SHARED SERVICE****************************************************
			//company = 'Sanergy & Fresh Life'; 
            
            if(recurringService.Billing_Type__c == 'Fixed value' && recurringService.Consumption_Units__c == 'Fixed value'){                
                
                //*****************************Shared Service - Fixed*********************************
                //Create an instance of Recurring Service Line Item for SLK
                recurringServiceItemSLK = new Recurring_Service_Line_Item__c();
                recurringServiceItemSLK.Recurring_Service__c = recurringService.Id;           
                recurringServiceItemSLK.Item__c = poItemSLK.Inventory_Item__r.Item_Description__c;
                recurringServiceItemSLK.Billing_Date__c = this.billingDate + 8;
                recurringServiceItemSLK.RS_Tag__c = RSTag;
                recurringServiceItemSLK.Vatable__c = recurringService.Vatable__c;
                recurringServiceItemSLK.VAT_Inclusive__c = recurringService.VAT_Inclusive__c;
                recurringServiceItemSLK.VAT_Percentage__c = recurringService.VAT_Percentage__c;
                recurringServiceItemSLK.Requesting_Company__c = 'aEBD0000000k9yM';
                recurringServiceItemSLK.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_SLK__c;
                recurringServiceItemSLK.Currency__c = 'aHQD0000000blJJ';
                System.debug('BILLING DATE' + this.billingDate);
                recurringServiceItemSLK.Billing_Date__c = this.billingDate + 8;
                INSERT recurringServiceItemSLK;
                
                //Create an instance of Recurring Service Line Item for FLI
                recurringServiceItemFLI = new Recurring_Service_Line_Item__c();
                recurringServiceItemFLI.Recurring_Service__c = recurringService.Id;           
                recurringServiceItemFLI.Item__c = poItemFLI.Inventory_Item__r.Item_Description__c;
                recurringServiceItemFLI.Billing_Date__c = this.billingDate + 8;
                recurringServiceItemFLI.RS_Tag__c = RSTag;
                recurringServiceItemFLI.Vatable__c = recurringService.Vatable__c;
                recurringServiceItemFLI.VAT_Inclusive__c = recurringService.VAT_Inclusive__c;
                recurringServiceItemFLI.VAT_Percentage__c = recurringService.VAT_Percentage__c;
                recurringServiceItemFLI.Requesting_Company__c = 'aEBD0000000kA4j';
                recurringServiceItemFLI.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_FLI__c;
                recurringServiceItemFLI.Currency__c = 'aHQD0000000blJJ';
                INSERT recurringServiceItemFLI;
                
                //Create an instance of Recurring Service PR Item - SLK
                recurringServicePRItemSLK = new Recurring_Service_PR_Item__c();
                recurringServicePRItemSLK.Recurring_Service_Line_Item__c = recurringServiceItemSLK.Id;
                recurringServicePRItemSLK.Quantity__c = recurringService.Billing_Units__c * (recurringService.SLK_percentage_value__c.setScale(5)/100);
                recurringServicePRItemSLK.Unit_Price__c = recurringService.Cost_Per_Unit__c;
                INSERT recurringServicePRItemSLK;

                //Create an instance of Recurring Service PR Item - FLI
                recurringServicePRItemFLI = new Recurring_Service_PR_Item__c();
                recurringServicePRItemFLI.Recurring_Service_Line_Item__c = recurringServiceItemFLI.Id;
                recurringServicePRItemFLI.Quantity__c = recurringService.Billing_Units__c * (recurringService.FLI_percentage_value__c.setScale(5)/100);
                recurringServicePRItemFLI.Unit_Price__c = recurringService.Cost_Per_Unit__c;
                INSERT recurringServicePRItemFLI;                
                
            }else{
                //*****************************Shared Service - Variable*********************************
                //Create an instance of Recurring Service Line Item for SLK
                recurringServiceItemSLK = new Recurring_Service_Line_Item__c();
                recurringServiceItemSLK.Recurring_Service__c = recurringService.Id;           
                recurringServiceItemSLK.Item__c = poItemSLK.Inventory_Item__r.Item_Description__c;
                recurringServiceItemSLK.Billing_Date__c = this.billingDate + 8;
                recurringServiceItemSLK.RS_Tag__c = RSTag;
                recurringServiceItemSLK.Vatable__c = recurringService.Vatable__c;
                recurringServiceItemSLK.VAT_Inclusive__c = recurringService.VAT_Inclusive__c;
                recurringServiceItemSLK.VAT_Percentage__c = recurringService.VAT_Percentage__c;
                recurringServiceItemSLK.Requesting_Company__c = 'aEBD0000000k9yM';
                recurringServiceItemSLK.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_SLK__c;
                recurringServiceItemSLK.Currency__c = 'aHQD0000000blJJ';
                INSERT recurringServiceItemSLK;
                
                //Create an instance of Recurring Service Line Item for FLI
                recurringServiceItemFLI = new Recurring_Service_Line_Item__c();
                recurringServiceItemFLI.Recurring_Service__c = recurringService.Id;           
                recurringServiceItemFLI.Item__c = poItemFLI.Inventory_Item__r.Item_Description__c;
                recurringServiceItemFLI.Billing_Date__c = this.billingDate + 8;
                recurringServiceItemFLI.RS_Tag__c = RSTag;
                recurringServiceItemFLI.Vatable__c = recurringService.Vatable__c;
                recurringServiceItemFLI.VAT_Inclusive__c = recurringService.VAT_Inclusive__c;
                recurringServiceItemFLI.VAT_Percentage__c = recurringService.VAT_Percentage__c;
                recurringServiceItemFLI.Requesting_Company__c = 'aEBD0000000kA4j';
                recurringServiceItemFLI.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_FLI__c;
                recurringServiceItemFLI.Currency__c = 'aHQD0000000blJJ';
                INSERT recurringServiceItemFLI;         
                
            }//End if(recurringService.Billing_Type__c == 'Fixed value' && recurringService.Consumption_Units__c == 'Fixed value')            
            
            //Get Recurring_Service_Line_Item IDs
            RSLineItemIdSLK = recurringServiceItemSLK.Id;
            RSLineItemIdFLI = recurringServiceItemFLI.Id;
            
            System.debug('RSLineItemIdSLK 1: ' + RSLineItemIdSLK);
            System.debug('RSLineItemIdFLI 2: ' + RSLineItemIdFLI);
            
            // Get Recurring Service Line Items
            //getRecurringServiceLineItemsSLK();
            //getRecurringServiceLineItemsFLI();

            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.INFO,'Successfully created Recurring Service Line Item');
            ApexPages.addmessage(successMessage);             
            
            //*********************************************END SHARED SERVICE****************************************************
        }else{         
            //*********************************************START UNSHARED SERVICE****************************************************
            
            if(recurringService.Billing_Type__c == 'Fixed value' && recurringService.Consumption_Units__c == 'Fixed value'){
                
                //*****************************UnShared Service - Fixed*********************************
                //Create an instance of Recurring Service Line Item
                recurringServiceItem = new Recurring_Service_Line_Item__c();
                recurringServiceItem.Recurring_Service__c = recurringService.Id;
                recurringServiceItem.Billing_Date__c = this.billingDate + 8;
                recurringServiceItem.RS_Tag__c = RSTag;
                recurringServiceItem.Vatable__c = recurringService.Vatable__c;
                recurringServiceItem.VAT_Inclusive__c = recurringService.VAT_Inclusive__c;
                recurringServiceItem.VAT_Percentage__c = recurringService.VAT_Percentage__c;
                recurringServiceItem.Currency__c = 'aHQD0000000blJJ';

                /*Get SLK PO Item        
                if(recurringService.Purchase_Order_Item_SLK__c != NULL){
                    recurringServiceItem.Item__c = poItemSLK.Inventory_Item__r.Item_Description__c;
                }
                //Get FLI PO Item        
                if(recurringService.Purchase_Order_Item_FLI__c != NULL){
                    recurringServiceItem.Item__c = poItemFLI.Inventory_Item__r.Item_Description__c;
                }*/            
                
                //Check if there's a value in SLK_percentage_value__c or FLI_percentage_value__c
                if(recurringService.SLK_percentage_value__c == 100 && recurringService.Purchase_Order_Item_SLK__c != null){
                    //Add Sanergy Limited
                    recurringServiceItem.Requesting_Company__c = 'aEBD0000000k9yM';
                    //company = 'Sanergy Limited';                
                    recurringServiceItem.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_SLK__c;
                    recurringServiceItem.Item__c = poItemSLK.Inventory_Item__r.Item_Description__c;
                }else if(recurringService.FLI_percentage_value__c == 100 && recurringService.Purchase_Order_Item_FLI__c != null){
                    //Add Fresh Life Initiative
                    recurringServiceItem.Requesting_Company__c = 'aEBD0000000kA4j';
                    //company = 'Fresh Life Initiative Limited'
                    recurringServiceItem.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_FLI__c;
                    recurringServiceItem.Item__c = poItemFLI.Inventory_Item__r.Item_Description__c;
                }             
                
                INSERT recurringServiceItem;
                
                //Create an instance of Recurring Service PR Item - SLK or FLI
                recurringServicePRItem = new Recurring_Service_PR_Item__c();
                recurringServicePRItem.Recurring_Service_Line_Item__c = recurringServiceItem.Id;
                
                // Check if company is Sanergy Limited
                if(recurringServiceItem.Requesting_Company__c == 'aEBD0000000k9yM'){                
                    recurringServicePRItem.Quantity__c = recurringService.Billing_Units__c * (recurringService.SLK_percentage_value__c.setScale(5)/100);
                }
                
                // Check if company is Fresh Life 
                if(recurringServiceItem.Requesting_Company__c == 'aEBD0000000kA4j'){                
                    recurringServicePRItem.Quantity__c = recurringService.Billing_Units__c * (recurringService.FLI_percentage_value__c.setScale(5)/100);
                }
                
                recurringServicePRItem.Unit_Price__c = recurringService.Cost_Per_Unit__c;
                INSERT recurringServicePRItem;         
                
            }else{
                //*****************************UnShared Service - Variable*********************************
                //Create an instance of Recurring Service Line Item
                recurringServiceItem = new Recurring_Service_Line_Item__c();
                recurringServiceItem.Recurring_Service__c = recurringService.Id;
                recurringServiceItem.Billing_Date__c = this.billingDate + 8;
                recurringServiceItem.RS_Tag__c = RSTag;
                recurringServiceItem.Vatable__c = recurringService.Vatable__c;
                recurringServiceItem.VAT_Inclusive__c = recurringService.VAT_Inclusive__c;
                recurringServiceItem.VAT_Percentage__c = recurringService.VAT_Percentage__c;
                recurringServiceItem.Currency__c = 'aHQD0000000blJJ';
                
                //Get SLK PO Item        
                if(recurringService.Purchase_Order_Item_SLK__c != NULL){
                    recurringServiceItem.Item__c = poItemSLK.Inventory_Item__r.Item_Description__c;
                }
                //Get FLI PO Item        
                if(recurringService.Purchase_Order_Item_FLI__c != NULL){
                    recurringServiceItem.Item__c = poItemFLI.Inventory_Item__r.Item_Description__c;
                }            
                
                //Check if there's a value in SLK_percentage_value__c or FLI_percentage_value__c
                if(recurringService.SLK_percentage_value__c != null && recurringService.FLI_percentage_value__c == null){
                    //Add Sanergy Limited
                    recurringServiceItem.Requesting_Company__c = 'aEBD0000000k9yM';
                    //company = 'Sanergy Limited';                
                    recurringServiceItem.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_SLK__c;
                }else if(recurringService.FLI_percentage_value__c != null && recurringService.SLK_percentage_value__c == null){
                    //Add Fresh Life Initiative
                    recurringServiceItem.Requesting_Company__c = 'aEBD0000000kA4j';
                    //company = 'Fresh Life Initiative Limited'
                    recurringServiceItem.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_FLI__c;
                }
                
                /*Check if the consumption units are fixed
                if(this.consumptionUnits){
                    //recurringServiceLineItem.Unit_Price__c = recurringServiceItem.Unit_Price__c;
                }else{
                    //recurringServiceLineItem.Unit_Price__c = recurringService.Cost_Per_Unit__c;
                }*/                 
                
                INSERT recurringServiceItem;                 
                
            }// End if(recurringService.Billing_Type__c == 'Fixed value' && recurringService.Consumption_Units__c == 'Fixed value')
            
            // Check if company is Sanergy Limited
            if(recurringServiceItem.Requesting_Company__c == 'aEBD0000000k9yM'){
                RSLineItemIdSLK = recurringServiceItem.Id;
                
                // Get Recurring Service Line Items
                getRecurringServiceLineItemsSLK();
            }
            
            // Check if company is Fresh Life 
            if(recurringServiceItem.Requesting_Company__c == 'aEBD0000000kA4j'){
                RSLineItemIdFLI = recurringServiceItem.Id;
                
                // Get Recurring Service Line Items
                getRecurringServiceLineItemsFLI();
            }
            
            System.debug('RSLineItemIdSLK 3: ' + RSLineItemIdSLK);
            System.debug('RSLineItemIdFLI 4: ' + RSLineItemIdFLI);
            
            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.INFO,'Successfully created Recurring Service Line Item');
            ApexPages.addmessage(successMessage);          
            
            //*********************************************END UNSHARED SERVICE****************************************************
        }
        
        //Create an instance of Pagereference & redirect user to VisualForce Page
        Pagereference pageRef = new PageReference('/apex/RecurringService');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('id',recurringService.Id);
        
        //Check if the Recurring Service is shared
        if(this.sharedService){
            pageRef.getParameters().put('RSTag',recurringServiceItemSLK.RS_Tag__c);
        }else{
            pageRef.getParameters().put('RSTag',recurringServiceItem.RS_Tag__c);
        }
        
        return pageRef;        
       
        //return null;
        //return new PageReference('/'+ recurringService.Id);
    }
    
    // Get SLK Recurring Service Line Items
    public void getRecurringServiceLineItemsSLK(){
        System.debug('RecurringService.Name: '+ recurringService.Name);
        
        if(recurringService.Name != null){
            
            recurringServiceLineItemListSLK = new List<RecurringServiceLineItem>();
            
            List<Recurring_Service_Line_Item__c> lineItemsSLK = [SELECT Id,Name,Item__c,Requesting_Company__c,Currency__c,RS_Tag__c,
                                                                 Requesting_Company__r.Name,Procurement_Request__c,Total_Price__c,Billing_Date__c,
                                                                 PR_Created__c,PO_Created__c,
                                                                 (SELECT Id,Name,Recurring_Service_Line_Item__c
                                                                  FROM Recurring_Service_PR_Items__r)
                                                                 FROM Recurring_Service_Line_Item__c
                                                                 WHERE Id =: RSLineItemIdSLK
                                                                 ORDER BY Name ASC];     
            
            for(Recurring_Service_Line_Item__c lineItem : lineItemsSLK){                
                //Add all records to the list
                recurringServiceLineItemListSLK.add(new RecurringServiceLineItem(lineItem));
            }//End for(Recurring_Service_Line_Item__c lineItem : lineItemsSLK)
            
        }//End if(recurringService.Name != null)
        
        //return null;
    }    
    
    // Get FLI Recurring Service Line Items
    public void getRecurringServiceLineItemsFLI(){
        System.debug('RecurringService.Name: '+ recurringService.Name);
        
        if(recurringService.Name != null){
            
            recurringServiceLineItemListFLI = new List<RecurringServiceLineItem>();
            
            List<Recurring_Service_Line_Item__c> lineItemsFLI = [SELECT Id,Name,Item__c,Requesting_Company__c,Currency__c,RS_Tag__c,
                                                                 Requesting_Company__r.Name,Procurement_Request__c,Total_Price__c,Billing_Date__c,
                                                                 PR_Created__c,PO_Created__c,
                                                                 (SELECT Id,Name,Recurring_Service_Line_Item__c
                                                                  FROM Recurring_Service_PR_Items__r)
                                                                 FROM Recurring_Service_Line_Item__c
                                                                 WHERE Id =: RSLineItemIdFLI
                                                                 ORDER BY Name ASC];     
            
            for(Recurring_Service_Line_Item__c lineItem : lineItemsFLI){                
                //Add all records to the list
                recurringServiceLineItemListFLI.add(new RecurringServiceLineItem(lineItem));
            }
        }
        
        //return null;
    }
    
    public void getRSLIPRRows(){
        System.debug('RSLineItemIdSLK: '+ RSLineItemIdFLI);
        System.debug('RSLineItemIdSLK: '+ RSLineItemIdSLK);
        
        if(rowIndexFLI==0){
            RSPRListFLI = [Select Id, Name, Recurring_Service_Line_Item__c, Recurring_Service_Line_Item__r.Recurring_Service__c,PO_Line_Item__c,
                           Quantity__c,Unit_Price__c,Recurring_Service__c,Comments__c,Recurring_Service_Line_Item__r.Requesting_Company__r.Name,
                           Allow_Delete__c,PR_Line_Item__c 
                           FROM Recurring_Service_PR_Item__c 
                           WHERE Recurring_Service_Line_Item__c =: RSLineItemIdFLI
                          ]; 
            rowIndexFLI = RSPRListFLI.size();            
        }

        if(rowIndexSLK==0){
            RSPRListSLK = [Select Id, Name, Recurring_Service_Line_Item__c, Recurring_Service_Line_Item__r.Recurring_Service__c,PO_Line_Item__c,
                           Quantity__c,Unit_Price__c,Recurring_Service__c,Comments__c,Recurring_Service_Line_Item__r.Requesting_Company__r.Name,
                           Allow_Delete__c,PR_Line_Item__c
                           FROM Recurring_Service_PR_Item__c 
                           WHERE Recurring_Service_Line_Item__c =: RSLineItemIdSLK
                          ]; 
            rowIndexSLK = RSPRListSLK.size();            
        }
        System.debug('RSPRListFLI: '+ RSPRListFLI);   
        System.debug('RSPRListSLK: '+ RSPRListSLK);   
    }

    //Create Recurring Service PR Items
    public PageReference createRecurringServicePRItems(){  
        
        //Create Recurring Service PR Items for SLK
        if(RSPRListSLK !=null && RSPRListSLK.size() >0){
            UPSERT RSPRListSLK;
        }
        
        //Create Recurring Service PR Items for FLI
        if(RSPRListFLI !=null && RSPRListFLI.size() >0){
            UPSERT RSPRListFLI;
        }
       
        //Ensure the list is not empty
        if ((RSPRListSLK !=null && RSPRListSLK.size() >0) || (RSPRListFLI !=null && RSPRListFLI.size() >0)){
            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.Severity.INFO,'Successfully created Recurring Service PR Item');
            ApexPages.addmessage(successMessage); 
        }
        
        System.debug('createRecurringServicePRItems - RSPRListSLK 1: '+ RSPRListSLK);      
        System.debug('createRecurringServicePRItems - RSPRListSLK 2: '+ RSPRListFLI);    
        
        //Activate Create PR Button
        showStep3Button = true;
        
        return null;
    }    
    
    //Create PR & PR Line Items
    public PageReference createPR(){        
        if(RSLineItemIdSLK!= null){
            createRSLIPR(RSLineItemIdSLK);
        }
        if(RSLineItemIdFLI!= null){
            createRSLIPR(RSLineItemIdFLI);
        }        
        //Redirect user to the recurringService created
        return new PageReference('/'+ recurringService.Id); 
    }
    
    public void createRSLIPR(String varRSLineItemId){
        //Hide createPRButton
        showStep3Button = false;
        
        Recurring_Service_Line_Item__c RSLineItems = [SELECT Id,Name,Item__c,Requesting_Company__c,Currency__c,
                                                       Requesting_Company__r.Name,Procurement_Request__c,PR_Created__c,
                                                       Total_Price__c,Purchase_Order__c,Billing_Date__c,PO_Created__c
                                                       FROM Recurring_Service_Line_Item__c
                                                       WHERE Id =: varRSLineItemId
                                                       ORDER BY Name ASC];
        
        //Create Procurement Request
        Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
        pr.Requestor__c = recurringService.Requestor__c;
        pr.Requesting_Company__c = RSLineItems.Requesting_Company__c;
        pr.Requesting_Department__c = recurringService.Requesting_Department__c;
        pr.Maintenance_Department__c = recurringService.Maintenance_Department__c;
        pr.Required_Date__c = RSLineItems.Billing_Date__c;
        pr.PR_Source__c = 'Recurring Service';
        pr.Is_Retrospective__c = 'Yes';                        
        INSERT pr;
        
        System.debug('CREATE PR: ' + pr);
        System.debug('PR OWNER: ' + pr.OwnerId);
        
        List<Recurring_Service_PR_Item__c> PRLineItems = [SELECT Id,Name,Recurring_Service_Line_Item__c, Comments__c,
                                                          Recurring_Service_Line_Item__r.Purchase_Order_Item__c,
                                                          Recurring_Service_Line_Item__r.Purchase_Order_Item__r.Name,
                                                          Recurring_Service_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c,
                                                          Quantity__c,Unit_Price__c,PR_Line_Item__c,PO_Line_Item__c,Allow_Delete__c,
                                                          Recurring_Service_Line_Item__r.Purchase_Order_Item__r.Vatable__c,
                                                          Recurring_Service_Line_Item__r.Purchase_Order_Item__r.VAT_Inclusive__c,
                                                          Recurring_Service_Line_Item__r.Purchase_Order_Item__r.VAT_Percentage__c
                                                          FROM Recurring_Service_PR_Item__c
                                                          WHERE Recurring_Service_Line_Item__c =: varRSLineItemId
                                                          ORDER BY Name ASC];        
        
        for(Recurring_Service_PR_Item__c item: PRLineItems){
            
            //Create PR Line Item
            PTS_Line_Item__c prLineItem = new PTS_Line_Item__c();
            prLineItem.Procurement_Tracking_Sheet__c = pr.Id;
            prLineItem.Requesting_Company__c = pr.Requesting_Company__c;
            prLineItem.Department__c = pr.Requesting_Department__c;
            prLineItem.Dim_2__c = recurringService.Dim_2__c;
            prLineItem.Dim_3__c = recurringService.Dim_3__c;
            prLineItem.Grant__c = recurringService.Grant__c;
            prLineItem.GLA__c = recurringService.GLA__c;
            prLineItem.Item__c = item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.Name;
            prLineItem.Specifications__c = item.Comments__c;
            prLineItem.RequestType__c = 'Service';
            prLineItem.Quantity__c = item.Quantity__c;
            prLineItem.Budget_Amount__c = item.Quantity__c * item.Unit_Price__c;
            prLineItem.Currency_Config__c = recurringServiceItem.Currency__c;
            prLineItem.Vendor__c = recurringService.Vendor__c;
            prLineItem.Quote_Currency__c = recurringServiceItem.Currency__c;
            prLineItem.Unit_Quote_Price__c = item.Unit_Price__c;
            prLineItem.Vatable__c = item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.Vatable__c;
            prLineItem.VAT_Inclusive__c = item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.VAT_Inclusive__c;
            prLineItem.VAT_Percentage__c = item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.VAT_Percentage__c;                
            prLineItem.Purchase_Order_Item__c = item.Recurring_Service_Line_Item__r.Purchase_Order_Item__c;                    
            INSERT prLineItem;
            
            System.debug('CREATE PR LINE ITEM ====== ' + prLineItem);
            
            //Update PR
            pr.Stage__c = 'Team Lead Approved';
            pr.Team_Lead_Approval_Status__c = 'Approved';
            UPDATE pr;            
            
            //Create Purchase Order
            Purchase_Order__c po = new Purchase_Order__c();
            po.Vendor_Account__c = prLineItem.Vendor__c;
            po.Order_Status__c = 'Open';
            po.PO_Source__c = 'Recurring Service';
            po.Company__c = prLineItem.Requesting_Company__c;
            po.PO_Currency__c = 'aHQD0000000blJJ';
            po.Is_Retrospective__c = 'NO';
            INSERT po;
            
            System.debug('CREATE PO: ' + po); 
            
            //Create PO Item
            Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c ();
            poLine.Purchase_Order__c = po.Id;
            poLine.PTS_Line_Item__c = prLineItem.Id;            
            poLine.Dimension_1__c = prLineItem.Department__c;
            poLine.Dimension_2__c = recurringService.Dim_2__c;
            poLine.Dimension_3__c = recurringService.Dim_3__c;
            poLine.GLA__c = recurringService.GLA__c;
            poLine.Dimension_4__c = recurringService.Grant__c;                        
            poLine.Requesting_Company__c = prLineItem.Requesting_Company__c;            
            System.debug('prLineItem.Quantity__c/item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c: ' + prLineItem.Quantity__c/item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c);
            poLine.Quantity_Requested__c = prLineItem.Quantity__c/item.Recurring_Service_Line_Item__r.Purchase_Order_Item__r.UOM_Conversion_Factor__c;
            poLine.Unit_Price__c = prLineItem.Unit_Quote_Price__c;
            poLine.Item__c = prLineItem.Item__c;
            poLine.Vatable__c = prLineItem.Vatable__c;
            poline.VAT_inclusive__c = prLineItem.VAT_Inclusive__c;
            poLine.VAT_Percentage__c = prLineItem.VAT_Percentage__c; 
            
            //Check if requesting company is Sanergy
            if(prLineItem.Requesting_Company__c == 'aEBD0000000k9yM'){
                poLine.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_SLK__c;
            }
            
            //Check if requesting company is Fresh Life
            if(prLineItem.Requesting_Company__c == 'aEBD0000000kA4j'){
                poLine.Purchase_Order_Item__c = recurringService.Purchase_Order_Item_FLI__c;
            }
           
            INSERT poLine;           
           
            System.debug('CREATE PO LINE ITEM: ' + poLine);             
            
            //UPDATE Recurring Service Line Item
            RSLineItems.Procurement_Request__c = pr.Id;                       	
            RSLineItems.Purchase_Order__c = po.Id;
            RSLineItems.PR_Created__c = true;
            RSLineItems.PO_Created__c = true;
            UPDATE RSLineItems;
            
            //Update Recurring_Service_PR_Item__c
            item.PR_Line_Item__c = prLineItem.Id;
            item.PO_Line_Item__c = poLine.Id;
            UPDATE item;
            
            //Update PR Line Item
            prLineItem.Status__c = 'Purchase Order Created';         
            
    		//Update PO
            po.Delivery_Date__c = date.today();
            po.Delivery_Mode__c = 'Delivery';
            po.Delivery_Address__c = 'Sameer Park - Office';
            UPDATE po;            
            
            //Submit the PO for approval
            Approval.ProcessSubmitRequest submitPO = new Approval.ProcessSubmitRequest();
            submitPO.setComments('Submitting request for approval.');
            submitPO.setObjectId(po.Id);
            
            // Submit the PO to a specific process
            submitPO.setProcessDefinitionNameOrId('Purchase_Order_Approval_Process_V4');
            submitPO.setSkipEntryCriteria(false);

            //Submit the PO for approval
            Approval.ProcessResult result = Approval.process(submitPO); 
            
			// Create Vendor Invoice
            //Vendor_Invoice__c vi = new Vendor_Invoice__c();
            
            
        }//End for(Recurring_Service_PR_Item__c item: PRLineItems )
        
        //Update PR
        //pr.Stage__c = 'Team Lead Approved';
        //pr.Team_Lead_Approval_Status__c = 'Approved';
        //UPDATE pr; 
        
    }     
    
    /* Add a new row for SLK Recurring_Service_PR_Item__c
    public void addRowSLK(){ 
        
        RSPRListSLK.add(new Recurring_Service_PR_Item__c(Recurring_Service_Line_Item__c = RSLineItemIdSLK)); 
        rowIndexSLK += 1;     
    }
    
    // Add a new row for FLI Recurring_Service_PR_Item__c
    public void addRowFLI(){
        
        RSPRListFLI.add(new Recurring_Service_PR_Item__c(Recurring_Service_Line_Item__c = RSLineItemIdFLI)); 
        rowIndexFLI += 1;     
    }
    
    //Delete a row from the added items    
    public void deleteRowSLK(){
        System.debug('DELETE rowIndexSLK aaaaaaa: ' + rowIndexSLK);        
        rowIndexSLK -= 1; 
        
        rowIndexSLK = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndexSLK'));
        //System.debug('DELETE rowIndexSLK bbbbbbb: ' + rowIndexSLK);          
        del = RSPRListSLK.remove(rowIndexSLK);
        delRSPRListSLK.add(del);
        
        //Delete Row
        DELETE delRSPRListSLK;   
    }

    //Delete a row from the added items    
    public void deleteRowFLI(){
        System.debug('DELETE rowIndexFLI bbbbb: ' + rowIndexFLI);        
        rowIndexFLI -= 1; 
        
        //rowIndexSLK = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndexSLK'));
        //System.debug('DELETE rowIndexSLK bbbbbbb: ' + rowIndexSLK);          
        del = RSPRListFLI.remove(rowIndexFLI);
        delRSPRListFLI.add(del);
        
        //Delete Row
        DELETE delRSPRListFLI;   
    }

    //Get Recurring Service Line Items
    public void getRecurringServiceLineItems(){
        System.debug('RecurringService.Name: '+ recurringService.Name);
        
        if(recurringService.Name != null){
            
            allRecurringServiceLineItemList = new List<RecurringServiceLineItem>();
            
            List<Recurring_Service_Line_Item__c> lineItems = [SELECT Id,Name,Item__c,Requesting_Company__c,Currency__c,RS_Tag__c,Recurring_Service__c,
                                                              Requesting_Company__r.Name,Procurement_Request__c,Total_Price__c,
                                                              (SELECT Id,Name,Recurring_Service_Line_Item__c
                                                               FROM Recurring_Service_PR_Items__r)
                                                              FROM Recurring_Service_Line_Item__c
                                                              WHERE Recurring_Service__c =: recurringService.Id
                                                              ORDER BY Name ASC];     
            
            for(Recurring_Service_Line_Item__c lineItem : lineItems){                
                //Add all records to the list
                allRecurringServiceLineItemList.add(new RecurringServiceLineItem(lineItem));
            }
        }
        
        //return null;
    }*/  
   
    // Recurring Service Line Item wrapper class
    public class RecurringServiceLineItem{        
        public Recurring_Service_Line_Item__c serviceItem {get; set;}
        
        //Constructor
        public RecurringServiceLineItem(Recurring_Service_Line_Item__c lineItem) {
            serviceItem = lineItem;
        }
    }    
}