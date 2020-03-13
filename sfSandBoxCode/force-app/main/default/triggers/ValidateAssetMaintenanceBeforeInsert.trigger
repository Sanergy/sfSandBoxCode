trigger ValidateAssetMaintenanceBeforeInsert on AssetMaintenance__c (before insert) {

     for (AssetMaintenance__c maintenance : Trigger.new) {
         
         String assetId = maintenance.Asset__c;
         boolean allowSave = true;
         
         if(assetId != null && !assetId.equals('')){
         
             List<AssetMaintenance__c> maintenanceRecs = [SELECT ID, Received_by__c, Received_On__c, Status__c FROM AssetMaintenance__c WHERE Asset__c = :assetId ];
             
             if(maintenanceRecs.size() > 0){
                 
                 for(AssetMaintenance__c rec: maintenanceRecs){
                     if(rec.Received_by__c == null || rec.Received_On__c == null){
                         allowSave = false;
                     }
                 }
             }
         }
         
         if(allowSave){
             maintenance.Diagnosis__c = null;
             maintenance.Solution__c = null;
             maintenance.Cost_of_Repairs__c = null;
             maintenance.Received_by__c = null;
             maintenance.Received_On__c = null;
             maintenance.Status__c = null;
        } else {
            maintenance.addError('The asset is already out for maintenance');
        }               
    }

}