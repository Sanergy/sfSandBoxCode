trigger CreateNewAGSaleOpportunity on Opportunity (after update) {
    for(Opportunity op:Trigger.new){
    
    /*
      if(op.RecordTypeId=='012D0000000KGCKIA4' || op.RecordTypeId=='012D0000000KGBlIAO' || op.RecordTypeId=='012D0000000KGCtIAO' 
          || op.RecordTypeId=='012D0000000KGB7IAO' || op.RecordTypeId=='012D0000000KFz6IAG'){
           if(Trigger.oldMap.get(op.id).StageName!=null && op.StageName!=null &&
               Trigger.oldMap.get(op.id).StageName!=op.StageName &&
               op.StageName.equals('Sale Confirmed')){
               
               //create a new AG Sale Opp
                Opportunity newOp=new Opportunity(
                    Name='x',
                    RecordTypeId='012D0000000KGB7IAO',
                    StageName='Pending Resale',
                    AccountId=op.accountId,
                    CloseDate=Date.today().addMonths(3),
                    Phone_Number__c=op.Phone_Number__c
                );
                
                List<Opportunity> newOpList=new List<Opportunity>();
                newOpList.add(newOp);
                
                Utils.insertOnce(op, newOpList, 'StageName' );
               // insert newOp;
          }
       }
    */       
    }
}