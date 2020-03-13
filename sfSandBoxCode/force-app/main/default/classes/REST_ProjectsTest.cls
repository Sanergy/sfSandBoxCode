@isTest(seeAllData = true)
public class REST_ProjectsTest {
   
    static testMethod void testGetAllDepartments() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/projects';
                
        System.RestContext.response = new RestResponse();
        
        List<REST_Projects.Project> projects= REST_Projects.getAllProjects();
        
        System.assertEquals(false, projects.isEmpty());
        
         //calling getter methods to raise code coverage
         REST_Projects.Project project=new REST_Projects.Project();
           project.getGuid();
            project.getName();
            project.getDivision();
            project.getItemNumber();
         
    }
 
}