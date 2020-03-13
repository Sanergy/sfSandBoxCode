@isTest(seeAllData=true)
public class CreateEmployeeStatusTriggerTest {
    static testMethod void EmployeeDirectoryTest(){
        
        //employee department
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1]; 
        
        
        
        //Create Department
        Sanergy_Department__c dept = new Sanergy_Department__c();
        dept.Name = 'It department';
        dept.Company__c = 'Sanergy';
        dept.Department_Code__c = 'CORE';
        dept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        dept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
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
        empRole.Has_Groupings__c = false;
        INSERT empRole;
        system.debug('Employee Role' + empRole);
        
    Employee_Role__c empRole2 = new Employee_Role__c();
        empRole2.Name = 'Business Analyst';
        empRole2.Sanergy_Department_Unit__c = deptUnit.Id;
        empRole2.Company_Division__c = 'Sanergy';
        empRole2.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empRole2.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empRole2.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empRole2.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empRole2.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empRole2.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT empRole2;      
        
        Employee_Role_Groupings__c groupings = new Employee_Role_Groupings__c();  
        groupings.Employee_Role__c = empRole2.id;
        groupings.Line_Manager__c = 'aAsD0000000GmgM';
        groupings.Line_Manager_SF_Account__c = '005D0000003Ykhb';
        groupings.Name = 'GROUP-001';
        INSERT groupings;        

        Employee_Role_Groupings__c groupings2 = new Employee_Role_Groupings__c();  
        groupings2.Employee_Role__c = empRole2.id;
        groupings2.Name = 'GROUP-001';
        INSERT groupings2;   
        
        
       empRole2.Has_Groupings__c = true;
       update empRole2;
   

        system.debug('Employee Role2' + empRole2);
        

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
 
        //CREATE EMPLOYEE
        Employee__c emp2 = new Employee__c();
        emp2.Name = 'Jason';
        emp2.Employee_First_Name__c = 'Jason';
        emp2.Employee_Last_Name__c = 'Statham';
        emp2.Recruitment_Requisition__c = requisition.Id;
        emp2.Primary_Phone__c = '0712345678';
        emp2.Employment_Start_Date__c = date.today()+50;
        emp2.Employee_Active__c = true;
        emp2.Employment_Status__c = 'Permanent';
        emp2.Employee_Role__c = empRole2.Id;
        emp2.Sanergy_Department_Unit__c = deptUnit.Id;
        emp2.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        emp2.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        emp2.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        emp2.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        emp2.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        emp2.Talent_Partner__c = 'aAsD0000000GmgM';
        
        
        INSERT emp2;        
        
        
        //Select User           
        //List<User> usr = [SELECT LastName,Alias,Email,Username,CommunityNickname,ProfileId,EmailEncodingKey FROM User LIMIT 1];
        
        //insert user
        User usr = new User();
        usr.LastName = 'David';
        usr.Alias = 'Dave';
        usr.Email = 'johndoe12345@saner.gy';
        usr.Username = 'johndoe12345@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        INSERT usr; 
        
        
        //insert employee status
        Employee_Status__c empstate = new Employee_Status__c();
        empstate.Employee__c = 'aAsD0000000GmgM';
        empstate.Date_To__c = date.today()+20;
        empstate.Effective_Date__c = date.today()+30;
        empstate.Employment_Status__c = 'Casual';
        empstate.Employee_Role__c = empRole.Id;
        empstate.Sanergy_Department_Unit__c = deptUnit.Id;
        empstate.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empstate.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empstate.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empstate.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empstate.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empstate.Talent_Partner__c = 'aAsD0000000GmgM';
        empstate.Expected_End_Date__c = date.today() +40;
        INSERT empstate;
        system.debug('Employee Status' +  empstate);
        
        
        
         empstate.Current_Status__c = true;
        empstate.Status__c = 'Approved';
      //  update empstate;
        
        
        //insert employee status
        Employee_Status__c empstate2 = new Employee_Status__c();
        empstate2.Employee__c = 'aAsD0000000GmgM';
        empstate2.Date_To__c = date.today()+20;
        empstate2.Effective_Date__c = date.today()+30;
        empstate2.Employment_Status__c = 'Casual';
        empstate2.Current_Status__c = false;
        empstate2.Status__c = 'Approved';
        empState2.Employee_Role__c = empRole2.Id;
        empstate2.Sanergy_Department_Unit__c = deptUnit.Id;
        empstate2.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empstate2.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empstate2.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empstate2.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empstate2.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empstate2.Talent_Partner__c = 'aAsD0000000GmgM';
        empstate2.Employee_Role_Grouping__c = groupings.Id;
        empstate2.Expected_End_Date__c = date.today() +40;
        INSERT empstate2;
        system.debug('Employee Status' +  empstate); 
        
        
        empstate2.Current_Status__c = false;
        empstate2.Status__c = 'Approved';
        //update empstate2;
        
    }
}