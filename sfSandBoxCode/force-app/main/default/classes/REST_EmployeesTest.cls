@isTest(seeAllData = true)
public class REST_EmployeesTest {
   
    static testMethod void testGetAllEmployees() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/employees';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_Employees.Employee > recs = REST_Employees.getAllEmployees();
        
        System.assertEquals(false, recs.isEmpty());
        
        REST_Employees.Employee employee=new REST_Employees.Employee();
     
      }
 
}