@isTest(seeAllData = true)
public class BulkApprovalControllerTest{
    public static TestMethod void BulkApprovalControllerTester(){
        
//         list<Purchase_Order__c> poIDs =[SELECT id,name,Owner.name, Vendor_Account__r.name, Company__r.name,
//                                         Order_Status__c, Firm_Date__c, PO_Currency__r.Name, Total_Amount__c
//                                         FROM Purchase_Order__c
//                                        ];
        
        
//         //Get dim1                              
//         List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Delegate_s_Threshold_Amount__c,Teamlead__c 
//                                                  FROM FFA_Config_Object__c 
//                                                  WHERE Type__c = 'dim1' 
//                                                  AND Name LIKE 'Information Technology'
//                                                  AND isActive__c = true LIMIT 1];      
        
//         //Get Company
//         List<FFA_Config_Object__c> company= [SELECT id 
//                                              FROM FFA_Config_Object__c 
//                                              WHERE type__c='company' 
//                                              AND Name = 'Sanergy Limited'
//                                              and isActive__c=true LIMIT 1];       
        
//         //Get the location
//         List<FFA_Config_Object__c> location=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim2'  AND isActive__c=true LIMIT 1];         
        
//         //get the dim3
//         List<FFA_Config_Object__c> dim3=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim3'  AND isActive__c=true LIMIT 1];
        
//         //get the grant
//         List<FFA_Config_Object__c> grant=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim4'  AND isActive__c=true LIMIT 1];
                 
//         //Get gla
//         List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla'
//                                          AND (Name='2000 - Accounts Payable Control'
//                                               OR Name='2050 - Accrued Accounts Payable Control')
//                                          AND isActive__c=true LIMIT 2];
        
//          test.startTest();
//          //Get dim4                                     
//          List<FFA_Config_Object__c> dim4 = [SELECT Id,Name,Type__c,isActive__c 
//                                             FROM FFA_Config_Object__c 
//                                             WHERE Type__c = 'dim4' 
//                                             AND isActive__c = true LIMIT 1];
//                  //Get dim2                                    
//          List<FFA_Config_Object__c> dim2 = [SELECT Id,Name,Type__c,isActive__c 
//                                             FROM FFA_Config_Object__c 
//                                             WHERE Type__c = 'dim2' 
//                                             AND isActive__c = true LIMIT 1];
                                                 
//         //Create Account       
//         Account accounts = new Account();
//         accounts.Name = 'Tuffsteel Ltd';
//         accounts.CurrencyIsoCode = 'KES';                        
//         INSERT accounts; 
     
//         //*******************************************************************************
//         // Create Sanergy Department - RecordType - Sanergy
//         Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
        
//         // Create Sanergy Department Unit        
//         Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();
        
//         // Create Employee Role
//         Employee_Role__c employeeRole = new Employee_Role__c();        
        
//         // Create Employee Manager
//         Employee__c employeeManager = new Employee__c();       
        
//         // Create Employee
//         Employee__c employee = new Employee__c();
        
//         //Create Leave Group
//         Leave_Group__c leaveGroup = new Leave_Group__c();        
        
//         //Create Recruitment requisition
//         Recruitment_Requisition__c recruitmentRequisition = new Recruitment_Requisition__c();
//         //recruitmentRequisition.Name = 'System Analyst';
//         recruitmentRequisition.Requestor__c = employeeManager.Id;
//         recruitmentRequisition.Requesting_Department__c = department.get(0).Id;
//         recruitmentRequisition.Talent_Partner__c = department.get(0).Teamlead__c;
//         recruitmentRequisition.Request_Date__c = date.today();
//         recruitmentRequisition.Stage__c = 'New';
//         recruitmentRequisition.Number_of_Required_Staff__c = 3;
//         recruitmentRequisition.Job_Description__c = 'Job description text';
//         recruitmentRequisition.Justification_for_Additional_staff__c = 'Assist in completion of projects';
//         recruitmentRequisition.Type_of_employment__c = 'Permanent';
//         recruitmentRequisition.Duration_of_Fixed_term_Contract_Months__c = 3;
//         recruitmentRequisition.Is_recruitment_budgeted__c = 'Yes';
//         //recruitmentRequisition.Candidate_Specification__c = 'Any Nationality';
//         recruitmentRequisition.Proposed_Employee_required_Date__c = date.today()+30;
//         recruitmentRequisition.Location__c = 'Sameer';
//         INSERT recruitmentRequisition;       
        
//         System.debug('RECRUITMENT REQUISITION: ' + recruitmentRequisition);
        
//         // Create Sanergy Department - RecordType - Sanergy
//         sanergyDept.RecordTypeId = '012D0000000KIvqIAG';        
//         sanergyDept.Name = 'Core Services';
//         sanergyDept.Company__c = 'Sanergy';
//         sanergyDept.Department_Code__c = 'CORE';
//         sanergyDept.Team_Lead__c = 'aAsD0000000GmgM';
//         INSERT sanergyDept;
        
//         System.debug('SANERGY DEPARTMENT: ' + sanergyDept);
        
//         // Create Sanergy Department Unit      
//         //create department unit
//         sanergyDeptUnit.Name = 'Information Technology System';
//         sanergyDeptUnit.Unit_Code__c = 'CORE';
//         sanergyDeptUnit.Sanergy_Department__c = sanergyDept.Id;
//         sanergyDeptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
//         sanergyDeptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
//         sanergyDeptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
//         sanergyDeptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
//         sanergyDeptUnit.Talent_Partner__c = '005D0000003Ykhb';
//         sanergyDeptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
//         INSERT sanergyDeptUnit;
               
//         System.debug('SANERGY DEPARTMENT UNIT: ' + sanergyDeptUnit);
        
//         //Insert Employee Role 
//         employeeRole.Name = 'Business Analyst';
//         employeeRole.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
//         employeeRole.Company_Division__c = 'Sanergy';
//         employeeRole.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
//         employeeRole.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
//         employeeRole.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
//         employeeRole.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
//         employeeRole.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
//         employeeRole.Talent_Partner__c = 'aAsD0000000GmgM';
//         INSERT employeeRole;

        
//         System.debug('EMPLOYEE ROLE: ' + employeeRole);
        
//         // Create Employee Manager       
//         employeeManager.Name = 'Kim Kardashian';
//         employeeManager.Employee_First_Name__c = 'Kim';
//         employeeManager.Employee_Last_Name__c = 'Kardashian';
//         employeeManager.Primary_Phone__c = '1234567';        
//         employeeManager.Employment_Start_Date__c = date.today() - 200;
//         employeeManager.Employment_Status__c = 'Permanent';
//         employeeManager.Identification_Number__c = '920183';
//         employeeManager.Primary_Phone__c = '93489853489';      
//         employeeManager.Sanergy_Department__c = sanergyDept.Id;
//         employeeManager.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
//         employeeManager.Employee_Role__c = employeeRole.Id;
//         employeeManager.Recruitment_Requisition__c = recruitmentRequisition.Id;
//         //employeeManager.Employee_SF_Account__c = '0057E000003e0oe';
//         employeeManager.Company_Division__c = employeeRole.Company_Division__c;
//         employeeManager.Tickets_Created__c = false; 
//         INSERT employeeManager;
        
//         System.debug('EMPLOYEE MANAGER: ' + employeeManager);        
//         /** Select Account
// List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
// FROM Account
// WHERE Name='Tuffsteel Ltd'];*/         
        
//         /*List<Employee__c> employee = [SELECT id,Line_Manager__c FROM Employee__c
// WHERE Sanergy_Department__c != null
// AND Sanergy_Department_Unit__c != null
// AND Sanergy_Department_Unit__r.Approver__c != null
// AND Employee_Active__c = true
// LIMIT 1];*/
//         //*********************************************************************************
        
//         // Create Employee        
//         employee.Name = 'Jason';
//         employee.Employee_First_Name__c = 'Jason';
//         employee.Employee_Last_Name__c = 'Statham';
//         employee.Recruitment_Requisition__c = recruitmentRequisition.Id;
//         employee.Primary_Phone__c = '0712345678';
//         employee.Employment_Start_Date__c = date.today()+50;
//         employee.Employee_Active__c = true;
//         employee.Employment_Status__c = 'Permanent';
//         employee.Employee_Role__c = employeeRole.Id;
//         employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
//         employee.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
//         employee.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
//         employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
//         employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
//         employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
//         employee.Talent_Partner__c = 'aAsD0000000GmgM';
//         employee.Sanergy_Department__c = sanergyDept.Id;
//         employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;

        
//         INSERT employee;    
        
//         System.debug('EMPLOYEE : ' + employee);
//         //***************************************************************************        
        
//         //if(employee.size() > 0){
        
//         employee.Allowance_Approver__c = UserInfo.getUserId();
//         UPDATE employee;
        
//         //Create Staff Allowance
//         Staff_Allowances__c staffAllowance = new Staff_Allowances__c();
//         staffAllowance.Employee__c = employee.Id;
//         staffAllowance.Allowance_Frequency__c = 'Monthly';
//         staffAllowance.isActive__c = true;
//         staffAllowance.Verified__c = true;
//         staffAllowance.Allowance_Description__c = 'Test Allowance Description';
//         staffAllowance.Voice_Mobile_Network__c = 'Safaricom';
//         staffAllowance.Voice_Mobile_Number__c = '+254722222222';
//         staffAllowance.Voice_Amount__c = 2000;
//         staffAllowance.Start_Date__c = Date.today().toStartOfMonth();
//         staffAllowance.End_Date__c = Date.today().addMonths(1);
//         staffAllowance.Last_Verified_Date__c = Date.today();
//         staffAllowance.Allowance_Type__c = 'Meal Allowance';
//         staffAllowance.Department_Unit__c = sanergyDeptUnit.Id;
//         staffAllowance.Sanergy_Department__c = sanergyDept.Id;
//         INSERT staffAllowance; // This will test the AutofilEmployeeDetails trigger.
        
//         // Set the current user as the approver
//         staffAllowance.Approver__c = UserInfo.getUserId();
//         UPDATE staffAllowance;
        
//         // Create a Currency Config
//         Currency_Config__c cc = new Currency_Config__c();
//         cc.Name = 'KSH';
//         cc.Start__c = date.today();
//         cc.End__c = date.today();
//         cc.Value__c = 1;
//         cc.Currency_Name__c='Kenyan Shilling';
//         cc.Current__c = true;
//         INSERT cc;
        
        
//         // Create a Contract            
//         Contract c = new Contract();
//         c.AccountId = accounts.Id; 
//         c.Status = 'Draft';
//         c.StartDate = date.today();
//         c.ContractTerm = 1;
//         c.CurrencyIsoCode = 'KES';
//         c.Payment_Terms__c = '7 Days';
//         c.Primary_Contract__c = true;
//         INSERT c;
        
//         // Create Inventory_UoM__c
//         Inventory_UoM__c iUom = new Inventory_UoM__c();
//         iUom.Name = 'Dummy Inventory UOM 1';
//         iUom.Description__c = 'Dummy Inventory UOM one';
//         iUom.Uom_Code__c = '101';
//         iUom.CurrencyIsoCode = 'KES';
//         INSERT iUom;
        
//         // Create Inventory_Item_Group__c
//         Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
//         invItemGroup.Name = 'New Inventory Item Group';
//         invItemGroup.Commodity_Code__c = 'New Commodity code';
//         invItemGroup.Description__c = 'Brief description';                
//         INSERT invItemGroup;
        
//         Group_Details__c debitAc = new Group_Details__c();
//         debitAc.Inventory_Item_Group__c = invItemGroup.Id;
//         debitAc.Credit_Debit__c = 'Debit'; 
//         debitAc.Transaction_ID__c = 'PORCPT';
//         debitAc.Is_GL_Account__c = true;
//         debitAc.Config_Account__c = gla.get(0).Id;            
//         INSERT debitAc;
        
//         Group_Details__c creditAc = new Group_Details__c();
//         creditAc.Inventory_Item_Group__c = invItemGroup.Id;
//         creditAc.Credit_Debit__c = 'Credit'; 
//         creditAc.Transaction_ID__c = 'PORCPT';
//         creditAc.Is_GL_Account__c = true;
//         creditAc.Config_Account__c = gla.get(1).Id;        
//         INSERT creditAc;
        
//         // Create Inventory Location
//         Inventory_Location__c site = new Inventory_Location__c();
//         site.Name = 'Mukuru';
//         INSERT site;
        
//         // Create Inventory_Item__c
//         Inventory_Item__c invItem = new Inventory_Item__c();
//         invItem.Name='Inventory Item 1'; 
//         invItem.Item_Number__c = '123456';
//         invItem.Item_Description__c = 'brief description';
//         invItem.Item_Type__c = 'Stock';
//         invItem.Item_Company__c = company.get(0).Id;
//         invItem.Responsible_Department__c = department.get(0).Id;
//         invItem.Inventory_UoM__c = iUom.Id;
//         invItem.Item_Group__c = invItemGroup.Id;
//         invItem.Default_Location__c = 'Mukuru';
//         invItem.Default_Lot__c = '3';
//         invItem.Currency_Config__c = cc.Id;
//         invItem.unit_cost__c = 20;            
//         INSERT invItem;
        
//         System.debug('CREATE INVENTORY ITEM: ' + invItem);                
        
//         //Create Inventory Item Location
//         Inventory_Item_Location__c inventoryItemLocation  = new Inventory_Item_Location__c();
//         inventoryItemLocation.Location_Name__c = '001';
//         inventoryItemLocation.Inventory_Item__c = invItem.Id;
//         inventoryItemLocation.Location__c = site.Id;
//         inventoryItemLocation.Max_Location_Quantity__c = 100000;
//         INSERT inventoryItemLocation;
        
//         System.debug('CREATE INVENTORY ITEM LOCATION: ' + inventoryItemLocation);
        
//         //Create Item Location Lot
//         Item_Location_Lot__c itemLocationLot = new Item_Location_Lot__c();
//         itemLocationLot.Item_Location__c = inventoryItemLocation.Id;
//         itemLocationLot.Lot_Name__c  = '001';
//         itemLocationLot.Quantity__c = 100000;
//         INSERT itemLocationLot;
        
//         System.debug('CREATE ITEM LOCATION LOT: ' + itemLocationLot);  
        
//         //Create Purchase Order Item
//         Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
//         poItem.Name = 'PO Item 1';
//         poItem.Item_Description__c = 'brief description';
//         poItem.Inventory_Item__c = invItem.Id; 
//         poItem.Purchase_UoM__c = iUom.Id;
//         poItem.UOM_Conversion_Factor__c = 1;
//         // poItem.Contract_Number__c = c.Id;
//         poItem.Status__c= 'Active';
//         poItem.Approved__c = true;   
//         poItem.Primary_Vendor__c= true; 
//         poItem.Vendor__c = '001D000001ssdn6'; 
//         poItem.Currency__c = cc.Id;   
//         poItem.Department_Team_Lead__c = UserInfo.getUserId();
//         INSERT poItem;
        
//         System.debug('CREATE PO ITEM: ' + poItem);          
        
//         //Create PR
//         Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
//         pr.Requestor_Type__c = 'Employee';
//         pr.Required_Date__c = Date.today() + 14;
//         pr.Requesting_Department__c = department.get(0).id;
//         pr.Maintenance_Department__c = department.get(0).id;
//         pr.Priority__c = 'Low';
//         pr.Remarks__c = 'Some remarks'; 
//         pr.Requestor__c = employee.Id;
//         pr.High_Priority_Comments__c = 'comment';
//         pr.Requesting_Company__c = invItem.Item_Company__c;
//         pr.Is_Retrospective__c = 'No';
//         INSERT pr;
        
//         System.debug('CREATE PR: ' + pr); 
        
//                 //Create PR
//         Procurement_Tracking_Sheet__c pr2 = new Procurement_Tracking_Sheet__c();
//         pr2.Requestor_Type__c = 'Employee';
//         pr2.Required_Date__c = Date.today() + 14;
//         pr2.Requesting_Department__c = department.get(0).id;
//         pr2.Maintenance_Department__c = department.get(0).id;
//         pr2.Priority__c = 'Low';
//         pr2.Remarks__c = 'Some remarks'; 
//         pr2.Requestor__c = employee.Id;
//         pr2.High_Priority_Comments__c = 'comment';
//         pr2.Requesting_Company__c = invItem.Item_Company__c;
//         pr2.Is_Retrospective__c = 'NO';
//         pr2.PR_Source__c = 'Special Payment Request';
//         pr2.Stage__c ='Open';
//         INSERT pr2;
        
//         System.debug('CREATE PR22222222222222222: ' + pr2);  
        
//         //Create PRLine
//         PTS_Line_Item__c prItem2 = new PTS_Line_Item__c();        
//         prItem2.Procurement_Tracking_Sheet__c = pr2.Id;
//         prItem2.Department__c = department.get(0).id;
//         prItem2.Inventory_Item__c = invItem.Id;
//         prItem2.Requesting_Company__c = invItem.Item_Company__c;
//         prItem2.Item__c = 'Test Item';
//         prItem2.Override_PR_Item_Cost_Check__c = true;
//         prItem2.Override_Justification__c = 'just';
//         prItem2.Specifications__c = 'Test Specifications';
//         prItem2.Quantity__c = 1000;
//         prItem2.Budget_Amount__c= 1000000000;
//         prItem2.Currency_Config__c = cc.id; 
//         prItem2.Purchase_Order_Item__c = poItem.id; 
//         prItem2.non_primary_vendor_description__c = 'comment';
//         prItem2.RequestType__c = 'Stock';
//         INSERT prItem2;         
        
//         // Create an approval request for the account
//         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
//         req1.setComments('Submitting request for approval.');
//         req1.setObjectId(pr2.Id);
//         /*
//         ProcessInstanceWorkItem pi = [SELECT Id, ActorId FROM ProcessInstanceWorkItem LIMIT 1];
//         pi.ActorId = '0051I0000027LCVQA2';
//         update pi;
//         */
//         //Create Special Procurement               
//         Special_Procurement__c sp1 = new Special_Procurement__c();
//         sp1.Requestor__c = 'aAsD0000000GmgM';
//         sp1.Type__c = 'Special Procurement';
//         sp1.Required_Date__c = date.today();
//         sp1.Comments__c = 'Two tyres for Toyota Corolla';         
//         sp1.Requesting_Department__c = department.get(0).Id;
//         sp1.Vendor__c = poItem.Vendor__c;//'001D000001ssdn6';
        
//         // sp1.Approval_Status__c = 'Open';
//         sp1.Dim_2__c = dim2.get(0).Id;
//         sp1.Dim_3__c = dim3.get(0).Id;
//         sp1.GLA__c = gla.get(0).Id;
//         sp1.Grant__c = dim4.get(0).Id;
//         sp1.Requesting_Company__c = company.get(0).Id;
//         //  sp1.Requires_PR__c = true;
//         sp1.Stage__c = 'Open';
//         INSERT sp1;
        
//         System.debug('SPR: ' + sp1.Requesting_Company__c);
         
//          //Create Special Procurement Line Items
// 		 Special_Procurement_Line_Item__c spLineItems1 = new Special_Procurement_Line_Item__c();
//          spLineItems1.Special_Procurement__c = sp1.Id;
//          spLineItems1.Item__c = 'Two 18 Inch Car Tyress';
//          spLineItems1.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
//          spLineItems1.Quantity_Requested__c = 2;
//          spLineItems1.Unit_Price__c = 600;
//          spLineItems1.Create_PR_Line_Item__c = true;
//        //  spLineItems1.Status__c = 'Approved';
//         spLineItems1.Request_Type__c = 'Stock';  
//         spLineItems1.EPR_Created__c = false;
//         spLineItems1.Purchase_Order_Item__c = poItem.ID;
            
//          INSERT spLineItems1;
                
//         //Create PR
//         Procurement_Tracking_Sheet__c pr1 = new Procurement_Tracking_Sheet__c();
//         pr1.Requestor_Type__c = 'Employee';
//         pr1.Required_Date__c = Date.today() + 14;
//         pr1.Requesting_Department__c = department.get(0).id;
//         pr1.Maintenance_Department__c = department.get(0).id;
//         pr1.Priority__c = 'Low';
//         pr1.Remarks__c = 'Some remarks'; 
//         pr1.Requestor__c = employee.Id;
//         pr1.High_Priority_Comments__c = 'comment';
//         pr1.Requesting_Company__c = invItem.Item_Company__c;
//         pr1.Is_Retrospective__c = 'NO';
//         pr1.Special_Payment_Request__c = sp1.id;
//         pr1.PR_Source__c = 'Special Payment Request';
//         pr1.Stage__c ='Open';
//         INSERT pr1;
        
//         System.debug('CREATE PR1111111111111111111111111: ' + pr1);  
        
//         //Create PRLine
//         PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
//         prItem.Procurement_Tracking_Sheet__c = pr.Id;
//         prItem.Department__c = department.get(0).id;
//         prItem.Inventory_Item__c = invItem.Id;
//         prItem.Requesting_Company__c = invItem.Item_Company__c;
//         prItem.Item__c = 'Test Item';
//         prItem.Override_PR_Item_Cost_Check__c = true;
//         prItem.Override_Justification__c = 'just';
//         prItem.Specifications__c = 'Test Specifications';
//         prItem.Quantity__c = 1000;
//         prItem.Budget_Amount__c= 1000000000;
//         prItem.Currency_Config__c = cc.id; 
//         prItem.Purchase_Order_Item__c = poItem.id; 
//         prItem.non_primary_vendor_description__c = 'comment';
//         prItem.RequestType__c = 'Stock';
//         prItem.GLA__c = gla.get(0).Id;
//         prItem.Override_Gla__c = true;        
//         INSERT prItem; 
        
//         pr.Team_Lead_Approval_Status__c = 'Approved';
//         pr.Stage__c= 'Team Lead Approved';
//         UPDATE pr;
        
//         prItem.Status__c = 'Pending Purchase Order';
//         UPDATE prItem;
        
//         //Create Purchase Order
//         Purchase_Order__c po =new Purchase_Order__c();
//         po.Vendor_Account__c = '001D000001ssdn6'; //accounts.Id;
//         po.Company__c = company.get(0).Id;
//         po.PO_Currency__c = cc.Id;
//         po.Order_Status__c = 'Open'; 
//         po.Is_Retrospective__c = 'NO';
//         INSERT po;
        
//         //Create Purchase Order Line Item
//         Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
//         poLine.Name = 'Purchase Order Line Item 1';
//         poLine.Purchase_Order__c = po.Id;
//         poLine.Purchase_Order_Item__c = poItem.Id;
//         poLine.PTS_Line_Item__c = prItem.id;
//         poLine.Item__c = 'Test Item';
//         poLine.Quantity_Requested__c = 1;
//         poLine.Unit_Price__c = 100;
//         poLine.Vatable__c = true;
//         poLine.VAT_inclusive__c = true;
//         poLine.VAT_Percentage__c = '16';
//         poLine.Variation_Notes__c = 'notes';
//         poLine.Dimension_1__c = department.get(0).id;
//         poLine.Terms_Conditions__c = 'Some Terms';
//         poLine.Requesting_Company__c=company.get(0).Id; 
//         poLine.Variation_Notes__c = 'variation notes'; 
//         poLine.Status__c = 'Open';            
//         INSERT poLine;
        
        
//         // Create Vendor Invoice
//         Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
//         vi.Vendor__c = po.Vendor_Account__c;
//         vi.Currency_Config_Currency__c = po.PO_Currency__c;
//         //vi.Contract_Number__c = c.Id;                        
//         vi.Status__c='Open';            
//         INSERT vi;
        
//         // Create Vendor Invoice Item
//         Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
//         viItems.Vendor_Invoice__c = vi.Id ;
//         viItems.Purchase_Order_Line_Item__c = poLine.Id;
//         viItems.Company__c = company.get(0).Id;
//         viItems.Quantity__c = 4;
//         viItems.Status__c='Pending GIGO Check';
//         viItems.Closed__c = false;            
//         INSERT viItems;
        
//         poLine.Invoice_Assigned__c = true;
//         UPDATE poline;
        
//         viItems.Accepted_Receive_Quantity__c = 1;
//         viItems.Status__c = 'GIGO Checked';
//         UPDATE viItems;
        
//         //create EPR
//         Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c();
//         epr.department__c=department.get(0).Id;
//         epr.Company__c='Sanergy Ltd';
//         epr.Vendor_Company__c=vi.Vendor__c;
//         epr.Invoice_Number__c='INVOICE1234'; 
//         epr.Vendor_Invoice_Number__c = vi.Id;
//         epr.Scheduled_Payment_Date__c=Date.today();              
//         epr.Payment_Type__c='Prepayment';
//         epr.Preferred_Payment_Method__c = 'Check';
//         epr.Status__c='Open';
//         epr.Team_Lead_Approval_Status__c=null;          
//         INSERT epr;      
//         //create EPR
//         Electronic_Payment_Request__c epr1=new Electronic_Payment_Request__c();
//         epr1.department__c=department.get(0).Id;
//         epr1.Company__c='Sanergy Ltd';
//         epr1.Vendor_Company__c=vi.Vendor__c;
//         epr1.Invoice_Number__c='INVOICE1234'; 
//         epr1.Vendor_Invoice_Number__c = vi.Id;
//         epr1.Scheduled_Payment_Date__c=Date.today();              
//         epr1.Payment_Type__c='Prepayment';
//         epr1.Preferred_Payment_Method__c = 'Check';
//         epr1.Status__c='Open';
//         epr1.Team_Lead_Approval_Status__c=null;          
//         INSERT epr1; 
        
//         //test.startTest();
//         //Create EPR Line items
//         EPR_Payable_Item__c eprPayable=new EPR_Payable_Item__c();
//         eprPayable.EPR__c=epr.id;
//         eprPayable.Item__c='test Item';
//         eprPayable.Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1;
//         eprPayable.Quantity__c=1;
//         eprPayable.Department_dim1__c=department.get(0).Id;
//         eprPayable.Location_Dim2__c=location.get(0).Id;
//         eprPayable.Dim_3__c=dim3.get(0).Id;
//         eprPayable.Grant_Funding_Availale_dim4__c=grant.get(0).Id;
//         eprPayable.GLA__c=gla.get(0).Id;    
//         INSERT eprPayable;
        
//         epr.Status__c = 'Line Manager Approved';
//         UPDATE epr;
//        // test.stopTest();
        
//         //Create Leave Group
//         leaveGroup.Name = 'Permanent - Full Times';        
//         leaveGroup.Leave_Group__c = 'Full Time';
//         INSERT leaveGroup;
        
//         System.debug('LEAVE GROUP: ' + leaveGroup);
        
//         // Create Leave Entitlement Type Config
//         Leave_Entitlement_Type_Config__c leaveTypeConfig = new Leave_Entitlement_Type_Config__c();
//         leaveTypeConfig.Leave_Group__c = leaveGroup.Id;
//         leaveTypeConfig.Leave_Type__c = 'Annual Leave';
//         leaveTypeConfig.Year__c = 2018;
//         leaveTypeConfig.Total_No_of_Leave_Days__c = 21;
//         //leaveTypeConfig.Proratable__c = true;
//         INSERT leaveTypeConfig;
        
//         System.debug('LEAVE TYPE CONFIG: ' + leaveTypeConfig);       
        
//         // Create Leave Entitlement Utilization
//         Leave_Entitlement_Utilization__c leaveUtilization = new Leave_Entitlement_Utilization__c();
//         leaveUtilization.Leave_Entitlement_Type_Config__c = leaveTypeConfig.Id;
//         leaveUtilization.Employee__c = employee.Id;
//         leaveUtilization.Total_No_of_Leave_Days__c = 10;
//         INSERT leaveUtilization;
        
//         System.debug('LEAVE UTILIZATION: ' + leaveUtilization);    
        
//         // Create Employee Leave Request
//         Employee_Leave_Request__c  leaveRequest = new Employee_Leave_Request__c();
//         leaveRequest.Leave_Entitlement_Utilization__c = leaveUtilization.Id;
//         leaveRequest.Employee__c =  employee.Id;
//         leaveRequest.Leave_Start_Date__c = date.today();
//         leaveRequest.Leave_End_Date__c = date.today() + 3;
//         leaveRequest.Employee_s_Department__c = sanergyDeptUnit.Id;
//         leaveRequest.Department_Team_Lead__c = sanergyDeptUnit.Approver__c; 
//         leaveRequest.Line_Manager_Account__c = UserInfo.getUserId();
//         INSERT leaveRequest;        
        
        
//         // Get the EPR we just updated            
//         Approval.ProcessSubmitRequest appEpr = new Approval.ProcessSubmitrequest();
//         appEpr.setObjectId(epr.Id);                
//         Approval.ProcessResult result1 = Approval.process(appEpr);
        
//         // Update the Procurement Tracking Sheet
//         pr.Maintenance_TL__c=UserInfo.getUserId();
//         pr.Team_Ld__c= UserInfo.getUserId();                          
        
//         UPDATE pr;
        
//         // Get the Procurement Tracking Sheet we just updated
//         Approval.ProcessSubmitRequest appPr = new Approval.ProcessSubmitrequest();
//         appPr.setObjectId(pr.Id);              
//         Approval.ProcessResult result2 = Approval.process(appPr);
        
//         /* -- This is gigiving an error for Too many retries of batch save in the presence of Apex triggers with failures:
//         // Get the SPR Process
//         Approval.ProcessSubmitRequest appspr = new Approval.ProcessSubmitrequest();
//         appspr.setObjectId(sp1.Id);              
//         Approval.ProcessResult result22 = Approval.process(appspr);  
//         */
        
//         // Get the Purchase Order we just created                 
//         Approval.ProcessSubmitRequest appPo = new Approval.ProcessSubmitrequest();
//         appPo.setObjectId(po.Id); 
//         Approval.ProcessResult result3 = Approval.process(appPo);
        
//         // Get the Leave Request we just created                 
//         Approval.ProcessSubmitRequest appELR = new Approval.ProcessSubmitrequest();
//         appELR.setObjectId(leaveRequest.Id); 
//         Approval.ProcessResult resultELR = Approval.process(appELR);
        
//         // Get the PO Item we just created
//         poItem.Status__c= 'Created';
//         //UPDATE poItem;
//         //Approval.ProcessSubmitRequest appPOI = new Approval.ProcessSubmitrequest();
//         //appPOI.setObjectId(poItem.Id); 
//         //Approval.ProcessResult resultPOI = Approval.process(appPOI);
         
//         // Get the Recruitment Requisition Item we just created                 
//         Approval.ProcessSubmitRequest appRecReq = new Approval.ProcessSubmitrequest();
//         appRecReq.setObjectId(recruitmentRequisition.Id); 
//         //Approval.ProcessResult resultRecReq = Approval.process(appRecReq);
        
//         // Get the Employee Role Item we just created                 
//         Approval.ProcessSubmitRequest appEmpRole = new Approval.ProcessSubmitrequest();
//         appEmpRole.setObjectId(employeeRole.Id); 
//         //Approval.ProcessResult resultEmpRole = Approval.process(appEmpRole);
        
//         List<Id> newWorkItemIds = result3.getNewWorkitemIds();
//         Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
//         req2.setAction('Approve');
//         req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
//         req2.setWorkitemId(newWorkItemIds.get(0));
//         Approval.ProcessResult result4 = Approval.process(req2);  
        
//         //Reassign to current user
//         Set<Id> AppObjectIds = new Set<Id>();
//         AppObjectIds.add(pr.id);
//         AppObjectIds.add(po.Id);
//         AppObjectIds.add(epr.id);
//         AppObjectIds.add(leaveRequest.Id);
//         AppObjectIds.add(poItem.Id);
//         AppObjectIds.add(recruitmentRequisition.id);
//         AppObjectIds.add(employeeRole.Id);
//         List<ProcessInstanceWorkItem> pi = [SELECT Id, ActorId FROM ProcessInstanceWorkItem 
//                                       WHERE ProcessInstance.TargetObjectId IN : AppObjectIds];
//         //loop through and assign to current user
//         for(ProcessInstanceWorkItem item: pi){
//             item.ActorId = UserInfo.getUserId();
//         }
        
//         UPDATE pi;
      
//         test.stopTest();
//         /*
//         List<Fleet_Request__c> fleet = [SELECT id, Team_Lead__c FROM Fleet_Request__c
//                                         WHERE Status__c = 'Line Manager Approved'
//                                         OR Status__c = 'Request Competed'
//                                         ORDER BY Name DESC
//                                         LIMIT 1];
        
//         if(fleet.size() > 0){
//             fleet.get(0).Team_Lead__c=UserInfo.getUserId();
//             update fleet;
//             System.debug('FLEET:'+fleet.get(0).id);
            
//             Approval.ProcessSubmitRequest appFleet = new Approval.ProcessSubmitrequest();
//             appFleet.setObjectId(fleet.get(0).id);
//             Approval.ProcessResult result = Approval.process(appFleet);
            
//             //move approval to TL
//             List<ProcessInstanceWorkitem> workItem = [Select p.Id, ProcessInstance.TargetObjectId 
//                                                       from ProcessInstanceWorkitem p                                                           
//                                                       WHERE ProcessInstance.TargetObjectId = :fleet.get(0).id
//                                                       LIMIT 1];
//             if(workItem.size()>0){
//                 Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
//                 req.setComments('Approve');
//                 req.setAction('Approve');
                
//                 req.setWorkitemId(workItem.get(0).id);
//                 Approval.process(req);
//             }                                        
//         }
        
          
//          List<Casuals_Job__c> job = [SELECT id, Team_Lead__c,Start_Date__c, End_Date__c
//                                         FROM Casuals_Job__c
//                                         WHERE Expected_Total_Amount__c > 0
//                                         ORDER BY Name DESC
//                                         LIMIT 1];
            
//             if(job.size() > 0){
//                 job.get(0).Team_Lead__c=UserInfo.getUserId();
//                 job.get(0).Start_Date__c=Date.today();
//                 job.get(0).End_Date__c=Date.today()+24;
//                 update job;
                
//                 Approval.ProcessSubmitRequest appJob = new Approval.ProcessSubmitrequest();
//                 appJob.setObjectId(job.get(0).id); 
//                 try{
                    
//                 }catch(Exception e){
//                     Approval.ProcessResult result = Approval.process(appJob);
//                 } 
//             }
//            */

 
//         PageReference pageRef = Page.BulkApprovalController;
//         Test.setCurrentPage(pageRef);
//         //create instance of BulkApprovalController controller
//         BulkApprovalController controller = new BulkApprovalController();
       
//         /*  String objectType = apexpages.currentpage().getParameters().get('objectType');
// if(objectType  == null){
// objectType = '.';
// }

// BulkApprovalController.ApprovalsWrapper app_wrapper = new BulkApprovalController.ApprovalsWrapper(objectType, id objectId, ProcessInstanceWorkitem workItem);
// */ 
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperEPRs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
//        }      
                    
       
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperSPRs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getMaintenanceTaskWrapper()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperRecruitRequisition()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperEmpRoles()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }       
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperELRs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPRs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
//         }
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPRLINEs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
//         }
//         /*
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperFLEET()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
//         }
        
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperJOBs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
//         }
// 		*/
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPOs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }
//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPOIs()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
            
//         }

//         for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperALLOWANCES()){
//             w.selectedApprovalOption = 'Approve';
//             pageRef.getParameters().put('objectType', w.objectType);
//             controller.save();
//         }        
//        // Test.stopTest();
//         //get approvals
//         controller.getWrapperALLOWANCES();
//         //mark allowances reject
//         controller.markAllAllowancesRej();
        
//         //mark allowances approve
//         controller.markAllAllowancesApp();
//         controller.getPURCHASE_ORDER_ITEM();        
//         controller.getEPR_NAME();
//         controller.getPR_NAME();
//         controller.getPR_LINE_NAME();
//         //controller.getFLEET_NAME();
//         //controller.getCONTRACTOR_JOB_NAME();
//         controller.getSTAFF_ALLOWANCES_NAME();
//         controller.getPURCHASE_ORDER_NAME(); 
        
//         controller.getSPECIAL_PROCUREMENT_NAME();
//         controller.getRECRUITMENT_REQUISITION();
//         controller.getEMPLOYEE_Role();
//         controller.getASSET_MAINTENANCE_TASK();
        
//         //Approve Allowances
//         controller.saveAllowanceActions();
        
//         controller.save();
//         controller.a();
//         //controller.b();
//         //controller.c();
//         //controller.d();
//         //controller.e();
        
//         //}
    }
}