@isTest(SeeAllData=true)
public class CreateSupplementaryWorkOrderTest {
    
    static testMethod void supplementaryWorkOrderTest(){
        
        //Get dim1                              
        FFA_Config_Object__c department = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim1' 
                                           AND Name = 'Information Technology'
                                           AND isActive__c = true 
                                           LIMIT 1];
        System.debug('' + department);
        
        //Get dim2                                    
        FFA_Config_Object__c dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim2' 
                                     AND isActive__c = true 
                                     LIMIT 1];
        
        //Get dim3                                   
        FFA_Config_Object__c dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim3' 
                                     AND isActive__c = true 
                                     LIMIT 1];
        
        //Get dim4                                     
        FFA_Config_Object__c grant = [SELECT Id,Name,Type__c,isActive__c 
                                      FROM FFA_Config_Object__c 
                                      WHERE Type__c = 'dim4' 
                                      AND isActive__c = true 
                                      LIMIT 1];
        
        //Get gla
        FFA_Config_Object__c gla= [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                   WHERE Type__c = 'gla' 
                                   AND isActive__c = true 
                                   AND Name = '6430 - Government Fees & Levies' 
                                   LIMIT 1];        
        
        //Get Company
        FFA_Config_Object__c freshLife= [SELECT Id,Name 
                                         FROM FFA_Config_Object__c 
                                         WHERE type__c = 'company' 
                                         AND isActive__c = true
                                         AND Name = 'Fresh Life Initiative Limited'
                                         LIMIT 1];        
        
        //Create Account
        Account account1 = new Account();
        account1.Name='John Doe';
        account1.CurrencyIsoCode = 'KES';
        INSERT account1;
        
        System.debug('account1 = ' + account1);          
        
        //Create a Contact
        Contact salesPerson = new Contact();
        salesPerson.FirstName = 'Jane';
        salesPerson.LastName = 'Doe';
        salesPerson.Sex__c = 'Female';
        salesPerson.AccountId = account1.Id;
        INSERT salesPerson;
        
        System.debug('salesPerson = ' + salesPerson);
        
        //Get Location
        Location__c location = [SELECT id FROM Location__c LIMIT 1];
        
        //Get SubArea
        Sub_Area__c subArea = [SELECT id FROM Sub_Area__c LIMIT 1];
        
        // Create a Currency Config
        Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc; 
        
        System.debug('CREATE CURRENCY CONFIG: ' + cc);
        
        Inventory_Location__c inventorySite = new Inventory_Location__c();
        inventorySite.Name = 'Mukuru 2345';
        insert inventorySite;         
        
        // Create Inventory_UoM__c
        Inventory_UoM__c inventoryItemUOM = new Inventory_UoM__c();
        //inventoryItemUOM.Name = 'Dummy Inventory UOM 1';
        inventoryItemUOM.Description__c = 'Dummy Inventory UOM';
        inventoryItemUOM.Uom_Code__c = '101';
        inventoryItemUOM.CurrencyIsoCode = 'KES';
        INSERT inventoryItemUOM;
        
        System.debug('CREATE INVENTORY UOM: ' + inventoryItemUOM);
        
        // Create Inventory_inventoryItem_Group__c
        Inventory_Item_Group__c invinventoryItemGroup = new Inventory_Item_Group__c();
        invinventoryItemGroup.Name = 'New Inventory inventoryItem Group';
        invinventoryItemGroup.Commodity_Code__c = 'New Purchase';
        invinventoryItemGroup.Description__c = 'Brief description';
        invinventoryItemGroup.Dimension_1__c = department.Id;
        invinventoryItemGroup.Dimension_2__c = dim2.Id;
        invinventoryItemGroup.Dimension_3__c = dim3.Id;
        invinventoryItemGroup.Dimension_4__c = grant.Id;
        INSERT invinventoryItemGroup;
        
        System.debug('CREATE INVENTORY GROUP: ' + invinventoryItemGroup);
        
        Group_Details__c groupDetails = new Group_Details__c();
        groupDetails.Inventory_Item_Group__c = invinventoryItemGroup.Id;
        groupDetails.Credit_Debit__c = 'Debit'; 
        groupDetails.Transaction_ID__c = 'PORCPT';
        groupDetails.Is_GL_Account__c = true;
        groupDetails.Config_Account__c = gla.Id;        
        INSERT groupDetails; 
        
        System.debug('CREATE GROUP DETAILS: ' + groupDetails);         
        
        //Create Inventory Item
        Inventory_Item__c inventoryItemFLI = new Inventory_Item__c();
        inventoryItemFLI.Item_Description__c = 'Internet';
        inventoryItemFLI.Currency_Config__c = cc.Id;
        inventoryItemFLI.Name = 'Fresh Life Internet';
        inventoryItemFLI.Item_Number__c = '1234567';
        inventoryItemFLI.Responsible_Department__c = department.Id;
        inventoryItemFLI.Policy_Quantity__c = 10;
        inventoryItemFLI.Minimum_Quantity__c = 2;
        inventoryItemFLI.Item_Group__c = invinventoryItemGroup.Id;
        inventoryItemFLI.Inventory_UoM__c = inventoryItemUOM.Id;
        inventoryItemFLI.unit_cost__c = 100;
        inventoryItemFLI.Item_Company__c = freshLife.Id;
        inventoryItemFLI.Default_Site__c = inventorySite.Id;
        inventoryItemFLI.Default_Location__c = '1';
        inventoryItemFLI.Default_Lot__c = '1';        
        INSERT inventoryItemFLI;        
        
        System.debug('CREATE INVENTORY ITEM: ' + inventoryItemFLI);
        
        //Create Inventory Item
        Inventory_Item__c inventoryItemFLI2 = new Inventory_Item__c();
        inventoryItemFLI2.Item_Description__c = 'Internet 2';
        inventoryItemFLI2.Currency_Config__c = cc.Id;
        inventoryItemFLI2.Name = 'Fresh Life Internet 2';
        inventoryItemFLI2.Item_Number__c = '12345678';
        inventoryItemFLI2.Responsible_Department__c = department.Id;
        inventoryItemFLI2.Policy_Quantity__c = 10;
        inventoryItemFLI2.Minimum_Quantity__c = 2;
        inventoryItemFLI2.Item_Group__c = invinventoryItemGroup.Id;
        inventoryItemFLI2.Inventory_UoM__c = inventoryItemUOM.Id;
        inventoryItemFLI2.unit_cost__c = 100;
        inventoryItemFLI2.Item_Company__c = freshLife.Id;
        inventoryItemFLI2.Default_Site__c = inventorySite.Id;
        inventoryItemFLI2.Default_Location__c = '1';
        inventoryItemFLI2.Default_Lot__c = '1';        
        INSERT inventoryItemFLI2;        
        
        System.debug('CREATE INVENTORY ITEM: ' + inventoryItemFLI2);

        //*****Start Testing Creation of 'Structure' & 'BIB' Supplementary Work Orders*****
        //Create Toilet Sale Opportunity 
        Opportunity toiletSaleOpportunity = new Opportunity();
        toiletSaleOpportunity.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management 
        toiletSaleOpportunity.StageName ='Pending Govt Approval';          
        toiletSaleOpportunity.AccountId = account1.Id;
        toiletSaleOpportunity.Name = account1.Name;
        toiletSaleOpportunity.Primary_Salesperson__c = salesPerson.Id;
        toiletSaleOpportunity.CloseDate =  date.today() + 30;
        toiletSaleOpportunity.FLTs_Approved__c = 2;
        toiletSaleOpportunity.Basic_FLT__c = false;//change this
        toiletSaleOpportunity.Upstructures_Required__c=2.0;//change this
        toiletSaleOpportunity.Existing_Location__c=true;//change this
        toiletSaleOpportunity.Location__c = location.Id;
        toiletSaleOpportunity.Existing_FLO__c=true;//change this
        
        INSERT toiletSaleOpportunity;
        
        System.debug('toiletSaleOpportunity = ' + toiletSaleOpportunity);     

        //Add Engineering Items
        PageReference pageRef1 = Page.AddOpportunityItems;            
        Test.setCurrentPage(pageRef1);
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(toiletSaleOpportunity);
        AddOppItemsController oppItemsController = new AddOppItemsController(controller1);
        oppItemsController.fltVersion='V2';
        oppItemsController.createItems();
        
        //add BiB Items
        PageReference pageRef2 = Page.AddLaunchItems;
        Test.setCurrentPage(pageRef2);
        ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(toiletSaleOpportunity);
        AddLaunchItemsController oppLaunchItemsController = new AddLaunchItemsController(controller2);
        oppLaunchItemsController.createItems();
        
        //Approve Engineering & BIB Items
        toiletSaleOpportunity.BIB_Items_Approved__c=true;
        toiletSaleOpportunity.Engineering_Items_Approved__c=true;
        toiletSaleOpportunity.Marketing_Items_Approved__c=true; 
        
        toiletSaleOpportunity.Structure_WO_Created__c = true;
        toiletSaleOpportunity.BIB_WO_Created__c = true;
        UPDATE toiletSaleOpportunity;
        
        //Create Opportunity_Item__c
        Opportunity_Item__c opportunityItem1 = new Opportunity_Item__c();
        opportunityItem1.Name = 'Item Name';
        opportunityItem1.Description__c = 'Supplementary Item';
        opportunityItem1.Grouping__c = 'Structure Package';
        opportunityItem1.InventoryItem__c = inventoryItemFLI.Id;
        opportunityItem1.Default_Quantity__c = 2;        
        INSERT opportunityItem1;
            
        System.debug('opportunityItem1: = ' + opportunityItem1);      
        
        //Create Standard Opportunity WO Items
        Opportunity_WO_Item__c opportunityWOItem1 = new Opportunity_WO_Item__c();
        opportunityWOItem1.Opportunity__c = toiletSaleOpportunity.Id;
        opportunityWOItem1.Opportunity_Item__c = opportunityItem1.Id;
        opportunityWOItem1.Quantity__c = (opportunityItem1.Default_Quantity__c * toiletSaleOpportunity.FLTs_Approved__c);        
        INSERT opportunityWOItem1;
        
        System.debug('opportunityWOItem1: = ' + opportunityWOItem1);     
        
        //Create Opportunity_Item__c
        Opportunity_Item__c opportunityItem2 = new Opportunity_Item__c();
        opportunityItem2.Name = 'Item Name 2';
        opportunityItem2.Description__c = 'Supplementary Item';
        opportunityItem2.Grouping__c = 'BIB Package';
        opportunityItem2.InventoryItem__c = inventoryItemFLI2.Id;
        opportunityItem2.Add_Item_Linearly__c = true;
        opportunityItem2.Default_Quantity__c = 3;        
        INSERT opportunityItem2;
            
        System.debug('opportunityItem2: = ' + opportunityItem2);

        // Create Opportunity_BIB_Item__c
        Opportunity_BIB_Item__c bib = new Opportunity_BIB_Item__c();
        bib.Opportunity__c = toiletSaleOpportunity.Id;
        bib.Opportunity_Item__c = opportunityItem2.Id;                            
        bib.Quantity__c = opportunityItem2.Default_Quantity__c * toiletSaleOpportunity.FLTs_Approved__c;        
        INSERT bib;
        
        System.debug('bib: = ' + bib);        
        
        //Create Supplementary Work Orders
        PageReference pageRef3 = Page.CreateSupplementaryWorkOrder;
        Test.setCurrentPage(pageRef3);
        pageRef3.getParameters().put('rowIndex', '1');          
        ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(toiletSaleOpportunity);
        CreateSupplementaryWorkOrder supplementaryWorkOrder = new CreateSupplementaryWorkOrder(controller3);
        
        //Create an instance of OpportunityItem Wrapper Class      
        CreateSupplementaryWorkOrder.OpportunityItem opportunityItemWrapperClass1 = new CreateSupplementaryWorkOrder.OpportunityItem(opportunityItem1); 
        opportunityItemWrapperClass1.itemGrouping = 'Structure Package';
        
        CreateSupplementaryWorkOrder.OpportunityItem opportunityItemWrapperClass2 = new CreateSupplementaryWorkOrder.OpportunityItem(opportunityItem2);
        opportunityItemWrapperClass2.itemGrouping = 'BIB Package';

        supplementaryWorkOrder.opportunityItemWrapperClassList.add(opportunityItemWrapperClass1);
        supplementaryWorkOrder.opportunityItemWrapperClassList.add(opportunityItemWrapperClass2);        
        supplementaryWorkOrder.saveItems();        
        supplementaryWorkOrder.getBIBItemsPendingApproval();
        supplementaryWorkOrder.getOpportunityWorkOrderItemsPendingApproval();
		
        for(Opportunity_BIB_Item__c bibItem : supplementaryWorkOrder.getBIBItemsPendingApproval()){
            //Approve Supplementary Item
            bibItem.Approved_Supplementary_Item__c = true;
            UPDATE bibItem;
        }

        for(Opportunity_WO_Item__c woItem : supplementaryWorkOrder.getOpportunityWorkOrderItemsPendingApproval()){
            //Approve Supplementary Item
            woItem.Approved_Supplementary_Item__c = true;
            UPDATE woItem;
        }        
        
        supplementaryWorkOrder.createWorkOrders();        
        supplementaryWorkOrder.addRow();

        //*****Stop Testing Creation of 'Structure' & 'BIB' Supplementary Work Orders*****

        //*****Start Testing Creation of 'Basic FLT' & 'BIB' Supplementary Work Orders*****
        //Create Toilet Sale Opportunity 
        Opportunity toiletSaleOpportunity2 = new Opportunity();
        toiletSaleOpportunity2.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management 
        toiletSaleOpportunity2.StageName ='Pending Govt Approval';          
        toiletSaleOpportunity2.AccountId = account1.Id;
        toiletSaleOpportunity2.Name = account1.Name;
        toiletSaleOpportunity2.Primary_Salesperson__c = salesPerson.Id;
        toiletSaleOpportunity2.CloseDate =  date.today() + 30;
        toiletSaleOpportunity2.FLTs_Approved__c = 2;
        toiletSaleOpportunity2.Basic_FLT__c = false;       
        INSERT toiletSaleOpportunity2;       

        //Add Engineering Items
        PageReference pageRef4 = Page.AddOpportunityItems;            
        Test.setCurrentPage(pageRef4);
        ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(toiletSaleOpportunity2);
        AddOppItemsController oppItemsController4 = new AddOppItemsController(controller4);
        oppItemsController4.fltVersion='Basic FLT';
        oppItemsController4.createItems();
        
        //add BiB Items
        PageReference pageRef5 = Page.AddLaunchItems;
        Test.setCurrentPage(pageRef5);
        ApexPages.Standardcontroller controller5 = new ApexPages.Standardcontroller(toiletSaleOpportunity2);
        AddLaunchItemsController oppLaunchItemsController5 = new AddLaunchItemsController(controller5);
        oppLaunchItemsController5.createItems();
        
        //Approve Engineering & BIB Items
        toiletSaleOpportunity2.BIB_Items_Approved__c=true;
        toiletSaleOpportunity2.Engineering_Items_Approved__c=true;
        toiletSaleOpportunity2.Marketing_Items_Approved__c=true; 
        
        toiletSaleOpportunity2.BIB_WO_Created__c = true;
        toiletSaleOpportunity2.Basic_FLT_WO_Created__c = true;
        UPDATE toiletSaleOpportunity2;
        
        //Create Opportunity_Item__c
        Opportunity_Item__c opportunityItem3 = new Opportunity_Item__c();
        opportunityItem3.Name = 'Item Name 3';
        opportunityItem3.Description__c = 'Supplementary Item';
        opportunityItem3.Grouping__c = 'Upstructure Package';
        opportunityItem3.InventoryItem__c = inventoryItemFLI2.Id;
        opportunityItem3.Default_Quantity__c = 2;        
        INSERT opportunityItem3;       
        
        //Create Standard Opportunity WO Items
        Opportunity_WO_Item__c opportunityWOItem2 = new Opportunity_WO_Item__c();
        opportunityWOItem2.Opportunity__c = toiletSaleOpportunity2.Id;
        opportunityWOItem2.Opportunity_Item__c = opportunityItem3.Id;
        opportunityWOItem2.Quantity__c = (opportunityItem3.Default_Quantity__c * toiletSaleOpportunity2.FLTs_Approved__c);        
        INSERT opportunityWOItem2;
        
        //Create Supplementary Work Orders
        PageReference pageRef6 = Page.CreateSupplementaryWorkOrder;
        Test.setCurrentPage(pageRef6);
        pageRef6.getParameters().put('rowIndex', '1');         
        ApexPages.Standardcontroller controller6 = new ApexPages.Standardcontroller(toiletSaleOpportunity2);
        CreateSupplementaryWorkOrder supplementaryWorkOrder2 = new CreateSupplementaryWorkOrder(controller6);
        
        //Create an instance of OpportunityItem Wrapper Class      
        CreateSupplementaryWorkOrder.OpportunityItem opportunityItemWrapperClass3 = new CreateSupplementaryWorkOrder.OpportunityItem(opportunityItem3);
        opportunityItemWrapperClass3.itemGrouping = 'Upstructure Package';     
            
        supplementaryWorkOrder2.opportunityItemWrapperClassList.add(opportunityItemWrapperClass3);
        supplementaryWorkOrder2.saveItems();
        supplementaryWorkOrder2.getBIBItemsPendingApproval();
        supplementaryWorkOrder2.getOpportunityWorkOrderItemsPendingApproval();         
        
        for(Opportunity_WO_Item__c woItem2 : supplementaryWorkOrder2.getOpportunityWorkOrderItemsPendingApproval()){
            //Approve Supplementary Item
            woItem2.Approved_Supplementary_Item__c = true;
            UPDATE woItem2;
        }         
        
        supplementaryWorkOrder2.createWorkOrders();
        supplementaryWorkOrder2.addRow();
        supplementaryWorkOrder2.deleteRow();
        
        //*****Stop Testing Creation of 'Basic FLT' & 'BIB' Supplementary Work Orders*****
    }

}