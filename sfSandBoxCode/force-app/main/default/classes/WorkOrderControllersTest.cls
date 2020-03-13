@isTest(seeAllData = true)
public class WorkOrderControllersTest {
    static testMethod void TestWorkOrderControllers() {
        
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            
            //Get Dimension 1
            c2g__codaDimension1__c dimensions = [SELECT Id,Name
                                                 FROM c2g__codaDimension1__c
                                                 WHERE Name='Pit Conversion'];
            
            FFA_Config_Object__c compny = [SELECT Name,Id,Type__c FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'company' AND isActive__c = true 
                                           AND Name = 'Sanergy Limited' LIMIT 1];
            //Get GLA
            /* FFA_Config_Object__c gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
WHERE Type__c = 'gla' AND isActive__c = true AND lookup_ID__c!= null LIMIT 1];
*/                SYSTEM.debug('oooooooooocompnyoooooo'+ compny);

            if(compny != null){
                FFA_Config_Object__c department = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                   WHERE Type__c = 'dim1' AND isActive__c = true 
                                                   AND Name = 'Sanergy Operations - Supply Chain - Warehouse' LIMIT 1];
                SYSTEM.debug('oooooooooodepartmentoooooo'+ department);
                if(department != null){
                    Inventory_UoM__c uom = new Inventory_UoM__c();
                    uom.Uom_Code__c = 'Pack';
                    uom.Name = 'n';
                    uom.Description__c = 'Pack - 70kg';
                    INSERT uom;
                    
                    Inventory_Location__c site = new Inventory_Location__c();
                    site.Name = 'Mukuru';
                    INSERT site;
                    
                    
                    List<Inventory_item__c> items = [Select Id,Has_BOM__c, Name,unit_cost__c,Item_Group__r.Dimension_1__r.lookup_ID__c,
                                                     Item_Group__r.Dimension_2__r.lookup_ID__c, Item_Group__r.Dimension_3__r.lookup_ID__c,
                                                     Item_Group__r.Dimension_4__r.lookup_ID__c,Item_Group__c
                                                     FROM Inventory_item__c WHERE Item_Group__c != null AND Has_BOM__c = true LIMIT 1
                                                    ];
                    
                    FFA_Config_Object__c dim3 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim3' AND isActive__c = true 
                                                 AND Name = 'Not Applicable' LIMIT 1];
                    if(dim3 != null){
                        
                        FFA_Config_Object__c dim4 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                     WHERE Type__c = 'dim4' AND isActive__c = true 
                                                     AND Name = 'Not Applicable' LIMIT 1];
                        if(dim4 != null){
                            FFA_Config_Object__c dim2 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                         WHERE Type__c = 'dim2' AND isActive__c = true 
                                                         AND Name = 'Not Applicable' LIMIT 1];
                            if(dim2 != null){
                                Inventory_Item_Group__c comCode = new Inventory_Item_Group__c();
                                comCode.Name = 'name';
                                comCode.Dimension_1__c = department.Id;
                                comCode.Description__c = 'Raw';
                                comCode.Dimension_2__c = dim2.Id;
                                comCode.Dimension_3__c = dim3.Id;
                                comCode.Dimension_4__c = dim4.Id;
                                comCode.Commodity_Code__c = 'Raw';
                                insert comCode;
                                
                                Currency_Config__c currenc = new Currency_Config__c();
                                currenc.Currency_Name__c = 'Kenyan Shilling';
                                currenc.Name = 'KES';
                                currenc.Value__c = 1;
                                currenc.start__c = date.today();
                                currenc.Current__c = true;
                                insert currenc;
                                
                                Inventory_Item__c item = new Inventory_Item__c();
                                item.Item_Description__c = 'Cement1';
                                item.Currency_Config__c = currenc.Id;
                                item.Name = 'item1';
                                item.Item_Number__c = '123457';
                                item.Responsible_Department__c = department.Id;
                                item.Policy_Quantity__c = 10;
                                item.Minimum_Quantity__c = 2;
                                item.Item_Group__c = comCode.Id;
                                item.Inventory_UoM__c = uom.Id;
                                item.unit_cost__c = 700;
                                item.Item_Company__c = compny.Id;
                                item.Default_Site__c = site.Id;
                                item.Default_Location__c = '1';
                                item.Default_Lot__c = '1';
                                item.WO_Receipt_Variance_Acceptable__c=true;                                
                                INSERT item;
                                
                                Inventory_Item__c item2 = new Inventory_Item__c();
                                item2.Item_Description__c = 'Cement2';
                                item2.Currency_Config__c = currenc.Id;
                                item2.Name = 'item2';
                                item2.Item_Number__c = '456789';
                                item2.Responsible_Department__c = department.Id;
                                item2.Policy_Quantity__c = 100;
                                item2.Minimum_Quantity__c = 20;
                                item2.Item_Group__c = comCode.Id;
                                item2.Inventory_UoM__c = uom.Id;
                                item2.unit_cost__c = 1000;
                                item2.Item_Company__c = compny.Id;
                                item2.Default_Site__c = site.Id;
                                item2.Default_Location__c = '1';
                                item2.Default_Lot__c = '1';                                
                                INSERT item2;
                                
                                Inventory_Item__c item3 = new Inventory_Item__c();
                                item3.Item_Description__c = 'Cement3';
                                item3.Currency_Config__c = currenc.Id;
                                item3.Name = 'item3';
                                item3.Item_Number__c = '456789345';
                                item3.Responsible_Department__c = department.Id;
                                item3.Policy_Quantity__c = 100;
                                item3.Minimum_Quantity__c = 20;
                                item3.Item_Group__c = comCode.Id;
                                item3.Inventory_UoM__c = uom.Id;
                                item3.unit_cost__c = 1000;
                                item3.Item_Company__c = compny.Id;
                                item3.Default_Site__c = site.Id;
                                item3.Default_Location__c = '1';
                                item3.Default_Lot__c = '1'; 
                                INSERT item3;                                
                                
                                Inventory_Item_BOM__c bom = new Inventory_Item_BOM__c();
                                bom.Parent_Item__c = item.Id;
                                bom.Quantity_Per__c = 2;
                                bom.BOM_Item__c = item2.Id;                                
                                INSERT bom; 
                                
                                Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
                                    Name = site.Name,
                                    Location_Name__c = '008980',
                                    Location__c = site.Id,
                                    Inventory_Item__c = item.Id,
                                    Max_Location_Quantity__c = 100
                                );
                                
                                insert itmloc;
                                
                                Inventory_Item_Location__c itmloc1 = new Inventory_Item_Location__c(
                                    Name = site.Name,
                                    Location_Name__c = '0089800',
                                    Location__c = site.Id,
                                    Inventory_Item__c = item.Id,
                                    Max_Location_Quantity__c = 100000
                                );
                                
                                INSERT itmloc1;                                
                                
                                Inventory_Item_Location__c itmloc2 = new Inventory_Item_Location__c(
                                    Name = site.Name,
                                    Location_Name__c = '0089801',
                                    Location__c = site.Id,
                                    Inventory_Item__c = item2.Id,
                                    Max_Location_Quantity__c = 100000
                                );
                                
                                insert itmloc2;
                                
                                Inventory_Item_Location__c itmloc3 = new Inventory_Item_Location__c(
                                    Name = site.Name,
                                    Location_Name__c = '1',
                                    Location__c = site.Id,
                                    Inventory_Item__c = item3.Id,
                                    Max_Location_Quantity__c = 100000
                                );
                                
                                insert itmloc3;                                
                                
                                Item_Location_Lot__c lot = new Item_Location_Lot__c();
                                lot.Lot_Name__c = 'Lot 18';
                                lot.Quantity__c = 90909;
                                lot.Item_Location__c = itmloc.Id;                                
                                INSERT lot;
                                
                                Item_Location_Lot__c lot3 = new Item_Location_Lot__c();
                                lot3.Lot_Name__c = '1';
                                lot3.Quantity__c = 90909;
                                lot3.Item_Location__c = itmloc2.Id;
                                INSERT lot3;
                                
                                Item_Location_Lot__c lot4 = new Item_Location_Lot__c();
                                lot4.Lot_Name__c = '1';
                                lot4.Quantity__c = 90909;
                                lot4.Item_Location__c = itmloc3.Id;
                                INSERT lot4; 
                                
                                
                                
                                FFA_Config_Object__c gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                                            WHERE Type__c = 'gla' AND isActive__c = true 
                                                            AND Name = '1410 - Inventory - Raw Material' LIMIT 1];
                                
                                Inventory_Transaction__c romtrans = new Inventory_Transaction__c();
                                romtrans.Item__c = item.Id;
                                romtrans.Location__c = itmloc.Id;
                                romtrans.Quantity_Impact__c = 'I';
                                romtrans.Transaction_ID__c = 'WORCPT';
                                romtrans.Transaction_Quantity__c = 5;            
                                romtrans.Location_Lot__c = lot.Id;
                                romtrans.Item_Unit_Price__c = item.unit_cost__c;
                                romtrans.Debit_Account__c = gla.Lookup_Id__c;
                                romtrans.Credit_Account__c = gla.Lookup_Id__c;
                                romtrans.Dimension_1__c = items.get(0).Item_Group__r.Dimension_1__r.lookup_ID__c;
                                romtrans.Dimension_2__c = items.get(0).Item_Group__r.Dimension_2__r.lookup_ID__c;
                                romtrans.Dimension_3__c = items.get(0).Item_Group__r.Dimension_3__r.lookup_ID__c;
                                romtrans.Dimension_4__c = items.get(0).Item_Group__r.Dimension_4__r.lookup_ID__c;
                                romtrans.Comments__c = 'WORCPT';
                                romtrans.Item_Unit_Price__c = 500;
                                
                                insert romtrans;

                                
                                if(gla != null){
                                    
                                    Group_Details__c details = new Group_Details__c();
                                    details.Config_Account__c = gla.Id;
                                    details.Credit_Debit__c = 'Debit';
                                    details.Inventory_Item_Group__c = comCode.Id;
                                    details.Transaction_ID__c = 'WOISS';
                                    details.Is_GL_Account__c = true;                                    
                                    INSERT details;
                                    
                                    Group_Details__c details1 = new Group_Details__c();
                                    details1.Config_Account__c = gla.Id;
                                    details1.Credit_Debit__c = 'Credit';
                                    details1.Inventory_Item_Group__c = comCode.Id;
                                    details1.Transaction_ID__c = 'WOISS';
                                    details1.Is_GL_Account__c = true;                                    
                                    INSERT details1;
                                    
                                    Group_Details__c details2 = new Group_Details__c();
                                    details2.Config_Account__c = gla.Id;
                                    details2.Credit_Debit__c = 'Debit';
                                    details2.Inventory_Item_Group__c = comCode.Id;
                                    details2.Transaction_ID__c = 'LOCMOVE';
                                    details2.Is_GL_Account__c = true;                                   
                                    INSERT details2;
                                    
                                    Group_Details__c details3 = new Group_Details__c();
                                    details3.Config_Account__c = gla.Id;
                                    details3.Credit_Debit__c = 'Credit';
                                    details3.Inventory_Item_Group__c = comCode.Id;
                                    details3.Transaction_ID__c = 'LOCMOVE';
                                    details3.Is_GL_Account__c = true;                                    
                                    INSERT details3;
                                    
                                    Group_Details__c details4 = new Group_Details__c();
                                    details4.Config_Account__c = gla.Id;
                                    details4.Credit_Debit__c = 'Debit';
                                    details4.Inventory_Item_Group__c = comCode.Id;
                                    details4.Transaction_ID__c = 'WORCPT';
                                    details4.Is_GL_Account__c = true;                                    
                                    INSERT details4;
                                    
                                    Group_Details__c details5 = new Group_Details__c();
                                    details5.Config_Account__c = gla.Id;
                                    details5.Credit_Debit__c = 'Credit';
                                    details5.Inventory_Item_Group__c = comCode.Id;
                                    details5.Transaction_ID__c = 'WORCPT';
                                    details5.Is_GL_Account__c = true;                                    
                                    INSERT details5;
                                    
                                    Group_Details__c details6 = new Group_Details__c();
                                    details6.Config_Account__c = gla.Id;
                                    details6.Credit_Debit__c = 'Debit';
                                    details6.Inventory_Item_Group__c = comCode.Id;
                                    details6.Transaction_ID__c = 'INVLOCADJ';
                                    details6.Is_GL_Account__c = true;                                    
                                    INSERT details6;
                                    
                                    Group_Details__c details7 = new Group_Details__c();
                                    details7.Config_Account__c = gla.Id;
                                    details7.Credit_Debit__c = 'Credit';
                                    details7.Inventory_Item_Group__c = comCode.Id;
                                    details7.Transaction_ID__c = 'INVLOCADJ';
                                    details7.Is_GL_Account__c = true;                                    
                                    INSERT details7;
                                    
                                    Group_Details__c details8 = new Group_Details__c();
                                    details8.Config_Account__c = gla.Id;
                                    details8.Credit_Debit__c = 'Debit';
                                    details8.Inventory_Item_Group__c = comCode.Id;
                                    details8.Transaction_ID__c = 'WOISSEXP';
                                    details8.Is_GL_Account__c = true;                                    
                                    INSERT details8;
                                    
                                    Group_Details__c details9 = new Group_Details__c();
                                    details9.Config_Account__c = gla.Id;
                                    details9.Credit_Debit__c = 'Credit';
                                    details9.Inventory_Item_Group__c = comCode.Id;
                                    details9.Transaction_ID__c = 'WOISSEXP';
                                    details9.Is_GL_Account__c = true;                                    
                                    INSERT details9;                                    
                                    
                                    Purchase_Order_Item__c poI = [SELECT Id, Unit_Net_Price__c,Name, Inventory_Item__c,Gross_Value__c,Item_Cost__c,
                                                                  Item_Description__c,Net_VAT__c,Primary_Vendor__c,Purchase_UoM__c,Vendor__c,Vatable__c,
                                                                  VAT_Percentage__c,VAT_Inclusive__c, Currency__c
                                                                  FROM Purchase_Order_Item__c WHERE Primary_Vendor__c = true                                                                  
                                                                  LIMIT 1];
                                    
                                    if(poI != null){
                                        /*poI.Inventory_Item__c = item.Id;
poI.Purchase_UoM__c = item.Inventory_UoM__c;
poI.UOM_Conversion_Factor__c = 1;
UPDATE poI;*/
                                        
                                      // poI.Inventory_Item__c = item2.Id;
                                      poI.Purchase_UoM__c = item2.Inventory_UoM__c;
                                        poI.UOM_Conversion_Factor__c = 2;
                                       //UPDATE poI;
                                        
                                        Item_Location_Lot__c lot1 = new Item_Location_Lot__c();
                                        lot1.Lot_Name__c = 'Lot 188';
                                        lot1.Quantity__c = 90909;
                                        lot1.Item_Location__c = itmloc1.Id;                                        
                                        INSERT lot1;
                                        
                                        List<Inventory_Requisition_Item__c> requisitionItem = [SELECT Id,Inventory_Requisition__r.Id,Name,Inventory_Requisition__c
                                                                                               FROM Inventory_Requisition_Item__c];
                                        if(requisitionItem.size()>0){
                                            
                                            PageReference pageReff2 = Page.InventoryItemIssue;
                                            Test.setCurrentPage(pageReff2);
                                            ApexPages.Standardcontroller cont2 = new ApexPages.Standardcontroller(requisitionItem.get(0).Inventory_Requisition__r);
                                            RequisitionIssuanceController controller = new RequisitionIssuanceController(cont2);
                                            
                                            controller.selectAll();
                                            controller.processSelected();
                                            controller.getSites();        
                                            for (RequisitionIssuanceController.IssuanceItem thisListItem :controller.issuanceList) {
                                                thisListItem.site=site.Id;
                                                thisListItem.location= itmloc2.Id;
                                                thisListItem.lot = lot3.Id;
                                                thisListItem.issueQuantity = 1;
                                                thisListItem.setLocs();
                                                thisListItem.setLots();
                                                thisListItem.selectLot();
                                            }
                                            controller.selectAll();
                                            controller.unselectAll();        
                                        }        
                                        Inventory_Item_Recipe__c recipe = new Inventory_Item_Recipe__c();
                                        recipe.Parent_Item__c = item.Id;
                                        
                                        insert recipe;
                                        
                                        Inventory_Item_Recipe_Item__c recipeItem = new Inventory_Item_Recipe_Item__c();
                                        recipeItem.Inventory_Item__c = item2.Id;
                                        recipeItem.Quantity_Per__c = 1;
                                        recipeItem.Inventory_Item_Recipe__c = recipe.Id;
                                        
                                        insert recipeItem;
                                        
                                        List<Inventory_Item_Recipe__c> listRe = new List<Inventory_Item_Recipe__c> ();
                                        listRe.add(recipe);
                                        
                                    }//END if(gla != null)
                                    
                                    //********************************START**********************************************
                                    //Create Work Order 1
                                    Work_Order__c wo = new Work_Order__c();
                                    wo.Company__c = compny.Id;
                                    wo.Inventory_Item__c = item.Id;
                                    wo.Inventory_Item_Quantity__c = 1000;
                                    wo.Work_Order_Type__c = 'WO-Manufactured';
                                    wo.Dimension_1__c=dimensions.Id;
                                    wo.Work_Order__c = 1000;
                                    wo.Issue_Variance__c = 'abc';
                                    INSERT wo;                                      
                                    
                                    wo.Inventory_Item_Quantity__c = 1200;
                                    UPDATE wo;
                                    
                                    //Create Work Order Item 1
                                    Work_Order_Item__c witem =  new Work_Order_Item__c();
                                    witem.BOM_Quantity__c = 20;
                                    witem.Inventory_Item__c = item2.Id;
                                    // witem.Planned_Cost__c = item2.unit_cost__c * 3;
                                    witem.Planned_Cost__c = 1000;
                                    witem.Work_Order__c = wo.Id;
                                    witem.Unit_Cost__c = item2.unit_cost__c;
                                    witem.Planned_Material_Cost__c = 1000;
                                    INSERT witem;                                        
                                    
                                    //Create Work Order 2
                                    Work_Order__c wo2 = new Work_Order__c();
                                    wo2.Company__c = compny.Id;
                                    wo2.Inventory_Item__c = item.Id;
                                    wo2.Inventory_Item_Quantity__c = 5000;
                                    wo2.Work_Order_Type__c = 'WO-Service';
                                    wo2.Dimension_1__c=dimensions.Id;  
                                    wo2.Work_Order__c = 1000;
                                    wo2.Issue_Variance__c = 'abc';
                                    INSERT wo2;                                          
                                    
                                    //Create Work Order Item 2
                                    Work_Order_Item__c witem2 =  new Work_Order_Item__c();
                                    witem2.BOM_Quantity__c = 20;
                                    witem2.Inventory_Item__c = item2.Id;
                                    witem2.Planned_Cost__c = item2.unit_cost__c * 3;
                                    witem2.Work_Order__c = wo2.Id;
                                    witem2.Unit_Cost__c = item2.unit_cost__c;
                                    witem2.Planned_Material_Cost__c = 1000;
                                    INSERT witem2;

                                    
                                    PageReference pageReff = Page.IssueWOItems;
                                    Test.setCurrentPage(pageReff);
                                    ApexPages.Standardcontroller cont = new ApexPages.Standardcontroller(wo);
                                    IssueWorkOrderItems IssueWorkOrderItem = new IssueWorkOrderItems(cont);
                                    
                                    IssueWorkOrderItem.selectAll();
                                    IssueWorkOrderItem.getItems();
                                    IssueWorkOrderItem.getSites();
                                    
                                    for (IssueWorkOrderItems.ItemWrapper thisListItem :IssueWorkOrderItem.items) {
                                        thisListItem.site=site.Id;
                                        thisListItem.location= itmloc2.Id;
                                        thisListItem.lot = lot3.Id;
                                        thisListItem.issueQuantity = 1000;
                                        thisListItem.setLocs();
                                        thisListItem.setLots();
                                        thisListItem.selectLot();
                                    }
                                    IssueWorkOrderItem.issueItems();
                                    IssueWorkOrderItem.selectAll();
                                    IssueWorkOrderItem.unselectAll();
                                    
                                    PageReference pageReff3 = Page.IssueWOItems;
                                    Test.setCurrentPage(pageReff3);
                                    ApexPages.Standardcontroller cont3 = new ApexPages.Standardcontroller(wo2);
                                    IssueWorkOrderItems IssueWorkOrderItem3 = new IssueWorkOrderItems(cont3);
                                    
                                    IssueWorkOrderItem3.selectAll();
                                    IssueWorkOrderItem3.getItems();
                                    IssueWorkOrderItem3.getSites();
                                    
                                    for (IssueWorkOrderItems.ItemWrapper thisListItem3 :IssueWorkOrderItem3.items) {
                                        thisListItem3.site=site.Id;
                                        thisListItem3.location= itmloc2.Id;
                                        thisListItem3.lot = lot3.Id;
                                        thisListItem3.issueQuantity = 1000;
                                        thisListItem3.setLocs();
                                        thisListItem3.setLots();
                                        thisListItem3.selectLot();
                                    }
                                    IssueWorkOrderItem3.issueItems();
                                    IssueWorkOrderItem3.selectAll();
                                    IssueWorkOrderItem3.unselectAll();
                                    
                                    Work_Order_Item_Issue__c issue = new Work_Order_Item_Issue__c();
                                    issue.Work_Order__c = wo.Id;
                                    issue.Work_Order_Item__c = witem.Id;
                                    issue.Unit_Value__c = 1000;
                                    issue.Issued_Quantity__c = 1;
                                    issue.Inventory_UoM__c = uom.Id;
                                    insert issue;
                                    
   
                                    PageReference pageRef = Page.GenerateWOItems;
                                    Test.setCurrentPage(pageRef);
                                    ApexPages.Standardcontroller c = new ApexPages.Standardcontroller(wo);
                                    GenerateWorkOderItems GenerateWorkOderItem = new GenerateWorkOderItems(c);
                                    
                                    //GenerateWorkOderItem.Recipe = recipe.Id;               
                                    GenerateWorkOderItem.FirmWorkOder();
                                    GenerateWorkOderItem.setRecs();                
                                    GenerateWorkOderItem.getItms();
                                    GenerateWorkOderItem.getLines();
                                    GenerateWorkOderItem.getRecipies();
                                    GenerateWorkOderItem.generateWOItems();
                                    GenerateWorkOderItem.getCreatedWOIs();
                                    
                                    GenerateWorkOderItem.Recipe = null; 
                                    GenerateWorkOderItem.setRecs();                
                                    GenerateWorkOderItem.getItms();
                                    GenerateWorkOderItem.getLines();
                                    GenerateWorkOderItem.getRecipies();
                                    GenerateWorkOderItem.generateWOItems();
                                    GenerateWorkOderItem.getCreatedWOIs();
                                    
                                    wo.Issue_Variance__c = 'abc';
                                    update wo;
                                    
                                    String reasonForIssueVariance = 'abc';
                                    String location = '001';
                                    double x = 500;
                                    
                                    PageReference ReceiveWoItemspageRef = Page.GenerateWOItems;
                                    Test.setCurrentPage(ReceiveWoItemspageRef);
                                    ApexPages.Standardcontroller cc = new ApexPages.Standardcontroller(wo);
                                    ReceiveWoItemsController ReceiveWoItems = new ReceiveWoItemsController(cc);
                                    ReceiveWoItems.getWorkOrderItems();                                        
                                    ReceiveWoItems.getIssuedItems();
                                    ReceiveWoItems.getSites();
                                    ReceiveWoItems.reasonForIssueVariance = 'abc';
                                    ReceiveWoItems.receiveQuantity1 = 100;
                                    ReceiveWoItems.location = '001';
                                    
                                    
                                    
                                    Work_Order_Receipts__c receipts = new Work_Order_Receipts__c();
                                    receipts.Receive_Site__c = site.Id;
                                    receipts.Receive_Location__c = itmloc1.Id;
                                    receipts.Receive_Lot__c = lot.Id; 
                                    receipts.Receive_Quantity__c = 1000;
                                    receipts.Inventory_Transaction__c = romtrans.Id;
                                    receipts.Work_Order__c = wo2.id;
                                    Insert receipts;
                                    
                                     // Create Work_Order_By_product__c
                                    Work_Order_By_product__c byProducts = new Work_Order_By_product__c();
                                    byProducts.Parent_Item__c = item.Id;
                                    byProducts.By_product_Item__c = item.Id;
                                    INSERT byProducts; 
                                    
                                    ReceiveWoItemsController.TestWrapper wrapperTest = new ReceiveWoItemsController.TestWrapper(byProducts);                                                                                                                  
                                    wrapperTest.x = 8;
                                    wrapperTest.y = 8;
                                    wrapperTest.z = 8;
                                    

                                    
                                     system.debug('************Products iTEM*************' + byProducts.By_product_Item__c);
                                    
                                    //Receive by Products
                                    ReceiveWoItemsController.ItemWrapper wrapper = new ReceiveWoItemsController.ItemWrapper(byProducts);                                                                                                                  
                                    wrapper.site2 = item3.Default_Site__c;
                                    wrapper.location2 = '000001';
                                    wrapper.lot2 = '0001';
                                    wrapper.receiveQuantity2 = 500;
                                    wrapper.locationId2 = itmloc3.Id;
                                    wrapper.lotId2 = lot4.Id;
                                    wrapper.setItemLocations();
                                    
                                    system.debug('************site2*************' + wrapper.site2);
                                    
                                    
                                    // Create a list and add the test Wrapper Values
                                    List<ReceiveWoItemsController.ItemWrapper> Products= new List<ReceiveWoItemsController.ItemWrapper>();
                                    Products.add(wrapper);
                                    
                                    
                                    // Call the By Products List from the controller and assign to it the test class wrapper class list
                                    ReceiveWoItems.workOrderByProducts = Products;
                                    system.debug('********+++++++++++++Products**********+++++++***' + Products);
                                    
                                    //createan inventroy Item Location for the BY Product Item 
                                    Inventory_Item_Location__c itmloc1BY= new Inventory_Item_Location__c(
                                        Name = 'Mukuru - 1',
                                        Location_Name__c = wrapper.location2,
                                        Location__c =  wrapper.site2,
                                        Inventory_Item__c = byProducts.By_product_Item__c,
                                        Max_Location_Quantity__c = 100000
                                    );
                                    
                                    INSERT itmloc1BY; 
                                    
                                    Group_Details__c details10 = new Group_Details__c();
                                    details10.Config_Account__c = gla.Id;
                                    details10.Credit_Debit__c = 'Debit';
                                    details10.Inventory_Item_Group__c = item.Item_Group__c;
                                    details10.Transaction_ID__c = 'WORCPT';
                                    details10.Is_GL_Account__c = true;                                    
                                    INSERT details10;
                                    
                                    List<Group_Details__c> groupList = new List<Group_Details__c>();
                                    groupList.add(details10);
                                    
                                    ReceiveWoItems.glas = groupList;
                                    system.debug('%%%%%%%%%%groupList%%%' + groupList);

                                    if((ReceiveWoItems.glas).size()  == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The item configuration is missing either credit or debit GL Accounts'));
 
                                    }
                                    
                                    ReceiveWoItems.getWorkOrderByProducts();
                                    system.debug('********+++++++++++++WorkOrderByProducts**********+++++++***' + ReceiveWoItems.getWorkOrderByProducts());
                                    ReceiveWoItems.receiveByProductsToInventory();
                                    ReceiveWoItems.ReceivingInventory();
                                    ReceiveWoItems.closeInstallationWo();
                                    
                                    //Set the work order status to 'Closed' in order to reverse it.
                                    wo.Status__c = 'Closed';
                                    UPDATE wo;
                                    
                                    
                                    //Reverse Work Order Receipts (WO-Manufactured)
                                    PageReference ReverseWOpageRef = Page.ReverseWorkOrder;
                                    Test.setCurrentPage(ReverseWOpageRef);
                                    ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(wo);
                                    ReverseWorkOrderController ReverseWO = new ReverseWorkOrderController(sc1);
                                    ReverseWO.getWorkOrderReceiptInventoryTransactions();
                                    
                                    for (ReverseWorkOrderController.ItemWrapper wrapper1 : ReverseWO.inventoryTransactions) {
                                        wrapper1.selected = true;
                                        wrapper1.reverseQuantity = 1;                                         
                                        wrapper1.site = site.Id;
                                        wrapper1.location = '1';
                                        wrapper1.lot = '1';
                                    }
                                    
                                    //Reset Salesforce Governor Limits to Avoid 'Too many SOQL' error
                                    Test.startTest();
                                    
                                    //Reverse Work Order Receipt
                                    ReverseWO.reverseWorkOrderReceipt();                                    
                                    
                                    //Set the work order status to in progress/complete in order to reverse issuances.
                                    wo.Status__c = 'Work in progress';
                                    UPDATE wo;
                                    
                                    //Reverse Work Order Issuances (WO-Manufactured)
                                    PageReference ReverseWOpageRef2 = Page.ReverseWorkOrderIssuances;
                                    Test.setCurrentPage(ReverseWOpageRef2);
                                    ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(wo);
                                    ReverseWorkOrderController ReverseWO2 = new ReverseWorkOrderController(sc2);                                        
                                    ReverseWO2.getWorkOrderIssuanceWOISSInventoryTransactions();
                                    
                                    for (ReverseWorkOrderController.ItemWrapper wrapper2 : ReverseWO2.inventoryTransactions) {
                                        wrapper2.selected = true;
                                        wrapper2.reverseQuantity = 1;                                         
                                        wrapper2.site = site.Id;
                                        wrapper2.location = '1';
                                        wrapper2.lot = '1';
                                    }
                                    
                                    //Reverse Work Order Issuance
                                    ReverseWO2.reverseWorkOrderIssuanceWOISS();
                                    
                                    //Reverse WO-Service
                                    PageReference ReverseWOpageRef3 = Page.ReverseWorkOrderIssuances;
                                    Test.setCurrentPage(ReverseWOpageRef3);
                                    ApexPages.Standardcontroller sc3 = new ApexPages.Standardcontroller(wo2);
                                    ReverseWorkOrderController ReverseWO3 = new ReverseWorkOrderController(sc3);
                                   
                                    ReverseWO3.getWorkOrderIssuanceWOISSEXPInventoryTransactions();
                                    
                                    for (ReverseWorkOrderController.ItemWrapper wrapper3 : ReverseWO3.inventoryTransactions) {
                                        wrapper3.selected = true;
                                        wrapper3.reverseQuantity = 1;                                         
                                        wrapper3.site = site.Id;
                                        wrapper3.location = '1';
                                        wrapper3.lot = '1';
                                    }
                                    
                                   
                                    ReverseWO3.reverseWorkOrderIssuanceWOISSEXP();
                                    Test.stopTest();
                                    
                                    //*********************************END***********************************************
                                }
                            } 
                        }
                    }
                }
            }
        }
    }
}