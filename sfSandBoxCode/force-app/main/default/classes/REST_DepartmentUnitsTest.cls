@isTest(seeAllData = true)
public class REST_DepartmentUnitsTest {
   
    static testMethod void testGetAllDepartmentUnits() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/department_units';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_DepartmentUnits.DepartmentUnit> units = REST_DepartmentUnits.getAllDepartmentUnits();
        
        System.assertEquals(false, units.isEmpty());
        
        //calling getter methods to raise code coverage
        REST_DepartmentUnits.DepartmentUnit unit=new REST_DepartmentUnits.DepartmentUnit();
                unit.getGuid();
                unit.getDepartment();
                unit.getName();
                unit.getLineManager();
    }
}