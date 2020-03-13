@isTest(seeAllData=true)
public class ProcessCountVarianceControllerTest {
    
    static testMethod void testDecreaseAdjustment(){
        
        //Get Department
        List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];        
      
        //Get gla
        List<FFA_Config_Object__c> glas= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
       
		// Create a Currency Config
		Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;        
        
		// Create Inventory UoM
        Inventory_UoM__c iUom = new Inventory_UoM__c();
        iUom.Name = 'Dummy Inventory UOM 1';
        iUom.Description__c = 'Dummy Inventory UOM one';
        iUom.Uom_Code__c = '101';
        iUom.CurrencyIsoCode = 'KES';
        INSERT iUom;
        
		// Create Inventory Item Group
        Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
        invItemGroup.Name = 'New Inventory Item Group';
        invItemGroup.Commodity_Code__c = 'New Commodity code';
		invItemGroup.Description__c = 'Brief description';            
        INSERT invItemGroup;
       
        Group_Details__c creditGl = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Config_Account__c = glas.get(0).Id,
            Credit_Debit__c = 'Credit',
            Is_GL_Account__c = true,
            Transaction_ID__c = 'CYCLECNT'
        );
        
        insert creditGl;
        
         Group_Details__c debitGl = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Config_Account__c = glas.get(1).Id,
            Credit_Debit__c = 'Debit',
            Is_GL_Account__c = true,
            Transaction_ID__c = 'CYCLECNT'
        );
        
        insert debitGl;
        
        // Create Inventory Location
        Inventory_Location__c site = new Inventory_Location__c();
        site.Name = 'Mukuru';        
        INSERT site;
        
		// Create Inventory Item
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
        
        // Create Inventory Item Location
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c();
        itmloc.Name = site.Name;
        itmloc.Location_Name__c = '001';
        itmloc.Location__c = site.Id;
        itmloc.Inventory_Item__c = invItem.Id;
        itmloc.Max_Location_Quantity__c = 100;              
        INSERT itmloc; 
        
        // Create Item Location Lot
        Item_Location_Lot__c lot = new Item_Location_Lot__c();
        lot.Lot_Name__c = '001';
        lot.Quantity__c = 100;
        lot.Item_Location__c = itmloc.Id;                
        INSERT lot;        
        
        // Create Inventory Count
		Inventory_Count__c ic = new Inventory_Count__c();
        ic.Count_Date__c = date.today();
        INSERT ic;
        
        // Create Item Inventory Count
        Item_Inventory_Count__c itemInvCount = new Item_Inventory_Count__c();
        itemInvCount.Item_Location__c = itmloc.Id;
        itemInvCount.Item_Lot__c = lot.Id;    
        itemInvCount.Inventory_Count__c = ic.Id;
        itemInvCount.Inventory_Item__c = invItem.Id;
        itemInvCount.Inventory_Stock__c = 200;
        itemInvCount.Physical_Count__c = 150;
        INSERT itemInvCount;

		// Create Inventory Transaction
        Inventory_Transaction__c invTrans = new Inventory_Transaction__c();
		invTrans.Item__c = invItem.Id;
        invTrans.Transaction_ID__c = 'PORCPT';
        invTrans.Transaction_Quantity__c = 20;
        invTrans.Quantity_Impact__c = 'I';
        invTrans.Location__c = itmloc.Id;
        invTrans.Location_Lot__c = lot.Id;
        invTrans.CurrencyIsoCode = 'KES'; 
        
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u.get(0)) {
            PageReference pageRef = Page.ProcessVariance;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller cont = new ApexPages.Standardcontroller(ic);
            ProcessCountVarianceController processCountVariance = new ProcessCountVarianceController (cont); 
            processCountVariance.getItems();
            processCountVariance.selectAll();
            processCountVariance.updateInventoryCounts();     
        }
    }
}