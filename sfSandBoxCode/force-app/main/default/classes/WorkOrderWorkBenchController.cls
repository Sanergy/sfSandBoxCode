public class WorkOrderWorkBenchController{
    
    public List<ReplenishmentTracker> rList {get; set;}
    public String selectedStatus {get; set;}
    
    public WorkOrderWorkBenchController(){
        
        rList = new List<ReplenishmentTracker>();
        List<Inventory_Replenishment_Tracker__c> replenishmentList = [SELECT Inventory_Item__c, Inventory_Item__r.Item_Company__c, Inventory_Item__r.Inventory_Stock__c,
                                                                     Inventory_Item__r.Minimum_Quantity__c, Quantity_Pending__c, Work_Order__c, 
                                                                     Work_Order__r.Inventory_Item_Quantity__c,
                                                                     RecordType.name,Status__c,CreatedDate,Firm_Date__c,Approved_Date__c
                                                                     FROM  Inventory_Replenishment_Tracker__c
                                                                     WHERE Status__c != 'Cancelled'
                                                                     AND Status__c!= 'Closed'
                                                                     AND RecordType.name = 'Work Order Replenishment'];
                                                                     
        for(Inventory_Replenishment_Tracker__c irt : replenishmentList){
           
            ReplenishmentTracker rt = new ReplenishmentTracker();            
            rt.tracker = irt;
            
            rList.add(rt);
        }
    }
    
    public void refreshList(){
        if(this.selectedStatus != null){
            this.rList = new List<ReplenishmentTracker>();
            
            List<Inventory_Replenishment_Tracker__c> replenishmentList = [SELECT Inventory_Item__c, Inventory_Item__r.Item_Company__c, Inventory_Item__r.Inventory_Stock__c,
                                                                         Inventory_Item__r.Minimum_Quantity__c, Quantity_Pending__c, Work_Order__c,
                                                                         Work_Order__r.Inventory_Item_Quantity__c, 
                                                                         RecordType.name,Status__c,CreatedDate,Firm_Date__c,Approved_Date__c 
                                                                         FROM  Inventory_Replenishment_Tracker__c
                                                                         WHERE Status__c != 'Cancelled'
                                                                         AND Status__c!= 'Closed'
                                                                         AND RecordType.name = 'Work Order Replenishment'
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
        List<Work_Order__c> woList = new List<Work_Order__c>();
        
        Set<id> woIds =  new Set<id>();
        
        for(ReplenishmentTracker t : selected){
            woIds.add(t.tracker.Work_Order__c);
            t.tracker.Status__c = 'Firmed';
            t.tracker.Firm_Date__c = Date.today();
            
            irtList.add(t.tracker);
        }
                
        Map<id,Work_Order__c> woLinesMap = new Map<id,Work_Order__c>([SELECT Inventory_Item_Quantity__c,Status__c  FROM Work_Order__c WHERE id IN :woIds]);
        
        for(ReplenishmentTracker t : selected){
            woLinesMap.get(t.tracker.Work_Order__c).Inventory_Item_Quantity__c = t.tracker.Work_Order__r.Inventory_Item_Quantity__c;
            woLinesMap.get(t.tracker.Work_Order__c).Status__c = 'Firmed';
            
            woList.add(woLinesMap.get(t.tracker.Work_Order__c));
        }
        
        update irtList;
        update woList;
        
        refreshList();
        
        return Page.WorkOrderWorkbench;
    }
    
    
    public PageReference cancelRequests(){
        List<ReplenishmentTracker> selected = getSelected();
               
        List<Inventory_Replenishment_Tracker__c> irtList = new List<Inventory_Replenishment_Tracker__c>();
        List<Work_Order__c> woList = new List<Work_Order__c>();
        
        Set<id> woIds =  new Set<id>();
        
        for(ReplenishmentTracker t : selected){
            woIds.add(t.tracker.Work_Order__c);
            t.tracker.Status__c = 'Cancelled';
            
            irtList.add(t.tracker);
        }
                
        Map<id,Work_Order__c> woLinesMap = new Map<id,Work_Order__c>([SELECT Inventory_Item_Quantity__c,Status__c  FROM Work_Order__c WHERE id IN :woIds]);
        
        for(ReplenishmentTracker t : selected){
            
            woLinesMap.get(t.tracker.Work_Order__c).Status__c = 'Closed';
            
            woList.add(woLinesMap.get(t.tracker.Work_Order__c));
        }
        
        update irtList;
        update woList;
        
        refreshList();
        
        return Page.WorkOrderWorkbench;
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
    
    
    public List<SelectOption> getStatuses() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('------','--Select Status---'));
        options.add(new SelectOption('Planned','Planned'));
        options.add(new SelectOption('Firmed','Firmed'));
        return options;
    }
    
    public Class ReplenishmentTracker{
        public Inventory_Replenishment_Tracker__c tracker {get; set;}
        public Boolean selected {get; set;}
    
    }
}