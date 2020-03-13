trigger GetLounchedToiletsFromOpportunity on Opportunity (before update) {
    for(Opportunity op:Trigger.New){
        
        Opportunity opp = Trigger.OldMap.get(op.Id);
        
        if(op.StageName != opp.StageName && op.StageName == 'Launched'){
            
            Date today = Date.today();  
        
        	Date startOfMonth = today.toStartOfMonth();        
            
            Double myNumber = 0;
            
        	List<Opportunity> opportunity = [SELECT Id,Number_of_Sale_Opportunities__c, Number_of_Opportunity_Products__c,FLTs_Approved__c, StageName, Actual_Launch_Date__c,NumberOfLounchedToilets__c FROM Opportunity
                                   		WHERE StageName ='Launched' 
                                   		AND Actual_Launch_Date__c <=: today 
                                   		AND Actual_Launch_Date__c >=: startOfMonth
                                       ];
                       
            for (Opportunity o:opportunity){
                
               ///Opportunity oppp = [SELECT Id,FLTs_Approved__c FROM Opportunity WHERE Id =: o.Id ];
               
                //myNumber += oppp.FLTs_Approved__c;
                System.debug('MYNUMBER 1: ' + myNumber);
                myNumber += o.FLTs_Approved__c;
                System.debug('MYNUMBER 2: ' + myNumber);
             }
            
            /*List<Toilet__c> toilets = [SELECT Id, Name,Opportunity__c, Opening_Date__c FROM Toilet__c
                                   		WHERE  Opening_Date__c <=: today 
                                   		AND Opening_Date__c >=: startOfMonth
                                        AND Opportunity__c =: op.Id
                                       ];*/
			
            op.NumberOfLounchedToilets__c = myNumber + op.FLTs_Approved__c;
            op.Number_of_Sale_Opportunities__c = opportunity.size() + 1;
             			
            

            
            
        }
            
        
    }
}