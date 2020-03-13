@isTest(seeAllData=True)
public class SanergyDepartmentUnitTriggerTest {
    
    static testMethod void SanergyDepartmentUnitTest(){
        //employee department
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c, lookup_ID__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1]; 
        //Testing FFAConfigApproverTrigger
        //Create FFA Config Object
        FFA_Config_Object__c ffaConfig = new FFA_Config_Object__c (
        	name = 'FLCS',
            Type__c = 'dim1',
            isActive__c = TRUE,
            lookup_ID__c = 'XXX',
            Delegated_approver__c = '005D0000003Ykhb'
        );
        INSERT ffaConfig;
        
        //Update FFA Config
        ffaConfig.Team_Lead_Employee_Account__c = 'aAsD0000000GmgM'; //employee object - James
        UPDATE ffaConfig;
        
        //Create User
        User usr = new User();
        usr.LastName = 'John';
        usr.Alias = 'Doe';
        usr.Email = 'johndoe@saner.gy';
        usr.Username = 'johndoe@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.Team_Lead__c = '005D0000003Ykhb';
        usr.LocaleSidKey = 'en_US';
        INSERT usr;           
        
        //Create Department
        Sanergy_Department__c dept = new Sanergy_Department__c();
        dept.Name = 'It department';
        dept.Company__c = 'Sanergy';
        dept.Department_Code__c = 'CORE';
        dept.Department_Status__c = true;
        dept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        //dept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct

        INSERT dept;
        
        //create department unit
        Sanergy_Department_Unit__c deptUnit = new Sanergy_Department_Unit__c();
        deptUnit.Name = 'Information Technology System';
        deptUnit.Unit_Code__c = 'CORE';
        deptUnit.Sanergy_Department__c = dept.Id;
        deptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        deptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        deptUnit.Talent_Partner__c = '005D0000003Ykhb';
        deptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        deptUnit.Active__c = TRUE;
        INSERT deptUnit;  
        
        //Insert Employee Role 
        Employee_Role__c empRole = new Employee_Role__c();
        empRole.Name = 'Business Analyst';
        empRole.Sanergy_Department_Unit__c = deptUnit.Id;
        empRole.Company_Division__c = 'Sanergy';
        empRole.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empRole.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empRole.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empRole.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empRole.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empRole.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT empRole;
        
        system.debug('Employee Role' + empRole);

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
        Employee__c emp = new Employee__c();
        emp.Name = 'Jason';
        emp.Employee_First_Name__c = 'Jason';
        emp.Employee_Last_Name__c = 'Statham';
        emp.Recruitment_Requisition__c = requisition.Id;
        emp.Primary_Phone__c = '0712345678';
        emp.Employment_Start_Date__c = date.today()+50;
        emp.Employee_Active__c = true;
        emp.Employment_Status__c = 'Permanent';
        emp.Employee_Role__c = empRole.Id;
        emp.Sanergy_Department_Unit__c = deptUnit.Id;
        emp.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        emp.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        emp.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        emp.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        emp.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        emp.Talent_Partner__c = 'aAsD0000000GmgM';
        
        INSERT emp;
               
        //Update Employee Role
        UPDATE empRole;
        
        //Update Sanergy Department Unit
        //sanergyDeptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';        
        //UPDATE sanergyDeptUnit;

        
        //Test different company/record type names
        try {
            dept.Department_Status__c = FALSE;
            UPDATE dept;  
        }catch(Exception e){
            system.debug(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        //Test different company/record type names
        try {
            dept.Company__c = 'Fresh Life';
            UPDATE dept;  
        }catch(Exception e){
            system.debug(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
        //Update Sanergy Department
        try {
            dept.Team_Lead_SF_Account__c = usr.Id;
            UPDATE dept; 
        }catch(Exception e){
            system.debug(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
        //Try update TL with no active emp
        try {
            emp.Employee_Active__c = FALSE;
            UPDATE emp;
            
            dept.Team_Lead__c = emp.id;
            UPDATE dept;
        }catch(Exception e){
            system.debug(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
  
        //Reset Employee and Try successful update
        try {
            emp.Employee_Active__c = TRUE;
            UPDATE emp;
            
            dept.Team_Lead__c = emp.id;
            UPDATE dept;
        }catch(Exception e){
            system.debug(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        //Try Delete
        try {
            DELETE dept;
        }catch(Exception e){
            system.debug(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
    }
}