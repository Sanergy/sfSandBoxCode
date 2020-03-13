@isTest(seeAllData = true)
public class RecurringServiceTest {
    static testMethod void RecurringServiceTest(){
        
        //Get dim1                              
        FFA_Config_Object__c department = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim1' 
                                           AND Name = 'Information Technology'
                                           AND isActive__c = true 
                                           LIMIT 1];
        System.debug('' + department);
        
        //Get dim2                                    
        FFA_Config_Object__c dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim2' 
                                     AND isActive__c = true 
                                     LIMIT 1];
        
        //Get dim3                                   
        FFA_Config_Object__c dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim3' 
                                     AND isActive__c = true 
                                     LIMIT 1];
        
        //Get dim4                                     
        FFA_Config_Object__c grant = [SELECT Id,Name,Type__c,isActive__c 
                                      FROM FFA_Config_Object__c 
                                      WHERE Type__c = 'dim4' 
                                      AND isActive__c = true 
                                      LIMIT 1];
        
        //Get gla
        FFA_Config_Object__c gla= [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                   WHERE Type__c = 'gla' 
                                   AND isActive__c = true 
                                   AND Name = '6430 - Government Fees & Levies' 
                                   LIMIT 1];
        
        //Get Company
        FFA_Config_Object__c sanergy= [SELECT Id,Name 
                                       FROM FFA_Config_Object__c 
                                       WHERE type__c = 'company' 
                                       AND isActive__c = true
                                       AND Name = 'Sanergy Limited'
                                       LIMIT 1];
        
        //Get Company
        FFA_Config_Object__c freshLife= [SELECT Id,Name 
                                         FROM FFA_Config_Object__c 
                                         WHERE type__c = 'company' 
                                         AND isActive__c = true
                                         AND Name = 'Fresh Life Initiative Limited'
                                         LIMIT 1];
        
        //Get RecordType Id
        RecordType vendor = [SELECT Id 
                             FROM RecordType 
                             WHERE Name = 'Sanergy Vendor' 
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
        Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
        sanergyDeptUnit.Name = 'Information Technology System';
        sanergyDeptUnit.Unit_Code__c = 'CORE';
        sanergyDeptUnit.Sanergy_Department__c = dept.Id;
        sanergyDeptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        sanergyDeptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        sanergyDeptUnit.Talent_Partner__c = '005D0000003Ykhb';
        sanergyDeptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        INSERT sanergyDeptUnit;  
        
        //Insert Employee Role 
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
        
        system.debug('Employee Role: ' + empRole);
        
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
        requisition.Requesting_Department__c = department.Id;
        INSERT requisition;
        
        System.debug('Recruitment Requisition: ' + requisition);  
        
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
        
        //Create Employee
        Employee__c employee = new Employee__c();
        employee.Name = 'Jason';
        employee.Employee_First_Name__c = 'Jason';
        employee.Employee_Last_Name__c = 'Statham';
        employee.Recruitment_Requisition__c = requisition.Id;
        employee.Primary_Phone__c = '0712345678';
        employee.Employment_Start_Date__c = date.today()+50;
        employee.Employee_Active__c = true;
        employee.Employment_Status__c = 'Permanent';
        employee.Employee_Role__c = empRole.Id;
        employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employee.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee.Talent_Partner__c = 'aAsD0000000GmgM';
        employee.Work_Email__c = 'abcd@gmail.com';
        employee.Employee_SF_Account__c = usr.Id;
        INSERT employee;
        
        System.debug('Employee: ' + employee);       
    
        //Create Account       
        Account accounts = new Account();
        accounts.Name = 'Liquid Telcom';
        accounts.CurrencyIsoCode = 'KES';
        accounts.RecordTypeId = vendor.Id;
        INSERT accounts;
        
        // Create Contract
        Contract contract = new Contract();
        contract.AccountId = accounts.Id;
        contract.Type_of_Contract__c = 'Master Service Agreement';
        contract.Status = 'Draft';
        contract.StartDate = date.today();
        contract.ContractTerm = 12;
        contract.Primary_Contract__c=true;        
        contract.Payment_Terms__c = '30 Days';
        contract.Contract_Summary__c = 'summary of contract';
        INSERT contract;        
        
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
        
        Inventory_Location__c inventorySite = new Inventory_Location__c();
        inventorySite.Name = 'Mukuru 2345';
        insert inventorySite;        

        // Create Inventory_UoM__c
        Inventory_UoM__c inventoryItemUOM = new Inventory_UoM__c();
        //inventoryItemUOM.Name = 'Dummy Inventory UOM 1';
        inventoryItemUOM.Description__c = 'Dummy Inventory UOM';
        inventoryItemUOM.Uom_Code__c = '101';
        inventoryItemUOM.CurrencyIsoCode = 'KES';
        INSERT inventoryItemUOM;
        
        System.debug('CREATE INVENTORY UOM: ' + inventoryItemUOM);      
        
        // Create Inventory_inventoryItem_Group__c
        Inventory_Item_Group__c invinventoryItemGroup = new Inventory_Item_Group__c();
        invinventoryItemGroup.Name = 'New Inventory inventoryItem Group';
        invinventoryItemGroup.Commodity_Code__c = 'New Purchase';
        invinventoryItemGroup.Description__c = 'Brief description';
        invinventoryItemGroup.Dimension_1__c = department.Id;
        invinventoryItemGroup.Dimension_2__c = dim2.Id;
        invinventoryItemGroup.Dimension_3__c = dim3.Id;
        invinventoryItemGroup.Dimension_4__c = grant.Id;
        INSERT invinventoryItemGroup;
        
        System.debug('CREATE INVENTORY GROUP: ' + invinventoryItemGroup);
        
        Group_Details__c groupDetails = new Group_Details__c();
        groupDetails.Inventory_Item_Group__c = invinventoryItemGroup.Id;
        groupDetails.Credit_Debit__c = 'Debit'; 
        groupDetails.Transaction_ID__c = 'PORCPT';
        groupDetails.Is_GL_Account__c = true;
        groupDetails.Config_Account__c = gla.Id;        
        INSERT groupDetails; 
        
        System.debug('CREATE GROUP DETAILS: ' + groupDetails);        

        Inventory_Item__c inventoryItemSLK = new Inventory_Item__c();
        inventoryItemSLK.Item_Description__c = 'Internet';
        inventoryItemSLK.Currency_Config__c = cc.Id;
        inventoryItemSLK.Name = 'Sanergy Internet';
        inventoryItemSLK.Item_Number__c = '123456';
        inventoryItemSLK.Responsible_Department__c = department.Id;
        inventoryItemSLK.Policy_Quantity__c = 10;
        inventoryItemSLK.Minimum_Quantity__c = 2;
        inventoryItemSLK.Item_Group__c = invinventoryItemGroup.Id;
        inventoryItemSLK.Inventory_UoM__c = inventoryItemUOM.Id;
        inventoryItemSLK.unit_cost__c = 100;
        inventoryItemSLK.Item_Company__c = sanergy.Id;
        inventoryItemSLK.Default_Site__c = inventorySite.Id;
        inventoryItemSLK.Default_Location__c = '1';
        inventoryItemSLK.Default_Lot__c = '1';        
        INSERT inventoryItemSLK;        
        
        System.debug('CREATE INVENTORY ITEM: ' + inventoryItemSLK);
        
        Inventory_Item__c inventoryItemFLI = new Inventory_Item__c();
        inventoryItemFLI.Item_Description__c = 'Internet';
        inventoryItemFLI.Currency_Config__c = cc.Id;
        inventoryItemFLI.Name = 'Fresh Life Internet';
        inventoryItemFLI.Item_Number__c = '1234567';
        inventoryItemFLI.Responsible_Department__c = department.Id;
        inventoryItemFLI.Policy_Quantity__c = 10;
        inventoryItemFLI.Minimum_Quantity__c = 2;
        inventoryItemFLI.Item_Group__c = invinventoryItemGroup.Id;
        inventoryItemFLI.Inventory_UoM__c = inventoryItemUOM.Id;
        inventoryItemFLI.unit_cost__c = 100;
        inventoryItemFLI.Item_Company__c = freshLife.Id;
        inventoryItemFLI.Default_Site__c = inventorySite.Id;
        inventoryItemFLI.Default_Location__c = '1';
        inventoryItemFLI.Default_Lot__c = '1';        
        INSERT inventoryItemFLI;        
        
        System.debug('CREATE INVENTORY ITEM: ' + inventoryItemFLI);         
        
        //Create Inventory Item Location
        Inventory_Item_Location__c inventoryItemLocationSLK  = new Inventory_Item_Location__c();
        inventoryItemLocationSLK.Location_Name__c = '001';
        inventoryItemLocationSLK.Inventory_Item__c = inventoryItemSLK.Id;
        inventoryItemLocationSLK.Location__c = inventorySite.Id;
        inventoryItemLocationSLK.Max_Location_Quantity__c = 100000;
        INSERT inventoryItemLocationSLK;
        
        System.debug('CREATE INVENTORY ITEM LOCATION: ' + inventoryItemLocationSLK);
        
        //Create Inventory Item Location
        Inventory_Item_Location__c inventoryItemLocationFLI  = new Inventory_Item_Location__c();
        inventoryItemLocationFLI.Location_Name__c = '001';
        inventoryItemLocationFLI.Inventory_Item__c = inventoryItemFLI.Id;
        inventoryItemLocationFLI.Location__c = inventorySite.Id;
        inventoryItemLocationFLI.Max_Location_Quantity__c = 100000;
        INSERT inventoryItemLocationFLI;
        
        System.debug('CREATE INVENTORY ITEM LOCATION: ' + inventoryItemLocationFLI);        
        
        //Create Item Location Lot
        Item_Location_Lot__c itemLocationLotSLK = new Item_Location_Lot__c();
        itemLocationLotSLK.Item_Location__c = inventoryItemLocationSLK.Id;
        itemLocationLotSLK.Lot_Name__c  = '001';
        itemLocationLotSLK.Quantity__c = 100000;
        INSERT itemLocationLotSLK;
        
        System.debug('CREATE ITEM LOCATION LOT: ' + itemLocationLotSLK);
        
        //Create Item Location Lot
        Item_Location_Lot__c itemLocationLotFLI = new Item_Location_Lot__c();
        itemLocationLotFLI.Item_Location__c = inventoryItemLocationFLI.Id;
        itemLocationLotFLI.Lot_Name__c  = '001';
        itemLocationLotFLI.Quantity__c = 100000;
        INSERT itemLocationLotFLI;
     
        
        //Get Purchase Order Item
        Purchase_Order_Item__c poItemSLK = new Purchase_Order_Item__c();
        poItemSLK.Name = 'Sanergy Item';
        poItemSLK.Item_Description__c = 'Item Desc';
        poItemSLK.Currency__c = cc.Id;
        poItemSLK.Inventory_Item__c = inventoryItemSLK.Id;
        poItemSLK.Purchase_UoM__c = inventoryItemUOM.Id;
        poItemSLK.UOM_Conversion_Factor__c = 1;
        poItemSLK.Contract_Number__c = contract.Id;
        poItemSLK.Vendor__c = contract.AccountId;
        poItemSLK.Primary_Vendor__c = true;
        poItemSLK.Status__c='Active';
        poItemSLK.Approved__c = true;
        INSERT poItemSLK;


        //Get Purchase Order Item
        Purchase_Order_Item__c poItemFLI = new Purchase_Order_Item__c();
        poItemFLI.Name = 'Fresh Life Item';
        poItemFLI.Item_Description__c = 'Item Desc';
        poItemFLI.Currency__c = cc.Id;
        poItemFLI.Inventory_Item__c = inventoryItemFLI.Id;
        poItemFLI.Purchase_UoM__c = inventoryItemUOM.Id;
        poItemFLI.UOM_Conversion_Factor__c = 1;
        poItemFLI.Contract_Number__c = contract.Id;
        poItemFLI.Vendor__c = contract.AccountId;
        poItemFLI.Primary_Vendor__c = true;        
        poItemFLI.Status__c='Active';
        poItemFLI.Approved__c = true;
        INSERT poItemFLI; 
        
        
        // Create a Shared Recurring Service (Fixed)
        Recurring_Service__c fixedSharedRecurringService = new Recurring_Service__c();
        fixedSharedRecurringService.Requestor__c = employee.Id;
        fixedSharedRecurringService.Service_Name__c = 'Internet';
        fixedSharedRecurringService.Service_Type__c = 'Post Pay';
        fixedSharedRecurringService.Shared_service__c = true;
        fixedSharedRecurringService.Requesting_Department__c = department.Id;
        fixedSharedRecurringService.Maintenance_Department__c = department.Id;
        fixedSharedRecurringService.Vendor__c = accounts.Id;
        fixedSharedRecurringService.Start_Date__c = date.today();
        fixedSharedRecurringService.End_Date__c = date.today() + 365;
        fixedSharedRecurringService.Billing_Frequency__c = 'Monthly';
        fixedSharedRecurringService.Billing_Type__c = 'Fixed value';
        fixedSharedRecurringService.Billing_Units__c = 18;
        fixedSharedRecurringService.Consumption_Units__c = 'Fixed value';
        fixedSharedRecurringService.Cost_Per_Unit__c = 1000;
        fixedSharedRecurringService.FLI_percentage_value__c = 40;
        fixedSharedRecurringService.Purchase_Order_Item_FLI__c = poItemFLI.Id;
        fixedSharedRecurringService.SLK_percentage_value__c = 60;
        fixedSharedRecurringService.Purchase_Order_Item_SLK__c = poItemSLK.Id;
        fixedSharedRecurringService.Stage__c = 'Open';
        fixedSharedRecurringService.GLA__c = gla.Id;
        fixedSharedRecurringService.Dim_2__c = dim2.Id;
        fixedSharedRecurringService.Dim_3__c = dim3.Id;
        fixedSharedRecurringService.Grant__c = grant.Id;
        INSERT fixedSharedRecurringService;
        

        
        //Test a Shared Recurring Service (Fixed)
        //Create an instance of Pagereference & redirect user to VisualForce Page        
        PageReference pageRef1 = Page.RecurringService;
        pageRef1.setRedirect(true);        
        test.setCurrentPageReference(pageRef1);
        pageRef1.getParameters().put('id', fixedSharedRecurringService.Id);        
        
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(fixedSharedRecurringService);        
        RecurringService rs1 = new RecurringService(controller1); 
        
        //Add startTest() to reset the salesforce governor limits
        //Prevents too many SOQL       
        Test.startTest();
        
        rs1.billingDate = date.today() + 8;
        rs1.getRSId();
		rs1.createRecurringServiceLineItem();        
        
        //Pass the RSTag value if it exists        
        pageRef1.getParameters().put('RSTag', rs1.recurringServiceItemSLK.RS_Tag__c);
        test.setCurrentPageReference(pageRef1);        
        rs1.getRSId();
        rs1.getRSLIPRRows();
        rs1.createRecurringServicePRItems();             
        rs1.createPR(); //Heavy method might cause Too Many SOQL        
        
        Test.stopTest();
        
        //Create an Unshared Recurring Service (Fixed)
        Recurring_Service__c fixedUnSharedRecurringService = new Recurring_Service__c();
        fixedUnSharedRecurringService.Requestor__c = employee.Id;
        fixedUnSharedRecurringService.Service_Name__c = 'Internet';
        fixedUnSharedRecurringService.Service_Type__c = 'Post Pay';
        fixedUnSharedRecurringService.Shared_service__c = false;
        fixedUnSharedRecurringService.Requesting_Department__c = department.Id;
        fixedUnSharedRecurringService.Maintenance_Department__c = department.Id;
        fixedUnSharedRecurringService.Vendor__c = accounts.Id;
        fixedUnSharedRecurringService.Start_Date__c = date.today();
        fixedUnSharedRecurringService.End_Date__c = date.today() + 365;
        fixedUnSharedRecurringService.Billing_Frequency__c = 'Monthly';
        fixedUnSharedRecurringService.Billing_Type__c = 'Fixed value';
        fixedUnSharedRecurringService.Billing_Units__c = 18;
        fixedUnSharedRecurringService.Consumption_Units__c = 'Fixed value';
        fixedUnSharedRecurringService.Cost_Per_Unit__c = 2000;
        fixedUnSharedRecurringService.FLI_percentage_value__c = 100;
        fixedUnSharedRecurringService.Purchase_Order_Item_FLI__c = poItemFLI.Id;
        fixedUnSharedRecurringService.Stage__c = 'Open';
        fixedUnSharedRecurringService.GLA__c = gla.Id;
        fixedUnSharedRecurringService.Dim_2__c = dim2.Id;
        fixedUnSharedRecurringService.Dim_3__c = dim3.Id;
        fixedUnSharedRecurringService.Grant__c = grant.Id;
        INSERT fixedUnSharedRecurringService;
          
        
        //Test an Unshared Recurring Service ( Fixed )
        PageReference pageRef2 = Page.RecurringService;
        test.setCurrentPageReference(pageRef2);
        pageRef2.getParameters().put('id', fixedUnSharedRecurringService.Id);
        
        //Test getRSId() after the RSTag has been set to reload the page again
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(fixedUnSharedRecurringService);        
        RecurringService rs2 = new RecurringService(controller2);
        rs2.billingDate = date.today() + 8;        
        rs2.getRSId();        
		rs2.createRecurringServiceLineItem();
        /*
        //No need to test these again
        //Pass the RSTag value if it exists        
            pageRef2.getParameters().put('RSTag', rs2.recurringServiceItem.RS_Tag__c);
            rs2.createRecurringServicePRItems();
            rs2.getRSLIPRRows();
            rs2.createPR();      
        */
        
        //Create a Shared Recurring Service (Variable)
        Recurring_Service__c variableSharedRecurringService = new Recurring_Service__c();
        variableSharedRecurringService.Requestor__c = employee.Id;
        variableSharedRecurringService.Service_Name__c = 'Internet';    
        variableSharedRecurringService.Service_Type__c = 'Post Pay';
        variableSharedRecurringService.Shared_service__c = true;
        variableSharedRecurringService.Requesting_Department__c = department.Id;
        variableSharedRecurringService.Maintenance_Department__c = department.Id;
        variableSharedRecurringService.Vendor__c = accounts.Id;
        variableSharedRecurringService.Start_Date__c = date.today();
        variableSharedRecurringService.End_Date__c = date.today() + 366;
        variableSharedRecurringService.Billing_Frequency__c = 'Monthly';
        variableSharedRecurringService.Billing_Type__c = 'Variable';
        variableSharedRecurringService.Billing_Units__c = 18;
        variableSharedRecurringService.Consumption_Units__c = 'Fixed value';
        variableSharedRecurringService.Cost_Per_Unit__c = 1000;
        variableSharedRecurringService.FLI_percentage_value__c = 30;
        variableSharedRecurringService.Purchase_Order_Item_FLI__c = poItemFLI.Id;
        variableSharedRecurringService.SLK_percentage_value__c = 70;
        variableSharedRecurringService.Purchase_Order_Item_SLK__c = poItemSLK.Id;
        variableSharedRecurringService.Stage__c = 'Open';
        variableSharedRecurringService.GLA__c = gla.Id;
        variableSharedRecurringService.Dim_2__c = dim2.Id;
        variableSharedRecurringService.Dim_3__c = dim3.Id;
        variableSharedRecurringService.Grant__c = grant.Id;
        INSERT variableSharedRecurringService;
        
        
        //Test a Shared Recurring Service (Variable)
        //Create an instance of Pagereference & redirect user to VisualForce Page
        PageReference pageRef3 = Page.RecurringService;
        pageRef3.setRedirect(true);        
        test.setCurrentPageReference(pageRef3);
        pageRef3.getParameters().put('id', variableSharedRecurringService.Id);        
        
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(variableSharedRecurringService);        
        RecurringService rs3 = new RecurringService(controller3);
        rs3.billingDate = date.today() + 8;        
        rs3.getRSId();
		rs3.createRecurringServiceLineItem();

      
    }    
    
}