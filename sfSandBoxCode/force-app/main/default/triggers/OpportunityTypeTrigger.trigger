trigger OpportunityTypeTrigger on Opportunity (before insert, before update) {
    
    /*Datetime dt = datetime.now();
    String todaysDate = dt.format('DD/MM/YYYY');
    String formattedDate = ' (' + todaysDate + ') - ';
    
    //Get Opportunity RecordType
    RecordType opportunityRecordType = [SELECT Id,Name 
                                        FROM RecordType 
                                        WHERE Name ='Agricultural Product Sales - Payment' 
                                        LIMIT 1];
    
    for(Opportunity opportunity: Trigger.new){
        
        if(opportunity.RecordTypeId == opportunityRecordType.Id){
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId]; 
            
            opportunity.Name = customerAccount.Name + formattedDate + opportunity.Opportunity_Type__c;
            
        }//End if(opportunity.RecordTypeId == opportunityRecordType.Id)
        
        if(opportunity.Sale_Made__c == 'Yes'){
            /*(op.RecordTypeId=='012D0000000KGCKIA4' || op.RecordTypeId=='012D0000000KGBlIAO' || op.RecordTypeId=='012D0000000KGCtIAO' 
            || op.RecordTypeId=='012D0000000KGB7IAO' || op.RecordTypeId=='012D0000000KFz6IAG'){
            if(Trigger.oldMap.get(op.id).StageName != 'Order Delivered' && op.StageName != null &&
            Trigger.oldMap.get(op.id).StageName != op.StageName){
                        
            List<Farmstar_C2C_Visit__c> c2c = [SELECT Id,Opportunity__c,Account__c FROM Farmstar_C2C_Visit__c
                                               WHERE Account__c =: opportunity.AccountId AND Opportunity__c = null];
            
            for(Farmstar_C2C_Visit__c visit:c2c){
                visit.Sales_Order_Signed__c = opportunity.Sales_Order_Signed__c;
                visit.Close_Date__c = opportunity.CloseDate;
                visit.Delivery_Method__c = opportunity.Delivery_Method__c;
                visit.Delivery_instructions__c = 'assds';
                visit.Opportunity_Stage__c = opportunity.StageName;
                visit.Opportunity__c = opportunity.Id;
                update visit;
                opportunity.Number_Of_Visits__c = c2c.size();
                
                
            }
        }// End if(op.Sale_Made__c == 'Yes')
        
        if(opportunity.Sale_Made__c == 'No'){
            /*(op.RecordTypeId=='012D0000000KGCKIA4' || op.RecordTypeId=='012D0000000KGBlIAO' || op.RecordTypeId=='012D0000000KGCtIAO' 
            || op.RecordTypeId=='012D0000000KGB7IAO' || op.RecordTypeId=='012D0000000KFz6IAG'){
            if(Trigger.oldMap.get(op.id).StageName != 'Order Delivered' && op.StageName != null &&
            Trigger.oldMap.get(op.id).StageName != op.StageName){
            
            List<Farmstar_C2C_Visit__c> c2c2 = [SELECT Id,Opportunity__c,Account__c FROM Farmstar_C2C_Visit__c
                                                WHERE Account__c =: op.AccountId AND Opportunity__c =: opportunity.Id];
            
            for(Farmstar_C2C_Visit__c visit:c2c2){
                
                visit.Opportunity__c = null;
                update visit;
                
                
                
            }
            opportunity.Number_Of_Visits__c = 0;
        }// End if(op.Sale_Made__c == 'No')        
        
    }// End for(Opportunity opportunity: Trigger.new)*/
    
}