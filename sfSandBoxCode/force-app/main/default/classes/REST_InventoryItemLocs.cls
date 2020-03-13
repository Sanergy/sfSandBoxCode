@RestResource(urlMapping='/inv_item_locations')
global with sharing class REST_InventoryItemLocs {

    @HttpPost
    global static List<ItemLocation> getAllLocations(List<String> itemIds, String projectId) {
    
        List<ItemLocation> itemLocations = new List<ItemLocation>();
        
        List<rstk__iclocitem__c> sanItmLocs = null;
        
        if(projectId != null) {
        
            sanItmLocs = [SELECT Id, Name, rstk__iclocitem_locid__c, rstk__iclocitem_locqty__c,
                             rstk__iclocitem_locnum__c, rstk__iclocitem_icitem__c,
                             rstk__iclocitem_div__c, rstk__iclocitem_proj__c, rstk__iclocitem_site__c
                             FROM rstk__iclocitem__c 
                             WHERE rstk__iclocitem_icitem__c IN :itemIds AND rstk__iclocitem_proj__c = :projectId];
        } else {
        
            sanItmLocs = [SELECT Id, Name, rstk__iclocitem_locid__c, rstk__iclocitem_locqty__c,
                             rstk__iclocitem_locnum__c, rstk__iclocitem_icitem__c,
                             rstk__iclocitem_div__c, rstk__iclocitem_proj__c, rstk__iclocitem_site__c
                             FROM rstk__iclocitem__c 
                             WHERE rstk__iclocitem_icitem__c IN :itemIds];
        }
        
        if(sanItmLocs != null && sanItmLocs.size()> 0){
        
            for(rstk__iclocitem__c sanItmLoc : sanItmLocs){
            
                ItemLocation itemLocation = new ItemLocation();
                
                itemLocation.guid = sanItmLoc.Id;
                itemLocation.name = sanItmLoc.Name;
                itemLocation.locationId = sanItmLoc.rstk__iclocitem_locid__c;
                itemLocation.quantity = sanItmLoc.rstk__iclocitem_locqty__c;
                itemLocation.locationNumber = sanItmLoc.rstk__iclocitem_locnum__c;
                itemLocation.itemNumber = sanItmLoc.rstk__iclocitem_icitem__c;
                itemLocation.division = sanItmLoc.rstk__iclocitem_div__c;
                itemLocation.project = sanItmLoc.rstk__iclocitem_proj__c;
                itemLocation.site = sanItmLoc.rstk__iclocitem_site__c;
            
                itemLocations.add(itemLocation);
            }
        }
        
        return itemLocations;
    }
    
    global class ItemLocation {
        
        public String guid;
        public String name;
        public String locationId;
        public Decimal quantity;
        public String itemName;
        public String locationNumber;
        public String itemNumber;
        public String division;
        public String project;
        public String site;
    }
}