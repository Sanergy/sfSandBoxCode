trigger CountC2CforAgriculturalSaleOpportunity on Opportunity (before update) {
    /*for(Opportunity op : Trigger.New){
        if(op.Sale_Made__c == 'Yes'){
            (op.RecordTypeId=='012D0000000KGCKIA4' || op.RecordTypeId=='012D0000000KGBlIAO' || op.RecordTypeId=='012D0000000KGCtIAO' 
          || op.RecordTypeId=='012D0000000KGB7IAO' || op.RecordTypeId=='012D0000000KFz6IAG'){
           if(Trigger.oldMap.get(op.id).StageName != 'Order Delivered' && op.StageName != null &&
               Trigger.oldMap.get(op.id).StageName != op.StageName){

                   List<Farmstar_C2C_Visit__c> c2c = [SELECT Id,Opportunity__c,Account__c FROM Farmstar_C2C_Visit__c
                                                     WHERE Account__c =: op.AccountId AND Opportunity__c = null];
                   
                   for(Farmstar_C2C_Visit__c visit:c2c){
                       visit.Sales_Order_Signed__c = op.Sales_Order_Signed__c;
                       visit.Close_Date__c = op.CloseDate;
                       visit.Delivery_Method__c = op.Delivery_Method__c;
                       visit.Delivery_instructions__c = 'assds';
                       visit.Opportunity_Stage__c = op.StageName;
                       visit.Opportunity__c = op.Id;
                       update visit;
                       op.Number_Of_Visits__c = c2c.size();

                       
                   }
               }
        if(op.Sale_Made__c == 'No'){
            /*(op.RecordTypeId=='012D0000000KGCKIA4' || op.RecordTypeId=='012D0000000KGBlIAO' || op.RecordTypeId=='012D0000000KGCtIAO' 
          || op.RecordTypeId=='012D0000000KGB7IAO' || op.RecordTypeId=='012D0000000KFz6IAG'){
           if(Trigger.oldMap.get(op.id).StageName != 'Order Delivered' && op.StageName != null &&
               Trigger.oldMap.get(op.id).StageName != op.StageName){

                   List<Farmstar_C2C_Visit__c> c2c2 = [SELECT Id,Opportunity__c,Account__c FROM Farmstar_C2C_Visit__c
                                                     WHERE /*Account__c =: op.AccountId AND Opportunity__c =: op.Id];
                   
                   for(Farmstar_C2C_Visit__c visit:c2c2){
                       
                       visit.Opportunity__c = null;
                       update visit;
                       

                       
                   }
            op.Number_Of_Visits__c = 0;
               }
        
          }*/
}