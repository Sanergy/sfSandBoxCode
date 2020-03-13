trigger FleetTeamLeadTrigger on Fleet_Request__c (before insert, before update) {
    for(Fleet_Request__c f:Trigger.new){
          List<FFA_Config_Object__c> RDTl= [SELECT ID,Name,Teamlead__c,Teamlead__r.Team_Lead__c,Delegated_Fleet_Approver__r.Team_Lead__c, Delegated_Fleet_Approver__c, Delegate_s_Threshold_Amount_fleet__c FROM FFA_Config_Object__c 
                                           WHERE Id=:f.Requesting_Department__c];
         
         if(RDTl.size()>0){
             //insert trigger                               
             if(Trigger.isInsert){
                   //check if Director made the request, in which case, Sanj approves
                   if((f.ownerId=='005D0000001qyr7' || 
                       f.ownerId=='005D0000001rH3B' || 
                       f.ownerId=='005D0000001qz2K' ) &&
                       RDTl.get(0).name=='Directors'){
                           f.Team_Lead__c=RDTL.get(0).Teamlead__r.Team_Lead__c;
                   
                   }
                   
                   //if Tealead is the creator
                   else if(RDTL.get(0).Teamlead__c!=null && RDTL.get(0).Teamlead__c==f.OwnerId){
                       f.Team_Lead__c=RDTL.get(0).Teamlead__r.Team_Lead__c;
                   }
                   
                   //if delegate approver is the creator
                   else if(RDTL.get(0).Delegated_Fleet_Approver__c!=null && RDTL.get(0).Delegated_Fleet_Approver__c==f.OwnerId){
                       f.Team_Lead__c=RDTL.get(0).Delegated_Fleet_Approver__r.Team_Lead__c;
                   }
                   else{
                        f.Team_Lead__c=RDTL.get(0).Delegated_Fleet_Approver__c ;      
                   }
                   
             }
             
             //update trigger
             else if(Trigger.isUpdate){
                 if(f.Requesting_Department__c!=null && f.Requesting_Department__c!=Trigger.oldMap.get(f.id).Requesting_Department__c){
                      //if director
                      if((f.ownerId=='005D0000001qyr7' || 
                       f.ownerId=='005D0000001rH3B' || 
                       f.ownerId=='005D0000001qz2K' ) &&
                       RDTl.get(0).name=='Directors'){
                           f.Team_Lead__c=RDTL.get(0).Teamlead__r.Team_Lead__c;
                     }
                     
                     //if teamlead
                     else if(RDTL.get(0).Teamlead__c!=null && RDTL.get(0).Teamlead__c==f.OwnerId){
                       f.Team_Lead__c=RDTL.get(0).Teamlead__r.Team_Lead__c;
                     }
                     
                      //if delegate approver is the creator
                       else if(RDTL.get(0).Delegated_Fleet_Approver__c!=null && RDTL.get(0).Delegated_Fleet_Approver__c==f.OwnerId){
                           f.Team_Lead__c=RDTL.get(0).Delegated_Fleet_Approver__r.Team_Lead__c;
                       }
                     
                     //if ordinary user
                     
                     else if(f.Total_Request_Cost__c > RDTl.get(0).Delegate_s_Threshold_Amount_fleet__c  ){
                         f.Team_Lead__c=RDTL.get(0).Teamlead__c;
                     }
                     
                     else{
                         f.Team_Lead__c=RDTL.get(0).Delegated_Fleet_Approver__c;
                     }
                 
                 }
             }                             
         }    
    }

}