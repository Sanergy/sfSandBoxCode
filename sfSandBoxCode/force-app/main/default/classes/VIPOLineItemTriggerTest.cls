@isTest(seeAllData=True)
public class VIPOLineItemTriggerTest {
    static testMethod void VIPOLineItemTriggerTest(){
        
        Test.startTest();
        
        VIPOLineItemTriggerTest vipo = new VIPOLineItemTriggerTest();  
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
        INSERT poI;
        
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
        
        //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Dim_2__c = dim2.get(0).id;
        prItem.Dim_3__c = dim3.get(0).id;
        prItem.Grant__c = dim4.get(0).id;
        prItem.GLA__c = gla.get(0).id;
        prItem.Inventory_Item__c = poI.Inventory_Item__c;
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
        prItem.Purchase_Order_Item__c = poI.id; 
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.RequestType__c = 'Stock';
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
      //  poLine.VAT_inclusive__c = fals;
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
        
      
        
        
        Vendor_Invoice_Purchase_Order_Line_Item__c  VIPOLI= new Vendor_Invoice_Purchase_Order_Line_Item__c();
        VIPOLI.Purchase_Order_Line_Item__c =  poLine.Id;
        VIPOLI.Last_Invoice__c = FALSE;
        VIPOLI.Requested_Quantity__c = 1;
        VIPOLI.Item_Received_Total__c = 1;
        VIPOLI.Item_Unit_Cost__c = 0;
        VIPOLI.Item_Vat__c = 0;
        VIPOLI.Reconciled_Item_Quantity_Received__c = 0;
        VIPOLI.Reconciled_Line_Total__c =0;
        //  VIPOLI.Vendor_Invoice__c = 'aHiD0000000Kyta';
        VIPOLI.Last_Invoice__c = TRUE;
        VIPOLI.Vendor_Invoice__c = VI.Id;
        Insert VIPOLI; 
        
                
       // Database.DeleteResult result = Database.delete(VIPOLI, false);
        
        /*Vendor_Invoice_Purchase_Order_Line_Item__c VIPOlITEMS = [SELECT ID,NAME,Purchase_Order_Line_Item__c,Last_Invoice__c,Requested_Quantity__c,
                                                                 Item_Received_Total__c,Item_Unit_Cost__c,Item_Vat__c,Reconciled_Item_Quantity_Received__c,
                                                                 Reconciled_Line_Total__c
                                                                 FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                                                 WHERE ID =:  VIPOLI.ID
                                                                 ];*/
        delete VIPOLI;
        delete vi;

        Test.stopTest();       
        
    }
    
    
}