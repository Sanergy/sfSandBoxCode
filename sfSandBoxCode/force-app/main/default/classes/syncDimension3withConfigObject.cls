@isTest(seeAllData=true)
private class syncDimension3withConfigObject{
     
     static testMethod void testsyncDimension3withConfigObject() {  
      
       List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
             System.runAs(userFFA.get(0)){
                 
                 //Test creation of a DIM
                 c2g__codaDimension3__c dim=new c2g__codaDimension3__c(
                     name='test name',
                     c2g__ReportingCode__c='test code'
                 );
                 insert  dim;
                 
                 List<FFA_Config_Object__c> ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE Name='test name'];
                 System.assert(ffaConfig.size()>0);
               
                
                 //Test update of a DIM
                 dim.name='test name changed';
                 update dim;
                 
                 ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE Name='test name changed'];
                 System.assert(ffaConfig.size()>0);
                 
                 
                 //Test delete of a DIM
                 delete dim;
                 
                 ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE Name='test name changed'];
                 System.assert(ffaConfig.size()==0);
             }
        }
        
     }
}