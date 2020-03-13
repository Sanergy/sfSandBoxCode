@isTest(seeAllData = true)
public class CreateNewMaintenanceTaskTriggerTest {
    static testMethod void testCreateNewMaintenanceTaskTriggerTest(){
        
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
        // Create Sanergy Department - RecordType - Sanergy
        Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
        
        // Create Sanergy Department Unit        
        Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
        
        // Create Employee Role
        Employee_Role__c empRole = new Employee_Role__c();
        
        // Create Employee
        Employee__c employee = new Employee__c();        
        //Create Department
        sanergyDept.Name = 'It department';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        INSERT sanergyDept;
        
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
        
        //Insert Employee Role 
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
        
        INSERT employee;
        
        Asset_Maintenance_Schedule__c sched = new Asset_Maintenance_Schedule__c();
        sched.Name = 'Test Name';
        
        Insert sched;
        
        Sanergy_Asset__c sanAsset = new Sanergy_Asset__c();
        
        
        
        
        List<RecordType> record = [SELECT id,Name from RecordType where Name ='Open'];
        List<RecordType> record3 = [SELECT id,Name from RecordType where Name ='Firmed'];
        System.debug('RECORD TYPE: ' + record);
        
        List<RecordType> record2 = [SELECT id,Name from RecordType where Name ='Completed'];
        System.debug('RECORD TYPE: ' + record2);
        
        
        
        sanAsset.Asset_Name__c = 'Laptop'; 
        sanAsset.Manufacturer__c = 'Dell';
        sanAsset.Make__c = 'Dell';
        sanAsset.Model__c = 'Latitude e6430';
        sanAsset.Operating_System__c = 'Ubuntu';
        sanAsset.Active__c = true;
        
        insert sanAsset;
        
        if(sanAsset.Id != null ){
            //insert maint task
         /* Asset_Maintenance_Task__c maintTask = new Asset_Maintenance_Task__c();
            maintTask.Maintenance_Type__c = 'PM(Preventive Maintenance)';
            maintTask.Asset_Maintenance_Schedule__c = sched.Id;
            maintTask.RecordTypeId = record.get(0).id;
            maintTask.Status__c = 'Open';
            maintTask.Clone_Service_Items__c = false;
            maintTask.GLA__c = gla.Id;
            maintTask.Assigned_To__c = employee.Id;
            maintTask.Sanergy_Asset__c = sanAsset.Id;
          
            insert maintTask;  */     
        }
        
        // sanAsset.Manufacturer__c = 'HP';
        // sanAsset.Model__c = 'PRO BOOK';
        // update sanAsset;  
        
        
        
        
      /*  Asset_Maintenance_Task__c maintTask4 = new Asset_Maintenance_Task__c();
        maintTask4.Maintenance_Type__c = 'PM(Preventive Maintenance)';
        maintTask4.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask4.RecordTypeId = record2.get(0).id;
        maintTask4.Status__c = 'In Progress';
        maintTask4.Clone_Service_Items__c = false;
        maintTask4.GLA__c = gla.Id;
        maintTask4.Assigned_To__c = employee.Id;
        maintTask4.Sanergy_Asset__c = sanAsset.Id;
        maintTask4.Service_Date__c = date.today()+2;
        maintTask4.Proposed_Service_Date__c = date.today()+7;
        maintTask4.Proposed_Reading__c = 200.35;
        maintTask4.Meter_Reading__c = 3000;
        
        insert maintTask4;
        
        
        Asset_Maintenance_Task__c maintTask3 = new Asset_Maintenance_Task__c();
        maintTask3.Maintenance_Type__c = 'PM(Preventive Maintenance)';
        maintTask3.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask3.RecordTypeId = record3.get(0).id;
        maintTask3.Status__c = 'Open';
        maintTask3.Clone_Service_Items__c = false;
        maintTask3.GLA__c = gla.Id;
        maintTask3.Assigned_To__c = employee.Id;
        maintTask3.Sanergy_Asset__c = sanAsset.Id;
        maintTask3.Service_Date__c = date.today()+2;
        maintTask3.Proposed_Service_Date__c = date.today()+7;
        maintTask3.Proposed_Reading__c = 200.35;
        
        insert maintTask3;*/
        
        /*maintTask3.CreateTask__c = True;
maintTask3.Status__c = 'Completed';
maintTask3.Clone_Service_Items__c = True;
Update maintTask3;*/
        
        Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
        usage.Sanergy_Asset__c = sanAsset.Id;
        usage.Current_Reading__c = true;
        usage.Actual_Units__c =2000;
        usage.Date__c = date.today() -3;
        
        insert usage;  
        system.debug('usageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' + usage);  
        
        Asset_Usage_Reading__c usage2 = new Asset_Usage_Reading__c();
        usage2.Sanergy_Asset__c = sanAsset.Id;
        usage2.Actual_Units__c = 4000;
        usage2.Current_Reading__c = true;
        usage2.Date__c = date.today();
        
        insert usage2;
        
        usage.Current_Reading__c = false;
        update usage;
        system.debug('usageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee' + usage2);          
        
        
        
        List<Inventory_item__c> items = [Select Id,Has_BOM__c, Name,unit_cost__c,Item_Group__r.Dimension_1__r.lookup_ID__c,
                                         Item_Group__r.Dimension_2__r.lookup_ID__c, Item_Group__r.Dimension_3__r.lookup_ID__c,
                                         Item_Group__r.Dimension_4__r.lookup_ID__c,Item_Group__c
                                         FROM Inventory_item__c WHERE Item_Group__c != null AND Has_BOM__c = true LIMIT 1
                                        ];
        
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true  and Name = 'Fresh Life Initiative Limited' LIMIT 1];
        
        
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        
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
        
        FFA_Config_Object__c glas = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'gla' AND isActive__c = true 
                                     AND Name = '1410 - Inventory - Raw Material' LIMIT 1];
        
        
        if(gla != null){
            Group_Details__c details = new Group_Details__c();
            details.Config_Account__c = glas.Id;
            details.Credit_Debit__c = 'Debit';
            details.Inventory_Item_Group__c = comCode.Id;
            details.Transaction_ID__c = 'PORCPT';
            details.Is_GL_Account__c = true;                                    
            INSERT details;    
        }
        
        
        
        
        // Create UOM
        Inventory_UoM__c uom = new Inventory_UoM__c();
        uom.Uom_Code__c = 'Pack';
        uom.Name = 'n';
        uom.Description__c = 'Pack - 70kg';
        INSERT uom;
        
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
        
        // Get Sanergy Vendor RecordType Id
        List<RecordType> rt=[SELECT Id,Name FROM RecordType WHERE Name='Sanergy Vendor'];
        
        //Create Account       
        Account accounts = new Account();
        accounts.RecordTypeId = rt.get(0).Id;
        accounts.Name = 'Unilever Kenya';
        accounts.CurrencyIsoCode = 'KES';                        
        INSERT accounts;
        
        // Create Contract
        Contract contract = new Contract();
        contract.AccountId = accounts.Id;
        contract.Type_of_Contract__c = 'Master Service Agreement';
        contract.Status = 'Draft';
        contract.StartDate = date.today();
        contract.ContractTerm = 5;
        contract.Primary_Contract__c=true;        
        contract.Payment_Terms__c = '30 Days';
        contract.Contract_Summary__c = 'summary of contract';
        INSERT contract;
        
        //Get Purchase Order Item
        Purchase_Order_Item__c poI = new Purchase_Order_Item__c();
        poI.Name = 'Item';
        poI.Item_Description__c = 'Item Desc';
        poI.Currency__c = curr.id;
        poI.Inventory_Item__c = invItem.Id;
        poI.Purchase_UoM__c = uom.Id;
        poI.UOM_Conversion_Factor__c = 1;
        poI.Contract_Number__c = contract.Id;
        poI.Vendor__c = contract.AccountId;
        poI.Status__c='Active'; 
        poI.Approved__c = true;
        poI.Comments__c = 'afghjkll';
        INSERT poI;
        
        Boolean HighPriority =true;
        test.startTest(); 
        //Create PR
        Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
        pr.Requestor_Type__c = 'Employee';
        pr.Required_Date__c = Date.today() + 14;
        pr.Requesting_Department__c = department.get(0).id;
        pr.Maintenance_Department__c = department.get(0).id;
        pr.Priority__c = 'Low';
        pr.Remarks__c = 'Some remarks'; 
        pr.Requestor__c = employee.id;
        pr.High_Priority_Comments__c = 'comment';
        pr.Requesting_Company__c = invItem.Item_Company__c;
        pr.Is_Retrospective__c = 'No';
        pr.PR_Source__c = '	Asset Maintenance Task - BM';  
        INSERT pr;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Dim_2__c = dim2.get(0).id;
        prItem.Dim_3__c = dim3.get(0).id;
        prItem.Grant__c = dim4.get(0).id;
        prItem.GLA__c = gla.id;
        prItem.Inventory_Item__c = poI.Inventory_Item__c;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Commodity_Code_Gla__c = gla.id;
        prItem.Override_Gla__c = false;
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 10;
        prItem.Budget_Amount__c= 10;
        prItem.Currency_Config__c = curr.id; 
        prItem.Purchase_Order_Item__c = poI.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        prItem.Asset_Id__c = sanAsset.Id;
        prItem.GLA__c = gla.Id;
        prItem.Override_Gla__c = TRUE;
        INSERT prItem; 
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        UPDATE pr;
        
        prItem.Status__c = 'Pending Purchase Order';
        UPDATE prItem;
        
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = poI.Vendor__c;
        po.Company__c = company.get(0).id;
        po.PO_Currency__c = curr.id;
        po.Firm_Date__c = Date.today();
        
        insert po;
        
        //create PO Lines
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Purchase_Order__c = po.id;
        poLine.Purchase_Order_Item__c = poI.id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 1;
        poLine.Unit_Price__c = 1;
        poLine.Vatable__c = false;
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Dimension_2__c = dim2.get(0).id;
        poLine.Dimension_3__c = dim3.get(0).id;
        poLine.Dimension_4__c = dim4.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.GLA__c = gla.id;
        poLine.Requesting_Company__c = invItem.Item_Company__c;        
        INSERT poLine;
        
        
        
        //Create Vendor Invoice
        Vendor_Invoice__c vi = new Vendor_Invoice__c();
        vi.Vendor__c = po.Vendor_Account__c;
        vi.Proforma_Invoice__c= 'invTest';
        vi.Vendor_Invoice_date__c = Date.today()+5;
        vi.Currency_Config_Currency__c = po.PO_Currency__c;
        vi.Status__c = 'Items Received';
        vi.Invoice_Total__c = 2000;
        vi.Reconciled__c = false;
        // vi.Count_VIPOLI__c = 1;
        
        insert vi;        
        
        //Create Vendor Invoice
        Vendor_Invoice__c vi1 = new Vendor_Invoice__c();
        vi1.Vendor__c = po.Vendor_Account__c;
        vi1.Proforma_Invoice__c= 'invTest';
        vi1.Vendor_Invoice_date__c = Date.today()+5;
        vi1.Currency_Config_Currency__c = po.PO_Currency__c;
        vi1.Status__c = 'Items Received';
        
        insert vi1;        
        
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 1;
        VIPOLI.Item_Received_Total__c = 1;
        VIPOLI.Item_Unit_Cost__c = 0;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 0;
        VIPOLI.Reconciled_Line_Total__c =0;
        VIPOLI.Last_Invoice__c = TRUE;
        VIPOLI.Vendor_Invoice__c = VI.Id;
        Insert VIPOLI; 
        
        
        Vendor_Invoice_Items__c vii = new Vendor_Invoice_Items__c();
        vii.Purchase_Order_Line_Item__c = poLine.Id;
        vii.Quantity__c = 1;
        Vii.CurrencyIsoCode = 'KES';
        vii.Vendor_Invoice_Purchase_Order_Line_Item__c = VIPOLI.Id;
        vii.Company__c = invItem.Item_Company__c;
        vii.Vendor_Invoice__c = vi.Id;
        INSERT vii;
        
        Inventory_Requisition__c InvRequisition = new Inventory_Requisition__c(
            Creator__c = employee.Id,
            Requestor__c = employee.Id,
            Request_Date__c = System.today(),
            Required_Date__c = System.today(),
            Company__c = company.get(0).Id,
            Department__c = department.get(0).Id,
            Dimension_2__c = dim2.get(0).Id,
            Dimension_3__c = dim3.get(0).Id,
            Dimension_4__c = dim4.get(0).Id
        );
        
        insert InvRequisition;
        
        Inventory_Requisition_Item__c requisitionItem = new Inventory_Requisition_Item__c(
            Inventory_Item__c = invItem.Id,
            Inventory_Requisition__c = InvRequisition.Id,
            GLA__c = gla.Id,
            Quantity__c = 5
        );
        
        insert requisitionItem;
        
        
        
        
        
        
        
        
        
        
        Asset_Service_Item__c asi = new Asset_Service_Item__c();      
        asi.Item_Code__c = 'Cement';
        asi.Inventory_Item__c = invItem.Id;
        asi.Purchase_Order_Item__c = poI.Id;
        asi.vendor__c = accounts.Id;
        asi.Inventory_Uom__c = uom.Id;
        Insert asi;
        
        
      /*  Asset_Maintenance_Task__c maintTask2 = new Asset_Maintenance_Task__c();
        maintTask2.Maintenance_Type__c = 'BM(Break Down Maintenance)';
        maintTask2.Asset_Maintenance_Schedule__c = sched.Id;
        maintTask2.RecordTypeId = record.get(0).id;
        maintTask2.Status__c = 'Open';
        maintTask2.Clone_Service_Items__c = false;
        maintTask2.GLA__c = gla.Id;
        maintTask2.Assigned_To__c = employee.Id;
        maintTask2.Sanergy_Asset__c = 'aAAD0000000wk8H';
        maintTask2.Service_Date__c = date.today()+2;
        maintTask2.Proposed_Service_Date__c = date.today()+7;
        maintTask2.Proposed_Reading__c = 200.35;
        insert maintTask2;*/
        
        /*Note Sand Box text  
        Asset_Maintenance_Task__c tsk= [Select id From 
                                        Asset_Maintenance_Task__c 
                                        where id =: 'aJb7E0000000019'];
       */  
      
        /* Note Production Test */
        Asset_Maintenance_Task__c tsk= [
            Select id 
            FROM Asset_Maintenance_Task__c 
            where id =: 'aJU4G000000TN7h' or id =: 'aJb7E0000000019'
            LIMIT 1
        ];
        
        list<Maintenance_Service_Items__c> mentainList = [SELECT id,Purchase_Order_Item__c,Inventory_Item__c,Name,Specification__c,
                                                          Quantity__c,RecordType__c,Unit_Item_Cost__c,Company__c,
                                                          Uom_Conversion_Factor__c,Vendor__c,Asset_Service_Item__c,Asset_Maintenance_Task__c,
                                                          Cost_Price__c,Item_Description__c
                                                          FROM Maintenance_Service_Items__c
                                                          WHERE Asset_Maintenance_Task__c =: tsk.id
                                                         ];
        
        List<Maintenance_Service_Items__c> maintenanceList = new List<Maintenance_Service_Items__c>();
        
        for(Maintenance_Service_Items__c mentain: mentainList){
            //Get the POI,
            Purchase_Order_Item__c poi2 = [SELECT Id
                                           FROM Purchase_Order_Item__c 
                                           WHERE Id =: mentain.Purchase_Order_Item__c
                                          ]; 
            maintenanceList.add(mentain);
            
        }                                   
        
        
        Maintenance_Service_Items__c msi = new Maintenance_Service_Items__c();
        msi.Asset_Maintenance_Task__c = tsk.Id;
        msi.Asset_Service_Item__c = asi.Id;
        Insert msi;
        
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(tsk);
        CreatePRFromAssetMaintenanceTask task = new CreatePRFromAssetMaintenanceTask(controller); 
        
        task.HighPriority = false; 
        task.HighPriority = True;
        task.getServiceItems();
        task.CreatePR();
        task.createPRLineItem(maintenanceList);
        task.POArray = maintenanceList;
        task.POArrayList = maintenanceList;
        //task.createInventoryItem(maintenanceList);
        task.x =10;
        task.y = 30;
        task.testMethtwo();
        task.testMethThree();
        task.testMeth();
        test.stopTest();


        
    }
}