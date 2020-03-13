@isTest(seeAllData=true)
private class ValidateEPRTriggerTest  {    
    
    /*------------------Test Class for the ValidateEPR Trigger------------------------- */  
    static testMethod void ValidateEPRTriggerTest() {
        
        //Get the department
        List<FFA_Config_Object__c> department=[SELECT Id, Delegate_s_Threshold_Amount__c 
                                               FROM FFA_Config_Object__c 
                                               WHERE Type__c='dim1' 
                                               AND Name='Sanergy Operations - Supply Chain - Warehouse'
                                               AND isActive__c=true 
                                               AND Delegate_s_Threshold_Amount__c > 0 
                                               LIMIT 1];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT Id 
                                             FROM FFA_Config_Object__c 
                                             WHERE type__c='company' 
                                             AND Name='Sanergy Limited'
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
        ac2.CurrencyIsoCode = 'USD';
        ac2.c2g__CODAAccountTradingCurrency__c = 'USD';
        ac2.Type = 'Vendor';
        ac2.c2g__CODAPaymentMethod__c = 'Check';
        ac2.RecordTypeId = type.get(0).Id;
        ac2.rstk__Rootstock_Vendor__c=true;
        ac2.c2g__CODAAccountsPayableControl__c = accountsPayableControlGLA.get(0).Id;
        ac2.c2g__CODAAccountsReceivableControl__c = accountsReceivableControlGLA.get(0).Id;
        INSERT ac2;
        
        Account acEUR = new Account();
        acEUR.Name = 'Nicki Minaj2';
        acEUR.CurrencyIsoCode = 'EUR';
        acEUR.c2g__CODAAccountTradingCurrency__c = 'EUR';
        acEUR.Type = 'Vendor';
        acEUR.c2g__CODAPaymentMethod__c = 'Check';
        acEUR.RecordTypeId = type.get(0).Id;
        acEUR.rstk__Rootstock_Vendor__c=true;
        acEUR.c2g__CODAAccountsPayableControl__c = accountsPayableControlGLA.get(0).Id;
        acEUR.c2g__CODAAccountsReceivableControl__c = accountsReceivableControlGLA.get(0).Id;
        INSERT acEUR;
        
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
        c.AccountId=ac.Id; 
        c.Status = 'Draft';
        c.StartDate=date.today();
        c.ContractTerm=1;
        c.CurrencyIsoCode='KES';
        c.Payment_Terms__c='7 Days';
        c.Primary_Contract__c=true;
        INSERT c;
        
        /*
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
        
        INSERT debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'PORCPT',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        INSERT creditAc;
        
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
        
        INSERT itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
        
        INSERT lot;
        
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

        poLine.Invoice_Assigned__c = true;
        UPDATE poline;
        
        // Create Vendor Invoice
        Vendor_Invoice__c vi = new Vendor_Invoice__c ();            
        vi.Vendor__c = ac.Id;
        vi.Currency_Config_Currency__c = cc.Id;
        vi.Contract_Number__c = c.Id;                        
        vi.Status__c='Open';
        vi.Actual_Date__c = date.today();
        vi.Vendor_Invoice_date__c = date.today();
        vi.Comments__c = 'comments';
        INSERT vi;
        
        Vendor_Invoice_Items__c viItems = new Vendor_Invoice_Items__c();
        viItems.Vendor_Invoice__c = vi.Id ;
        viItems.Purchase_Order_Line_Item__c = poLine.Id;
        viItems.Company__c = company.get(0).Id;
        viItems.Quantity__c = 4;
        viItems.Status__c='Pending GIGO Check';
        viItems.Closed__c = false;        
        INSERT viItems;
        
        // Create Vendor Invoice
        Vendor_Invoice__c vi2 = new Vendor_Invoice__c ();            
        vi2.Vendor__c = ac2.Id;
        vi2.Currency_Config_Currency__c = cc.Id;
        //vi2.Contract_Number__c = c.Id;                        
        vi2.Status__c='Open';
        vi2.Actual_Date__c = date.today();
        vi2.Vendor_Invoice_date__c = date.today();
        vi2.Comments__c = 'comments';
        INSERT vi2;
        
        /*
        Vendor_Invoice_Items__c viItems2 = new Vendor_Invoice_Items__c();
        viItems2.Vendor_Invoice__c = vi2.Id ;
        viItems2.Purchase_Order_Line_Item__c = poLine.Id;
        viItems2.Company__c = company.get(0).Id;
        viItems2.Quantity__c = 4;
        viItems2.Status__c='Pending GIGO Check';
        viItems2.Closed__c = false;        
        INSERT viItems2;
        
        viItems.Accepted_Receive_Quantity__c = 1;
        viItems.Status__c = 'GIGO Checked';
        UPDATE viItems;                   
  */      
        //create EPR
        Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c();
        epr.department__c=department.get(0).Id;
        epr.Company__c='Sanergy Ltd';
        epr.Vendor_Company__c= ac.Id;
        epr.Invoice_Number__c='INVOICE123'; 
        //epr.Vendor_Invoice_Number__c = vi.Id;
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
        
        
        epr.Status__c = 'Line Manager Approved';
        //epr.Team_Lead_Approval_Status__c='Approved'; 
        //UPDATE epr;
        
        System.debug('CREATE EPR: ' + epr);
        System.debug('CREATE EPR LINE ITEM: ' + eprPayable);     
        
        //create EPR
        Electronic_Payment_Request__c epr2 =new Electronic_Payment_Request__c();
        epr2.department__c=department.get(0).Id;
        epr2.Company__c='Fresh Life Initiative Ltd';
        epr2.Vendor_Company__c= ac2.Id;
        epr2.Invoice_Number__c='INVOICE123'; 
        //epr2.Vendor_Invoice_Number__c = vi2.Id;
        epr2.Scheduled_Payment_Date__c=Date.today()+10;              
        epr2.Payment_Type__c='Prepayment';
        epr2.Preferred_Payment_Method__c = 'Check';
        epr2.Payment_Method__c = 'Check';
        epr2.Status__c='Open';
        epr2.Confirmation_Number__c = '12345678';
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
            Department_dim1__c=department.get(0).Id,
            Location_Dim2__c=location.get(0).Id,
            Dim_3__c=dim3.get(0).Id,
            Grant_Funding_Availale_dim4__c=grant.get(0).Id,
            GLA__c=gla.get(0).Id
        );
        
        INSERT eprPayable2; 
        epr2.Status__c = 'Line Manager Approved';
        //UPDATE epr2;
        
        //create EPR for SLK EUR
        Electronic_Payment_Request__c eprSLKEUR =new Electronic_Payment_Request__c();
        eprSLKEUR.department__c=department.get(0).Id;
        eprSLKEUR.Company__c='Sanergy Ltd';
        eprSLKEUR.Vendor_Company__c= acEUR.Id;
        eprSLKEUR.Invoice_Number__c='INVOICE123'; 
        eprSLKEUR.Vendor_Invoice_Number__c = NULL;
        eprSLKEUR.Scheduled_Payment_Date__c=Date.today()+10;              
        eprSLKEUR.Payment_Type__c='Prepayment';
        eprSLKEUR.Preferred_Payment_Method__c = 'Check';
        eprSLKEUR.Payment_Method__c = 'Check';
        eprSLKEUR.Status__c='Open';
        eprSLKEUR.Confirmation_Number__c = '12345678';
        //epr.Notes__c = 'some notes';
        eprSLKEUR.Team_Lead_Approval_Status__c=null;
        eprSLKEUR.Cash_Entry__c=null;
        INSERT eprSLKEUR;            
        
        eprSLKEUR.Status__c = 'Line Manager Approved';
        //UPDATE eprSLKEUR;
        
        //Insert EPR Line items
        EPR_Payable_Item__c eprPayableSLKEUR=new EPR_Payable_Item__c(
            EPR__c=eprSLKEUR.id,
            Item__c='test Item',
            Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1,
            Quantity__c=1,
            Department_dim1__c=department.get(0).Id,
            Location_Dim2__c=location.get(0).Id,
            Dim_3__c=dim3.get(0).Id,
            Grant_Funding_Availale_dim4__c=grant.get(0).Id,
            GLA__c=gla.get(0).Id
        );
        
        INSERT eprPayableSLKEUR; 
        
        
        //Add Attachments
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(Name='Doc1', body = bodyBlob, parentId=epr.id); 
        insert attach;

        Attachment attachPO =new Attachment(Name='Doc2', body = bodyBlob, parentId= epr.id); 
        insert attachPO;
 
        
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
            System.runAs(userFFA.get(0)){                
                //test PIN Creation
                PageReference pageRef = Page.Create_PIN_From_EPR;
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(epr);
                CreatePINFromEPR pinController = new CreatePINFromEPR(sc);
                pinController.CreatePINFromEPR();
                
                //test Journal Creation
                pageRef = Page.CreateJournalFromEPR;
                sc = new ApexPages.Standardcontroller(epr);
                /*CreateJournalFromEPR createJournal = new CreateJournalFromEPR(sc);
                createJournal.createJournal();*/
                
                //test Cash Entry Creation
                pageRef = Page.Create_Cash_Entry_From_EPR;
                sc = new ApexPages.Standardcontroller(epr);
                CreateCashEntryFromEPR cashEntrycontroller = new CreateCashEntryFromEPR(sc);
                cashEntrycontroller.createCashEntryWithLines();

                //Update EPR to USD VEndor
                epr.Cash_Entry__c= NULL;
                epr.Vendor_Company__c = ac2.id;//Test USD
                UPDATE epr;
                
                //Test existing CSH Exists
                cashEntrycontroller.createCashEntryWithLines();
                
                //update EPR with the CSH generated
                epr.Cash_Entry__c= cashEntrycontroller.cshEntryID;
                epr.Vendor_Company__c = ac2.id;//Test USD
                UPDATE epr;
                
                //Test existing CSH Exists
                cashEntrycontroller.createCashEntryWithLines();
                
                
                //post the cash entry
                List<c2g.CODAAPICommon.Reference> cashEntryRefs = new List<c2g.CODAAPICommon.Reference>();
                cashEntryRefs.add(c2g.CODAAPICommon.getRef(cashEntrycontroller.cshEntryID, null));
                try{
                   c2g.CODAAPICashEntry_6_0.BulkPostCashEntry(null, cashEntryRefs); 
                }
                catch (Exception e){
                    system.debug('FFA CSH Error: '+ e.getMessage());
                }
                
				
                
                //Test SLK EUR
                PageReference pageRefSLKEUR = Page.Create_Cash_Entry_From_EPR;
                ApexPages.Standardcontroller scSLKEUR = new ApexPages.Standardcontroller(eprSLKEUR);
                CreateCashEntryFromEPR cashEntrycontrollerSLKEUR = new CreateCashEntryFromEPR(scSLKEUR);
                cashEntrycontrollerSLKEUR.createCashEntryWithLines();

                //to increase test coverage
                eprSLKEUR.Payment_Method__c = 'Electronic';
                eprSLKEUR.Vendor_Company__c = ac2.id;
                UPDATE eprSLKEUR;
                
                cashEntrycontrollerSLKEUR.createCashEntryWithLines();
                
                //Reset Govenor Limits to avoid 'Too many SOQL error'
                Test.startTest();
                
                //To test FLI Company
                List<String> fliCo = new List<String>();
                fliCo.add('Fresh Life Initiative Limited');
                c2g.CODAAPICompany_2_0.SetCurrentCompanies(fliCo);
                              
                //update the EPR to FLI
                eprSLKEUR.Company__c = 'Fresh Life Initiative Ltd';
                eprSLKEUR.Cash_Entry__c = NULL;
                eprSLKEUR.Payable_Invoice__c = NULL;
                UPDATE eprSLKEUR; 
                
                PageReference pageRefFLIEUR = Page.Create_Cash_Entry_From_EPR;
                ApexPages.Standardcontroller scFLIEUR = new ApexPages.Standardcontroller(eprSLKEUR); //Reuse this EPR
                CreateCashEntryFromEPR cashEntrycontrollerFLIEUR = new CreateCashEntryFromEPR(scFLIEUR);
                cashEntrycontrollerFLIEUR.createCashEntryWithLines();
                
                //update the EPR to FLI
                eprSLKEUR.Company__c = 'Fresh Life Initiative Ltd';
                eprSLKEUR.Cash_Entry__c = NULL;
                eprSLKEUR.Payable_Invoice__c = NULL;
                eprSLKEUR.Payment_Method__c='Check';
                UPDATE eprSLKEUR;
                
                cashEntrycontrollerFLIEUR.createCashEntryWithLines();
                
                //Test USD
                eprSLKEUR.Vendor_Company__c = ac.id;
                UPDATE eprSLKEUR;
                cashEntrycontrollerFLIEUR.createCashEntryWithLines();
                
                Test.stopTest();

    /*            
                //Test.stopTest();
                
                
                //Test Create pin from sprTest
                pageRef = Page.CreatePinFromSPR;
                sc = new ApexPages.Standardcontroller(epr);
                CreatePinFromSPR sprPin = new CreatePinFromSPR(sc);
                //sprPin.CreatePin();                
                
                List<c2g__codaCashEntry__c> cashEntry=[SELECT c2g__Status__c 
                                                       FROM c2g__codaCashEntry__c
                                                       WHERE id=: epr.Cash_Entry__c];

                
                if(cashEntry.size()>0){
                    cashEntry.get(0).c2g__Status__c='Complete';
                    //cashEntry.get(0).c2g__Description__c='Test Description';
                    UPDATE cashEntry;
                    System.debug('Cash entry posted on '+epr.Payment_Date__c);
                }         
                else{
                    System.debug('Cash entry not created');
                }  
                
                //Reset Govenor Limits to avoid 'Too many SOQL error'
                Test.startTest();
                
                //To test FLI Company
                List<String> fliCo = new List<String>();
                fliCo.add('Fresh Life Initiative Limited');
                system.debug('FFA Co Current = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                c2g.CODAAPICompany_2_0.SetCurrentCompanies(fliCo);
                System.assertEquals('Fresh Life Initiative Limited', c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                system.debug('FFA Co New = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                
                //update the EPR to FLI
                epr.Company__c = 'Fresh Life Initiative Ltd';
                epr.Cash_Entry__c = null;
                epr.Payable_Invoice__c = null;
                update epr;                
                
                //run test methods
                pinController.CreatePINFromEPR();
                cashEntrycontroller.createCashEntryWithLines();                
                
				//To increase coverage run again with different Payment Method
                //update the EPR to FLI
                epr.Company__c = 'Fresh Life Initiative Ltd';
                epr.Cash_Entry__c = null;
                epr.Payable_Invoice__c = null;
                epr.Payment_Method__c = 'Electronic';
                UPDATE epr;
                
                //run test methods
                pinController.CreatePINFromEPR();
                cashEntrycontroller.createCashEntryWithLines();  
 
                //test PIN Creation
                PageReference pageRef2 = Page.Create_PIN_From_EPR;
                ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(epr2);
                CreatePINFromEPR pinController2 = new CreatePINFromEPR(sc2);

                //test Cash Entry Creation - Fresh Life Ltd
                PageReference pageRefCshEntry = Page.Create_Cash_Entry_From_EPR;
                ApexPages.Standardcontroller scFLI = new ApexPages.Standardcontroller(epr2);
                CreateCashEntryFromEPR cashEntrycontrollerFLI = new CreateCashEntryFromEPR(scFLI);
                cashEntrycontrollerFLI.createCashEntryWithLines();
                
                //test Cash Entry Creation - Sanergy Ltd
                pageRef2 = Page.Create_Cash_Entry_From_EPR;
                sc2 = new ApexPages.Standardcontroller(epr2);
                CreateCashEntryFromEPR cashEntrycontroller2 = new CreateCashEntryFromEPR(sc2);
                
				//To increase coverage run again with different Currency
                //update the EPR to FLI
                epr2.Vendor_Company__c = ac2.Id; //ac2 has been set with USD
                epr2.Company__c = 'Fresh Life Initiative Ltd';
                epr2.Cash_Entry__c = null;
                epr2.Payable_Invoice__c = null;
                epr2.Payment_Method__c='Check';
                update epr2;
                
                //run test methods
                pinController2.CreatePINFromEPR();
                cashEntrycontroller2.createCashEntryWithLines();
                
                
                
                //Test SLK EUR
                epr2.Vendor_Company__c = acEUR.Id; //ac2 has been set with EUR
                epr2.Company__c = 'Fresh Life Initiative Ltd';
                epr2.Cash_Entry__c = null;
                epr2.Payable_Invoice__c = null;
                epr2.Payment_Method__c='Check';
                epr2.Vendor_Invoice_Number__c = NULL;
                update epr2;
                
                cashEntrycontroller2.createCashEntryWithLines();
                
                         
                //To test Sanergy Inc (FP) Company
                List<String> fpCo = new List<String>();
                fpCo.add('Sanergy, Inc. (FP)');
                system.debug('FFA Co Current = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                c2g.CODAAPICompany_2_0.SetCurrentCompanies(fpCo);
                System.assertEquals('Sanergy, Inc. (FP)', c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                system.debug('FFA Co New = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);				
                
                //update the EPR to FLI
                epr.Company__c = 'Sanergy Inc (FP)';
                //epr.RespectiveCompany__c = 'a19D0000004Tbl1';
                epr.Cash_Entry__c = null;
                epr.Payable_Invoice__c = null;
                update epr;
                
                //run test methods
                pinController.CreatePINFromEPR();
                cashEntrycontroller.createCashEntryWithLines();
                Test.stopTest();                
                
                //To test Sanergy Inc (NP) Company
                List<String> npCo = new List<String>();
                npCo.add('Sanergy, Inc. (NP)');
                system.debug('FFA Co Current = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                c2g.CODAAPICompany_2_0.SetCurrentCompanies(npCo);
                System.assertEquals('Sanergy, Inc. (NP)', c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                system.debug('FFA Co New = ' + c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0]);
                
                //update the EPR to FLI
                epr.Company__c = 'Sanergy Inc (NP)';
                epr.Cash_Entry__c = null;
                epr.Payable_Invoice__c = null;
                update epr;
                
                //run test methods
                pinController.CreatePINFromEPR();
                cashEntrycontroller.createCashEntryWithLines();
	
                Test.stopTest(); 
               */ 
            }
        }
    }
    
    static testMethod void validateEPRTypes() {
        //Get the department
        List<FFA_Config_Object__c> department=
            [
                SELECT Id, Delegate_s_Threshold_Amount__c 
                FROM FFA_Config_Object__c 
                WHERE Type__c='dim1' AND isActive__c=true 
                AND (NOT Name LIKE '%XX%')
                LIMIT 1
            ];
        
        //Create Account       
        Account ac = new Account();
        ac = 
            [
                SELECT id, Name, RecordType.Name 
                FROM  Account 
                WHERE Type = 'Vendor' AND RecordType.Name = 'Sanergy Vendor' LIMIT 1
            ];
        
        //create EPR - Special Procurement
        Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c();
        epr.department__c=department.get(0).Id;
        epr.Company__c='Sanergy Ltd';
        epr.Vendor_Company__c= ac.Id;
        epr.Invoice_Number__c='INVOICE123'; 
        //epr.Vendor_Invoice_Number__c = vi.Id;
        epr.Scheduled_Payment_Date__c=Date.today()+10;              
        epr.Payment_Type__c='Special Procurement';
        epr.Preferred_Payment_Method__c = 'Check';
        epr.Payment_Method__c = 'Check';
        epr.Status__c='Open';
        epr.Confirmation_Number__c = '12345678';
        //epr.Notes__c = 'some notes';
        epr.Team_Lead_Approval_Status__c=null;
        epr.Cash_Entry__c=null;
        INSERT epr;  
    }
}