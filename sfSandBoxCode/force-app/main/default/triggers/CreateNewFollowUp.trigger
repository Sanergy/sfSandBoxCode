trigger CreateNewFollowUp on Ag_Sales_Followup__c (before update) {
   for(Ag_Sales_Followup__c agSaleFollowUp:Trigger.New){  
   /*  
   
       if(agSaleFollowUp.Planned_Date__c!=null && agSaleFollowUp.Follow_Up_Task__c!=null){
           agSaleFollowUp.Opportunity_FollowUp_Complete__c=true;
       
       }
       
       if(agSaleFollowUp.Next_Followup_Date__c!=null && Trigger.oldMap.get(agSaleFollowUp.id).Next_Followup_Date__c!=agSaleFollowUp.Next_Followup_Date__c){  
          Opportunity op=[SELECT Ag_Sales_Followup_Completed__c FROM Opportunity WHERE ID=:agSaleFollowUp.Opportunity_Name__c];
          
          if(op.Ag_Sales_Followup_Completed__c ==false){
                  Ag_Sales_Followup__c newAgFollowUp=new Ag_Sales_Followup__c(
                       name=agSaleFollowUp.name,
                       Planned_Date__c=agSaleFollowUp.Next_Followup_Date__c,
                       Employee__c=agSaleFollowUp.Employee__c,
                       Comments__c=agSaleFollowUp.Followup_Comments__c,
                       Task__c=agSaleFollowUp.Follow_Up_Task__c,
                       Opportunity_Name__c=agSaleFollowUp.Opportunity_Name__c
                   ); 
               
               
                List<Ag_Sales_Followup__c> newAgFollowUpList=new List<Ag_Sales_Followup__c>();
                newAgFollowUpList.add(newAgFollowUp);
                Utils.insertOnce(agSaleFollowUp,newAgFollowUpList,'Next_Followup_Date__c');
          }   
       }
       
       */
   }
}