@isTest(SeeAllData=true)
public class InventoryTest {
    static testMethod void TestInventory(){
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {
            FFA_Config_Object__c compny = [SELECT Name,Id,Type__c FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'company' AND isActive__c = true 
                                           AND Name = 'Sanergy Limited' LIMIT 1];
            if(compny != null){
                FFA_Config_Object__c department = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                   WHERE Type__c = 'dim1' AND isActive__c = true 
                                                   AND Name = 'Sanergy Operations - Supply Chain - Warehouse' LIMIT 1];
                if(department != null){
                    Inventory_UoM__c uom = new Inventory_UoM__c();
                    uom.Uom_Code__c = 'Pack';
                    uom.Name = 'n';
                    uom.Description__c = 'Pack - 70kg';
                    insert uom;
                    
                    Inventory_Location__c site = new Inventory_Location__c();
                    site.Name = 'Mukuru 2345';
                    insert site;
                    
                    
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
                                
                                Purchase_Order_Item__c poI = [SELECT Id, Unit_Net_Price__c,Name, Inventory_Item__c,Gross_Value__c,Item_Cost__c,
                                                              Item_Description__c,Net_VAT__c,Primary_Vendor__c,Purchase_UoM__c,Vendor__c,Vatable__c,
                                                              VAT_Percentage__c,VAT_Inclusive__c, Currency__c
                                                              FROM Purchase_Order_Item__c 
                                                              WHERE Primary_Vendor__c = true
                                                              AND Status__c='Active'
                                                              AND Approved__c = true                                                              
                                                              LIMIT 1];
                                
                                if(poI != null){
                                    poI.Inventory_Item__c = item.Id;
                                    poI.Purchase_UoM__c = item.Inventory_UoM__c;
                                    poI.UOM_Conversion_Factor__c = 1;
                                    update poI;
                                    
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
                                    
                                    insert itmloc1;
                                    
                                    
                                    
                                    
                                    FFA_Config_Object__c gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                                                WHERE Type__c = 'gla' AND isActive__c = true 
                                                                AND Name = '6775 - Meals - Internal' LIMIT 1];
                                    if(gla != null){
                                        
                                        Group_Details__c details = new Group_Details__c();
                                        details.Config_Account__c = gla.Id;
                                        details.Credit_Debit__c = 'Debit';
                                        details.Inventory_Item_Group__c = comCode.Id;
                                        details.Transaction_ID__c = 'LOCMOVE';
                                        details.Is_GL_Account__c = true;
                                        
                                        Insert details;
                                        
                                        Group_Details__c details1 = new Group_Details__c();
                                        details1.Config_Account__c = gla.Id;
                                        details1.Credit_Debit__c = 'Credit';
                                        details1.Inventory_Item_Group__c = comCode.Id;
                                        details1.Transaction_ID__c = 'LOCMOVE';
                                        details1.Is_GL_Account__c = true;
                                        
                                        Insert details1;
                                        
                                        
                                        Item_Location_Lot__c lot = new Item_Location_Lot__c();
                                        lot.Lot_Name__c = 'Lot 18';
                                        lot.Quantity__c = 90909;
                                        lot.Item_Location__c = itmloc.Id;
                                        
                                        insert lot;
                                        
                                        Item_Location_Lot__c lot1 = new Item_Location_Lot__c();
                                        lot1.Lot_Name__c = 'Lot 188';
                                        lot1.Quantity__c = 90909;
                                        lot1.Item_Location__c = itmloc1.Id;
                                        
                                        insert lot1;
                                        
                                        Inventory_Location_Move__c locmv = new Inventory_Location_Move__c();
                                        locmv.Inventory_Item__c = item.Id;
                                        locmv.Location_From__c = itmloc.Id;
                                        locmv.Location_To__c = itmloc1.Id;
                                        locmv.Quantity__c = 3;
                                        locmv.Location_Lot_From__c = lot.Id;
                                        locmv.Location_Lot_To__c = lot1.Id;
                                        
                                        insert locmv;
                                        
                                        
                                        Inventory_Transaction__c Trans = new Inventory_Transaction__c();
                                        Trans.Item__c = item.Id;
                                        Trans.Transaction_ID__c = 'CYCLECNT';
                                        Trans.Location__c = itmloc.Id;
                                        Trans.Location_Lot__c = lot.Id;
                                        Trans.Transaction_Quantity__c = 1;
                                        Trans.Item_Unit_Price__c = item.unit_cost__c;
                                        Trans.Quantity_Impact__c = 'D';
                                        Trans.Debit_Account__c = gla.lookup_ID__c;
                                        Trans.Credit_Account__c = gla.lookup_ID__c;
                                        Trans.Dimension_1__c = department.lookup_ID__c;
                                        Trans.Dimension_2__c = dim2.lookup_ID__c;
                                        Trans.Dimension_3__c = dim3.lookup_ID__c;
                                        Trans.Dimension_4__c = dim4.lookup_ID__c;
                                        Trans.Comments__c = 'CYCLECNT';
                                        
                                        insert Trans;
                                        try{
                                            lot.Quantity__c = 0;
                                            update lot;
                                            
                                            delete Trans;
                                        }catch(Exception e){
                                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                                            
                                        }
                                        
                                        try{
                                            Trans.Transaction_Quantity__c = 1;
                                            
                                            update Trans;
                                        }catch(Exception e){
                                            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                                            
                                        }
                                        
                                        
                                        
                                        System.debug('Credit::::'+ Trans.Credit_Account__c);
                                        System.debug('DEbit::::'+ Trans.Debit_Account__c);
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}