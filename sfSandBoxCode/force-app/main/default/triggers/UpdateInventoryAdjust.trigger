trigger UpdateInventoryAdjust on rstk__sytxncst__c (before insert, after insert, after update) {
    
    for (rstk__sytxncst__c costTransaction: Trigger.new) {
    
        Inventory_Adjustment__c adj = null;
        Map<String, Object> adjustVals = new Map<String, Object>();
        
        if(Trigger.isInsert){
            
            if(costTransaction.rstk__sytxncst_txnid__c.equals('INVLOCADJ')){
                
                rstk__icitem__c item = null;
                
                rstk__syusr__c rstkUser = [SELECT id, name, rstk__syusr_lastcmpno__c, rstk__syusr_lastdiv__c
                                           FROM rstk__syusr__c
                                           WHERE rstk__syusr_employee__c = :UserInfo.getUserId()];
                
                if(costTransaction.rstk__sytxncst_item__c != null){
                                        
                    rstk__peitem__c engItem;
                    
                    if(costTransaction.Id == null){
                        List<rstk__peitem__c> engItems = [SELECT Id, Name, rstk__peitem_item__c FROM rstk__peitem__c 
                                    WHERE rstk__peitem_item__c = :costTransaction.rstk__sytxncst_item__c];
                        if(engItems.size() > 0){
                            engItem = engItems.get(0);
                        }
                    } else {
                        List<rstk__peitem__c> engItems = [SELECT Id, Name, rstk__peitem_item__c FROM rstk__peitem__c 
                                    WHERE rstk__peitem_item__c = :costTransaction.item_num__c
                                                          AND rstk__peitem_div__c = :rstkUser.rstk__syusr_lastdiv__c];
                        if(engItems.size() > 0){
                            engItem = engItems.get(0);
                        }
                    }
                                            
                    if(engItem != null){
                        item = [SELECT Id, Name, rstk__icitem_item__c, rstk__icitem_div__c FROM rstk__icitem__c WHERE rstk__icitem_item__c = :engItem.Id];
                    }
                }
                
                if(item != null){
                    
                    if(costTransaction.Id == null){
                        costTransaction.item_num__c = costTransaction.rstk__sytxncst_item__c;
                        costTransaction.rstk__sytxncst_item__c = item.Name;
                    } else {
                        if(costTransaction.rstk__sytxncst_comments__c != null){
                            try{
                                adjustVals = (Map<String, Object>)JSON.deserializeUntyped(costTransaction.rstk__sytxncst_comments__c);
                            }catch(Exception e){}
                        }
                                                 
                        adj = new Inventory_Adjustment__c(Cost_Transaction__c = costTransaction.Id,
                                                          Current_Division__c = rstkUser.rstk__syusr_lastdiv__c,
                                                          Inventory_Item__c = item.Id,
                                                          Quantity__c = costTransaction.rstk__sytxncst_txnqty__c,
                                                          Qty_Impact__c = costTransaction.rstk__sytxncst_locqtyupdind__c,
                                                          Department__c = (String)adjustVals.get('dept'),
                                                          Site__c = (String)adjustVals.get('site'),
                                                          Requesting_User__c = (String)adjustVals.get('user'),
                                                          Dimension_1__c = (String)adjustVals.get('dim1'),
                                                          Dimension_2__c = (String)adjustVals.get('dim2'),
                                                          Dimension_3__c = (String)adjustVals.get('dim3'),
                                                          Dimension_4__c = (String)adjustVals.get('dim4'),
                                                          Adjustment_GL_Account__c = (String)adjustVals.get('gla'),
                                                          Project__c = (String)adjustVals.get('prj')
                                                         );  
                        
                        System.debug(rstkUser.rstk__syusr_lastdiv__c);
                        System.debug(item.Id);
                        System.debug(item.rstk__icitem_div__c);
                        
                        insert adj;
                    }
                }
            }
        }
        
        if(Trigger.isUpdate){
            
            if(costTransaction.rstk__sytxncst_txnid__c.equals('INVLOCADJ')){
                if(Trigger.oldMap.get(costTransaction.Id).rstk__sytxncst_journalentryno__c == null 
                   && costTransaction.rstk__sytxncst_journalentryno__c != null){
                       
                       List<Inventory_Adjustment__c> adjs = [SELECT Id, Name FROM Inventory_Adjustment__c WHERE Cost_Transaction__c = :costTransaction.Id];
                       
                       if(adjs.size() > 0){
                           adj = adjs.get(0);
                           adj.Journal__c = costTransaction.rstk__sytxncst_journalentryno__c;
                           update adj;
                       }                
                }
            }
        }
    }
}