@isTest(seeAllData=true)
public class ToiletsClosedNotificationTest {
    
    // Tests for ToiletsClosedNotification class.    
    @isTest static void testToiletsClosed(){ 
        
        Date d = date.today() + 1;        
        
        List<RecordType> record = [SELECT id,Name from RecordType where Name ='Sanergy'];
        System.debug('RECORD TYPE: ' + record);
        
        // Get dim1                              
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
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
        
        System.debug('deptUnit = ' + deptUnit);   
        
        // Create Employee Role
        Employee_Role__c empRole1 = new Employee_Role__c();      
        empRole1.Name = 'Business Analyst';
        empRole1.Sanergy_Department_Unit__c = deptUnit.Id;
        empRole1.Company_Division__c = 'Sanergy';
        empRole1.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empRole1.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empRole1.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empRole1.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empRole1.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empRole1.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT empRole1;
        system.debug('Employee Role' + empRole1);
        
        //Create Recruitment_Requisition__c
        Recruitment_Requisition__c requisition1 = new Recruitment_Requisition__c();
        requisition1.Name = 'Business Analyst';
        requisition1.Requestor__c = 'aAsD000000001S7';
        requisition1.Talent_Partner__c = '005D0000003Ykhb';
        requisition1.Employee_Role__c = empRole1.Id;
        requisition1.Request_Date__c = date.today()+30;
        requisition1.Number_of_Required_Staff__c = 5;
        requisition1.Job_Description__c = 'ANALYSIS';
        requisition1.Justification_for_new_position__c = 'Test';
        requisition1.Type_of_employment__c = 'Permanent';
        requisition1.Duration_of_Fixed_term_Contract_Months__c = 1;
        requisition1.Is_recruitment_budgeted__c = 'yes';
        requisition1.Candidate_Specification__c = 'Kenyan';
        requisition1.Proposed_Employee_required_Date__c = date.today()+40;
        requisition1.Location__c = 'Mukuru';
        requisition1.Requesting_Department__c = department.get(0).Id;
        INSERT requisition1;
        
        // Create Employee
        Employee__c employee1 = new Employee__c();  
        employee1.Name = 'Jane Doe';
        employee1.Employee_First_Name__c = 'Jane';
        employee1.Employee_Last_Name__c = 'Doe';
        employee1.Job_Title__c = 'Associate';
        employee1.Recruitment_Requisition__c = requisition1.Id;
        employee1.Primary_Phone__c = '0712345678';
        employee1.Employment_Start_Date__c = date.today()+50;
        employee1.Employee_Active__c = true;
        employee1.Gender__c = 'Male';
        employee1.Employment_Status__c = 'Permanent';
        employee1.Employee_Role__c = empRole1.Id;
        employee1.Sanergy_Department_Unit__c = deptUnit.Id;
        employee1.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee1.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee1.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee1.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee1.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee1.Talent_Partner__c = 'aAsD0000000GmgM';
        employee1.Employee_SF_Account__c = '005D0000004ZrkJ';
        employee1.Leave_Accrual_Start_Date__c = date.today()-50;
        employee1.Employment_Start_Date__c = date.today() - 100;
        employee1.Tickets_Created__c = false;
        INSERT employee1;
        
        // Create Employee
        Employee__c employee2 = new Employee__c();  
        employee2.Name = 'Jane Doe';
        employee2.Employee_First_Name__c = 'Jane';
        employee2.Employee_Last_Name__c = 'Doe';
        employee2.Job_Title__c = 'Associate';
        employee2.Recruitment_Requisition__c = requisition1.Id;
        employee2.Primary_Phone__c = '0712345678';
        employee2.Employment_Start_Date__c = date.today()+50;
        employee2.Employee_Active__c = true;
        employee2.Gender__c = 'Male';
        employee2.Employment_Status__c = 'Permanent';
        employee2.Employee_Role__c = empRole1.Id;
        employee2.Sanergy_Department_Unit__c = deptUnit.Id;
        employee2.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee2.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee2.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee2.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee2.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee2.Talent_Partner__c = 'aAsD0000000GmgM';
        employee2.Employee_SF_Account__c = '005D0000004ZrkJ';
        employee2.Leave_Accrual_Start_Date__c = date.today()-50;
        employee2.Employment_Start_Date__c = date.today() - 100;
        employee2.Tickets_Created__c = false;
        INSERT employee2;           
        
        //Create Area
        Area__c area = new Area__c();
        area.Name = 'Nairobi';
        area.Area_Abbreviation__c = 'NRB';
        area.Last_Location_No__c = 100;        
        INSERT area;
        
        //Create Sub Area
        Sub_Area__c subArea = new Sub_Area__c();
        subArea.Name = 'Sameer Business Park';
        subArea.Area_Name__c = area.Id;
        subArea.Customer_Support_Asst_Mngr_EmployeeGUID__c = employee1.Id;
        subArea.Customer_Support_CSA_EmployeeGUID__c = employee2.Id;
        subArea.Sales_SA_EmployeeGUID__c = employee1.Id;
        subArea.Sales_Asst_Mngr_EmployeeGUID__c = employee2.Id;          
        INSERT subArea;        
        
        //Create Account       
        Account accounts = new Account();
        accounts.Name = 'Nicki Minaj';
        accounts.CurrencyIsoCode = 'KES';                        
        INSERT accounts;
        
        //Create Contact
        Contact contacts=new Contact();
        contacts.FirstName = 'John';
        contacts.LastName = 'Doe';
        contacts.Sex__c = 'Male';
        INSERT contacts;
        
        // Create Location  
        Location__c location = new Location__c();
        location.Name = 'NRB-20';
        location.Last_FLT__c = 0;
        location.Franchise_Type__c = 'Residential';
        location.Sub_Area__c = subArea.Id;
        INSERT location;  
        
        //Create Opportunity
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Nicki minaj';
        opportunity.AccountId = accounts.Id;
        opportunity.StageName = 'Sale Open';
        opportunity.Primary_Salesperson__c = contacts.Id;
        opportunity.CloseDate = date.today() + 7;
        opportunity.Sub_Area_Lookup__c = subArea.Id;
        opportunity.Location__c = location.Id;
        opportunity.Franchise_Type__c = 'Residential';
        
        //Run test as TEMP RS        
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {            
            INSERT opportunity;
        }//End System.runAs(u)     
        
        // Create a Toilet
        Toilet__c toilet = new Toilet__c();
        toilet.RecordTypeId = record.get(0).Id;
        toilet.Name = 'NRB-20.1';
        toilet.Location__c = location.Id;
        toilet.Opportunity__c = opportunity.Id;     
        toilet.Operational_Status__c = 'Closed';
        toilet.Current_Specific_Status__c = 'Closed - Demolished';
        toilet.Closure_Type__c = 'Temporary';
        toilet.Reason_1__c = 'Dispute';
        toilet.Explanation_1__c='With neighbors';
        toilet.Collection_Route__c = 'Ruben Collection Spot';
        toilet.Current_Status_Change_date__c = date.today() - 60; //Insert -60 days
        INSERT toilet;       
        
        // Create an instance of ToiletsClosedNotification
        ToiletsClosedNotification toiletsClosed = new ToiletsClosedNotification();
        Database.executeBatch(toiletsClosed);           
    }
    
    // Tests for ToiletsClosedNotificationSchedule class.     
    @isTest static void testToiletsClosedNotificationSchedule(){
        // Execute the job on midnight, 31 December 2022
        String cronExpr = '0 0 0 31 12 ? 2022';
        
        // Create an instance of ToiletsClosedNotificationSchedule         
        ToiletsClosedNotificationSchedule ns = new ToiletsClosedNotificationSchedule();
        
        // Schedule the test job        
        String jobId = System.schedule('This is a Sandbox Test Job', cronExpr, ns);
        ns.execute(null);
        
    }
}