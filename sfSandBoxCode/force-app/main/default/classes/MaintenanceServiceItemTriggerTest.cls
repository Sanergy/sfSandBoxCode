@isTest(seeAllData = true)
public class MaintenanceServiceItemTriggerTest {
    static testMethod void testMaintenanceServiceItemTriggerTest(){
     /*   
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true LIMIT 2];      
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 1];
        
        List<FFA_Config_Object__c> department2 = [SELECT Id,Name,Type__c,isActive__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        
        //create gla
        FFA_Config_Object__c gla3 = [SELECT Id,Name,Type__c 
                                          FROM FFA_Config_Object__c
                                          WHERE NAME LIKE '%6720%'
                                          AND  Type__c = 'gla' 
                                          LIMIT 1];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE Name ='Fresh Life Initiative Limited' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
        //UOM
        Inventory_UoM__c uom = new Inventory_UoM__c(
            Uom_Code__c = 'Pack',
            Name = 'n',
            Description__c = 'Pack - 70kg'
        );
        insert uom;
        
        //Currency
        Currency_Config__c curr = new Currency_Config__c(
            Currency_Name__c = 'Kenyan Shilling',
            Name = 'KES',
            Value__c = 1,
            start__c = date.today(),
            Current__c = true
        );
        insert curr;
        
        Inventory_Item_Group__c comCode = new Inventory_Item_Group__c(
            Name = 'name',
            Dimension_1__c = department.get(0).Id,
            Description__c = 'Raw',
            Dimension_2__c = dim2.get(0).Id,
            Dimension_3__c = dim3.get(0).Id,
            Dimension_4__c = dim4.get(0).Id,
            Commodity_Code__c = 'Raw'
        );
        insert comCode;
        
        Inventory_Location__c site = new Inventory_Location__c(
            Name = 'Mukuru 2345'
        );
        insert site;
        
        Inventory_item__c invItem = new Inventory_item__c(
            Name = 'item',
            Item_Number__c = '123456',
            Item_Description__c = 'Item Description',
            Item_Type__c = 'Stock',
            Item_Company__c = company.get(0).Id,
            Inventory_UoM__c = uom.Id,
            Currency_Config__c = curr.Id,
            Responsible_Department__c = department.get(0).Id,
            Policy_Quantity__c = 10,
            Minimum_Quantity__c = 2,
            Item_Group__c = comCode.Id,
            unit_cost__c = 100,
            Default_Site__c = site.Id,
            Default_Location__c = '1',
            Default_Lot__c = '1',
            Planning_Policy__c = 'No MRP Planning'
        );
        
        insert invItem;
        
        //Fetch Existing Account		
        List<Account> acc =[SELECT Id,
                            Name,
                            CurrencyIsoCode
                            FROM Account
                            WHERE Name='Tuffsteel Ltd'
                            Limit 1
                           ];
        
        // Create a Contract            
        Contract contract = new Contract(
            AccountId=acc.get(0).Id, 
            Status = 'Draft',
            StartDate=date.today(),
            ContractTerm=1, CurrencyIsoCode='KES',
            Payment_Terms__c='7 Days',
            Primary_Contract__c=true
        );
        INSERT contract;
        
        //Get Purchase Order Item
        Purchase_Order_Item__c poI = new Purchase_Order_Item__c(
            Name = 'Item',
            Item_Description__c = 'Item Desc',
            Currency__c = curr.id,
            Inventory_Item__c = invItem.Id,
            Purchase_UoM__c = uom.Id,
            UOM_Conversion_Factor__c = 10,
            Contract_Number__c = contract.Id,
            Vendor__c = contract.AccountId,
            Status__c='Active'
        );
        insert poI;
        
        //create service item
        Asset_Service_Item__c serveItem = new Asset_Service_Item__c();
        serveItem.Inventory_Item__c = invItem.Id;
        serveItem.Purchase_Order_Item__c = poI.Id;
        serveItem.vendor__c = acc.get(0).Id;
        
        insert serveItem;
        
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
        
        //insert user
        User usr = new User();
        usr.LastName = 'Daver';
        usr.Alias = 'Doper';
        usr.Email = 'usd.sssr@saner.gy';
        usr.Username = 'wvgtxx@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.Team_Lead__c = '005D0000004ZrkJ';
        usr.LocaleSidKey = 'en_US';
        INSERT usr;
        
        //
        Recruitment_Requisition__c requisition = new Recruitment_Requisition__c();
        requisition.Name = 'Business Analyst';
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
        requisition.Requesting_Department__c = department2.get(0).Id;
        INSERT requisition;
       
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
        emp.HR_Employee_ID__c = '1519';
        emp.HR_Unique_Record_ID__c = '40872';
        
        INSERT emp;      
        
 
       
        Asset_Maintenance_Schedule__c sched = new Asset_Maintenance_Schedule__c();
        sched.Name = 'Test Name';
        
        Insert sched;
        
        Sanergy_Asset__c sanAsset = new Sanergy_Asset__c();sanAsset.Asset_Name__c = 'Laptop'; 
        sanAsset.Manufacturer__c = 'Dell';
        sanAsset.Make__c = 'Dell';
        sanAsset.Model__c = 'Latitude e6430';
        sanAsset.Operating_System__c = 'Ubuntu';
        sanAsset.Active__c = true;
        
        insert sanAsset;
        
        sanAsset.Manufacturer__c = 'HP';
        sanAsset.Model__c = 'PRO BOOK';
        update sanAsset;
        
        Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
        usage.Sanergy_Asset__c = sanAsset.Id;
        usage.Current_Reading__c = true;
        usage.Actual_Units__c = 10;
        usage.Date__c = date.today()-3;
        
        insert usage;
        
       List<RecordType> record = [SELECT id,Name from RecordType where Name ='Open'];
		System.debug('RECORD TYPE: ' + record);
        
        List<RecordType> record2 = [SELECT id,Name from RecordType where Name ='Completed'];
		System.debug('RECORD TYPE: ' + record2);
        
        Asset_Maintenance_Task__c maintTask2 = new Asset_Maintenance_Task__c();
        maintTask2.Maintenance_Type__c = 'BM(Break Down Maintenance)';
        maintTask2.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask2.RecordTypeId = record2.get(0).id;
        maintTask2.Status__c = 'Completed';
        maintTask2.Clone_Service_Items__c = false;
        maintTask2.GLA__c = gla3.Id;
        maintTask2.Assigned_To__c = emp.Id;
        maintTask2.Sanergy_Asset__c = sanAsset.Id;
        maintTask2.Service_Date__c = date.today()+2;
        maintTask2.Proposed_Service_Date__c = date.today()+7;
        maintTask2.Proposed_Reading__c = 200.35;

        insert maintTask2;
        
        //insert Maintenance_Service_Items__c
        Maintenance_Service_Items__c Maintenance = new Maintenance_Service_Items__c();
        Maintenance.Asset_Maintenance_Task__c = maintTask2.id ;
        Maintenance.Asset_Service_Item__c = serveItem.id;
        
        insert Maintenance;
*/        
    }
    
}