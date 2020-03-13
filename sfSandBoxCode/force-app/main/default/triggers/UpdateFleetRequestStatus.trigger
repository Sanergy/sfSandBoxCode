trigger UpdateFleetRequestStatus on Fleet_Requests__c (after update) {
    for(Fleet_Requests__c  tripLeg: Trigger.new){
        
        
        //if stage moves to trip completed
        if(tripLeg.Fleet_Request_Status__c!=null && Trigger.oldMap.get(tripLeg.id).Fleet_Request_Status__c!=null
         && tripLeg.Fleet_Request_Status__c!=Trigger.oldMap.get(tripLeg.id).Fleet_Request_Status__c
         && (tripLeg.Fleet_Request_Status__c=='Trip Completed' || tripLeg.Fleet_Request_Status__c=='Trip Cancelled')){
        
            //get count of all completed or cancelled trips
            Integer countClosedLegs=[SELECT count()
                                     FROM Fleet_Requests__c  
                                     WHERE Fleet_Request__c=:tripLeg.Fleet_Request__c
                                     AND( Fleet_Request_Status__c='Trip Completed'
                                     OR Fleet_Request_Status__c='Trip Cancelled')];
                                     
           List<Fleet_Request__c> fr=[SELECT Count_of_Legs__c,Status__c
                                      FROM Fleet_Request__c
                                      WHERE id=:tripLeg.Fleet_Request__c ];
                                      
            if(fr.size()>0 && fr.get(0).Count_of_Legs__c <= countClosedLegs){
                fr.get(0).Status__c='Request Competed';
                update fr;
            }
        }
    
    }
}