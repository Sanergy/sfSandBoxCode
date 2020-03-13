@isTest(seeAllData = true)
public class REST_GlaAccountsTest {
   
    static testMethod void testGetAllAccounts() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/gla_accounts';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_GlaAccounts.GlaAccount> recs = REST_GlaAccounts.getAllAccounts();
        
        System.assertEquals(false, recs.isEmpty());
                
    }
 
}