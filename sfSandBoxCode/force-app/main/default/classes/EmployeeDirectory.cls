public class EmployeeDirectory {
    
    public List <Employee__c> employees {get;set;}
    public String searchText {get;set;}
    public String filterValue {get;set;}
    public Boolean active;
    
    //constructor
    public EmployeeDirectory(){
        //get employeeDetails when the method is called
        getEmployeeDetails();
        searchText = '';
        filterValue = '';
    } 
    
    public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Active','Active Employees'));
        options.add(new SelectOption('Inactive','Inactive Employees'));
        //options.add(new SelectOption('%%','All Employees'));
        return options;
    }
    
    public void getEmployeeDetails(){
        
        //Select employee details from the employee table
        
        if(searchText == '' ){
            employees = [SELECT Id, Name, Profile_Picture__c, Employee_Role__c, Employee_Role__r.Name,Sanergy_Department_Unit__r.Name,HR_Unique_Record_ID__c,
                         Primary_Location__c, Sanergy_Department__c,Sanergy_Department__r.Name,Work_Email__c,Primary_Phone__c
                         FROM Employee__c
                         ORDER BY Name ASC];
            
            System.debug('filter : '+filterValue);
            
        }else{
            searchText = '%'+ searchText + '%';
            if(filterValue != null){
                if(filterValue == 'Active'){
                    active = true;
                }else if(filterValue == 'Inactive'){
                    active = false;
                }else{
                    active = true;
                }
            }
            employees = [SELECT Id, Name, Profile_Picture__c, Employee_Role__c, Employee_Role__r.Name,Sanergy_Department_Unit__r.Name,HR_Unique_Record_ID__c,
                         Primary_Location__c, Sanergy_Department__c,Sanergy_Department__r.Name,Work_Email__c,Primary_Phone__c
                         FROM Employee__c
                         WHERE (Name LIKE : searchText 
                         OR Sanergy_Department__r.Name LIKE : searchText
                         OR Sanergy_Department_Unit__r.Name LIKE : searchText
                         OR Employee_Role__r.Name LIKE : searchText)
                         AND Employee_Active__c  =: active
                         ORDER BY Name ASC];
            
            System.debug('employee ' + employees);
            
            //after fetching the employees clear the % sign on the searchText
            searchText = searchText.replaceAll('%','');
            
            System.debug('filter : '+filterValue);
        }
        System.debug('EMPLOYEE: ' + employees);
        
    }

}