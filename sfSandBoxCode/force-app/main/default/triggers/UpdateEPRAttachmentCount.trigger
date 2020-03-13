trigger UpdateEPRAttachmentCount on Attachment (before insert, after delete) {
    
    List<Attachment> attList=trigger.isDelete? Trigger.old: Trigger.new;
    
    for(Attachment att:attList){
        Id idToProcess=att.ParentId;
        Schema.sObjectType entityType = idToProcess.getSObjectType();
        if(entityType!=null && entityType==Electronic_Payment_Request__c.sObjectType){
           List<Electronic_Payment_Request__c> epr=[SELECT attachment_count__c FROM Electronic_Payment_Request__c
                                                   WHERE ID=:idToProcess];
           
            if(epr.size()>0){
                if(trigger.isInsert){
                    if(epr.get(0).attachment_count__c==null){
                       epr.get(0).attachment_count__c=0; 
                    }
                	epr.get(0).attachment_count__c++;
                    update epr;
                }
                else if(trigger.isDelete){
                    if(epr.get(0).attachment_count__c==null || epr.get(0).attachment_count__c<1 ){
                       epr.get(0).attachment_count__c=0; 
                    }
                    else{
                        epr.get(0).attachment_count__c--;
                        update epr;
                    }  
                }   
            }   
        }
    }
}