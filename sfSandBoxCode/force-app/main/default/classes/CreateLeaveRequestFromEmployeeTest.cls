@isTest(seeAllData = true)
public class CreateLeaveRequestFromEmployeeTest {
    
    static testMethod void testCreateLeaveRequestFromEmployee(){
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev']; //run test as Dev
        //List<User> u = [Select Id,Alias FROM User WHERE Id = '005D0000003Ykhb']; //run test as Dev
        System.runAs(u.get(0)) {
            // Get dim1                              
            List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                     FROM FFA_Config_Object__c 
                                                     WHERE Type__c = 'dim1' 
                                                     AND Name = 'Information Technology'
                                                     AND isActive__c = true LIMIT 1];
            
            // Create Employee Manager
            //Employee__c employeeManager = new Employee__c();       
            
            // Create Employee
            /* Employee__c employee =[SELECT ID,Name,Sanergy_Department_Unit__c 
FROM Employee__c 
WHERE ID = '005D0000008kHZI'];*/
            
            
            //Create Leave Group
            Leave_Group__c leaveGroup = new Leave_Group__c();  
            
            // Create Sanergy Department - RecordType - Sanergy
            Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
            
            // Create Sanergy Department Unit        
            Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
            
            // Create Employee Role
            Employee_Role__c empRole = new Employee_Role__c();
            
            // Create Employee
            //Employee__c employee = new Employee__c();  
            
            //Create Department
            sanergyDept.Name = 'It department';
            sanergyDept.Company__c = 'Sanergy';
            sanergyDept.Department_Code__c = 'CORE';
            sanergyDept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
            sanergyDept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
            INSERT sanergyDept;
            
            //create department unit
            sanergyDeptUnit.Name = 'Information Technology System';
            sanergyDeptUnit.Unit_Code__c = 'CORE';
            sanergyDeptUnit.Sanergy_Department__c = sanergyDept.Id;
            sanergyDeptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
            sanergyDeptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
            sanergyDeptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
            sanergyDeptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
            sanergyDeptUnit.Talent_Partner__c = '005D0000003Ykhb';
            sanergyDeptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
            INSERT sanergyDeptUnit;
            
            //Insert Employee Role 
            empRole.Name = 'Business Analyst';
            empRole.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
            empRole.Company_Division__c = 'Sanergy';
            empRole.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
            empRole.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
            empRole.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
            empRole.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
            empRole.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
            empRole.Talent_Partner__c = 'aAsD0000000GmgM';
            INSERT empRole;
            system.debug('Employee Role' + empRole);
            
            //
            Recruitment_Requisition__c requisition = new Recruitment_Requisition__c();
            requisition.Name = 'Business Analyst';
            requisition.Requestor__c = 'aAsD000000001S7';
            requisition.Talent_Partner__c = '005D0000003Ykhb';
            requisition.Employee_Role__c = empRole.Id;
            requisition.Request_Date__c = date.today()+30;
            requisition.Number_of_Required_Staff__c = 5;
            requisition.Job_Description__c = 'ANALYSIS';
            requisition.Justification_for_new_position__c = 'Test';
            requisition.Type_of_employment__c = 'Permanent';
            requisition.Duration_of_Fixed_term_Contract_Months__c = 1;
            requisition.Is_recruitment_budgeted__c = 'yes';
            requisition.Candidate_Specification__c = 'Kenyan';
            requisition.Proposed_Employee_required_Date__c = date.today()+40;
            requisition.Location__c = 'Mukuru';
            requisition.Requesting_Department__c = department.get(0).Id;
            INSERT requisition;
            
            
            /*
//CREATE EMPLOYEE
employee.Name = 'Jason';
employee.Employee_First_Name__c = 'Jason';
employee.Employee_Last_Name__c = 'Statham';
employee.Recruitment_Requisition__c = requisition.Id;
employee.Primary_Phone__c = '0712345678';
employee.Employment_Start_Date__c = date.today()+50;
employee.Employee_Active__c = true;
employee.Gender__c = 'Male';
employee.Employment_Status__c = 'Permanent';
employee.Employee_Role__c = empRole.Id;
employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
employee.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
employee.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
employee.Talent_Partner__c = 'aAsD0000000GmgM';
employee.Employee_SF_Account__c = '005D0000004ZrkJ';
employee.Leave_Accrual_Start_Date__c = date.today()-50;
employee.Employment_Start_Date__c = date.today() - 100;
employee.Leave_Group__c = leaveGroup.Id;
employee.Tickets_Created__c = false;

INSERT employee;
*/ 
            
            Employee__c employee = [SELECT Id,Sanergy_Department_Unit__c FROM Employee__c
                                    WHERE Id = 'aAsD0000000Gn0wKAC'
                                    //WHERE Id = 'aAsD0000000GmgM'
                                   ];
            
            System.debug('employee ID 1 = ' + employee);
            /* Create Employee Manager       
employeeManager.Name = 'Kim Kardashian';
employeeManager.Employee_First_Name__c = 'Kim';
employeeManager.Employee_Last_Name__c = 'Kardashian';
employeeManager.Primary_Phone__c = '1234567';
employeeManager.Employment_Start_Date__c = date.today() - 200;
employeeManager.Employment_Status__c = 'Permanent';
employeeManager.Identification_Number__c = '920183';
employeeManager.Primary_Phone__c = '93489853489';  
employeeManager.Line_Manager__c = 'aAsD0000000Gmhr';
employeeManager.Line_Manager_SF_Account__c = '005D0000004ZrkJ';
employeeManager.Sanergy_Department__c = sanergyDept.Id;
employeeManager.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
employeeManager.Employee_Role__c = empRole.Id;
employeeManager.Recruitment_Requisition__c = requisition.Id;
employeeManager.Employee_SF_Account__c = '005D0000001qz2K';
employeeManager.Company_Division__c = empRole.Company_Division__c;
employeeManager.Tickets_Created__c = false; 
INSERT employeeManager;*/
            
            //  System.debug('EMPLOYEE MANAGER: ' + employeeManager);
            
            // Create Sanergy Calendar
            Sanergy_Calendar__c sanergyCalendar = new Sanergy_Calendar__c();        
            sanergyCalendar.Name = 'SC-2019-05-01';
            sanergyCalendar.Date__c = date.today();
            sanergyCalendar.Description__c = 'Labour Day';
            sanergyCalendar.IsHoliday__c = true;
            sanergyCalendar.IsWeekend__c = false;
            INSERT sanergyCalendar;
            
            // System.debug('SANERGY CALENDAR : ' + sanergyCalendar);            
            
            //Create Leave Group
            //Leave_Group__c leaveGroup = new Leave_Group__c();
            leaveGroup.Leave_Group__c = 'Permanent - Part time';
            leaveGroup.Leave_Group_Status__c = true;
            leaveGroup.Leave_Group__c = 'Just a comment';
            INSERT leaveGroup;
            
            //System.debug('LEAVE GROUP : ' + leaveGroup);
            
            //Create Leave_Entitlement_Type_Config__c
            Leave_Entitlement_Type_Config__c leaveType = new Leave_Entitlement_Type_Config__c();
            leaveType.Leave_Group__c = leaveGroup.Id;
            leaveType.Leave_Type__c = 'Annual Leave';
            leaveType.Year__c = date.today().year();
            leaveType.Total_No_of_Leave_Days__c = 21;
            leaveType.Proratable__c = true;
            leaveType.Display_to_User__c = true;
            leaveType.Year_End_Date__c = date.today() + 80;
            leaveType.Year_Start_Date__c =  date.today() - 20;
            INSERT leaveType;
            
            // System.debug('LEAVE TYPE ONE: ' + leaveType);
            
            //Create Leave Entitlement Utilization
            Leave_Entitlement_Utilization__c leaveUtilization = new Leave_Entitlement_Utilization__c();
            leaveUtilization.Leave_Entitlement_Type_Config__c = leaveType.Id;
            leaveUtilization.Employee__c = employee.Id;
            INSERT leaveUtilization;
            
            System.debug('LEAVE UTILIZATION 1: ' + leaveUtilization);            
            
            //Create Employee Leave Request 
            Employee_Leave_Request__c leaveRequest = new Employee_Leave_Request__c();
            leaveRequest.Leave_Entitlement_Utilization__c = leaveUtilization.Id;
            leaveRequest.Employee__c = employee.Id;
            leaveRequest.Leave_Start_Date__c = Date.newInstance(System.today().year(),12,28);
            leaveRequest.Leave_End_Date__c = Date.newInstance(System.today().year()+1,01,10);
            leaveRequest.Employee_s_Department__c = employee.Sanergy_Department_Unit__c;
            leaveRequest.Department_Team_Lead__c = department.get(0).Teamlead__c;  
            leaveRequest.Line_Manager_Account__c = '005D0000004ZrkJ';
            INSERT leaveRequest;        
            
            System.debug('LEAVE REQUEST : ' + leaveRequest);
            // System.debug('LEAVE REQUEST START DATE: ' + leaveRequest.Leave_Start_Date__c); 
            //  System.debug('LEAVE REQUEST END DATE: ' + leaveRequest.Leave_End_Date__c);         
            
            //Create an instance of LeaveRequest Wrapper Class      
            CreateLeaveRequestFromEmployee.LeaveRequest leaveRequestWrapperClass = new CreateLeaveRequestFromEmployee.LeaveRequest(leaveRequest);
            
            //Create an instance of LeaveUtilization Wrapper Class      
            CreateLeaveRequestFromEmployee.LeaveUtilization LeaveUtilizationWrapperClass = new CreateLeaveRequestFromEmployee.LeaveUtilization(leaveUtilization);
            
            //Create an instance of SanergyCalendar Wrapper Class      
            CreateLeaveRequestFromEmployee.SanergyCalendar sanergyCalendarWrapperClass = new CreateLeaveRequestFromEmployee.SanergyCalendar(sanergyCalendar);        
            
            string daysRequested = '2';
            
            ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(employee);
            CreateLeaveRequestFromEmployee createLeaveRequest = new CreateLeaveRequestFromEmployee(controller);        
            createLeaveRequest.fetchEmployeeInfo();
            createLeaveRequest.getLeaveUtilizations(); 
            
            /* Leave_Entitlement_Utilization__c utilization = [SELECT Id, Name,Leave_Type__c,Leave_Entitlement_Type_Config__c,
Leave_Entitlement_Type_Config__r.Display_to_User__c,
Leave_Entitlement_Type_Config__r.Year_End_Date__c
FROM Leave_Entitlement_Utilization__c
WHERE Employee__c = '005D0000008kHZI'
AND Id = 'aJ67E0000004CH5'
AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true];*/
            
            // createLeaveRequest.selectedObject = leaveUtilization.Id;
            //createLeaveRequest.selectedObject = 'aJ67E0000004CrH'; // sandbox;
            //createLeaveRequest.selectedObject = 'aIz4G000000blTb';//pauline - live
            System.debug('employee.Id = ' + employee.Id);
            //Make sure TempRS Employee has a Leave Utilisation in both Sandbox and Live
            Leave_Entitlement_Utilization__c utilization = 
                [
                    SELECT Id, Name,Leave_Type__c,Leave_Entitlement_Type_Config__c,
                    Leave_Entitlement_Type_Config__r.Display_to_User__c,
                    Leave_Entitlement_Type_Config__r.Year_End_Date__c
                    FROM Leave_Entitlement_Utilization__c
                    WHERE Employee__c = : employee.Id //DO NOT USE ICT/TEMPRS
                    AND Leave_Entitlement_Type_Config__r.Year__c =: date.today().year()
                    AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                    LIMIT 1
                ];
            System.debug('selectedObject = utilization.Id = ' + employee.Id);
            createLeaveRequest.selectedObject = utilization.Id;//temp rs
            
            //createLeaveRequest.selectedObject = 'aIz4G000000Gmkn';//temp rs - live
            
            //createLeaveRequest.selectedObject = 'aIz4G000000blkC';//DO NOT USE ICT
            // createLeaveRequest.selectedObject = 'aIzD0000000KzMj' temp rs;
            //  createLeaveRequest.selectedObject = utilization.id;
            
            createLeaveRequest.leaveRequest.Leave_Start_Date__c = Date.newInstance(System.today().year(),02,28);
            createLeaveRequest.leaveRequest.Leave_End_Date__c = Date.newInstance(System.today().year()+1,01,01);
            //createLeaveRequest.leaveRequest.Comments__c = 'Very Sick';
            createLeaveRequest.leaveRequest.Line_Manager_Account__c  = 'aAsD0000000GmgM';
            
            CreateLeaveRequestFromEmployee createLeaveRequest2 = new CreateLeaveRequestFromEmployee(controller);        
            createLeaveRequest2.leaveRequest.Leave_Start_Date__c = null;
            createLeaveRequest2.leaveRequest.Leave_End_Date__c = null;
            
            createLeaveRequest2.calculateLeave();
            
            //try incorrect dates
            createLeaveRequest2.leaveRequest.Leave_Start_Date__c = Date.newInstance(2019,02,27);
            createLeaveRequest2.leaveRequest.Leave_End_Date__c = Date.newInstance(2019,02,25);
            createLeaveRequest2.calculateLeave();             
            
            //try Missing dates
            createLeaveRequest2.leaveRequest.Leave_Start_Date__c = NULL;
            createLeaveRequest2.leaveRequest.Leave_End_Date__c = NULL;
            createLeaveRequest2.calculateLeave(); 
            
            //try missing LEU
            createLeaveRequest2.leaveRequest.Leave_Start_Date__c = Date.newInstance(2019,02,27);
            createLeaveRequest2.leaveRequest.Leave_End_Date__c = Date.newInstance(2019,02,25);
            createLeaveRequest2.selectedObject = NULL;
            createLeaveRequest2.calculateLeave();  
            
            //SanergyUtils.monthsBetween(createLeaveRequest.startDate,createLeaveRequest.endDate);
            SanergyUtils.monthsBetween(Date.newInstance(System.today().year(),12,28), Date.newInstance(System.today().year()+1,01,10));        
            
            createLeaveRequest.setLeaveDaysAccruedText('21');
            createLeaveRequest.calculateLeave();  
            createLeaveRequest.getSanergyCalendars();
            createLeaveRequest.getLeaveRequests();
            createLeaveRequest.getNumberOfRequestDays();
            createLeaveRequest.getLeaveDaysAccruedText();
            createLeaveRequest.createLeaveRequest();
            
            //Leave Request 3
            CreateLeaveRequestFromEmployee createLeaveRequest3 = new CreateLeaveRequestFromEmployee(controller);   
            createLeaveRequest3.selectedObject = utilization.Id;//temp rs
            createLeaveRequest3.leaveRequest.Leave_Start_Date__c = Date.newInstance(2019,02,25);
            createLeaveRequest3.leaveRequest.Leave_End_Date__c = Date.newInstance(2019,02,28);
            
            createLeaveRequest3.getSanergyCalendars();
            createLeaveRequest3.getLeaveDaysAccruedText();
        
        } //end run as Dev
    }
}