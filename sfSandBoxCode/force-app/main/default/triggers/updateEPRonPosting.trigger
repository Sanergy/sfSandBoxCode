trigger updateEPRonPosting on c2g__codaCashEntry__c (after update) {
    for(c2g__codaCashEntry__c cashEntry:Trigger.new){
        //if Reference ID is changed or status moved to complete, update the related VIs
        if(
            (cashEntry.c2g__Status__c!=null 
             && Trigger.oldMap.get(cashEntry.id).c2g__Status__c!=null
             && cashEntry.c2g__Status__c!=Trigger.oldMap.get(cashEntry.id).c2g__Status__c 
             && cashEntry.c2g__Status__c=='Complete'
            )
            || 
            (Trigger.oldMap.get(cashEntry.id).c2g__Reference__c != cashEntry.c2g__Reference__c 
             && cashEntry.c2g__Status__c=='Complete')
          ){
               system.debug('in here cashEntry = '+ cashEntry);
               //update any related EPR with the confirmation number and payment date
               List<Electronic_Payment_Request__c> eprList=[SELECT Confirmation_Number__c, Payment_Date__c
                                                            FROM Electronic_Payment_Request__c
                                                            WHERE Cash_Entry__c=:cashEntry.id];
               
               if(eprList.size()>0){
                   for(Electronic_Payment_Request__c epr:eprList){ 
                       epr.Confirmation_Number__c=cashEntry.c2g__Reference__c;
                       epr.Payment_Date__c=date.today();
                   }
                   
                   update eprList;
                   
               }
               
               for(Electronic_Payment_Request__c updatedepr:eprList){
                   List<Vendor_Invoice_Payment__c> vipList = [SELECT Id, Name, Payment_Made__c,EPR__c,EPR__r.Confirmation_Number__c
                                                              FROM Vendor_Invoice_Payment__c
                                                              WHERE EPR__C =: updatedepr.Id
                                                             ];
                   if(vipList.size()>0){
                       for(Vendor_Invoice_Payment__c vip: vipList ){
                           if(vip.EPR__r.Confirmation_Number__c != null){
                               vip.Payment_Made__c = true;
                           }  
                       }    
                   }
                   update  vipList;
               }  
           }
    }
}