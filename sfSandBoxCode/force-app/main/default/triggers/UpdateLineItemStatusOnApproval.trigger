trigger UpdateLineItemStatusOnApproval on Procurement_Tracking_Sheet__c (after update) {
    
    //if stage changes to Team Lead Approved, update statuses of line items
    /*
    for(Procurement_Tracking_Sheet__c  pts:Trigger.new){
        if(pts.Stage__c!=null && pts.Stage__c!= Trigger.oldMap.get(pts.id).Stage__c && pts.Stage__c=='Team Lead Approved'){
            
            //Select line items
            List<PTS_Line_Item__c> ptsLine=[SELECT Status__c,Item_Type__c
                                            FROM PTS_Line_Item__c WHERE
                                            Procurement_Tracking_Sheet__c=:pts.id ];
                                            
           if(ptsLine.size()>0){
               for(PTS_Line_Item__c line:ptsLine){
                   if(line.Item_Type__c=='Service' || line.Item_Type__c=='One-off'){
                       line.Status__c='Pending Sourcing';
                   }
                   else if(line.Item_Type__c=='Stock'){
                       line.Status__c='Pending Purchase Order';
                   }
               }
               
               update ptsLine;
           }  
        }
    }
*/
}