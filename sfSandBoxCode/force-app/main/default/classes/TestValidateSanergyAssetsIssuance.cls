@isTest
public class TestValidateSanergyAssetsIssuance {
    
    static TestMethod void testInsertAssetIssuance(){
        
        Sanergy_Asset__c asset = new Sanergy_Asset__c(Asset_Name__c='Test Asset', Manufacturer__c='Dell', Make__c='Latitude',
                                                      Model__c='E 6400', Operating_System__c = 'Windows',Active__c=true);
        
        insert asset;
        
        Sanergy_Assets_Issuance__c issuance = new Sanergy_Assets_Issuance__c(Asset_ID__c=asset.Id);
        
    }

}