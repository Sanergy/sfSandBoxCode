@isTest(seeAllData=true)
public class REST_Case_Test {
    
    static testMethod void  testGetMethod(){
        
        //Get Opportunity Maintenance Case RecordType
        RecordType opportunityMaintenanceCaseRecordType = [SELECT Id,Name 
                                                           FROM RecordType 
                                                           WHERE Name ='Maintenance Cases' 
                                                           LIMIT 1];
        
        // Get dim1                              
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        
        // Get Sanergy USD Account                            
        Account accounts = [SELECT Id,Name
                            FROM Account 
                            WHERE Name = 'Sanergy USD'
                            LIMIT 1];         
        
        // Create Sanergy Department - RecordType - Sanergy
        Sanergy_Department__c sanergyDept1 = new Sanergy_Department__c();
        sanergyDept1.Name = 'It department';
        sanergyDept1.Company__c = 'Sanergy';
        sanergyDept1.Department_Code__c = 'CORE';
        sanergyDept1.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDept1.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        INSERT sanergyDept1;
        
        System.debug('sanergyDept1 = ' + sanergyDept1);
        
        // Create Sanergy Department Unit        
        Sanergy_Department_Unit__c sanergyDeptUnit1 = new Sanergy_Department_Unit__c();
        sanergyDeptUnit1.Name = 'Information Technology System';
        sanergyDeptUnit1.Unit_Code__c = 'CORE';
        sanergyDeptUnit1.Sanergy_Department__c = sanergyDept1.Id;
        sanergyDeptUnit1.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit1.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        sanergyDeptUnit1.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit1.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        sanergyDeptUnit1.Talent_Partner__c = '005D0000003Ykhb';
        sanergyDeptUnit1.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        INSERT sanergyDeptUnit1;
        
        System.debug('sanergyDeptUnit1 = ' + sanergyDeptUnit1);
        
        // Create Employee Role
        Employee_Role__c empRole1 = new Employee_Role__c();      
        empRole1.Name = 'Business Analyst';
        empRole1.Sanergy_Department_Unit__c = sanergyDeptUnit1.Id;
        empRole1.Company_Division__c = 'Sanergy';
        empRole1.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empRole1.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empRole1.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empRole1.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empRole1.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empRole1.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT empRole1;
        
        System.debug('Employee Role 1 = ' + empRole1);
        
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
        
        System.debug('requisition1 = ' + requisition1);      
        
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
        employee1.Sanergy_Department_Unit__c = sanergyDeptUnit1.Id;
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
        
        System.debug('employee1 = ' + employee1);          
        
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
        employee2.Sanergy_Department_Unit__c = sanergyDeptUnit1.Id;
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
        
        System.debug('employee2 = ' + employee2);        
        
        //Create User
        User usr = new User();
        usr.LastName = 'Kellen';
        usr.Alias = 'Ellen';
        usr.Email = 'kellenellen@saner.gy';
        usr.Username = 'kellenellen@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.Team_Lead__c = '005D0000003Ykhb';
        usr.LocaleSidKey = 'en_US';
        INSERT usr;
        
        System.debug('user = ' + usr);
        
        //Create Area
        Area__c area = new Area__c();
        area.Name = 'Nairobi';
        area.Area_Abbreviation__c = 'NRB';
        area.Last_Location_No__c = 100;        
        INSERT area;
        
        System.debug('area = ' + area);          
        
        //Create Sub Area
        Sub_Area__c subArea = new Sub_Area__c();
        subArea.Name = 'Sameer Business Park';
        subArea.Area_Name__c = area.Id;
        subArea.Customer_Support_Asst_Mngr_EmployeeGUID__c = employee1.Id;
        subArea.Customer_Support_CSA_EmployeeGUID__c = employee2.Id;
        subArea.Sales_SA_EmployeeGUID__c = employee1.Id;
        subArea.Sales_Asst_Mngr_EmployeeGUID__c = employee2.Id;        
        INSERT subArea;
        
        System.debug('subArea = ' + subArea);
        
        // Create Location  
        Location__c location = new Location__c();
        location.Name = 'NRB-20';
        location.Last_FLT__c = 0;
        location.Franchise_Type__c = 'Residential';
        location.Sub_Area__c = subArea.Id;
        INSERT location;
        
        System.debug('location = ' + location);        

        //Create a Contact
        Contact salesPerson = new Contact();
        salesPerson.FirstName = 'Jane';
        salesPerson.LastName = 'Doe';
        salesPerson.Sex__c = 'Female';
        salesPerson.Employee_Name__c = employee1.Id;
        salesPerson.RecordTypeId = '012D0000000KEEfIAO';//Fresh Life Sales Associate
        salesPerson.AccountId = accounts.Id;
        salesPerson.OwnerId = usr.Id;
        INSERT salesPerson;
        
        System.debug('salesPerson = ' + salesPerson);          
        
        // Create a Lead
        Lead lead = new Lead();
        lead.FirstName = 'John';
        lead.LastName = 'Doe';
        lead.Status = 'Open';
        lead.Company = 'John Doe';
        lead.Primary_Salesperson__c = salesPerson.Id;
        lead.Phone = '12345987';
        lead.FLTS_Requested__c = 2;
        lead.Plot_Occupied__c = 'Yes';
        lead.Plot_Completed__c = 'Yes';
        lead.LeadSource = 'Hotspot';
        lead.Franchise_Type__c = 'Institution';
        lead.Deposit_Paid__c = true;
        lead.FLR_Lease__c = true;
        lead.Sub_Area_Lookup__c = subArea.Id;
        lead.OwnerId = usr.Id;
        INSERT lead; 
        
        //Create Account from Lead
        Account account = new Account();
        account.Name = lead.Company;
        account.Phone = lead.Phone;
        account.Type = 'Prospect'; //Customer
        account.Mobile_Payment_Payee__c = lead.Company;
        account.Area__c =  lead.Sub_Area_Lookup__r.Area__c;
        account.SubArea__c = lead.Sub_Area_Lookup__c;
        account.Primary_Salesperson__c = lead.Primary_Salesperson__c;
        account.OwnerId = lead.OwnerId; //lead.Primary_Salesperson__c
        account.RecordTypeId = '012D0000000KE7nIAG';// Sanergy Toilet Sale - Prospect
        INSERT account;
        
        System.debug('account = ' + account);        
        
        //Create Opportunity from Lead
        Opportunity opportunity = new Opportunity();
        opportunity.StageName ='Pending Govt Approval';
        opportunity.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management            
        opportunity.AccountId = account.Id;
        opportunity.Name = account.Name;
        opportunity.No_of_FLTs__c = lead.FLTS_Requested__c;
        opportunity.Primary_Salesperson__c = lead.Primary_Salesperson__c;
        opportunity.LeadSource = lead.LeadSource;
        opportunity.CloseDate =  date.today() + 30;
        opportunity.Area_Name__c = area.Id;
        opportunity.Sub_Area_Lookup__c = subArea.Id;
        opportunity.OwnerId = lead.OwnerId; //lead.Primary_Salesperson__c
        if(lead.Plot_Completed__c == 'Yes'){
            opportunity.Plot_Complete__c = true;
        }
        if(lead.Plot_Occupied__c == 'Yes'){
            opportunity.Plot_Occupied__c = true;
        }
        if(lead.Franchise_Type__c == 'Institution'){
            opportunity.Franchise_Type__c = 'Institution';
        }
        
        INSERT opportunity;
        
        System.debug('opportunity = ' + opportunity);        
        
        //Create Toilet
        Toilet__c toilet = new Toilet__c();
        toilet.RecordTypeId = '012D0000000K64jIAC'; //Sanergy
        toilet.Name = 'NRB-20.1';
        toilet.Location__c = location.Id;
        toilet.Opportunity__c = opportunity.Id;
        toilet.Operational_Status__c = 'Open';
        toilet.Collection_Route__c = 'CLOSED';
        toilet.Current_Specific_Status__c = 'Open - New';
        INSERT toilet;  
        
        //Create Opportunity Maintenance Case
        Opportunity maintenanceOpportunity = new Opportunity();
        maintenanceOpportunity.RecordTypeId = opportunityMaintenanceCaseRecordType.Id;
        maintenanceOpportunity.Name = 'Maintenance Opportunity';
        maintenanceOpportunity.AccountId = account.Id;
        maintenanceOpportunity.CurrencyIsoCode = 'KES';
        maintenanceOpportunity.CloseDate = date.today();
        maintenanceOpportunity.StageName = 'Open';
        INSERT maintenanceOpportunity;
        
        //Create Case Category
        Ussd_Cate_C__c caseCategory = new Ussd_Cate_C__c();
        caseCategory.category_name__c = 'Category 1';
        caseCategory.USSD_Row_Number__c = 1;
        INSERT caseCategory;
        
        //Create Case Timeline
        Case_Timeliness__c caseTimeline = new Case_Timeliness__c();
        caseTimeline.Name = 'Case Timeline 1';
        caseTimeline.Case_Category__c = 'Maintenance';
        caseTimeline.Agreed_Upon_Time_For_Resolution__c = 3;
        caseTimeline.Priority_Level__c = 'Critical';
        caseTimeline.USSD_TEXT__c = 'CaseTime';
        caseTimeline.USSD_Case_Categories__c = caseCategory.Id;
        INSERT caseTimeline;
        
        //Create a Case
        Case myCase = new Case();
        myCase.Case_Type__c = caseTimeline.Id;
        myCase.Toilet__c = toilet.Id;
        myCase.Case_Opportunity__c = maintenanceOpportunity.Id;
        myCase.Date_First_Reported__c = date.today();
        myCase.Case_Root_Cause__c = 'Other';
        myCase.Description = 'Logged from Android';
        myCase.Comments__c = 'Testing 1';
        myCase.Status = 'Open';
        myCase.Case_Category__c = 'Maintenance';
        myCase.Priority = 'Medium';
        myCase.Subject = caseTimeline.USSD_TEXT__c;
        myCase.Photo_URL__c = 'http://csapp.saner.gy/casephotos_test/john.jpg';
        myCase.Photo_URL_2__c = 'http://csapp.saner.gy/casephotos_test/jane.jpg';
        myCase.Case_Reported_By__c = usr.Email; 
        INSERT myCase;
        
        //UPDATE Case
        myCase.Status = 'Closed';
        UPDATE myCase;
        
        //********Start testing REST_CaseCategories class********
        
        //Test HTTP GET
        RestRequest request1 = new RestRequest();
        request1.requestUri ='/services/apexrest/api/casecategory/' + caseCategory.Id;
        request1.httpMethod = 'GET';
        RestContext.request = request1; 
        REST_CaseCategories.getCaseCategory();
        
        //********Stop testing REST_CaseCategories class*********
        
        //********Start testing REST_CaseTimeline class********
        
        //Test HTTP GET
        RestRequest request2 = new RestRequest();
        request2.requestUri ='/services/apexrest/api/casecategory/' + caseCategory.Id + '/casetimeline/' + caseTimeline.Id;
        request2.httpMethod = 'GET';
        RestContext.request = request2; 
        REST_CaseTimeline.getCaseTimelineById();
                
        //********Stop testing REST_CaseTimeline class*********
        
        //********Start testing REST_CaseTimelines class********
        
        //Test HTTP GET
        RestRequest request3 = new RestRequest();
        request3.requestUri ='/services/apexrest/api/casecategory/' + caseCategory.Id + '/casetimelines/' + caseTimeline.Id;
        request3.httpMethod = 'GET';
        RestContext.request = request3; 
        REST_CaseTimelines.getCaseTimeliness();
                        
        //********Stop testing REST_CaseTimelines class*********        
        
        //********Start testing REST_Case class********

        //Test HTTP GET
        RestRequest request4 = new RestRequest();
        request4.requestUri ='/services/apexrest/api/casecategory/' + caseCategory.Id + '/casetimeline/' + caseTimeline.Id + '/case/' + myCase.Id;
        request4.httpMethod = 'GET';
        RestContext.request = request4; 
        REST_Case.getCaseById();

        //TEST HTTP POST
        RestRequest request5 = new RestRequest();
        request5.requestUri ='/services/apexrest/api/casecategory/' + caseCategory.Id + '/casetimeline/' + caseTimeline.Id + '/case/';
        request5.httpMethod = 'POST';
        RestContext.request = request5;
        
        REST_Case.AndroidCases cases = new REST_Case.AndroidCases(); 
        cases.caseTimelineId = caseTimeline.Id;
        cases.toiletId = toilet.Id;
        cases.dateReportedOnAndroid = date.today();
        cases.comments = 'testing testing 123';
        cases.image = 'johndoe.jpg';
        cases.image2 = 'janedoe.jpg';
        cases.reportedBy = 'johndoe@gmail.com';
        
        List<REST_Case.AndroidCases> caseList = new List<REST_Case.AndroidCases>();
        caseList.add(cases);        
        REST_Case.createCases(caseList);
        
        //********Stop testing REST_Case class********
        
        //********Start testing REST_Toilet_Cases class********
        
        //Test HTTP GET
        RestRequest request6 = new RestRequest();
        request6.requestUri ='/services/apexrest/api/toilet/' + toilet.Id + '/cases';
        request6.httpMethod = 'GET';
        RestContext.request = request6; 
        REST_Toilet_Cases.getReportedCasesByToiletId();        
        
        //********Stop testing REST_Toilet_Cases class********
    }
    
}