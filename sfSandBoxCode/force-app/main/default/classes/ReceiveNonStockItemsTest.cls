@isTest(SeeAllData=true)
public class ReceiveNonStockItemsTest {
    
    static testMethod void testReceiveToDefaultLocs(){
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true LIMIT 2];      
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true  LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id,Name FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true  and Name != 'DO NOT USE - 2161 - VAT RESERVE' LIMIT 1];
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                           FROM Account
                           WHERE Name='Eye to Eye Transporters']; 
        
        Double conversionFactor = 1;
        
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
            Config_Account__c = gla.get(0).Id
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
        invItem.Item_Type__c = 'Non Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Inventory_UoM__c = iUom.Id;
        invItem.Item_Group__c = invItemGroup.Id;
        invItem.Default_Location__c = '001';
        invItem.Default_Lot__c = '001';
        invItem.Currency_Config__c = cc.Id;
        invItem.unit_cost__c = 20;
        
        INSERT invItem;
        
        Inventory_Item_Location__c location = new Inventory_Item_Location__c();
        location.Name = 'Mukuru';
        location.Location_Name__c = '001';
        location.Inventory_Item__c = invItem.Id;
        location.Location__c = site.Id;
        
        insert location;
        
        Item_Location_Lot__c  lots = new Item_Location_Lot__c();
        lots.Name = 'Mukuru - 1-1';
        lots.Lot_Name__c = '001';
        lots.Quantity__c = 3;
        lots.CurrencyIsoCode = 'KES';
        lots.Item_Location__c = location.Id;
        insert lots;
        
        //Create Purchase Order Item
        Purchase_Order_Item__c poItem =new Purchase_Order_Item__c();
        poItem.Name = 'PO Item 1';
        poItem.Item_Description__c = 'brief description';
        poItem.Inventory_Item__c = invItem.Id; 
        poItem.Purchase_UoM__c = iUom.Id;
        poItem.UOM_Conversion_Factor__c = 10;
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
        prItem.Quantity_Requested_On_PO_Line_Items__c = 4;
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
        prItem.RequestType__c = 'Non-Stock';
        prItem.GLA__c = gla.get(0).Id;
        prItem.Override_Gla__c = true;
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
        poLine.Quantity_Requested__c = 4;
        poLine.Unit_Price__c = 100;
        poLine.Vatable__c = true;
        poLine.VAT_inclusive__c = true;
       // poLine.GLA__c = gla.get(0).Id;
        poLine.VAT_Percentage__c = '16';
        poLine.Variation_Notes__c = 'notes';
        poLine.Dimension_1__c = department.get(0).id;
        poLine.Terms_Conditions__c = 'Some Terms';
        poLine.Requesting_Company__c=company.get(0).Id; 
        poLine.Variation_Notes__c = 'variation notes'; 
        poLine.Po_line_Receipt_Status__c = 'Open';
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
        viItems.Status__c='Open';
        viItems.Closed__c = false;
        viItems.Accepted_Receive_Quantity__c = 0;
        
        INSERT viItems;
        
        
        
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u.get(0)) {
            
            // List<Vendor_Invoice_Items__c> itm = new List<Vendor_Invoice_Items__c>(); 
            PageReference pageRef = Page.VerifyItemsToReceive;
            
            
            
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(vi);
            ReceiveNonStockItems controller = new ReceiveNonStockItems(sc);
            controller.getItems();
            
            
            
            controller.verifyItems();
            // controller.testa();            
            List<ReceiveNonStockItems.ItemWrapper> items = controller.getItems();
            
            for(ReceiveNonStockItems.ItemWrapper item :items){
                item.site = site.Id;
                item.siteName = site.Name;
                item.setLocations();
                item.setLots();
                item.setLotName();
                item.item.Accepted_Receive_Quantity__c = 4;
            }
            
            // controller.receiveToInventory();
            
            ReceiveNonStockItems.ItemWrapper wrapper = new ReceiveNonStockItems.ItemWrapper(viItems);
            wrapper.setLocations();
            wrapper.setLots();
            wrapper.setLotName();
            wrapper.selected = true;
            wrapper.locationName = 'Mukuru - 001';
            wrapper.lotName = 'Mukuru - 001 - 001';
            wrapper.inventoryQuantity = 0.1;
            wrapper.invUnitPrice = 2.0;
            wrapper.location = 'Mukuru';
            
            viItems.Accepted_Receive_Quantity__c = 4;
            update viItems;
            controller.receiveToInventory();
            
            viItems.Complete_Order__c = true;
            prItem.Status__c = 'Partially Received';  
            poLine.Status__c = 'Items Partially Received'; 
            
            update prItem;
            update poLine;
            
            
            
        }
    }
    
    
}