@isTest(seeAllData = true)
public class LocationAddControllerTest{
     static testMethod void LocationAddControllerTest(){
      
        //Get a user with FFA access, run test as that user
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        
        if(u.size() > 0){
            System.runAs(u.get(0)){
            
            //Get Company - Prefarably Sanergy
            List<FFA_Config_Object__c> company = [SELECT Name,Id,Type__c FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'company' AND isActive__c = true 
                                                 AND Name = 'Sanergy Limited' LIMIT 1];
            
            //Get a department (dim 1)
            List<FFA_Config_Object__c> dim1= [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                     WHERE Type__c = 'dim1' AND isActive__c = true LIMIT 1];
             //Get DIm 2                                   
            List<FFA_Config_Object__c> dim2 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                               WHERE Type__c = 'dim2' AND isActive__c = true  LIMIT 1];                                         
            //Get Dim 3
            List<FFA_Config_Object__c> dim3 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                               WHERE Type__c = 'dim3' AND isActive__c = true  LIMIT 1];
                                               
            //Get Dim 4
            List<FFA_Config_Object__c> dim4 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                               WHERE Type__c = 'dim4' AND isActive__c = true LIMIT 1];
                                               
            //Get a GLA
            List<FFA_Config_Object__c> gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                              WHERE Type__c = 'gla' AND isActive__c = true LIMIT 1];
              
                                                                                    
            //Create UoM
            Inventory_UoM__c uom = new Inventory_UoM__c();
            uom.Uom_Code__c = 'Each1';
            uom.Name = 'Each1';
            uom.Description__c = 'Each1';
            insert uom;
            
            //Create Site
            Inventory_Location__c site = new Inventory_Location__c();
            site.Name = 'Test Mukuru Site';
            insert site;
            
            //Create Commodity Code  
            Inventory_Item_Group__c comCode = new Inventory_Item_Group__c();  
            comCode.Name = 'test code';
            comCode.Dimension_1__c = dim1.get(0).Id;
            comCode.Dimension_2__c = dim2.get(0).Id;
            comCode.Dimension_3__c = dim3.get(0).Id;
            comCode.Dimension_4__c = dim4.get(0).Id;
            comCode.Description__c = 'Test Desc';
            comCode.Commodity_Code__c = 'Test Desc';
            insert comCode;
             
            //Create Currency record           
            Currency_Config__c curr = new Currency_Config__c();
            curr.Currency_Name__c = 'Kenyan Shilling';
            curr.Name = 'KES';
            curr.Value__c = 1;
            curr.start__c = date.today();
            curr.Current__c = true;
            insert curr;
            
            //Create Inventory Item
            Inventory_Item__c item = new Inventory_Item__c();
            item.Item_Description__c = 'Test Item';
            item.Currency_Config__c = curr.Id;
            item.Name = 'Test Item';
            item.Item_Number__c = '123456';
            item.Responsible_Department__c = dim1.get(0).Id;
            item.Policy_Quantity__c = 10;
            item.Item_Group__c = comCode.Id;
            item.Inventory_UoM__c = uom.Id;
            item.unit_cost__c = 100;
            item.Item_Company__c = company.get(0).Id;
            item.Default_Site__c = site.Id;
            item.Default_Location__c = '1';
            item.Default_Lot__c = '1';                                            
            insert Item;               
               
            //Create a location for the item
            Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
                  Name = site.Name,
                  Location_Name__c = 'testLocNumber',
                  Location__c = site.Id,
                  Inventory_Item__c = item.Id,
                  Max_Location_Quantity__c = 100
            );    
            insert itmloc;
            
            //Create a lot for the item location                
            Item_Location_Lot__c itmlot = new Item_Location_Lot__c();
            itmlot.Lot_Name__c = 'test';
            itmlot.Quantity__c = 10;
            itmlot.Item_Location__c = itmloc.Id;    
            insert itmlot;
            
            //------Create Group Details-CYCLECNT--------------------//
            Group_Details__c CYCLECNT_Debit= new Group_Details__c();
            CYCLECNT_Debit.Config_Account__c = gla.get(0).Id;
            CYCLECNT_Debit.Credit_Debit__c = 'Debit';
            CYCLECNT_Debit.Inventory_Item_Group__c = comCode.Id;
            CYCLECNT_Debit.Transaction_ID__c = 'CYCLECNT';
            CYCLECNT_Debit.Is_GL_Account__c = true;            
            Insert CYCLECNT_Debit;
            
            Group_Details__c CYCLECNT_Credit= new Group_Details__c();
            CYCLECNT_Credit.Config_Account__c = gla.get(0).Id;
            CYCLECNT_Credit.Credit_Debit__c = 'Credit';
            CYCLECNT_Credit.Inventory_Item_Group__c = comCode.Id;
            CYCLECNT_Credit.Transaction_ID__c = 'CYCLECNT';
            CYCLECNT_Credit.Is_GL_Account__c = true;
            insert CYCLECNT_Credit;
            //-------------------------------------------------------//
            
             //------Create Group Details-INVLOCSCRP--------------------//
            Group_Details__c INVLOCSCRP_Debit= new Group_Details__c();
            INVLOCSCRP_Debit.Config_Account__c = gla.get(0).Id;
            INVLOCSCRP_Debit.Credit_Debit__c = 'Debit';
            INVLOCSCRP_Debit.Inventory_Item_Group__c = comCode.Id;
            INVLOCSCRP_Debit.Transaction_ID__c = 'INVLOCSCRP';
            INVLOCSCRP_Debit.Is_GL_Account__c = true;            
            Insert INVLOCSCRP_Debit;
            
            Group_Details__c INVLOCSCRP_Credit= new Group_Details__c();
            INVLOCSCRP_Credit.Config_Account__c = gla.get(0).Id;
            INVLOCSCRP_Credit.Credit_Debit__c = 'Credit';
            INVLOCSCRP_Credit.Inventory_Item_Group__c = comCode.Id;
            INVLOCSCRP_Credit.Transaction_ID__c = 'INVLOCSCRP';
            INVLOCSCRP_Credit.Is_GL_Account__c = true;
            insert INVLOCSCRP_Credit;
            //-------------------------------------------------------//
            
             //------Create Group Details-INVLOCADD--------------------//
            Group_Details__c INVLOCADD_Debit= new Group_Details__c();
            INVLOCADD_Debit.Config_Account__c = gla.get(0).Id;
            INVLOCADD_Debit.Credit_Debit__c = 'Debit';
            INVLOCADD_Debit.Inventory_Item_Group__c = comCode.Id;
            INVLOCADD_Debit.Transaction_ID__c = 'INVLOCADD';
            INVLOCADD_Debit.Is_GL_Account__c = true;            
            Insert INVLOCADD_Debit;
            
            Group_Details__c INVLOCADD_Credit= new Group_Details__c();
            INVLOCADD_Credit.Config_Account__c = gla.get(0).Id;
            INVLOCADD_Credit.Credit_Debit__c = 'Credit';
            INVLOCADD_Credit.Inventory_Item_Group__c = comCode.Id;
            INVLOCADD_Credit.Transaction_ID__c = 'INVLOCADD';
            INVLOCADD_Credit.Is_GL_Account__c = true;
            insert INVLOCADD_Credit;
            //-------------------------------------------------------//
            
             //------Create Group Details-INVLOCADJ--------------------//
            Group_Details__c INVLOCADJ_Debit= new Group_Details__c();
            INVLOCADJ_Debit.Config_Account__c = gla.get(0).Id;
            INVLOCADJ_Debit.Credit_Debit__c = 'Debit';
            INVLOCADJ_Debit.Inventory_Item_Group__c = comCode.Id;
            INVLOCADJ_Debit.Transaction_ID__c = 'INVLOCADJ';
            INVLOCADJ_Debit.Is_GL_Account__c = true;            
            Insert INVLOCADJ_Debit;
            
            Group_Details__c INVLOCADJ_Credit= new Group_Details__c();
            INVLOCADJ_Credit.Config_Account__c = gla.get(0).Id;
            INVLOCADJ_Credit.Credit_Debit__c = 'Credit';
            INVLOCADJ_Credit.Inventory_Item_Group__c = comCode.Id;
            INVLOCADJ_Credit.Transaction_ID__c = 'INVLOCADJ';
            INVLOCADJ_Credit.Is_GL_Account__c = true;
            insert INVLOCADJ_Credit;
            //-------------------------------------------------------//
           
            test.startTest();
            PageReference pageRef = Page.Perform_Inventory_Adjust;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(item);
            LocationAddController controller = new LocationAddController(sc);
           
            //Test Controller methods
            //Add new Location
            Test.setCurrentPage(controller.pageNewLocation());
            controller.location.Name = site.Name;
            controller.location.Location_Name__c = 'testLocNumber2';
            controller.location.Location__c = site.Id;
            controller.location.Inventory_Item__c = item.Id;
            controller.location.Max_Location_Quantity__c = 200;
           
            //populate a lot
            controller.lots.get(0).lots.Lot_Name__c = 'test2';
            controller.lots.get(0).lots.Quantity__c = 10;
            
            //Add new lot line
            controller.addLotLine();
            
            //Populate new lot line
            controller.lots.get(1).lots.Lot_Name__c = 'test3';
            controller.lots.get(1).lots.Quantity__c = 10;
            controller.lots.get(1).getNewQuantity();
            
            //Remove a lot line
            ApexPages.currentPage().getParameters().put('removeLotIndex', '0');
            controller.removeLot();
            
            //Save new location
            Test.setCurrentPage(controller.saveNewLocation());
            
            //Perform lot add
            ApexPages.currentPage().getParameters().put('locId', '0');
            Test.setCurrentPage(controller.pageNewLots());
            
             //populate a lot
            controller.lots.get(0).lots.Lot_Name__c = 'test4';
            controller.lots.get(0).lots.Quantity__c = 10;
            
            //Save new lot
            Test.setCurrentPage(controller.saveNewLots());
            
            //Update Location
            Test.setCurrentPage(controller.pageItemAdjust());
            
             //Update Location
            Test.setCurrentPage(controller.pageUpdateQuantities());
            
            controller.resetPageUpdate();
            
            //set adjust values
            controller.wrapper.get(0).lots.get(0).lots.Adjust_Quantity__c = 3;
            controller.wrapper.get(0).lots.get(0).selectedAction = 'I';
            controller.wrapper.get(0).lots.get(0).getNewQuantity();
            
            controller.wrapper.get(1).lots.get(0).lots.Adjust_Quantity__c = 3;
            controller.wrapper.get(1).lots.get(0).selectedAction = 'S';
            
            controller.wrapper.get(1).getLotSize();
            controller.wrapper.get(1).getLotsSelected();
            
            controller.performLocationAdd();
            controller.saveUpdateQuantities();
            
            test.stopTest();
        }
        
       }
        
    }
}