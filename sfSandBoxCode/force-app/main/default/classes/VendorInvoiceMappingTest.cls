@isTest (seeAllData = true)
public class VendorInvoiceMappingTest {
    static testMethod void VendorInvoiceMappingTest(){
        Boolean  ishide;
        //  VendorInvoiceMappingTest vimp = new VendorInvoiceMappingTest();  
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true LIMIT 2];      
        
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
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
        
        //Create Inventory Item
        Inventory_item__c invItem = new Inventory_item__c();
        invItem.Name = 'Sugar';
        invItem.Item_Number__c = '123456';
        invItem.Item_Description__c = 'Item Description';
        invItem.Item_Type__c = 'Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Inventory_UoM__c = uom.Id;
        invItem.Currency_Config__c = curr.Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Policy_Quantity__c = 10;
        invItem.Minimum_Quantity__c = 2;
        invItem.Item_Group__c = comCode.Id;
        invItem.unit_cost__c = 100;
        invItem.Default_Site__c = site.Id;
        invItem.Default_Location__c = '1';
        invItem.Default_Lot__c = '1';
        invItem.Planning_Policy__c = 'No MRP Planning';        
        INSERT invItem;
        
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
        Purchase_Order_Item__c poItem = new Purchase_Order_Item__c();
        poItem.Name = 'Item';
        poItem.Item_Description__c = 'Item Desc';
        poItem.Currency__c = curr.id;
        poItem.Inventory_Item__c = invItem.Id;
        poItem.Purchase_UoM__c = uom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = contract.Id;
        poItem.Vendor__c = contract.AccountId;
        poItem.Status__c = 'Active';
        poItem.Approved__c = true;         
        INSERT poItem;
        
        //Create PR
        Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
        pr.Requestor_Type__c = 'Employee';
        pr.Required_Date__c = Date.today() + 14;
        pr.Requesting_Department__c = department.get(0).id;
        pr.Maintenance_Department__c = department.get(0).id;
        pr.Priority__c = 'Low';
        pr.Remarks__c = 'Some remarks'; 
        pr.Requestor__c = employee.get(0).id;
        pr.High_Priority_Comments__c = 'comment';
        pr.Requesting_Company__c = invItem.Item_Company__c;
        //pr.Is_Retrospective__c = 'Yes';
        INSERT pr;
        
        test.startTest();
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Dim_2__c = dim2.get(0).id;
        prItem.Dim_3__c = dim3.get(0).id;
        prItem.Grant__c = dim4.get(0).id;
        prItem.GLA__c = gla.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Commodity_Code_Gla__c = gla.get(0).id;
        prItem.Override_Gla__c = true;
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 10;
        prItem.Budget_Amount__c= 10;
        prItem.Currency_Config__c = curr.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        INSERT prItem; 
        
        //Update PR
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        UPDATE pr;
        
        //Update PR Line Item
        prItem.Status__c = 'Pending Purchase Order';
        prItem.Purchase_Order_Item__c = poItem.id;
        UPDATE prItem;
        
        test.stopTest();
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = accounts.Id;
        po.Company__c = company.get(0).id;
        po.PO_Currency__c = curr.id;
        po.Firm_Date__c = Date.today();
        
        insert po;
        
        //create PO Lines
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Purchase_Order__c = po.id;
        poLine.Purchase_Order_Item__c = poItem.id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 1;
        poLine.Unit_Price__c = 1;
        poLine.Vatable__c = false;
        // poLine.VAT_inclusive__c = fals;
        // poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Dimension_2__c = dim2.get(0).id;
        poLine.Dimension_3__c = dim3.get(0).id;
        poLine.Dimension_4__c = dim4.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.GLA__c = gla.get(0).id;
        poLine.Requesting_Company__c = invItem.Item_Company__c;        
        INSERT poLine;
        
        
        //create PO Lines
        /*  Purchase_Order_Line_Item__c poLine2 = new Purchase_Order_Line_Item__c();
poLine2.Purchase_Order__c = po.id;
poLine2.Purchase_Order_Item__c = poI.id;
poLine2.PTS_Line_Item__c = prItem.id;
poLine2.Item__c = 'Test Item';
poLine2.Quantity_Requested__c = 1;
poLine2.Unit_Price__c = 1;
poLine2.Vatable__c = false;
// poLine2.VAT_inclusive__c = true;
//   poLine2.VAT_Percentage__c = '16';
poLine2.Variation_Notes__c = 'notes';
poLine2.Dimension_1__c = department.get(0).id;
poLine2.Dimension_2__c = dim2.get(0).id;
poLine2.Dimension_3__c = dim3.get(0).id;
poLine2.Dimension_4__c = dim4.get(0).id;
poLine2.Terms_Conditions__c = 'Some Terms';
poLine2.GLA__c = gla.get(0).id;
poLine2.Requesting_Company__c = invItem.Item_Company__c;
poLine2.Status__c = 'Open';
poLine2.Last_Invoice__c = true;
poLine2.Name = 'POL1-2020';
INSERT poLine2;  */          
        
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
        INSERT vi1;        
        
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 1;
        VIPOLI.Item_Received_Total__c = 1;
        VIPOLI.Item_Unit_Cost__c = 0;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 11;
        VIPOLI.Reconciled_Line_Total__c =12;
        //  VIPOLI.Vendor_Invoice__c = 'aHiD0000000Kyta';
        VIPOLI.Last_Invoice__c = true;
        VIPOLI.Vendor_Invoice__c = VI.Id;
        INSERT VIPOLI; 
        ishide = true;

        //Attempt to delete VIPOLIto test VendorInvoicePOTrigger        
        Vendor_Invoice_PO__c vipo = new Vendor_Invoice_PO__c();
        vipo.Purchase_Order__c = po.id;
        vipo.Vendor_Invoice__c = vi.id;
        INSERT vipo;
        UPDATE vipo;
        DELETE vipo;
        
        //Attempt to delete VIPOLIto test VendorInvoicePOTrigger
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLIClone= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLIClone.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLIClone.Last_Invoice__c = FALSE;
        VIPOLIClone.Requested_Quantity__c = 1;
        VIPOLIClone.Item_Received_Total__c = 1;
        VIPOLIClone.Item_Unit_Cost__c = 0;
        VIPOLIClone.Item_Vat__c = 0;
        VIPOLIClone.Reconciled_Item_Quantity_Received__c = 11;
        VIPOLIClone.Reconciled_Line_Total__c =12;
        VIPOLIClone.Last_Invoice__c = true;
        VIPOLIClone.Vendor_Invoice__c = VI.Id;
        INSERT VIPOLIClone; 
        DELETE VIPOLIClone;
        
        
        /* Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI2= new Vendor_Invoice_Purchase_Order_Line_Item__c();
VIPOLI2.Purchase_Order_Line_Item__c =  poLine2.Id;
VIPOLI2.Last_Invoice__c = FALSE;
VIPOLI2.Requested_Quantity__c = 20;
VIPOLI2.Item_Received_Total__c = 10;
VIPOLI2.Item_Unit_Cost__c = 0;
VIPOLI2.Item_Vat__c = 0;
VIPOLI2.Reconciled_Item_Quantity_Received__c = 0;
VIPOLI2.Reconciled_Line_Total__c =0;
// VIPOLI2.Vendor_Invoice__c = 'aHiD0000000Kyta';
VIPOLI2.Last_Invoice__c = True;
VIPOLI2.Purchase_Order_Line_Item__c = poLine2.Id;
VIPOLI2.Vendor_Invoice__c = VI.Id;
Insert VIPOLI2; 
*/
        
        Vendor_Invoice_Items__c vii = new Vendor_Invoice_Items__c();
        vii.Purchase_Order_Line_Item__c = poLine.Id;
        vii.Quantity__c = 1;
        Vii.CurrencyIsoCode = 'KES';
        vii.Vendor_Invoice_Purchase_Order_Line_Item__c = VIPOLI.Id;
        vii.Company__c = invItem.Item_Company__c;
        vii.Vendor_Invoice__c = vi.Id;
        INSERT vii;
        
        
        VendorInvoiceMapping.ItemWrapper ItemWrapperClass = new VendorInvoiceMapping.ItemWrapper(VIPOLI);
        VendorInvoiceMapping.ItemWrapper ItemWrapperClass2 = new VendorInvoiceMapping.ItemWrapper(VIPOLI);
        VendorInvoiceMapping.PoliWrapper PoliWrapperClass = new VendorInvoiceMapping.PoliWrapper(poLine);
        VendorInvoiceMapping.PoliClosedWrapper PoliClosedWrapperClass = new VendorInvoiceMapping.PoliClosedWrapper(poLine);
        
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vi);
        VendorInvoiceMapping vim = new VendorInvoiceMapping(controller); 
        
        vim.getVendorInvoicePurchaseOrderLineItems();
        ItemWrapperClass.selected = TRUE;
        
        vim.getpoItems();
        vim.getpoItemsClosed();
        vim.Rows();
        vim.selectAll();
        vim.saveVI();
        
        PoliWrapperClass.selected = TRUE;
        vim.selectAllPOLI();
        vim.Ro();
        vim.testSelectUnselect();
        vim.CallReconcilePage();
        vim.CalculateTotals();
        
        //Test Exceptions
        vi.Invoice_Total__c = NULL;
        vi.Reconciled__c = FALSE;
        UPDATE vi;
        
        //vipoli.Status__c = 'Open';
        UPDATE vipoli;
        
        poLine.Payment_Variance__c = 'Test 123';
        poLine.Receipt_Variance__c = 'Test 123';
        poLine.Status__c = 'Open';
        UPDATE poline;
        
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(vi);
        VendorInvoiceMapping vim2 = new VendorInvoiceMapping(controller2); 
        
        ItemWrapperClass2.selected = TRUE;
        vim2.getVendorInvoicePurchaseOrderLineItems();
        vim2.getpoItems();
        
        vi.Invoice_Total__c = NULL;
        vi.Reconciled__c = FALSE;
        UPDATE vi;
        
        //vipoli.Status__c = 'Open';
        UPDATE vipoli;
        
        poLine.Payment_Variance__c = 'Test 123';
        poLine.Receipt_Variance__c = 'Test 123';
        poLine.Status__c = 'Open';
        UPDATE poline;
        
        //Test POLI Mapping page
        PageReference pageRef3 = Page.POLIMapping;
        pageRef3.setRedirect(true);        
        test.setCurrentPageReference(pageRef3);
        pageRef3.getParameters().put('id', vi.Id); 
        PoliWrapperClass.selected = TRUE;
        
        vim.getVendorInvoicePurchaseOrderLineItems();
        ItemWrapperClass.selected = TRUE;
        
        vim.getpoItems();
        vim.Rows();
        vim.selectAllPOLI();
        vim.ReconcilePOLI();
        
        /*
ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(vi);
VendorInvoiceMapping vim2 = new VendorInvoiceMapping(controller2); 
vim2.getVendorInvoicePurchaseOrderLineItems();
ItemWrapperClass.selected = TRUE;
vim2.getpoItems();
vim2.getpoItemsClosed();
vim2.Rows();
vim2.getpoItems();
vim2.selectAll();
vim2.saveVI();
//vim.saveAndReconcileVI();
vim2.CalculateTotals();
vim2.selectAllPOLI();
vim2.ReconcilePOLI();
//vim.Reconc();
vim2.Ro();
vim2.testSelectUnselect();
vim2.CallReconcilePage();       
*/
    }  
    static testMethod void VIPINGenerationTest(){
        Boolean  ishide;
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id, lookup_ID__c FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true AND Name='Sanergy Limited' AND isActive__c=true LIMIT 1];
        
        //Get Department 
        List<FFA_Config_Object__c> department = [SELECT id, lookup_id__c FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Name='Sanergy Operations - Supply Chain - Warehouse' LIMIT 1];      
        
        List<FFA_Config_Object__c> dim2= [SELECT id, lookup_ID__c FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id, lookup_ID__c FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id, lookup_ID__c FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id, lookup_ID__c FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
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
        
        //Create Inventory Item
        Inventory_item__c invItem = new Inventory_item__c();
        invItem.Name = 'Sugar';
        invItem.Item_Number__c = '123456';
        invItem.Item_Description__c = 'Item Description';
        invItem.Item_Type__c = 'Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Inventory_UoM__c = uom.Id;
        invItem.Currency_Config__c = curr.Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Policy_Quantity__c = 10;
        invItem.Minimum_Quantity__c = 2;
        invItem.Item_Group__c = comCode.Id;
        invItem.unit_cost__c = 100;
        invItem.Default_Site__c = site.Id;
        invItem.Default_Location__c = '1';
        invItem.Default_Lot__c = '1';
        invItem.Planning_Policy__c = 'No MRP Planning';        
        INSERT invItem;
        
        // Get Sanergy Vendor RecordType Id
        RecordType record = [SELECT Id,Name FROM RecordType WHERE Name='Sanergy Vendor'];
        
        //Account accounts = [SELECT Id,Name FROM Account WHERE Id = '001D000001CkFKH'  LIMIT 1]; //'Sanergy Ltd Vendor
              
        //Create Account
        Account accounts = new Account();
        accounts.RecordTypeId = record.Id;
        accounts.Name = 'Company XYZ';
        accounts.CurrencyIsoCode = 'KES';
        accounts.c2g__CODAAccountTradingCurrency__c = 'KES';
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
        Purchase_Order_Item__c poItem = new Purchase_Order_Item__c();
        poItem.Name = 'Item';
        poItem.Item_Description__c = 'Item Desc';
        poItem.Currency__c = curr.id;
        poItem.Inventory_Item__c = invItem.Id;
        poItem.Purchase_UoM__c = uom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = contract.Id;
        poItem.Vendor__c = contract.AccountId;
        poItem.Status__c = 'Active';
        poItem.Approved__c = true;         
        INSERT poItem;
        
        //Create PR
        Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
        pr.Requestor_Type__c = 'Employee';
        pr.Required_Date__c = Date.today() + 14;
        pr.Requesting_Department__c = department.get(0).id;
        pr.Maintenance_Department__c = department.get(0).id;
        pr.Priority__c = 'Low';
        pr.Remarks__c = 'Some remarks'; 
        pr.Requestor__c = employee.get(0).id;
        pr.High_Priority_Comments__c = 'comment';
        pr.Requesting_Company__c = invItem.Item_Company__c;
        //pr.Is_Retrospective__c = 'Yes';
        INSERT pr;
        
        test.startTest();
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Dim_2__c = dim2.get(0).id;
        prItem.Dim_3__c = dim3.get(0).id;
        prItem.Grant__c = dim4.get(0).id;
        prItem.GLA__c = gla.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Commodity_Code_Gla__c = gla.get(0).id;
        prItem.Override_Gla__c = true;
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 10;
        prItem.Budget_Amount__c= 10;
        prItem.Currency_Config__c = curr.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        INSERT prItem; 
        
        //Update PR
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        UPDATE pr;
        
        //Update PR Line Item
        prItem.Status__c = 'Pending Purchase Order';
        UPDATE prItem;
        
        test.stopTest();
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = accounts.Id;
        po.Company__c = company.get(0).id;
        po.PO_Currency__c = curr.id;
        po.Firm_Date__c = Date.today();
        
        insert po;
        
        //create PO Lines
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Purchase_Order__c = po.id;
        poLine.Purchase_Order_Item__c = poItem.id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 10;
        poLine.Unit_Price__c = 10;
        poLine.Vatable__c = false;
        // poLine.VAT_inclusive__c = fals;
        // poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Dimension_2__c = dim2.get(0).id;
        poLine.Dimension_3__c = dim3.get(0).id;
        poLine.Dimension_4__c = dim4.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.GLA__c = gla.get(0).id;
        poLine.Requesting_Company__c = invItem.Item_Company__c;     
        poLine.Last_Invoice__c = TRUE;
        poLine.Status__c = 'Firmed';
        INSERT poLine;
        
        
        //Create Vendor Invoice
        Vendor_Invoice__c vi = new Vendor_Invoice__c();
        vi.Vendor__c = po.Vendor_Account__c;
        vi.Proforma_Invoice__c= 'invTest';
        vi.Vendor_Invoice_date__c = Date.today()+5;
        vi.Currency_Config_Currency__c = po.PO_Currency__c;
        vi.Status__c = 'Items Received';
        vi.Invoice_Total__c = 100;
        vi.Reconciled__c = TRUE;
        // vi.Count_VIPOLI__c = 1;
        vi.Vendor_Invoice_date__c = Date.today()-4;
        vi.Payment_Variance__c = 'XYZ';
        vi.Receipt_Variance__c = 'YYY';
        vi.Reconciled_Invoice_Total__c = 100;
        //vi.Total_Payments__c = 100;
        insert vi;        
        
        //Create Vendor Invoice
        Vendor_Invoice__c vi1 = new Vendor_Invoice__c();
        vi1.Vendor__c = po.Vendor_Account__c;
        vi1.Proforma_Invoice__c= 'invTest';
        vi1.Vendor_Invoice_date__c = Date.today()+5;
        vi1.Currency_Config_Currency__c = po.PO_Currency__c;
        vi1.Status__c = 'Items Received';        
        INSERT vi1;        
        
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Vendor_Invoice__c = VI.Id;
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = TRUE;
        VIPOLI.Requested_Quantity__c = 10;
        VIPOLI.Item_Received_Total__c = 10;
        VIPOLI.Item_Unit_Cost__c = 10;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Status__c = 'Reconciled';
        
        //  VIPOLI.Vendor_Invoice__c = 'aHiD0000000Kyta';
        
        VIPOLI.Reconciled_Item_Quantity_Received__c = 10;
        VIPOLI.Reconciled_Line_Total__c =100;
        VIPOLI.Reconciled_Line_Net_Cost__c = 10;
        VIPOLI.Reconciled_Line_VAT__c = 0;
        VIPOLI.Last_Invoice__c = true;
        INSERT VIPOLI; 
        
        ishide = true;
        
        /* Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI2= new Vendor_Invoice_Purchase_Order_Line_Item__c();
VIPOLI2.Purchase_Order_Line_Item__c =  poLine2.Id;
VIPOLI2.Last_Invoice__c = FALSE;
VIPOLI2.Requested_Quantity__c = 20;
VIPOLI2.Item_Received_Total__c = 10;
VIPOLI2.Item_Unit_Cost__c = 0;
VIPOLI2.Item_Vat__c = 0;
VIPOLI2.Reconciled_Item_Quantity_Received__c = 0;
VIPOLI2.Reconciled_Line_Total__c =0;
// VIPOLI2.Vendor_Invoice__c = 'aHiD0000000Kyta';
VIPOLI2.Last_Invoice__c = True;
VIPOLI2.Purchase_Order_Line_Item__c = poLine2.Id;
VIPOLI2.Vendor_Invoice__c = VI.Id;
Insert VIPOLI2; 
*/
        
        
        Vendor_Invoice_Items__c vii = new Vendor_Invoice_Items__c();
        vii.Purchase_Order_Line_Item__c = poLine.Id;
        vii.Quantity__c = 1;
        Vii.CurrencyIsoCode = 'KES';
        vii.Vendor_Invoice_Purchase_Order_Line_Item__c = VIPOLI.Id;
        vii.Company__c = invItem.Item_Company__c;
        vii.Vendor_Invoice__c = vi.Id;
        INSERT vii;

        /*
               this.vi = [SELECT ID,Name, Vendor__c,Expected_Total__c,Receipt_Variance__c,Payment_Variance__c,Invoice_Number__c,
                   VI_Status__c,Invoice_Total__c,Reconciled__c,Total_Payments__c,Reconciled_Invoice_Total__c,
                   Reconciled_Received_Value__c, Comments__c, Contract_Number__c, Payment_Terms__c, Payment_Terms_Due_Date__c, 
                   Payment_Total_Reconciled_Total_Diff__c,Count_VIPOLI__c, Count_VIPOLI_Reconciled__c, Sum_VI_Items_Accepted__c, 
                   Invoice_Received_Value__c,RecordTypeId, Sum_VI_Items_Received_Value__c,Variance_Flag__c,Max_Price_Var__c,
                   Min_Price_Var__c, VI_PIN__c, Payment_Confirmed__c
                   FROM Vendor_Invoice__c
                   WHERE id =: thisVIGUID
                  ];
*/
        //create EPR
        Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c();
        epr.department__c=department.get(0).Id;
        epr.Company__c='Sanergy Ltd';
        epr.Vendor_Company__c=vi.Vendor__c;
        epr.Invoice_Number__c='INVOICE123'; 
        epr.Vendor_Invoice_Number__c = vi.Id;
        epr.Scheduled_Payment_Date__c=Date.today()+10;              
        epr.Payment_Type__c='Prepayment';
        epr.Preferred_Payment_Method__c = 'Check';
        epr.Payment_Method__c = 'Check';
        epr.Status__c='Open';
        epr.Confirmation_Number__c = '12345678';
        //epr.Notes__c = 'some notes';
        epr.Team_Lead_Approval_Status__c=null;
        epr.Cash_Entry__c=null;
        INSERT epr;            
        
        //Insert EPR Line items
        EPR_Payable_Item__c eprPayable=new EPR_Payable_Item__c(
            EPR__c=epr.id,
            Item__c='test Item',
            Unit_Price__c=100,
            Quantity__c=1,
            Department_dim1__c=department.get(0).Id,
            Location_Dim2__c=dim2.get(0).Id,
            Dim_3__c=dim3.get(0).Id,
            Grant_Funding_Availale_dim4__c=dim4.get(0).Id,
            GLA__c=gla.get(0).Id
        );
        
        INSERT eprPayable;
        
        Vendor_Invoice_Payment__c vip=new Vendor_Invoice_Payment__c(
            Company__c = company.get(0).id,
            EPR__c=epr.id,
            Vendor_Invoice__c=vi.id,
            Payment_Cost__c=100,
            Payment_Made__c = TRUE
        ); 
        insert vip;
        
        UPDATE vi;
        /*
        //create payment record
        PageReference pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdCtrllerPaymentFromVI = new ApexPages.StandardController(vi); 
        CreatePaymentsFromVendorInvoice cp = new CreatePaymentsFromVendorInvoice(stdCtrllerPaymentFromVI);
        
        cp.vi =[SELECT Paid_Freshlife_Cost__c,Total_Freshlife_Cost__c,Paid_Sanergy_Cost__c,Total_Sanergy_Cost__c,
                Paid_SanergyFP_Cost__c,Total_SanergyFP_Cost__c,Paid_SanergyNP_Cost__c,Total_SanergyNP_Cost__c,Vendor__c,vendor__r.name,
                Prepayment_Sanergy_Amount__c,Prepayment_Freshlife_Amount__c,Prepayment_SanergyFP_Amount__c,Prepayment_SanergyNP_Amount__c,
                Invoice_Number__c,Proforma_Invoice__c,id,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,Actual_Date__c
                FROM Vendor_Invoice__c WHERE id= :vi.id];
        
        cp.vi.Prepayment_Sanergy_Amount__c=100;
        cp.vi.Prepayment_Freshlife_Amount__c=100;
        cp.vi.Prepayment_SanergyFP_Amount__c=100;
        cp.vi.Prepayment_SanergyNP_Amount__c=100;
        cp.eprM.Scheduled_Payment_Date__c = Date.today()+4;
        
        cp.createEPR('Sanergy Ltd', 10, 'aEBD0000000k9yM','a19D00000026xGa');
        
        cp.createPrePaymentRequest();
        
        UPDATE vi;
        */
        
        VendorInvoiceMapping.ItemWrapper ItemWrapperClass = new VendorInvoiceMapping.ItemWrapper(VIPOLI);
        VendorInvoiceMapping.ItemWrapper ItemWrapperClass2 = new VendorInvoiceMapping.ItemWrapper(VIPOLI);
        VendorInvoiceMapping.PoliWrapper PoliWrapperClass = new VendorInvoiceMapping.PoliWrapper(poLine);
        VendorInvoiceMapping.PoliClosedWrapper PoliClosedWrapperClass = new VendorInvoiceMapping.PoliClosedWrapper(poLine);
        
        
        //ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(vi);
        //VendorInvoiceMapping vim = new VendorInvoiceMapping(controller); 
        
        //Test OLD FIRM VI page with action Firm
        PageReference pageOLDVIFirm = Page.FirmVendorInvoice;
        pageOLDVIFirm.setRedirect(true);        
        test.setCurrentPageReference(pageOLDVIFirm);
        ApexPages.StandardController scOLDFIRM = new ApexPages.StandardController(vi);
        FirmVendorInvoice OLDVIFirm = new FirmVendorInvoice(scOLDFIRM);
        OLDVIFirm.FirmVI();
        
        //Test OLD CREATEPINFROMVI page with action Firm
        PageReference pageOLDVICreatePIN = Page.FirmVendorInvoice;
        pageOLDVICreatePIN.setRedirect(true);        
        test.setCurrentPageReference(pageOLDVICreatePIN);
        ApexPages.StandardController scOLDVIPIN = new ApexPages.StandardController(vi);
        CreatePINFromVendorInvoice OLDVIPIN = new CreatePINFromVendorInvoice(scOLDVIPIN);
        OLDVIPIN.CreatePINFromVendorInvoice();
        
        //Test VI page with action Firm
        PageReference pageRefVIFirm = Page.VendorInvoiceMapping;
        pageRefVIFirm.setRedirect(true);        
        test.setCurrentPageReference(pageRefVIFirm);
        pageRefVIFirm.getParameters().put('id', vi.Id); 
        pageRefVIFirm.getParameters().put('action', 'CreatePIN'); 
        
        List<Vendor_Invoice__c> viSetList = new List<Vendor_Invoice__c>();
        viSetList.add(vi);
        ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(viSetList);
        VendorInvoiceMapping vim = new VendorInvoiceMapping(standardSetController);
        vim.viGUID = vi.Id;
        vim.viAction = 'CreatePIN';
        
        vim.getVendorInvoicePurchaseOrderLineItems();
        ItemWrapperClass.selected = TRUE;
        
        vim.getpoItems();
        vim.getpoItemsClosed();
        vim.Rows();
        vim.selectAll();
        vim.FirmVI();
        vim.saveVI();
        
        vim.DiscardVI();
        
        PoliWrapperClass.selected = TRUE;
        vim.selectAllPOLI();
        vim.Ro();
        vim.testSelectUnselect();
        vim.CallReconcilePage();
        vim.CalculateTotals();
        vim.CloseVI();
        

        //return to Page Ref to Create PIN
        Test.setCurrentPage(pageRefVIFirm);
        
        //requery the VI
        List<Vendor_Invoice_Purchase_Order_Line_Item__c> vipoliLst = 
            [SELECT ID,Name,Item_Received_Total__c, Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,Purchase_Order_Line_Item__r.Name,
                Purchase_Order_Line_Item__r.Item__c, Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
                Purchase_Order_Line_Item__r.UoM__c,
                Purchase_Order_Line_Item__r.Quantity_Requested__c, Purchase_Order_Line_Item__r.Quantity_Accepted__c,
                Purchase_Order_Line_Item__c,Requested_Quantity__c,Status__c,Total_Cost__c,Vendor_Invoice__c,
                Vendor_Invoice__r.Reconciled__c, Reconciled_Item_Quantity_Received__c,Vendor_Invoice__r.Invoice_Total__c,
                Vendor_Invoice__r.Count_VIPOLI__c, Vendor_Invoice__r.Count_VIPOLI_Reconciled__c,
                Last_Invoice__c, Reconciled_Line_Total__c, Reconciled_Line_VAT__c, Reconciled_Line_Net_Cost__c,
                Purchase_Order_Line_Item__r.GLA__c, Purchase_Order_Line_Item__r.GLA__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_1__c,Purchase_Order_Line_Item__r.Dimension_1__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_2__c, Purchase_Order_Line_Item__r.Dimension_2__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_3__c, Purchase_Order_Line_Item__r.Dimension_3__r.Lookup_Id__c,
                Purchase_Order_Line_Item__r.Dimension_4__c, Purchase_Order_Line_Item__r.Dimension_4__r.Lookup_Id__c,
                Vendor_Invoice__r.Reconciled_Invoice_Total__c,
             Vendor_Invoice__r.VI_PIN__c, Vendor_Invoice__r.Total_Payments__c
                FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                WHERE Vendor_Invoice__c =: vi.Id];
        system.debug('vipoliLst before PIN = ' + vipoliLst);
        system.debug('VI before PIN = ' + vi);
        
        //Populate Lookup Values
        vim.ReconPINGLA.value = gla.get(0).lookup_ID__c;
        vim.ReconPINDIM1.value = department.get(0).lookup_ID__c;
        vim.ReconPINDIM2.value = dim2.get(0).lookup_ID__c;
        vim.ReconPINDIM3.value = dim3.get(0).lookup_ID__c;
        vim.ReconPINDIM4.value = dim4.get(0).lookup_ID__c;
        
        vim.ReconPINNetValue = 20.0;
        vim.ReconPINTaxValue = 3.0;
        vim.CreatePIN();
        //Test Exceptions
        vi.Invoice_Total__c = NULL;
        vi.Reconciled__c = FALSE;
        UPDATE vi;
        
        //vipoli.Status__c = 'Open';
        UPDATE vipoli;
        
        poLine.Payment_Variance__c = 'Test 123';
        poLine.Receipt_Variance__c = 'Test 123';
        poLine.Status__c = 'Open';
        UPDATE poline;
        
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(vi);
        VendorInvoiceMapping vim2 = new VendorInvoiceMapping(controller2); 
        
        ItemWrapperClass2.selected = TRUE;
        vim2.getVendorInvoicePurchaseOrderLineItems();
        vim2.getpoItems();
        
        vi.Invoice_Total__c = NULL;
        vi.Reconciled__c = FALSE;
        UPDATE vi;
        
        //vipoli.Status__c = 'Open';
        UPDATE vipoli;
        
        poLine.Payment_Variance__c = 'Test 123';
        poLine.Receipt_Variance__c = 'Test 123';
        poLine.Status__c = 'Open';
        UPDATE poline;
        
        
        
        //Test POLI Mapping page
        PageReference pageRef3 = Page.POLIMapping;
        pageRef3.setRedirect(true);        
        test.setCurrentPageReference(pageRef3);
        pageRef3.getParameters().put('id', vi.Id); 
        PoliWrapperClass.selected = TRUE;
        
        vim.getVendorInvoicePurchaseOrderLineItems();
        ItemWrapperClass.selected = TRUE;
        
        vim.getpoItems();
        vim.Rows();
        vim.selectAllPOLI();
        vim.ReconcilePOLI();
        
        //Test VendorInvoiceItemsTrigger
        vii.status__c = 'Approved';
        UPDATE vii;
        DELETE vii;
        /*
ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(vi);
VendorInvoiceMapping vim2 = new VendorInvoiceMapping(controller2); 
vim2.getVendorInvoicePurchaseOrderLineItems();
ItemWrapperClass.selected = TRUE;
vim2.getpoItems();
vim2.getpoItemsClosed();
vim2.Rows();
vim2.getpoItems();
vim2.selectAll();
vim2.saveVI();
//vim.saveAndReconcileVI();
vim2.CalculateTotals();
vim2.selectAllPOLI();
vim2.ReconcilePOLI();
//vim.Reconc();
vim2.Ro();
vim2.testSelectUnselect();
vim2.CallReconcilePage();       
*/
    }  
    static testMethod void ReversePO(){
        List<Inventory_Transaction__c> invTran = new List<Inventory_Transaction__c>();
        Purchase_Order__c po = new Purchase_Order__c();
        String POId = '';
        invTran = 
            [
                SELECT Id, Name, Item__c,Transaction_ID__c,Location_Lot__r.Name,
                Item__r.Name ,Item__r.Inventory_UoM__r.Name,Location__r.Location__r.Name,
                Transaction_Quantity__c,Quantity_Impact__c,Reversed_Transaction_ID__c,
                Location__c,Location_Lot__c,Quantity_At_Location__c,Location_Lot__r.Quantity__c,
                Vendor_Invoice__c,Item__r.Default_Lot__c,Purchase_Order_Line__c,Credit_Account__c,
                Purchase_Order_Line__r.Purchase_Order__c, Purchase_Order_Line__r.Purchase_Order__r.Name,
                Debit_Account__c,Dimension_1__c,Transaction_Value__c,Item__r.Item_Group__c,
                Item__r.Default_Site__c,Item__r.Default_Location__c,
                Item__r.Default_Site__r.Name,Location__r.Location__c,
                Item__r.unit_cost__c,Location__r.Location_Name__c,Location_Lot__r.Lot_Name__c                                                        
                FROM Inventory_Transaction__c
                WHERE Transaction_Reversed__c = false
                AND Transaction_ID__c = 'PORCPT'
                AND Reversed_Transaction_ID__c=NULL 
                ORDER BY CreatedDate DESC LIMIT 1
            ];
        if(invTran != NULL){
            for(Inventory_Transaction__c item:invTran){
                POId = item.Purchase_Order_Line__r.Purchase_Order__c;
            }
            //adjust inventory quantity in location
            PO = [SELECT Id FROM Purchase_Order__c WHERE Id =: POId ];
            system.debug('PO Test = ' + PO);
            if (po != NULL){
                ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(PO);
                ReversePurchaseOrderController vim2 = new ReversePurchaseOrderController(controller2); 
                
                vim2.getPurchaseOrderLineItems();
                vim2.getPurchaseOrderReceiptInventoryTransactions();
                ReversePurchaseOrderController.ItemWrapper ItemWrp = new ReversePurchaseOrderController.ItemWrapper(invTran[0]);
                
                for(ReversePurchaseOrderController.ItemWrapper item: vim2.inventoryTransactions){
                    item.selected = TRUE;
                    system.debug('Test in here');
                }
                try{
                    vim2.reversePurchaseOrderReceipt();    
                }
                Catch(Exception e) {
                    system.debug('reversePurchaseOrderReceipt Error = ' + e.getMessage());
                }
                
            }
        }
    }
}