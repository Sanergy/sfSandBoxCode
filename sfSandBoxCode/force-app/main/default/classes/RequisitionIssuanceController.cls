public class RequisitionIssuanceController {
    
    public ApexPages.StandardController standardController;
    public Inventory_Requisition__c requisition{get; set;}
    public Id inventoryItem;
    public List<IssuanceItem> issuanceList;
    
    public RequisitionIssuanceController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.requisition = (Inventory_Requisition__c)standardController.getRecord();
        issuanceList = new List<IssuanceItem>();
        
        List<Inventory_Requisition_Item__c> items = [SELECT Id,Name,GLA__c,Inventory_Item__c, Inventory_Requisition__c,
                                                     Issued_Quantity__c, Notes__c, Quantity__c, Quantity_Remaining__c,
                                                     GLA__r.lookup_ID__c, GLA__r.Name,
                                                     Inventory_Requisition__r.Request_Date__c,
                                                     Inventory_Requisition__r.Creator__c,
                                                     Inventory_Requisition__r.Department__c,
                                                     Inventory_Requisition__r.Required_Date__c,
                                                     Inventory_Requisition__r.Requestor__c,
                                                     Inventory_Requisition__r.Department__r.lookup_ID__c,
                                                     Inventory_Requisition__r.Dimension_2__r.lookup_ID__c,
                                                     Inventory_Requisition__r.Dimension_3__r.lookup_ID__c,
                                                     Inventory_Requisition__r.Dimension_4__r.lookup_ID__c,
                                                     Inventory_Item__r.Name,
                                                     Inventory_Item__r.unit_cost__c,
                                                     Inventory_Item__r.Item_Group__c
                                                     FROM Inventory_Requisition_Item__c 
                                                     WHERE Inventory_Requisition__c =: this.requisition.Id 
                                                        AND Quantity_Remaining__c > 0
                                                    ];
        
        for(Inventory_Requisition_Item__c item:items){
            IssuanceItem wr = new IssuanceItem(item);
            issuanceList.add(wr);
        }
    }
    
    public PageReference selectAll() {
        if(issuanceList != null){
            for(IssuanceItem lg:issuanceList){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(issuanceList != null){
            for(IssuanceItem lg:issuanceList){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    public List<IssuanceItem> getIssuanceList(){
        return this.issuanceList;
    }
    
    public PageReference  processSelected() {
        
         if(issuanceList != null && issuanceList.size() > 0){
            
            integer issued = 0;
            integer expected = 0;
            
            for(IssuanceItem item : issuanceList){
                
                if(item.selected == true){
                    
                    if(item.item.Quantity_Remaining__c >= item.issueQuantity && item.issueQuantity <= item.selectedLot.Quantity__c && item.selectedLot != null && item.selected ){
                   
                        List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                       FROM Group_Details__c
                                                       WHERE Inventory_Item_Group__c = :item.item.Inventory_Item__r.Item_Group__c
                                                       AND Transaction_ID__c = :'INVLOCADJ'
                                                       AND Is_GL_Account__c = true
                                                      ];
                        
                        Group_Details__c creditGl = null;
                        
                        for(Group_Details__c gla : glas){
                            if(gla.Credit_Debit__c == 'Credit'){
                                creditGl = gla;
                            }
                        }
                        
                        if(item.item.GLA__r.lookup_ID__c != null && creditGl != null){
                            //insert issuance record
                            item.issuanceItem.Quantity__c = item.issueQuantity;
                            insert item.issuanceItem;   
                            
                            //insert 
                            Inventory_Transaction__c trans = new Inventory_Transaction__c();
                                trans.Item__c = item.item.Inventory_Item__c;
                                trans.Transaction_ID__c = 'INVISSUE';
                                trans.Location__c = item.location;
                                trans.Location_Lot__c = item.lot;
                                trans.Transaction_Quantity__c = item.issueQuantity;
                                trans.Item_Unit_Price__c = item.item.Inventory_Item__r.unit_cost__c;
                                trans.Quantity_Impact__c = 'D';
                                trans.Debit_Account__c = item.item.GLA__r.lookup_ID__c;
                                trans.Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                                trans.Dimension_1__c = item.item.Inventory_Requisition__r.Department__r.lookup_ID__c;
                                trans.Dimension_2__c = item.item.Inventory_Requisition__r.Dimension_2__r.lookup_ID__c;
                                trans.Dimension_3__c = item.item.Inventory_Requisition__r.Dimension_3__r.lookup_ID__c;
                                trans.Dimension_4__c = item.item.Inventory_Requisition__r.Dimension_4__r.lookup_ID__c;
                                trans.Comments__c = item.item.Inventory_Item__r.Name;
                            	trans.Inventory_Requisition_Issuance__c = item.issuanceItem.id;

                            
                            insert trans;
                        
                            expected +=1;
                            
                   
                        } else {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit GL Accounts ' + item.item.GLA__r.lookup_ID__c + ' <=> ' + creditGl);
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
            }
                    
            if(expected == issued){
                return new PageReference('/' + this.requisition.Id);
            } else {
                return new PageReference('/' + this.requisition.Id);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Some Items Were not Issued');
                ApexPages.addmessage(msg);
                return null;
            }
            
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly confirm that the selected Item has enough quantities and the issue quantity is correct'));
            return null;
        }
        
        return null;
    }
    
    public List<SelectOption> getSites() {
        
        List<SelectOption> sites= new List<SelectOption>();
        SelectOption defopt = new SelectOption('NA', '----------');
        sites.add(defopt);
        
        List<Inventory_Location__c> locations = [Select Id, Name, Description__c
                                                              From Inventory_Location__c
                                                             ];
        for(Inventory_Location__c location : locations){
            SelectOption option = new SelectOption(location.Id, location.Name);
            sites.add(option);
        }

        return sites;
    }
    
    public class IssuanceItem{
        
        public Double issueQuantity {get; set;}
        public String site {get; set;}
        public String location {get; set;}
        public String lot {get; set;}
        public Item_Location_Lot__c selectedLot {get; set;}
        public List<SelectOption> locations {get; set;}
        public List<SelectOption> lots {get; set;}
        
        public Inventory_Requisition_Issuance__c issuanceItem {get; set;}
        public Inventory_Requisition_Item__c item {get; set;}
        public Boolean selected {get; set;}
        Public Double quantityRemaining{get; set;} 

        public IssuanceItem(Inventory_Requisition_Item__c line) {
            item = line;
            issuanceItem = new Inventory_Requisition_Issuance__c();
            
            this.quantityRemaining = line.Quantity__c - line.Issued_Quantity__c;
            issuanceItem.Date_Issued__c = date.today();
            issuanceItem.Received_By__c = line.Inventory_Requisition__r.Requestor__c;            
            issuanceItem.Inventory_Requisition_Item__c = line.id;            
            issuanceItem.Quantity__c = issueQuantity;
        	
            this.selected = true;
        }
        
         public void setLocs() {
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
        
         public void setLots() {
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
        
         public void selectLot() {
             
            issueQuantity = item.Quantity_Remaining__c;
             
            if(lot != null && !lot.equals('NA')){
                selectedLot = [Select Id, Name,Quantity__c
                               From Item_Location_Lot__c
                               WHERE id = :this.lot
                              ];
            }
       
        }
    }
}