trigger UpdateGLAccount on c2g__codaJournalLineItem__c (after insert) {
    
    for (c2g__codaJournalLineItem__c lineItem: Trigger.new) {
     
      /*  if(lineItem.c2g__Journal__c != null && !lineItem.GLA_Change__c){
            
            List<Inventory_Adjustment__c> adjusts = [SELECT Id, Name, Cost_Transaction__c, Dimension_1__c, Dimension_2__c,
                                               Dimension_3__c, Dimension_4__c, Adjustment_GL_Account__c, Inventory_Item__c
                                               FROM Inventory_Adjustment__c 
                                               WHERE Journal__c = :lineItem.c2g__Journal__c];
           
            if(adjusts.size() > 0 ){
                
                Inventory_Adjustment__c adjust = adjusts.get(0);
                String glaId = adjust.Adjustment_GL_Account__c;
                
                List<Rootstock_Item_GLA__c> itemGlas = [SELECT Id, Name, Inventory_Item__c, General_Ledger_Account__c 
                                                        FROM Rootstock_Item_GLA__c WHERE Inventory_Item__c = :adjust.Inventory_Item__c];
               
               if(itemGlas != null && itemGlas.size() > 0){
                   
                   glaId = itemGlas.get(0).Inventory_Item__c;
               } 
               
                List<rstk__sytxncst__c> cost = [SELECT Id, Name, rstk__sytxncst_dracct__c, rstk__sytxncst_cracct__c
                                          FROM rstk__sytxncst__c WHERE Id = :adjust.Cost_Transaction__c];
                
                if(cost.size()>0){
                    if(!lineItem.c2g__GeneralLedgerAccount__c.equals(cost.get(0).rstk__sytxncst_dracct__c) || !lineItem.c2g__GeneralLedgerAccount__c.equals(cost.get(0).rstk__sytxncst_cracct__c)){
                        adjust.Journal_Ac_Issues__c = true;
                        update adjust; 
                    }
                } 
                
                if(lineItem.c2g__Value__c > 0 && glaId != null){
                    
                    c2g__codaJournalLineItem__c debit = lineItem.clone(false, true);
                    debit.c2g__Value__c = (debit.c2g__Value__c * -1);
                    debit.GLA_Change__c = true;
                    
                    insert debit;
                    
                    c2g__codaJournalLineItem__c credit = lineItem.clone(false, true);
                    credit.GLA_Change__c = true;
                    credit.c2g__GeneralLedgerAccount__c = adjust.Adjustment_GL_Account__c;
                    
                    insert credit;
                } 
            }
        }
*/
    }

}