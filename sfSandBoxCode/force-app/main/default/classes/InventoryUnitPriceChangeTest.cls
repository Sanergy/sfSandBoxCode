@isTest(SeeAllData=true)

public class InventoryUnitPriceChangeTest {
    
    static testMethod void InventoryUnitPriceChangeTest(){
        
        //Get Company
        FFA_Config_Object__c compny = [SELECT Name,Id,Type__c FROM FFA_Config_Object__c 
                                       WHERE Type__c = 'company' AND isActive__c = true 
                                       AND Name = 'Sanergy Limited' LIMIT 1];
        //Get dim1                              
        FFA_Config_Object__c department = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim1' AND isActive__c = true LIMIT 1];
        
        FFA_Config_Object__c dim3 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim3' AND isActive__c = true 
                                     AND Name = 'Not Applicable' LIMIT 1];
        
        FFA_Config_Object__c dim4 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim4' AND isActive__c = true 
                                     AND Name = 'Not Applicable' LIMIT 1];
        
        FFA_Config_Object__c dim2 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim2' AND isActive__c = true 
                                     AND Name = 'Not Applicable' LIMIT 1];
        
        //Get GLA
        FFA_Config_Object__c gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                    WHERE Type__c = 'gla' AND isActive__c = true AND lookup_ID__c!= null LIMIT 1];
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
        
         Decimal newPrice = 10;
        
        Inventory_UoM__c uom = new Inventory_UoM__c();
        uom.Uom_Code__c = 'Pack';
        uom.Name = 'n';
        uom.Description__c = 'Pack - 70kg';
        insert uom;
        
        
        Inventory_Item_Group__c comCode = new Inventory_Item_Group__c();
        comCode.Name = 'name';
        comCode.Dimension_1__c = department.Id;
        comCode.Description__c = 'Raw';
        comCode.Dimension_2__c = dim2.Id;
        comCode.Dimension_3__c = dim3.Id;
        comCode.Dimension_4__c = dim4.Id;
        comCode.Commodity_Code__c = 'Raw';
        insert comCode;
        
        List<Inventory_item__c> items = [Select Id,Has_BOM__c, Name,unit_cost__c,Item_Group__r.Dimension_1__r.lookup_ID__c,
                                         Item_Group__r.Dimension_2__r.lookup_ID__c, Item_Group__r.Dimension_3__r.lookup_ID__c,
                                         Item_Group__r.Dimension_4__r.lookup_ID__c,Item_Group__c
                                         FROM Inventory_item__c WHERE  Has_BOM__c = true LIMIT 1
                                        ];

        
        Inventory_Location__c site = new Inventory_Location__c();
        site.Name = 'Mukuru - 001';
        insert site;
        
        Currency_Config__c currenc = new Currency_Config__c();
        currenc.Currency_Name__c = 'Kenyan Shilling';
        currenc.Name = 'KES';
        currenc.Value__c = 1;
        currenc.start__c = date.today();
        currenc.Current__c = true;
        insert currenc;  
        
        Inventory_Item__c item = new Inventory_Item__c();
        item.Item_Description__c = 'Cement';
        item.Currency_Config__c = currenc.Id;
        item.Name = 'item';
        item.Item_Number__c = '123456';
        item.Responsible_Department__c = department.Id;
        item.Policy_Quantity__c = 10;
        item.Minimum_Quantity__c = 2;
        item.Item_Group__c = comCode.Id;
        item.Inventory_UoM__c = uom.Id;
        item.unit_cost__c = 100;
        item.Item_Company__c = compny.Id;
        item.Default_Site__c = site.Id;
        item.Default_Location__c = '1';
        item.Default_Lot__c = '1';
        
        insert Item;
        
        item.unit_cost__c = 200;
        
        
        Inventory_Location__c invloc = new Inventory_Location__c(
            Name = 'Mukuru - 001'
        );
        insert invloc;
        
        
        Inventory_Item_Location__c loc = new Inventory_Item_Location__c(
            Name = 'Mukuru - 001',
            Location__c = invloc.Id,
            Inventory_Item__c = item.Id,
            Location_Name__c = '00809',
            Max_Location_Quantity__c = 100
        );
        insert loc;
        system.debug('Location' + loc);
        
        Item_Location_Lot__c lot2 = new Item_Location_Lot__c();
        lot2.Lot_Name__c = 'Lot 19';
        lot2.Quantity__c = 909;
        lot2.Item_Location__c = loc.Id;
        
        insert lot2;
        
        lot2.Quantity__c = 999;
        update lot2;
        
 
        Inventory_Item_BOM__c InvBOM = new Inventory_Item_BOM__c();
        InvBOM.Parent_Item__c = items.get(0).Id;
        InvBOM.BOM_Item__c = item.id;
        InvBOM.Quantity_Per__c = 1.00;
        Insert InvBOM;
        system.debug('BOM iTEM' + InvBOM);
        
        Inventory_Transaction__c fromtrans = new Inventory_Transaction__c();
        
        fromtrans.Item__c = item.Id;
        fromtrans.Location__c = loc.Id;
        fromtrans.Quantity_Impact__c = 'U';
        fromtrans.Transaction_ID__c = 'UNITPRICECHANGE';
        fromtrans.Transaction_Quantity__c = 0.00;            
        fromtrans.Location_Lot__c = lot2.Id;
        fromtrans.Item_Unit_Price__c = item.unit_cost__c;
        fromtrans.Debit_Account__c = gla.Lookup_Id__c;
        fromtrans.Credit_Account__c = gla.Lookup_Id__c;
        fromtrans.Dimension_1__c = item.Item_Group__r.Dimension_1__r.lookup_ID__c;
        fromtrans.Dimension_2__c = item.Item_Group__r.Dimension_2__r.lookup_ID__c;
        fromtrans.Dimension_3__c = item.Item_Group__r.Dimension_3__r.lookup_ID__c;
        fromtrans.Dimension_4__c = item.Item_Group__r.Dimension_4__r.lookup_ID__c;
        fromtrans.Comments__c = 'UNITPRICECHANGE';
        fromtrans.Item_Unit_Price__c = 10;
        
        System.debug('Credit gla id: '+gla.Lookup_Id__c);
        System.debug('Debit gla id: '+gla.Lookup_Id__c);
        
        insert fromtrans;
        
        
        Inventory_Transaction__c romtrans = new Inventory_Transaction__c();
        
        romtrans.Item__c = item.Id;
        romtrans.Location__c = loc.Id;
        romtrans.Quantity_Impact__c = 'U';
        romtrans.Transaction_ID__c = 'UNITPRICECHANGE';
        romtrans.Transaction_Quantity__c = 0;            
        romtrans.Location_Lot__c = lot2.Id;
        romtrans.Item_Unit_Price__c = items.get(0).unit_cost__c;
        romtrans.Debit_Account__c = gla.Lookup_Id__c;
        romtrans.Credit_Account__c = gla.Lookup_Id__c;
        romtrans.Dimension_1__c = items.get(0).Item_Group__r.Dimension_1__r.lookup_ID__c;
        romtrans.Dimension_2__c = items.get(0).Item_Group__r.Dimension_2__r.lookup_ID__c;
        romtrans.Dimension_3__c = items.get(0).Item_Group__r.Dimension_3__r.lookup_ID__c;
        romtrans.Dimension_4__c = items.get(0).Item_Group__r.Dimension_4__r.lookup_ID__c;
        romtrans.Comments__c = 'UNITPRICECHANGE';
        romtrans.Item_Unit_Price__c = 10;
        
        insert romtrans;
        
        //Create an instance of Inventory Item Wrapper Class      
        InventoryUnitPriceChange.WrapperItems InventoryItemsWrapperClass = new InventoryUnitPriceChange.WrapperItems(Item);
        
        //Create an instance of Inventory Item Wrapper Class      
        InventoryUnitPriceChange.BOMWrapper BOMItemsWrapperClass = new InventoryUnitPriceChange.BOMWrapper(InvBOM);
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(item);
        InventoryUnitPriceChange UPC = new InventoryUnitPriceChange(controller);
        UPC.newPrice = 10;
        UPC.getItems();
        UPC.getBom();
        UPC.CreateInventoryTransaction();
        
        
    }
    
}