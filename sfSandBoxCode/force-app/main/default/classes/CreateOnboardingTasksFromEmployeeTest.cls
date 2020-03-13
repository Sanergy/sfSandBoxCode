@isTest(seeAllData = true)
public class CreateOnboardingTasksFromEmployeeTest {
    
    static testMethod void CreateOnboardingTasksFromEmployeeTest(){
        
        
        
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
        INSERT empRole;
        system.debug('Employee Role' + empRole);
        
        //Select User           
        //List<User> usr = [SELECT LastName,Alias,Email,Username,CommunityNickname,ProfileId,EmailEncodingKey,Team_Lead__c FROM User LIMIT 1];
        
        //insert user
        User usr = new User();
        usr.LastName = 'David';
        usr.Alias = 'Dave';
        usr.Email = 'usr12345@saner.gy';
        usr.Username = 'johndoe12345@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.Team_Lead__c = '005D0000003Ykhb';
        usr.LocaleSidKey = 'en_US';
        INSERT usr; 
        
        //Create requirement requisition
        Recruitment_Requisition__c requisition = new Recruitment_Requisition__c();
        //requisition.Name = 'Business Analyst';
        requisition.Requestor__c = 'aAsD000000001S7';
        requisition.Talent_Partner__c = usr.Id;
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
        
        //Create Onboarding Task Config
        Onboarding_Task_Config__c onboardingTaskConfig1 = new Onboarding_Task_Config__c();
        onboardingTaskConfig1.Employee_Role__c = empRole.Id;
        onboardingTaskConfig1.Task_Name__c = 'Visit to Kinanie';
        onboardingTaskConfig1.Assigned_To__c = usr.Team_Lead__c;
        onboardingTaskConfig1.No_of_Days_After_Hire_Date__c = 30;
        onboardingTaskConfig1.Category__c = 'Pre-Bamboo HR Tasks';
        onboardingTaskConfig1.Description__c = 'Take all employees to visit to Kinanie';
        onboardingTaskConfig1.On_boarding_Done_By__c = 'Specific User';
        onboardingTaskConfig1.Onboarding_for__c = 'All roles';
        INSERT onboardingTaskConfig1; 
 
        //Create Onboarding Task Config
        Onboarding_Task_Config__c onboardingTaskConfig2 = new Onboarding_Task_Config__c();
        onboardingTaskConfig2.Employee_Role__c = empRole.Id;
        onboardingTaskConfig2.Task_Name__c = 'Visit to Kinanie';
        onboardingTaskConfig2.Assigned_To__c = usr.Team_Lead__c;
        onboardingTaskConfig2.No_of_Days_After_Hire_Date__c = 30;
        onboardingTaskConfig2.Category__c = 'Pre-Bamboo HR Tasks';
        onboardingTaskConfig2.Description__c = 'Take all employees to visit to Kinanie';
        onboardingTaskConfig2.On_boarding_Done_By__c = 'Specific User';
        onboardingTaskConfig2.Onboarding_for__c = 'All roles';
        INSERT onboardingTaskConfig2; 
                
        
          
        CreateOnboardingTasksFromEmployee.OnboardingTask OnbardTask= new CreateOnboardingTasksFromEmployee.OnboardingTask (onboardingTaskConfig1);
        Boolean selected = true;
       // OnbardTask.createTask();

     
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(emp);
        CreateOnboardingTasksFromEmployee createOnbardingTask= new CreateOnboardingTasksFromEmployee (controller);
        createOnbardingTask.getItems();
        createOnbardingTask.createTask();
        
     
    }
}