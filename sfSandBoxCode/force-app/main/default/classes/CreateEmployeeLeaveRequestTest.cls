@isTest(seeAllData = true)
public class CreateEmployeeLeaveRequestTest {
    static testMethod void testCreateLeaveRequest(){
        
         // Get dim1                              
         List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                  FROM FFA_Config_Object__c 
                                                  WHERE Type__c = 'dim1' 
                                                  AND Name = 'Information Technology'
                                                  AND isActive__c = true LIMIT 1];
        
      // Create Sanergy Department - RecordType - Sanergy
      Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
      
      // Create Sanergy Department Unit        
      Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
      
      // Create Employee Role
        Employee_Role__c empRole = new Employee_Role__c();
      
      // Create Employee
      Employee__c employee = new Employee__c();        
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
        
        //CREATE EMPLOYEE
        employee.Name = 'Jason';
        employee.Employee_First_Name__c = 'Jason';
        employee.Employee_Last_Name__c = 'Statham';
        employee.Recruitment_Requisition__c = requisition.Id;
        employee.Primary_Phone__c = '0712345678';
        employee.Employment_Start_Date__c = date.today()+50;
        employee.Employee_Active__c = true;
        employee.Employment_Status__c = 'Permanent';
        employee.Employee_Role__c = empRole.Id;
        employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employee.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee.Talent_Partner__c = 'aAsD0000000GmgM';
        
        INSERT employee;
		
        //Create Leave Group
        Leave_Group__c leaveGroup = new Leave_Group__c();
        leaveGroup.Name = 'Permanent - Full Times';        
        leaveGroup.Leave_Group__c = 'Full Time';
        INSERT leaveGroup;
        
        System.debug('LEAVE GROUP: ' + leaveGroup);
        
        // Create Leave Entitlement Type Config
        Leave_Entitlement_Type_Config__c leaveTypeConfig = new Leave_Entitlement_Type_Config__c();
        leaveTypeConfig.Leave_Group__c = leaveGroup.Id;
        leaveTypeConfig.Leave_Type__c = 'Annual Leave';
        leaveTypeConfig.Year__c = 2018;
        leaveTypeConfig.Total_No_of_Leave_Days__c = 21;
        //leaveTypeConfig.Proratable__c = true;
        INSERT leaveTypeConfig;
        
        System.debug('LEAVE TYPE CONFIG: ' + leaveTypeConfig);       
        
        // Create Leave Entitlement Utilization
        Leave_Entitlement_Utilization__c leaveUtilization = new Leave_Entitlement_Utilization__c();
        leaveUtilization.Leave_Entitlement_Type_Config__c = leaveTypeConfig.Id;
        leaveUtilization.Employee__c = employee.Id;
        leaveUtilization.Total_No_of_Leave_Days__c = 10;
        INSERT leaveUtilization;
        
        System.debug('LEAVE UTILIZATION: ' + leaveUtilization);    
        
		// Create Employee Leave Request
        Employee_Leave_Request__c  leaveRequest = new Employee_Leave_Request__c();
        leaveRequest.Leave_Entitlement_Utilization__c = leaveUtilization.Id;
        leaveRequest.Employee__c = employee.Id;
        leaveRequest.Leave_Start_Date__c = date.today();
        leaveRequest.Leave_End_Date__c = date.today() + 3;
		leaveRequest.Employee_s_Department__c = sanergyDeptUnit.Id;
		leaveRequest.Department_Team_Lead__c = sanergyDeptUnit.Approver__c;        
        INSERT leaveRequest;
        
        System.debug('EMPLOYEE LEAVE REQUEST: ' + leaveRequest);

		// Create Sanergy Calendar
        Sanergy_Calendar__c sanergyCalendar = new Sanergy_Calendar__c();         
        sanergyCalendar.Name = 'SC-2018-05-01';
        sanergyCalendar.Date__c = date.today();
        sanergyCalendar.Description__c = 'Labour Day';
        sanergyCalendar.IsHoliday__c = true;
        sanergyCalendar.IsWeekend__c = false;
        INSERT sanergyCalendar;
        
        System.debug('SANERGY CALENDAR: ' + sanergyCalendar);        
    }
}