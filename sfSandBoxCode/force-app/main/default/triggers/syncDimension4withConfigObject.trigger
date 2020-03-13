trigger syncDimension4withConfigObject on c2g__codaDimension4__c (after update, after insert, after delete) {
    
    List<c2g__codaDimension4__c > dimList =Trigger.isDelete?Trigger.old:Trigger.new;
    
    for(c2g__codaDimension4__c  dimListRecord:dimList ){
     
     //update action
      if(Trigger.isUpdate){
          List<FFA_Config_Object__c> ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE lookup_ID__c=:dimListRecord.id ];
          if(ffaConfig.size()>0){
              ffaConfig.get(0).Name=dimListRecord.name;
              update ffaConfig;
          }
      }
      
      //insert action
      else if(Trigger.isInsert){
          FFA_Config_Object__c ffaConfigRecord=new FFA_Config_Object__c(
              lookup_ID__c=dimListRecord.id,
              Type__c='dim4',
              name=dimListRecord.name
          );
          insert ffaConfigRecord;  
      }
      
      //delete action
      else if(Trigger.isDelete){
           List<FFA_Config_Object__c> ffaConfig=[SELECT id FROM FFA_Config_Object__c WHERE lookup_ID__c=:dimListRecord.id ];
           if(ffaConfig.size()>0){
              delete ffaConfig;
          }
      }
    }
}