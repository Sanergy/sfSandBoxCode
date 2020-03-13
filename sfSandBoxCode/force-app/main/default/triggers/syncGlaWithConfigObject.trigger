trigger syncGlaWithConfigObject on c2g__codaGeneralLedgerAccount__c (after insert, after update, after delete) {
     List<c2g__codaGeneralLedgerAccount__c > glaList =Trigger.isDelete?Trigger.old:Trigger.new;
    
    for(c2g__codaGeneralLedgerAccount__c glaListRecord:glaList ){
     
      //update action
      if(Trigger.isUpdate && glaListRecord.name!=null && trigger.oldMap.get(glaListRecord.id).name!=null
         && glaListRecord.name!=trigger.oldMap.get(glaListRecord.id).name ){
          List<FFA_Config_Object__c> ffaConfig=[SELECT Name FROM FFA_Config_Object__c WHERE lookup_ID__c=:glaListRecord.id ];
          if(ffaConfig.size()>0){
              ffaConfig.get(0).Name=glaListRecord.name;
              update ffaConfig;
          }
      }
      
      //insert action
      else if(Trigger.isInsert){
          FFA_Config_Object__c ffaConfigRecord=new FFA_Config_Object__c(
              lookup_ID__c=glaListRecord.id,
              Type__c='gla',
              name=glaListRecord.name
          );
          insert ffaConfigRecord;  
      }
      
      //delete action
      else if(Trigger.isDelete){
           List<FFA_Config_Object__c> ffaConfig=[SELECT id FROM FFA_Config_Object__c WHERE lookup_ID__c=:glaListRecord.id ];
           if(ffaConfig.size()>0){
              delete ffaConfig;
          }
      }
    }
}