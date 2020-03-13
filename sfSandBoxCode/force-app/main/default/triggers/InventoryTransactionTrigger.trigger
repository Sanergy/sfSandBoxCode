trigger InventoryTransactionTrigger on Inventory_Transaction__c (before insert, before update, before delete) {
    
    if(Trigger.isDelete){
        for(Inventory_Transaction__c inv: Trigger.old){
            inv.adderror('You are not permitted to delete a transaction once created');
        } 
    }
    
    else{
        
        for(Inventory_Transaction__c inv: Trigger.new){
            
            inv.Transaction_Date__c = System.today();
            
            Inventory_Item__c item = [SELECT Id, Name, Item_Type__c,Inventory_Stock__c,Currency_Config__c,Currency_Config__r.Name,
                                      Item_Company__c,Item_Company__r.lookup_ID__c,Item_Company__r.Name,Default_Site__c,unit_cost__c
                                      FROM Inventory_Item__c
                                      WHERE Id = :inv.Item__c
                                     ];
            
            System.debug('COMPANY:'+ item);
            
            Date today;
            String itemCompany;
            String Company;
            itemCompany = item.Item_Company__r.lookup_ID__c;
            Company = item.Item_Company__r.Name;
            today =  Date.today();
            System.debug('ITEM COMPANY:'+ itemCompany);
            String itemType = item.Item_Type__c;
            if(item != null && item.Item_Type__c != null){
                
                
                if(Trigger.isUpdate){
                    // Check if the values changed are different
                    if(Trigger.oldMap.get(inv.id).Transaction_Reversed__c != inv.Transaction_Reversed__c || 
                       Trigger.oldMap.get(inv.id).Reversed_Transaction_ID__c != inv.Reversed_Transaction_ID__c){
                           //Code to be executed                        
                       }else{
                           inv.adderror('You are not permitted to update a transaction once created');
                       }                    
                    
                }
                else{
                    if(itemType == 'Stock' && inv.Transaction_ID__c != 'LOCMOVE' && inv.Transaction_ID__c !='UNITPRICECHANGE'){
                        if(inv.Debit_Account__c == null){
                            inv.adderror('A debit account is required');
                        }
                        
                        if(inv.Credit_Account__c == null){
                            inv.adderror('A credit account is required');
                        }
                        
                        if(inv.Transaction_Quantity__c == null || inv.Transaction_Quantity__c <= 0){
                            inv.adderror('You cannot post a transaction with zero or Nevative Quantity');
                        }
                    }
                    
                    if(inv.Transaction_ID__c.endsWith('RVRS')){
                        inv.Quantity_Impact__c = 'D';
                    }
                    
                    if(inv.Quantity_Impact__c == 'D' || inv.Quantity_Impact__c == 'S'){
                        
                        List<Item_Location_Lot__c> itemLoc = [SELECT Id, Name, Quantity__c
                                                              FROM Item_Location_Lot__c
                                                              WHERE Id = :inv.Location_Lot__c];
                        
                        if(itemLoc.size() > 0){
                            
                            Item_Location_Lot__c location = itemLoc.get(0);
                            
                            inv.Quantity_At_Location__c = location.Quantity__c;
                            
                            System.debug('ITEM Name: ' + inv.Item__r.Name + 'Item_Location_Lot__c Quantity: ' + location.Quantity__c + 'Inventory_Transaction__c Quantity: ' + inv.Transaction_Quantity__c);
                            
                            if(location.Quantity__c >= inv.Transaction_Quantity__c){
                                
                                location.Quantity__c = location.Quantity__c - inv.Transaction_Quantity__c;
                                update location;
                                
                            } else {
                                inv.adderror('The location does not have enough items to complete the transaction');
                            }
                            
                        } else{
                            inv.adderror('The item is not in Inventory');
                        }
                        
                    } else if(inv.Quantity_Impact__c == 'I'){
                        
                        List<Item_Location_Lot__c> itemLoc = [SELECT Id, Name, Quantity__c
                                                              FROM Item_Location_Lot__c
                                                              WHERE Id = :inv.Location_Lot__c];
                        
                        Item_Location_Lot__c location = itemLoc.get(0);
                        
                        inv.Quantity_At_Location__c = location.Quantity__c;
                        
                        Double d = (location.Quantity__c == null ? 0 : location.Quantity__c) + inv.Transaction_Quantity__c;
                        location.Quantity__c = d;
                        
                        update location;
                    }
                    
                    if(inv.Transaction_ID__c == 'PORCPT' || inv.Transaction_ID__c == 'PORCPTRVS' || inv.Transaction_ID__c =='UNITPRICECHANGE' || inv.Transaction_ID__c == 'WORCPT'  || inv.Transaction_ID__c =='WORCPTRVS'){
                        
                        
                        
                        Double newUnitPrice = 0.00;
                        Double newInvQty = 0.00;
                        Double newWorkOrderUnitPrice = 0.00;
                        
                        if(inv.Transaction_ID__c == 'PORCPT'){
                            newInvQty = (item.Inventory_Stock__c == null ? 0 : item.Inventory_Stock__c) + inv.Transaction_Quantity__c;
                            newUnitPrice = ((item.Inventory_Stock__c * item.unit_cost__c) + (inv.Transaction_Value__c).SetScale(2))/newInvQty;
                        }
                        if(inv.Transaction_ID__c == 'PORCPTRVS'){
                            newInvQty = (item.Inventory_Stock__c == null ? 0 : item.Inventory_Stock__c) - inv.Transaction_Quantity__c;
                            newUnitPrice = ((item.Inventory_Stock__c * item.unit_cost__c) - (inv.Transaction_Value__c).SetScale(2))/newInvQty;  
                        }
                        if(inv.Transaction_ID__c =='UNITPRICECHANGE'){
                            newUnitPrice = inv.Item_Unit_Price__c;
                        }
                        
                        if(inv.Transaction_ID__c == 'WORCPT'){
                            newInvQty = (item.Inventory_Stock__c == null ? 0 : item.Inventory_Stock__c) + inv.Transaction_Quantity__c;
                            newUnitPrice = ((item.Inventory_Stock__c * item.unit_cost__c) + (inv.Transaction_Value__c).SetScale(2))/newInvQty;                            
                        }
                        
                        if(inv.Transaction_ID__c == 'WORCPTRVS'){
                            newInvQty = (item.Inventory_Stock__c == null ? 0 : item.Inventory_Stock__c) + inv.Transaction_Quantity__c;
                            newUnitPrice = ((item.Inventory_Stock__c * item.unit_cost__c) - (inv.Transaction_Value__c).SetScale(2))/newInvQty;                            
                        }
                        Inventory_Unit_Price_Change__c unitPriceChange = new Inventory_Unit_Price_Change__c();
                        
                        
                        if(item.unit_cost__c != newUnitPrice){
                            
                            
                            unitPriceChange.Current_Stock_Quantity__c = item.Inventory_Stock__c; 
                            unitPriceChange.Current_Unit_Price__c = item.unit_cost__c;
                            unitPriceChange.Inventory_Item__c = item.id;
                            unitPriceChange.PO__c =inv.Transaction_Value__c;
                            unitPriceChange.PO_Quantity__c = inv.Transaction_Quantity__c;
                            unitPriceChange.Purchase_Order_Line_Item__c = inv.Purchase_Order_Line__c;
                            unitPriceChange.Vendor_Invoice__c = inv.Vendor_Invoice__c;
                            unitPriceChange.Transaction_Type_del__c	 = inv.Transaction_ID__c;
                            unitPriceChange.Comments__c = inv.Comments__c;
                            insert unitPriceChange;
                            
                            system.debug('UnitPriceChange' + unitPriceChange);
                            
                            
                            item.unit_cost__c = newUnitPrice;
                            update item;
                            
                            
                        } 
                        
                        if(unitPriceChange.Id != null){
                            unitPriceChange.New_Unit_Price__c =  newUnitPrice;
                            unitPriceChange.New_Stock_Quantity__c = newInvQty;
                            update unitPriceChange;                             
                        }
                        System.debug('NewUnitPriceChange' + unitPriceChange);  
                        system.debug('ITEEEM'+ item);
                        system.debug ('New unit PO Price ' + inv.Item_Unit_Price__c + ' changed the Inv Unit Cost from ' + item.unit_cost__c + ' to ' + newUnitPrice);
                        
                        /*List<Inventory_Item_BOM__c> listBOM =[SELECT Parent_Item__c,Parent_Item__r.Inventory_Stock__c,Parent_Item__r.unit_cost__c
FROM Inventory_Item_BOM__c
WHERE BOM_Item__c =: item.ID
];
system.debug('List Inventory Items'+ listBOM);
IF(listBOM.size() > 0){
for (Inventory_Item_BOM__c ls : listBOM){
//Create the history Record 

Inventory_Unit_Price_Change__c unitPriceChange1 = new Inventory_Unit_Price_Change__c();
unitPriceChange1.Current_Stock_Quantity__c = ls.Parent_Item__r.Inventory_Stock__c; 
unitPriceChange1.Current_Unit_Price__c = ls.Parent_Item__r.unit_cost__c;
unitPriceChange1.Inventory_Item__c = ls.Parent_Item__c;
unitPriceChange1.PO__c =inv.Transaction_Value__c;
unitPriceChange1.PO_Quantity__c = inv.Transaction_Quantity__c;
unitPriceChange1.Purchase_Order_Line_Item__c = inv.Purchase_Order_Line__c;
unitPriceChange1.Vendor_Invoice__c = inv.Vendor_Invoice__c;
unitPriceChange1.Transaction_Type_del__c = inv.Transaction_ID__c;
unitPriceChange1.Comments__c = inv.Comments__c;
insert unitPriceChange1;  


System.debug('LS.ID' + ls.id); 

//get thetotal for all the prices of the child object 
AggregateResult result = [SELECT Parent_Item__c, AVG(Parent_Item__r.unit_cost__c) Parentaveg ,SUM(BoM_Item_Cost__c) totalsum
FROM Inventory_Item_BOM__c
WHERE Parent_Item__c =: ls.Parent_Item__c
GROUP BY Parent_Item__c
];
if(result != null ){
Decimal parentAvg = (Decimal) result.get('Parentaveg');
Decimal total = (Decimal) result.get('totalsum');  
if(parentAvg != total ){
ls.Parent_Item__r.unit_cost__c = total;
update ls;
system.debug('previous amount' + parentAvg+ 'new amount'+ ls.Parent_Item__r.unit_cost__c);
}

unitPriceChange1.New_Unit_Price__c =  total;
update unitPriceChange1;
unitPriceChange1.New_Stock_Quantity__c = ls.Parent_Item__r.Inventory_Stock__c;
update unitPriceChange1;
} 

}

}*/
                        
                    }
                    
                    
                    
                    
                    
                    //if(itemType == 'Stock' && inv.Transaction_ID__c != 'LOCMOVE' && inv.Transaction_ID__c !='UNITPRICECHANGE'){
                    if(inv.Transaction_ID__c != 'LOCMOVE' && inv.Transaction_ID__c !='UNITPRICECHANGE'){
                        
                        if(inv.Transaction_Value__c != 0){                            
                            
                            if(inv.Debit_Account__c != null && inv.Credit_Account__c != null){                                
                                
                                c2g__codaAccountingCurrency__c  accountingCurrency = [SELECT id, Name, c2g__OwnerCompany__c, c2g__OwnerCompany__r.Name, 
                                                                                      FFA_Config_Company__c, FFA_Config_Company__r.Name
                                                                                      FROM c2g__codaAccountingCurrency__c
                                                                                      WHERE Name =: item.Currency_Config__r.Name 
                                                                                      AND c2g__OwnerCompany__c =: itemCompany];
                                
                                system.debug('ACCOUNTING REFERENCE' +accountingCurrency);
                                
                                String Type; 
                                if(inv.Transaction_ID__c == 'WOISSEXP'){
                                                                 // Get the opportunity for the workOrder
                                List<Work_Order__c> wkorder =[SELECT Id,Opportunity__c 
                                                        FROM Work_Order__c 
                                                        WHERE Id =: inv.Work_Order__c
                                                       ];
                                //Get the Product payment type for the for opportunity
                                    
                                if( wkorder.size() > 0 ){
                                   List<Opportunity> oppoLst = [SELECT Id,Product_Payment_Type__c,RecordType.Name
                                                                  FROM Opportunity 
                                                                  WHERE RecordType.Name like '%Toilet Sale%'
                                                                  AND Id =: wkorder.get(0).Opportunity__c
                                                                 ];   
                                    
                                //Check if the List contains the Record Type with Toilet Sale and Assign it to a string
                                if(oppoLst.size() > 0){
                                    Type = oppoLst.get(0).Product_Payment_Type__c;
                                }
                                    else{
                                        Type = '';
                                    }
                                } 
                                else{
                                        Type = '';
                                    }
                                }


                                c2g__codaJournal__c ffajournal = new c2g__codaJournal__c(
                                    c2g__JournalDate__c = System.today(),
                                    c2g__JournalStatus__c = 'In Progress',
                                    ffgl__DerivePeriod__c = true,
                                    c2g__JournalCurrency__c = accountingCurrency.Id,
                                    c2g__Transaction__c = null,
                                    c2g__OwnerCompany__c = inv.Item_Company__c,
                                    c2g__JournalDescription__c = item != null ? item.Name : inv.Comments__c,
                                    c2g__Reference__c = inv.Transaction_ID__c,
                                    Product_Type__c = Type,
                                    Vendor__c = inv.Vendor_Account__c
                                    

                                );
                                insert ffajournal;
                                
                                inv.Journal_Entry_Number__c = ffajournal.Id;
                                Double Vat = ((inv.VAT_Amount__c == null ? 0 :  inv.VAT_Amount__c).SetScale(2));
                                Double DebitValue = ((inv.Transaction_Quantity__c * inv.Item_Unit_Price__c).SetScale(2));
                                // Double CreditValue = Vat + DebitValue;
                                Double CreditValue = (((inv.VAT_Amount__c == null ? 0 :  inv.VAT_Amount__c).SetScale(2)) +  ((inv.Transaction_Quantity__c * inv.Item_Unit_Price__c).SetScale(2))).SetScale(2);
                                
                                
                                c2g__codaJournalLineItem__c debitLine = new c2g__codaJournalLineItem__c(
                                    c2g__Journal__c =  ffajournal.Id,
                                    c2g__DebitCredit__c = 'Debit',
                                    c2g__LineType__c = 'General Ledger Account',
                                    c2g__GeneralLedgerAccount__c = inv.Debit_Account__c,
                                    c2g__Value__c =  DebitValue,
                                    c2g__Dimension1__c = inv.Dimension_1__c,
                                    c2g__Dimension2__c = inv.Dimension_2__c,
                                    c2g__Dimension3__c = inv.Dimension_3__c,
                                    c2g__Dimension4__c = inv.Dimension_4__c
                                );
                                insert debitLine;
                                
                                      c2g__codaJournalLineItem__c creditLine = new c2g__codaJournalLineItem__c(
                                        c2g__Journal__c = ffajournal.Id,
                                        c2g__DebitCredit__c = 'Credit',
                                        c2g__LineType__c ='General Ledger Account',
                                        c2g__GeneralLedgerAccount__c = inv.Credit_Account__c,
                                        c2g__Value__c = (DebitValue * -1),
                                        c2g__Dimension1__c = inv.Dimension_1__c,
                                        c2g__Dimension2__c = inv.Dimension_2__c,
                                        c2g__Dimension3__c = inv.Dimension_3__c,
                                        c2g__Dimension4__c = inv.Dimension_4__c
                                    );
                                    insert creditLine;                               
                                
                                
                               /* if(Vat != 0){
                                    
                                    c2g__codaJournalLineItem__c creditLineVat = new c2g__codaJournalLineItem__c(
                                        c2g__Journal__c = ffajournal.Id,
                                        c2g__DebitCredit__c = 'Credit',
                                        c2g__LineType__c ='General Ledger Account',
                                        c2g__GeneralLedgerAccount__c = inv.Credit_Account__c,
                                        c2g__Value__c = Vat,
                                        c2g__Dimension1__c = inv.Dimension_1__c,
                                        c2g__Dimension2__c = inv.Dimension_2__c,
                                        c2g__Dimension3__c = inv.Dimension_3__c,
                                        c2g__Dimension4__c = inv.Dimension_4__c
                                    );
                                    insert creditLineVat;                                
                                    
                                    
                                    c2g__codaJournalLineItem__c creditLine = new c2g__codaJournalLineItem__c(
                                        c2g__Journal__c = ffajournal.Id,
                                        c2g__DebitCredit__c = 'Credit',
                                        c2g__LineType__c ='General Ledger Account',
                                        c2g__GeneralLedgerAccount__c = inv.Credit_Account__c,
                                        c2g__Value__c = (CreditValue * -1),
                                        c2g__Dimension1__c = inv.Dimension_1__c,
                                        c2g__Dimension2__c = inv.Dimension_2__c,
                                        c2g__Dimension3__c = inv.Dimension_3__c,
                                        c2g__Dimension4__c = inv.Dimension_4__c
                                    );
                                    insert creditLine;                                   
                                    
                                }
                                
                                else{
                                  
                                    c2g__codaJournalLineItem__c creditLine = new c2g__codaJournalLineItem__c(
                                        c2g__Journal__c = ffajournal.Id,
                                        c2g__DebitCredit__c = 'Credit',
                                        c2g__LineType__c ='General Ledger Account',
                                        c2g__GeneralLedgerAccount__c = inv.Credit_Account__c,
                                        c2g__Value__c = (DebitValue * -1),
                                        c2g__Dimension1__c = inv.Dimension_1__c,
                                        c2g__Dimension2__c = inv.Dimension_2__c,
                                        c2g__Dimension3__c = inv.Dimension_3__c,
                                        c2g__Dimension4__c = inv.Dimension_4__c
                                    );
                                    insert creditLine;                                     
                                }
                                */
                                
                                
                                //Update item unit price If PORCPT
                                
                                
                                
                                //Update item unit price If PORCPTRVS NOTE NOT PORVS!!!
                                
                            }
                        } 
                        /*else {
inv.addError('You are not permitted to post a transaction with no value');
}*/
                    }
                    
                    if(inv.Quantity_Impact__c == 'D' && Company =='Fresh Life Initiative Limited' && itemType == 'Stock' && (item.Inventory_Stock__c - inv.Transaction_Quantity__c) == 0){
                        system.debug('itemcOMAPNY' + itemCompany);
                        RecordType record = [SELECT id,Name from RecordType where Name ='Stock Out Case'];
                        
                        Occurrence__c occ = new Occurrence__c (
                            RecordTypeId = record.Id,
                            Name ='Inventory Stock',
                            Full_Description__c = 'The stock Item ' + item.Name +  ' has run out ',
                            Inventory_Item__c = item.Id,
                            Occurrence_Date__c = today
                        );
                        insert occ;
                        system.debug('occurence'+ occ);
                    }
                    
                    
                }
                
            }
            
            else {
                inv.addError('Inventory Item is not selected or the Item does not have the type set');
            }
        }
    }
}