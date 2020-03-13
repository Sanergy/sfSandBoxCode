public class CreateLeaveRequestFromEmployee {
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    //Employee
    public Employee__c employee {get; set;} 
    
    //create disabled
    public Boolean  ishide {get; set;}
    
    //Employee Leave Request
    public Employee_Leave_Request__c leaveRequest {get; set;}
    public List<LeaveRequest> leaveRequestList {get; set;}
    
    //Leave Entitlement Utilization
    public List<LeaveUtilization> leaveUtilizationList {get; set;}
    
    //Sanergy Calendar
    public List<SanergyCalendar> sanergyCalendarList {get; set;}  
    public List<Sanergy_Calendar__c> sanergyCalendarLineItems {get; set;} 
    
    public SanergyCalendar sanergyCalendar {get; set;}
    //public String daysRequested{get;set;}
    
    //
    public List<Employee__c> empinfo {get;set;}
    public String dptUnitApprover;
    
    //Get the Date when the LeavePeriod for the current year ends
    Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();        
    String leavePeriodEndDate = settings.get('Leave Period End Date').Value__c;
    public Date convertStringToDate = Date.valueOf(leavePeriodEndDate);
    public Date thisMonthStartDate = Date.newInstance(System.today().year(),System.today().month(),01);
    public Date startDate;
    public Date endDate;
    public date PeriodEnd;
    PUBLIC Date stDate;
    public String formatStartDate;
    public String formatEndDate;
    public Decimal daysAccruedInMonth=0.0;
    public String leaveDaysAccruedText='';
    public List<SelectOption> objectOptions {get;set;}
    public String selectedObject {get; set;}
    Public Boolean hasValidEmployeeID;
    
    //Number Of Days Requested
    Integer countHolidays=0;
    Integer countWeekends=0;
    Public Integer NoOfDayss = 0;
    
    //get the number of days requested from the days requested dropdown 
    //public String daysRequested{get;set;}
    
    // Constructor
    public CreateLeaveRequestFromEmployee(ApexPages.StandardController controller){               
        this.controller = controller;
        
        ishide = false;
        leaveRequest = new Employee_Leave_Request__c();
        objectOptions = new List<SelectOption>();
        employee = (Employee__c)controller.getRecord();       
        System.debug('EMPLOYEE: ' + employee);
        //override the employee to get the details from the method fetchEmployeeInfo
        empinfo = fetchEmployeeInfo();
        
        //set default
        hasValidEmployeeID = false;
        if(empinfo != NULL && empinfo.size() == 1){
            //SF Record Exists
            hasValidEmployeeID = TRUE;
            employee.Id = empinfo.get(0).ID;
            employee.Name = empinfo.get(0).Name;
            employee.Leave_Accrual_Start_Date__c = empinfo.get(0).Leave_Accrual_Start_Date__c;
            employee.Sanergy_Department_Unit__c = empinfo.get(0).Sanergy_Department_Unit__c;
            dptUnitApprover = empinfo.get(0).Sanergy_Department_Unit__r.Approver__c;
            
            List<Leave_Entitlement_Utilization__c> utilizations = [SELECT Id, Name,Leave_Type__c,Leave_Entitlement_Type_Config__c,
                                                                   Leave_Entitlement_Type_Config__r.Display_to_User__c,
                                                                   Leave_Entitlement_Type_Config__r.Year_End_Date__c,
                                                                   Leave_Entitlement_Type_Config__r.Leave_Name__c,
                                                                   Leave_Type_Name__c,
                                                                   Leave_Entitlement_Type_Config__r.Year__c
                                                                   FROM Leave_Entitlement_Utilization__c
                                                                   WHERE Employee__c =: employee.Id
                                                                   AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                                                                   ORDER BY Leave_Entitlement_Type_Config__r.Year__c DESC,Leave_Entitlement_Type_Config__r.Leave_Name__c
                                                                   
                                                                   
                                                                  ];
            
            System.debug('LEAVE UTILIZATION: ' + utilizations);
            
            if(utilizations != null && utilizations.size() > 0){
                objectOptions.add(new SelectOption('','--SELECT OPTION--'));
                for(Leave_Entitlement_Utilization__c utilization: utilizations){
                    objectOptions.add(new SelectOption(utilization.Id, utilization.Leave_Type__c == null ? 'NULL' : utilization.Leave_Type_Name__c));
                }            
            }

        }            
        else{
            //User has no associated SF Account
            hasValidEmployeeID = false;
            objectOptions.add(new SelectOption('','--SELECT OPTION--'));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Employee Details not Found. Please contact HR Admin'));
        }
        
    }
    
    //method to set the employeeId from The employeeUserId
    public List<Employee__c> fetchEmployeeInfo(){
        
        List<Employee__c> empDetails;
        String empid = '';
        //soql to fetch the employeeObjectId From the UserObjectId
        empDetails = [SELECT ID,Name,Sanergy_Department_Unit__c,Leave_Accrual_Start_Date__c,
                      Sanergy_Department_Unit__r.Approver__c, Line_Manager_SF_Account__c,
                      Employee_SF_Account__c
                      FROM Employee__c 
                      WHERE
                      Employee_SF_Account__c =: UserInfo.getUserId()
                      LIMIT 1
                     ];
        
        System.debug('empDetails: = ' + empDetails);
        
        return empDetails;
    }
    
    // Get Leave Entitlement Utilizations
    public List<LeaveUtilization> getLeaveUtilizations() {        
        
        if(leaveUtilizationList == null){
            
            leaveUtilizationList = new List<LeaveUtilization>();
            
            List<Leave_Entitlement_Utilization__c> utilizationLineItems = [SELECT Name,Leave_Entitlement_Type_Config__c,
                                                                           Leave_Entitlement_Type_Config__r.Name,Employee__c,
                                                                           Leave_Entitlement_Type_Config__r.Leave_Group__r.Name,
                                                                           Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c,
                                                                           Employee__r.Name,Leave_Type__c,Total_No_of_Leave_Days__c,
                                                                           Leave_Days_Accrued__c,Leave_Days_Used__c,
                                                                           Leave_Entitlement_Type_Config__r.Leave_Name__c,
                                                                           Leave_Type_Name__c,
                                                                           Leave_Days_Remaining__c,Employee__r.Leave_Accrual_Start_Date__c , 
                                                                           Leave_Entitlement_Type_Config__r.Display_to_User__c 
                                                                           FROM Leave_Entitlement_Utilization__c 
                                                                           WHERE Employee__c =: employee.Id
                                                                           AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                                                                           ORDER BY Leave_Type__c ASC];
            
            
            for(Leave_Entitlement_Utilization__c utilizationLineItem : utilizationLineItems){                
                //Add all records to the list
                leaveUtilizationList.add(new LeaveUtilization(utilizationLineItem));
            }
            System.debug('LEAVE UTILIZATION: ' + leaveUtilizationList);
        }
        return leaveUtilizationList;
    }
    
    //Create Leave Request
    public PageReference createLeaveRequest(){
        if (hasValidEmployeeID == false){
            //No valid employee ID found for the given User ID
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Employee Details not Found. Please contact HR Admin'));
        }
        else {
            if(selectedObject != null && leaveRequest.Leave_Start_Date__c != null && leaveRequest.Leave_End_Date__c != null && leaveRequest.Leave_Start_Date__c <= leaveRequest.Leave_End_Date__c ){  
                System.debug('selectedObject' + selectedObject);
                Leave_Entitlement_Utilization__c utilizationDate = [SELECT Id, Name,Leave_Type__c,Leave_Entitlement_Type_Config__c,
                                                                    Leave_Entitlement_Type_Config__r.Display_to_User__c,
                                                                    Leave_Entitlement_Type_Config__r.Year_End_Date__c
                                                                    FROM Leave_Entitlement_Utilization__c
                                                                    WHERE Employee__c =: employee.Id
                                                                    AND Id =: selectedObject
                                                                    AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                                                                   ];
                
                System.debug('utilizationDate' + utilizationDate);
                
                // Create an Instance of Employee Leave Request
                Employee_Leave_Request__c employeeLeaveRequest = new Employee_Leave_Request__c();       
                ishide = false;
                
                Decimal totalDaysRequested = 0;
                endDate = leaveRequest.Leave_End_Date__c;
                
                //list of days requested 
                if(sanergyCalendarList != NULL && sanergyCalendarList.size() > 0){
                    for(SanergyCalendar sc : sanergyCalendarList){                
                        totalDaysRequested += sc.sanergyCalendar.is_Weekend_or_Holiday__c;                
                    }   
                }
                
                
                employeeLeaveRequest.Leave_Entitlement_Utilization__c = selectedObject;
                employeeLeaveRequest.Employee__c = employee.Id;
                employeeLeaveRequest.Leave_Start_Date__c = leaveRequest.Leave_Start_Date__c;
                
                //Check if the leave endDate falls outside the current year
                if(endDate.year() > System.today().year()){
                    System.debug('leavePeriodEndDate1: ' + leavePeriodEndDate);
                    
                    //Check if Leave_End_Date__c provided by user >= leavePeriodEndDate specified in sanergy settings
                    if(leaveRequest.Leave_End_Date__c >= utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c){
                        employeeLeaveRequest.Leave_End_Date__c = utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c;
                    }else{
                        employeeLeaveRequest.Leave_End_Date__c = leaveRequest.Leave_End_Date__c;
                    }//End if(leaveRequest.Leave_End_Date__c >= convertStringToDate)
                    
                }else{
                    employeeLeaveRequest.Leave_End_Date__c = leaveRequest.Leave_End_Date__c; 
                }// End if(endDate.year() > System.today().year())
                
                //employeeLeaveRequest.Leave_End_Date__c = leaveRequest.Leave_End_Date__c;                   
                employeeLeaveRequest.Employee_s_Department__c = employee.Sanergy_Department_Unit__c;
                employeeLeaveRequest.Department_Team_Lead__c = dptUnitApprover;  
                employeeLeaveRequest.Line_Manager_Account__c = empinfo.get(0).Line_Manager_SF_Account__c;
                employeeLeaveRequest.No_Of_Leave_Days_Requested__c = totalDaysRequested;
                employeeLeaveRequest.No_Of_Approved_Leave_Days__c = totalDaysRequested ;
                employeeLeaveRequest.Comments__c = leaveRequest.Comments__c;
                employeeLeaveRequest.Request_From_VFP__c = true; 
                employeeLeaveRequest.Coverage_Plans__c = leaveRequest.Coverage_Plans__c;
                INSERT employeeLeaveRequest;
                
                // Create an approval request for the account
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(employeeLeaveRequest.Id);
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);  
                
                return new PageReference('/'+ employeeLeaveRequest.Id);
                
            }else if(selectedObject =='' || selectedObject == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the leave type'));
            }else if(leaveRequest.Leave_Start_Date__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the start date'));
            }else if(leaveRequest.Leave_End_Date__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the end date'));
            } else if (leaveRequest.Leave_Start_Date__c > leaveRequest.Leave_End_Date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Leave Start Date cannot be greater than the Leave End Date'));
            }
        }
        return null;
    }
    
    // Get Sanergy Calendar
    public List<SanergyCalendar> getSanergyCalendars() {
        system.debug('employee.Id: = '+ employee.Id); 
        system.debug('selectedObject'+ selectedObject); 
        if(selectedObject != null ){
            Leave_Entitlement_Utilization__c utilizationDate = [SELECT Id, Name,Leave_Type__c,Leave_Entitlement_Type_Config__c,
                                                                Leave_Entitlement_Type_Config__r.Display_to_User__c,
                                                                Leave_Entitlement_Type_Config__r.Year_End_Date__c,
                                                                Leave_Entitlement_Type_Config__r.Year__c
                                                                FROM Leave_Entitlement_Utilization__c
                                                                WHERE Employee__c =: employee.Id
                                                                AND Id =: selectedObject
                                                                AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                                                               ];   
            
            system.debug('utilizationDateList' + utilizationDate);
            if(leaveRequest.Leave_Start_Date__c != null && leaveRequest.Leave_End_Date__c != null){
                
                endDate = leaveRequest.Leave_End_Date__c;
                stDate = leaveRequest.Leave_Start_Date__c;
                if(stDate > utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c ){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Dates You Have Selected are NOT Valid For This Utilization. The Last Date for ' + utilizationDate.Leave_Entitlement_Type_Config__r.Year__c + ' Leave Year is ' + utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c.format()));
                    return null; 
                }
                else{
                    sanergyCalendarList = new List<SanergyCalendar>();
                    sanergyCalendarLineItems = new List<Sanergy_Calendar__c>();
                    
                    //Check if the leave endDate falls outside the current year
                    if(endDate.year() > System.today().year()){
                        System.debug('leavePeriodEndDate2: ' + leavePeriodEndDate);
                        
                        //Check if Leave_End_Date__c provided by user >= leavePeriodEndDate specified in sanergy settings
                        if(leaveRequest.Leave_End_Date__c >= utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c){
                            
                            sanergyCalendarLineItems = [SELECT Id,Name,Date__c,Description__c, Weekday_Name__c, is_Weekend_or_Holiday__c,
                                                        Weekday_No__c,IsHoliday__c,IsWeekend__c
                                                        FROM Sanergy_Calendar__c														
                                                        WHERE Date__c >=: leaveRequest.Leave_Start_Date__c
                                                        AND Date__c <=: utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c
                                                        ORDER BY Date__c ASC];
                            
                        }
                        else{
                            sanergyCalendarLineItems = [SELECT Id,Name,Date__c,Description__c, Weekday_Name__c, is_Weekend_or_Holiday__c,
                                                        Weekday_No__c,IsHoliday__c,IsWeekend__c
                                                        FROM Sanergy_Calendar__c														
                                                        WHERE Date__c >=: leaveRequest.Leave_Start_Date__c
                                                        AND Date__c <=: leaveRequest.Leave_End_Date__c
                                                        ORDER BY Date__c ASC];
                            
                        }///End if(leaveRequest.Leave_End_Date__c >= convertStringToDate)
                        
                    }else{
                        
                        sanergyCalendarLineItems = [SELECT Id,Name,Date__c,Description__c, Weekday_Name__c, is_Weekend_or_Holiday__c,
                                                    Weekday_No__c,IsHoliday__c,IsWeekend__c
                                                    FROM Sanergy_Calendar__c														
                                                    WHERE Date__c >=: leaveRequest.Leave_Start_Date__c
                                                    AND Date__c <=: leaveRequest.Leave_End_Date__c
                                                    ORDER BY Date__c ASC];
                        
                    }// End if(endDate.year() > System.today().year())   
                }
                
                
                for(Sanergy_Calendar__c sanergyCalendarLineItem : sanergyCalendarLineItems){
                    
                    sanergyCalendarList.add(new SanergyCalendar(sanergyCalendarLineItem));
                }
                
            }          
            
        }
        
        
        return sanergyCalendarList;
    } 
    
    
    public PageReference calculateLeave() {   
        ishide = true;
        
        if(leaveRequest.Leave_Start_Date__c != null && leaveRequest.Leave_End_Date__c != null && leaveRequest.Leave_Start_Date__c <= leaveRequest.Leave_End_Date__c){            
            
            Integer leaveDaysValid = -1;
            leaveDaysValid = checkLeaveDaysValid();
            
            
        }else if(leaveRequest.Leave_Start_Date__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the start date'));            
        }else if(leaveRequest.Leave_End_Date__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the end date'));            
        }else if (leaveRequest.Leave_Start_Date__c > leaveRequest.Leave_End_Date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Leave Start Date cannot be greater than the Leave End Date'));
        }       
        return null;
    }
    
    public Integer checkLeaveDaysValid(){
        
        List<Employee_Leave_Request__c> employeesOnLeave = [SELECT Id,Employee__c,Leave_Start_Date__c ,Leave_End_Date__c
                                                            FROM Employee_Leave_Request__c														
                                                            WHERE ((Leave_Start_Date__c >=: leaveRequest.Leave_Start_Date__c AND Leave_Start_Date__c <=: leaveRequest.Leave_End_Date__c) 
                                                                   OR (Leave_End_Date__c >=: leaveRequest.Leave_Start_Date__c AND Leave_End_Date__c <=: leaveRequest.Leave_End_Date__c)) 
                                                            AND (Approval_Status__c = 'Approved by HR')
                                                            AND Employee__c =: employee.Id
                                                           ];
        
        if(employeesOnLeave.size() > 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'An Approved Leave Request Already Exists for the Requested period'));
            return 0;
        }
        
        return 1;
    }
    
    public void setLeaveDaysAccruedText(String leaveDaysAccruedText){
        this.leaveDaysAccruedText = leaveDaysAccruedText;
    }
    
    //Get the Number of Leave Days Requested
    public Integer getNumberOfRequestDays(){
        
        Date leaveStartDate = Date.valueOf(leaveRequest.Leave_Start_Date__c);
        Date leaveEndDate = Date.valueOf(leaveRequest.Leave_End_Date__c + 1);
        NoOfDayss= leaveStartDate.daysBetween(leaveEndDate);
        
        //Get the no. of holidays between the leave request            
        List<Sanergy_Calendar__c> sanergyCalendar = [SELECT Id,Name,Date__c,Description__c, Weekday_Name__c,Weekday_No__c,
                                                     IsHoliday__c,IsWeekend__c
                                                     FROM Sanergy_Calendar__c                                                       
                                                     WHERE Date__c >=: leaveRequest.Leave_Start_Date__c
                                                     AND Date__c <=: leaveRequest.Leave_End_Date__c
                                                     AND (IsHoliday__c=true OR IsWeekend__c=true)];
        
        for (Integer i = 0; i < sanergyCalendar.size(); i++) {
            
            if(sanergyCalendar.get(i).Weekday_Name__c == 'Saturday' || sanergyCalendar.get(i).Weekday_Name__c == 'Sunday'){
                countWeekends+=1; 
            }else if(sanergyCalendar.get(i).IsHoliday__c==true && sanergyCalendar.get(i).IsWeekend__c==false){
                countHolidays+=1;
                
            }                               
            
            System.debug('DAY: ' + sanergyCalendar.get(i).Weekday_Name__c);
            System.debug('NO. OF WEEKENDS: ' + countWeekends);
            System.debug('NO. OF HOLIDAYS: ' + countHolidays);
        }
        // Get no. of leave days after deduction
        NoOfDayss = NoOfDayss - countWeekends - countHolidays;
        
        return NoOfDayss;
    }
    
    
    
    public String getLeaveDaysAccruedText(){ 
        
        //SOQL
        List<Leave_Entitlement_Utilization__c> utilizationSingleRow = [SELECT Name,Leave_Entitlement_Type_Config__c,
                                                                       Leave_Entitlement_Type_Config__r.Name,Employee__c,
                                                                       Leave_Entitlement_Type_Config__r.Leave_Group__r.Name,
                                                                       Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c,
                                                                       Leave_Entitlement_Type_Config__r.Proratable__c,                                                                 
                                                                       Employee__r.Name,Leave_Type__c,Total_No_of_Leave_Days__c,
                                                                       Leave_Days_Accrued__c,Leave_Days_Used__c,
                                                                       Leave_Days_Remaining__c,Employee__r.Leave_Accrual_Start_Date__c  
                                                                       FROM Leave_Entitlement_Utilization__c 
                                                                       WHERE Employee__c =: employee.Id
                                                                      AND Id =: selectedObject
                                                                      ];
        
        System.debug('HELLO WORLD' + employee.Id + ' >>' + selectedObject); 
        System.debug('Leave_Entitlement_Utilization__c: ' + utilizationSingleRow + ' >>' + selectedObject);
        
        //Check if Prorated
        if(utilizationSingleRow != null && utilizationSingleRow.size()> 0){
            if(utilizationSingleRow.get(0).Leave_Entitlement_Type_Config__r.Proratable__c == false){
                this.leaveDaysAccruedText = 'You have a total of ' + utilizationSingleRow.get(0).Total_No_of_Leave_Days__c + ' days for this period';  
            }else{
                //Get the start date
                startDate = employee.Leave_Accrual_Start_Date__c;
                System.debug('Start Date : '+startDate);
                
                if(startDate != null && startDate.year() < System.today().year()){
                    startDate = Date.newInstance(System.today().year(),01,01);
                }
                
                //Get the leave end date
                endDate = leaveRequest.Leave_End_Date__c;
                System.debug('End Date : '+ endDate);    
                
                //Check if the endDate falls outside the current year
                if(endDate != null && endDate.year() > System.today().year()){
                    //endDate = Date.newInstance(System.today().year(),12,31); //get from sanergy settings end date for leave year
                    System.debug('leavePeriodEndDate3: ' + leavePeriodEndDate);
                    
                    if(selectedObject != null ){
                        Leave_Entitlement_Utilization__c utilizationDate = [SELECT Id, Name,Leave_Type__c,Leave_Entitlement_Type_Config__c,
                                                                            Leave_Entitlement_Type_Config__r.Display_to_User__c,
                                                                            Leave_Entitlement_Type_Config__r.Year_End_Date__c
                                                                            FROM Leave_Entitlement_Utilization__c
                                                                            WHERE Employee__c =: employee.Id
                                                                            AND Id =: selectedObject
                                                                            AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                                                                           ];                    
                        
                        
                        endDate = utilizationDate.Leave_Entitlement_Type_Config__r.Year_End_Date__c;
                    }
                }
                //Get no. of months between start date and leave end date
                Double fullMonths = 0.0;
                if(startDate != null && endDate != null){
                    //Always assume current month has not been accrued yet
                    fullMonths = SanergyUtils.monthsBetween(thisMonthStartDate-1,endDate);
                }
                
                //Format start date & end date                               
                formatStartDate = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day()).format('dd-MM-yyyy');
                formatEndDate = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day()).format('dd-MM-yyyy');
                
                System.debug('fullMonths: ' + fullMonths);
                System.debug('Days_Accrued_Per_Month__c: ' + utilizationSingleRow.get(0).Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c);
                
                //Calculate leave days accrued
                daysAccruedInMonth = fullMonths * utilizationSingleRow.get(0).Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c;
                
                System.debug('fullMonths * utilizationSingleRow.get(0).Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c: ' + daysAccruedInMonth);
                
                //add current accrued days
                daysAccruedInMonth = daysAccruedInMonth + utilizationSingleRow.get(0).Leave_Days_Accrued__c;
                
                System.debug('daysAccruedInMonth + utilizationSingleRow.get(0).Leave_Days_Accrued__c: ' + daysAccruedInMonth);
                
                daysAccruedInMonth = daysAccruedInMonth.setScale(2, RoundingMode.HALF_UP);
                this.leaveDaysAccruedText = 'Leave days accrued from ' + formatStartDate + ' to ' + formatEndDate + ' will be ' + daysAccruedInMonth;                 
            }
        }        
        System.debug('Leave Days accrued Text : ' + this.leaveDaysAccruedText);
        return this.leaveDaysAccruedText;
    }
    
    // Get Employee Leave Requests
    public List<LeaveRequest> getLeaveRequests() {        
        
        if(leaveRequestList == null){
            
            leaveRequestList = new List<LeaveRequest>();
            
            List<Employee_Leave_Request__c> leaveRequestLineItems = [SELECT Id,Name,Leave_Entitlement_Utilization__c,
                                                                     Employee__c,Leave_Start_Date__c,Leave_End_Date__c,
                                                                     Department_Team_Lead__c,Approval_Status__c,
                                                                     Leave_Approved__c,Leave_Type__c,
                                                                     No_Of_Leave_Days_Requested__c,No_Of_Approved_Leave_Days__c,
                                                                     Employee__r.Leave_Accrual_Start_Date__c,Coverage_Plans__c 
                                                                     FROM Employee_Leave_Request__c														
                                                                     WHERE Employee__c =: employee.Id
                                                                     AND Leave_Start_Date__c = LAST_YEAR 
                                                                     ORDER BY Leave_Start_Date__c DESC];
            
            for(Employee_Leave_Request__c leaveRequestLineItem : leaveRequestLineItems){                              
                leaveRequestList.add(new LeaveRequest(leaveRequestLineItem));
            }
            System.debug('LEAVE REQUEST: ' + leaveRequestList);
        }
        return leaveRequestList;
    }    
    
    
    // Leave Utilization wrapper class
    public class LeaveUtilization{        
        public Leave_Entitlement_Utilization__c leaveUtilization {get; set;}     
        
        //Constructor
        public LeaveUtilization(Leave_Entitlement_Utilization__c leu) {
            leaveUtilization = leu;			  
        }        
    }
    
    // Leave Request wrapper class
    public class LeaveRequest{        
        public Employee_Leave_Request__c employeeLeaveRequest {get; set;}		
        
        //Constructor
        public LeaveRequest(Employee_Leave_Request__c request) {
            employeeLeaveRequest = request;			
        }        
    }    
    
    //Sanergy Calendar wrapper class
    public class SanergyCalendar{        
        public Sanergy_Calendar__c sanergyCalendar {get; set;}	
        public String daysRequested{get;set;}
        
        public List<SelectOption> options {get; set;}
        
        //Constructor
        public SanergyCalendar(Sanergy_Calendar__c sanergyCal) {
            
            sanergyCalendar = sanergyCal;
            
            options=new List<SelectOption>();
            options.add(new SelectOption('1','1'));
            options.add(new SelectOption('0.5','0.5'));
            options.add(new SelectOption('0','0')); 
            
        }        
    }
    
}