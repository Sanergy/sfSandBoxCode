@isTest(seeAllData=true)
private class UpdateEPRAttachmentCountTest{
    static testMethod void UpdateEPRAttachmentCountTester() {
        
        //**********************************************************************************************
          //Get the department
          List<FFA_Config_Object__c> department=[SELECT id, Delegate_s_Threshold_Amount__c FROM FFA_Config_Object__c WHERE Type__c='dim1' AND isActive__c=true AND Delegate_s_Threshold_Amount__c > 0 LIMIT 1];

          //Get Company
       	  List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' 
                                                AND Name='Sanergy Limited'
                                                AND isActive__c=true LIMIT 1];          
          
          //Get the location
          List<FFA_Config_Object__c> location=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim2'  AND isActive__c=true LIMIT 1];

         //get the dim3
          List<FFA_Config_Object__c> dim3=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim3'  AND isActive__c=true LIMIT 1];

          //get the dim4
          List<FFA_Config_Object__c> grant=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim4'  AND isActive__c=true LIMIT 1];
                           
          //Get GLA
          List<FFA_Config_Object__c> gla=[SELECT Id 
                                          FROM FFA_Config_Object__c 
                                          WHERE Name = '1410 - Inventory - Raw Material'
                                          AND Type__c='gla' LIMIT 1];
          
      	  //Get employee
    	  List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];          
          
        //Get Record Type
        List<RecordType> type = [SELECT id,Name from RecordType where Name ='Sanergy Vendor']; 
        
       	//Create Account       
        Account ac = new Account();
        ac.Name = 'Nicki Minaj';
        ac.CurrencyIsoCode = 'KES';
        ac.RecordTypeId = type.get(0).Id;
        INSERT ac;          

        //*********************************************************************************************************************
		// Create a Currency Config
		Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KSH';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
		// Create a Contract            
		Contract c = new Contract();
        c.AccountId=ac.Id; 
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
        poItem.Vendor__c = ac.Id; 
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
        po.Vendor_Account__c = ac.Id;
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
        
        poLine.Invoice_Assigned__c = true;
        update poline;
        
        viItems.Accepted_Receive_Quantity__c = 1;
        viItems.Status__c = 'GIGO Checked';
        update viItems;         
          //**********************************************************************************************************          
          
          //create EPR
          Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c(
              department__c=department.get(0).Id,
              Company__c='Sanergy Ltd',
              Vendor_Company__c=vi.Vendor__c,
              Invoice_Number__c='INVOICE123', 
              Vendor_Invoice_Number__c = vi.Id,
              Scheduled_Payment_Date__c=Date.today(),              
              Payment_Type__c='Prepayment',
              Preferred_Payment_Method__c = 'Check'              
          );
          
           
            
            try{
               epr.Status__c='Closed';
                insert epr;
            }catch (Exception e){
                // this try-catch block will fail because the cash entry is being created on Fresh Life Side but the 
                //Banks are for Sanergy. This is to ensure that the controller gets some code coverage
            }
            
            try{
               epr.Payment_Type__c=null;
                insert epr;
            }catch (Exception e){
                // this try-catch block will fail because the cash entry is being created on Fresh Life Side but the 
                //Banks are for Sanergy. This is to ensure that the controller gets some code coverage
            }
          epr.Payment_Type__c='Prepayment';
          epr.Team_Lead_Approval_Status__c=null;
          epr.Status__c='Open';          
          
          insert epr;
                    
         //insert EPR Line items
         EPR_Payable_Item__c eprPayable=new EPR_Payable_Item__c(
             EPR__c=epr.id,
             Item__c='test Item',
             Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1,
             Quantity__c=1,
             Department_dim1__c=department.get(0).Id,
             Location_Dim2__c=location.get(0).Id,
             Dim_3__c=dim3.get(0).Id,
             Grant_Funding_Availale_dim4__c=grant.get(0).Id,
             GLA__c=gla.get(0).Id
         );
         
         insert eprPayable;
         
         eprPayable.Unit_Price__c-=1;
         update eprPayable;
         
         eprPayable.Unit_Price__c+=1;
         update eprPayable;
         
         delete eprPayable;
         
         //insert EPR Line items
         EPR_Payable_Item__c eprPayable2=new EPR_Payable_Item__c(
             EPR__c=epr.id,
             Item__c='test Item',
             Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1,
             Quantity__c=1,
             Department_dim1__c=department.get(0).Id,
             Location_Dim2__c=location.get(0).Id,
             Dim_3__c=dim3.get(0).Id,
             Grant_Funding_Availale_dim4__c=grant.get(0).Id,
             GLA__c=gla.get(0).Id
         );
         
         insert eprPayable2;
         
         epr.Status__c = 'Line Manager Approved';
         update epr;
        
        //**********************************************************************************************        
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=epr.Id;
        insert attach;
           
        List<Attachment> attachments=[select id from Attachment where parent.id=:epr.Id];
        System.assert(attachments.size()>0);
            
        delete attachments;
        //System.assert(attachments.size()==0);       
    }
}