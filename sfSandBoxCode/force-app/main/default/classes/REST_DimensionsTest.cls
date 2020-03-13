@isTest(seeAllData = true)
public class REST_DimensionsTest {
   
    static testMethod void testGetAllDimensions() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/dimensions';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_Dimensions.DimensionHolder> recs = REST_Dimensions.getAllDimensions();
        
        System.assertEquals(false, recs.isEmpty());
        
        
        //to add code coverage, call the getters of the util class
        REST_Dimensions.DimensionHolder rrecs=new REST_Dimensions.DimensionHolder();
            rrecs.getName();
            rrecs.getDescription();
            rrecs.getGuid();
            rrecs.getDimension();
    }
 
}