@isTest(seeAllData = true)
public class REST_DepartmentsTest {
   
    static testMethod void testGetAllDepartments() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/departments';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_Departments.Department> depts= REST_Departments.getAllDepartments();
        
        System.assertEquals(false, depts.isEmpty());
        
        //calling getter methods to raise code coverage
        REST_Departments.Department department=new REST_Departments.Department();
                department.getGuid();
                department.getDivisionId();
                department.getName();
                department.getTeamLead();
    }
 
}