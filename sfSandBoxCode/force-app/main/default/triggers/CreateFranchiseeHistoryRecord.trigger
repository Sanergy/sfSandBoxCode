trigger CreateFranchiseeHistoryRecord on Toilet__c (after insert, after update) {
    
    for(Toilet__c toilet:trigger.new){
        Franchisee_History_Record__c fhr;
 
 /*-----------------------------------If trigger is insert------------------------------------*/
         if(Trigger.isInsert){
             fhr=new Franchisee_History_Record__c(
                 Current_owner__c=true,
                 Start_Date__c=Date.today(),
                 Opportunity__c=toilet.Opportunity__c,
                 Toilet__c=toilet.id
             );
             insert fhr;
          }   
/*-----------------------------------end of insert------------------------------------*/
 
 
 
 
 
 
 /*-----------------------------------If trigger is update------------------------------------*/
         else if(Trigger.isUpdate){
         if(Trigger.oldMap.get(toilet.id).opportunity__c!=null &&
            toilet.opportunity__c!=Trigger.oldMap.get(toilet.id).opportunity__c){
               List<Franchisee_History_Record__c> fhrCurrent=[SELECT End_date__c,Current_owner__c
                                                               FROM Franchisee_History_Record__c
                                                               WHERE Toilet__c=:toilet.id
                                                               AND Current_owner__c=true];
                
                //update the current active owner                                               
               if(fhrCurrent.size()>0){
                   fhrCurrent.get(0).End_date__c=Date.today();
                   fhrCurrent.get(0).Current_owner__c=false;
                   
                   update fhrCurrent;
               }
               
               fhr=new Franchisee_History_Record__c(
                     Current_owner__c=true,
                     Start_Date__c=Date.today(),
                     Opportunity__c=toilet.Opportunity__c,
                     Toilet__c=toilet.id
               ); 
               
               insert fhr;
             }
                
         }
 /*-----------------------------------End of update------------------------------------*/
    
      
        
     }    
}