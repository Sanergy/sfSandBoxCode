public class GeneratePreviousPOsPRsAndPOItemsOnPR {

    @TestVisible public ApexPages.StandardController standardController;
    @TestVisible public Inventory_Transaction__c inventoryTransaction;
    @TestVisible public List<Inventory_Transaction__c> inventoryTransactionList {get; set;}
    @TestVisible public Purchase_Order_Line_Item__c purchaseOrderLineItem;
    @TestVisible public List<Purchase_Order_Line_Item__c> purchaseOrderLineItemList {get; set;}
    @TestVisible public PTS_Line_Item__c procurementRequestLineItem;
    @TestVisible public List<PTS_Line_Item__c > procurementRequestLineItemList {get; set;}
    @TestVisible public Purchase_Order_Item__c purchaseOrderItem;
    @TestVisible public List<PTS_Line_Item__c > purchaseOrderItemList {get; set;}
    
    public GeneratePreviousPOsPRsAndPOItemsOnPR(ApexPages.StandardController standardController){
        this.standardController = standardController;
                
        this.procurementRequestLineItem = (PTS_Line_Item__c)standardController.getRecord();
        this.procurementRequestLineItem = [SELECT Id,Purchase_Order_Line_Item__c,Purchase_Order_Item__c,Purchase_Order_Item__r.Inventory_Item__c 
                                      		FROM PTS_Line_Item__c 
                                      		WHERE Id =: procurementRequestLineItem.Id];
        
        this.inventoryTransactionList = getinventoryTransactionList();
        this.procurementRequestLineItemList = getProcurementRequestLineItemList();
        this.purchaseOrderLineItemList = getPurchaseOrderLineItemList();

    }
    
        @TestVisible private List<Inventory_Transaction__c> getinventoryTransactionList() {
        
        if(inventoryTransactionList == null) {
            inventoryTransactionList = new List<Inventory_Transaction__c>();
            
            @TestVisible List<Inventory_Transaction__c> lineItems = [SELECT id,Name , Comments__c , Credit_Account__c , Debit_Account__c ,Dimension_2__c,
                                                                     Dimension_3__c , Dimension_4__c, Dimension_1__c , Item__c   , Item_Company__c,
                                                                     Item_Unit_Price__c   ,Journal_Entry_Number__c, Location__c  ,Location_Lot__c   ,
                                                                     Location_Name__c  ,Opportunity__c , Quantity_At_Location__c,
                                                                     Quantity_Impact__c    ,Transaction_Date__c ,Transaction_ID__c ,Transaction_Quantity__c  ,Transaction_Value__c  ,
                                                                     Purchase_Order_Line__c,  Work_Order__c
                                                                     FROM Inventory_Transaction__c 
                                                                     WHERE Item__c =: procurementRequestLineItem.Purchase_Order_Item__r.Inventory_Item__c
                                                                     AND Quantity_Impact__c = 'D' AND Item__c != null
                                                                     ORDER BY Transaction_Date__c DESC NULLS LAST
                                                                     Limit 5
                                                                     ];
            
            for(Inventory_Transaction__c lineItem : lineItems){
                inventoryTransactionList.add(lineItem);
            }
            
        }
        return inventoryTransactionList;
    }

        @TestVisible private List<PTS_Line_Item__c> getProcurementRequestLineItemList() {
        
        if(procurementRequestLineItemList == null) {
            procurementRequestLineItemList = new List<PTS_Line_Item__c>();
            
            System.debug(this.procurementRequestLineItem.Purchase_Order_Item__c);
            
            @TestVisible List<PTS_Line_Item__c> lineItems = [SELECT id,Name ,Actual_Price__c,GLA__c,Grant__c,Inventory_UoM__c,Item__c,Item_Type__c,
                                                             Budget_Amount__c,Item_Quote_Information__c,Procurement_Tracking_Sheet__c,Department__c,
                                                             Purchase_Order_Item__c,Purchase_URL__c,Currency_Config__c,
                                                             Purpose__c,Qty_Delivered__c,Purchase_Order_Line_Item__c, Requesting_Company__c,Specifications__c,Dim_2__c,Vendor__c,
                                                             Status__c,Dim_3__c,Estimate__c,Exchange_Rate__c, PP_Approved_Date__c
                                                             FROM PTS_Line_Item__c
                                                             WHERE Purchase_Order_Item__c =: this.procurementRequestLineItem.Purchase_Order_Item__c
                                                             AND Id !=: this.procurementRequestLineItem.Id
                                                             ORDER BY PP_Approved_Date__c DESC NULLS LAST
                                                             Limit 5
                                                             ];
           
            for(PTS_Line_Item__c lineItem : lineItems){
                procurementRequestLineItemList.add(lineItem);
            }
            
        }
        return procurementRequestLineItemList;
    }
    
	  	@TestVisible private List<Purchase_Order_Line_Item__c> getPurchaseOrderLineItemList() {
        
        if(purchaseOrderLineItemList == null) {
            purchaseOrderLineItemList = new List<Purchase_Order_Line_Item__c>();
            
            @TestVisible List<Purchase_Order_Line_Item__c> lineItems = [SELECT id,Name , Company__c , Requesting_Company__c , CompanyName__c , Dimension_1__c  ,Dimension_2__c ,Dimension_3__c , Dimension_4__c,
                                                                        Electronic_Payment_Request__c  ,EPR_Line_Item__c   ,GLA__c , Invoice_Assigned__c   ,Item_Type__c   , Item__c   ,Vatable__c, PIN__c  ,PIN_Line_Item__c   ,
                                                                        PTS_Line_Item__c   ,Purchase_Order__c, Purchase_Order_Item__c  ,Quantity_Accepted__c   ,Quantity_Remaining__c  ,Quantity_Requested__c  ,Quantity_RTV__c    ,
                                                                        Status__c  ,Terms_Conditions__c    ,Total_Price__c ,Total_Item_Value__c ,Total_Net_Price__c  ,Total_VAT_Amount__c  ,
                                                                        Unit_Net_Price__c  ,Unit_Price__c  ,VAT_Amount__c, VAT_inclusive__c, VAT_Percentage__c, Vendor_id__c, Purchase_Order__r.Firm_Date__c
                                                                        FROM Purchase_Order_Line_Item__c 
                                                                        WHERE Purchase_Order_Item__c =: this.procurementRequestLineItem.Purchase_Order_Item__c 
                                                                        ORDER BY Purchase_Order__r.Firm_Date__c DESC NULLS LAST
                                                                        Limit 5
                                                                        ];
            
            for(Purchase_Order_Line_Item__c lineItem : lineItems){
                purchaseOrderLineItemList.add(lineItem);
            }
            
        }
        return purchaseOrderLineItemList;
    }

    
}