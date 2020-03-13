@isTest(seeAllData = true)
public class AssetServiceItemTriggerTest {
    
    static testMethod void testAssetServiceItemTriggerTest(){
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true LIMIT 2];      
        //Get Dim 2
        List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
        //Get dim3
        List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
        //Get dim4
        List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
        
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 1];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE Name ='Fresh Life Initiative Limited' and isActive__c=true LIMIT 1];
        
        //Get employee
        List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
        
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
        
        //Fetch Existing Account		
        List<Account> acc =[SELECT Id,
                            Name,
                            CurrencyIsoCode
                            FROM Account
                            WHERE Name='Tuffsteel Ltd'
                            Limit 1
                           ];
        
        // Create a Contract            
        Contract contract = new Contract(
            AccountId=acc.get(0).Id, 
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
        
        //create service item
        Asset_Service_Item__c serveItem = new Asset_Service_Item__c();
        serveItem.Inventory_Item__c = invItem.Id;
        serveItem.Purchase_Order_Item__c = poI.Id;
        serveItem.vendor__c = acc.get(0).Id;
        
        insert serveItem;
        
    }
}