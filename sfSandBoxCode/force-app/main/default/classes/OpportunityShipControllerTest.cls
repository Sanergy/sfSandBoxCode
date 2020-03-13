@isTest(SeeAllData=true)

private class OpportunityShipControllerTest {
    
    static testMethod void TestOpportunityShipController() {
        //create two accounts
        Account ac=new Account(Name='Acc',CurrencyIsoCode='KES' );                        
        insert ac;
        //create Contact
        Contact con=new Contact(lastname='Onyando',Sex__c='Male');
        insert con;
        //get application management recordtype id
        List<RecordType> rt=[SELECT id FROM RecordType WHERE Name='Agricultural Product Sales - Closing'];
        
        List<Opportunity> opList=new List<Opportunity>();
        //Create two Opportunities
        
        Opportunity opp =new Opportunity(
            RecordTypeId=rt.get(0).id,
            Name='x',
            AccountId=ac.ID,
            StageName='Sale Open',
            CloseDate=Date.today(),
            Primary_Salesperson__c=con.ID
        );
        insert opp;
        
        Product2 product2 = [SELECT Id, Name, Use_Inventory__c, Inventory_Product__c,rstk__Product_rs_addprod__c
                             FROM Product2
                             WHERE Use_Inventory__c = true 
                             AND Inventory_Product__c != null 
                             LIMIT 1
                            ];
        
        Inventory_item__c item = [Select Id, Name
                                  FROM Inventory_item__c
                                  WHERE Id = :product2.Inventory_Product__c                                  
                                 ];
        item.Item_Type__c = 'Stock';
        update item;
        
        Inventory_Location__c invloc = new Inventory_Location__c(
            Name = 'Kilimani'
        );
        insert invloc;
        
        Inventory_Item_Location__c loc = new Inventory_Item_Location__c();
        loc.Name = invloc.Name;
        loc.Location__c = invloc.Id;
        loc.Location_Name__c = '18181';
        //Batch__c = batch.Id,
        loc.Inventory_Item__c = item.Id;
        //re_order_quantity__c = 5,
        //Count__c = 99
        insert loc;
        
        Item_Location_Lot__c lot2 = new Item_Location_Lot__c();
        lot2.Lot_Name__c = 'Lot 19';
        lot2.Quantity__c = 909;
        lot2.Item_Location__c = loc.Id;
        
        List<PricebookEntry> pbeList = [
            SELECT Id, Product2Id FROM PricebookEntry
            WHERE Product2Id = :product2.Id
            AND Pricebook2.isStandard=true
        ];
        
        Map<Id,Id> prodToPbe = new Map<Id,Id>();
        
        for (PricebookEntry pbEntry: pbeList) {
            prodToPbe.put(pbEntry.Product2Id, pbEntry.Id);
        }
        
        OpportunityLineItem lineItem = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId  = prodToPbe.get(product2.Id),
            Quantity = 5,
            Inventory_Item_Location__c = loc.Id,
            TotalPrice = 5555
        );
         insert lineItem;
        
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];

        System.runAs(u) {
            
            PageReference pageRef = Page.OpportunityShip;
            
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opp);
            OpportunityShipController controller = new OpportunityShipController(sc);
            
            controller.selectAll();
            controller.getProducts();
            controller.getSites();
            
            for(OpportunityShipController.ProductWrapper  thisListItem :controller.products) {
                
                thisListItem.site=invloc.Id;
                thisListItem.location= loc.Id;
                thisListItem.setLots();
                thisListItem.setLots();
                thisListItem.selectLot();
                thisListItem.setLocations();
                thisListItem.lot = lot2.Id;
                thisListItem.selectedLot = lot2;
                thisListItem.product.Quantity_Shipped__c = 1;
                thisListItem.shipQuantity = thisListItem.product.Quantity_Shipped__c;
            }
            	
            controller.selectAll();
            controller.getProducts();
            controller.getSites();
            controller.shipFromInventory();
            //controller.unselectAll();
            
            for(OpportunityShipController.ProductWrapper  thisListItem :controller.products) {
                thisListItem.site=null;
                thisListItem.location= null;
                thisListItem.lot = null;
                thisListItem.selectedLot = null;
                
                thisListItem.setLots();
                thisListItem.setLots();
                thisListItem.selectLot();
                thisListItem.setLocations();
            }
            
            controller.shipFromInventory();
            controller.unselectAll();
        }
    }
}