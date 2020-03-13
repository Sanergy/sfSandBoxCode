@RestResource(urlMapping='/employees')
global with sharing class REST_Employees {

    @HttpPost
    global static List<Employee> getAllEmployees() {
        
        List<Employee> employees = new List<Employee>();
        
        List<Employee__c> sanEmployees = [SELECT Id, Name, Employee_Active__c, Employee_First_Name__c, Employee_Last_Name__c,
                                            Employee_Middle_Name__c, Employment_Start_Date__c, Employment_Status__c,
                                            HR_Employee_ID__c, HR_Unique_Record_ID__c, Identification_Document__c, Identification_Number__c,
                                            Job_Title__c, Line_Manager__c, Line_Manager__r.Work_Email__c, Primary_Location__c, Primary_Phone__c,   Sanergy_Department__c,
                                            Sanergy_Department_Unit__c, Termination_Date__c, Work_Email__c FROM Employee__c
                                            WHERE Employee_First_Name__c != NULL
                                            AND Employee_Last_Name__c != NULL
                                            AND Job_Title__c != NULL];
        
        if(sanEmployees != null && sanEmployees.size()> 0){
        
            for(Employee__c sanEmployee : sanEmployees){
            
                Employee employee = new Employee();
                
                employee.guid = sanEmployee.Id;
                employee.name = sanEmployee.Name;
                employee.department = sanEmployee.Sanergy_Department__c; 
                employee.departmentUnit = sanEmployee.Sanergy_Department_Unit__c;
                employee.isActive = sanEmployee.Employee_Active__c;
                employee.firstName = sanEmployee.Employee_First_Name__c;   
                employee.otherNames = sanEmployee.Employee_Middle_Name__c;
                employee.lastName = sanEmployee.Employee_Last_Name__c;
                employee.startDate = sanEmployee.Employment_Start_Date__c;
                employee.employmentStatus = sanEmployee.Employment_Status__c;
                employee.employeeId = sanEmployee.HR_Employee_ID__c;
                employee.employmentNumber = sanEmployee.HR_Employee_ID__c;
                employee.identificationDocument = sanEmployee.Identification_Document__c;
                employee.identificationNumber = sanEmployee.Identification_Number__c;
                employee.jobTitle = sanEmployee.Job_Title__c;
                employee.lineManager = sanEmployee.Line_Manager__c;
                employee.primaryLocation = sanEmployee.Primary_Location__c;
                employee.primaryPhone = sanEmployee.Primary_Phone__c;
                employee.terminationDate = sanEmployee.Termination_Date__c;
                employee.workEmail = sanEmployee.Work_Email__c;
                employee.managerEmail= sanEmployee.Line_Manager__r.Work_Email__c;
            
                employees.add(employee);
            }
        }
        
        return employees;
    }
    
    global class Employee {
    
        public String guid;
        public String name;
        public String department;
        public String departmentUnit;
        public Boolean isActive;
        public String firstName;
        public String otherNames;
        public String lastName;
        public Date startDate;
        public String employmentStatus;
        public String employeeId;
        public String employmentNumber;
        public String identificationDocument;
        public String identificationNumber;
        public String jobTitle;
        public String lineManager;
        public String primaryLocation;
        public String primaryPhone;
        public Date terminationDate;
        public String workEmail;
        public String managerEmail;
    
    }
}