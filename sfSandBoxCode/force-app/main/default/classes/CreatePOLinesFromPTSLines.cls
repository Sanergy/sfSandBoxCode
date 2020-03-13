public class CreatePOLinesFromPTSLines{

        
    //create standard controller
    private ApexPages.StandardSetController standardController;
    
     //create standard controller
    private ApexPages.StandardController controller;
      
     public List<String> createdPOsId {get; set;}
    
    public String searchText {get;set;}

    
     public List<LinesWrapper> linesWrapper {get; set;}
     
      public CreatePOLinesFromPTSLines(ApexPages.StandardSetController controller) {
          searchText = '';
          getLines();
          if(standardController==null){
               this.standardController=controller;
               createdPOsId =new List<String>();
       String strId = apexpages.currentpage().getparameters().get('id');
              if (strId == null){
              getLines();
              }
              else{
              getSpecificPrLine(strId);
              }
          }
      }  

       
    public void getSpecificPrLine( String prid) {
            linesWrapper= new List<LinesWrapper>();
                     
             for(PTS_Line_Item__c r: [SELECT id,Name,POI_Unit_Price__c,Item__c,Specifications__c, Quantity__c, Qty_Delivered__c,Item_Type__c,Currency_Config__c,Procurement_Tracking_Sheet__r.name,Quote_Currency__c,Total_Quote_Price__c,Purchase_Order_Item__c,
                                      Procurement_Tracking_Sheet__r.Requestor__r.name,Vendor__c,Vendor__r.name,Quote_Currency__r.name,Procurement_Tracking_Sheet__r.Requesting_Department__r.name,  Currency_Config__r.name,Vatable__c, Quantity_Remaining__c ,Department__c,Dim_2__c,Unit_Quote_Price__c ,VAT_Percentage__c,Dim_3__c,Grant__c,GLA__c, Requesting_Company__c,Requesting_Company__r.Name,Status__c,VAT_Inclusive__c, Purchase_Order_Item__r.Purchase_UoM__c, Purchase_Order_Item__r.Inventory_UOM__c,
                                      Purchase_Order_Item__r.UOM_Conversion_Factor__c,Override_Justification__c,Override_PR_Item_Cost_Check__c,
                                      Purchase_Order_Item__r.Inventory_Item__r.unit_cost__c,Procurement_Tracking_Sheet__r.Is_Retrospective__c,
                                      Purchase_Order_Item__r.Purchase_UoM__r.Name,non_primary_vendor_description__c 
                                      FROM PTS_Line_Item__c 
                                      WHERE  Procurement_Tracking_Sheet__r.id =: prid
                                      AND Procurement_Tracking_Sheet__r.Is_Retrospective__c = 'YES'
                                      AND Procurement_Tracking_Sheet__r.Team_Lead_Approval_Status__c = 'Approved'
                                      ORDER BY NAME DESC
                                       ]) {
            
                linesWrapper.add(new LinesWrapper(r));
              
        }
    }
   
    public void getLines() {
        if(searchText == '' ){
            linesWrapper= new List<LinesWrapper>();
                     
             for(PTS_Line_Item__c r: [SELECT id,Name,POI_Unit_Price__c,Item__c,Specifications__c, Quantity__c, Qty_Delivered__c,Item_Type__c,Currency_Config__c,
                                     Procurement_Tracking_Sheet__r.name,Quote_Currency__c,Total_Quote_Price__c,Purchase_Order_Item__c,
                                     Procurement_Tracking_Sheet__r.Requestor__r.name,Vendor__c,Vendor__r.name,Quote_Currency__r.name,
                                     Procurement_Tracking_Sheet__r.Requesting_Department__r.name,  Currency_Config__r.name,Vatable__c,
                                     Po_Line_attached__c, Quantity_Remaining__c ,Department__c,Dim_2__c,Unit_Quote_Price__c ,VAT_Percentage__c,
                                     Dim_3__c,Grant__c,GLA__c, Company__c, Requesting_Company__c,Requesting_Company__r.Name,Status__c ,
                                     VAT_Inclusive__c, Purchase_Order_Item__r.Purchase_UoM__c, Purchase_Order_Item__r.Inventory_UOM__c,
                                     Purchase_Order_Item__r.UOM_Conversion_Factor__c,Override_Justification__c,Override_PR_Item_Cost_Check__c,
                                     Purchase_Order_Item__r.Inventory_Item__r.unit_cost__c,Procurement_Tracking_Sheet__r.Is_Retrospective__c,
                                     Purchase_Order_Item__r.Purchase_UoM__r.Name,non_primary_vendor_description__c
                                     FROM PTS_Line_Item__c 
                                     WHERE Status__c='Pending Purchase Order'
                                     AND Procurement_Tracking_Sheet__r.Stage__c ='Team Lead Approved'
                                     ORDER BY NAME DESC
                                      ]) {
            
                linesWrapper.add(new LinesWrapper(r));
              
        }
    }
        else{
      // searchText = '%'+ searchText + '%';
          
            linesWrapper= new List<LinesWrapper>();
                     
             for(PTS_Line_Item__c r: [SELECT id,Name,POI_Unit_Price__c,Item__c,Specifications__c, Quantity__c, Qty_Delivered__c,Item_Type__c,Currency_Config__c,
                                     Procurement_Tracking_Sheet__r.name,Quote_Currency__c,Total_Quote_Price__c,Purchase_Order_Item__c,
                                     Procurement_Tracking_Sheet__r.Requestor__r.name,Vendor__c,Vendor__r.name,Quote_Currency__r.name,
                                     Procurement_Tracking_Sheet__r.Requesting_Department__r.name,  Currency_Config__r.name,Vatable__c,
                                     Po_Line_attached__c, Quantity_Remaining__c ,Department__c,Dim_2__c,Unit_Quote_Price__c ,VAT_Percentage__c,
                                     Dim_3__c,Grant__c,GLA__c, Company__c, Requesting_Company__c,Requesting_Company__r.Name,Status__c ,
                                     VAT_Inclusive__c, Purchase_Order_Item__r.Purchase_UoM__c, Purchase_Order_Item__r.Inventory_UOM__c,
                                     Purchase_Order_Item__r.UOM_Conversion_Factor__c,Override_Justification__c,Override_PR_Item_Cost_Check__c,
                                     Purchase_Order_Item__r.Inventory_Item__r.unit_cost__c,Procurement_Tracking_Sheet__r.Is_Retrospective__c,
                                     Purchase_Order_Item__r.Purchase_UoM__r.Name,non_primary_vendor_description__c
                                     FROM PTS_Line_Item__c 
                                     WHERE Status__c='Pending Purchase Order'
                                     AND Procurement_Tracking_Sheet__r.Stage__c ='Team Lead Approved'
                                     AND Procurement_Tracking_Sheet__r.name LIKE : searchText
                                     ORDER BY NAME DESC
                                      ]) {
            
                linesWrapper.add(new LinesWrapper(r));
              
  
        }
    }
    }
    public PageReference selectAll() {
        if(linesWrapper!=null){
            for(LinesWrapper lg:linesWrapper){
                lg.selected=true;
                
            }
        }
        return null;
    }
    
    
    public PageReference unselectAll() {
        if(linesWrapper!=null){
            for(LinesWrapper lg:linesWrapper){
                lg.selected=false; 
            }
        }        
        return null;
    }
    

    public PageReference processSelected() {
        Integer count=0;
        for(LinesWrapper lw:linesWrapper){
           if(lw.selected==true){
               count++;
           }            
        }
        
        if(count > 0){
            return Page.Create_PO_Lines_from_PTS_Lines_Step_2;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly select atleast one Line Item'));
            return null;
        }
    }
    
     public List<LinesWrapper> getLinesSelected(){
        List<LinesWrapper> selectesLinesWrapper=new List<LinesWrapper>();
         
        for(LinesWrapper lw:linesWrapper){
            
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
    
     public List<Purchase_Order__c> getCreatedPOs(){ 
        List<Purchase_Order__c> ordersList=[SELECT id,Order_Status__c, Vendor_Account__c,Company__r.name,PO_Currency__r.name,
                                            Total_Amount__c, Name
                                            FROM Purchase_Order__c
                                            WHERE id IN :this.createdPOsId];
                                            
        return ordersList;
    } 
    
    public PageReference createPOLines() {
        List<LinesWrapper> selectedLines=getLinesSelected();
        
        if(selectedLines.size()>0){
        
             Set<String> values= new Set<String>();
             List<Purchase_Order__c> POs=new List<Purchase_Order__c>();
             List<PTS_Line_Item__c> ptsLineList = new List<PTS_Line_Item__c>();
             
             List<id> idString=new List<id>();
             
             //get account from PO items
             for(LinesWrapper lw: selectedLines){
                if(lw.poLine.Purchase_Order_Item__c!=null){
                    idString.add(lw.poLine.Purchase_Order_Item__c);
                }                
             }
            
            Map<id,Purchase_Order_Item__c> poItems=new Map<id,Purchase_Order_Item__c>([SELECT id,Vendor__c FROM  Purchase_Order_Item__c
                                                    WHERE ID IN :idString]);
             
             for(LinesWrapper lw: selectedLines){             
                String companyId= lw.poLine.Requesting_Company__c;
                String isRetro = lw.ptsLine.Procurement_Tracking_Sheet__r.Is_Retrospective__c;
                String vendorId=  lw.ptsLine.Item_Type__c=='Stock Item'? poItems.get(lw.poLine.Purchase_Order_Item__c).Vendor__c 
                                                                            :lw.ptsLine.vendor__c;
                                                                            
                lw.vendorId =vendorId;
                String currencyName= lw.mCurrency;
                if(values.add(concatValuesWithSpace(companyId, vendorId,currencyName))==true){
                    Purchase_Order__c po=new Purchase_Order__c();
                    po.Vendor_Account__c=vendorId;
                    po.Order_Status__c='Open';
                    po.Company__c=companyId;
                    po.PO_Currency__c=lw.mCurrencyId;
                    po.Is_Retrospective__c = isRetro;
                    POs.add(po);
                }
                lw.ptsLine.Status__c='Purchase Order Created';
                ptsLineList.add(lw.ptsLine);
             }
             try{
                 insert POs;
                 update ptsLineList;
                 
                 List<Purchase_Order_Line_Item__c> linesToInsert=new List<Purchase_Order_Line_Item__c>();
            
                for(Purchase_Order__c order:POs){              
                    
                    for(LinesWrapper wr:selectedLines){
                        if(wr.mCurrencyId == order.PO_Currency__c && wr.poLine.Requesting_Company__c==order.Company__c && wr.vendorId==order.Vendor_Account__c){
                            wr.poLine.Purchase_Order__c=order.id;  
                            linesToInsert.add(wr.poLine);
                        }
                    }
                    
                    this.createdPOsId.add(order.id);
                    }  
                    
                    if(linesToInsert.size()>0){
                        insert linesToInsert;
                    }
                 
                 /*for(Purchase_Order_Line_Item__c lns: linesToInsert){
                   lns.VI_Recon_Total__c = 0;
                   update linesToInsert;
                 }*/

                 
             }catch(Exception e){                     
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                System.debug(e.getMessage());
                return null;
             }
            
            return Page.Create_PO_Lines_from_PTS_Lines_Step_3;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Line has been selected'));
            return null;
        }         
    }
    
    
    //method to return single-space separated string
    public String concatValuesWithSpace(String companyId, String vendorId, String currencyName){
        return companyId+' '+vendorId+' '+currencyName;
    }
    
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
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
            
            poLine = new Purchase_Order_Line_Item__c ();
            
            inventoryUom = line.Purchase_Order_Item__r.Inventory_UOM__c;
            purchaseUom = line.Purchase_Order_Item__r.Purchase_UoM__r.Name;
            conversionFactor = line.Purchase_Order_Item__r.UOM_Conversion_Factor__c;
            inventoryUnitPrice = line.Purchase_Order_Item__r.Inventory_Item__r.unit_cost__c;
             
            ptsLine = line;

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
            poLine.POI_Unit_Price__c = line.POI_Unit_Price__c;
                        
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