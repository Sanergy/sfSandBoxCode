@isTest(SeeAllData=true)

public class CreateTransactionsTriggerTest {
    
    static testMethod void moveItemTest(){
        
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u.get(0)) {
            List<Inventory_item__c> item = [Select Id, Name, Item_Group__c,Inventory_Stock__c,Inventory_UoM__c
                                  FROM Inventory_item__c WHERE Inventory_Stock__c >= 3 
                                  AND Commodity_Code_Type__c = 'Manufactured'
                                 ];
            
            if(item.size() > 0){
                
                item.get(0).Item_Type__c = 'Stock';
                update item;
                
                Inventory_Location__c loc1 = new Inventory_Location__c(
                    Name = 'Mukuru 2345'
                );
                insert loc1;
                
                Inventory_Location__c loc2 = new Inventory_Location__c(
                    Name = 'Mukuru 1234'
                );
                insert loc2;
                
                Inventory_Item_Location__c itmloc1 = new Inventory_Item_Location__c(
                    Name = loc1.Name,
                    Location_Name__c = '008980',
                    Location__c = loc1.Id,
                    Inventory_Item__c = item.get(0).Id,
                    Max_Location_Quantity__c = 100
                );
                
                insert itmloc1;
            
                Inventory_Item_Location__c itmloc2 = new Inventory_Item_Location__c(
                    Name = loc2.Name,
                    Location_Name__c = '00809',
                    Location__c = loc2.Id,
                    Inventory_Item__c = item.get(0).Id,
                    Max_Location_Quantity__c = 100
                );
            
            	insert itmloc2;
            
            	Item_Location_Lot__c lot1 = new Item_Location_Lot__c();
                lot1.Lot_Name__c = 'Lot 18';
                lot1.Quantity__c = 90909;
                lot1.Item_Location__c = itmloc1.Id;
            
                insert lot1;
                
                lot1.Quantity__c = 9090;
                
                update lot1;
                
                Item_Location_Lot__c lot2 = new Item_Location_Lot__c();
                lot2.Lot_Name__c = 'Lot 19';
                lot2.Quantity__c = 909;
                lot2.Item_Location__c = itmloc2.Id;
            
                insert lot2;
                        
                Inventory_Location_Move__c locmv = new Inventory_Location_Move__c();
                locmv.Inventory_Item__c = item.get(0).Id;
                locmv.Location_From__c = itmloc1.Id;
                locmv.Location_To__c = itmloc2.Id;
                locmv.Quantity__c = 3;
                locmv.Location_Lot_From__c = lot1.Id;
                locmv.Location_Lot_To__c = lot2.Id;
        
                insert locmv;
                
                
                
                List<Inventory_item__c> items = [Select Id, Name, Inventory_UoM__c, Item_Group__c,Inventory_Stock__c
                                                 FROM Inventory_item__c WHERE Inventory_Stock__c >= 3 
                                                 AND Commodity_Code_Type__c != 'Manufactured' LIMIT 1
                                                 ];
                
                if(items.size() > 0){
                    
                    items.get(0).Item_Type__c = 'Stock';
                	update items;
                    
                    List<Purchase_Order_Item__c> poI = [SELECT Id, Unit_Net_Price__c,Name, Inventory_Item__c,Gross_Value__c,Item_Cost__c,
                                                        Item_Description__c,Net_VAT__c,Primary_Vendor__c,Purchase_UoM__c,Vendor__c,Vatable__c,
                                                        VAT_Percentage__c,VAT_Inclusive__c, Currency__c
                                                        FROM Purchase_Order_Item__c WHERE Primary_Vendor__c = true
                                                        AND Purchase_UoM__c =: items.get(0).Inventory_UoM__c
                                                        LIMIT 1
                                                       ];
                    
                    if(poI.size() > 0){
                        poI.get(0).Inventory_Item__c = items.get(0).Id;
                        poI.get(0).UOM_Conversion_Factor__c = 1;
                       // update poI;
                        
                        Inventory_Location__c loc = new Inventory_Location__c(
                            Name = 'Mukuru 2345'
                        );
                        insert loc;
            
                        Inventory_Location__c lo = new Inventory_Location__c(
                            Name = 'Mukuru 1234'
                        );
                        insert lo;
            
                        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
                            Name = loc.Name,
                            Location_Name__c = '008980',
                            Location__c = loc.Id,
                            Inventory_Item__c = items.get(0).Id,
                            Max_Location_Quantity__c = 100
                        );
                        
                        insert itmloc;
                       
                    	Item_Location_Lot__c lot = new Item_Location_Lot__c();
                        lot.Lot_Name__c = 'Lot 18';
                        lot.Quantity__c = 90909;
                        lot.Item_Location__c = itmloc.Id;
            
            			insert lot;
                    }
                }
            }
        }
    }
}