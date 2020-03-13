public class EmployeesWhoAreOnLeave {
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    // Leave in between list
    public List<Employee_Leave_Request__c> leaveBetweenList{get;set;}
    
    // Employees going on leave in the next 30 days
    public List<Employee_Leave_Request__c> employeesOnLeave{get;set;}
    
    //Get the id of the Employee_Leave_Request_c 
    public Employee_Leave_Request__c leaveRequest{get; set;}
    
    //Get Employees  
    public Date leaveStartDate;
    public Date leaveEndDate;

    // Constructor
    public EmployeesWhoAreOnLeave(){ 
        leaveStartDate = date.today();
		leaveEndDate = date.today() + 30;
        getEmployeesOnLeave();
    }
    
    // Constructor
    public EmployeesWhoAreOnLeave(ApexPages.StandardController controller){               
        this.controller = controller;
        leaveRequest = (Employee_Leave_Request__c)controller.getRecord();
        System.debug('EEEE' + leaveRequest);
        leaveRequest= [SELECT Id, Name,Leave_Entitlement_Utilization__c,Employee__c,Employee__r.Name,Leave_Start_Date__c,Leave_End_Date__c,
                       Employee_s_Department__c,Employee_s_Department__r.Name,Approval_Status__c,Leave_Approved__c,Leave_Type__c,No_Of_Leave_Days_Requested__c,No_Of_Approved_Leave_Days__c,
                       Employee__r.Leave_Accrual_Start_Date__c 
                       FROM Employee_Leave_Request__c														
                       WHERE ID =: leaveRequest.Id
                      ];
        
        
    }
    
    //Get the People On leave in Between the days the days the Employee is Requesting for Leave 
    public List<Employee_Leave_Request__c> getLeaveBetween(){
        leaveBetweenList = [SELECT Id, Name,Leave_Entitlement_Utilization__c,Employee__c,Employee__r.Name,Leave_Start_Date__c,Leave_End_Date__c,Employee__r.Employee_active__c,
                            Employee_s_Department__c,Employee__r.Sanergy_Department__r.Name,Approval_Status__c,Leave_Approved__c,Leave_Type__c,No_Of_Leave_Days_Requested__c,
                            No_Of_Approved_Leave_Days__c,Employee__r.Leave_Accrual_Start_Date__c 
                            FROM Employee_Leave_Request__c														
                            WHERE ((Leave_Start_Date__c >=: leaveRequest.Leave_Start_Date__c AND Leave_Start_Date__c <=: leaveRequest.Leave_End_Date__c) 
                                   OR (Leave_End_Date__c >=: leaveRequest.Leave_Start_Date__c AND Leave_Start_Date__c <=: leaveRequest.Leave_End_Date__c)) 
                            AND (Approval_Status__c = 'Approved by HR' OR Approval_Status__c = 'Pending Approval')
                            AND (Employee__r.Employee_active__c = true)
                            ORDER BY Leave_Start_Date__c DESC
                           ];
        System.debug('LEAVE BETWEEN: ' + leaveBetweenList);
        return leaveBetweenList;
        
    }
    
    //Employees going on leave in the next 30 days
    public List<Employee_Leave_Request__c> getEmployeesOnLeave(){
        employeesOnLeave = [SELECT Id, Name,Leave_Entitlement_Utilization__c,Employee__c,Employee__r.Name,Leave_Start_Date__c,Leave_End_Date__c,Employee__r.Employee_active__c,
                            Employee_s_Department__c,Employee__r.Sanergy_Department__r.Name,Approval_Status__c,Leave_Approved__c,Leave_Type__c,No_Of_Leave_Days_Requested__c,
                            No_Of_Approved_Leave_Days__c,Employee__r.Leave_Accrual_Start_Date__c 
                            FROM Employee_Leave_Request__c														
                            WHERE ((Leave_Start_Date__c >=: leaveStartDate AND Leave_Start_Date__c <=: leaveEndDate) 
                                   OR (Leave_End_Date__c >=: leaveStartDate AND Leave_End_Date__c <=: leaveEndDate)) 
                            AND (Approval_Status__c = 'Approved by HR' AND Employee__r.Employee_active__c = true)                            
                            ORDER BY Leave_Start_Date__c ASC
                           ];
        
        System.debug('EMPLOYEES ON LEAVE: ' + employeesOnLeave);
        return employeesOnLeave;
    }    
}