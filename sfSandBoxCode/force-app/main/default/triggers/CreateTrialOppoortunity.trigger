trigger CreateTrialOppoortunity on Trial__c (after insert) {
   for(Trial__c trial:Trigger.new){
            
            List<Opportunity> opList=new List<Opportunity>();
            
               //create a trial opportunity
                Opportunity opTrial=new Opportunity(
                    Name='x',
                    RecordTypeId='012D0000000KGB7IAO',
                    StageName='Active Trial',
                    Trial__c=trial.id,
                    AccountId=trial.Account__c,
                    CloseDate=Date.today(),
                    Phone_Number__c=trial.Phone__c,
                    Type='Trial'  
                );
                
                //create an after-sale opportunity
                Opportunity opAfterSale=new Opportunity(
                   Name='x',
                    RecordTypeId='012D0000000KGB7IAO',
                    StageName='Active Trial',
                    Trial__c=trial.id,
                    AccountId=trial.Account__c,
                    CloseDate=Date.today().addMonths(3),
                    Phone_Number__c=trial.Phone__c,
                    Type='After Sale'  
                );
                
                opList.add(opTrial);
                opList.add(opAfterSale);
                
                insert opList; 
        }     
}