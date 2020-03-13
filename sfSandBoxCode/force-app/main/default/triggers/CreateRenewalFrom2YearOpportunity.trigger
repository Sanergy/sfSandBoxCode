trigger CreateRenewalFrom2YearOpportunity on Opportunity (after update) {
    for(Opportunity op:Trigger.new){
    
        //create renewal opportunity when stage moves to FLO Launched
        if(op.StageName!=null && op.StageName=='FLO Launched' && Trigger.oldMap.get(op.id).StageName!=op.StageName && op.Specific_Financing_Method__c=='2 Year Loan'){
            //get the toilets for this opportunity
            List<Toilet__c> toiletList=[SELECT ID
                                        FROM Toilet__c
                                        WHERE Opportunity__c=:op.id];
        
            if(toiletList.size()>0){
                List<Opportunity> renewalOpps=new List<Opportunity>();
                Date renewalStartDate=op.Actual_Launch_Date__c.toStartOfMonth().addMonths(12).addDays(14);
                Date renewalEndDate=renewalStartDate.addYears(1).addDays(-1);
                
                //get renewal recordtype
                List<RecordType> RenewalrecordType=[SELECT ID
                                            FROM RecordType
                                            WHERE Name='Renewal Sale'];
                
                
                for(Toilet__c toilet:toiletList){
                    Opportunity opp=new Opportunity(
                                 RecordTypeId=RenewalrecordType.get(0).ID,
                                 AccountId=op.AccountId,
                                 CloseDate=op.Actual_Launch_Date__c,
                                 Toilet__c=toilet.ID,
                                 StageName='Renewal - In Progress',
                                 Renewal_Start_Date__c=renewalStartDate,
                                 Renewal_End_Date__c=renewalEndDate,
                                 Name='x'
                   );
                   
                   renewalOpps.add(opp);
                }
                
                insert renewalOpps;
                 System.debug(toiletList.size());
            }
            else{
           System.debug(toiletList.size());
        }
           
        }
        
   }
}