@isTest(seeAllData = true)
public class IssueWorkOrderItems2Test {
    
    static testMethod void testIssueWorkOrderItems2() {
        
        // Get dim1                              
        List<FFA_Config_Object__c> department1 = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
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
        requisition1.Requesting_Department__c = department1.get(0).Id;
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
        
        // Create Location  
        Location__c location = new Location__c();
        location.Name = 'NRB-20';
        location.Last_FLT__c = 0;
        location.Franchise_Type__c = 'Residential';
        location.Sub_Area__c = subArea.Id;
        INSERT location;      
        
        //Get Application Management RecordType Id
        List<RecordType> rt=[SELECT Id 
                             FROM RecordType 
                             WHERE Name='Toilet Sale - Application Management'];
        
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
        INSERT opportunity;
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT Id 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE type__c='dim1' 
                                                 AND isActive__c=true 
                                                 AND Teamlead__c <> null LIMIT 1];      
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT Id,Name 
                                             FROM FFA_Config_Object__c 
                                             WHERE type__c = 'company' 
                                             AND isActive__c = true
                                             AND Name = 'Sanergy Limited'];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                         WHERE Type__c = 'gla' AND isActive__c = true 
                                         AND Name = '6775 - Meals - Internal' LIMIT 1];
        
        //System.debug('CREATE FRESH LIFE: ' + company2);
        
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
        
        // Create Group_Details Debit
        Group_Details__c debitAc = new Group_Details__c();
        debitAc.Inventory_Item_Group__c = invItemGroup.Id;
        debitAc.Credit_Debit__c = 'Debit';
        debitAc.Transaction_ID__c = 'WOISS';
        debitAc.Is_GL_Account__c = true;
        debitAc.Config_Account__c = gla.get(0).Id;
        INSERT debitAc;
        
        //Insert WOCLOSE Group
        Group_Details__c debitAc2 = new Group_Details__c();
        debitAc2.Inventory_Item_Group__c = invItemGroup.Id;
        debitAc2.Credit_Debit__c = 'Debit';
        debitAc2.Transaction_ID__c = 'WOISSEXP';
        debitAc2.Is_GL_Account__c = true;
        debitAc2.Config_Account__c = gla.get(0).Id;
        INSERT debitAc2;
        
        // Create Group_Details Credit
        Group_Details__c creditAc = new Group_Details__c();
        creditAc.Inventory_Item_Group__c = invItemGroup.Id;
        creditAc.Credit_Debit__c = 'Credit'; 
        creditAc.Transaction_ID__c = 'WOISS';
        creditAc.Is_GL_Account__c = true;
        creditAc.Config_Account__c = gla.get(0).Id;
        INSERT creditAc;
        
        //Insert WOISSEXP Group
        Group_Details__c creditAc2 = new Group_Details__c();
        creditAc2.Inventory_Item_Group__c = invItemGroup.Id;
        creditAc2.Credit_Debit__c = 'Credit'; 
        creditAc2.Transaction_ID__c = 'WOISSEXP';
        creditAc2.Is_GL_Account__c = true;
        creditAc2.Config_Account__c = gla.get(0).Id;
        INSERT creditAc2;      
        
        // Create Inventory Location
        Inventory_Location__c site = new Inventory_Location__c();
        site.Name = 'Mukuru';
        INSERT site;
        
        System.debug('CREATE INVENTORY LOCATION: ' + site);
        
        // Create Inventory_Item__c
        Inventory_Item__c invItem = new Inventory_Item__c();
        invItem.Name='Bucket';
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
        
        // Create Inventory Item BOM
        Inventory_Item_BOM__c inventoryItemBOM = new Inventory_Item_BOM__c();
        inventoryItemBOM.Parent_Item__c = invItem.id;
        inventoryItemBOM.BOM_Item__c = invItem.id;
        inventoryItemBOM.Quantity_Per__c = 1;
        inventoryItemBOM.BOM_Factor__c = 'Linear';
        INSERT inventoryItemBOM;
        
        System.debug('CREATE INVENTORY ITEM BOM: ' + inventoryItemBOM);        
        
        //Create Opportunity Item
        Opportunity_Item__c opportunityItem = new Opportunity_Item__c();
        opportunityItem.Name = 'Paint Package';
        opportunityItem.Grouping__c = 'Paint Package';
        opportunityItem.Description__c = 'A1 Door Poster';
        opportunityItem.InventoryItem__c = invItem.Id;
        opportunityItem.Structure_Version__c = 'V2';
        opportunityItem.Default_Quantity__c = 1;
        opportunityItem.Franchise_Type__c = 'Commercial';
        INSERT opportunityItem;
        
        System.debug('CREATE OPPORTUNITY ITEM: ' + opportunityItem);        
        
        //Create Opportunity Work Order Item
        Opportunity_WO_Item__c opportunityWorkOrderItem = new Opportunity_WO_Item__c();
        opportunityWorkOrderItem.Opportunity__c = opportunity.Id;
        opportunityWorkOrderItem.Opportunity_Item__c = opportunityItem.Id;
        opportunityWorkOrderItem.Quantity__c = 1;
        opportunityWorkOrderItem.CurrencyIsoCode = 'KES';
        INSERT opportunityWorkOrderItem;
        
        System.debug('CREATE OPPORTUNITY WORK ORDER ITEM: ' + opportunityWorkOrderItem);          
        /*-----------------------Application Management fields-------------------------*/
        
        //GR STUFF
        opportunity.Location_confirmed_date__c=Date.today();
        opportunity.GR_Checklist_signed_Date__c=Date.today();
        opportunity.Government_Signatures_Received__c=true;
        opportunity.GR_Checklist_signed_by_AGRO__c=true;
        
        
        //APPLICATION STUFF
        opportunity.No_of_FLTs__c=2;
        opportunity.Financing_Method__c='Upfront';
        opportunity.GPS_Latitude__c=13.000000;
        opportunity.GPS_Longitude__c=12.000000;
        opportunity.Pre_app_Signed_Date__c=Date.today();
        opportunity.SA_Approved_Land__c=true;
        opportunity.Pre_app_Submitted_and_Signed__c=true;
        opportunity.Initial_Land_review_Submitted_and_Signed__c=true;
        opportunity.Location_Within_Operational_Areas__c=true;
        opportunity.App_Pt_2_received__c=true;
        opportunity.Expected_Deposit_Amount__c=10000;
        opportunity.Expected_Deposit_Payment_date__c=Date.today();
        opportunity.App2_date__c=Date.today();
        
        //DEPOSIT STUFF
        opportunity.Deposit_Amount_Received__c=10000;
        opportunity.Deposit_Paid_Date__c=Date.today();
        opportunity.CM_Deposit__c=true;
        
        /*-----------------------Deposit Management fields-------------------------*/
        //FINANCE STUFF
        opportunity.Loan_Duration__c='Upfront payment';
        opportunity.FLTs_Approved__c=2;
        
        //add products
        opportunity.Franchise_Type__c = 'Residential';        
        opportunity.CM__c=true;
        
        //INSTALLATION STUFF        
        opportunity.FLR_Date__c=Date.today();
        opportunity.Upstructures_Required__c=2.0;        
        opportunity.Installation_Checklist_Signed_date__c=Date.today();
        opportunity.Installation_Checklist_Signed__c=true;
        opportunity.CM_Install_Approved__c=true;
        opportunity.Installation_Scheduled_Stage_Entry_Date__c=Date.today();
        opportunity.Planned_Installation_End_date__c=Date.today();
        
        UPDATE opportunity;
        
        //add engineering Items
        opportunityItem.Structure_Version__c = 'V2';
        UPDATE opportunityItem;
        System.debug('ADD ENGINEERING ITEMS: ' + opportunityItem);
        
        //Create BiB Items
        Opportunity_BIB_Item__c bibItems = new Opportunity_BIB_Item__c();
        bibItems.Opportunity__c = opportunity.Id;
        bibItems.Opportunity_Item__c = opportunityItem.Id;
        bibItems.Quantity__c = 1;
        INSERT bibItems;
        
        // Update Opportunity
        opportunity.BIB_Items_Added__c = true;
        opportunity.BIB_Items_Approved__c=true;
        opportunity.Engineering_Items_Approved__c=true;
        opportunity.Marketing_Items_Approved__c=true;
        opportunity.Pit_Conversion_Items_Approved__c=true;
        
        opportunity.First_day_of_Actual_Installation__c=Date.today();
        opportunity.Installation_Complete_Date__c=Date.today();
        opportunity.Actual_Launch_Date__c=Date.today();
        opportunity.Training_Scheduled_Date__c=Date.today();
        opportunity.Training_date__c=Date.today();
        
        //launch FLO
        opportunity.stageName='Launched';
        UPDATE opportunity;
        
        // Get record type 'WO Receive'
        List<RecordType> recordType =[SELECT Id,Name 
                                      FROM RecordType 
                                      WHERE Name='WO Receive'];
        
        //Create Work Order
        Work_Order__c workOrder = new Work_Order__c();
        workOrder.RecordTypeId = recordType.get(0).Id;
        workOrder.Inventory_Item__c = invItem.Id;
        workOrder.Company__c = invItem.Item_Company__c;
        workOrder.Site__c = site.Id;
        workOrder.Inventory_Item_Quantity__c = 1;
        workOrder.Status__c = 'Work in progress';
        workOrder.Work_Order_Type__c = 'WO-Service';
        INSERT workOrder;
        
        //attempt to issue without WO Items
        ApexPages.Standardcontroller crtllWO = new ApexPages.Standardcontroller(workOrder);
        IssueWorkOrderItems2 issueWOI = new IssueWorkOrderItems2(crtllWO);
        issueWOI.issueItems();
        
        // Create Work Order Item
        Work_Order_Item__c workOrderItem = new Work_Order_Item__c();
        workOrderItem.Work_Order__c = workOrder.Id;
        workOrderItem.Inventory_Item__c = invItem.Id;
        //workOrderItem.BOM_Quantity__c = opportunityWorkOrderItem.Quantity__c;
        workOrderItem.BOM_Quantity__c = 30;
        workOrderItem.Unit_Cost__c = invItem.unit_cost__c;
        workOrderItem.Currency__c = cc.Id;
        workOrderItem.Planned_Material_Cost__c = invItem.unit_cost__c * opportunityWorkOrderItem.Quantity__c;
        INSERT workOrderItem;
        
        //Create Work Order Item Issue
        Work_Order_Item_Issue__c workOrderItemIssue = new Work_Order_Item_Issue__c();
        workOrderItemIssue.Work_Order__c = workOrder.Id;
        workOrderItemIssue.Work_Order_Item__c = workOrderItem.Id;
        workOrderItemIssue.Issued_Quantity__c = 10;
        workOrderItemIssue.Inventory_UoM__c = iUom.Id;
        workOrderItemIssue.Unit_Value__c = 30;
        INSERT workOrderItemIssue;            
        
        // Create Opportunity Work Order
        Opportunity_Work_Order__c opportunityWorkOrder = new Opportunity_Work_Order__c();
        opportunityWorkOrder.Opportunity__c = opportunity.Id;
        opportunityWorkOrder.WorkOrder__c = workOrder.Id;
        opportunityWorkOrder.Work_Order_Type__c = 'Structure';
        INSERT opportunityWorkOrder;
        
        opportunity.Structure_WO_Created__c = true;
        UPDATE opportunity;
        
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(workOrder);
        IssueWorkOrderItems2 issueWorkOrderItems = new IssueWorkOrderItems2(controller1);
        IssueWorkOrderItems2.ItemWrapper wrapper = new IssueWorkOrderItems2.ItemWrapper(workOrderItem);        
        issueWorkOrderItems.getItems();
        issueWorkOrderItems.unselectAll();
        issueWorkOrderItems.selectAll();   
      //  issueWorkOrderItems.getSites();
        //wrapper.selectLotnew();
        //issueWorkOrderItems.issueItems();
        
      //  wrapper.site = site.Id;
       // wrapper.location = inventoryItemLocation.Id;
       // wrapper.lot = itemLocationLot.Id;
        //wrapper.setLocs();
        //wrapper.setLots();
        //wrapper.selectLot();
       // wrapper.site = null;
        //wrapper.selectLotnew(); 
        for( IssueWorkOrderItems2.ItemWrapper item : issueWorkOrderItems.getItems()){
                item.issueQuantity=2;
           		item.selectLotnew();
                //item.selectedLot.Quantity__c = 8999;
            }
        issueWorkOrderItems.issueItems();   
/*        
        //attempt to issue to Inventory Item with no Commodity Code
        // Create Inventory_Item_Group__c
        Inventory_Item_Group__c invItemGroupEmpty = new Inventory_Item_Group__c();
        invItemGroupEmpty.Name = 'Empty Inventory Item Group';
        invItemGroupEmpty.Commodity_Code__c = 'Empty Commodity code';
        invItemGroupEmpty.Description__c = 'Empty Brief description';            
        INSERT invItemGroupEmpty;
        invItem.Item_Group__c = invItemGroupEmpty.id;
        UPDATE invItem;
        issueWorkOrderItems.issueItems(); 
*/
    }
}