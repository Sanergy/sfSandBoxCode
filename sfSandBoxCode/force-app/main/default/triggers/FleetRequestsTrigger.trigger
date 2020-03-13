trigger FleetRequestsTrigger on Fleet_Request__c (after update) {
    for(Fleet_Request__c  fr: Trigger.new){
    
        Map<String, String> statusMapping=new Map<String, String>();
        statusMapping.put('Open', 'Request Open');
        statusMapping.put('Pending Quote', 'Quote in Progress');
        statusMapping.put('Pending Team Lead Approval', 'Pending TL Approval');
        statusMapping.put('Team Lead Approved', 'TL Approved');
    
        //if Stage moves to Pending Quote
        if(fr.Status__c!=null && Trigger.oldMap.get(fr.id).Status__c!=null
           && fr.Status__c!=Trigger.oldMap.get(fr.id).Status__c
           && statusMapping.get(fr.Status__c)!=null){
           
           List<Fleet_Requests__c> tripLegs=[SELECT Fleet_Request_Status__c
                                          FROM Fleet_Requests__c
                                          WHERE Fleet_Request__c=:fr.id];
                                          
             if(tripLegs.size()>0){
                 for(Fleet_Requests__c leg:tripLegs){
                     leg.Fleet_Request_Status__c=statusMapping.get(fr.Status__c);
                 }
                 update tripLegs;
             }
        }
    }
}