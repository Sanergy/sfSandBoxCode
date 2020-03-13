trigger CreateFranchiseeHistoryRecordFrmOpp on Opportunity (before update) {
    /*- Commented 2020-03-09 : Creating duplicate FHR Entry
    for(Opportunity op:Trigger.New){
        if(Trigger.oldMap.get(op.id).accountId!=null &&
           op.accountId!=Trigger.oldMap.get(op.id).accountId){
                     List<Franchisee_History_Record__c> fhrList=[SELECT End_date__c,Current_owner__c
                                                       FROM Franchisee_History_Record__c
                                                       WHERE Toilet__r.Opportunity__c=:op.id
                                                       AND Current_owner__c=true];
                                                       
                   List<Franchisee_History_Record__c> fhrNew=new List<Franchisee_History_Record__c>();
                                                               
                   for(Franchisee_History_Record__c fhr:fhrList){
                       fhr.End_date__c=Date.today();
                       fhr.Current_owner__c=false; 
                       
                       Franchisee_History_Record__c fhrToInsert=new Franchisee_History_Record__c (
                             Current_owner__c=true,
                             Start_Date__c=Date.today(),
                             Opportunity__c=op.id,
                             Toilet__c=fhr.toilet__c 
                       ); 
                       
                       fhrNew.add(fhrToInsert);
                   }
                   
                   update fhrList;
                   insert fhrNew;
              
           }
    }
    */
}