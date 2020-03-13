@isTest(seealldata=true)
public class DepartmentTeamLeadTriggerTest {

    static testMethod void testTeamLeadsTrigger(){
        
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
        
        // Create Sanergy Department Unit        
        Sanergy_Department_Unit__c sanergyDeptUnit2 = new Sanergy_Department_Unit__c();        
        
        // Create Employee Role
        Employee_Role__c employeeRole = new Employee_Role__c();        
        
        // Create Employee Manager
        Employee__c employeeManager = new Employee__c();       
        
        // Create Employee
        Employee__c employee = new Employee__c();
        
        //Create Leave Group
        Leave_Group__c leaveGroup = new Leave_Group__c();        
        
        //Create Recruitment requisition
        Recruitment_Requisition__c recruitmentRequisition = new Recruitment_Requisition__c();
        //recruitmentRequisition.Name = 'System Analyst';
        recruitmentRequisition.Requestor__c = employeeManager.Id;
        recruitmentRequisition.Requesting_Department__c = department.get(0).Id;
        recruitmentRequisition.Talent_Partner__c = department.get(0).Teamlead__c;
        recruitmentRequisition.Request_Date__c = date.today();
        recruitmentRequisition.Stage__c = 'New';
        recruitmentRequisition.Number_of_Required_Staff__c = 3;
        recruitmentRequisition.Job_Description__c = 'Job description text';
        recruitmentRequisition.Justification_for_Additional_staff__c = 'Assist in completion of projects';
        recruitmentRequisition.Type_of_employment__c = 'Permanent';
        recruitmentRequisition.Duration_of_Fixed_term_Contract_Months__c = 3;
        recruitmentRequisition.Is_recruitment_budgeted__c = 'Yes';
        //recruitmentRequisition.Candidate_Specification__c = 'Any Nationality';
        recruitmentRequisition.Proposed_Employee_required_Date__c = date.today()+30;
        recruitmentRequisition.Location__c = 'Sameer';
        INSERT recruitmentRequisition;       
        
        System.debug('RECRUITMENT REQUISITION: ' + recruitmentRequisition);
        
        // Create Sanergy Department - RecordType - Sanergy
        sanergyDept.RecordTypeId = '012D0000000KIvqIAG';        
        sanergyDept.Name = 'Core Services';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Team_Lead__c = employeeManager.Id;
        INSERT sanergyDept;
        
        System.debug('SANERGY DEPARTMENT: ' + sanergyDept);
        
        // Create Sanergy Department Unit      
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
        
        System.debug('SANERGY DEPARTMENT UNIT: ' + sanergyDeptUnit);
        
        sanergyDeptUnit2.Name = 'Information Technology System';
        sanergyDeptUnit2.Unit_Code__c = 'CORE';
        sanergyDeptUnit2.Sanergy_Department__c = sanergyDept.Id;
        sanergyDeptUnit2.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit2.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        sanergyDeptUnit2.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit2.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        sanergyDeptUnit2.Talent_Partner__c = '005D0000003Ykhb';
        sanergyDeptUnit2.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        INSERT sanergyDeptUnit2;      
        
        System.debug('SANERGY DEPARTMENT UNIT 2: ' + sanergyDeptUnit2);        
        
        //Insert Employee Role 
        employeeRole.Name = 'Business Analyst';
        employeeRole.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employeeRole.Company_Division__c = 'Sanergy';
        employeeRole.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employeeRole.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employeeRole.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employeeRole.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employeeRole.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employeeRole.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT employeeRole;
        System.debug('EMPLOYEE ROLE: ' + employeeRole);
        
        // Create Employee Manager       
        employeeManager.Name = 'Kim Kardashian';
        employeeManager.Employee_First_Name__c = 'Kim';
        employeeManager.Employee_Last_Name__c = 'Kardashian';
        employeeManager.Gender__c = 'Male';
        employeeManager.Primary_Phone__c = '1234567';
        employeeManager.Employment_Start_Date__c = date.today() - 200;
        employeeManager.Employment_Status__c = 'Permanent';
        employeeManager.Identification_Number__c = '920183';
        employeeManager.Primary_Phone__c = '93489853489';      
        employeeManager.Sanergy_Department__c = sanergyDept.Id;
        employeeManager.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employeeManager.Employee_Role__c = employeeRole.Id;
        employeeManager.Recruitment_Requisition__c = recruitmentRequisition.Id;
        //employeeManager.Employee_SF_Account__c = '0057E000003e0oe';
        employeeManager.Company_Division__c = employeeRole.Company_Division__c;
        employeeManager.Tickets_Created__c = false; 
        INSERT employeeManager;
        
        System.debug('EMPLOYEE MANAGER: ' + employeeManager);           
        
        //Create Leave Group
        leaveGroup.Leave_Group__c = 'Permanent - Part Time';
        leaveGroup.Leave_Group_Status__c = true;
        leaveGroup.Leave_Group__c = 'Just a comment';
        INSERT leaveGroup;
        
        System.debug('LEAVE GROUP : ' + leaveGroup);    
        
        // Create Employee        
      //CREATE EMPLOYEE
        employee.Name = 'Jason';
        employee.Employee_First_Name__c = 'Jason';
        employee.Employee_Last_Name__c = 'Statham';
        employee.Recruitment_Requisition__c = recruitmentRequisition.Id;
        employee.Primary_Phone__c = '0712345678';
        employee.Employment_Start_Date__c = date.today()+50;
        employee.Employee_Active__c = true;
        employee.Gender__c = 'Male';
        employee.Employment_Status__c = 'Permanent';
        employee.Employee_Role__c = employeeRole.Id;
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
        
        System.debug('EMPLOYEE : ' + employee);
        
        //Update Employee's Leave Group
        employee.Leave_Group__c = leaveGroup.Id;
        UPDATE employee;
        
        System.debug('UPDATE EMPLOYEE : ' + employee);        
        
        //Create Leave_Entitlement_Type_Config__c
        Leave_Entitlement_Type_Config__c leaveType = new Leave_Entitlement_Type_Config__c();
        leaveType.Leave_Group__c = leaveGroup.Id;
        leaveType.Leave_Type__c = 'Annual Leave';
        leaveType.Year__c = 2018;
        leaveType.Total_No_of_Leave_Days__c = 21;
        leaveType.Proratable__c = true;
        INSERT leaveType;
        
        System.debug('LEAVE TYPE : ' + leaveType);
        
        //Create Leave Entitlement Utilization
        Leave_Entitlement_Utilization__c leaveUtilization = new Leave_Entitlement_Utilization__c();
        leaveUtilization.Leave_Entitlement_Type_Config__c = leaveType.Id;
        leaveUtilization.Employee__c = employee.Id;
        INSERT leaveUtilization;
        
        System.debug('LEAVE UTILIZATION : ' + leaveUtilization);            
        
        //Create Employee Leave Request 
        Employee_Leave_Request__c leaveRequest = new Employee_Leave_Request__c();
        leaveRequest.Leave_Entitlement_Utilization__c = leaveUtilization.Id;
        leaveRequest.Employee__c = employee.Id;
        leaveRequest.Leave_Start_Date__c = employee.Leave_Accrual_Start_Date__c;
        leaveRequest.Leave_End_Date__c = date.today() + 30;
        leaveRequest.Employee_s_Department__c = employee.Sanergy_Department_Unit__c;
        leaveRequest.Department_Team_Lead__c = employee.Sanergy_Department_Unit__r.Approver__c;       
        INSERT leaveRequest;        
        
        System.debug('LEAVE REQUEST : ' + leaveRequest);
        
        leaveRequest.Employee_s_Department__c = sanergyDeptUnit2.Id;
        UPDATE leaveRequest;
        
        System.debug('LEAVE REQUEST UPDATE: ' + leaveRequest);        
    }    
}