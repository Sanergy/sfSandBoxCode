trigger FleetRequestTrigger on Fleet_Requests__c (before insert, before update, before delete) {

  if(Trigger.isInsert){
    for(Fleet_Requests__c  leg:Trigger.new){
    
        Fleet_Request__c fr=[SELECT OwnerId, Requesting_Department__c, Team_Lead__c, Total_Request_Cost__c  
                                           FROM Fleet_Request__c 
                                           WHERE ID=:leg.Fleet_Request__c];
        
        //update the approver on the EPR based on threshold amount
        List<FFA_Config_Object__c> department=[SELECT Teamlead__c, name, Delegated_Fleet_Approver__c, Delegate_s_Threshold_Amount_fleet__c
                                               FROM FFA_Config_Object__c
                                               WHERE ID=:fr.Requesting_Department__c];
    
     //check user is not Directors
       if((fr.ownerId=='005D0000001qyr7' || 
           fr.ownerId=='005D0000001rH3B' || 
           fr.ownerId=='005D0000001qz2K' ) &&
           department.get(0).name=='Directors'){} 
           
        //check user is not delegate or TL
        else if(fr.OwnerId != department.get(0).Teamlead__c && fr.OwnerId != department.get(0).Delegated_Fleet_Approver__c ){
            if(department.get(0).Delegate_s_Threshold_Amount_fleet__c!=null && leg.Total_Estimated_Cost__c!=null  && (fr.Total_Request_Cost__c+leg.Total_Estimated_Cost__c) > department.get(0).Delegate_s_Threshold_Amount_fleet__c ){
                 fr.Team_Lead__c=department.get(0).Teamlead__c;
                 update fr;
            }
        }         
    }
   }
   
   else if(Trigger.isUpdate){
   for(Fleet_Requests__c  leg:Trigger.new){
   
     if(leg.Total_Estimated_Cost__c !=null && leg.Total_Estimated_Cost__c != Trigger.oldMap.get(leg.id).Total_Estimated_Cost__c){
     
    
      Fleet_Request__c fr=[SELECT OwnerId, Requesting_Department__c, Team_Lead__c, Total_Request_Cost__c 
                                           FROM Fleet_Request__c 
                                           WHERE ID=:leg.Fleet_Request__c];
        
        //update the approver on the EPR based on threshold amount
        List<FFA_Config_Object__c> department=[SELECT Teamlead__c, name, Delegated_Fleet_Approver__c, Delegate_s_Threshold_Amount_fleet__c
                                               FROM FFA_Config_Object__c
                                               WHERE ID=:fr.Requesting_Department__c];
           //check for Directors
           if((fr.ownerId=='005D0000001qyr7' || 
               fr.ownerId=='005D0000001rH3B' || 
               fr.ownerId=='005D0000001qz2K' ) &&
               department.get(0).name=='Directors'){}
             
           else if(fr.OwnerId != department.get(0).Teamlead__c  && fr.OwnerId != department.get(0).Delegated_Fleet_Approver__c){
                if(department.get(0).Delegate_s_Threshold_Amount_fleet__c!=null){ 
                
                Decimal formervalue=Trigger.oldMap.get(leg.id).Total_Estimated_Cost__c==null? 0: Trigger.oldMap.get(leg.id).Total_Estimated_Cost__c;
                
                //Difference in edit
                Decimal diff = (leg.Total_Estimated_Cost__c-formervalue);
                 if(fr.Total_Request_Cost__c + diff > department.get(0).Delegate_s_Threshold_Amount_fleet__c){
                    fr.Team_Lead__c=department.get(0).Teamlead__c;
                    
                 }   
                 else{
                    fr.Team_Lead__c=department.get(0).Delegated_Fleet_Approver__c;
                    
                 } 
                 update fr;
                }
            }    
       }     
      }
   }
   
   else if(Trigger.isDelete){
       for(Fleet_Requests__c leg:Trigger.old){
    
        Fleet_Request__c fr=[SELECT OwnerId, Requesting_Department__c, Team_Lead__c, Total_Request_Cost__c  
                                           FROM Fleet_Request__c 
                                           WHERE ID=:leg.Fleet_Request__c];
                                           
        
        //update the approver on the EPR based on threshold amount
        List<FFA_Config_Object__c> department=[SELECT Teamlead__c, name, Delegated_Fleet_Approver__c, Delegate_s_Threshold_Amount_fleet__c
                                               FROM FFA_Config_Object__c
                                               WHERE ID=:fr.Requesting_Department__c];
         
         
         
            //check for Directors
           if((fr.ownerId=='005D0000001qyr7' || 
               fr.ownerId=='005D0000001rH3B' || 
               fr.ownerId=='005D0000001qz2K' ) &&
               department.get(0).name=='Directors'){}
          else if(fr.OwnerId != department.get(0).Teamlead__c && fr.OwnerId != department.get(0).Delegated_Fleet_Approver__c ){
            if(department.get(0).Delegate_s_Threshold_Amount_fleet__c!=null && leg.Total_Estimated_Cost__c!=null && (fr.Total_Request_Cost__c-leg.Total_Estimated_Cost__c) <= department.get(0).Delegate_s_Threshold_Amount_fleet__c ){
                 fr.Team_Lead__c=department.get(0).Delegated_Fleet_Approver__c;
                 update fr;
            } 
        }
     }
   }
}