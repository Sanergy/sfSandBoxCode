@isTest(seeAllData = true)
public class REST_InventoryItemLocsTest {
   
    static testMethod void testGetAllLocations() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/inv_item_locations';
                
        System.RestContext.response = new RestResponse();
        
        List<String> itemIds = new List<String>();
        List<rstk__icitem__c> itms=[SELECT ID 
                                    FROM rstk__icitem__c
                                    LIMIT 1];
                                    
        itemIds.add(itms.get(0).ID);
        
        List<REST_InventoryItemLocs.ItemLocation> recs = REST_InventoryItemLocs.getAllLocations(itemIds, null);
        
        //System.assertEquals(true, recs.isEmpty());
    }
    
    static testMethod void testGetAllLocationsWhithProj() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/inv_item_locations';
                
        System.RestContext.response = new RestResponse();
        
        List<String> itemIds = new List<String>();
         
                                    
        
        
          List<rstk__iclocitem__c> sanItmLocs = [SELECT rstk__iclocitem_icitem__c,rstk__iclocitem_proj__c
                                                 FROM rstk__iclocitem__c 
                                                 WHERE rstk__iclocitem_icitem__c <> null
                                                 AND rstk__iclocitem_proj__c <> null
                                                 LIMIT 1];
                                                 
          itemIds.add(sanItmLocs .get(0).rstk__iclocitem_icitem__c);
        
        List<REST_InventoryItemLocs.ItemLocation> recs = REST_InventoryItemLocs.getAllLocations(itemIds, sanItmLocs .get(0).rstk__iclocitem_proj__c);
        
        //System.assertEquals(true, recs.isEmpty());
    }
 
}