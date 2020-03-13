public class DelegateTLApprovals
{
    //Create standard controller
    private ApexPages.StandardController controller;
    public Employee__c employee {get; set;} 
    //public Employee__c delegateTo {get; set;}
    public List<Sanergy_Department__c> deptList {get; set;} 
    public List<Sanergy_Department_Unit__c> deptUnitList {get; set;} 
    public List<FFA_Config_Object__c> ffaConfigList {get; set;} 
    public List<Sanergy_Department__c> TLDepts {get; set;} 
    public List<Sanergy_Department_Unit__c> TLDeptUnits {get; set;} 
    public List<FFA_Config_Object__c> TLFFAConfigs {get; set;} 
    public LookupValue empToDelegate {get;set;}
    public List<DepartmentWrapper> TLDeptsWrp {get; set;}
    public List<DepartmentUnitWrapper> TLDeptUnitsWrp {get; set;}
    public List<FFAConfigWrapper> FFAConfigsWrp {get; set;}
    public String NotificationMsg {get; set;}
    public Employee__c empDelegateFound {get; set;} 
    
    // Constructor
    public DelegateTLApprovals(ApexPages.StandardController controller){               
        this.controller = controller;
        employee = (Employee__c)controller.getRecord(); 
        //override the employee to get the details from the method fetchEmployeeInfo
        String EmployeeId = apexpages.currentpage().getparameters().get('EmployeeId');
        //allow Sys Admin to enter EmployeeId and impersonate user
        system.debug('Heher' + EmployeeId + ' ' + UserInfo.getProfileId() + ' employee obj = ' + employee);
        if(String.isBlank(EmployeeId) == FALSE && UserInfo.getProfileId() == Id.ValueOf('00eD0000001kXVa')){ //sys admin
            employee = fetchEmployeeInfo(EmployeeId); 
            system.debug('Heher' + employee);
        }else {
            //NO id found, get from user ID
            Employee__c emp = 
                [SELECT ID,Name,Sanergy_Department_Unit__c,Leave_Accrual_Start_Date__c,
                 Sanergy_Department_Unit__r.Approver__c, Line_Manager_SF_Account__c, Employee_SF_Account__c
                 FROM Employee__c WHERE Employee_SF_Account__c =: UserInfo.getUserId()
                 LIMIT 1
                ];
            
            employee = fetchEmployeeInfo(emp.id); 
        }
        
        
        this.empToDelegate = new LookupValue();
        empDelegateFound = new Employee__c();
        //set default
        if(employee != NULL){
            //SF Record Exists
            List<Employee__c> empDetails;
            //soql to fetch the employeeObjectId From the UserObjectId
            empDetails = [SELECT ID,Name,Sanergy_Department_Unit__c,Leave_Accrual_Start_Date__c,
                          Sanergy_Department_Unit__r.Approver__c, Line_Manager_SF_Account__c,
                          Employee_SF_Account__c
                          FROM Employee__c 
                          WHERE id =: employee.id
                          LIMIT 1
                         ];
            
            TLDeptsWrp = new List<DepartmentWrapper>();
            TLDeptUnitsWrp = new List<DepartmentUnitWrapper>();
            FFAConfigsWrp = new List<FFAConfigWrapper>();
            //Get List of Departments the employee is in charge of
            TLDeptsWrp = getTLDepts(Id.valueOf(employee.Id));
            //Get List of Department Units the employee is in charge of
            TLDeptUnitsWrp = getTLDeptUnits(Id.valueOf(employee.Id));
            //Get List of FFA Config DIM 1s the employee is in charge of
            FFAConfigsWrp = getTLFFAConfigs(Id.valueOf(employee.Id));
        }
    }     
    
    //Get all active Depts
    public List<DepartmentWrapper> getTLDepts(Id EmpID){ 
        deptList = 
            [
                SELECT Id, Name,Department_Code__c, Department_Status__c, Team_Lead__c, Team_Lead_SF_Account__c, Company__c
                FROM Sanergy_Department__c
                WHERE Department_Status__c = TRUE AND Team_Lead__c =: EmpID
                ORDER BY Name
            ];
        for(Sanergy_Department__c d : deptList){
            TLDeptsWrp.add(new DepartmentWrapper(d));
        }
        return TLDeptsWrp;
    }    
    
    //Get Department Units
    public List<DepartmentUnitWrapper> getTLDeptUnits(Id EmpID){ 
        deptUnitList = 
            [
                SELECT Id, Name, Line_Manager__c, Line_Manager_SF_Account__c, Team_Lead__c, Team_Lead_SF_Account__c,
                Sanergy_Department__c, Sanergy_Department__r.Name, Department_Unit_Code__c, Active__c
                FROM Sanergy_Department_Unit__c
                WHERE Line_Manager__c =: EmpID AND Active__c = TRUE //DU TL will be updated by the Dept Trigger so no need to update TL here
                ORDER BY Sanergy_Department__r.Name, Name
            ];
        
        //add to wrapper
        for(Sanergy_Department_Unit__c item : deptUnitList){
            TLDeptUnitsWrp.add(new DepartmentUnitWrapper(item));
        }
        return TLDeptUnitsWrp;
    }
    
    //Get FFA_Config_Object__c
    public List<FFAConfigWrapper> getTLFFAConfigs(Id EmpID){ 
        ffaConfigList = 
            [
                SELECT Id, Name, Team_Lead_Employee_Account__c, Type__c, isActive__c
                FROM FFA_Config_Object__c
                WHERE Team_Lead_Employee_Account__c =: EmpID AND Type__c = 'dim1' AND isActive__c = TRUE
                ORDER BY Name
            ];
        
        //add to wrapper
        for(FFA_Config_Object__c item : ffaConfigList){
            FFAConfigsWrp.add(new FFAConfigWrapper(item));
        }
        return FFAConfigsWrp;
    }
    
    public Employee__c fetchEmployeeInfo(String UserID){
        //soql to fetch the employeeObjectId From the UserObjectId
        Employee__c empDetails = 
            [SELECT ID,Name,Sanergy_Department_Unit__c,Leave_Accrual_Start_Date__c,Sanergy_Department_Unit__r.Approver__c,
             Line_Manager_SF_Account__c, Employee_SF_Account__c,Employee_First_Name__c, Work_Email__c
             FROM Employee__c 
             WHERE id =: UserID
             LIMIT 1
            ];
        
        System.debug('empDetails: = ' + empDetails);
        
        return empDetails;
    }
    
    
    public PageReference updateDelegatedApprovals (){
        //Confirm entered emp ID is Valid and active and has SF Account
        system.debug('empToDelegate = ' + empToDelegate);
        if (empToDelegate != NULL && String.isEmpty(empToDelegate.value) == FALSE) {
            try {
                empDelegateFound = 
                    [
                        SELECT id, Name, Employee_First_Name__c, Employee_SF_Account__c, Work_Email__c 
                        FROM Employee__c WHERE id =: empToDelegate.value AND Employee_SF_Account__c != NULL AND Employee_Active__c = TRUE LIMIT 1
                    ];
                
                if(empDelegateFound != NULL){
                    //UPDATE Depts
                    
                    if(TLDeptsWrp != NULL && TLDeptsWrp.size()>0){
                        deptList = new List<Sanergy_Department__c>();  
                        for(DepartmentWrapper item : TLDeptsWrp){
                            //update the TL for selected row
                            if(item.selected == TRUE){
                                item.dept.Team_Lead__c = empDelegateFound.id;  
                                item.DelegatedFrom = employee.Name; 
                                item.DelegatedTo = empDelegateFound.Name;
                                deptList.add(item.dept);
                            }
                        }
                    }
                    if(deptList.size() > 0) {
                        UPDATE deptList; 
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Department Records Successfully Updated'));
                    }
                    
                    //UPDATE Dept Units
                    if(TLDeptUnitsWrp != NULL && TLDeptUnitsWrp.size()>0){
                        deptUnitList = new List<Sanergy_Department_Unit__c>();
                        for(DepartmentUnitWrapper item : TLDeptUnitsWrp){
                            //update the TL
                            if(item.selected == TRUE){
                                item.deptUnit.Line_Manager__c = empDelegateFound.id; 
                                item.DelegatedFrom = employee.Name; 
                                item.DelegatedTo = empDelegateFound.Name;
                                deptUnitList.add(item.deptUnit);
                            }
                        }
                    }
                    if(deptUnitList.size() > 0) {
                        UPDATE deptUnitList; 
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Department Unit Records Successfully Updated'));
                    }
                    
                    //UPDATE FFA Configs
                    if(FFAConfigsWrp != NULL && FFAConfigsWrp.size()>0){
                        ffaConfigList = new List<FFA_Config_Object__c> ();
                        for(FFAConfigWrapper item : FFAConfigsWrp){
                            //update the TL
                            if(item.selected == TRUE){
                                item.ffaConfig.Team_Lead_Employee_Account__c = empDelegateFound.id; 
                                item.DelegatedFrom = employee.Name; 
                                item.DelegatedTo = empDelegateFound.Name;
                                ffaConfigList.add(item.ffaConfig);
                            }
                        }
                    }
                    if(ffaConfigList.size() > 0) {
                        UPDATE ffaConfigList; 
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'DIM 1 Records Successfully Updated'));
                    }
                    
                    //Show updated rows
                    ShowUpdatedRows ();
                    //Send email
                    SendNotificationEmail();
                }
                else {
                    
                }
            }
            catch(Exception e){
                //No rows found
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            }
            
        }else {
            //No rows found
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No rows were updated; Select an Employee to Delegate Approvals to'));
        }
        return null;
    }
    
    // Departments wrapper class
    public class DepartmentWrapper{        
        public Sanergy_Department__c dept {get; set;}
        public String DelegatedFrom {get; set;}
        public String DelegatedTo {get; set;}
        public Boolean selected {get; set;}
        public String ceRowStyle {get; set;}
        public Boolean rowDisabled {get; set;}
        //Constructor
        public DepartmentWrapper(Sanergy_Department__c d) {
            dept = d;
            //selected = false;
        }
        
        public String ShowUpdatedRows(){
            if(selected == TRUE){
                selected = false;
                ceRowStyle = 'background:#e5f5cb;font-weight: bold;'; //Highlight selected row
                rowDisabled = TRUE;
                return dept.Name;
            } else
            {
                //default color/style
                ceRowStyle = 'background:#ffffff;font-weight: normal;'; //Highlight selected row
                rowDisabled = FALSE;
                return '--';
            }
        }
    }    
    
    // Department Units wrapper class
    public class DepartmentUnitWrapper{        
        public Sanergy_Department_Unit__c deptUnit {get; set;}
        public String DelegatedFrom {get; set;}
        public String DelegatedTo {get; set;}
        public Boolean selected {get; set;}
        public String ceRowStyle {get; set;}
        public Boolean rowDisabled {get; set;}
        //Constructor
        public DepartmentUnitWrapper(Sanergy_Department_Unit__c du) {
            deptUnit = du;
            //selected = false;
        }
        
        public String ShowUpdatedRows(){
            if(selected == TRUE){
                selected = false;
                ceRowStyle = 'background:#e5f5cb;font-weight: bold;'; //Highlight selected row
                rowDisabled = TRUE;
                return deptUnit.name;
            } else
            {
                //default color/style
                ceRowStyle = 'background:#ffffff;font-weight: normal;'; //Highlight selected row
                rowDisabled = FALSE;
                return '--';
            }
        }
    }
    
    // FFA Configs wrapper class
    public class FFAConfigWrapper{        
        public FFA_Config_Object__c ffaConfig {get; set;}
        public String DelegatedFrom {get; set;}
        public String DelegatedTo {get; set;}
        public Boolean selected {get; set;}
        public String ceRowStyle {get; set;}
        public Boolean rowDisabled {get; set;}
        
        //Constructor
        public FFAConfigWrapper(FFA_Config_Object__c ff) {
            ffaConfig = ff;
            //selected = false;
        }
        
        public String ShowUpdatedRows(){
            if(selected == TRUE){
                selected = false;
                ceRowStyle = 'background:#e5f5cb;font-weight: bold;'; //Highlight selected row
                rowDisabled = TRUE;
                return ffaConfig.Name;
            } else
            {
                //default color/style
                ceRowStyle = 'background:#ffffff;font-weight: normal;'; //Highlight selected row
                rowDisabled = FALSE;
                return '--';
            }
        }
    }
    
    public void ShowUpdatedRows (){
        //update rows to show status as well as return message for email
        NotificationMsg = '';
        Integer rowCount = 0;
        
        NotificationMsg = '<b>Department(s):</b> <br/>';
        for(DepartmentWrapper item : TLDeptsWrp){
            rowCount = rowCount + 1;
                NotificationMsg = NotificationMsg + ' <br/> '   + rowCount + ') ' + item.ShowUpdatedRows();  
        }
        NotificationMsg = NotificationMsg + '<p><b>Department Unit(s):</b> </p>';
        for(DepartmentUnitWrapper item : TLDeptUnitsWrp){
            rowCount = rowCount + 1;
            //if(String.isBlank(item.ShowUpdatedRows()) == FALSE ){
                NotificationMsg = NotificationMsg + ' <br/> '   + rowCount + ') ' + item.ShowUpdatedRows();  
            //} 
            //String msg =  (item.ShowUpdatedRows() != null) ? String.valueOf(item.ShowUpdatedRows()) : '' ;
        }
        NotificationMsg = NotificationMsg + '<p><b>DIM 1(s):</b> </p>';
        for(FFAConfigWrapper item : FFAConfigsWrp){
            rowCount = rowCount + 1;
            //if(String.isBlank(item.ShowUpdatedRows()) == FALSE ){
                NotificationMsg = NotificationMsg + ' <br/> '   + rowCount + ') ' + item.ShowUpdatedRows();  
            //} 
        }
        
        system.debug('NotificationMsg =  '  + NotificationMsg);
    }
    
    public void SendNotificationEmail(){
        // List of emails to send
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Send email to recipient
        List<String> sendTo = new List<String>();
        sendTo.add(employee.Work_Email__c);
        sendTo.add(empDelegateFound.Work_Email__c);
        
        mail.setToAddresses(sendTo);
        
        // Set the email sender
        mail.setReplyTo(employee.Work_Email__c);
        mail.setSenderDisplayName('SANERGY - ' + employee.Name); 
        
        //flag to false to stop inserting activity history
        mail.setSaveAsActivity(false);             
        
        // Create the email body
        mail.setSubject('Delegated my Approvals to you');
        String body = '<p>Dear ' + empDelegateFound.Employee_First_Name__c + ',</p>'; 
        body += '<p>I have delegated you as approver for the below items: </p>';
        body += '<p>' + NotificationMsg + '</p>';
        /*
        https://calendar.google.com/calendar/r/eventedit?text=OOO - Approval Delegation&details=OOO&location=OOO&dates=20191228/20200108
        body += '<p><a href = "https://calendar.google.com/calendar/r/eventedit?text=OOO - {!relatedTo.Leave_Type__c}&details=OOO&location=OOO&dates={!relatedTo.StartEndDate__c}">
        body += '<img src="https://test.salesforce.com/servlet/servlet.ImageServer?id=0157E000000iBoC&oid=00D7E0000004aWp&lastMod=127057656800"></img>
        body += '</a>'*/
        mail.setHtmlBody(body);
        
        //Add email to the list
        mails.add(mail);            
        // Send email
        Messaging.sendEmail(mails);
    }
    
}