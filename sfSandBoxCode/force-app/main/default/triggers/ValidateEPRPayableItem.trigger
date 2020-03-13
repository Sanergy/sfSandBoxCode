trigger ValidateEPRPayableItem on EPR_Payable_Item__c (before insert, before update, before delete) {
   
   if(Trigger.isInsert){
    for(EPR_Payable_Item__c EPI:Trigger.new){
    
        Electronic_Payment_Request__c EPR=[SELECT OwnerId, Team_Lead_Approval_Status__c,Gross_Payment_Amount__c, Approving_Teamlead__c,department__c, department__r.Delegated_approver__c, department__r.Delegate_s_Threshold_Amount__c, department__r.Teamlead__c  
                                           FROM Electronic_Payment_Request__c
                                           WHERE ID=:EPI.EPR__c];
                                           
        if(EPR.Team_Lead_Approval_Status__c!=null && EPR.Team_Lead_Approval_Status__c=='Approved'){
            EPI.addError('A new EPR payable item cannot be added to this EPR. This EPR has been approved by the Team Lead');
        }
        
        
        //update the approver on the EPR based on threshold amount
        List<FFA_Config_Object__c> department=[SELECT Teamlead__c, name, Delegated_approver__c, Delegate_s_Threshold_Amount__c
                                               FROM FFA_Config_Object__c
                                               WHERE ID=:EPR.department__c];
    
     //check for Directors
       if((EPR.ownerId=='005D0000001qyr7' || 
           EPR.ownerId=='005D0000001rH3B' || 
           EPR.ownerId=='005D0000001qz2K' ) &&
           department.get(0).name=='Directors'){} 
        else if(EPR.OwnerId != department.get(0).Teamlead__c){
            if(EPR.department__r.Delegate_s_Threshold_Amount__c!=null && (EPR.Gross_Payment_Amount__c+EPI.Gross_price__c) > EPR.department__r.Delegate_s_Threshold_Amount__c ){
                 EPR.Approving_Teamlead__c=EPR.department__r.Teamlead__c;
                 update EPR;
            }
        }                                      
        
        
        
        
    }
   }
   
   else if(Trigger.isUpdate){
   for(EPR_Payable_Item__c EPI:Trigger.new){
      Electronic_Payment_Request__c EPR=[SELECT OwnerId, Team_Lead_Approval_Status__c,Gross_Payment_Amount__c, Approving_Teamlead__c,department__c, department__r.Delegated_approver__c, department__r.Delegate_s_Threshold_Amount__c, department__r.Teamlead__c  
                                           FROM Electronic_Payment_Request__c
                                           WHERE ID=:EPI.EPR__c];
        
        //update the approver on the EPR based on threshold amount
        List<FFA_Config_Object__c> department=[SELECT Teamlead__c, name, Delegated_approver__c, Delegate_s_Threshold_Amount__c
                                               FROM FFA_Config_Object__c
                                               WHERE ID=:EPR.department__c];
           //check for Directors
           if((EPR.ownerId=='005D0000001qyr7' || 
               EPR.ownerId=='005D0000001rH3B' || 
               EPR.ownerId=='005D0000001qz2K' ) &&
               department.get(0).name=='Directors'){}
             
           else if(EPR.OwnerId != department.get(0).Teamlead__c){
                if(EPR.department__r.Delegate_s_Threshold_Amount__c!=null){ 
                
                //Difference in edit
                Decimal diff = (EPI.Gross_price__c-Trigger.oldMap.get(EPI.id).Gross_price__c);
                 if(EPR.Gross_Payment_Amount__c + diff > EPR.department__r.Delegate_s_Threshold_Amount__c ){
                    EPR.Approving_Teamlead__c=EPR.department__r.Teamlead__c;
                    
                 }   
                 else{
                    EPR.Approving_Teamlead__c=EPR.department__r.Delegated_approver__c;
                    
                 } 
                 update EPR;
                }
            }     
      }
   }
   
   else if(Trigger.isDelete){
       for(EPR_Payable_Item__c EPI:Trigger.old){
    
        Electronic_Payment_Request__c EPR=[SELECT OwnerId, Team_Lead_Approval_Status__c,Gross_Payment_Amount__c, Approving_Teamlead__c,department__c, department__r.Delegated_approver__c, department__r.Delegate_s_Threshold_Amount__c, department__r.Teamlead__c  
                                           FROM Electronic_Payment_Request__c
                                           WHERE ID=:EPI.EPR__c];
                                           
        if(EPR.Team_Lead_Approval_Status__c!=null && EPR.Team_Lead_Approval_Status__c=='Approved'){
            EPI.addError('This EPR Payable item cannot be deleted. The EPR has been approved by the Team Lead');
        }
        
        //update the approver on the EPR based on threshold amount
        List<FFA_Config_Object__c> department=[SELECT Teamlead__c, name, Delegated_approver__c, Delegate_s_Threshold_Amount__c
                                               FROM FFA_Config_Object__c
                                               WHERE ID=:EPR.department__c];
         
         
         
            //check for Directors
           if((EPR.ownerId=='005D0000001qyr7' || 
               EPR.ownerId=='005D0000001rH3B' || 
               EPR.ownerId=='005D0000001qz2K' ) &&
               department.get(0).name=='Directors'){}
         else if(EPR.OwnerId != department.get(0).Teamlead__c){                                      
            if(EPR.department__r.Delegate_s_Threshold_Amount__c!=null && (EPR.Gross_Payment_Amount__c-EPI.Gross_price__c) <= EPR.department__r.Delegate_s_Threshold_Amount__c ){
                 EPR.Approving_Teamlead__c=EPR.department__r.Delegated_approver__c;
                 update EPR;
            } 
        }
     }
   }
}