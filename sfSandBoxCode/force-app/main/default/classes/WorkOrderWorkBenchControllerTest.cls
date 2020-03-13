@isTest(seeAllData=true)
public class WorkOrderWorkBenchControllerTest{
    
    static testMethod void WorkOrderWorkBenchControllerTest(){
        List<Inventory_item__c> items = [Select Id,Policy_Quantity__c,Default_Site__c,Item_Company__c
                                         FROM Inventory_item__c
                                         WHERE Item_Group__c != null 
                                         AND Has_BOM__c = true 
                                         AND Item_Source__c = 'Manufactured'
                                         AND Policy_Quantity__c!=null
                                         LIMIT 1
                                        ];
        
        if(items.size() > 0){
            List<RecordType> manufactureRecordType = [SELECT id FROM RecordType
                                                      WHERE Name = 'Work Order Replenishment'
                                                      AND SObjectType = 'Inventory_Replenishment_Tracker__c'];
            
            Work_Order__c wo = new Work_Order__c(
                Inventory_Item__c = items.get(0).id,
                Inventory_Item_Quantity__c = items.get(0).Policy_Quantity__c,
                Site__c = items.get(0).Default_Site__c,
                Company__c = items.get(0).Item_Company__c,
                Work_Order_Type__c = 'WO-Manufactured',
                Status__c = 'Planned'
            );
            insert wo;
            
            Inventory_Replenishment_Tracker__c tracker = new Inventory_Replenishment_Tracker__c(
                recordTypeId = manufactureRecordType.get(0).id,
                Inventory_Item__c = wo.Inventory_Item__c,
                Work_Order__c = wo.id,
                Quantity_Pending__c = wo.Inventory_Item_Quantity__c 
            );
            
            insert tracker;
            
            //Create controller
            WorkOrderWorkBenchController woWorkBnchCtrl = new WorkOrderWorkBenchController();
            
            woWorkBnchCtrl.getStatuses();
            woWorkBnchCtrl.selectedStatus = 'Planned';
            woWorkBnchCtrl.refreshList();
            woWorkBnchCtrl.rList.get(0).selected = true;
            woWorkBnchCtrl.firmRequests();
            
            woWorkBnchCtrl.selectedStatus = 'Firmed';
            woWorkBnchCtrl.refreshList();
            woWorkBnchCtrl.rList.get(0).selected = true;
            woWorkBnchCtrl.cancelRequests();    
        }
    }
}