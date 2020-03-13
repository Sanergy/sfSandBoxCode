@isTest(seeAllData = true)
public class UnitsAndDateValidationTest {
    
    static testMethod void testUnitsAndDateValidationTest(){
        Sanergy_Asset__c sanAsset = new Sanergy_Asset__c();
        Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
        Asset_Usage_Reading__c usage1 = new Asset_Usage_Reading__c();
        
        sanAsset.Asset_Name__c = 'Laptop'; 
        sanAsset.Manufacturer__c = 'Dell';
        sanAsset.Make__c = 'Dell';
        sanAsset.Model__c = 'Latitude e6430';
        sanAsset.Operating_System__c = 'Ubuntu';
        sanAsset.Active__c = true;
        
        insert sanAsset;
        
        System.debug('asset ---->>>>>>' + sanAsset);
        
        usage.Sanergy_Asset__c = sanAsset.Id;
        usage.Current_Reading__c = true;
        usage.Actual_Units__c = 10;
        usage.Date__c = date.today()-3;
        
        System.debug('test date  ' +  usage.Date__c );
        
        insert usage;
        
        System.debug('usage ---->>>>>>' + usage);
 /**       
        usage1.Sanergy_Asset__c = sanAsset.Id;
        usage1.Current_Reading__c = true;
        usage1.Actual_Units__c = 9;
        usage1.Date__c = date.today();
        
        System.debug('test date1  ' +  usage1.Date__c );
        
        insert usage1;
**/
    }
    
}