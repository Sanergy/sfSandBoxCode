@isTest(seeAllData = true)
public class CreateEPRFromSPRTriggerTest {
    static testMethod void CreateEPRFromSPRTriggerTest(){
         //Get dim1                              
         List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                  FROM FFA_Config_Object__c 
                                                  WHERE Type__c = 'dim1' 
                                                  AND Name = 'Information Technology'
                                                  AND isActive__c = true LIMIT 1];
            System.debug('' + department);
         //Get dim2                                    
         List<FFA_Config_Object__c> dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim2' 
                                            AND isActive__c = true LIMIT 1];
            
         //Get dim3                                   
         List<FFA_Config_Object__c> dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim3' 
                                            AND isActive__c = true LIMIT 1];
            
         //Get dim4                                     
         List<FFA_Config_Object__c> dim4 = [SELECT Id,Name,Type__c,isActive__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim4' 
                                            AND isActive__c = true LIMIT 1];
                                                 
         //Get GLA
         /* List<FFA_Config_Object__c> gla = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'gla' 
                                           AND isActive__c = true LIMIT 1];*/
       List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla'
                                         AND (Name='2000 - Accounts Payable Control'
                                         OR Name='2050 - Accrued Accounts Payable Control')
                                         AND isActive__c=true LIMIT 2];                                      
         //Get Company
         List<FFA_Config_Object__c> company= [SELECT Id,Name,Type__c,isActive__c 
                                              FROM FFA_Config_Object__c 
                                              WHERE type__c='company' 
                                              AND isActive__c=true LIMIT 5];
        
        //Get employee
        //James ID - need to make sure emp selected has a TL for the sharing reasons to work 
        List<Employee__c> employee = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                      FROM Employee__c 
                                      WHERE Employee_Active__c=true 
                                      AND Id = 'aAsD0000000GmgM' LIMIT 1];          
             
         //Get a vendor
         List<Account> vendor = [SELECT Id 
                                 FROM Account 
                                 WHERE RecordType.Name = 'Sanergy Vendor'
                                 AND ID =: '001D000001APxbJ'
                                 LIMIT 1];
        
         //Get Company
         FFA_Config_Object__c company1 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy Limited'
                                          LIMIT 1];        
         
         //Get Company
         FFA_Config_Object__c company2 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Fresh Life Initiative Limited'
                                          LIMIT 1];

         //Get Company
         FFA_Config_Object__c company3 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy, Inc. (FP)'
                                          LIMIT 1]; 
         
         //Get Company
         FFA_Config_Object__c company4 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy, Inc. (NP)'
                                          LIMIT 1];
        
        //Fetch Existing Account		
        List<Account> ac= [SELECT Id,
                           Name,
                           CurrencyIsoCode
                           FROM Account
                           WHERE Name='Tuffsteel Ltd'
                           Limit 1
                          ];
        
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
        
        // Create a Contract            
        Contract contract = new Contract(
            AccountId=ac.get(0).Id, 
            Status = 'Draft',
            StartDate=date.today(),
            ContractTerm=1, CurrencyIsoCode='KES',
            Payment_Terms__c='7 Days',
            Primary_Contract__c=true
        );
        INSERT contract;
        
        //Get Purchase Order Item
        Purchase_Order_Item__c poI = new Purchase_Order_Item__c();
        poI.Name = 'Item';
        poI.Item_Description__c = 'Item Desc';
        poI.Currency__c = curr.id;
        poI.Inventory_Item__c = invItem.Id;
        poI.Purchase_UoM__c = uom.Id;
        poI.UOM_Conversion_Factor__c = 10;
        poI.Contract_Number__c = contract.Id;
        poI.Vendor__c = contract.AccountId;
        poI.Status__c = 'Active';
        poI.Approved__c = true; 
        INSERT poI;           
         
         //Create Special Procurement               
         Special_Procurement__c sp1 = new Special_Procurement__c();
         sp1.Requestor__c = 'aAsD0000000GmgM';
         sp1.Type__c = 'Cash Advance';
         sp1.Required_Date__c = date.today();
         sp1.Comments__c = 'Two tyres for Toyota Corolla';         
         sp1.Requesting_Department__c = department.get(0).Id;
         sp1.Vendor__c = contract.AccountId;     
         sp1.Approval_Status__c = 'Approved By Team Lead';
         sp1.Dim_2__c = dim2.get(0).Id;
         sp1.Dim_3__c = dim3.get(0).Id;
         sp1.GLA__c = gla.get(0).Id;
         sp1.Grant__c = dim4.get(0).Id;
         sp1.Requesting_Company__c = company1.Id;
        sp1.Reconciliation_Completed__c = TRUE;
        INSERT sp1;
		 
        System.debug('SPR: ' + sp1.Requesting_Company__c);
        
        //Create Special Procurement Line Items
        Special_Procurement_Line_Item__c spLineItems1 = new Special_Procurement_Line_Item__c();
        spLineItems1.Special_Procurement__c = sp1.Id;
        spLineItems1.Item__c = 'Two 18 Inch Car Tyress';
        spLineItems1.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
        spLineItems1.Quantity_Requested__c = 2;
        spLineItems1.Unit_Price__c = 600;
        spLineItems1.Status__c = 'Approved';
        spLineItems1.Purchase_Order_Item__c =poI.Id;
        INSERT spLineItems1;
        
         //Create Special Procurement               
         Special_Procurement__c sp2 = new Special_Procurement__c();
         sp2.Requestor__c = 'aAsD0000000Gmhr';//Ani
         sp2.Type__c = 'Employee Reimbursement';
         sp2.Required_Date__c = date.today();
         sp2.Comments__c = 'Two tyres for Toyota Corollas';         
         sp2.Requesting_Department__c = department.get(0).Id;
         sp2.Vendor__c = contract.AccountId; 
         sp2.Approval_Status__c = 'Approved By Team Lead';
         sp2.Dim_2__c = dim2.get(0).Id;
         sp2.Dim_3__c = dim3.get(0).Id;
         sp2.GLA__c = gla.get(0).Id;
         sp2.Grant__c = dim4.get(0).Id;
         sp2.Requesting_Company__c = company2.Id;
         //sp2.Reconciliation_Completed__c = TRUE;
         INSERT sp2;
		 
        System.debug('SPR: ' + sp2.Requesting_Company__c);
        
        //Create Special Procurement Line Items
        Special_Procurement_Line_Item__c spLineItems2 = new Special_Procurement_Line_Item__c();
        spLineItems2.Special_Procurement__c = sp2.Id;
        spLineItems2.Item__c = 'Two 18 Inch Car Tyress';
        spLineItems2.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                 
        spLineItems2.Quantity_Requested__c = 2;
        spLineItems2.Unit_Price__c = 600;
        spLineItems2.Status__c = 'Approved';
        spLineItems2.Purchase_Order_Item__c =poI.Id;
        INSERT spLineItems2;

         //Create Special Procurement               
         Special_Procurement__c sp3 = new Special_Procurement__c();
         sp3.Requestor__c = 'aAsD0000000GmgM';//James
         sp3.Type__c = 'Special Procurement';
         sp3.Required_Date__c = date.today();
         sp3.Comments__c = 'Two tyres for Toyota Corollas';         
         sp3.Requesting_Department__c = department.get(0).Id;
         sp3.Vendor__c = contract.AccountId; 
         sp3.Approval_Status__c = 'Approved By Team Lead';
         sp3.Dim_2__c = dim2.get(0).Id;
         sp3.Dim_3__c = dim3.get(0).Id;
         sp3.GLA__c = gla.get(0).Id;
         sp3.Grant__c = dim4.get(0).Id;
         sp3.Requesting_Company__c = company3.Id;
         sp3.Reconciliation_Completed__c = TRUE;
         INSERT sp3;
		 
         System.debug('SPR: ' + sp3.Requesting_Company__c);
         
         //Create Special Procurement Line Items
		 Special_Procurement_Line_Item__c spLineItems3 = new Special_Procurement_Line_Item__c();
         spLineItems3.Special_Procurement__c = sp3.Id;
         spLineItems3.Item__c = 'Two 18 Inch Car Tyress';
         spLineItems3.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
         spLineItems3.Quantity_Requested__c = 2;
         spLineItems3.Unit_Price__c = 400;
         spLineItems3.Status__c = 'Approved';
         spLineItems3.Purchase_Order_Item__c =poI.Id;
         INSERT spLineItems3;
         
         //Create Special Procurement               
         Special_Procurement__c sp4 = new Special_Procurement__c();
         sp4.Requestor__c = 'aAsD0000000Gmoa';//Lindsay
         sp4.Type__c = 'Cash Advance';
         sp4.Required_Date__c = date.today();
         sp4.Comments__c = 'Two tyres for Toyota Corollas';         
         sp4.Requesting_Department__c = department.get(0).Id;
         sp4.Vendor__c = contract.AccountId;       
         sp4.Approval_Status__c = 'Approved By Team Lead';
         sp4.Dim_2__c = dim2.get(0).Id;
         sp4.Dim_3__c = dim3.get(0).Id;
         sp4.GLA__c = gla.get(0).Id;
         sp4.Grant__c = dim4.get(0).Id;
         sp4.Requesting_Company__c = company4.Id;
         INSERT sp4;
		 
         System.debug('SPR: ' + sp4.Requesting_Company__c);
         
         //Create Special Procurement Line Items
		 Special_Procurement_Line_Item__c spLineItems4 = new Special_Procurement_Line_Item__c();
         spLineItems4.Special_Procurement__c = sp4.Id;
         spLineItems4.Item__c = 'Two 18 Inch Car Tyress';
         spLineItems4.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                 
         spLineItems4.Quantity_Requested__c = 2;
         spLineItems4.Unit_Price__c = 300;
         spLineItems4.Status__c = 'Approved';
         spLineItems4.Purchase_Order_Item__c =poI.Id;
         INSERT spLineItems4;
        
        //CREATE EPR 
        Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();
        epr.department__c = sp1.Requesting_Department__c;
        epr.Company__c = 'Sanergy Ltd';
        epr.Vendor_Company__c = sp1.Vendor__c;
        epr.Invoice_Number__c = sp1.Name;                              
        epr.Scheduled_Payment_Date__c = date.today();                
        epr.Notes__c='Payment for items bought';
        epr.Payment_Type__c = sp1.Type__c;         
        insert epr;
        
        sp1.EPR_Created__c = true;
        update sp1;
        
        
        EPR_Payable_Item__c eprLineItems = new EPR_Payable_Item__c();            
        eprLineItems.epr__c=epr.id;
        eprLineItems.Department_dim1__c = epr.department__c;
        eprLineItems.Item__c = spLineItems1.Item__c;
        eprLineItems.Quantity__c = spLineItems1.Quantity_Requested__c;
        eprLineItems.Unit_Price__c = spLineItems1.Unit_Price__c;
        eprLineItems.Location_Dim2__c = sp1.Dim_2__c;
        eprLineItems.Dim_3__c = sp1.Dim_3__c;                
        eprLineItems.GLA__c = sp1.GLA__c;
        
        INSERT eprLineItems;
       
        spLineItems1.EPR_Created__c = True;
        update spLineItems1;
        
        
        // Special Procurement Payment
        Special_Procurement_Payment__c spp = new Special_Procurement_Payment__c();
        spp.Company__c=sp1.Requesting_Company__c;
        spp.EPR__c=epr.id;
        spp.Special_Procurement__c=sp1.id;
        spp.Payment_Cost__c=sp1.Total_Amount__c;
        
        INSERT spp;	
     
         //ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(sp1);
         CreateEPRFromSPRTriggerTest createEPR1= new CreateEPRFromSPRTriggerTest ();

        // ApexPages.Standardcontroller controller2 = new ApexPages.Standardcontroller(sp2);
         CreateEPRFromSPRTriggerTest createEPR2= new CreateEPRFromSPRTriggerTest ();
         
        // ApexPages.Standardcontroller controller3 = new ApexPages.Standardcontroller(sp3);
         CreateEPRFromSPRTriggerTest createEPR3= new CreateEPRFromSPRTriggerTest ();

        // ApexPages.Standardcontroller controller4 = new ApexPages.Standardcontroller(sp4);
         CreateEPRFromSPRTriggerTest createEPR4= new CreateEPRFromSPRTriggerTest ();
        
    }
}