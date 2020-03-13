@isTest(seeAllData = true)
public class REST_RecordTypesTest {
   
    static testMethod void testGetAllDepartments() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/record_types';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_RecordTypes.RecType> recordType= REST_RecordTypes.getAllRecordTypes();
        
        System.assertEquals(false, recordType.isEmpty());
        
        //calling getter methods to raise code coverage
        REST_RecordTypes.RecType rec= new REST_RecordTypes.RecType();
         rec.getGuid();
         rec.getName();
    }
 
}