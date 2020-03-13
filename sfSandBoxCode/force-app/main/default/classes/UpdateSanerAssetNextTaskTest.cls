@isTest(seeAllData = true)
public class UpdateSanerAssetNextTaskTest {
    
    static testMethod void testUpdateSanerAssetNextTaskTest(){
        
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        
        //create gla
        FFA_Config_Object__c gla = [SELECT Id,Name,Type__c 
                                          FROM FFA_Config_Object__c
                                          WHERE NAME LIKE '%6720%'
                                          AND  Type__c = 'gla' 
                                          LIMIT 1];
        
        
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
               
        
        Asset_Maintenance_Schedule__c sched = new Asset_Maintenance_Schedule__c();
        sched.Name = 'Test Name';
        
        Insert sched;
        
        Sanergy_Asset__c sanAsset1 = new Sanergy_Asset__c();
        sanAsset1.Asset_Name__c = 'Laptop'; 
        sanAsset1.Manufacturer__c = 'Dell';
        sanAsset1.Make__c = 'Dell';
        sanAsset1.Model__c = 'Latitude e6430';
        sanAsset1.Operating_System__c = 'Ubuntu';
        sanAsset1.Active__c = true;
        
        insert sanAsset1;
        
        sanAsset1.Manufacturer__c = 'HP';
        sanAsset1.Model__c = 'PRO BOOK';
        update sanAsset1;

        
        Sanergy_Asset__c sanAsset = new Sanergy_Asset__c();
        sanAsset.Asset_Name__c = 'Laptop'; 
        sanAsset.Manufacturer__c = 'Dell';
        sanAsset.Make__c = 'Dell';
        sanAsset.Model__c = 'Latitude e6430';
        sanAsset.Operating_System__c = 'Ubuntu';
        sanAsset.Active__c = true;
        insert sanAsset;
        
        sanAsset.Manufacturer__c = 'HP';
        sanAsset.Model__c = 'PRO BOOK';
        sanAsset.Current_Reading__c = 90;
        update sanAsset;
        
        Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
        usage.Sanergy_Asset__c = sanAsset.Id;
        usage.Current_Reading__c = true;
        usage.Actual_Units__c = 90;
        usage.Date__c = date.today()-3;
        
        insert usage;
        
        List<RecordType> record = [SELECT id,Name from RecordType where Name ='Open'];
		System.debug('RECORD TYPE: ' + record);
        
        List<RecordType> record2 = [SELECT id,Name from RecordType where Name ='Completed'];
		System.debug('RECORD TYPE: ' + record2);
        //insert maint task
        Asset_Maintenance_Task__c maintTask1 = new Asset_Maintenance_Task__c();
        maintTask1.Maintenance_Type__c = 'PM(Preventive Maintenance)';
        maintTask1.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask1.RecordTypeId = record.get(0).id;
        maintTask1.Status__c = 'Open';
        maintTask1.Clone_Service_Items__c = false;
        maintTask1.GLA__c = gla.Id;
        maintTask1.Assigned_To__c = emp.Id;
        maintTask1.Sanergy_Asset__c = sanAsset.Id;
        maintTask1.Maintenance_Type__c = 'PM(Preventive Maintenance)';
        maintTask1.Proposed_Service_Date__c = date.today()+16;
        maintTask1.CreateTask__c = True;
        maintTask1.Notes__c = 'abc';
        maintTask1.Unit_Description__c = 'abe';

        insert maintTask1; 
        
        
        
       /* Asset_Maintenance_Task__c maintTask2 = new Asset_Maintenance_Task__c();
        maintTask2.Maintenance_Type__c = 'BM(Break Down Maintenance)';
        maintTask2.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask2.RecordTypeId = record2.get(0).id;
        maintTask2.Status__c = 'Completed';
        maintTask2.Clone_Service_Items__c = false;
        maintTask2.GLA__c = gla.Id;
        maintTask2.Assigned_To__c = emp.Id;
        maintTask2.Sanergy_Asset__c = sanAsset.Id;
        maintTask2.Service_Date__c = date.today()+2;
        maintTask2.Proposed_Service_Date__c = date.today()+7;
        maintTask2.Proposed_Reading__c = 200.35;

        insert maintTask2;*/
        
        //insert maint task
        Asset_Maintenance_Task__c maintTask = new Asset_Maintenance_Task__c();
        maintTask.Maintenance_Type__c = 'PM(Preventive Maintenance)';
        maintTask.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask.RecordTypeId = record.get(0).id;
        maintTask.Clone_Service_Items__c = false;
        maintTask.GLA__c = gla.Id;
        maintTask.Assigned_To__c = emp.Id;
        maintTask.Sanergy_Asset__c = sanAsset.Id;
        maintTask.Maintenance_Type__c = 'PM(Preventive Maintenance)';
        maintTask.Status__c = 'Completed';
        maintTask.Proposed_Service_Date__c = date.today()+14;
        maintTask.CreateTask__c = True;
        maintTask.Notes__c = 'abc';
        maintTask.Unit_Description__c = 'abe';
        maintTask.Next_Task_Proposed_Date__c = date.today()+16;

        insert maintTask;

        
    }
    
}