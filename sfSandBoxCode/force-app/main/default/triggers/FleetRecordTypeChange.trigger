trigger FleetRecordTypeChange on Fleet_Request__c (before update) {
    for(Fleet_Request__c fl:Trigger.new){
        
        if(Trigger.oldMap.get(fl.id).Status__c!=null && fl.status__c!=null
            && fl.Status__c!=Trigger.oldMap.get(fl.id).Status__c && fl.Status__c=='Team Lead Approved'){
        
            LIST<Fleet_Requests__c> fr=[SELECT ID 
                                    FROM Fleet_Requests__c 
                                    WHERE Fleet_Request__c=:fl.id];
                                    
            List<RecordType> rt=[SELECT ID FROM RecordType WHERE name='Fleet Request-After Approval'];
            if(rt.size()>0){
                
                for(Fleet_Requests__c flr:fr){
                    flr.recordTypeId=rt.get(0).Id;
                    update flr;
                }
            }
            
        }
    }

}