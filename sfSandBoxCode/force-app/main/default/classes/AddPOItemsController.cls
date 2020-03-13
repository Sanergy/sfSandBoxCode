public class AddPOItemsController {
    
    public ApexPages.StandardController standardController;
    public Purchase_Order__c purchaseOrder {get; set;}
    public List<LinesWrapper> poItems {get; set;}
    public List<String> createdPOsId {get; set;}
    
    public AddPOItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.purchaseOrder = (Purchase_Order__c)standardController.getRecord();
        
        List<PTS_Line_Item__c> prLines = [SELECT id,Name ,Item__c,Specifications__c, Quantity__c, Qty_Delivered__c,Item_Type__c,Currency_Config__c,
                                           Procurement_Tracking_Sheet__r.name,Quote_Currency__c,Total_Quote_Price__c,Purchase_Order_Item__c,
                                           Procurement_Tracking_Sheet__r.Requestor__r.name,Vendor__c,Vendor__r.name,Quote_Currency__r.name,
                                           Procurement_Tracking_Sheet__r.Requesting_Department__r.name,  Currency_Config__r.name,Vatable__c,
                                           Po_Line_attached__c, Quantity_Remaining__c ,Department__c,Dim_2__c,Unit_Quote_Price__c ,VAT_Percentage__c,
                                           Dim_3__c,Grant__c,GLA__c, Company__c, Requesting_Company__c,Requesting_Company__r.Name,Status__c ,
                                           VAT_Inclusive__c, Purchase_Order_Item__r.Purchase_UoM__c, Purchase_Order_Item__r.Inventory_UOM__c,
                                           Purchase_Order_Item__r.UOM_Conversion_Factor__c,Override_Justification__c,Override_PR_Item_Cost_Check__c,
                                           Purchase_Order_Item__r.Inventory_Item__r.unit_cost__c,
                                           Purchase_Order_Item__r.Purchase_UoM__r.Name,non_primary_vendor_description__c
                                           FROM PTS_Line_Item__c 
                                           WHERE Status__c='Pending Purchase Order'
                                          	AND Vendor__c = :purchaseOrder.Vendor_Account__c
                                          	AND Requesting_Company__c = :purchaseOrder.Company__c
                                          	AND Quote_Currency__c = :purchaseOrder.PO_Currency__c
                                           ORDER BY NAME DESC
                                          ];
        
        poItems = new List<LinesWrapper>();
        createdPOsId =new List<String>();
        
        for(PTS_Line_Item__c prLine : prLines){
            LinesWrapper wr = new LinesWrapper(prLine);
            poItems.add(wr);
        }
    }
    
    public PageReference selectAll() {
        if(poItems != null){
            for(LinesWrapper lg:poItems){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(poItems != null){
            for(LinesWrapper lg:poItems){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    public List<LinesWrapper> getLinesSelected(){
        
        List<LinesWrapper> selectesLinesWrapper=new List<LinesWrapper>();
         
        for(LinesWrapper lw:poItems){
            
            if(lw.selected==true){
                if(lw.hasErrors != null && lw.hasErrors){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,lw.error));
                } else {
                    selectesLinesWrapper.add(lw);
                }
            }
        }
        return selectesLinesWrapper;
    } 
    
    public PageReference addPoItems(){
        
        List<LinesWrapper> selectedLines=getLinesSelected();
        
        if(selectedLines.size()>0){
            
            List<Purchase_Order_Line_Item__c> linesToInsert = new List<Purchase_Order_Line_Item__c>();
            List<PTS_Line_Item__c> ptsLineList = new List<PTS_Line_Item__c>();
            
            for(LinesWrapper lw :selectedLines){

                if(lw.ptsLine.Quote_Currency__c != purchaseOrder.PO_Currency__c){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The Item selected does not match the PO Currency'));
                }else if(lw.ptsLine.Requesting_Company__c != purchaseOrder.Company__c){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The Item selected does not match the PO Company'));
                }else if(lw.ptsLine.Vendor__c != purchaseOrder.Vendor_Account__c){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'The Item selected does not match the PO Vendor'));
                }else {
                    lw.poLine.Purchase_Order__c=purchaseOrder.id;  
                    linesToInsert.add(lw.poLine);
                    
                    lw.ptsLine.Status__c='Purchase Order Created';
                    ptsLineList.add(lw.ptsLine);
                }
            }

            if(linesToInsert.size()>0){
                try{
                    insert linesToInsert;
                    update ptsLineList;
            
            		return new PageReference('/' + this.purchaseOrder.Id);
                }catch(Exception e){                     
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                }
            }
            return null;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Line has been selected'));
            return null;
        }         
    }
    
     public class LinesWrapper{
        public PTS_Line_Item__c ptsLine {get; set;}
        public Boolean selected {get; set;}
         public Decimal qtyRemaining {get; set;}
        public Decimal amtRemaining {get; set;}
        public Decimal unitPrice {get; set;}
        public String mCurrency {get; set;}
        public String mCurrencyId {get; set;}
        public Purchase_Order_Line_Item__c poLine {get; set;}
        public String vendorId {get; set;}
        public String inventoryUom {get; set;}
        public String purchaseUom {get; set;}
        public Decimal conversionFactor {get; set;}
        public Decimal inventoryUnitPrice {get; set;}
        public String error {get; set;}
        public Boolean hasErrors {get; set;}

        public LinesWrapper(PTS_Line_Item__c line) {
            ptsLine = line;
            
            poLine = new Purchase_Order_Line_Item__c ();
            
            inventoryUom = line.Purchase_Order_Item__r.Inventory_UOM__c;
            purchaseUom = line.Purchase_Order_Item__r.Purchase_UoM__r.Name;
            conversionFactor = line.Purchase_Order_Item__r.UOM_Conversion_Factor__c;
            inventoryUnitPrice = line.Purchase_Order_Item__r.Inventory_Item__r.unit_cost__c;
            
            if(conversionFactor != null && conversionFactor > 0){
                qtyRemaining = line.Quantity_Remaining__c / conversionFactor;
                poLine.Quantity_Requested__c = qtyRemaining;
                amtRemaining = qtyRemaining * (line.Unit_Quote_Price__c==null ? 0 : line.Unit_Quote_Price__c);
            } else {
                hasErrors = true;
                error = line.Item__c + ' (PO Item Conversion factor not set)';
            }
            
             poLine.PTS_Line_Item__c=ptsLine.id;          
            poLine.PTS_Line_Item__c=ptsLine .id;
             
            poLine.Dimension_1__c=line.Department__c;
            poLine.Dimension_2__c=line.Dim_2__c;
            poLine.Dimension_3__c=line.Dim_3__c;
            poLine.Dimension_4__c=line.Grant__c;
            poLine.GLA__c=line.GLA__c;
                        
            poLine.Requesting_Company__c=line.Requesting_Company__c;
            selected = false;
            
            unitPrice = line.Unit_Quote_Price__c;
            mCurrency = line.Quote_Currency__r.name;
            mCurrencyId = line.Quote_Currency__c;
            poLine.Purchase_Order_Item__c= line.Purchase_Order_Item__c;
            poLine.Unit_Price__c = line.Unit_Quote_Price__c;
            poLine.Item__c = line.Item__c;
            poLine.Vatable__c=line.Vatable__c;
            poline.VAT_inclusive__c=line.VAT_Inclusive__c;
            poLine.VAT_Percentage__c=line.VAT_Percentage__c; 
        }
    }
}