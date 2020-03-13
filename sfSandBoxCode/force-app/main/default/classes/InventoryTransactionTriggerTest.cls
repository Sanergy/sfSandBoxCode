@isTest(SeeAllData=true)

public class InventoryTransactionTriggerTest {
    
    static testMethod void InventoryTransactionTest(){
        
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u.get(0)) {
            //Get Company
            FFA_Config_Object__c compny = [SELECT Name,Id,Type__c FROM FFA_Config_Object__c 
                                             WHERE Type__c = 'company' AND isActive__c = true 
                                             AND Name = 'Sanergy Limited' LIMIT 1];
            //Get dim1                              
            FFA_Config_Object__c department = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' AND isActive__c = true LIMIT 1];
            //Get dim2                                    
            FFA_Config_Object__c dim2 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim2' AND isActive__c = true LIMIT 1];
            //Get dim3                                   
            FFA_Config_Object__c dim3 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim3' AND isActive__c = true LIMIT 1];
            //Get dim4                                     
            FFA_Config_Object__c dim4 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim4' AND isActive__c = true LIMIT 1];
            //Get GLA
            FFA_Config_Object__c gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'gla' AND isActive__c = true AND lookup_ID__c!= null LIMIT 1];
             //Get Company
             List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
             
             //Create Inventory commodity Code
            Inventory_Item_Group__c comCode = new Inventory_Item_Group__c();
            comCode.Name = 'name';
            comCode.Dimension_1__c = department.Id;
            comCode.Description__c = 'Test Desc';
            comCode.Dimension_2__c = dim2.Id;
            comCode.Dimension_3__c = dim3.Id;
            comCode.Dimension_4__c = dim4.Id;
            comCode.Commodity_Code__c = 'Test Descr';
            insert comCode;
            
           //Create Group Details
            Group_Details__c detailsDebit = new Group_Details__c();
            detailsDebit.Config_Account__c = gla.Id;
            detailsDebit.Credit_Debit__c = 'Debit';
            detailsDebit.Inventory_Item_Group__c = comCode.Id;
            detailsDebit.Transaction_ID__c = 'INVLOCADJ';
            detailsDebit.Is_GL_Account__c = true;            
            Insert detailsDebit ;
                                
            Group_Details__c detailsCredit = new Group_Details__c();
            detailsCredit.Config_Account__c = gla.Id;
            detailsCredit.Credit_Debit__c = 'Credit';
            detailsCredit.Inventory_Item_Group__c = comCode.Id;
            detailsCredit.Transaction_ID__c = 'INVLOCADJ';
            detailsCredit.Is_GL_Account__c = true;            
            Insert detailsCredit ;
            
            List<Inventory_item__c> items = [Select Id,Has_BOM__c, Name,unit_cost__c,Item_Group__r.Dimension_1__r.lookup_ID__c,
                                            Item_Group__r.Dimension_2__r.lookup_ID__c, Item_Group__r.Dimension_3__r.lookup_ID__c,
                                            Item_Group__r.Dimension_4__r.lookup_ID__c,Item_Group__c
                                            FROM Inventory_item__c WHERE Item_Group__c != null AND Has_BOM__c = true LIMIT 1
                                     		];
            
            if(items.size() > 0){
                
                items.get(0).Item_Type__c = 'Stock';
                items.get(0).Item_Group__c =comCode.id;
                update items;
                
                Inventory_Location__c invloc = new Inventory_Location__c(
                    Name = 'Kilimani'
                );
                insert invloc;
                
                Inventory_Item_Location__c loc = new Inventory_Item_Location__c(
                    Name = invloc.Name,
                    Location__c = invloc.Id,
                    Inventory_Item__c = items.get(0).Id,
                    Location_Name__c = '00809',
                    Max_Location_Quantity__c = 100
                );
                insert loc;
                
                Item_Location_Lot__c lot2 = new Item_Location_Lot__c();
                lot2.Lot_Name__c = 'Lot 19';
                lot2.Quantity__c = 909;
                lot2.Item_Location__c = loc.Id;
                
                insert lot2;
                
                lot2.Quantity__c = 999;
                update lot2;
                
                Inventory_Transaction__c fromtrans = new Inventory_Transaction__c();
                
                fromtrans.Item__c = items.get(0).Id;
                fromtrans.Location__c = loc.Id;
                fromtrans.Quantity_Impact__c = 'D';
                fromtrans.Transaction_ID__c = 'INVLOCADJ';
                fromtrans.Transaction_Quantity__c = 5;            
                fromtrans.Location_Lot__c = lot2.Id;
                fromtrans.Item_Unit_Price__c = items.get(0).unit_cost__c;
                fromtrans.Debit_Account__c = gla.Lookup_Id__c;
                fromtrans.Credit_Account__c = gla.Lookup_Id__c;
                fromtrans.Dimension_1__c = items.get(0).Item_Group__r.Dimension_1__r.lookup_ID__c;
                fromtrans.Dimension_2__c = items.get(0).Item_Group__r.Dimension_2__r.lookup_ID__c;
                fromtrans.Dimension_3__c = items.get(0).Item_Group__r.Dimension_3__r.lookup_ID__c;
                fromtrans.Dimension_4__c = items.get(0).Item_Group__r.Dimension_4__r.lookup_ID__c;
                fromtrans.Comments__c = 'INVLOCADJ';
                fromtrans.Item_Unit_Price__c = 15;
            
                System.debug('Credit gla id: '+gla.Lookup_Id__c);
                System.debug('Debit gla id: '+gla.Lookup_Id__c);
                
                insert fromtrans;
                Inventory_Transaction__c romtrans = new Inventory_Transaction__c();
                
                romtrans.Item__c = items.get(0).Id;
                romtrans.Location__c = loc.Id;
                romtrans.Quantity_Impact__c = 'I';
                romtrans.Transaction_ID__c = 'INVLOCADJ';
                romtrans.Transaction_Quantity__c = 5;            
                romtrans.Location_Lot__c = lot2.Id;
                romtrans.Item_Unit_Price__c = items.get(0).unit_cost__c;
                romtrans.Debit_Account__c = gla.Lookup_Id__c;
                romtrans.Credit_Account__c = gla.Lookup_Id__c;
                romtrans.Dimension_1__c = items.get(0).Item_Group__r.Dimension_1__r.lookup_ID__c;
                romtrans.Dimension_2__c = items.get(0).Item_Group__r.Dimension_2__r.lookup_ID__c;
                romtrans.Dimension_3__c = items.get(0).Item_Group__r.Dimension_3__r.lookup_ID__c;
                romtrans.Dimension_4__c = items.get(0).Item_Group__r.Dimension_4__r.lookup_ID__c;
                romtrans.Comments__c = 'INVLOCADJ';
                romtrans.Item_Unit_Price__c = 15;
            
                insert romtrans;
            } 
        }
    }
}