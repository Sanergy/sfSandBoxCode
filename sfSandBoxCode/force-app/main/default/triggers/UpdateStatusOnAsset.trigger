trigger UpdateStatusOnAsset on AssetMaintenance__c (after insert, after update) {

     for (AssetMaintenance__c maintenance : Trigger.new) {
     
         String assetId = maintenance.Asset__c;
         
         Sanergy_Asset__c asset = [SELECT ID, Asset_Name__c, Asset_Status__c FROM Sanergy_Asset__c WHERE ID = :assetId ]; 
         
         if(asset != null){
             if(Trigger.isUpdate) {
                 if(maintenance.Received_by__c != null || maintenance.Received_On__c != null){
                     asset.Asset_Status__c = 'Inventory';
                     update asset;
                 }
             } else if(Trigger.isInsert){
                 asset.Asset_Status__c = 'Out for 3rd Party Repair';
                 asset.Employee__c = null;
                 update asset;
             }
         }
    }
}