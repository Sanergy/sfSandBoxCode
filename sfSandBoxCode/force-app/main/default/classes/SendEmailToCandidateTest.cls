@isTest(seeAllData=true)
public class SendEmailToCandidateTest {
    
    static testMethod void testSendEmailToCandidate(){
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        
        User user = [SELECT Id, Name  
                     FROM User
                     WHERE Name = 'Web App'];        
        
        // Create Employee Manager
        Employee__c employeeManager = new Employee__c();
        
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
        
        //Create Recruitment Request Config - RecordType - Account
        Recruitment_Request_Config__c recruitmentRequestConfig1 = new Recruitment_Request_Config__c();   
        recruitmentRequestConfig1.RecordTypeId = '012D0000000Qrta';
        recruitmentRequestConfig1.Employee_Role__c = empRole.Id;
        recruitmentRequestConfig1.Amount__c = 100;
        recruitmentRequestConfig1.Maximum__c = 100;
        recruitmentRequestConfig1.Type__c = 'Airtime Allowance';
        INSERT recruitmentRequestConfig1;
        
        System.debug('Recruitment Request Config: ' + recruitmentRequestConfig1);         
        
        //Create Recruitment Request Config - RecordType - Account
        Recruitment_Request_Config__c recruitmentRequestConfig2 = new Recruitment_Request_Config__c();   
        recruitmentRequestConfig2.RecordTypeId = '012D0000000Qrta';
        recruitmentRequestConfig2.Employee_Role__c = empRole.Id;
        recruitmentRequestConfig2.Amount__c = 100;
        recruitmentRequestConfig2.Maximum__c = 100;
        recruitmentRequestConfig2.Type__c = 'Meal Allowance';
        INSERT recruitmentRequestConfig2;
        
        System.debug('Recruitment Request Config: ' + recruitmentRequestConfig1);       
        
        // Create Employee Manager       
        employeeManager.Name = 'Kim Kardashian';
        employeeManager.Employee_First_Name__c = 'Kim';
        employeeManager.Employee_Last_Name__c = 'Kardashian';
        employeeManager.Primary_Phone__c = '1234567';
        employeeManager.Employment_Start_Date__c = date.today() - 200;
        employeeManager.Employment_Status__c = 'Permanent';
        employeeManager.Identification_Number__c = '920183';
        employeeManager.Primary_Phone__c = '93489853489';      
        employeeManager.Sanergy_Department__c = sanergyDept.Id;
        employeeManager.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employeeManager.Employee_Role__c = empRole.Id;
        employeeManager.Recruitment_Requisition__c = requisition.Id;
        //employeeManager.Employee_SF_Account__c = '0057E000003e0oe';
        employeeManager.Company_Division__c = empRole.Company_Division__c;
        employeeManager.Tickets_Created__c = false; 
        INSERT employeeManager;
        
        System.debug('EMPLOYEE MANAGER: ' + employeeManager);
        
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
        employee.Tickets_Created__c = false;        
        INSERT employee;
        
        // Update Recruitment Requisition
        // recruitmentRequisition.Requestor__c = employeeManager.Id;
        UPDATE requisition;
        
        // Update Sanergy Department
        //sanergyDept.Team_Lead__c = employeeManager.Id;
        UPDATE sanergyDept;
        
        // Update Sanergy Department Unit
        // sanergyDeptUnit.Line_Manager__c = employeeManager.Id;
        UPDATE sanergyDeptUnit;
        
        // Update Employee Role
        // employeeRole.Line_Manager__c = employeeManager.Id;
        UPDATE empRole;
        
        // Create Candidate
        Candidate__c candidate = new Candidate__c();
        //candidate.Name = 'John Doe';
        candidate.Recruitment_Requisition__c = requisition.Id;
        candidate.First_Name__c = 'John';
        candidate.Last_Name__c = 'Doe';
        candidate.ID_Number__c = '12345678';
        candidate.Phone_Number__c = '+254736271518';
        candidate.Email__c = 'johndoe@saner.gy';
        candidate.Resume__c = 'https://www.google.com/';
        candidate.Country__c = 'Las Vegas';
        candidate.Date_Available__c = date.today();
        candidate.Candidate_Status__c = 'Shortlisted';
        candidate.Requesting_Department__c = department.get(0).Id;
        candidate.Requesting_Department_Team_Lead__c = department.get(0).Teamlead__c;
        INSERT candidate;
        
        System.debug('CANDIDATE: ' + candidate);
        
		//Create Candidate Requisition
        Candidate_Requisition__c candidateRequisition = new Candidate_Requisition__c();
        candidateRequisition.Candidate__c = candidate.Id;
        candidateRequisition.Status__c = 'Shortlisted';
        candidateRequisition.Date_Available__c = date.today();
        candidateRequisition.Candidate_Rating__c = '1';
        candidateRequisition.Recruitment_Requisition__c = requisition.Id;
        candidateRequisition.Years_Of_Experience__c = '2.0';
        candidateRequisition.OwnerId = user.Id;
        INSERT candidateRequisition;
        
        // Update Candidate Status
        candidate.Candidate_Status__c = 'Offer Accepted';
        UPDATE candidate;
        
        System.debug('UPDATE CANDIDATE: ' + candidate); 
    }
    
}