@isTest(seeAllData = true)
public class REST_SiteTest {
   
    static testMethod void testGetAllSites() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/sites';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_Site.Site> site= REST_Site.getAllSites();
        
        System.assertEquals(false, site.isEmpty());
        
        //calling getter methods to raise code coverage
        REST_Site.Site sitee=new REST_Site.Site();
        sitee.getName();
        sitee.getDescription();
        sitee.getGuid();
        sitee.getDivision();
    }
 
}