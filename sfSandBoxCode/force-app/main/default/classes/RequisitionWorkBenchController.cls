public class RequisitionWorkBenchController{
    
    public List<ReplenishmentTracker> rList {get; set;}
    public String selectedStatus {get; set;}
    public boolean displayPopup {get; set;}
    public boolean displayNewItemPopup {get; set;}
    public boolean displayManualRunPopup {get; set;}
    public List<ReplenishmentTracker> itemsToChangeVendor {get; set;}
   
    @TestVisible
    public List<ReplenishmentTracker> itemsToAdd;
    
      
    
    public RequisitionWorkBenchController(){
        
        rList = new List<ReplenishmentTracker>();
        List<Inventory_Replenishment_Tracker__c> replenishmentList = [SELECT Inventory_Item__c, Inventory_Item__r.Item_Company__c, Inventory_Item__r.Inventory_Stock__c,
                                                                         Inventory_Item__r.Minimum_Quantity__c, Inventory_Item__r.Policy_Quantity__c,Inventory_Item__r.Inventory_UoM__r.name, Quantity_Pending__c, Procurement_Request_Line_Item__c, 
                                                                         Procurement_Request_Line_Item__r.Quantity__c,Procurement_Request_Line_Item__r.Currency_Config__r.name, Work_Order__c,PO_Line__r.Purchase_Order_Item__c,
                                                                         PO_Line__c,PO_Line__r.Purchase_Order_Item__r.Vendor__c,PO_Line__r.Purchase_Order_Item__r.Currency__r.name, Procurement_Request_Line_Item__r.Budget_Amount_Per_item__c,
                                                                         Procurement_Request_Line_Item__r.Budget_Amount__c,Procurement_Request_Line_Item__r.Total_Quote_Price__c,Procurement_Request_Line_Item__r.Quote_Currency__r.name, PO_Line__r.Purchase_Order_Item__r.Gross_Value__c,
                                                                         PO_Line__r.Total_Price__c,  PO_Line__r.Quantity_Requested__c,PO_Line__r.Purchase_Order__r.PO_Currency__r.name, PO_Line__r.Reorder_Quantity__c, PO_Line__r.Quantity_At_Hand__c,
                                                                         PO_Line__r.Reorder_Level__c, PO_Line__r.UoM__c, PO_Line__r.Inventory_Item_UOM__c, PO_Line__r.Notes__c, Procurement_Request_Line_Item__r.Purchase_Order_Item__r.Vendor__c,
                                                                         Procurement_Request_Line_Item__r.Purchase_Uom__c, 
                                                                         RecordType.name,Status__c,CreatedDate,Firm_Date__c,Approved_Date__c
                                                                         FROM  Inventory_Replenishment_Tracker__c
                                                                         WHERE Status__c != 'Cancelled'
                                                                         AND Status__c!= 'Closed'
                                                                         AND RecordType.name = 'Purchase Request Replenishment'];
                                                                     
        for(Inventory_Replenishment_Tracker__c irt : replenishmentList){
           
            ReplenishmentTracker rt = new ReplenishmentTracker();            
            rt.tracker = irt;
            
            rList.add(rt);
        }
    }
    
    public List<ReplenishmentTracker > getSelectedForVendorChange(){    
        itemsToChangeVendor  = getSelected();  
              
        Set<id> idSet = new Set<id>();
        
        for(ReplenishmentTracker tracker : itemsToChangeVendor){
            tracker.poLine = new Purchase_Order_Line_Item__c();
            idSet.add(tracker.tracker.Inventory_Item__c);        
        }
        
        Map<id, Inventory_Item__c> items = new Map<id, Inventory_Item__c>([SELECT id,
                                                                         (SELECT id,Vendor__r.name FROM Purchase_Order_Items__r)
                                                                         FROM Inventory_Item__c
                                                                         WHERE id IN :idSet]);
        
        for(ReplenishmentTracker tracker : itemsToChangeVendor ){
            tracker.setOptions(items.get(tracker.tracker.Inventory_Item__c));
        }
        
        return  itemsToChangeVendor;
    }
    
    
    public PageReference saveVendorChange(){
        List<Purchase_Order_Line_Item__c> poLines = new List<Purchase_Order_Line_Item__c>();
        
        for(ReplenishmentTracker tracker : itemsToChangeVendor){        
            List<Purchase_Order_Line_Item__c> poLine = [SELECT Purchase_Order_Item__c,Variation_Notes__c
                                                        FROM Purchase_Order_Line_Item__c 
                                                        WHERE id = :tracker.tracker.PO_Line__c];
                                                        
            List<Purchase_Order_Item__c> poItem = [SELECT Item_Cost__c,Vatable__c,VAT_Inclusive__c,VAT_Percentage__c
                                                   FROM Purchase_Order_Item__c
                                                   WHERE id = :tracker.selectedVendor];
                                                        
            if(poLine != null && poLine.size() > 0){
                poLine.get(0).Purchase_Order_Item__c = tracker.selectedVendor;
                poLine.get(0).Vatable__c = poItem.get(0).Vatable__c;
                poLine.get(0).Unit_Price__c = poItem.get(0).Item_Cost__c;
                poLine.get(0).VAT_inclusive__c = poItem.get(0).VAT_Inclusive__c;
                poLine.get(0).VAT_Percentage__c = poItem.get(0).VAT_Percentage__c;
                
                poLine.get(0).Variation_Notes__c = tracker.poLine.Variation_Notes__c;
                
                poLines.add(poLine.get(0));
            }
        }
        
        if(poLines.size() > 0){
            //update poLines;          
        }
        
        refreshList(); 
        return closePopup(); 
    }
    
    public void refreshList(){
        if(this.selectedStatus != null){
            this.rList = new List<ReplenishmentTracker>();
            
            List<Inventory_Replenishment_Tracker__c> replenishmentList = [SELECT Inventory_Item__c, Inventory_Item__r.Item_Company__c, Inventory_Item__r.Inventory_Stock__c,
                                                                         Inventory_Item__r.Minimum_Quantity__c, Inventory_Item__r.Policy_Quantity__c,Inventory_Item__r.Inventory_UoM__r.name, Quantity_Pending__c, Procurement_Request_Line_Item__c, 
                                                                         Procurement_Request_Line_Item__r.Quantity__c,Procurement_Request_Line_Item__r.Currency_Config__r.name, Work_Order__c,PO_Line__r.Purchase_Order_Item__c,
                                                                         PO_Line__c,PO_Line__r.Purchase_Order_Item__r.Vendor__c,PO_Line__r.Purchase_Order_Item__r.Currency__r.name, Procurement_Request_Line_Item__r.Budget_Amount_Per_item__c,
                                                                         Procurement_Request_Line_Item__r.Budget_Amount__c,Procurement_Request_Line_Item__r.Total_Quote_Price__c,Procurement_Request_Line_Item__r.Quote_Currency__r.name, PO_Line__r.Purchase_Order_Item__r.Gross_Value__c,
                                                                         PO_Line__r.Total_Price__c,  PO_Line__r.Quantity_Requested__c,PO_Line__r.Purchase_Order__r.PO_Currency__r.name, PO_Line__r.Reorder_Quantity__c, PO_Line__r.Quantity_At_Hand__c,
                                                                         PO_Line__r.Reorder_Level__c, PO_Line__r.UoM__c, PO_Line__r.Inventory_Item_UOM__c, PO_Line__r.Notes__c, Procurement_Request_Line_Item__r.Purchase_Order_Item__r.Vendor__c,
                                                                         Procurement_Request_Line_Item__r.Purchase_Uom__c, 
                                                                         RecordType.name,Status__c,CreatedDate,Firm_Date__c,Approved_Date__c
                                                                         FROM  Inventory_Replenishment_Tracker__c
                                                                         WHERE Status__c != 'Cancelled'
                                                                         AND Status__c!= 'Closed'
                                                                         AND RecordType.name = 'Purchase Request Replenishment'
                                                                         AND Status__c = :this.selectedStatus ];
                                                                     
            for(Inventory_Replenishment_Tracker__c irt : replenishmentList){
               
                ReplenishmentTracker rt = new ReplenishmentTracker();            
                rt.tracker = irt;
                
                this.rList.add(rt);
            }        
        }
    }
    
    public PageReference firmRequests(){
        List<ReplenishmentTracker> selected = getSelected();
               
        List<Inventory_Replenishment_Tracker__c> irtList = new List<Inventory_Replenishment_Tracker__c>();
        List<PTS_Line_Item__c> prList = new List<PTS_Line_Item__c>();
        
        Set<id> prIds =  new Set<id>();
        
        for(ReplenishmentTracker t : selected){
            prIds.add(t.tracker.Procurement_Request_Line_Item__c);
            t.tracker.Status__c = 'Firmed';
            t.tracker.Firm_Date__c = Date.today();
            
            irtList.add(t.tracker);
        }
                
        Map<id,PTS_Line_Item__c> prLinesMap = new Map<id,PTS_Line_Item__c>([SELECT Quantity__c,Unit_Quote_Price__c,Budget_Amount__c,UoM_conversion_factor__c,PO_Quantity__c FROM PTS_Line_Item__c WHERE id IN :prIds]);
        
        for(ReplenishmentTracker t : selected ){
            if(t.tracker.Quantity_Pending__c != 0 && prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).UoM_conversion_factor__c != 0){
            Decimal quantity = t.tracker.Quantity_Pending__c;
           
            prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).Quantity__c = quantity;
            prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).Budget_Amount__c = prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).PO_Quantity__c* prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).Unit_Quote_Price__c;
            prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).Status__c = 'Pending Purchase Order';
            
            prList.add(prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c));
            }
        }
        
        update irtList;
        update prList;
        
        refreshList();
        
        return Page.requisitionworkbenchcontroller;
    }
    
    public PageReference approveRequests(){
        List<ReplenishmentTracker> selected = getSelected();
        List<Inventory_Replenishment_Tracker__c> invTracker = new List<Inventory_Replenishment_Tracker__c>();
        
        List<PTS_Line_Item__c> prLines = new List<PTS_Line_Item__c>();
        List<Purchase_Order__c> pos = new List<Purchase_Order__c>();
        List<Purchase_Order_Line_Item__c> poLines = new List<Purchase_Order_Line_Item__c>();
        Map<id,Inventory_Replenishment_Tracker__c> replenisherMap = new Map<id,Inventory_Replenishment_Tracker__c>();
        
        Set<id> prLInesIds = new Set<id>();
        
        for(ReplenishmentTracker t : selected){
            prLInesIds.add(t.tracker.Procurement_Request_Line_Item__c);
            t.tracker.Status__c='Approved';
            t.tracker.Approved_Date__c=Date.today();
            invTracker.add(t.tracker);
            
            replenisherMap.put(t.tracker.Procurement_Request_Line_Item__c, t.tracker);
        } 
        
        prLines = [SELECT id,Name ,Item__c,Specifications__c, Quantity__c, Qty_Delivered__c,Item_Type__c,Currency_Config__c,
                   Procurement_Tracking_Sheet__r.name,Quote_Currency__c,Total_Quote_Price__c,Purchase_Order_Item__c,
                   Procurement_Tracking_Sheet__r.Requestor__r.name,Vendor__c,Vendor__r.name,Quote_Currency__r.name,
                   Procurement_Tracking_Sheet__r.Requesting_Department__r.name,  Currency_Config__r.name,Vatable__c,
                   Po_Line_attached__c, Quantity_Remaining__c ,Department__c,Dim_2__c,Unit_Quote_Price__c ,VAT_Percentage__c,
                   Dim_3__c,Grant__c,GLA__c,PO_Quantity__c, Company__c, Requesting_Company__c,Requesting_Company__r.Name,Status__c ,
                   VAT_Inclusive__c,RequestType__c
                   FROM PTS_Line_Item__c 
                   WHERE id IN :prLInesIds ]; 
         
        //Split by vendors, company and currency
        Map<String, List<PTS_Line_Item__c>> vendorMap = new Map<String, List<PTS_Line_Item__c>>();
        
        for(PTS_Line_Item__c line : prLines){
            List<PTS_Line_Item__c> lines = vendorMap.get(line.Vendor__c+'-'+line.Requesting_Company__c+'-'+line.Quote_Currency__c);
            
            if(lines != null && lines.size() != 0 ){
                lines.add(line);
            }
            else{
                lines = new List<PTS_Line_Item__c>();
                lines.add(line);
                
                vendorMap.put (line.Vendor__c+'-'+line.Requesting_Company__c+'-'+line.Quote_Currency__c , lines);
            }
            
            line.Status__c  = 'Purchase Order Created';
        }
       
        Set<String> stringSet = vendorMap.keySet();
        
        for(String str : stringSet ){
            System.debug('Key String: '+str);
            String[] strArray= str.split('-');
            
            String vendorId = strArray[0];
            String companyId= strArray[1];
            String currencyId= strArray[2];
            
            Purchase_Order__c po = new Purchase_Order__c();            
            po.Vendor_Account__c=vendorId;
            po.Order_Status__c='Open';
            po.Company__c=companyId;
            po.PO_Currency__c=currencyId;
            pos.add(po);
        }
        
        insert pos;
        
        for(Purchase_Order__c po : pos){
            String key = po.Vendor_Account__c+'-'+po.Company__c+'-'+po.PO_Currency__c;
            List<PTS_Line_Item__c> prLine = vendorMap.get(key);
            
            //Create PO Lines
            for(PTS_Line_Item__c line: prLine ){
                    Purchase_Order_Line_Item__c poLine =new Purchase_Order_Line_Item__c ();
                    poLine.PTS_Line_Item__c = line.id;
                    poLine.Quantity_Requested__c=line.PO_Quantity__c;   
                    poLine.Dimension_1__c=line.Department__c;
                    poLine.Dimension_2__c=line.Dim_2__c;
                    poLine.Dimension_3__c=line.Dim_3__c;
                    poLine.Dimension_4__c=line.Grant__c;
                    poLine.GLA__c=line.GLA__c;
                    poLine.Requesting_Company__c=line.Requesting_Company__c;
                    poLine.Purchase_Order_Item__c= line.Purchase_Order_Item__c;
                    poLine.Unit_Price__c = line.Unit_Quote_Price__c;
                    poLine.Item__c = line.Item__c;
                    poLine.Vatable__c=line.Vatable__c;
                    poline.VAT_inclusive__c=line.VAT_Inclusive__c;
                    poLine.VAT_Percentage__c=line.VAT_Percentage__c; 
                    poLine.Purchase_Order__c = po.id;
                    
                    poLines.add(poLine);
            }
        }
        
        insert poLines;
        
        //Map PO lines to tracker        
        for(Purchase_Order_Line_Item__c poLine : poLines){
            Inventory_Replenishment_Tracker__c tracker = replenisherMap.get(poLine.PTS_Line_Item__c);
            
            if(tracker != null){
                tracker.PO_Line__c = poLine.id;
            }
        }
        
        update invTracker;
        update prLines;
        
        
        refreshList();
        return Page.requisitionworkbenchcontroller;
        
    }
    
    
    public PageReference cancelRequests(){
        List<ReplenishmentTracker> selected = getSelected();
               
        List<Inventory_Replenishment_Tracker__c> irtList = new List<Inventory_Replenishment_Tracker__c>();
        List<PTS_Line_Item__c> prList = new List<PTS_Line_Item__c>();
        
        Set<id> prIds =  new Set<id>();
        
        for(ReplenishmentTracker t : selected){
            prIds.add(t.tracker.Procurement_Request_Line_Item__c);
            t.tracker.Status__c = 'Cancelled';
            
            irtList.add(t.tracker);
        }
                
        Map<id,PTS_Line_Item__c> prLinesMap = new Map<id,PTS_Line_Item__c>([SELECT Quantity__c,Unit_Quote_Price__c,Budget_Amount__c FROM PTS_Line_Item__c WHERE id IN :prIds]);
        
        for(ReplenishmentTracker t : selected){
            
            prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c).Status__c = 'Cancelled';
            
            prList.add(prLinesMap.get(t.tracker.Procurement_Request_Line_Item__c));
        }
        
        update irtList;
        update prList;
        
        refreshList();
        
        return Page.requisitionworkbenchcontroller;
    }
    
    
    private List<ReplenishmentTracker> getSelected(){       
        List<ReplenishmentTracker> selected = new List<ReplenishmentTracker>();
                
        for(ReplenishmentTracker tracker : rList){
            if(tracker.selected == true){
                 selected.add(tracker);
            }
        }
        return selected;
    }
    
    public List<ReplenishmentTracker> getItemsToAdd(){ 
        if(itemsToAdd == null){
            itemsToAdd = new List<ReplenishmentTracker>();
            addNewItemLine();
        }              
        return itemsToAdd;
    }
    
    public void removeItemLine(){        
        String index = ApexPages.currentPage().getParameters().get('removeItemIndex');
        
        for(Integer i=0; i< itemsToAdd.size(); i++){
            if(itemsToAdd.get(i).index == index ){
              itemsToAdd.remove(i);
              break;
            }
        }
    }
    
    public PageReference manualRunMPR(){        
        Map<String, Sanergy_Settings__c> settings=Sanergy_Settings__c.getAll();        
        Integer batchSize = Integer.valueOf(settings.get('Inventory Replenisher Batch Size').value__c);
        
        InventoryItemsReplenisher batch=new InventoryItemsReplenisher();
        database.executeBatch(batch,batchSize );    
        
        closeManualRunPopup();
       refreshList();
       return Page.RequisitionWorkBenchController;
    }
    
    public PageReference saveItemsToAdd(){     
        
        List<RecordType> purchaseRecordType = [SELECT id FROM RecordType
                                               WHERE Name = 'Purchase Request Replenishment'
                                               AND SObjectType = 'Inventory_Replenishment_Tracker__c'];
        
        Map<String, Sanergy_Settings_Supply_Chain__c> settings = Sanergy_Settings_Supply_Chain__c.getAll();                                        
        
        Set<id> itemIDs = new Set<id>();   
        
        List<ReplenishmentTracker> validatedItems = new List<ReplenishmentTracker>();
        
        
        for(ReplenishmentTracker t : itemsToAdd){
            if(t.tracker.Inventory_Item__c != null && t.tracker.Quantity_Pending__c != null){
                itemIDs.add(t.tracker.Inventory_Item__c);
                validatedItems.add(t);
            }            
        }
        
        if(itemIDs.size() > 0){
            Map<id,Inventory_Item__c> invItems = new Map<id,Inventory_Item__c>([SELECT (SELECT id,Gross_Value__c, UOM_Conversion_Factor__c,Item_Cost__c,Vatable__c,VAT_Inclusive__c,VAT_Percentage__c,
                                                                                       Currency__c, Vendor__c,Inventory_Item__c, Inventory_Item__r.Item_Source__c, inventory_item__r.Policy_Quantity__c,
                                                                                       Inventory_Item__r.Item_Description__c
                                                                                       FROM Purchase_Order_Items__r
                                                                                       WHERE Vendor_Type__c = 'Primary'
                                                                                       AND Primary_Vendor__c =  true)
                                                                                  FROM Inventory_Item__c 
                                                                                  WHERE id IN :itemIDs]);
        
            List<PTS_Line_Item__c> prLines = new List<PTS_Line_Item__c>();
            
               
            for(ReplenishmentTracker t : validatedItems){
                    
                //if there is a purchase order item
                 if(invItems.get(t.tracker.Inventory_Item__c).Purchase_Order_Items__r != null && invItems.get(t.tracker.Inventory_Item__c).Purchase_Order_Items__r.size() > 0 ){
                    Purchase_Order_Item__c poItem = invItems.get(t.tracker.Inventory_Item__c).Purchase_Order_Items__r.get(0);
                    Decimal quantityAfterUoM = t.tracker.Quantity_Pending__c / ((poItem.UOM_Conversion_Factor__c==null || poItem.UOM_Conversion_Factor__c<1) ? 1 : poItem.UOM_Conversion_Factor__c) ;
                                        
                    //Create PR Lines
                    PTS_Line_Item__c pLines= new PTS_Line_Item__c(
                        Item__c = poItem.Inventory_Item__r.Item_Description__c,
                        Specifications__c = poItem.Inventory_Item__r.Item_Description__c,
                        Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                        Dim_2__c = settings.get('Dimension 2 - Mukuru').value__c,
                        Dim_3__c = settings.get('Dimension 3 - Not Applicable').value__c,
                        Grant__c = settings.get('Dimension 4 - Not Applicable').value__c,
                        GLA__c = settings.get('GLA - Inventory Items').value__c,
                        Requesting_Company__c = settings.get('Company - Sanergy').value__c,
                        Quantity__c = t.tracker.Quantity_Pending__c,
                        Budget_Amount__c = (quantityAfterUoM  * poItem.Gross_Value__c ),
                        Currency_Config__c = poItem.Currency__c,
                        Vendor__c = poItem.Vendor__c,
                        Inventory_Item__c = t.tracker.Inventory_Item__c,
                        Purchase_Order_Item__c = poItem.id,
                        Quote_Currency__c = poItem.Currency__c,
                        Unit_Quote_Price__c = poItem.Item_Cost__c,
                        Vatable__c = poItem.Vatable__c,
                        VAT_Inclusive__c = poItem.VAT_Inclusive__c,
                        VAT_Percentage__c = poItem.VAT_Percentage__c,
                        RequestType__c = 'Stock'
                    );
                    
                    prLines.add(pLines);           
                 }
                    
            } 
            
            if(prLines.size() > 0){
                 List<Inventory_Replenishment_Tracker__c> trackerList = new List<Inventory_Replenishment_Tracker__c>();
                 
                 Procurement_Tracking_Sheet__c pr =  new Procurement_Tracking_Sheet__c(
                    Requestor_Type__c = 'Reorder Level',
                    Required_Date__c = Date.today() + 14,
                     Requestor__c = settings.get('WH Inventory Requestor').value__c,//Basil Warehouse Officer
                    Requesting_Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                    Maintenance_Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                    Requesting_Company__c = settings.get('Company - Sanergy').value__c,
                    Next_Step__c = 'Pending Team Lead Approval',
                    Stage__c = 'Open',
                    Priority__c = 'High',
                    Is_Retrospective__c	 = 'No',
                    High_Priority_Comments__c = 'Generated from Inventory Replenisher'                         
                );
                
                insert pr;
                
                for(PTS_Line_Item__c line : prLines){
                    line.Procurement_Tracking_Sheet__c = pr.id;
                }
                
                insert prLines;
                
                for(PTS_Line_Item__c  line : prLines){
                    Inventory_Replenishment_Tracker__c tracker = new Inventory_Replenishment_Tracker__c(
                        recordTypeId = purchaseRecordType.get(0).id,
                        Inventory_Item__c = line.Inventory_Item__c,
                        Procurement_Request_Line_Item__c = line.id,
                        Quantity_Pending__c = line.Quantity__c           
                    );
                                        
                    trackerList.add(tracker);
                }
                
                insert trackerList;
            }
        }
        
       closeNewItemPopup();
       this.itemsToAdd = null;
       refreshList();
       return Page.RequisitionWorkBenchController;
    }
    
    public void addNewItemLine(){        
        ReplenishmentTracker tracker = new ReplenishmentTracker();
        
        tracker.tracker= new Inventory_Replenishment_Tracker__c ();
        
        itemsToAdd.add(tracker);
    }
    
    public List<SelectOption> getStatuses() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('------','--Select Status---'));
        options.add(new SelectOption('Planned','Planned'));
        options.add(new SelectOption('Firmed','Firmed'));
        options.add(new SelectOption('Approved','Approved'));
        return options;
    }
    
    public PageReference closePopup() {        
        displayPopup = false;  
        
        return Page.requisitionworkbenchcontroller;     
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public void closeNewItemPopup() {        
        displayNewItemPopup = false;  
        
       // return Page.requisitionworkbenchcontroller;     
    }     
    public void showNewItemPopup() {        
        displayNewItemPopup = true;    
    }
    
    public void closeManualRunPopup() {        
        displayManualRunPopup = false;  
        
           
    }     
    public void showManualRunPopup() {        
        displayManualRunPopup = true;    
    }
    
    public Class ReplenishmentTracker{
        public Inventory_Replenishment_Tracker__c tracker {get; set;}
        public Boolean selected {get; set;} 
        public List<SelectOption> options {get; set;}
        public String selectedVendor {get; set;}
        public String notes{get; set;}
        public Purchase_Order_Line_Item__c poLine {get; set;}
        public String index{get; set;}
        
        public ReplenishmentTracker(){
            index = Utils.getUniqueRandomString();
        }
        
        public void setOptions(Inventory_Item__c item){
             options = new List<SelectOption>();
             
             List<Purchase_Order_Item__c> vendors = item.Purchase_Order_Items__r;
             
             
             
             for(Purchase_Order_Item__c vendor : vendors){
                 if(selectedVendor == null){
                     selectedVendor = vendor.id;
                 }
                 options.add(new SelectOption(vendor.id,vendor.vendor__r.name));
             }
        }   
    }
}