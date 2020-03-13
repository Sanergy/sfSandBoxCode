@isTest(seeAllData = true)
public class REST_Rootstock_ItemsTest {
   
    static testMethod void testGetAllRSItems() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/items';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_Rootstock_Items.ItemHolder> rsItem= REST_Rootstock_Items.getAllInventoryItems();
        
        System.assertEquals(false, rsItem.isEmpty());
        
               
    }
 
}