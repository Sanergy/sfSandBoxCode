public class CreateEmployeeDetailsFromEmployee {
    
    //variables declarations
    private String employeeId; //<-- employeeid 
    public List<Employee__c> myInfo {get;set;}
    public List<Employee__c> empUnderAManager {get;set;}
    public List<Leave_Entitlement_Utilization__c> leaveUtil {get;set;}
    public List<Leave_Accrual__c> leaveAccrual {get;set;}
    public List<Employee_Leave_Request__c> leaveRequest {get;set;}
    public List<Employee_Job_Information__c> empJobInfo {get;set;}
    public List<Sanergy_Assets_Issuance__c> sanergyAssetIssued {get;set;}
    public List<Staff_Allowances__c> payrollMod {get;set;}
    public List<Employee_Vaccination__c> empVaccination {get;set;}
    public List<Employee_Banking_Information__c> empBankInfo {get;set;}
    public List<Employee_Training__c> empTrainings {get;set;}
    public List<Employee_Union__c> empUnion {get;set;}
    public List<Employee_Benefits_Dependents__c> empBenefitDependents {get;set;}
    public List<Employee_Benefits_Plan__c> empBenPlan {get;set;}
    public List<Employee_Emergency_Contacts__c> empEmgncyContact {get;set;}
    public List<Employee_Visa_Status__c> empVisa {get;set;}
    
    Public Blob file {get;set;}
    Public Integer size {get;set;}
    public String name {get;set;}
    
    //constructor
    public CreateEmployeeDetailsFromEmployee(){
        
        //get employeeID from url
        String strId = apexpages.currentpage().getparameters().get('id');
        System.debug('Employee id from url : ' + strId);
        
        //check if id is null or not.
        // if id is null then get current logged in user else assign id to the id provided in the url
        if(strId == null || strId == '' || strId == ' '){
            //GET LoggedIn Employee Id
            this.employeeId = getEmployeeId();
            
        }else{
            
            //id from the url
            this.employeeId = strId;
        } 
        
        //methods
        fetchEmployeeDetails();
        getLeaveUtilization();
        getLeaveAccruals();
        getEmployeeLeaveRequest();
        getEmployeeJobInfo();
        getEmployeesUnderAManager();
        getIssuedAssets();
        payrollModifications();
        employeeVaccination();
        getBankingInfo();
        employeeTrainings();
        employeeUnion();
        employeeBenDependents();
        employeeBenefitPlan();
        employeeEmergencyContacts();
        employeeVisaStatus();
        
        
        System.debug('Employee did  :' + getEmployeeId());
    }
    
    //method to set the employeeId from The employeeUserId
    public String getEmployeeId(){
        
        String empid = '';
        //soql to fetch the employeeObjectId From the UserObjectId
        Employee__c empc = [SELECT ID FROM
                            Employee__c 
                            WHERE
                            Employee_SF_Account__c =: UserInfo.getUserId()
                           ];
        empid = empc.ID;
        
        return empid;
    }
    
    //method to fetch employeeDetails
    public void fetchEmployeeDetails(){
        //create an soql query to get the employee details
        //method to get logged in user info_id --> UserInfo.getUserId()
        
        myInfo = [SELECT ID, Employee_Image__c, Name,Employee_First_Name__c,Employee_Middle_Name__c,Employee_Last_Name__c,
                  Primary_Phone__c,Job_Title__c,HR_Employee_ID__c,Employee_Role__c,Recruitment_Requisition__r.Name,Company_Division__c,
                  Sanergy_Department__r.Name, Sanergy_Department_Unit__r.Name,Sanergy_Department_Unit__r.Line_Manager__r.Name,Line_Manager__c,Line_Manager__r.Name,Allowance_Approver__r.Name,
                  Sanergy_Department_Unit__r.Talent_Partner__r.Name,Primary_Location__c,Employee_Active__c,Leave_Group__r.Name,Identification_Document__c,
                  KRA_PIN__c,NHIF_Number__c,NSSF_PIN__c,HR_Unique_Record_ID__c,Identification_Number__c,Passport_No__c,Employment_Status__c,Work_Email__c,
                  HR_Number__c,Employee_SF_Account__c,Employment_Start_Date__c,Termination_Date__c,Tickets_Created__c,Payroll_ID__c,
                  Gender__c,Marital_Status__c,Address_Line_1__c,Address_Line_2__c,City__c,Post_Code__c,Home_Email__c,Education__c,Specific_Course_Undertaken__c,
                  Other_Academic_Qualification_1__c,Length_of_Service__c,Nationality__c,Preferred_Payment_Method__c,Other_Academic_Qualification_2__c,Other_Academic_Qualification_3__c,Other_Academic_Qualification_4__c,End_Date__c,
                  Date_Issued__c,Date_Received__c,X3_Month_Probation_Review_Date__c,Probation_End_Date__c,Country__c,Secondary_Phone__c,Date_of_Birth__c,Leave_Accrual_Start_Date__c,Age__c,Team_Lead__c,Team_Lead_SF_Account__c,Team_Lead_SF_Account__r.Name,Line_Manager_SF_Account__c	
                  FROM Employee__c
                  WHERE ID = : employeeId
                 ];
        
    }
    
    //method to get Employee Information
    public void getEmployeeJobInfo(){
        
        //Query to return a list with all employee job info
        empJobInfo = [SELECT Company__c,Company__r.Name,Department__c,Department__r.Name,Effective_Date__c,
                      Job_Title__c,	Job_Title__r.Name,Location__c,Location__r.Name,Reports_To__c,Reports_To__r.Name
                      FROM Employee_Job_Information__c
                      WHERE ID =: employeeId];
        
        
    }
    
    //method to get Leave Entitlement Utilization
    public void getLeaveUtilization(){
        
        //soql to get the leave utilization of a specific user
        leaveUtil = [SELECT Name,Leave_Days_Accrued__c,Leave_Days_Remaining__c,Leave_Days_Used__c,
                     Leave_Entitlement_Type_Config__c,Leave_Type__c,Total_No_of_Leave_Days__c,Leave_Type_Name__c,Leave_Year__c
                     FROM Leave_Entitlement_Utilization__c 
                     WHERE Employee__c =: employeeId
                    ORDER BY Leave_Year__c DESC,Leave_Type_Name__c
                    ];
        
    }
    
    //method to get leave accruals
    public void getLeaveAccruals(){
        
        //soql to get leave accrual
        leaveAccrual = [SELECT Name,Days_Accrued__c,Days_Worked__c,Employee__c,Employee__r.Name,Leave_Entitlement_Utilization__c,Leave_Entitlement_Utilization__r.Leave_Type__c,
                        Leave_Entitlement_Utilization__r.Leave_Type_Name__c,Period__c,Leave_Entitlement_Utilization__r.Leave_Year__c
                        FROM Leave_Accrual__c
                        WHERE Employee__c =: employeeId
                        ORDER BY Leave_Entitlement_Utilization__r.Leave_Year__c  DESC, Leave_Entitlement_Utilization__r.Leave_Type_Name__c, Period__c DESC 
                       ];
    }
    
    //method to get employee leave request
    public void getEmployeeLeaveRequest(){
        
        // SOQL to Fetch employeeLeaveRequest
        leaveRequest = [SELECT Approval_Status__c,Comments__c,Department_Team_Lead__c,Department_Team_Lead__r.Name,
                        Employee__c,Employee__r.Name,Employee_s_Department__c,Employee_s_Department__r.Name,
                        Leave_Approved__c,Leave_End_Date__c,Leave_Entitlement_Utilization__c,Leave_Start_Date__c,
                        Leave_Type__c,Next_Step__c,	Next_Step_Due_Date__c,No_Of_Approved_Leave_Days__c,
                        No_Of_Leave_Days_Requested__c,Stage__c, Leave_Entitlement_Utilization__r.Leave_Year__c
                        FROM Employee_Leave_Request__c
                        WHERE Employee__c =: employeeId 
                        ORDER BY Leave_Entitlement_Utilization__r.Leave_Year__c DESC, Leave_Start_Date__c DESC
                       ];
    }
    
    //method to get my team
    public void getEmployeesUnderAManager(){
        
        //query to fetch  employees under a loggedIn Manager
        empUnderAManager = [SELECT Id, Name, Employee_Role__c, Employee_Role__r.Name,Sanergy_Department_Unit__r.Name,
                            Primary_Location__c,Work_Email__c,Primary_Phone__c
                            FROM Employee__c
                            WHERE Line_Manager__c =: employeeId
                            ORDER BY Employee_Active__c DESC NULLS LAST
                           ];
    }
    
    //method to get the assets issued
    public void getIssuedAssets(){
        //query to fetch the assets isuued for a psecific employee
        sanergyAssetIssued = [SELECT ID ,Name, Asset_ID__c,Asset_Name__c,Issue_Type__c,Date_Issued__c,Date_Due__c,
                              Asset_Returned__c,Date_Returned__c,Item_Condition_on_Return__c
                              FROM Sanergy_Assets_Issuance__c
                              WHERE Employee__c =: employeeId
                             ];
    }
    
    //method to get payroll modifications
    public void payrollModifications(){
        
        //soql query
        payrollMod = [SELECT Name,RecordType.Name,Allowance_Description__c,Total_Allowance_Amount__c,
                      Start_Date__c,End_Date__c,Allowance_Frequency__c,isActive__c,Verified__c	
                      FROM Staff_Allowances__c
                      WHERE Employee__c =: employeeId
                     ]; 
    }
    
    //Method to get Employee Vaccinations
    public void employeeVaccination(){
        
        //soql query
        empVaccination = [SELECT Vaccination__c,Dose__c,Due_Date__c,Administered__c,Date_Administered__c
                          FROM Employee_Vaccination__c 
                          WHERE Employee__c =: employeeId
                         ];
    }
    
    //Method to get Employee Banking Information
    public void getBankingInfo(){
        
        //soql query
        empBankInfo = [SELECT BI_Effective_Date__c,BI_Bank_Name__c,BI_Bank_Branch__c,BI_Bank_Account_Number__c,
                       BI_Bank_Title__c,BI_Comments__c,CurrencyIsoCode
                       FROM Employee_Banking_Information__c
                       WHERE Employee__c =: employeeId ];
    }
    
    //Method to get employee trainings
    public void employeeTrainings(){
        
        //soql query
        empTrainings = [SELECT Employee_Training_Record__c,Employee_Training_Record__r.Name,Training_Completion_Date__c, Training_Cost__c,
                        Credits__c,Hours__c,Notes__c,Currency__c,Currency__r.Name
                        FROM Employee_Training__c
                        WHERE Employee__c =: employeeId 
                       ];
    }
    
    //Method to get Employee Union Info
    public void employeeUnion(){
        
        //soql query
        empUnion = [SELECT Effective_Date__c,Payee__c,Comments__c,Pay_Rate__c,Pay_Type__c,Unionizable_or_Non_Unionizable_Choice__c
                    FROM Employee_Union__c
                    WHERE Employee__c =: employeeId
                   ];
    }
    
    //Method to get Employee Benefit Dependents
    
    public void employeeBenDependents(){
        
        //soql query
        empBenefitDependents = [SELECT First_Name__c,Middle_Name__c,Last_Name__c,Relationship__c,Date_of_Birth__c,Gender__c,Mobile_Phone__c,Employee_Name__r.Name,Employee_Name__c
                                FROM Employee_Benefits_Dependents__c
                                WHERE Employee_Name__c =: employeeId
                               ];       
    }
    
    
    //Method to get Employee Benefit Plan
    public void employeeBenefitPlan(){
        
        //soql query
        empBenPlan = [SELECT Benefit_Plan__c,Company_Contribution__c,Effective_Date__c,Eligibility_Date__c,
                      Employee_Contribution__c,Plan_Coverage__c,Plan_Status__c
                      FROM Employee_Benefits_Plan__c
                      WHERE Employee__c =: employeeId
                     ];       
    }
    
    
    //Method to get Employee Emergency Contacts
    public void employeeEmergencyContacts(){
        
        //soql query
        empEmgncyContact = [SELECT A__c,Address_Line_2__c,City__c,Contact_Name__c,Employee__c,Employee__r.Name,
                            Country__c,Email__c,Home_Phone__c,Mobile_Phone__c,
                            Post_Code__c,Primary_Contact__c,Relationship__c,Work_Phone__c
                            FROM Employee_Emergency_Contacts__c
                            WHERE Employee__c =: employeeId
                           ];       
    }
    
    //Method to get Employee Visa Status
    public void employeeVisaStatus(){
        
        //soql query
        empVisa = [SELECT Current_Status__c,Current_Visa__c,Documentation_Available__c,Effective_Date__c,Expiry_Date__c,Visa_Status__c
                   FROM Employee_Visa_Status__c
                   WHERE Employee__c =: employeeId
                  ];       
    }
    
    //method to handle the upload
    /**
    public void upload(){
       
        //attachement with photo
        Attachment objA = new Attachment();
        objA.body = fileContent;
        objA.Name = 'testPic';
        objA.ParentId = employeeId;
        objA.ContentType = '';
        System.debug('content Type ==> ' + fileContent);
        // employeeId
        
        ContentVersion img = new ContentVersion();
        img.VersionData = file;
        img.VersionData = EncodingUtil.base64Decode(ConType);
        img.PathOnClient = '/file';
        
        //try uploading the photo
        try{
            insert img;
            System.debug('Result >>>>>' + img.PathOnClient);
        }catch(DMLException e){
			System.debug('Failed >>>>>' + e);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Document in Library'));
            
        }
        
    }
 */
    
}