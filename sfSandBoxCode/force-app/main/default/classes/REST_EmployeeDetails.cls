//GET details for logged in User
@RestResource(urlMapping='/api/employee')
global with sharing class REST_EmployeeDetails {
    
    @HttpGet
    global static List<EmployeeDetails> getLoggedInUserDetails() {
        
        List<EmployeeDetails> employeeInformation = new List<EmployeeDetails>();
        
        List<Employee__c> employee_details = [SELECT Id, Name, Company_Division__c,Sanergy_Department__r.Name,
                                              Sanergy_Department_Unit__r.Name,Primary_Phone__c,
                                              Team_Lead_SF_Account__r.Name
                                              FROM Employee__c 
                                              WHERE Employee_SF_Account__c =: UserInfo.getUserId()
                                              ORDER BY Name ASC];
        
        if(employee_details != null && employee_details.size()> 0){
            
            for(Employee__c employee : employee_details){
                
                EmployeeDetails detail = new EmployeeDetails();
                
                detail.guid = employee.Id;
                detail.name = employee.Name;
                detail.phone = employee.Primary_Phone__c;
                detail.company = employee.Company_Division__c;
                detail.department = employee.Sanergy_Department__r.Name;
                detail.departmentUnit = employee.Sanergy_Department_Unit__r.Name;
                detail.teamLead = employee.Team_Lead_SF_Account__r.Name;
                
                employeeInformation.add(detail);
            }
        }
        
        return employeeInformation;
    }
    
    global class EmployeeDetails {        
        public String guid;
        public String name;
        public String phone;        
        public String company;
        public String department;
        public String departmentUnit;
        public String teamLead;
    }     
  
}