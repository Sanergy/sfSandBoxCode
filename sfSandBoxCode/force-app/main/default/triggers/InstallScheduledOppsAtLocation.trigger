trigger InstallScheduledOppsAtLocation on Opportunity (after delete, after insert, after undelete, 
after update) {
    
Set<id> locIds = new Set<id>();
    List<Location__c> locsToUpdate = new List<Location__c>();
 
   if (Trigger.isUpdate || Trigger.isInsert || Trigger.isUndelete) {
      for (Opportunity item : Trigger.new)
          locIds.add(item.Location__c);
      }
    
    
    if ( Trigger.isUpdate || Trigger.isDelete) { 
        for (Opportunity item : Trigger.old)
            locIds.add(item.Location__c);
    }
    
    
    // get a List of the locations with the number of opps in install sched stage
    List<Location__c> locList = [select id, InstallSched__c from Location__c where id IN :locIds];
    
    List<Opportunity> oppList = [select Id, Location__c from Opportunity where Location__c IN :locIds and StageName = 'Installation Scheduled'] ;
    
   
    
    for ( Location__c uploc : locList ){
      
        Integer size = 0;
         
          for ( Opportunity opp: oppList ){
            
            if (opp.Location__c == uploc.Id)size++;
            
          }
           
      uploc.InstallSched__c = size;
      
      locsToUpdate.add(uploc);
    }
    
     update locsToUpdate;
    
}