@isTest(seeAllData=true)
public class BasicFLTItemsTest {
    
    static testMethod void CreateBasicFLTItems(){
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT Id,Name 
                                             FROM FFA_Config_Object__c 
                                             WHERE type__c = 'company' 
                                             AND isActive__c = true
                                             AND Name = 'Sanergy Limited'];        
        
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
        salesPerson.FirstName = 'John';
        salesPerson.LastName = 'Doe';
        salesPerson.Sex__c = 'Male';
        salesPerson.AccountId = account1.Id;
        INSERT salesPerson;
        
        System.debug('salesPerson = ' + salesPerson);

        //Create Toilet Sale Opportunity 
        Opportunity toiletSaleOpportunity = new Opportunity();
        toiletSaleOpportunity.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management 
        toiletSaleOpportunity.StageName ='Pending Govt Approval';          
        toiletSaleOpportunity.AccountId = account1.Id;
        toiletSaleOpportunity.Name = account1.Name;
        toiletSaleOpportunity.Primary_Salesperson__c = salesPerson.Id;
        toiletSaleOpportunity.CloseDate =  date.today() + 30;
        toiletSaleOpportunity.Location__c = location.Id;
        toiletSaleOpportunity.Sub_Area_Lookup__c = subArea.Id;
        toiletSaleOpportunity.FLTs_Approved__c =  1;
        toiletSaleOpportunity.Upstructures_Required__c = 1;
        toiletSaleOpportunity.Upstructure_required__c = true;
        INSERT toiletSaleOpportunity;
        
        System.debug('toiletSaleOpportunity = ' + toiletSaleOpportunity);
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        System.debug('CREATE CURRENCY CONFIG: ' + cc);        
        
        // Create Inventory_UoM__c
        Inventory_UoM__c iUom = new Inventory_UoM__c();
        //iUom.Name = 'Dummy Inventory UOM 1';
        iUom.Description__c = 'Dummy Inventory UOM';
        iUom.Uom_Code__c = '101';
        iUom.CurrencyIsoCode = 'KES';
        INSERT iUom;
        
        System.debug('CREATE INVENTORY UOM: ' + iUom);
        
        // Create Inventory_Item_Group__c
        Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
        invItemGroup.Name = 'New Inventory Item Group';
        invItemGroup.Commodity_Code__c = 'New Commodity code';
        invItemGroup.Description__c = 'Brief description';            
        INSERT invItemGroup;
        
        System.debug('CREATE INVENTORY GROUP: ' + invItemGroup);
        
        // Create Inventory Location
        Inventory_Location__c site = new Inventory_Location__c();
        site.Name = 'Mukuru';
        INSERT site;
        
        System.debug('CREATE INVENTORY LOCATION: ' + site);        
        
        // Create Inventory_Item__c
        Inventory_Item__c invItem = new Inventory_Item__c();
        invItem.Name='Door Poster 1';
        invItem.Item_Number__c = 'NS92345';
        invItem.Item_Description__c = 'A1 Door Poster';
        invItem.Item_Type__c = 'Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Inventory_UoM__c = iUom.Id;
        invItem.Item_Group__c = invItemGroup.Id;
        invItem.Default_Site__c = site.Id;
        invItem.Default_Location__c = 'Mukuru';
        invItem.Default_Lot__c = '3';
        invItem.Currency_Config__c = cc.Id;
        invItem.unit_cost__c = 20;
        invItem.Policy_Quantity__c = 100;
        invItem.Minimum_Quantity__c = 50;
        invItem.Batch_Item__c = true;
        INSERT invItem;     
        
        System.debug('CREATE INVENTORY ITEM: ' + invItem);
        
        //Create Opportunity Items
        Opportunity_Item__c opportunityItem = new Opportunity_Item__c();
        opportunityItem.Structure_Version__c = 'Basic FLT';
        opportunityItem.Grouping__c = 'Basic FLT Package';
        opportunityItem.Default_Quantity__c = 12;
        opportunityItem.Deactivate_Item__c = false;
        opportunityItem.Shared_Item__c = true;
        opportunityItem.Description__c = 'A3 Door Poster';
        opportunityItem.InventoryItem__c = invItem.Id;
        INSERT opportunityItem;
        
        System.debug('opportunityItem = ' + opportunityItem);

        //Create Opportunity WO Item
        Opportunity_WO_Item__c opportunityWOItem = new Opportunity_WO_Item__c();
        opportunityWOItem.Opportunity__c = toiletSaleOpportunity.Id;
        opportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
        opportunityWOItem.Quantity__c = opportunityItem.Default_Quantity__c;        
        INSERT opportunityWOItem;
        
        System.debug('CREATE OPPORTUNITY WO ITEM : ' + opportunityWOItem);        
        
        //Create Opportunity Items
        Opportunity_Item__c opportunityItem1 = new Opportunity_Item__c();
        opportunityItem1.Structure_Version__c = 'Basic FLT';
        opportunityItem1.Grouping__c = 'Basic FLT Package';
        opportunityItem1.Default_Quantity__c = 20;
        opportunityItem1.Deactivate_Item__c = false;
        opportunityItem1.Shared_Item__c = false;
        opportunityItem1.Description__c = 'A1 Door Poster';
        opportunityItem1.InventoryItem__c = invItem.Id;
        INSERT opportunityItem1;
        
        System.debug('opportunityItem1 = ' + opportunityItem1);

        //Create Opportunity WO Item
        Opportunity_WO_Item__c opportunityWOItem1 = new Opportunity_WO_Item__c();
        opportunityWOItem1.Opportunity__c = toiletSaleOpportunity.Id;
        opportunityWOItem1.Opportunity_Item__c = opportunityItem1.Id;
        opportunityWOItem1.Quantity__c = opportunityItem1.Default_Quantity__c;        
        INSERT opportunityWOItem1;
        
        System.debug('CREATE OPPORTUNITY WO ITEM 1: ' + opportunityWOItem1);

        //Create Opportunity Items
        Opportunity_Item__c opportunityItem2 = new Opportunity_Item__c();
        opportunityItem2.Structure_Version__c = 'Basic FLT';
        opportunityItem2.Grouping__c = 'Basic FLT Package - Upstructure';
        opportunityItem2.Default_Quantity__c = 10;
        opportunityItem2.Deactivate_Item__c = false;
        opportunityItem2.Description__c = 'A1 Door Poster 2';
        opportunityItem2.InventoryItem__c = invItem.Id;
        INSERT opportunityItem2;
        
        System.debug('opportunityItem2 = ' + opportunityItem2);
        
        //Create Opportunity WO Item
        Opportunity_WO_Item__c opportunityWOItem2 = new Opportunity_WO_Item__c();
        opportunityWOItem2.Opportunity__c = toiletSaleOpportunity.Id;
        opportunityWOItem2.Opportunity_Item__c = opportunityItem2.Id;
        opportunityWOItem2.Quantity__c = opportunityItem2.Default_Quantity__c;        
        INSERT opportunityWOItem2;
        
        System.debug('CREATE OPPORTUNITY WO ITEM 2: ' + opportunityWOItem2);        
        
        //Create Opportunity Items
        Opportunity_Item__c opportunityItem3 = new Opportunity_Item__c();
        opportunityItem3.Structure_Version__c = 'V3';
        opportunityItem3.Grouping__c = 'Structure Package';
        opportunityItem3.Default_Quantity__c = 20;
        opportunityItem3.Deactivate_Item__c = false;
        opportunityItem3.Description__c = 'A1 Door Poster 2';
        opportunityItem3.InventoryItem__c = invItem.Id;
        INSERT opportunityItem3;
        
        System.debug('opportunityItem3 = ' + opportunityItem3);
        
        //Create Opportunity WO Item
        Opportunity_WO_Item__c opportunityWOItem3 = new Opportunity_WO_Item__c();
        opportunityWOItem3.Opportunity__c = toiletSaleOpportunity.Id;
        opportunityWOItem3.Opportunity_Item__c = opportunityItem3.Id;
        opportunityWOItem3.Quantity__c = opportunityItem3.Default_Quantity__c;        
        INSERT opportunityWOItem3;
        
        System.debug('CREATE OPPORTUNITY WO ITEM 3: ' + opportunityWOItem3);         

        //Create Opportunity Items
        Opportunity_Item__c opportunityItem4 = new Opportunity_Item__c();
        opportunityItem4.Structure_Version__c = 'V3';
        opportunityItem4.Grouping__c = 'Upstructure Package';
        opportunityItem4.Default_Quantity__c = 20;
        opportunityItem4.Deactivate_Item__c = false;
        opportunityItem4.Description__c = 'A1 Door Poster 2';
        opportunityItem4.InventoryItem__c = invItem.Id;
        INSERT opportunityItem4;
        
        System.debug('opportunityItem4 = ' + opportunityItem4);
        
        //Create Opportunity Items
        Opportunity_Item__c opportunityItem5 = new Opportunity_Item__c();
        opportunityItem5.Grouping__c = 'Structure Package';
        opportunityItem5.Hybrid__c = true;
        opportunityItem5.Default_Quantity__c = 20;
        opportunityItem5.Deactivate_Item__c = false;
        opportunityItem5.Description__c = 'A1 Door Poster';
        opportunityItem5.InventoryItem__c = invItem.Id;
        INSERT opportunityItem5;
        
        System.debug('opportunityItem5 = ' + opportunityItem5);
        
        //Test the Class
        ApexPages.Standardcontroller standardController = new ApexPages.Standardcontroller(toiletSaleOpportunity);
        AddOppItemsController opportunityController = new AddOppItemsController(standardController);		
        opportunityController.fltVersion='Basic FLT';
        opportunityController.createItems();
        
        //Update Opportunity
        toiletSaleOpportunity.Structure_Items_Added__c = false;
        UPDATE toiletSaleOpportunity;
        
        opportunityController.fltVersion = 'V3';        
        opportunityController.createItems();
        
        //Update Opportunity
        toiletSaleOpportunity.Structure_Items_Added__c = false;
        UPDATE toiletSaleOpportunity;        
        
        opportunityController.fltVersion='V2-V3 Hybrid';
        opportunityController.createItems();
        
        //This test checks if the Structure items have already been added
        opportunityController.createItems();
    }
}