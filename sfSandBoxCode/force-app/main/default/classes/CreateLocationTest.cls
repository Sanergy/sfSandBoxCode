@isTest(SeeAllData=true)
public class CreateLocationTest {
    
    static testMethod void createLocationAndToilet(){
        
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev']; //run test as Dev
        System.runAs(u.get(0)) {
            /*Start testing the ConvertLeadToOpportunity class*/     
            
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
            
            // Create Sanergy Department - RecordType - Sanergy
            Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
            sanergyDept.Name = 'It department';
            sanergyDept.Company__c = 'Sanergy';
            sanergyDept.Department_Code__c = 'CORE';
            sanergyDept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
            sanergyDept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
            INSERT sanergyDept;
            
            System.debug('sanergyDept = ' + sanergyDept);          
            
            // Create Sanergy Department Unit        
            Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
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
            
            System.debug('sanergyDeptUnit = ' + sanergyDeptUnit);           
            
            // Create Employee Role
            Employee_Role__c empRole = new Employee_Role__c();      
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
            
            System.debug('Employee Role = ' + empRole);
            
            //Create Recruitment_Requisition__c
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
            
            System.debug('requisition = ' + requisition);
            
            // Create Employee
            Employee__c employee = new Employee__c();  
            employee.Name = 'Jane Doe';
            employee.Employee_First_Name__c = 'Jane';
            employee.Employee_Last_Name__c = 'Doe';
            employee.Job_Title__c = 'Associate';
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
            
            System.debug('employee = ' + employee);
            
            //Create a Contact
            Contact salesPerson = new Contact();
            salesPerson.FirstName = 'Jane';
            salesPerson.LastName = 'Doe';
            salesPerson.Sex__c = 'Female';
            salesPerson.Employee_Name__c = employee.Id;
            salesPerson.RecordTypeId = '012D0000000KEEfIAO';//Fresh Life Sales Associate
            salesPerson.AccountId = accounts.Id;
            salesPerson.OwnerId = usr.Id;
            INSERT salesPerson;
            
            System.debug('salesPerson = ' + salesPerson);        
            
            //Reset Too many SOQL governor limit error
            Test.startTest();
            
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
            lead.Franchise_Type__c = 'School';
            lead.Deposit_Paid__c = true;
            lead.FLR_Lease__c = true;
            lead.Sub_Area_Lookup__c = subArea.Id;
            lead.OwnerId = usr.Id;
            INSERT lead;        
            
            /*Stop testing the ConvertLeadToOpportunity class*/        
            
            /*Start testing the CreateLocation class*/
            
            //Get GLA
            c2g__codaGeneralLedgerAccount__c gla = [SELECT Id,Name,c2g__Type__c
                                                    FROM c2g__codaGeneralLedgerAccount__c
                                                    WHERE c2g__Type__c= 'Profit and Loss'
                                                    AND Name = '4110 - Sales - Toilets' 
                                                    LIMIT 1];        
            
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
            if(lead.Franchise_Type__c == 'Plot'){
                opportunity.Franchise_Type__c = 'Residential';
            }else if(lead.Franchise_Type__c == 'Commercial'){
                opportunity.Franchise_Type__c = 'Commercial';
            }else if(lead.Franchise_Type__c == 'School'){
                opportunity.Franchise_Type__c = 'School';
            }else if(lead.Franchise_Type__c == 'Institution'){
                opportunity.Franchise_Type__c = 'Institution';
            }
            
            INSERT opportunity;
            
            System.debug('opportunity = ' + opportunity);
            
            //UPDATE GR Approval section on the Opportunity
            opportunity.GR_Checklist_signed_by_AGRO__c = true;
            opportunity.Government_Signatures_Received__c = true ;
            opportunity.GR_Checklist_signed_Date__c = date.today();
            UPDATE opportunity;
            
            //Create a Product
            Product2 products = new Product2();
            products.Name = 'OpEx FLT Annual Renewal 2';
            products.IsActive = true;
            products.CurrencyIsoCode = 'KES';
            products.Family = 'Renewals';
            products.c2g__CODASalesRevenueAccount__c = gla.Id;//Sales Revenue Account
            products.c2g__CODASalesTaxStatus__c = 'Taxable';
            INSERT products;
            
            System.debug('products = ' + products);
            
            /*Create a Price Book
Pricebook2 priceBook = new Pricebook2();
priceBook.Name = 'Custom Price Book';
priceBook.IsActive = true;
INSERT priceBook;*/
            
            // Get standard price book ID.
            Id pricebookId = Test.getStandardPricebookId(); 
            
            //UPDATE the Opportunity        
            opportunity.Structure_finished_and_handed_over__c = true;
            opportunity.Painting_finished_and_Handed_over__c = true; 
            opportunity.Items_Delivered__c = true;
            opportunity.Pricebook2Id = pricebookId;
            UPDATE opportunity;         
            
            //Create a Price Book Entry
            PricebookEntry priceBookEntry1 = new PricebookEntry();
            priceBookEntry1.Product2Id = products.Id;
            priceBookEntry1.IsActive = true;
            priceBookEntry1.Pricebook2Id = pricebookId;
            priceBookEntry1.UnitPrice = 10000;
            INSERT priceBookEntry1;
            
            System.debug('priceBookEntry1 = ' + priceBookEntry1);
            
            //Create Opportunity Product
            OpportunityLineItem opportunityProduct = new OpportunityLineItem();
            opportunityProduct.OpportunityId = opportunity.Id;
            opportunityProduct.Product2Id = products.Id;
            opportunityProduct.PricebookEntryId = priceBookEntry1.Id;
            opportunityProduct.is_a_toilet__c = true;
            //opportunityProduct.Location__c = opportunity.Location__c;
            opportunityProduct.Quantity = 1;
            opportunityProduct.ServiceDate = date.today();
            opportunityProduct.UnitPrice = 8793.10;
            opportunityProduct.rstk__oppprod_weight__c = 0;
            INSERT opportunityProduct;
            
            System.debug('opportunityProduct = ' + opportunityProduct);
            
            System.debug('opportunity.Total_Number_of_Products__c : = ' + opportunity.Total_Number_of_Products__c );         
            
            //Instantiate ApexPages & CreateLocation classes
            ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(opportunity);        
            CreateLocation createALocation = new CreateLocation(controller3);
            
            //Test class methods
            createALocation.checkLocationExists = false;   
            createALocation.getToiletsPendingLaunch();        
            createALocation.activateDeactivateButton();
            createALocation.createNewLocation(); 
            createALocation.checkLocationExists = true;
            createALocation.numberOfFLTSToCreate = 1;
            createALocation.getAllToilets();
            createALocation.createNewToilet();      
            createALocation.getToiletsPendingLaunch();
            createALocation.toiletPendingLaunchNotification();        
            
            //Test if location already exists        
            // Create a Lead
            Lead lead3 = new Lead();
            lead3.FirstName = 'Anderson';
            lead3.LastName = 'Cooper';
            lead3.Status = 'Open';
            lead3.Company = 'Anderson Cooper';
            lead3.Primary_Salesperson__c = salesPerson.Id;
            lead3.Existing_FLO__c = true;
            lead3.Existing_Location__c = true;
            lead3.Location__c = location.Id;
            lead3.Phone = '123456789';
            lead3.FLTS_Requested__c = 1;
            lead3.Plot_Occupied__c = 'Yes';
            lead3.Plot_Completed__c = 'Yes';
            lead3.LeadSource = 'Hotspot';
            lead3.Franchise_Type__c = 'Institution';
            lead3.Deposit_Paid__c = true;
            lead3.FLR_Lease__c = true;
            lead3.Sub_Area_Lookup__c = subArea.Id;
            lead3.OwnerId = usr.Id;
            INSERT lead3;
            
            System.debug('lead3 = ' + lead3);          
            
            //Create Opportunity from Lead
            Opportunity opportunity2 = new Opportunity();
            opportunity2.StageName ='Pending Govt Approval';
            opportunity2.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management            
            opportunity2.AccountId = account.Id;
            opportunity2.Name = account.Name;
            opportunity2.Existing_FLO__c = lead3.Existing_FLO__c;
            opportunity2.Existing_Location__c = lead3.Existing_Location__c;
            opportunity2.Location__c = lead3.Location__c;
            opportunity2.No_of_FLTs__c = lead3.FLTS_Requested__c;
            opportunity2.Primary_Salesperson__c = lead3.Primary_Salesperson__c;
            opportunity2.LeadSource = lead3.LeadSource;
            opportunity2.CloseDate =  date.today() + 30;
            opportunity2.Area_Name__c = area.Id;
            opportunity2.Sub_Area_Lookup__c = subArea.Id;
            opportunity2.OwnerId = lead3.OwnerId; //lead.Primary_Salesperson__c
            if(lead3.Plot_Completed__c == 'Yes'){
                opportunity2.Plot_Complete__c = true;
            }
            if(lead3.Plot_Occupied__c == 'Yes'){
                opportunity2.Plot_Occupied__c = true;
            }
            if(lead3.Franchise_Type__c == 'Plot'){
                opportunity2.Franchise_Type__c = 'Residential';
            }else if(lead3.Franchise_Type__c == 'Commercial'){
                opportunity2.Franchise_Type__c = 'Commercial';
            }else if(lead3.Franchise_Type__c == 'School'){
                opportunity2.Franchise_Type__c = 'School';
            }else if(lead3.Franchise_Type__c == 'Institution'){
                opportunity2.Franchise_Type__c = 'Institution';
            }
            
            INSERT opportunity2;
            
            System.debug('opportunity2 = ' + opportunity2);          
            
            //Create Toilet
            Toilet__c toilet = new Toilet__c();
            toilet.RecordTypeId = '012D0000000K64jIAC'; //Sanergy
            toilet.Name = 'NRB-20.1';
            toilet.Location__c = opportunity2.Location__c;
            toilet.Opportunity__c = opportunity2.Id;
            toilet.Operational_Status__c = 'Pending Launch';
            toilet.Collection_Route__c = 'CLOSED';
            toilet.Current_Specific_Status__c = 'Pending Launch';
            INSERT toilet;
            
            System.debug('toilet = ' + toilet);           
            
            //Instantiate ApexPages & CreateLocation classes
            ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(opportunity2);        
            CreateLocation createALocation2 = new CreateLocation(controller4);
            //CreateLocation.Toilet toiletWrapperClass = new CreateLocation.Toilet(toilet);
            
            //Test class methods
            createALocation2.checkLocationExists = true;   
            createALocation2.getToiletsPendingLaunch();        
            createALocation2.activateDeactivateButton();
            createALocation2.getAllToilets();      
            createALocation2.getToiletsPendingLaunch();
            //toiletWrapperClass.selected = true;
            createALocation2.toiletPendingLaunchNotification();        
            /*Stop testing the CreateLocation class*/
            
            /*Start testing FLTLaunchTask trigger*/
            
            //Get FLT Launch RecordType
            RecordType fltLaunchRecordType = [SELECT Id,Name 
                                              FROM RecordType 
                                              WHERE Name ='FLT Launches' 
                                              LIMIT 1];
            
            //Create a task for Sales Associate
            Task salesAssociateTask = new Task();
            salesAssociateTask.RecordTypeId = fltLaunchRecordType.Id;//FLT Launches
            salesAssociateTask.OwnerId = opportunity2.OwnerId;//Task assigned to who
            salesAssociateTask.Subject = toilet.Name + ' is ' + toilet.Operational_Status__c;
            salesAssociateTask.Goals__c = 'Launch ' + toilet.Name;
            salesAssociateTask.WhatId = toilet.Id;
            salesAssociateTask.Related_To_Text__c = toilet.Name;
            salesAssociateTask.Opportunity__c = opportunity2.Id;
            salesAssociateTask.ActivityDate = date.today(); //Due Date
            salesAssociateTask.Description = toilet.Name + ' is ' + toilet.Operational_Status__c;//	Comments
            salesAssociateTask.Status  = 'Not Started';
            salesAssociateTask.Priority = 'Normal';
            salesAssociateTask.Task_Source__c = 'Visualforce Page';
            INSERT salesAssociateTask;  
            
            System.debug('Create salesAssociateTask ' + salesAssociateTask);        
            
            
            //Assumption: Sales Associate said 'NO' follow up is required
            salesAssociateTask.Follow_Up__c = 'No';
            UPDATE salesAssociateTask;
            
            //Assumption: Sales Associate said 'YES' follow up is required
            salesAssociateTask.Follow_Up__c = 'Yes';
            UPDATE salesAssociateTask; 
            
            //Create a task for Christell/Florence/Polycarp
            Task launchFLTTask = new Task();
            launchFLTTask.RecordTypeId = fltLaunchRecordType.Id;//FLT Launches
            launchFLTTask.OwnerId = opportunity2.OwnerId;//Task assigned to who
            launchFLTTask.Subject = toilet.Name + ' is ' + toilet.Operational_Status__c;
            launchFLTTask.Goals__c = 'Launch ' + toilet.Name;
            launchFLTTask.WhatId = toilet.Id;
            launchFLTTask.Related_To_Text__c = toilet.Name;
            launchFLTTask.Opportunity__c = opportunity2.Id;
            launchFLTTask.ActivityDate = date.today(); //Due Date
            launchFLTTask.Description = toilet.Name + ' is ' + toilet.Operational_Status__c;//	Comments
            launchFLTTask.Status  = 'Not Started';
            launchFLTTask.Priority = 'Normal';
            launchFLTTask.Task_Source__c = 'Sales Associate';
            INSERT launchFLTTask;
            
            System.debug('Create launchFLTTask ' + launchFLTTask);
            Test.stopTest();
            //Assumption: Sales Associate said 'NO' follow up is required
            launchFLTTask.Follow_Up__c = 'No';
            UPDATE launchFLTTask;        
            //Test.stopTest();
            /*Stop testing FLTLaunchTask trigger*/           
            
        }
    }
}