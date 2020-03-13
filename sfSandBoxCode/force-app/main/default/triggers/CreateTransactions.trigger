trigger CreateTransactions on Inventory_Location_Move__c (before insert, before update, before delete) {
    
    for(Inventory_Location_Move__c locmv: Trigger.new){
        
        if(Trigger.isUpdate){
            locmv.adderror('You are not permitted to update a transaction once created');
        } else if(Trigger.isDelete){
            locmv.adderror('You are not permitted to delete a transaction once created');
        } else{
            
            
            if(locmv.Location_Lot_From__c != null){
                        
                        List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c
                                                       FROM Group_Details__c
                                                       WHERE Inventory_Item_Group__c = :locmv.Inventory_Item__r.Item_Group__c
                                                       AND Transaction_ID__c = 'LOCMOVE'
                                                       AND Is_GL_Account__c = true
                                                      ];
                System.debug('GLA::'+glas.size());
                        
                        Group_Details__c creditGl = null;
                        Group_Details__c debitGl = null;
                        
                        for(Group_Details__c gla : glas){
                            if(gla.Credit_Debit__c == 'Credit'){
                                creditGl = gla;
                            } else if(gla.Credit_Debit__c == 'Debit'){
                                debitGl = gla;
                            }else{locmv.addError('GLA empty');}
                        }
                        
                        //if(debitGl != null && creditGl != null){
                                                            
                            Inventory_Transaction__c fromtrans = new Inventory_Transaction__c();
                            	fromtrans.Item__c = locmv.Inventory_Item__c;
                                fromtrans.Transaction_ID__c = 'LOCMOVE';
                                fromtrans.Location__c = locmv.Location_From__c;
                                fromtrans.Location_Lot__c = locmv.Location_Lot_From__c;
                                fromtrans.Transaction_Quantity__c = locmv.Quantity__c;
                                fromtrans.Item_Unit_Price__c = locmv.Inventory_Item__r.unit_cost__c;
                                fromtrans.Quantity_Impact__c = 'D';
                                //fromtrans.Debit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;
                                //fromtrans.Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                                fromtrans.Dimension_1__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_1__r.lookup_ID__c;
                                fromtrans.Dimension_2__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_2__r.lookup_ID__c;
                                fromtrans.Dimension_3__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_3__r.lookup_ID__c;
                                fromtrans.Dimension_4__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_4__r.lookup_ID__c;
                                fromtrans.Comments__c = 'Location move';
                            
                            insert fromtrans;            
            
          				  locmv.From_Transaction__c = fromtrans.Id;
            
                			Inventory_Transaction__c toTrans = new Inventory_Transaction__c();
            					toTrans.Item__c = locmv.Inventory_Item__c;
                                toTrans.Transaction_ID__c = 'LOCMOVE';
                                toTrans.Location__c = locmv.Location_To__c;
                                toTrans.Location_Lot__c = locmv.Location_Lot_To__c;
                                toTrans.Transaction_Quantity__c = locmv.Quantity__c;
                                toTrans.Item_Unit_Price__c = locmv.Inventory_Item__r.unit_cost__c;
                                toTrans.Quantity_Impact__c = 'I';
                                //toTrans.Debit_Account__c = debitGl.Config_Account__r.Lookup_Id__c;
                                //toTrans.Credit_Account__c = creditGl.Config_Account__r.Lookup_Id__c;
                                toTrans.Dimension_1__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_1__r.lookup_ID__c;
                                toTrans.Dimension_2__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_2__r.lookup_ID__c;
                                toTrans.Dimension_3__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_3__r.lookup_ID__c;
                                toTrans.Dimension_4__c = locmv.Inventory_Item__r.Item_Group__r.Dimension_4__r.lookup_ID__c;
                                toTrans.Comments__c = 'Location move';
                            
            				insert toTrans;
            
            				locmv.To_Transaction__c = toTrans.Id;
                        //}else{locmv.addError('GLAs are missing');}
            }else{locmv.addError('The leselcted Lot Does not have quantity');}
        }
    }
}