@isTest (SeeAllData=true)
private class Test_Toilet_Generation {
    
    @isTest
    private static void Test_Generation() {
        
        // Get dim1                              
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];       
        
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
        area.Last_Location_No__c = 20;        
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
        location.Area_Name__c = area.Id;
        INSERT location;
        
        System.debug('location = ' + location);      
        
        Account account1 = new Account();
        account1.Name='John Doe';
        account1.CurrencyIsoCode = 'KES';
        INSERT account1;
        
        System.debug('account1 = ' + account1);          
        
        //Create a Contact
        Contact salesPerson = new Contact();
        salesPerson.FirstName = 'Jane';
        salesPerson.LastName = 'Doe';
        salesPerson.Sex__c = 'Female';
        salesPerson.AccountId = account1.Id;
        INSERT salesPerson;
        
        System.debug('salesPerson = ' + salesPerson);
        
        //Create Toilet Sale Opportunity 
        Opportunity toiletSaleOpportunity = new Opportunity();
        toiletSaleOpportunity.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management 
        toiletSaleOpportunity.StageName ='Sale Open';          
        toiletSaleOpportunity.AccountId = account1.Id;
        toiletSaleOpportunity.Name = account1.Name;
        toiletSaleOpportunity.Primary_Salesperson__c = salesPerson.Id;
        toiletSaleOpportunity.CloseDate =  date.today() + 30;
        toiletSaleOpportunity.Location__c = location.Id;
        toiletSaleOpportunity.Sub_Area_Lookup__c = subArea.Id;
        INSERT toiletSaleOpportunity;
        
        System.debug('toiletSaleOpportunity = ' + toiletSaleOpportunity);        
        
        //Create Toilet
        Toilet__c toilet = new Toilet__c();
        toilet.RecordTypeId = '012D0000000K64jIAC'; //Sanergy
        toilet.Name = 'NRB-20.1';
        toilet.Location__c = toiletSaleOpportunity.Location__c;
        toilet.Opportunity__c = toiletSaleOpportunity.Id;
        toilet.Operational_Status__c = 'Open';
        toilet.Collection_Route__c = 'CLOSED';
        toilet.Current_Specific_Status__c = 'Open - New';
        INSERT toilet;
        
        System.debug('toilet = ' + toilet);
        
        Product2 prod = new Product2(Name = 'Sanitation Center');
        insert prod;
        
        sObject s = [select ID from Pricebook2 where IsStandard = TRUE];
        
        PricebookEntry pbe = new PricebookEntry (Pricebook2ID = s.ID, UnitPrice = 45000, IsActive = true, Product2ID = prod.ID);
        insert pbe;
        
        toiletSaleOpportunity.Actual_Launch_Date__c = System.today();
        toiletSaleOpportunity.StageName = 'FLO Launched';
        try {
            update toiletSaleOpportunity;
        }
        catch(DmlException ex){
        }
    }
}