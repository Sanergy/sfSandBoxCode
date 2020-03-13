@isTest(seeAllData = true)
public class SpecialPaymentRequestTriggerTest {
    static testMethod void SpecialPaymentRequestTriggerTest(){
        
        //Get dim1                              
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        System.debug('' + department);
        //Get dim2                                    
        List<FFA_Config_Object__c> dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim2' 
                                           AND isActive__c = true LIMIT 1];
        
        //Get dim3                                   
        List<FFA_Config_Object__c> dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim3' 
                                           AND isActive__c = true LIMIT 1];
        
        //Get dim4                                     
        List<FFA_Config_Object__c> dim4 = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim4' 
                                           AND isActive__c = true LIMIT 1];
        
        //Get GLA
        List<FFA_Config_Object__c> gla = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE Type__c = 'gla' 
                                          AND isActive__c = true LIMIT 2];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT Id,Name,Type__c,isActive__c 
                                             FROM FFA_Config_Object__c 
                                             WHERE type__c='company' 
                                             AND isActive__c=true LIMIT 5];
        //Get employee
        List<Employee__c> employeess = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                        FROM Employee__c 
                                        WHERE Employee_Active__c=true 
                                        AND Work_Email__c!=null LIMIT 1];         
        
        //Get a vendor
        List<Account> vendor = [SELECT Id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' LIMIT 1];
        //*******************************************************************************
        // Create Sanergy Department - RecordType - Sanergy
        Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
        
        // Create Sanergy Department Unit        
        Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
        
        // Create Employee Role
        Employee_Role__c employeeRole = new Employee_Role__c();        
        
        // Create Employee Manager
        Employee__c employeeManager = new Employee__c();       
        
        // Create Employee
        Employee__c employee = new Employee__c();
        
        //Create Leave Group
        Leave_Group__c leaveGroup = new Leave_Group__c();        
        
        //Create Recruitment requisition
        Recruitment_Requisition__c recruitmentRequisition = new Recruitment_Requisition__c();
        //recruitmentRequisition.Name = 'System Analyst';
        recruitmentRequisition.Requestor__c = employeeManager.Id;
        recruitmentRequisition.Requesting_Department__c = department.get(0).Id;
        recruitmentRequisition.Talent_Partner__c = department.get(0).Teamlead__c;
        recruitmentRequisition.Request_Date__c = date.today();
        recruitmentRequisition.Stage__c = 'New';
        recruitmentRequisition.Number_of_Required_Staff__c = 3;
        recruitmentRequisition.Job_Description__c = 'Job description text';
        recruitmentRequisition.Justification_for_Additional_staff__c = 'Assist in completion of projects';
        recruitmentRequisition.Type_of_employment__c = 'Permanent';
        recruitmentRequisition.Duration_of_Fixed_term_Contract_Months__c = 3;
        recruitmentRequisition.Is_recruitment_budgeted__c = 'Yes';
        //recruitmentRequisition.Candidate_Specification__c = 'Any Nationality';
        recruitmentRequisition.Proposed_Employee_required_Date__c = date.today()+30;
        recruitmentRequisition.Location__c = 'Sameer';
        INSERT recruitmentRequisition;       
        
        System.debug('RECRUITMENT REQUISITION: ' + recruitmentRequisition);
        
        // Create Sanergy Department - RecordType - Sanergy
        sanergyDept.RecordTypeId = '012D0000000KIvqIAG';        
        sanergyDept.Name = 'Core Services';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Team_Lead__c = employeeManager.Id;
        INSERT sanergyDept;
        
        System.debug('SANERGY DEPARTMENT: ' + sanergyDept);
        
        // Create Sanergy Department Unit      
        //create department unit
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
        
        System.debug('SANERGY DEPARTMENT UNIT: ' + sanergyDeptUnit);
        
        //Insert Employee Role 
        employeeRole.Name = 'Business Analyst';
        employeeRole.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employeeRole.Company_Division__c = 'Sanergy';
        employeeRole.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employeeRole.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employeeRole.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employeeRole.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employeeRole.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employeeRole.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT employeeRole;
        
        
        System.debug('EMPLOYEE ROLE: ' + employeeRole);
        
        // Create Employee Manager       
        employeeManager.Name = 'Kim Kardashian';
        employeeManager.Employee_First_Name__c = 'Kim';
        employeeManager.Employee_Last_Name__c = 'Kardashian';
        employeeManager.Primary_Phone__c = '1234567';        
        employeeManager.Employment_Start_Date__c = date.today() - 200;
        employeeManager.Employment_Status__c = 'Permanent';
        employeeManager.Identification_Number__c = '920183';
        employeeManager.Primary_Phone__c = '93489853489';      
        employeeManager.Sanergy_Department__c = sanergyDept.Id;
        employeeManager.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employeeManager.Employee_Role__c = employeeRole.Id;
        employeeManager.Recruitment_Requisition__c = recruitmentRequisition.Id;
        //employeeManager.Employee_SF_Account__c = '0057E000003e0oe';
        employeeManager.Company_Division__c = employeeRole.Company_Division__c;
        employeeManager.Tickets_Created__c = false; 
        INSERT employeeManager;
        
        System.debug('EMPLOYEE MANAGER: ' + employeeManager);        
        /** Select Account
List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
FROM Account
WHERE Name='Tuffsteel Ltd'];*/         
        
        /*List<Employee__c> employee = [SELECT id,Line_Manager__c FROM Employee__c
WHERE Sanergy_Department__c != null
AND Sanergy_Department_Unit__c != null
AND Sanergy_Department_Unit__r.Approver__c != null
AND Employee_Active__c = true
LIMIT 1];*/
        //*********************************************************************************
        
        // Create Employee        
        employee.Name = 'Jason';
        employee.Employee_First_Name__c = 'Jason';
        employee.Employee_Last_Name__c = 'Statham';
        employee.Recruitment_Requisition__c = recruitmentRequisition.Id;
        employee.Primary_Phone__c = '0712345678';
        employee.Employment_Start_Date__c = date.today()+50;
        employee.Employee_Active__c = true;
        employee.Employment_Status__c = 'Permanent';
        employee.Employee_Role__c = employeeRole.Id;
        employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employee.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT employee;
        
        //Get Company
        FFA_Config_Object__c company2 = [SELECT Id, Name FROM FFA_Config_Object__c WHERE Name='Sanergy Limited' LIMIT 1];//Sanergy Limited
        
        /*Create a Company
        FFA_Config_Object__c company1 = new FFA_Config_Object__c();
        company1.Name = 'Sanergy Limited';
        company1.Type__c='company';
        company1.isActive__c=True;
        company1.lookup_ID__c='w94jk6lwrls';
        INSERT company1;*/ 
        
        // Create Inventory_UoM__c
        Inventory_UoM__c iUom = new Inventory_UoM__c();
        iUom.Name = 'Dummy Inventory UOM 1';
        iUom.Description__c = 'Dummy Inventory UOM one';
        iUom.Uom_Code__c = '101';
        iUom.CurrencyIsoCode = 'KES';
        INSERT iUom;
        
        // Create Inventory_Item_Group__c
        Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
        invItemGroup.Name = 'New Inventory Item Group';
        invItemGroup.Commodity_Code__c = 'New Commodity code';
        invItemGroup.Description__c = 'Brief description';                
        INSERT invItemGroup;
        
        Group_Details__c debitAc = new Group_Details__c();
        debitAc.Inventory_Item_Group__c = invItemGroup.Id;
        debitAc.Credit_Debit__c = 'Debit'; 
        debitAc.Transaction_ID__c = 'PORCPT';
        debitAc.Is_GL_Account__c = true;
        debitAc.Config_Account__c = gla.get(0).Id;            
        INSERT debitAc;
        
        Group_Details__c creditAc = new Group_Details__c();
        creditAc.Inventory_Item_Group__c = invItemGroup.Id;
        creditAc.Credit_Debit__c = 'Credit'; 
        creditAc.Transaction_ID__c = 'PORCPT';
        creditAc.Is_GL_Account__c = true;
        creditAc.Config_Account__c = gla.get(1).Id;        
        INSERT creditAc;
        
        // Create Inventory Location
        Inventory_Location__c site = new Inventory_Location__c();
        site.Name = 'Mukuru';
        INSERT site;
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KSH';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        // Create Inventory_Item__c
        Inventory_Item__c invItem = new Inventory_Item__c();
        invItem.Name='Inventory Item 1'; 
        invItem.Item_Number__c = '123456';
        invItem.Item_Description__c = 'brief description';
        invItem.Item_Type__c = 'Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Inventory_UoM__c = iUom.Id;
        invItem.Item_Group__c = invItemGroup.Id;
        invItem.Default_Location__c = 'Mukuru';
        invItem.Default_Lot__c = '3';
        invItem.Currency_Config__c = cc.Id;
        invItem.unit_cost__c = 20;            
        INSERT invItem;
        
        System.debug('CREATE INVENTORY ITEM: ' + invItem);                
        
        //Create Inventory Item Location
        Inventory_Item_Location__c inventoryItemLocation  = new Inventory_Item_Location__c();
        inventoryItemLocation.Location_Name__c = '001';
        inventoryItemLocation.Inventory_Item__c = invItem.Id;
        inventoryItemLocation.Location__c = site.Id;
        inventoryItemLocation.Max_Location_Quantity__c = 100000;
        INSERT inventoryItemLocation;
        
        System.debug('CREATE INVENTORY ITEM LOCATION: ' + inventoryItemLocation);
        
        //Create Item Location Lot
        Item_Location_Lot__c itemLocationLot = new Item_Location_Lot__c();
        itemLocationLot.Item_Location__c = inventoryItemLocation.Id;
        itemLocationLot.Lot_Name__c  = '001';
        itemLocationLot.Quantity__c = 100000;
        INSERT itemLocationLot;
        
        System.debug('CREATE ITEM LOCATION LOT: ' + itemLocationLot);  
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        // poItem.Contract_Number__c = c.Id;
        poItem.Status__c= 'Active'; 
        poItem.Primary_Vendor__c= true; 
        poItem.Vendor__c = '001D000001ssdn6'; 
        poItem.Currency__c = cc.Id;
        poItem.Approved__c = true;
        INSERT poItem;
        
        System.debug('CREATE PO ITEM: ' + poItem);          
        
        //Create PR
        Procurement_Tracking_Sheet__c pr1= new Procurement_Tracking_Sheet__c();
        pr1.Requestor_Type__c = 'Employee';
        pr1.Required_Date__c = Date.today() + 14;
        pr1.Requesting_Department__c = department.get(0).id;
        pr1.Maintenance_Department__c = department.get(0).id;
        pr1.Priority__c = 'Low';
        pr1.Remarks__c = 'Some remarks'; 
        pr1.Requestor__c = employee.Id;
        pr1.High_Priority_Comments__c = 'comment';
        pr1.Requesting_Company__c = invItem.Item_Company__c;
        pr1.Is_Retrospective__c = 'Yes';
        INSERT pr1;
        
        test.startTest();
        //Create Special Procurement               
        Special_Procurement__c sp1 = new Special_Procurement__c();
        sp1.Requestor__c = 'aAsD0000000GmgM';
        sp1.Type__c = 'Cash Advance';
        sp1.Required_Date__c = date.today();
        sp1.Comments__c = 'Two tyres for Toyota Corolla';         
        sp1.Requesting_Department__c = department.get(0).Id;
        sp1.Vendor__c = poItem.Vendor__c;//'001D000001ssdn6';
        sp1.Approval_Status__c = 'Approved By Team Lead';
        sp1.Dim_2__c = dim2.get(0).Id;
        sp1.Dim_3__c = dim3.get(0).Id;
        sp1.GLA__c = gla.get(0).Id;
        sp1.Grant__c = dim4.get(0).Id;
        sp1.Requesting_Company__c = company.get(0).Id;
        //sp1.Requires_PR__c = true;
        INSERT sp1;
        
        System.debug('SPR: ' + sp1.Requesting_Company__c);
        
        //Create Special Procurement Line Items
        Special_Procurement_Line_Item__c spLineItems1 = new Special_Procurement_Line_Item__c();
        spLineItems1.Special_Procurement__c = sp1.Id;
        spLineItems1.Item__c = 'Two 18 Inch Car Tyress';
        spLineItems1.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
        spLineItems1.Quantity_Requested__c = 2;
        spLineItems1.Unit_Price__c = 600;
        spLineItems1.Create_PR_Line_Item__c = true;
        spLineItems1.Status__c = 'Approved';
        spLineItems1.EPR_Created__c = false;
        spLineItems1.Purchase_Order_Item__c = poItem.ID;
        
        INSERT spLineItems1;
        
        //CReate SPR -Procurement Type
        
        //Create Special Procurement               
        Special_Procurement__c spProc = new Special_Procurement__c();
        spProc.Requestor__c = 'aAsD0000000GmtM';
        spProc.Type__c = 'Special Procurement';
        spProc.Required_Date__c = date.today();
        spProc.Comments__c = 'Two tyres for Toyota Corolla';         
        spProc.Requesting_Department__c = department.get(0).Id;
        spProc.Vendor__c = poItem.Vendor__c; //vendor.get(0).Id;       
        spProc.Approval_Status__c = 'Approved By Team Lead';
        spProc.Dim_2__c = dim2.get(0).Id;
        spProc.Dim_3__c = dim3.get(0).Id;
        spProc.GLA__c = gla.get(0).Id;
        spProc.Grant__c = dim4.get(0).Id;
        spProc.Requesting_Company__c = company.get(0).Id;
        spProc.Stage__c = 'SPR Approved';
        
        INSERT spProc;
        
        //Create Special Procurement Line Items
        Special_Procurement_Line_Item__c spProcLI = new Special_Procurement_Line_Item__c();
        spProcLI.Special_Procurement__c = spProc.Id;
        spProcLI.Item__c = 'Two 18 Inch Car Tyress';
        spProcLI.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
        spProcLI.Quantity_Requested__c = 2;
        spProcLI.Unit_Price__c = 600;
        spProcLI.Create_PR_Line_Item__c = true;
        spProcLI.Status__c = 'Approved';
        spProcLI.EPR_Created__c = false;
        spProcLI.Purchase_Order_Item__c = poItem.ID;
        spProcLI.Request_Type__c = 'Stock';
        
        INSERT spProcLI;
        
        spProc.Requires_PR__c = true;
        UPDATE spProc;

        
        
        //Add Attachments
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=spProc.id); 
        insert attach;
        
        Attachment attachPO =new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=spProc.id); 
        insert attachPO;
        
        //Add Note
        Note notePR =new Note(Title = 'Note 1', body = 'bodyBlob' , parentId=spProc.id); 
        insert notePR;
        
        Note notePO =new Note(Title ='Note 2', body = 'bodyBlob', parentId=spProc.id); 
        insert notePO;
        
        //Add GoogleDoc
        GoogleDoc gDoc =new GoogleDoc(Name = 'GDoc1', url = 'https://docs.google.com/spreadsheets/d/1l1U4A0Bb3E8TUrNmmdibqejqSL9vsfS_AkOK3ez5lGE/edit#gid=0',  parentId=spProc.id); 
        insert gDoc;
        
        GoogleDoc gDocPO =new GoogleDoc(Name = 'GDoc2', url ='https://docs.google.com/document/d/1ReLwDzRZDHWh4m6NeX9XMtmKV_sQZTCYme7mbRpx5Iw/edit', parentId=spProc.id); 
        insert gDocPO;

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
        
        Inventory_Location__c site1 = new Inventory_Location__c(
            Name = 'Mukuru 2345'
        );
        insert site1;
        
        
        Inventory_item__c invItem1 = new Inventory_item__c(
            Name = 'item 2',
            Item_Number__c = '12345678',
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
            Default_Site__c = site1.Id,
            Default_Location__c = '1',
            Default_Lot__c = '1',
            Planning_Policy__c = 'No MRP Planning'
        );
        
        insert invItem1;
        
        //Create PR
        Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
        pr.Requestor_Type__c = 'Employee';
        pr.Required_Date__c = Date.today() + 14;
        pr.Requesting_Department__c = department.get(0).id;
        pr.Maintenance_Department__c = department.get(0).id;
        pr.Priority__c = 'High';
        pr.Remarks__c = 'Some remarks'; 
        pr.Requestor__c = employee.id; 
        pr.High_Priority_Comments__c = 'comment';
        pr.Requesting_Company__c = invItem.Item_Company__c;
        pr.Next_Step__c = 'Pending Team Lead Approval';
        pr.Stage__c = 'Open';
        pr.Is_Retrospective__c	 = 'NO';
        pr.High_Priority_Comments__c = 'PR Generated From SPR';
        
        insert pr;
        
        //Fetch Existing Account		
        List<Account> ac= [SELECT Id,
                           Name,
                           CurrencyIsoCode
                           FROM Account
                           WHERE Name='Tuffsteel Ltd'
                           Limit 1
                          ];
        
        // Create a Contract            
        Contract contract = new Contract(
            AccountId=ac.get(0).Id, 
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
            Inventory_Item__c = invItem1.Id,
            Purchase_UoM__c = uom.Id,
            UOM_Conversion_Factor__c = 10,
            Contract_Number__c = contract.Id,
            Vendor__c = contract.AccountId,
            Status__c='Active',
            Approved__c = true
        );
        insert poI;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Dim_2__c = dim2.get(0).id;
        prItem.Dim_3__c = dim3.get(0).id;
        prItem.Grant__c = dim4.get(0).id;
        prItem.GLA__c = gla.get(0).id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 2;
        prItem.Inventory_Item__c = poI.Inventory_Item__c;
        prItem.Budget_Amount__c= 10;
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.Currency_Config__c = curr.id; 
        prItem.Purchase_Order_Item__c = poI.id;
        prItem.RequestType__c = 'Stock';
        insert prItem;
        
        SpecialPaymentRequestTriggerTest sprTest  = new SpecialPaymentRequestTriggerTest(); 
        spProc.Stage__c = 'SPR Approved';
        UPDATE spProc;
        test.stopTest();
    }
}