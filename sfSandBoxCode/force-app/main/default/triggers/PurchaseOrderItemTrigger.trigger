trigger PurchaseOrderItemTrigger on Purchase_Order_Item__c (before insert,before update,before delete) {
    //For Each POI
    for(Purchase_Order_Item__c poi : Trigger.new){
        
        //Check if PO Item is flagged as Active
        if(poi.Status__c == 'Active' && poi.Approved__c == false){
            
            poi.adderror('This PO Item has to be approved');
            
        }else{            
            
            //check if there are any associated PRLI for this POI
            if(Trigger.IsBefore && Trigger.isDelete){
                
                List<PTS_Line_Item__c> PRLineList = [SELECT Id,Name,Purchase_Order_Item__c
                                                     FROM PTS_Line_Item__c
                                                     WHERE Purchase_Order_Item__c=: poi.Id
                                                    ];
                if(PRLineList.size() > 0){
                    for(PTS_Line_Item__c prli: PRLineList){
                        poi.addError('You cannot delete this PO Item since the Following PR Line Item(s) are associated with it.' + prli.Name); 
                    } 
                }
                
            } 
            //Check if Primary vendor is checked and Vendor Type is Primary
            if(poi.Vendor_Type__c == 'Primary'){
                poi.Primary_Vendor__c = true;
            }
            else if(poi.Primary_Vendor__c == true){
                poi.Vendor_Type__c = 'Primary'; 
            }
            
            //Get the Inventory Item UOM 
            List<Inventory_Item__c> invItms = [SELECT Id, Name,Inventory_UoM__c,Inventory_UoM__r.Name
                                               FROM Inventory_Item__c
                                               WHERE Id =: poi.Inventory_Item__c
                                              ];
            
            System.debug('Inventory Items' + invItms);
            
            //Get the Conversion Factor from the Purchase Order UOM and Inventory UOM
            if(invItms.size() > 0){
                List<Inventory_UoM__c> InvPurchaseUOM = [SELECT Id,Name
                                                         FROM Inventory_UoM__c
                                                         WHERE Id =: poi.Purchase_UoM__c
                                                        ];
                
                System.debug('Purchase ORDER UOM' + InvPurchaseUOM.get(0).Name);
                System.debug('INVENTORY UOM' + invItms.get(0).Inventory_UoM__r.Name);
                
                if(InvPurchaseUOM.size() > 0){
                    List<Inventory_UOM_Conversion__c> InvUOMConvs = [SELECT Id, Name,Comments__c, Conversion_Factor__c,
                                                                     From_UOM__c,Inventory_UoM__c,From_UOM__r.Name,
                                                                     Inventory_UoM__r.Name
                                                                     FROM Inventory_UOM_Conversion__c
                                                                     WHERE From_UOM__r.Name =: InvPurchaseUOM.get(0).Name
                                                                     AND Inventory_UoM__r.Name =: invItms.get(0).Inventory_UoM__r.Name
                                                                    ];
                    
                    System.debug('INV UOM CONVERSIONS '+ InvUOMConvs);
                    
                    //Set the Conversion Factor for the POI 
                    if(InvUOMConvs.size() > 0){
                        poi.UOM_Conversion_Factor__c = InvUOMConvs.get(0).Conversion_Factor__c;  
                    }                
                }
                
            }
            
            //Check if Primary Vendor is Checked on another POI for the same Inventory Item and Is Active
            List<Purchase_Order_Item__c> POILIST = [SELECT Id,Name,Company_Name__c,Inventory_Item__c,Inventory_UOM__c,Item_Description__c,
                                                    Primary_Vendor__c,Purchase_UoM__c,Status__c,Requires_Contract__c,Item_Cost__c,
                                                    Unit_Net_Price__c,Net_VAT__c,Vendor__c,Vendor_Type__c,Inventory_Item__r.Item_Type__c
                                                    FROM Purchase_Order_Item__c 
                                                    WHERE Inventory_Item__c =: poi.Inventory_Item__c
                                                    AND (Primary_Vendor__c =true OR Vendor_Type__c = 'Primary')
                                                    AND Status__c = 'Active'
                                                    AND Item_Type__c = 'Stock'
                                                    AND ID !=: POI.Id
                                                   ];
            
            if(POILIST.size() > 0 && poi.Status__c == 'Active' && poi.Item_Type__c == 'Stock' && 
               (poi.Primary_Vendor__c == true || poi.Vendor_Type__c == 'Primary')){
                
                for(Purchase_Order_Item__c itm:POILIST){
                    poi.addError('The Following PurchaseOrderItem(s) are active for this Inventory Item and Primary Vendor Checked.' + itm.Name); 
                }
            }
            
            //Check if the Account that is associated with the POI is active and if it's active then update the POI status to be active 
            List<Account> acc = [SELECT Id, Name,Vendor_Status__c
                                 FROM Account 
                                 WHERE Id =: poi.Vendor__c
                                ];
            
            if(acc.size() > 0){
                if(acc.get(0).Vendor_Status__c == 'Active' && poi.Approved__c == true && poi.Status__c == 'Pending Activation'){
                    poi.Status__c = 'Active';
                }
                
            }
            
            //Update the department Team Lead
            List<Inventory_Item__c> inv =[SELECT Id,Name,Responsible_Department__c
                                          FROM Inventory_Item__c
                                          WHERE Id =: poi.Inventory_Item__c
                                         ];
            
            if(inv.size() > 0){
                List<FFA_Config_Object__c> teamleadList = [SELECT Id,Name,Teamlead__c
                                                           FROM FFA_Config_Object__c
                                                           WHERE Id =: inv.get(0).Responsible_Department__c
                                                          ];
                if(teamleadList.size() > 0){
                    poi.Department_Team_Lead__c = teamleadList.get(0).Teamlead__c;
                }
            }
            
            
            //Check the older and the new value then insert a record on the POI Changes Object
            if(Trigger.isBefore && Trigger.isUpdate){
                
                Purchase_Order_Item__c oldPoi = Trigger.oldMap.get(poi.Id);
                
                Double unitPrice = oldPoi.Item_Cost__c;
                Double netPrice  = oldPoi.Unit_Net_Price__c;
                Double grossValue = oldPoi.Gross_Value__c;
                Double newunitPrice = poi.Item_Cost__c;
                
                system.debug('oldvalueeeee' + unitPrice);
                system.debug('newValueee' + newunitPrice);
                
                if(newunitPrice != unitPrice){
                    system.debug('Not equal to + Not equal to '); 
                    
                    Purchase_Order_Item_Price_Change__c poiChanges = new Purchase_Order_Item_Price_Change__c();
                    poiChanges.Company_Name__c = poi.Company_Name__c;
                    poiChanges.Purchase_Order_Item__c = poi.Id;
                    poiChanges.Purchase_UoM__c = poi.Purchase_UoM__c;
                    poiChanges.Current_Unit_Item_Cost__c = unitPrice;
                    poiChanges.Current_Unit_Net_Price__c = netPrice;
                    poiChanges.Current_Gross_Value__c = grossValue;
                    poiChanges.New_Unit_Item_Cost__c = poi.Item_Cost__c;
                    poiChanges.New_Unit_Net_Price__c = poi.Unit_Net_Price__c;
                    poiChanges.New_Gross_Value__c = poi.Gross_Value__c;
                    poiChanges.VAT_Amount__c = poi.Net_VAT__c;
                    poiChanges.Vendor__c = poi.Vendor__c;
                    poiChanges.Vendor_Type__c =  poi.Vendor_Type__c;  
                    
                    Insert poiChanges; 
                    
                }
                else{
                    system.debug('Equal to + Equal to' );   
                }
            }
            
            
        }// End if(poi.Status__c == 'Active' && poi.Approved__c == false)
        
    }// End for(Purchase_Order_Item__c poi : Trigger.new)
}