@isTest
private class TestSetAssetStatusOnInsert {
   
   @isTest
   private static void TestStatus() {
   
       Sanergy_Asset__c asset = new Sanergy_Asset__c(
           Asset_Name__c = 'Test Asset',
          Manufacturer__c='Dell',
          Make__c='Latitude',
          Model__c='E 6400',
          Operating_System__c = 'Windows',
          Active__c=true
       );
       
       insert asset;
       
       Sanergy_Asset__c savedasset = [SELECT ID, Asset_Name__c, Asset_Status__c FROM Sanergy_Asset__c WHERE ID = :asset.ID];
       
       System.assertEquals(savedasset.Asset_Status__c, 'Inventory');
       
   }
}