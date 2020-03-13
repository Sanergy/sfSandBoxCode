@isTest(seeAllData=true)
private class ProcurementRequestTestClass{
    //Test PR Triggers
    static testMethod void ProcurementRequestTest() {
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true LIMIT 2];      
        UPDATE department;
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        UPDATE dim2;
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        UPDATE dim3;
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        UPDATE dim4;
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                           FROM Account
                           WHERE Name='Tuffsteel Ltd']; 
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        // Create a Contract            
        Contract c = new Contract();
        c.AccountId=ac.get(0).Id; 
        c.Status = 'Draft';
        c.StartDate=date.today();
        c.ContractTerm=1;
        c.CurrencyIsoCode='KES';
        c.Payment_Terms__c='7 Days';
        c.Primary_Contract__c=true;
        INSERT c;
        
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
        
        Group_Details__c debitAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Debit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        insert debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(1).Id
        );
        
        insert creditAc;
        
        
        Inventory_Location__c site = new Inventory_Location__c(
            Name = 'Mukuru'
        );
        insert site;
        
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
        
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
        
        insert lot;
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = c.Id;
        poItem.Vendor__c = ac.get(0).Id; 
        poItem.Currency__c = cc.Id;
        poItem.Status__c = 'Active';
        poItem.Primary_Vendor__c = true;
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
        insert pr;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 1000;
        prItem.Budget_Amount__c= 1000000000;
        prItem.Currency_Config__c = cc.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        prItem.GLA__c = gla.get(0).Id;
        prItem.Override_Gla__c = TRUE;
        insert prItem; 
        
        pr.Requesting_Department__c = department.get(1).id;
        pr.Maintenance_Department__c = department.get(1).id;
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        try{ 
            prItem.Purchase_Order_Item__c = null;
            prItem.Inventory_Item__c = null;
            update prItem;
        } catch (Exception e) {
            e.getMessage();
        }
        prItem.Purchase_Order_Item__c = poItem.id;
        prItem.Inventory_Item__c = poItem.Inventory_Item__c;
        //update prItem;
    } 
    
    //Test PO Classes
    static testMethod void CreatePOClassesTest() {
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                           FROM Account
                           WHERE Name='Tuffsteel Ltd']; 
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        // Create a Contract            
        Contract c = new Contract();
        c.AccountId=ac.get(0).Id; 
        c.Status = 'Draft';
        c.StartDate=date.today();
        c.ContractTerm=1;
        c.CurrencyIsoCode='KES';
        c.Payment_Terms__c='7 Days';
        c.Primary_Contract__c=true;
        INSERT c;
        
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
        
        Group_Details__c debitAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Debit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        insert debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(1).Id
        );
        
        insert creditAc;
        
        
        Inventory_Location__c site = new Inventory_Location__c(
            Name = 'Mukuru'
        );
        insert site;
        
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
        
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
        
        insert lot;
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = c.Id;
        poItem.Vendor__c = ac.get(0).Id; 
        poItem.Currency__c = cc.Id;
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
        insert pr;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 1000;
        prItem.Budget_Amount__c= 1000000000;
        prItem.Currency_Config__c = cc.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        prItem.GLA__c = gla.get(0).Id;
        prItem.Override_Gla__c = TRUE;
        insert prItem; 
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        prItem.Status__c = 'Pending Purchase Order';
        update prItem;
        
        //Create Purchase Order
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = ac.get(0).Id;
        po.Company__c = company.get(0).Id;
        po.PO_Currency__c = cc.Id;
        po.Order_Status__c = 'Open';
        
        INSERT po;
        
        //Create Purchase Order Line Item
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Name = 'Purchase Order Line Item 1';
        poLine.Purchase_Order__c = po.Id;
        poLine.Purchase_Order_Item__c = poItem.Id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 1;
        poLine.Unit_Price__c = 100;
        poLine.Vatable__c = true;
        poLine.VAT_inclusive__c = true;
        poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.Requesting_Company__c=company.get(0).Id; 
        poLine.Variation_Notes__c = 'variation notes'; 
        poLine.Status__c = 'Open';
        
        INSERT poLine;
        
        // Create Vendor Invoice
        Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
        vi.Vendor__c = po.Vendor_Account__c;
        vi.Currency_Config_Currency__c = po.PO_Currency__c;
        vi.Contract_Number__c = c.Id;                        
        vi.Status__c='Open';
        
        INSERT vi;
        
        Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
        viItems.Vendor_Invoice__c = vi.Id ;
        viItems.Purchase_Order_Line_Item__c = poLine.Id;
        viItems.Company__c = company.get(0).Id;
        viItems.Quantity__c = 4;
        viItems.Status__c='Pending GIGO Check';
        viItems.Closed__c = false;
        
        INSERT viItems;
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 20;
        VIPOLI.Item_Received_Total__c = 10;
        VIPOLI.Item_Unit_Cost__c = 0;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 0;
        VIPOLI.Reconciled_Line_Total__c =0;
        VIPOLI.Vendor_Invoice__c = vi.Id;
        Insert VIPOLI; 
        
        
        poLine.Invoice_Assigned__c = true;
        update poline;
        
        viItems.Accepted_Receive_Quantity__c = 1;
        viItems.Status__c = 'GIGO Checked';
        update viItems;
        
        invItem.Item_Number__c = '567890';
        update invItem;  
        
        
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        
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
        
        
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        
        Test.startTest();
        List<Procurement_Tracking_Sheet__c> prList=new List<Procurement_Tracking_Sheet__c>();
        prList.add(pr);
        ApexPages.StandardSetController standardController = new ApexPages.StandardSetController(prList);
        
        CreatePOLinesFromPTSLines createPoFromLines = new CreatePOLinesFromPTSLines(standardController); 
        
        PageReference pageRef = Page.CreatePOFromPTSLines;
        Test.setCurrentPage(pageRef);
        
        createPoFromLines.selectAll();
        createPoFromLines.getLinesSelected();
        createPoFromLines.unselectAll();
        
        for(CreatePOLinesFromPTSLines.LinesWrapper lw : createPoFromLines.linesWrapper){
            if(lw.ptsLine.id == prItem.id){
                lw.selected = true;
            }
        }
        
        createPoFromLines.processSelected();
        createPoFromLines.createPOLines();
        
        createPoFromLines.getCreatedPOs();
        
        Test.stopTest();      
    }  
    
    //Test PO Classes
    static testMethod void PurchaseOrderActionsClassTest() {
        
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                           FROM Account
                           WHERE Name='Tuffsteel Ltd']; 
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        // Create a Contract            
        Contract c = new Contract();
        c.AccountId=ac.get(0).Id; 
        c.Status = 'Draft';
        c.StartDate=date.today();
        c.ContractTerm=1;
        c.CurrencyIsoCode='KES';
        c.Payment_Terms__c='7 Days';
        c.Primary_Contract__c=true;
        INSERT c;
        
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
        
        Group_Details__c debitAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Debit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        insert debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(1).Id
        );
        
        insert creditAc;
        
        
        Inventory_Location__c site = new Inventory_Location__c(
            Name = 'Mukuru'
        );
        insert site;
        
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
        
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
        
        insert lot;
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = c.Id;
        poItem.Vendor__c = ac.get(0).Id; 
        poItem.Currency__c = cc.Id;
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
        insert pr;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 1000;
        prItem.Budget_Amount__c= 1000000000;
        prItem.Currency_Config__c = cc.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        prItem.GLA__c = gla.get(0).Id;
        prItem.Override_Gla__c = TRUE;
        insert prItem; 
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        prItem.Status__c = 'Pending Purchase Order';
        update prItem;
        
        //Create Purchase Order
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = ac.get(0).Id;
        po.Company__c = company.get(0).Id;
        po.PO_Currency__c = cc.Id;
        po.Order_Status__c = 'Open';
        po.Is_Retrospective__c = 'NO';
        
        INSERT po;
        
        //Create Purchase Order Line Item
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Name = 'Purchase Order Line Item 1';
        poLine.Purchase_Order__c = po.Id;
        poLine.Purchase_Order_Item__c = poItem.Id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 1;
        poLine.Unit_Price__c = 100;
        poLine.Vatable__c = true;
        poLine.VAT_inclusive__c = true;
        poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.Requesting_Company__c=company.get(0).Id; 
        poLine.Variation_Notes__c = 'variation notes'; 
        poLine.Status__c = 'Open';
        
        INSERT poLine;
        
        
        // Create Vendor Invoice
        Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
        vi.Vendor__c = po.Vendor_Account__c;
        vi.Currency_Config_Currency__c = po.PO_Currency__c;
        vi.Contract_Number__c = c.Id;                        
        vi.Status__c='Open';
        
        INSERT vi;
        
        Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
        viItems.Vendor_Invoice__c = vi.Id ;
        viItems.Purchase_Order_Line_Item__c = poLine.Id;
        viItems.Company__c = company.get(0).Id;
        viItems.Quantity__c = 4;
        viItems.Status__c='Pending GIGO Check';
        viItems.Closed__c = false;
        
        INSERT viItems;
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 20;
        VIPOLI.Item_Received_Total__c = 10;
        VIPOLI.Item_Unit_Cost__c = 0;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 0;
        VIPOLI.Reconciled_Line_Total__c =0;
        VIPOLI.Vendor_Invoice__c = vi.Id;
        Insert VIPOLI; 
        
        
        poLine.Invoice_Assigned__c = true;
        update poline;
        
        viItems.Accepted_Receive_Quantity__c = 1;
        viItems.Status__c = 'GIGO Checked';
        update viItems;
        
        invItem.Item_Number__c = '567890';
        update invItem;  
        
        Test.startTest();
        
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        
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
        
        
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        // Get the Purchase Order we just created                 
        Approval.ProcessSubmitRequest appPo = new Approval.ProcessSubmitrequest();
        appPo.setObjectId(po.Id); 
        Approval.ProcessResult result3 = Approval.process(appPo);
        
        //Create Purchase Order
        Purchase_Order__c po1 =new Purchase_Order__c();
        po1.Vendor_Account__c = ac.get(0).Id;
        po1.Company__c = company.get(0).Id;
        po1.PO_Currency__c = cc.Id;
        po1.Order_Status__c = 'Open';
        po1.Is_Retrospective__c = 'NO';
        
        INSERT po1;
        
        //Create Purchase Order Line Item
        Purchase_Order_Line_Item__c poLine1 = new Purchase_Order_Line_Item__c();
        poLine1.Name = 'Purchase Order Line Item 1';
        poLine1.Purchase_Order__c = po1.Id;
        poLine1.Purchase_Order_Item__c = poItem.Id;
        poLine1.PTS_Line_Item__c = prItem.id;
        poLine1.Item__c = 'Test Item';
        poLine1.Quantity_Requested__c = 1;
        poLine1.Unit_Price__c = 100;
        poLine1.Vatable__c = true;
        poLine1.VAT_inclusive__c = true;
        poLine1.VAT_Percentage__c = '16';
        poLine1.Variation_Notes__c = 'notes';
        poLine1.Dimension_1__c = department.get(0).id;
        poLine1.Terms_Conditions__c = 'Some Terms';
        poLine1.Requesting_Company__c=company.get(0).Id; 
        poLine1.Variation_Notes__c = 'variation notes'; 
        poLine1.Status__c = 'Open';
        
        INSERT poLine1; 
        
        Test.stopTest();
        
        //Add Attachments
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=pr.id); 
        insert attach;
        
        Attachment attachPO =new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=po.id); 
        insert attachPO;
        
        //Add Note
        Note notePR =new Note(Title = 'Note 1', body = 'bodyBlob' , parentId=pr.id); 
        insert notePR;
        
        Note notePO =new Note(Title ='Note 2', body = 'bodyBlob', parentId=po.id); 
        insert notePO;
        
        //Add GoogleDoc
        GoogleDoc gDoc =new GoogleDoc(Name = 'GDoc1', url = 'https://docs.google.com/spreadsheets/d/1l1U4A0Bb3E8TUrNmmdibqejqSL9vsfS_AkOK3ez5lGE/edit#gid=0',  parentId=pr.id); 
        insert gDoc;
        
        GoogleDoc gDocPO =new GoogleDoc(Name = 'GDoc2', url ='https://docs.google.com/document/d/1ReLwDzRZDHWh4m6NeX9XMtmKV_sQZTCYme7mbRpx5Iw/edit', parentId=po.id); 
        insert gDocPO;
        
        
        
        //  PurchaseOrderActionController.WrapperItems wrapperCls = new PurchaseOrderActionController.WrapperItems();
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(po);
        
        PurchaseOrderActionController poActionsController= new PurchaseOrderActionController(standardController);
        PurchaseOrderActionController.wrpPOLineItems wrPOLI =new PurchaseOrderActionController.wrpPOLineItems(poLine);
        
        PageReference pageRef = Page.PurchaseOrderActionsFirm;
        Test.setCurrentPage(pageRef);
        
        poActionsController.Counter = 5;
        
        //  wrapperCls.Comments = 'abc';
        //Approve PO
        poActionsController.POApprove();
        
        //Approve PO
        poActionsController.PODecline();
        
        //Notify Vendor
        poActionsController.POVendorNotify();
        
        poActionsController.getPOLineItems();
        poActionsController.getopenLineList();
        poActionsController.getopenLineListByInventoryItem();
        poActionsController.getOpenVendorPOs();
        
        poActionsController.Approve();
        
        poActionsController.test();
        
        poActionsController.testThere();
        
        poActionsController.testTwo();
        poActionsController.POClose();
        
        //firm
        poActionsController.POFirm();
        
        // Create an approval request to test Reject
        
        // Submit the Purchase Order we just created                 
        Approval.ProcessSubmitRequest appPo1 = new Approval.ProcessSubmitrequest();
        appPo1.setObjectId(po1.Id); 
        Approval.ProcessResult procResult = Approval.process(appPo1);
        
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setComments('Submitting PO request for approval.');
        req2.setObjectId(po1.id);
        
        // Submit on behalf of a specific submitter
        req2.setSubmitterId(UserInfo.getUserId()); 
        
        
        ApexPages.StandardController standardController2 = new ApexPages.StandardController(po1);
        PurchaseOrderActionController poActionsController2= new PurchaseOrderActionController(standardController2); 
        
        PageReference pageRef2 = Page.PurchaseOrderActionsFirm;
        Test.setCurrentPage(pageRef2);
        
        poActionsController2.Counter = 5;
        poActionsController2.Reject();
        
        
        
        //Generate PO Document
        pageRef = Page.GeneratePODocument;
        Test.setCurrentPage(pageRef);
        GeneratePODocument poDoc = new GeneratePODocument(standardController);
        
        CreateVendorInvoiceFromPO vendorInvController = new CreateVendorInvoiceFromPO(standardController);
        vendorInvController.getItems();
        vendorInvController.createInvoice();
        List<Vendor_Invoice__c > viList= vendorInvController.getVins();
        
        Integer counter = 0;
        for(Vendor_Invoice__c v : viList){
            v.Invoice_Number__c = 'invTest'+counter;
            v.Vendor_Invoice_date__c = Date.today()+5;
            counter++;
        }
        
        vendorInvController.editInvoice();
        
        //Close
        poActionsController.POClose();
        
        /*
List<Vendor_Invoice__c> viSetList = new List<Vendor_Invoice__c>();
viSetList.add(vi);
ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(viSetList);
CreateVendorInvoiceFromPO AddPOLIToVICtrl = new CreateVendorInvoiceFromPO(standardSetController);

AddPOLIToVICtrl.viGUID = vi.Id;
AddPOLIToVICtrl.PONameToSearch = po.Name;
AddPOLIToVICtrl.SearchForPO();
AddPOLIToVICtrl.getviToAddPOLI();
AddPOLIToVICtrl.AddPOLIToVI();
*/
        //Test.stopTest();
    }
    
    //Test VI Classes
    static testMethod void addVendorInvoiceClassTest() {
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' AND Name = 'Sanergy Limited' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id,Name FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        UPDATE employee;
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                           FROM Account
                           WHERE Name='Eye to Eye Transporters']; 
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        // Create a Contract            
        Contract c = new Contract();
        c.AccountId=ac.get(0).Id; 
        c.Status = 'Draft';
        c.StartDate=date.today();
        c.ContractTerm=1;
        c.CurrencyIsoCode='KES';
        c.Payment_Terms__c='7 Days';
        c.Primary_Contract__c=true;
        INSERT c;
        
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
        
        Group_Details__c debitAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Debit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        insert debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(1).Id
        );
        
        insert creditAc;
        
        
        Inventory_Location__c site = new Inventory_Location__c(
            Name = 'Mukuru'
        );
        insert site;
        
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
        
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
        
        insert lot;
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = c.Id;
        poItem.Vendor__c = ac.get(0).Id; 
        poItem.Currency__c = cc.Id;
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
        insert pr;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 1000;
        prItem.Budget_Amount__c= 1000000000;
        prItem.Currency_Config__c = cc.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        prItem.GLA__c = gla.get(0).Id;
        prItem.Override_Gla__c = TRUE;
        insert prItem; 
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        prItem.Status__c = 'Pending Purchase Order';
        update prItem;
        
        //Create Purchase Order
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = ac.get(0).Id;
        po.Company__c = company.get(0).Id;
        po.PO_Currency__c = cc.Id;
        po.Order_Status__c = 'Open';
        po.Approved__c = true;
        
        INSERT po;
        
        // Create Vendor Invoice
        
        
        //Create Purchase Order Line Item
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Name = 'Purchase Order Line Item 1';
        poLine.Purchase_Order__c = po.Id;
        poLine.Purchase_Order_Item__c = poItem.Id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 1;
        poLine.Unit_Price__c = 100;
        poLine.Vatable__c = true;
        poLine.VAT_inclusive__c = true;
        poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.Requesting_Company__c=company.get(0).Id; 
        poLine.Variation_Notes__c = 'variation notes'; 
        poLine.Status__c = 'Open';
        poLine.Invoice_Assigned__c = false;

        INSERT poLine;
        
        po.Approved__c = TRUE;
        UPDATE po;
        
        Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
        vi.Vendor__c = po.Vendor_Account__c;
        vi.Currency_Config_Currency__c = po.PO_Currency__c;
        vi.Contract_Number__c = c.Id;                        
        vi.Status__c='Open';
        vi.Invoice_Total__c = 1000;
        vi.Vendor_Invoice_date__c = date.today()+4;
        INSERT vi; 
        
        Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
        viItems.Vendor_Invoice__c = vi.Id ;
        viItems.Purchase_Order_Line_Item__c = poLine.Id;
        viItems.Company__c = invItem.Item_Company__c;//company.get(0).Id;
        viItems.Quantity__c = 10;
        viItems.Status__c='Pending GIGO Check';
        viItems.Closed__c = false;
        viItems.Total_Cost__c = 100;
        viItems.Receive_Quantity__c = 100;
        viItems.Receipt_Unit_Gross_Value__c = 10;
        
        system.debug('VII company.get(0).Id; = ' + viItems);
        INSERT viItems;
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 20;
        VIPOLI.Item_Received_Total__c = 10;
        VIPOLI.Item_Unit_Cost__c = 10;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 0;
        VIPOLI.Reconciled_Line_Total__c =0;
        VIPOLI.Vendor_Invoice__c = vi.Id;
        Insert VIPOLI;         
        
        //Attempt to delete VIPOLIto test VendorInvoicePOTrigger  
        po.Firm_Date__c = system.today();
        UPDATE po;
        Vendor_Invoice_PO__c vipo = new Vendor_Invoice_PO__c();
        vipo.Purchase_Order__c = po.id;
        vipo.Vendor_Invoice__c = vi.id;
        INSERT vipo;
        UPDATE vipo;
        DELETE vipo;
        /*          
Purchase_Order_Line_Item__c poLine = [Select Id, Name, Purchase_Order_Item__r.Name, Quantity_Requested__c,Dimension_1__c,
Quantity_Remaining__c,Requesting_Company__c, Requesting_Company__r.Name,Po_line_Receipt_Status__c,
Unit_Net_Price__c, VAT_Amount__c
From Purchase_Order_Line_Item__c
WHERE Invoice_Assigned__c = false 
AND (Status__c = 'Open'
OR  Po_line_Receipt_Status__c = 'Items Partially Received')
AND Purchase_Order__r.Approved__c = true
AND Requesting_Company__c =: company.get(0).Id
AND Dimension_1__c =: department.get(0).id
LIMIT 1];        
*/
        
        //poLine.Invoice_Assigned__c = true;
        //update poline;

        
        viItems.Accepted_Receive_Quantity__c = 1;
        viItems.Status__c = 'GIGO Checked';
        update viItems;
        
        //poLine.Po_line_Receipt_Status__c = 'Items Partially Received';
        //update poLine;
        
        // po.Order_Status__c = 'Open';
        // update po;
        
        invItem.Item_Number__c = '567890';
        update invItem;  
        
        
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        
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
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(vi);        
        AddVendorInvItemsController addVendorInvController= new AddVendorInvItemsController (standardController); 
        
        AddVendorInvItemsController.ItemWrapper wrap = new AddVendorInvItemsController.ItemWrapper(poLine);       
        
        PageReference pageRef = Page.AddVendorInvoiceItems;
        Test.setCurrentPage(pageRef);
        
        addVendorInvController.getItems();
        addVendorInvController.unselectAll();
        addVendorInvController.selectAll();
        addVendorInvController.addInvoiceItems();
        
        //Test.stopTest();

        //Update Account to -1 days Offset
        ac.get(0).c2g__CODADaysOffset1__c = -1;
        UPDATE ac;
        pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        CreatePaymentsFromVendorInvoice cpAccPrepay = new CreatePaymentsFromVendorInvoice(standardController);
        
        cpAccPrepay.vi =[SELECT Paid_Freshlife_Cost__c,Total_Freshlife_Cost__c,Paid_Sanergy_Cost__c,Total_Sanergy_Cost__c,
                         Paid_SanergyFP_Cost__c,Total_SanergyFP_Cost__c,Paid_SanergyNP_Cost__c,Total_SanergyNP_Cost__c,Vendor__c,vendor__r.name,
                         Prepayment_Sanergy_Amount__c,Prepayment_Freshlife_Amount__c,Prepayment_SanergyFP_Amount__c,Prepayment_SanergyNP_Amount__c,
                         Invoice_Number__c,Proforma_Invoice__c,id,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,Actual_Date__c,
                         Received_Freshlife_Value__c
                         FROM Vendor_Invoice__c WHERE id= :vi.id];
        
        cpAccPrepay.vi.Vendor_Invoice_date__c = Date.today()+2;
        cpAccPrepay.vi.Invoice_Total__c = 1000;
        cpAccPrepay.vi.Prepayment_Sanergy_Amount__c =10;
        
        cpAccPrepay.eprM.Scheduled_Payment_Date__c = Date.today()+2;
        UPDATE cpAccPrepay.vi;
        
        cpAccPrepay.createPrePaymentRequest();
        
        
        //Update Account to +ve days Offset
        ac.get(0).c2g__CODADaysOffset1__c = 2;
        UPDATE ac;
        
        pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        CreatePaymentsFromVendorInvoice cp = new CreatePaymentsFromVendorInvoice(standardController);
        
        cp.vi =[SELECT Paid_Freshlife_Cost__c,Total_Freshlife_Cost__c,Paid_Sanergy_Cost__c,Total_Sanergy_Cost__c,
                Paid_SanergyFP_Cost__c,Total_SanergyFP_Cost__c,Paid_SanergyNP_Cost__c,Total_SanergyNP_Cost__c,Vendor__c,vendor__r.name,
                Prepayment_Sanergy_Amount__c,Prepayment_Freshlife_Amount__c,Prepayment_SanergyFP_Amount__c,Prepayment_SanergyNP_Amount__c,
                Invoice_Number__c,Proforma_Invoice__c,id,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,Actual_Date__c,
                Received_Freshlife_Value__c
                FROM Vendor_Invoice__c WHERE id= :vi.id];
        
        cp.vi.Vendor_Invoice_date__c = Date.today()+4;
        cp.vi.Invoice_Total__c = 1000;
        cp.vi.Prepayment_Sanergy_Amount__c=15;
        
        cp.eprM.Scheduled_Payment_Date__c = Date.today()+4;
        cp.createPrePaymentRequest();
        cp.createEPR('Sanergy Ltd', 10, 'aEBD0000000k9yM','a19D00000026xGa');
        
        //attempt to overpay
        cp.vi.Vendor_Invoice_date__c = Date.today()+4;
        cp.vi.Invoice_Total__c = 1000;
        cp.vi.Prepayment_Sanergy_Amount__c=15000;
        
        cp.eprM.Scheduled_Payment_Date__c = Date.today()+4;
        cp.createPrePaymentRequest();
        
        //attempt to delete VI Item
        //viItems.Status__c = 'Approved';
        //UPDATE viItems;
        DELETE viItems;
        Test.stopTest();
    }
    
    
    //Test VI Classes
    static testMethod void createPaymentsFromVIClassTest() {
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' AND Name = 'Fresh Life Initiative Limited' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode,c2g__CODADaysOffset1__c
                           FROM Account
                           WHERE Name='Tuffsteel Ltd']; 
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
        // Create a Contract            
        Contract c = new Contract();
        c.AccountId=ac.get(0).Id; 
        c.Status = 'Draft';
        c.StartDate=date.today();
        c.ContractTerm=1;
        c.CurrencyIsoCode='KES';
        c.Payment_Terms__c='7 Days';
        c.Primary_Contract__c=true;
        INSERT c;
        
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
        
        Group_Details__c debitAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Debit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        insert debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(1).Id
        );
        
        insert creditAc;
        
        
        Inventory_Location__c site = new Inventory_Location__c(
            Name = 'Mukuru'
        );
        insert site;
        
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
        
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
        
        insert lot;
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 1;
        poItem.Contract_Number__c = c.Id;
        poItem.Vendor__c = ac.get(0).Id; 
        poItem.Currency__c = cc.Id;
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
        insert pr;
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Inventory_Item__c = invItem.Id;
        prItem.Requesting_Company__c = invItem.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
        prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 1000;
        prItem.Budget_Amount__c= 1000000000;
        prItem.Currency_Config__c = cc.id; 
        prItem.Purchase_Order_Item__c = poItem.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
        prItem.GLA__c = gla.get(0).Id;
        prItem.Override_Gla__c = TRUE;
        insert prItem; 
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        prItem.Status__c = 'Pending Purchase Order';
        update prItem;
        
        //Create Purchase Order
        Purchase_Order__c po =new Purchase_Order__c();
        po.Vendor_Account__c = ac.get(0).Id;
        po.Company__c = company.get(0).Id;
        po.PO_Currency__c = cc.Id;
        po.Order_Status__c = 'Open';
        
        INSERT po;
        
        //Create Purchase Order Line Item
        Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
        poLine.Name = 'Purchase Order Line Item 1';
        poLine.Purchase_Order__c = po.Id;
        poLine.Purchase_Order_Item__c = poItem.Id;
        poLine.PTS_Line_Item__c = prItem.id;
        poLine.Item__c = 'Test Item';
        poLine.Quantity_Requested__c = 1;
        poLine.Unit_Price__c = 100;
        poLine.Vatable__c = true;
        poLine.VAT_inclusive__c = true;
        poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.Requesting_Company__c=company.get(0).Id; 
        poLine.Variation_Notes__c = 'variation notes'; 
        poLine.Status__c = 'Open';
        
        INSERT poLine;
        
        // Create Vendor Invoice
        Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
        vi.Vendor__c = po.Vendor_Account__c;
        vi.Currency_Config_Currency__c = po.PO_Currency__c;
        vi.Contract_Number__c = c.Id;                        
        vi.Status__c='Open';
        vi.Invoice_Total__c = 1000;
        vi.Vendor_Invoice_date__c = date.today()-4;
        
        INSERT vi;
                
        //Attempt to delete VIPOLIto test VendorInvoicePOTrigger  
        po.Firm_Date__c = system.today();
        UPDATE po;      
        Vendor_Invoice_PO__c vipo = new Vendor_Invoice_PO__c();
        vipo.Purchase_Order__c = po.id;
        vipo.Vendor_Invoice__c = vi.id;
        INSERT vipo;
        UPDATE vipo;
        DELETE vipo;
        
        Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
        viItems.Vendor_Invoice__c = vi.Id ;
        viItems.Purchase_Order_Line_Item__c = poLine.Id;
        viItems.Company__c = invItem.Item_Company__c;//company.get(0).Id;
        viItems.Quantity__c = 1;
        viItems.Status__c='Pending GIGO Check';
        viItems.Closed__c = false;
        viItems.Total_Cost__c = 100;
        viItems.Receive_Quantity__c = 1;
        viItems.Receipt_Unit_Gross_Value__c = 100;
        
        system.debug('VII company.get(0).Id; = ' + viItems);
        INSERT viItems;
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 1;
        VIPOLI.Item_Received_Total__c = 10;
        VIPOLI.Item_Unit_Cost__c = 10;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 0;
        VIPOLI.Reconciled_Line_Total__c =0;
        VIPOLI.Vendor_Invoice__c = vi.Id;
        Insert VIPOLI; 
        
        
        poLine.Invoice_Assigned__c = true;
        update poline;
        
        viItems.Accepted_Receive_Quantity__c = 1;
        viItems.Status__c = 'GIGO Checked';
        update viItems;
        
        invItem.Item_Number__c = '567890';
        update invItem;  
        
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
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
        
        pr.Team_Lead_Approval_Status__c = 'Approved';
        pr.Stage__c= 'Team Lead Approved';
        update pr;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(vi);        
        // AddVendorInvItemsController addVendorInvController= new AddVendorInvItemsController (standardController); 
        
        PageReference pageRef;
        //Update Account to 0 days Offset
        ac.get(0).c2g__CODADaysOffset1__c = 0;
        UPDATE ac;
        pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        CreatePaymentsFromVendorInvoice cpAccNotSpecified = new CreatePaymentsFromVendorInvoice(standardController);
        cpAccNotSpecified.createPrePaymentRequest();
            
        //Update Account to -1 days Offset
        ac.get(0).c2g__CODADaysOffset1__c = -1;
        UPDATE ac;
        pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        CreatePaymentsFromVendorInvoice cpAccPrepay = new CreatePaymentsFromVendorInvoice(standardController);
        
        cpAccPrepay.vi =[SELECT Paid_Freshlife_Cost__c,Total_Freshlife_Cost__c,Paid_Sanergy_Cost__c,Total_Sanergy_Cost__c,
                         Paid_SanergyFP_Cost__c,Total_SanergyFP_Cost__c,Paid_SanergyNP_Cost__c,Total_SanergyNP_Cost__c,Vendor__c,vendor__r.name,
                         Prepayment_Sanergy_Amount__c,Prepayment_Freshlife_Amount__c,Prepayment_SanergyFP_Amount__c,Prepayment_SanergyNP_Amount__c,
                         Invoice_Number__c,Proforma_Invoice__c,id,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,Actual_Date__c,
                         Received_Freshlife_Value__c
                         FROM Vendor_Invoice__c WHERE id= :vi.id];
        
        cpAccPrepay.vi.Vendor_Invoice_date__c = Date.today()+2;
        cpAccPrepay.vi.Invoice_Total__c = 1000;
        cpAccPrepay.vi.Prepayment_Freshlife_Amount__c=10;
        
        cpAccPrepay.eprM.Scheduled_Payment_Date__c = Date.today()+2;
        UPDATE cpAccPrepay.vi;
        
        cpAccPrepay.createPrePaymentRequest();
        
        //Update Account to -2 days Offset
        ac.get(0).c2g__CODADaysOffset1__c = -2;
        UPDATE ac;
        pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        CreatePaymentsFromVendorInvoice cpAccPrepayMixed = new CreatePaymentsFromVendorInvoice(standardController);
        
        //Update Account to +ve days Offset
        ac.get(0).c2g__CODADaysOffset1__c = 2;
        UPDATE ac;
        
        Test.startTest();
        
        pageRef = Page.CreatePrepaymentFromVendorInvoice;
        Test.setCurrentPage(pageRef);
        CreatePaymentsFromVendorInvoice cp = new CreatePaymentsFromVendorInvoice(standardController);
        
        system.debug('VI Before Refresh = ' + cp.vi);
        cp.vi =[SELECT Paid_Freshlife_Cost__c,Total_Freshlife_Cost__c,Paid_Sanergy_Cost__c,Total_Sanergy_Cost__c,
                Paid_SanergyFP_Cost__c,Total_SanergyFP_Cost__c,Paid_SanergyNP_Cost__c,Total_SanergyNP_Cost__c,Vendor__c,vendor__r.name,
                Prepayment_Sanergy_Amount__c,Prepayment_Freshlife_Amount__c,Prepayment_SanergyFP_Amount__c,Prepayment_SanergyNP_Amount__c,
                Invoice_Number__c,Proforma_Invoice__c,id,Contract_Number__c,Payment_Terms__c,Payment_Terms_Due_Date__c,Actual_Date__c,
                Received_Freshlife_Value__c
                FROM Vendor_Invoice__c WHERE id= :vi.id];
        system.debug('VI after Refresh = ' + cp.vi);
        
        cp.vi.Vendor_Invoice_date__c = Date.today()+2;
        cp.vi.Invoice_Total__c = 1000;
        //cp.vi.Prepayment_Sanergy_Amount__c=100;
        cp.vi.Prepayment_Freshlife_Amount__c=30;
        cp.vi.Prepayment_SanergyFP_Amount__c=100;
        cp.vi.Prepayment_SanergyNP_Amount__c=100;
        
        cp.eprM.Scheduled_Payment_Date__c = Date.today()+2;
        UPDATE cp.vi;
        cp.createPrePaymentRequest();

        //attempt to over pay        
        cp.vi.Prepayment_Freshlife_Amount__c=1000000;
        UPDATE cp.vi;
        cp.createPrePaymentRequest();
        
        //attempt to create with no date
        cp.vi.Vendor_Invoice_date__c = NULL;
        UPDATE cp.vi;
        cp.createPrePaymentRequest();
        
        cp.createEPR('Fresh Life Initiative Ltd', 10, 'aEBD0000000kA4j','a19D00000026xHv');

        //cp.createEPR('Sanergy Ltd', 10, 'aEBD0000000k9yM','a19D00000026xGa');
        Test.stopTest();
    }
    
    //Test VI Classes
    static testMethod void ActivatePurchaseOrderItemClassTest() {
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            
            //Get Company
            FFA_Config_Object__c compny = [SELECT Name,Id,Type__c FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'company' AND isActive__c = true 
                                           AND Name = 'Sanergy Limited' LIMIT 1];
            
            //Get dim1                              
            FFA_Config_Object__c department = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                               WHERE Type__c = 'dim1' AND isActive__c = true LIMIT 1];
            
            //Get dim2                                    
            FFA_Config_Object__c dim2 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                         WHERE Type__c = 'dim2' AND isActive__c = true LIMIT 1];
            
            //Get dim3                                   
            FFA_Config_Object__c dim3 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                         WHERE Type__c = 'dim3' AND isActive__c = true LIMIT 1];
            
            //Get dim4                                     
            FFA_Config_Object__c dim4 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                         WHERE Type__c = 'dim4' AND isActive__c = true LIMIT 1];
            
            //Get GLA
            FFA_Config_Object__c gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                        WHERE Type__c = 'gla' AND isActive__c = true LIMIT 1];
            
            //Get a vendor
            Account vendor = [SELECT id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' LIMIT 1];
            
            //Create UoM
            Inventory_UoM__c uom = new Inventory_UoM__c();
            uom.Uom_Code__c = 'EachTst';
            uom.Name = 'EachTst';
            uom.Description__c = 'EachTst';
            insert uom;
            
            //Create Site
            Inventory_Location__c site = new Inventory_Location__c();
            site.Name = 'Mukuru 2345';
            insert site;
            
            
            // Create Inventory_Item_Group__c
            Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
            invItemGroup.Name = 'New Inventory Item Group';
            invItemGroup.Commodity_Code__c = 'New Commodity code';
            invItemGroup.Description__c = 'Brief description';
            
            INSERT invItemGroup;
            
            Group_Details__c debitAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Debit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.Id
            );
            
            insert debitAc;
            
            
            //Create Inventory commodity Code
            Inventory_Item_Group__c comCode = new Inventory_Item_Group__c();
            comCode.Name = 'name';
            comCode.Dimension_1__c = department.Id;
            comCode.Description__c = 'Test Desc';
            comCode.Dimension_2__c = dim2.Id;
            comCode.Dimension_3__c = dim3.Id;
            comCode.Dimension_4__c = dim4.Id;
            comCode.Requires_Contract__c = true;
            comCode.Commodity_Code__c = 'Test Descr';
            insert comCode;
            
            //Create Currency               
            Currency_Config__c currenc = [SELECT id, Name FROM Currency_Config__c 
                                          WHERE Current__c = true AND Name = 'KES'
                                          LIMIT 1];
            
            //Create Inventory Item               
            Inventory_Item__c item = new Inventory_Item__c();
            item.Item_Description__c = 'Cement';
            item.Currency_Config__c = currenc.Id;
            item.Name = 'item';
            item.Item_Number__c = '123456';
            item.Responsible_Department__c = department.Id;
            item.Policy_Quantity__c = 10;
            item.Minimum_Quantity__c = 2;
            item.Item_Group__c = comCode.Id;
            item.Inventory_UoM__c = uom.Id;
            item.unit_cost__c = 100;
            item.Item_Company__c = compny.Id;
            item.Default_Site__c = site.Id;
            item.Default_Location__c = 'loc1';
            item.Default_Lot__c = 'lot1';                                                        
            insert Item;
            
            //Create Purchase Order Item                  
            Purchase_Order_Item__c poI = new Purchase_Order_Item__c();
            poI.name= 'Test Name';
            poI.Item_Description__c = 'Test Description';
            poI.Inventory_Item__c = item.id;
            poI.Purchase_UoM__c = uom.id;
            poI.UOM_Conversion_Factor__c = 1;
            poI.Item_Cost__c = 100;
            poI.Currency__c = currenc.id;
            poI.Status__c = 'Created';
            poI.Vendor__c = vendor.id;
            insert poI;
            
            Purchase_Order_Item__c poI2 = new Purchase_Order_Item__c();
            poI2.name= 'Test Name 2';
            poI2.Item_Description__c = 'Test Description';
            poI2.Inventory_Item__c = item.id;
            poI2.Purchase_UoM__c = uom.id;
            poI2.UOM_Conversion_Factor__c = 2;
            poI2.Item_Cost__c = 100;
            poI2.Currency__c = currenc.id;
            poI2.Status__c = 'Created';
            poI2.Vendor__c = vendor.id;
            insert poI2;
            
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.StandardController(poI);
            PageReference pageRef = Page.ActivatePurchaseOrderItem;
            Test.setCurrentPage(pageRef);
            
            //activate first Item
            ActivatePurchaseOrderItem activatePoiController= new ActivatePurchaseOrderItem(standardController); 
            // activatePoiController.activate();
            
            //resubmit for activation
            try{
                // activatePoiController.activate();
            }catch(Exception e){ System.debug (e.getMessage());         
                               }
            
            //activate second Item     
            comCode.Requires_Contract__c = false;
            update comCode;
            
            standardController = new ApexPages.StandardController(poI2);
            activatePoiController = new ActivatePurchaseOrderItem(standardController); 
            // activatePoiController.activate();
            
            // ProcurementRequestTracker tracker = new ProcurementRequestTracker();
            //tracker.save();
            String selectValue = 'ALL';
            ProcurementRequestTracker controller = new ProcurementRequestTracker();
            controller = new ProcurementRequestTracker();
            controller.save();
            
            Test.stopTest();                  
        }     
    }
    
    //Test AddPOLIToVI Classes
    static testMethod void AddPOLIToVIClassTest() {
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            //Get Department
            List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
            //Get Company
            List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
            
            //Get employee
            List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
            
            //Get gla
            List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
            
            // Select Account
            List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                               FROM Account
                               WHERE Name='Tuffsteel Ltd']; 
            
            // Create a Currency Config
            Currency_Config__c cc = new Currency_Config__c();
            cc.Name = 'KES';
            cc.Start__c = date.today();
            cc.End__c = date.today();
            cc.Value__c = 1;
            cc.Currency_Name__c='Kenyan Shilling';
            cc.Current__c = true;
            INSERT cc;
            
            // Create a Contract            
            Contract c = new Contract();
            c.AccountId=ac.get(0).Id; 
            c.Status = 'Draft';
            c.StartDate=date.today();
            c.ContractTerm=1;
            c.CurrencyIsoCode='KES';
            c.Payment_Terms__c='7 Days';
            c.Primary_Contract__c=true;
            INSERT c;
            
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
            
            Group_Details__c debitAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Debit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(0).Id
            );
            
            insert debitAc;
            
            Group_Details__c creditAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Credit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(1).Id
            );
            
            insert creditAc;
            
            
            Inventory_Location__c site = new Inventory_Location__c(
                Name = 'Mukuru'
            );
            insert site;
            
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
            
            Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
                Name = site.Name,
                Location_Name__c = '001',
                Location__c = site.Id,
                Inventory_Item__c = invItem.Id,
                Max_Location_Quantity__c = 100
            );
            
            insert itmloc;
            
            Item_Location_Lot__c lot = new Item_Location_Lot__c(
                Lot_Name__c = '001',
                Quantity__c = 10,
                Item_Location__c = itmloc.Id
            );
            
            insert lot;
            
            //Create Purchase Order Item
            Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
            poItem.Name = 'PO Item 1';
            poItem.Item_Description__c = 'brief description';
            poItem.Inventory_Item__c = invItem.Id; 
            poItem.Purchase_UoM__c = iUom.Id;
            poItem.UOM_Conversion_Factor__c = 1;
            poItem.Contract_Number__c = c.Id;
            poItem.Vendor__c = ac.get(0).Id; 
            poItem.Currency__c = cc.Id;
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
            insert pr;
            
            //Create PRLine
            PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
            prItem.Procurement_Tracking_Sheet__c = pr.Id;
            prItem.Department__c = department.get(0).id;
            prItem.Inventory_Item__c = invItem.Id;
            prItem.Requesting_Company__c = invItem.Item_Company__c;
            prItem.Item__c = 'Test Item';
            prItem.Override_PR_Item_Cost_Check__c = true;
            prItem.Override_Justification__c = 'just';
            prItem.Specifications__c = 'Test Specifications';
            prItem.Quantity__c = 1000;
            prItem.Budget_Amount__c= 1000000000;
            prItem.Currency_Config__c = cc.id; 
            prItem.Purchase_Order_Item__c = poItem.id; 
            prItem.non_primary_vendor_description__c = 'coment';
            prItem.RequestType__c = 'Stock';
            prItem.GLA__c = gla.get(0).Id;
            prItem.Override_Gla__c = TRUE;
            insert prItem; 
            
            pr.Team_Lead_Approval_Status__c = 'Approved';
            pr.Stage__c= 'Team Lead Approved';
            update pr;
            
            prItem.Status__c = 'Pending Purchase Order';
            update prItem;
            
            //Create Purchase Order
            Purchase_Order__c po =new Purchase_Order__c();
            po.Vendor_Account__c = ac.get(0).Id;
            po.Company__c = company.get(0).Id;
            po.PO_Currency__c = cc.Id;
            po.Order_Status__c = 'Vendor Notified';
            po.Firm_Date__c = date.today();
            
            INSERT po;
            
            system.debug('po.Name In Test After PO INsert = ' + po.Name);            
            //Create Purchase Order Line Item
            Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
            poLine.Name = 'Purchase Order Line Item 1';
            poLine.Purchase_Order__c = po.Id;
            poLine.Purchase_Order_Item__c = poItem.Id;
            poLine.PTS_Line_Item__c = prItem.id;
            poLine.Item__c = 'Test Item';
            poLine.Quantity_Requested__c = 1;
            poLine.Unit_Price__c = 100;
            poLine.Vatable__c = true;
            poLine.VAT_inclusive__c = true;
            poLine.VAT_Percentage__c = '16';
            poLine.Variation_Notes__c = 'notes';
            poLine.Dimension_1__c = department.get(0).id;
            poLine.Terms_Conditions__c = 'Some Terms';
            poLine.Requesting_Company__c=company.get(0).Id; 
            poLine.Variation_Notes__c = 'variation notes'; 
            poLine.Status__c = 'Open';
            
            INSERT poLine;
            
            // Create Vendor Invoice
            Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
            vi.Vendor__c = po.Vendor_Account__c;
            vi.Currency_Config_Currency__c = po.PO_Currency__c;
            vi.Contract_Number__c = c.Id;                        
            vi.Status__c='Open';
            
            
            INSERT vi;
            
            Test.startTest();
            //test without passing a VI ID parameter
            PageReference pageRefErr = Page.AddPOLIToVI;
            pageRefErr.setRedirect(true);        
            test.setCurrentPageReference(pageRefErr);
            
            List<Vendor_Invoice__c> viSetListErr = new List<Vendor_Invoice__c>();
            viSetListErr.add(vi);
            ApexPages.StandardSetController standardSetControllerErr = new ApexPages.StandardSetController(viSetListErr);
            CreateVendorInvoiceFromPO AddPOLIToVICtrlErr = new CreateVendorInvoiceFromPO(standardSetControllerErr);
            AddPOLIToVICtrlErr.SearchForPO();
            
            //Test Normal Page with VI provided
            PageReference pageRef1 = Page.AddPOLIToVI;
            pageRef1.setRedirect(true);        
            test.setCurrentPageReference(pageRef1);
            
            pageRef1.getParameters().put('id', vi.Id);        
            Purchase_Order__c purchaseOrder = new Purchase_Order__c();
            purchaseOrder =[SELECT id, Name FROM Purchase_Order__c WHERE ID =: po.id ]; //Need to do this to get the PO Name, po.Name will not work!!
            
            List<Vendor_Invoice__c> viSetList = new List<Vendor_Invoice__c>();
            viSetList.add(vi);
            ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(viSetList);
            CreateVendorInvoiceFromPO AddPOLIToVICtrl = new CreateVendorInvoiceFromPO(standardSetController);
            
            AddPOLIToVICtrl.viGUID = vi.Id;
            
            
            //First pass mainly to run exceptions
            AddPOLIToVICtrl.PONameToSearch = NULL;
            AddPOLIToVICtrl.getItems();
            AddPOLIToVICtrl.SearchForPO(); //Search when search text Is NULL
            AddPOLIToVICtrl.PONameToSearch = 'XXX123';
            AddPOLIToVICtrl.SearchForPO(); //Search with incorrect PO Name
            AddPOLIToVICtrl.getItems();
            
            AddPOLIToVICtrl.getviToAddPOLI();
            AddPOLIToVICtrl.AddPOLIToVI();
            
            //test correct PO but wrong status
            AddPOLIToVICtrl.PONameToSearch = purchaseOrder.Name;
            po.Order_Status__c = 'Open';
            //UPDATE po;
            AddPOLIToVICtrl.SearchForPO();
            
            //Reset and select items in wrapper class and attempt save
            AddPOLIToVICtrl.PONameToSearch = purchaseOrder.Name;
            po.Order_Status__c = 'Vendor Notified';
            UPDATE po;
            
            AddPOLIToVICtrl.SearchForPO();
            AddPOLIToVICtrl.getItems();
            AddPOLIToVICtrl.selectAllRecords();
            AddPOLIToVICtrl.getviToAddPOLI();
            AddPOLIToVICtrl.AddPOLIToVI();
            AddPOLIToVICtrl.unSelectAllRecords();
            
            try{
                // activatePoiController.activate();
            } catch(Exception e)
            { 
                System.debug (e.getMessage());         
                
            }
            
            Test.stopTest();  
            
            //Attempt to delete VIPOLIto test VendorInvoicePOTrigger        
            Vendor_Invoice_PO__c vipo = new Vendor_Invoice_PO__c();
            vipo.Purchase_Order__c = po.id;
            vipo.Vendor_Invoice__c = vi.id;
            INSERT vipo;
            UPDATE vipo;
            DELETE vipo;
        }     
    }
    
    //Test CreateVIFromPO Classes
    static testMethod void CreateVIFromPOClassTest() {
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            //Get Department
            List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
            //Get Company
            List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
            
            //Get employee
            List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
            
            //Get gla
            List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
            
            // Select Account
            List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                               FROM Account
                               WHERE Name='Tuffsteel Ltd']; 
            
            // Create a Currency Config
            Currency_Config__c cc = new Currency_Config__c();
            cc.Name = 'KES';
            cc.Start__c = date.today();
            cc.End__c = date.today();
            cc.Value__c = 1;
            cc.Currency_Name__c='Kenyan Shilling';
            cc.Current__c = true;
            INSERT cc;
            
            // Create a Contract            
            Contract c = new Contract();
            c.AccountId=ac.get(0).Id; 
            c.Status = 'Draft';
            c.StartDate=date.today();
            c.ContractTerm=1;
            c.CurrencyIsoCode='KES';
            c.Payment_Terms__c='7 Days';
            c.Primary_Contract__c=true;
            INSERT c;
            
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
            
            Group_Details__c debitAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Debit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(0).Id
            );
            
            insert debitAc;
            
            Group_Details__c creditAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Credit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(1).Id
            );
            
            insert creditAc;
            
            
            Inventory_Location__c site = new Inventory_Location__c(
                Name = 'Mukuru'
            );
            insert site;
            
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
            
            Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
                Name = site.Name,
                Location_Name__c = '001',
                Location__c = site.Id,
                Inventory_Item__c = invItem.Id,
                Max_Location_Quantity__c = 100
            );
            
            insert itmloc;
            
            Item_Location_Lot__c lot = new Item_Location_Lot__c(
                Lot_Name__c = '001',
                Quantity__c = 10,
                Item_Location__c = itmloc.Id
            );
            
            insert lot;
            
            //Create Purchase Order Item
            Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
            poItem.Name = 'PO Item 1';
            poItem.Item_Description__c = 'brief description';
            poItem.Inventory_Item__c = invItem.Id; 
            poItem.Purchase_UoM__c = iUom.Id;
            poItem.UOM_Conversion_Factor__c = 1;
            poItem.Contract_Number__c = c.Id;
            poItem.Vendor__c = ac.get(0).Id; 
            poItem.Currency__c = cc.Id;
            poItem.Status__c = 'Active';
            poItem.Primary_Vendor__c = true;
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
            insert pr;
            
            //Create PRLine
            PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
            prItem.Procurement_Tracking_Sheet__c = pr.Id;
            prItem.Department__c = department.get(0).id;
            prItem.Inventory_Item__c = invItem.Id;
            prItem.Requesting_Company__c = invItem.Item_Company__c;
            prItem.Item__c = 'Test Item';
            prItem.Override_PR_Item_Cost_Check__c = true;
            prItem.Override_Justification__c = 'just';
            prItem.Specifications__c = 'Test Specifications';
            prItem.Quantity__c = 1000;
            prItem.Budget_Amount__c= 1000000000;
            prItem.Currency_Config__c = cc.id; 
            prItem.Purchase_Order_Item__c = poItem.id; 
            prItem.non_primary_vendor_description__c = 'coment';
            prItem.RequestType__c = 'Stock';
            prItem.GLA__c = gla.get(0).Id;
            prItem.Override_Gla__c = TRUE;
            insert prItem; 
            
            pr.Team_Lead_Approval_Status__c = 'Approved';
            pr.Stage__c= 'Team Lead Approved';
            update pr;
            
            prItem.Status__c = 'Pending Purchase Order';
            update prItem;
            
            //Create Purchase Order
            Purchase_Order__c po =new Purchase_Order__c();
            po.Vendor_Account__c = ac.get(0).Id;
            po.Company__c = company.get(0).Id;
            po.PO_Currency__c = cc.Id;
            po.Order_Status__c = 'Vendor Notified';
            po.Firm_Date__c = date.today();
            
            
            INSERT po;
            
            system.debug('po.Name In Test After PO INsert = ' + po.Name);            
            //Create Purchase Order Line Item
            Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
            poLine.Name = 'Purchase Order Line Item 1';
            poLine.Purchase_Order__c = po.Id;
            poLine.Purchase_Order_Item__c = poItem.Id;
            poLine.PTS_Line_Item__c = prItem.id;
            poLine.Item__c = 'Test Item';
            poLine.Quantity_Requested__c = 1;
            poLine.Unit_Price__c = 100;
            poLine.Vatable__c = true;
            poLine.VAT_inclusive__c = true;
            poLine.VAT_Percentage__c = '16';
            poLine.Variation_Notes__c = 'notes';
            poLine.Dimension_1__c = department.get(0).id;
            poLine.Terms_Conditions__c = 'Some Terms';
            poLine.Requesting_Company__c=company.get(0).Id; 
            poLine.Variation_Notes__c = 'variation notes'; 
            poLine.Status__c = 'Open';
            poLine.Invoice_Assigned__c = false;
            
            INSERT poLine;
            /*
            // Create Vendor Invoice
            Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
            vi.Vendor__c = po.Vendor_Account__c;
            vi.Currency_Config_Currency__c = po.PO_Currency__c;
            vi.Contract_Number__c = c.Id;                        
            vi.Status__c='Open';
            
            
            INSERT vi;
            */
            Test.startTest();
            //test without passing a VI ID parameter
            PageReference pageRefVI = Page.CreateVIFromPO;
            pageRefVI.setRedirect(true);        
            test.setCurrentPageReference(pageRefVI);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(po);
            CreateVendorInvoiceFromPO vendorInvController = new CreateVendorInvoiceFromPO(stdController);
            vendorInvController.getItems();
            vendorInvController.createInvoice();
            List<Vendor_Invoice__c > viList= vendorInvController.getVins();
            
            Integer counter = 0;
            for(Vendor_Invoice__c v : viList){
                v.Invoice_Number__c = 'invTest'+counter;
                v.Vendor_Invoice_date__c = Date.today()+5;
                counter++;
            }
            
            vendorInvController.editInvoice();
            /*          
            //test without passing a VI ID parameter
            PageReference pageRefErr = Page.AddPOLIToVI;
            pageRefErr.setRedirect(true);        
            test.setCurrentPageReference(pageRefErr);
            
            List<Vendor_Invoice__c> viSetListErr = new List<Vendor_Invoice__c>();
            viSetListErr.add(vi);
            ApexPages.StandardSetController standardSetControllerErr = new ApexPages.StandardSetController(viSetListErr);
            CreateVendorInvoiceFromPO AddPOLIToVICtrlErr = new CreateVendorInvoiceFromPO(standardSetControllerErr);
            AddPOLIToVICtrlErr.SearchForPO();
            
            //Test Normal Page with VI provided
            PageReference pageRef1 = Page.AddPOLIToVI;
            pageRef1.setRedirect(true);        
            test.setCurrentPageReference(pageRef1);
            
            pageRef1.getParameters().put('id', vi.Id);        
            Purchase_Order__c purchaseOrder = new Purchase_Order__c();
            purchaseOrder =[SELECT id, Name FROM Purchase_Order__c WHERE ID =: po.id ]; //Need to do this to get the PO Name, po.Name will not work!!
            
            List<Vendor_Invoice__c> viSetList = new List<Vendor_Invoice__c>();
            viSetList.add(vi);
            ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(viSetList);
            CreateVendorInvoiceFromPO AddPOLIToVICtrl = new CreateVendorInvoiceFromPO(standardSetController);
            
            AddPOLIToVICtrl.viGUID = vi.Id;
            
            
            //First pass mainly to run exceptions
            AddPOLIToVICtrl.PONameToSearch = NULL;
            AddPOLIToVICtrl.getItems();
            AddPOLIToVICtrl.SearchForPO(); //Search when search text Is NULL
            AddPOLIToVICtrl.PONameToSearch = 'XXX123';
            AddPOLIToVICtrl.SearchForPO(); //Search with incorrect PO Name
            AddPOLIToVICtrl.getItems();
            
            AddPOLIToVICtrl.getviToAddPOLI();
            AddPOLIToVICtrl.AddPOLIToVI();
            
            //test correct PO but wrong status
            AddPOLIToVICtrl.PONameToSearch = purchaseOrder.Name;
            po.Order_Status__c = 'Open';
            //UPDATE po;
            AddPOLIToVICtrl.SearchForPO();
            
            //Reset and select items in wrapper class and attempt save
            AddPOLIToVICtrl.PONameToSearch = purchaseOrder.Name;
            po.Order_Status__c = 'Vendor Notified';
            UPDATE po;
            
            AddPOLIToVICtrl.SearchForPO();
            AddPOLIToVICtrl.getItems();
            AddPOLIToVICtrl.selectAllRecords();
            AddPOLIToVICtrl.getviToAddPOLI();
            AddPOLIToVICtrl.AddPOLIToVI();
            AddPOLIToVICtrl.unSelectAllRecords();
            
            */
            Test.stopTest();                  
        }     
    }
    
}