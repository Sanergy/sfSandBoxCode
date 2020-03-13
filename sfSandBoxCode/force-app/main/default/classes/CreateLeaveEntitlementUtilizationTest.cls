@isTest(seeAllData = true)
public class CreateLeaveEntitlementUtilizationTest {
    static testMethod void testUpdateLeaveGroup(){
        
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
        Employee__c employee2= new Employee__c();        

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
        
        //Create Leave Group
        Leave_Group__c leaveGroup1 = new Leave_Group__c();
        leaveGroup1.Name = 'Standard Time Off';        
        leaveGroup1.Leave_Group__c = 'Standard Time Off';
        INSERT leaveGroup1;
        
        // Create Leave Entitlement Type Config
        Leave_Entitlement_Type_Config__c leaveTypeConfig1 = new Leave_Entitlement_Type_Config__c();
        leaveTypeConfig1.Leave_Group__c = leaveGroup1.Id;
        leaveTypeConfig1.Leave_Type__c = 'Annual Leave';
        leaveTypeConfig1.Year__c = 2019;
        leaveTypeConfig1.Total_No_of_Leave_Days__c = 21;
        leaveTypeConfig1.Proratable__c = true;
        leaveTypeConfig1.Display_to_User__c = true;
        leaveTypeConfig1.Year_Start_Date__c = date.today() -20;
        INSERT leaveTypeConfig1;
        
        
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
        employee.Leave_Group__c = leaveGroup1.Id;
        employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee.Talent_Partner__c = 'aAsD0000000GmgM';
        employee.Employee_SF_Account__c = '005D0000008kHZI';
        employee.Leave_Accrual_Start_Date__c = date.today()-50;
        employee.Employment_Start_Date__c = date.today() - 100;

        INSERT employee;
 
        
        
        
        employee2.Name = 'Jason';
        employee2.Employee_First_Name__c = 'Jason';
        employee2.Employee_Last_Name__c = 'Statham';
        employee2.Recruitment_Requisition__c = requisition.Id;
        employee2.Primary_Phone__c = '0712345678';
        employee2.Employment_Start_Date__c = date.today()+50;
        employee2.Employee_Active__c = true;
        employee2.Gender__c = 'Male';
        employee2.Employment_Status__c = 'Permanent';
        employee2.Employee_Role__c = empRole.Id;
        employee2.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employee2.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee2.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee2.Leave_Group__c = leaveGroup1.Id;
        employee2.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee2.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee2.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee2.Talent_Partner__c = 'aAsD0000000GmgM';
        employee2.Employee_SF_Account__c = '005D0000003Ykhb';
        employee2.Leave_Accrual_Start_Date__c = date.today()-50;
        employee2.Employment_Start_Date__c = date.today() - 200;

        INSERT employee2;
        
        // Update Employee's Leave Group
        //    employee.Leave_Group__c = leaveGroup1.Id;
        //  UPDATE employee;
        
        //****************************8
        //Create Leave Group
        Leave_Group__c leaveGroup2 = new Leave_Group__c();
        leaveGroup2.Name = 'Permanent - Part Time';        
        leaveGroup2.Leave_Group__c = 'Part Time';
        INSERT leaveGroup2;
        
        // Create Leave Entitlement Type Config
        Leave_Entitlement_Type_Config__c leaveTypeConfig2 = new Leave_Entitlement_Type_Config__c();
        leaveTypeConfig2.Leave_Group__c = leaveGroup2.Id;
        leaveTypeConfig2.Leave_Type__c = 'Annual Leave';
        leaveTypeConfig2.Year__c = 2019;
        leaveTypeConfig2.Total_No_of_Leave_Days__c = 21;
        //leaveTypeConfig.Proratable__c = true;
        leaveTypeConfig2.Display_to_User__c = true;
        leaveTypeConfig1.Year_Start_Date__c = date.today();
        INSERT leaveTypeConfig2;
        
        
        
        // Update Employee's Leave Group
        employee.Leave_Group__c = leaveGroup2.Id;
        UPDATE employee;
        CreateLeaveEntitlementUtilization.empWrapper empWrapperWrapperClass = new CreateLeaveEntitlementUtilization.empWrapper(employee);
        empWrapperWrapperClass.selected = true;
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(leaveTypeConfig1);
        CreateLeaveEntitlementUtilization utilization = new CreateLeaveEntitlementUtilization(controller);
        
        
       
      	Leave_Entitlement_Utilization__c leaveUtilization1 = new Leave_Entitlement_Utilization__c();
        leaveUtilization1.Leave_Entitlement_Type_Config__c = leaveTypeConfig1.Id;
        leaveUtilization1.Employee__c = employee.Id;
        leaveUtilization1.Total_No_of_Leave_Days__c = 10;
        INSERT leaveUtilization1;
        
        //Create Leave Accrual
        Leave_Accrual__c leaveAccrual1 = new Leave_Accrual__c();
        //leaveAccrual1.Name = leaveTypeConfig1.Leave_Type__c;
        leaveAccrual1.Leave_Entitlement_Utilization__c = leaveUtilization1.Id;
        leaveAccrual1.Employee__c = employee.Id;
        leaveAccrual1.Period__c = System.today().year() + ' - ' + System.today().month(); 
        INSERT leaveAccrual1; 
        
        //DELETE leaveUtilization1;
        //DELETE leaveAccrual1;       
        utilization.getEmployees();

        utilization.createUtilizations();
        utilization.selectAll();
        utilization.selectAll();
        
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(leaveTypeConfig2);
        CreateLeaveEntitlementUtilization utilization1 = new CreateLeaveEntitlementUtilization(controller1);
        
        
        Leave_Entitlement_Utilization__c leaveUtilization2 = new Leave_Entitlement_Utilization__c();
        leaveUtilization2.Leave_Entitlement_Type_Config__c = leaveTypeConfig2.Id;
        leaveUtilization2.Employee__c = employee.Id;
        leaveUtilization2.Total_No_of_Leave_Days__c = 10;
        INSERT leaveUtilization2;
        
        //Create Leave Accrual
        Leave_Accrual__c leaveAccrual2 = new Leave_Accrual__c();
        //leaveAccrual2.Name = leaveTypeConfig2.Leave_Type__c;
        leaveAccrual2.Leave_Entitlement_Utilization__c = leaveUtilization2.Id;
        leaveAccrual2.Employee__c = employee.Id;
        leaveAccrual2.Period__c = System.today().year() + ' - ' + System.today().month(); 
        INSERT leaveAccrual2;	       

		utilization1.getEmployees();
        utilization1.createUtilizations();
        utilization1.selectAll();
        utilization1.unselectAll();
        
        
        /***************************
if(employee.Leave_Group__c != leaveGroup1.Id){

}*/
    }
}