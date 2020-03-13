trigger SetDimensionsAndGla on c2g__codaJournalLineItem__c (before insert) {
    
    for (c2g__codaJournalLineItem__c lineItem: Trigger.new) {
        
       /* if(lineItem.c2g__Journal__c != null && !lineItem.GLA_Change__c){
            
            List<Inventory_Adjustment__c> adjusts = [SELECT Id, Name, Cost_Transaction__c, Dimension_1__c, Dimension_2__c,
                                               Dimension_3__c, Dimension_4__c, Adjustment_GL_Account__c
                                               FROM Inventory_Adjustment__c 
                                               WHERE Journal__c = :lineItem.c2g__Journal__c];
            
            if(adjusts.size() > 0 ){
                Inventory_Adjustment__c adjust = adjusts.get(0);
                lineItem.c2g__Dimension1__c = adjust.Dimension_1__c;
                lineItem.c2g__Dimension2__c = adjust.Dimension_2__c;
                lineItem.c2g__Dimension3__c = adjust.Dimension_3__c;
                lineItem.c2g__Dimension4__c = adjust.Dimension_4__c;      
                     
            }            
        }
*/
    }
}