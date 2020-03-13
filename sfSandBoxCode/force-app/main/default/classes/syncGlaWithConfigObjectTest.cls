@isTest(seeAllData=true)
private class syncGlaWithConfigObjectTest{
     
     static testMethod void testSyncGlaWithConfigObject() {  
      
       List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
             System.runAs(userFFA.get(0)){
                 
                 //Test creation of a GLA
                 c2g__codaGeneralLedgerAccount__c gla=new c2g__codaGeneralLedgerAccount__c(
                     name='test name',
                     c2g__ReportingCode__c='test code',
                     c2g__Type__c='Balance Sheet'
                 );
                 insert  gla;
                 
                 List<FFA_Config_Object__c> ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE Name='test name'];
                 System.assert(ffaConfig.size()>0);
               
                
                 //Test update of a GLA
                 gla.name='test name changed';
                 update gla;
                 
                 ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE Name='test name changed'];
                 System.assert(ffaConfig.size()>0);
                 
                 
                 //Test delete of a GLA
                 delete gla;
                 
                 ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE Name='test name changed'];
                 System.assert(ffaConfig.size()==0);
             }
        }
        
     }
}