@isTest(seeAllData=true)
public class CreateJournalFromEPRTest {
    
    static testMethod void createJournalTest(){
        
        //Sanergy EPR
        Electronic_Payment_Request__c sanergy_EPR = [SELECT Id,Name,Company__c
                                                     FROM Electronic_Payment_Request__c
                                                     WHERE Company__c = 'Sanergy Ltd'
                                                     AND Id = 'aDED0000000L1dB'];
        
        //Fresh Life EPR
        Electronic_Payment_Request__c freshlife_EPR = [SELECT Id,Name,Company__c
                                                       FROM Electronic_Payment_Request__c
                                                       WHERE Company__c = 'Fresh Life Initiative Ltd' 
                                                       AND Id = 'aDED0000000L1dG'];
        //Sanergy EPR
        Electronic_Payment_Request__c sanergyFP_EPR = [SELECT Id,Name,Company__c
                                                       FROM Electronic_Payment_Request__c
                                                       WHERE Company__c = 'Sanergy Inc (FP)'
                                                       AND Vendor_Company__r.c2g__CODAAccountTradingCurrency__c = 'USD' 
                                                       AND Id = 'aDED0000000L12AOAS'];
        //Sanergy EPR
        Electronic_Payment_Request__c sanergyNP_EPR = [SELECT Id,Name,Company__c
                                                       FROM Electronic_Payment_Request__c
                                                       WHERE Company__c = 'Sanergy Inc (NP)'
                                                       AND Vendor_Company__r.c2g__CODAAccountTradingCurrency__c = 'USD' 
                                                       AND Id = 'aDED0000000L125OAC']; 
        
        //Add Attachments
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(Name='Doc1', body = bodyBlob, parentId = sanergy_EPR.id); 
        INSERT attach;
        
        Attachment attachPO =new Attachment(Name='Doc2', body = bodyBlob, parentId = sanergy_EPR.id); 
        INSERT attachPO;
        
        sanergy_EPR.Status__c = 'Line Manager Approved';
        //epr.Team_Lead_Approval_Status__c='Approved'; 
        UPDATE sanergy_EPR;
        
        System.debug('CREATE EPR: ' + sanergy_EPR);
        
        //Add Attachments
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body 2');
        Attachment attach2=new Attachment(Name='Doc1', body = bodyBlob2, parentId = freshlife_EPR.id); 
        INSERT attach2;
        
        Attachment attachPO2 =new Attachment(Name='Doc2', body = bodyBlob2, parentId = freshlife_EPR.id); 
        INSERT attachPO2;
        
        freshlife_EPR.Status__c = 'Line Manager Approved';
        //epr.Team_Lead_Approval_Status__c='Approved'; 
        UPDATE freshlife_EPR;
        
        System.debug('CREATE EPR 2: ' + freshlife_EPR);          
        
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
            System.runAs(userFFA.get(0)){               
                
                //test PIN Creation
                PageReference pageRef = Page.Create_PIN_From_EPR;
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(sanergy_EPR);
                CreatePINFromEPR pinController = new CreatePINFromEPR(sc);
                pinController.CreatePINFromEPR();
                
                //test Journal Creation
                pageRef = Page.CreateJournalFromEPR;
                sc = new ApexPages.Standardcontroller(sanergy_EPR);
                CreateJournalFromEPR createJournal = new CreateJournalFromEPR(sc);
                createJournal.createJournal();
                
                //test PIN Creation
                PageReference pageRef2 = Page.Create_PIN_From_EPR;
                ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(freshlife_EPR);
                CreatePINFromEPR pinController2 = new CreatePINFromEPR(sc2);
                pinController2.CreatePINFromEPR();
                
                //test Journal Creation
                pageRef2 = Page.CreateJournalFromEPR;
                sc2 = new ApexPages.Standardcontroller(freshlife_EPR);
                CreateJournalFromEPR createJournal2 = new CreateJournalFromEPR(sc2);
                createJournal2.createJournal();
                
                Test.startTest();
                
                //test PIN Creation
                PageReference pageRef3 = Page.Create_PIN_From_EPR;
                ApexPages.Standardcontroller sc3 = new ApexPages.Standardcontroller(sanergyFP_EPR);
                CreatePINFromEPR pinController3 = new CreatePINFromEPR(sc);
                pinController3.CreatePINFromEPR();
                
                //test Journal Creation
                pageRef3 = Page.CreateJournalFromEPR;
                sc3 = new ApexPages.Standardcontroller(sanergyFP_EPR);
                CreateJournalFromEPR createJournal3 = new CreateJournalFromEPR(sc3);
                createJournal3.createJournal();
                
                //test PIN Creation
                PageReference pageRef4 = Page.Create_PIN_From_EPR;
                ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(sanergyNP_EPR);
                CreatePINFromEPR pinController4 = new CreatePINFromEPR(sc4);
                pinController4.CreatePINFromEPR();
                
                //test Journal Creation
                pageRef4 = Page.CreateJournalFromEPR;
                sc4 = new ApexPages.Standardcontroller(sanergyNP_EPR);
                CreateJournalFromEPR createJournal4 = new CreateJournalFromEPR(sc4);
                createJournal4.createJournal(); 
                Test.stopTest();        
                
                /*Get a sanergy department
                List<FFA_Config_Object__c> department=[SELECT Id, Delegate_s_Threshold_Amount__c 
                FROM FFA_Config_Object__c 
                WHERE Type__c='dim1' 
                AND Name='Sanergy Operations - Supply Chain - Warehouse'
                AND isActive__c=true 
                AND Delegate_s_Threshold_Amount__c > 0 
                LIMIT 1];
                
                //Get a freshLife department
                List<FFA_Config_Object__c> department2=[SELECT Id, Delegate_s_Threshold_Amount__c 
                FROM FFA_Config_Object__c 
                WHERE Type__c='dim1' 
                AND Name='Fresh Life Operations - Installation'
                AND isActive__c=true 
                AND Delegate_s_Threshold_Amount__c > 0 
                LIMIT 1];        
                
                //Get Company
                FFA_Config_Object__c sanergy= [SELECT Id 
                FROM FFA_Config_Object__c 
                WHERE type__c='company' 
                AND Name='Sanergy Limited'
                AND isActive__c=true 
                LIMIT 1];
                
                //Get Company
                FFA_Config_Object__c freshLife= [SELECT Id 
                FROM FFA_Config_Object__c 
                WHERE type__c='company' 
                AND Name='Fresh Life Initiative Limited'
                AND isActive__c=true 
                LIMIT 1];          
                
                //Get the location
                List<FFA_Config_Object__c> location=[SELECT Id 
                FROM FFA_Config_Object__c 
                WHERE Type__c='dim2' 
                AND isActive__c=true
                AND Name='Mukuru'
                LIMIT 1];
                
                //get the dim3
                List<FFA_Config_Object__c> dim3=[SELECT Id 
                FROM FFA_Config_Object__c 
                WHERE Type__c='dim3' 
                AND isActive__c=true 
                AND Name='Not Applicable'
                LIMIT 1];
                
                //get the grant
                List<FFA_Config_Object__c> grant=[SELECT Id 
                FROM FFA_Config_Object__c 
                WHERE Type__c='dim4'  
                AND isActive__c=true
                AND Name='Not Applicable'
                LIMIT 1];
                
                //Get GLA
                List<FFA_Config_Object__c> gla=[SELECT Id 
                FROM FFA_Config_Object__c 
                WHERE Name = '2050 - Accrued Accounts Payable Control'
                AND Type__c='gla' 
                LIMIT 1];
                
                //Get GLA for - Accounts Payable Control
                List<c2g__codaGeneralLedgerAccount__c> accountsPayableControlGLA = [SELECT Id,Name
                FROM c2g__codaGeneralLedgerAccount__c
                WHERE Name = '2000 - Accounts Payable Control'
                LIMIT 1];
                
                //Get GLA for - Accounts Receivable Control
                List<c2g__codaGeneralLedgerAccount__c> accountsReceivableControlGLA = [SELECT Id,Name
                FROM c2g__codaGeneralLedgerAccount__c
                WHERE Name = '1200 - Accounts Receivable Control'
                LIMIT 1];        
                
                //Get employee
                List<Employee__c> employee = [SELECT Id 
                FROM Employee__c 
                WHERE Employee_Active__c=true 
                AND Work_Email__c!=null 
                LIMIT 1];          
                
                //Get Record Type
                List<RecordType> type = [SELECT Id,Name 
                FROM RecordType 
                WHERE Name ='Sanergy Vendor']; 
                
                //Create Account       
                Account ac = new Account();
                ac.Name = 'Nicki Minaj';
                ac.CurrencyIsoCode = 'KES';
                ac.c2g__CODAAccountTradingCurrency__c = 'KES';
                ac.Type = 'Vendor';
                ac.c2g__CODAPaymentMethod__c = 'Check';
                ac.RecordTypeId = type.get(0).Id;
                ac.rstk__Rootstock_Vendor__c=true;
                ac.c2g__CODAAccountsPayableControl__c = accountsPayableControlGLA.get(0).Id;
                ac.c2g__CODAAccountsReceivableControl__c = accountsReceivableControlGLA.get(0).Id;
                INSERT ac;       	
                
                Account ac2 = new Account();
                ac2.Name = 'Nicki Minaj2';
                ac2.CurrencyIsoCode = 'KES';
                ac2.c2g__CODAAccountTradingCurrency__c = 'USD';
                ac2.Type = 'Vendor';
                ac2.c2g__CODAPaymentMethod__c = 'Check';
                ac2.RecordTypeId = type.get(0).Id;
                ac2.rstk__Rootstock_Vendor__c=true;
                ac2.c2g__CODAAccountsPayableControl__c = accountsPayableControlGLA.get(0).Id;
                ac2.c2g__CODAAccountsReceivableControl__c = accountsReceivableControlGLA.get(0).Id;
                INSERT ac2;
                
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
                
                // Create Inventory_UoM__c
                Inventory_UoM__c iUom2 = new Inventory_UoM__c();
                iUom2.Name = 'Dummy Inventory UOM 2';
                iUom2.Description__c = 'Dummy Inventory UOM two';
                iUom2.Uom_Code__c = '102';
                iUom2.CurrencyIsoCode = 'KES';
                INSERT iUom2;        
                
                // Create Inventory_Item_Group__c
                Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
                invItemGroup.Name = 'New Inventory Item Group';
                invItemGroup.Commodity_Code__c = 'New Commodity code';
                invItemGroup.Description__c = 'Brief description';            
                INSERT invItemGroup;
                
                // Create Inventory_Item_Group__c
                Inventory_Item_Group__c invItemGroup2 = new Inventory_Item_Group__c();
                invItemGroup2.Name = 'New Inventory Item Group 2';
                invItemGroup2.Commodity_Code__c = 'New Commodity code 2';
                invItemGroup2.Description__c = 'Brief description 2';            
                INSERT invItemGroup2;        
                
                Group_Details__c debitAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Debit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(0).Id
                );
                
                INSERT debitAc;
                
                Group_Details__c debitAc2 = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup2.Id,
                Credit_Debit__c = 'Debit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(0).Id
                );
                
                INSERT debitAc2;        
                
                Group_Details__c creditAc = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Credit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(0).Id
                );
                
                INSERT creditAc;
                
                Group_Details__c creditAc2 = new Group_Details__c(
                Inventory_Item_Group__c = invItemGroup.Id,
                Credit_Debit__c = 'Credit', 
                Transaction_ID__c = 'PORCPT',
                Is_GL_Account__c = true,
                Config_Account__c = gla.get(0).Id
                );
                
                INSERT creditAc2;        
                
                Inventory_Location__c site = new Inventory_Location__c(
                Name = 'Mukuru'
                );
                INSERT site;
                
                // Create Inventory_Item__c
                Inventory_Item__c invItem = new Inventory_Item__c();
                invItem.Name='Inventory Item 1';  
                invItem.Item_Number__c = '123456';
                invItem.Item_Description__c = 'brief description';
                invItem.Item_Type__c = 'Stock';
                invItem.Item_Company__c = sanergy.Id;
                invItem.Responsible_Department__c = department.get(0).Id;
                invItem.Inventory_UoM__c = iUom.Id;
                invItem.Item_Group__c = invItemGroup.Id;
                invItem.Default_Location__c = 'Mukuru';
                invItem.Default_Lot__c = '3';
                invItem.Currency_Config__c = cc.Id;
                invItem.unit_cost__c = 20;            
                INSERT invItem;
                
                // Create Inventory_Item__c
                Inventory_Item__c invItem2 = new Inventory_Item__c();
                invItem2.Name='Inventory Item 2';  
                invItem2.Item_Number__c = '1234567';
                invItem2.Item_Description__c = 'brief description';
                invItem2.Item_Type__c = 'Stock';
                invItem2.Item_Company__c = freshLife.Id;
                invItem2.Responsible_Department__c = department2.get(0).Id;
                invItem2.Inventory_UoM__c = iUom2.Id;
                invItem2.Item_Group__c = invItemGroup2.Id;
                invItem2.Default_Location__c = 'Mukuru';
                invItem2.Default_Lot__c = '3';
                invItem2.Currency_Config__c = cc.Id;
                invItem2.unit_cost__c = 20;            
                INSERT invItem2;        
                
                Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
                Name = site.Name,
                Location_Name__c = '001',
                Location__c = site.Id,
                Inventory_Item__c = invItem.Id,
                Max_Location_Quantity__c = 100
                );
                
                INSERT itmloc;
                
                Inventory_Item_Location__c itmloc2 = new Inventory_Item_Location__c(
                Name = site.Name,
                Location_Name__c = '002',
                Location__c = site.Id,
                Inventory_Item__c = invItem2.Id,
                Max_Location_Quantity__c = 100
                );
                
                INSERT itmloc2;        
                
                Item_Location_Lot__c lot = new Item_Location_Lot__c(
                Lot_Name__c = '001',
                Quantity__c = 10,
                Item_Location__c = itmloc.Id
                );
                
                INSERT lot;
                
                Item_Location_Lot__c lot2 = new Item_Location_Lot__c(
                Lot_Name__c = '002',
                Quantity__c = 10,
                Item_Location__c = itmloc2.Id
                );
                
                INSERT lot2;        
                
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
                
                //Create Purchase Order Item
                Purchase_Order_Item__c poItem2 =new Purchase_Order_Item__c();
                poItem2.Name = 'PO Item 2';
                poItem2.Item_Description__c = 'brief description 2';
                poItem2.Inventory_Item__c = invItem2.Id; 
                poItem2.Purchase_UoM__c = iUom2.Id;
                poItem2.UOM_Conversion_Factor__c = 1;
                poItem2.Contract_Number__c = c.Id;
                poItem2.Vendor__c = ac.Id; 
                poItem2.Currency__c = cc.Id;   
                poItem2.Status__c = 'Active';
                poItem2.Approved__c = true;
                INSERT poItem2;        
                
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
                INSERT pr;
                
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
                INSERT prItem; 
                
                pr.Team_Lead_Approval_Status__c = 'Approved';
                pr.Stage__c= 'Team Lead Approved';
                UPDATE pr;
                
                prItem.Status__c = 'Pending Purchase Order';
                UPDATE prItem;
                
                //Create PR
                Procurement_Tracking_Sheet__c pr2 = new Procurement_Tracking_Sheet__c();
                pr2.Requestor_Type__c = 'Employee';
                pr2.Required_Date__c = Date.today() + 14;
                pr2.Requesting_Department__c = department2.get(0).id;
                pr2.Maintenance_Department__c = department2.get(0).id;
                pr2.Priority__c = 'Low';
                pr2.Remarks__c = 'Some remarks'; 
                pr2.Requestor__c = employee.get(0).id;
                pr2.High_Priority_Comments__c = 'comment';
                pr2.Requesting_Company__c = invItem2.Item_Company__c;
                INSERT pr2;
                
                //Create PRLine
                PTS_Line_Item__c prItem2 = new PTS_Line_Item__c();        
                prItem2.Procurement_Tracking_Sheet__c = pr2.Id;
                prItem2.Department__c = department2.get(0).id;
                prItem2.Inventory_Item__c = invItem2.Id;
                prItem2.Requesting_Company__c = invItem2.Item_Company__c;
                prItem2.Item__c = 'Test Item';
                prItem2.Override_PR_Item_Cost_Check__c = true;
                prItem2.Override_Justification__c = 'just';
                prItem2.Specifications__c = 'Test Specifications';
                prItem2.Quantity__c = 1000;
                prItem2.Budget_Amount__c= 1000000000;
                prItem2.Currency_Config__c = cc.id; 
                prItem2.Purchase_Order_Item__c = poItem2.id; 
                prItem2.non_primary_vendor_description__c = 'coment';
                prItem2.RequestType__c = 'Stock';
                prItem2.GLA__c = gla.get(0).Id;
                prItem2.Override_Gla__c = true;
                INSERT prItem2; 
                
                pr2.Team_Lead_Approval_Status__c = 'Approved';
                pr2.Stage__c= 'Team Lead Approved';
                UPDATE pr2;
                
                prItem2.Status__c = 'Pending Purchase Order';
                UPDATE prItem2;        
                
                //Create Purchase Order
                Purchase_Order__c po =new Purchase_Order__c();
                po.Vendor_Account__c = ac.Id;
                po.Company__c = sanergy.Id;
                po.PO_Currency__c = cc.Id;
                po.Order_Status__c = 'Open';        
                INSERT po;
                
                //Create Purchase Order
                Purchase_Order__c po2 =new Purchase_Order__c();
                po2.Vendor_Account__c = ac.Id;
                po2.Company__c = freshLife.Id;
                po2.PO_Currency__c = cc.Id;
                po2.Order_Status__c = 'Open';        
                INSERT po2;        
                
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
                poLine.Requesting_Company__c=sanergy.Id;
                poLine.Variation_Notes__c = 'variation notes'; 
                poLine.Status__c = 'Open';        
                INSERT poLine;
                
                //Create Purchase Order Line Item
                Purchase_Order_Line_Item__c poLine2 = new Purchase_Order_Line_Item__c();
                poLine2.Name = 'Purchase Order Line Item 2';
                poLine2.Purchase_Order__c = po2.Id;
                poLine2.Purchase_Order_Item__c = poItem2.Id;
                poLine2.PTS_Line_Item__c = prItem2.id;
                poLine2.Item__c = 'Test Item 2';
                poLine2.Quantity_Requested__c = 1;
                poLine2.Unit_Price__c = 100;
                poLine2.Vatable__c = true;
                poLine2.VAT_inclusive__c = true;
                poLine2.VAT_Percentage__c = '16';
                poLine2.Variation_Notes__c = 'notes';
                poLine2.Dimension_1__c = department2.get(0).id;
                poLine2.Terms_Conditions__c = 'Some Terms';
                poLine2.Requesting_Company__c=freshLife.Id;
                poLine2.Variation_Notes__c = 'variation notes'; 
                poLine2.Status__c = 'Open';        
                INSERT poLine2;        
                
                // Create Vendor Invoice
                Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
                vi.Vendor__c = po.Vendor_Account__c;
                vi.Currency_Config_Currency__c = po.PO_Currency__c;
                vi.Contract_Number__c = c.Id;                        
                vi.Status__c='Open';
                vi.Actual_Date__c = date.today();
                vi.Vendor_Invoice_date__c = date.today();
                vi.Comments__c = 'comments';
                INSERT vi;
                
                Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
                viItems.Vendor_Invoice__c = vi.Id ;
                viItems.Purchase_Order_Line_Item__c = poLine.Id;
                viItems.Company__c = sanergy.Id;
                viItems.Quantity__c = 1;
                viItems.Status__c='Pending GIGO Check';
                viItems.Closed__c = false;        
                INSERT viItems;
                
                // Create Vendor Invoice
                Vendor_Invoice__c vi2 = new Vendor_Invoice__c ();            
                vi2.Vendor__c = ac2.Id;
                vi2.Currency_Config_Currency__c = po2.PO_Currency__c;
                //vi2.Contract_Number__c = c.Id;                        
                vi2.Status__c='Open';
                vi2.Actual_Date__c = date.today();
                vi2.Vendor_Invoice_date__c = date.today();
                vi2.Comments__c = 'comments 2';
                INSERT vi2;
                
                Vendor_Invoice_Items__c viItems2 = new Vendor_Invoice_Items__c();
                viItems2.Vendor_Invoice__c = vi2.Id ;
                viItems2.Purchase_Order_Line_Item__c = poLine2.Id;
                viItems2.Company__c = freshLife.Id;
                viItems2.Quantity__c = 1;
                viItems2.Status__c='Pending GIGO Check';
                viItems2.Closed__c = false;        
                INSERT viItems2;
                
                poLine.Invoice_Assigned__c = true;
                UPDATE poline;
                
                viItems.Accepted_Receive_Quantity__c = 1;
                viItems.Status__c = 'GIGO Checked';
                UPDATE viItems;
                
                poLine2.Invoice_Assigned__c = true;
                UPDATE poline2;
                
                viItems2.Accepted_Receive_Quantity__c = 1;
                viItems2.Status__c = 'GIGO Checked';
                UPDATE viItems2;          
                
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
                Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1,
                Quantity__c=1,
                Department_dim1__c=department.get(0).Id,
                Location_Dim2__c=location.get(0).Id,
                Dim_3__c=dim3.get(0).Id,
                Grant_Funding_Availale_dim4__c=grant.get(0).Id,
                GLA__c=gla.get(0).Id
                );
                
                INSERT eprPayable;
                
                //create EPR
                Electronic_Payment_Request__c epr2 =new Electronic_Payment_Request__c();
                epr2.department__c=department2.get(0).Id;
                epr2.Company__c='Fresh Life Initiative Ltd';
                epr2.Vendor_Company__c= ac2.Id;
                epr2.Invoice_Number__c='INVOICE1235'; 
                epr2.Vendor_Invoice_Number__c = vi2.Id;
                epr2.Scheduled_Payment_Date__c=Date.today()+10;              
                epr2.Payment_Type__c='Prepayment';
                epr2.Preferred_Payment_Method__c = 'Check';
                epr2.Payment_Method__c = 'Check';
                epr2.Status__c='Open';
                epr2.Confirmation_Number__c = '123456789';
                //epr.Notes__c = 'some notes';
                epr2.Team_Lead_Approval_Status__c=null;
                epr2.Cash_Entry__c=null;
                INSERT epr2;            
                
                //Insert EPR Line items
                EPR_Payable_Item__c eprPayable2=new EPR_Payable_Item__c(
                EPR__c=epr2.id,
                Item__c='test Item',
                Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1,
                Quantity__c=1,
                Department_dim1__c=department2.get(0).Id,
                Location_Dim2__c=location.get(0).Id,
                Dim_3__c=dim3.get(0).Id,
                Grant_Funding_Availale_dim4__c=grant.get(0).Id,
                GLA__c=gla.get(0).Id
                );
                
                INSERT eprPayable2;*/        
                
            }
        }        
    }    
}