@isTest(seeAllData = true)
public class RequisitionWorkBenchControllerTest{
    
    public static TestMethod void RequisitionWorkBenchControllerTest(){
        
        //************************START************************
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id,Name 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE type__c='dim1' 
                                                 AND isActive__c=true 
                                                 AND Teamlead__c <> null 
                                                 AND Name = 'Information Technology'
                                                 LIMIT 1];      
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT Id,Name 
                                             FROM FFA_Config_Object__c 
                                             WHERE type__c='company' 
                                             AND isActive__c=true 
                                             AND Name = 'Sanergy Limited'
                                             LIMIT 1];        
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id,Name 
                                         FROM FFA_Config_Object__c 
                                         WHERE type__c='gla' 
                                         AND isActive__c=true 
                                         AND Name = '1410 - Inventory - Raw Material' 
                                         LIMIT 1];
        
        //Get employee
       List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];        
        
        // Select Account
        List<Account> ac= [SELECT Id,Name,CurrencyIsoCode
                           FROM Account
                           WHERE Name='Tuffsteel Ltd'];
        
        List<RecordType> purchaseRecordType = [SELECT id FROM RecordType
                                               WHERE Name = 'Purchase Request Replenishment'
                                               AND SObjectType = 'Inventory_Replenishment_Tracker__c'];        
        
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
        invItem.Item_Type__c = 'Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Inventory_UoM__c = iUom.Id;
        invItem.Item_Group__c = invItemGroup.Id;
        invItem.Item_Source__c = 'Purchased';
        invItem.Default_Location__c = 'Mukuru';
        invItem.Default_Lot__c = '3';
        invItem.Currency_Config__c = cc.Id;
        invItem.unit_cost__c = 20;
        invItem.Policy_Quantity__c = 200;
        INSERT invItem;

        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc; 
        
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
        poItem.Primary_Vendor__c =  true;
        poItem.Item_Cost__c = 300;
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
        pr.Requestor_Type__c = 'Reorder Level';
        pr.High_Priority_Comments__c = 'comment';
        pr.Requesting_Company__c = invItem.Item_Company__c;
        INSERT pr;
        System.debug('THE PR === ' + pr.Requesting_Company__c);
        
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
        prItem.Override_Gla__c = true;
        prItem.Unit_Quote_Price__c = poItem.Item_Cost__c;
        prItem.Vatable__c = poItem.Vatable__c;
        prItem.VAT_Inclusive__c = poItem.VAT_Inclusive__c;
        prItem.VAT_Percentage__c = poItem.VAT_Percentage__c;       
        insert prItem;

        //pr.Team_Lead_Approval_Status__c = 'Approved';
        //pr.Stage__c= 'Team Lead Approved';
        //update pr;
       
        //prItem.Status__c = 'Pending Purchase Order';
        //update prItem;        
        //************************END**************************
    
         /*List<Inventory_item__c> items = [Select Id,Policy_Quantity__c,Default_Site__c,Item_Company__c,
                                            Item_Description__c
                                            FROM Inventory_item__c
                                            WHERE Item_Group__c != null 
                                            AND Item_Source__c = 'Purchased'
                                            AND Policy_Quantity__c!=null
                                            AND ID IN (SELECT inventory_item__c FROM Purchase_Order_Item__c WHERE Vendor_Type__c = 'Primary' AND Vendor__c!= null)
                                            LIMIT 1
                                         ];
                                         
          if(items.size() > 0){
              items.get(0).Policy_Quantity__c = 200;
              update items;
                List<RecordType> purchaseRecordType = [SELECT id FROM RecordType
                                               WHERE Name = 'Purchase Request Replenishment'
                                               AND SObjectType = 'Inventory_Replenishment_Tracker__c'];
                                               
                Map<String, Sanergy_Settings_Supply_Chain__c> settings = Sanergy_Settings_Supply_Chain__c.getAll();
        
              List<Purchase_Order_Item__c> poItems = [SELECT id,Inventory_Item__r.Item_Company__c,Gross_Value__c, UOM_Conversion_Factor__c,Item_Cost__c,Vatable__c,VAT_Inclusive__c,VAT_Percentage__c,
                                                      Currency__c, Vendor__c,Inventory_Item__c, Inventory_Item__r.Item_Source__c, inventory_item__r.Policy_Quantity__c,
                                                      Inventory_Item__r.Item_Description__c
                                                      FROM Purchase_Order_Item__c
                                                      WHERE Vendor_Type__c = 'Primary'
                                                      AND Inventory_Item__c = :items.get(0).id
                                                      AND Status__c = 'Active'
                                                      AND Approved__c = true];
                Purchase_Order_Item__c item = poItems.get(0);                                 
              //Create PR 
                Procurement_Tracking_Sheet__c pr =  new Procurement_Tracking_Sheet__c(
                    Requestor_Type__c = 'Reorder Level',
                    Required_Date__c = Date.today() + 14,
                    Requesting_Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                    Requesting_Company__c = item.Inventory_Item__r.Item_Company__c,
                    Maintenance_Department__c = settings.get('Dimension 1 - Supply Chain').value__c
                );
                
                insert pr;
                
                
                
                //Create PR Lines
                PTS_Line_Item__c pLines= new PTS_Line_Item__c(
                    Item__c = items.get(0).Item_Description__c,
                    Specifications__c = items.get(0).Item_Description__c,
                    Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                    Dim_2__c = settings.get('Dimension 2 - Mukuru').value__c,
                    Dim_3__c = settings.get('Dimension 3 - Not Applicable').value__c,
                    Grant__c = settings.get('Dimension 4 - Not Applicable').value__c,
                    GLA__c = settings.get('GLA - Inventory Items').value__c,
                    Requesting_Company__c = item.Inventory_Item__r.Item_Company__c,
                    Inventory_Item__c = item.Inventory_Item__c,
                    Quantity__c = item.Inventory_Item__r.Policy_Quantity__c ,
                    Budget_Amount__c = (item.Inventory_Item__r.Policy_Quantity__c  * item.Gross_Value__c ),
                    Currency_Config__c = item.Currency__c,
                    Vendor__c = item.Vendor__c,
                    Purchase_Order_Item__c = item.id,
                    Quote_Currency__c = item.Currency__c,
                    Unit_Quote_Price__c = item.Item_Cost__c,
                    Vatable__c = item.Vatable__c,
                    VAT_Inclusive__c = item.VAT_Inclusive__c,
                    VAT_Percentage__c = item.VAT_Percentage__c,
                    Procurement_Tracking_Sheet__c = pr.id,
                    Override_PR_Item_Cost_Check__c = true,
                    Override_Justification__c = 'just',
                    non_primary_vendor_description__c = 'coment',
                    RequestType__c = 'Stock',
        			Override_Gla__c = true
                );
                
                insert pLines;*/
              
               Inventory_Replenishment_Tracker__c tracker = new Inventory_Replenishment_Tracker__c(
                    recordTypeId = purchaseRecordType.get(0).id,
                    Inventory_Item__c = invItem.Id,
                    Procurement_Request_Line_Item__c = prItem.id,
                    Quantity_Pending__c = invItem.Policy_Quantity__c              
               );
                
              insert tracker;
             //   try{
              //Create controller
              RequisitionWorkBenchController rqWorkBnchCtrl = new RequisitionWorkBenchController();
              
              rqWorkBnchCtrl.getStatuses();
              rqWorkBnchCtrl.selectedStatus = 'Planned';
              rqWorkBnchCtrl.refreshList();
              rqWorkBnchCtrl.rList.get(0).selected = true;
              rqWorkBnchCtrl.rList.get(0).tracker.Procurement_Request_Line_Item__c = prItem.id;
              update rqWorkBnchCtrl.rList.get(0).tracker;
            
              rqWorkBnchCtrl.firmRequests();             
              
              rqWorkBnchCtrl.selectedStatus = 'Firmed';
              rqWorkBnchCtrl.refreshList();		
              rqWorkBnchCtrl.rList.get(0).selected = true;  
              //rqWorkBnchCtrl.pos.get(0).tracker.Procurement_Request_Line_Item__c = pLines.id;
              //update rqWorkBnchCtrl.rList.get(0).tracker;
              try{
              rqWorkBnchCtrl.approveRequests();
              }catch(Exception e){e.getMessage();}
              rqWorkBnchCtrl.selectedStatus = 'Approved';
              rqWorkBnchCtrl.refreshList();
              rqWorkBnchCtrl.rList.get(0).selected = true;
              rqWorkBnchCtrl.getSelectedForVendorChange();
              rqWorkBnchCtrl.rList.get(0).poLine.Variation_Notes__c = 'Some Explanation';
              rqWorkBnchCtrl.saveVendorChange();              
              rqWorkBnchCtrl.getItemsToAdd();  
              
              /*List<Purchase_Order_Item__c> poItem = [SELECT Inventory_Item__c
                                                       FROM Purchase_Order_Item__c
                                                       WHERE Vendor_Type__c = 'Primary'
                                                       AND Primary_Vendor__c =  true
                                                       AND UOM_Conversion_Factor__c!=null
                                                       LIMIT 1];*/
                                                       
              rqWorkBnchCtrl.itemsToAdd.get(0).tracker.Inventory_Item__c = poItem.Inventory_Item__c; 
              rqWorkBnchCtrl.itemsToAdd.get(0).tracker.Quantity_Pending__c = 10;
              rqWorkBnchCtrl.saveItemsToAdd();               
               
              rqWorkBnchCtrl.getItemsToAdd(); 
              rqWorkBnchCtrl.removeItemLine();
             // rqWorkBnchCtrl.manualRunMPR();
              rqWorkBnchCtrl.cancelRequests();
              rqWorkBnchCtrl.closePopup();
              //    }catch(Exception e){e.getMessage();}
           
          //}
    }
}