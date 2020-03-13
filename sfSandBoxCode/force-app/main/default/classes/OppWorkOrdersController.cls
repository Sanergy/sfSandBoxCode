public class OppWorkOrdersController{
    
    private ApexPages.StandardController standardController;
    
    //Opportunity
    public Opportunity opp {get; set;}     
    
    public OppWorkOrdersController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        opp = (Opportunity) standardController.getRecord();
        
        opp = [SELECT ID,Name,Basic_FLT__c,BIB_Items_Approved__c,Engineering_Items_Approved__c,
               Marketing_Items_Approved__c,Pit_Conversion_Items_Approved__c,Structure_WO_Created__c,
               BIB_WO_Created__c,Pit_Conversion_WO_Created__c,Basic_FLT_WO_Created__c,FLTs_Approved__c,
               Pit_Conversion__c,No_of_approved_pit_s_to_be_converted__c
               FROM Opportunity 
               WHERE Id =: opp.Id];
    }
    
    public PageReference createOrders() {
        
        if(opp.BIB_Items_Approved__c && opp.Engineering_Items_Approved__c && opp.Marketing_Items_Approved__c){
            
            Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
            //String slkDivision = settings.get('SLK Division Id').Value__c;
            String fliDivision = settings.get('FLIK Division Id').Value__c;
            //String slkStructItem = settings.get('Structure SLK Item').Value__c;
            String fliStructItem = settings.get('Structure FLI Item').Value__c;
            //String slkBibItem = settings.get('Bib SLK Item').Value__c;
            String fliBibItem = settings.get('Bib FLI Item').Value__c;
            //String slkPitItem = settings.get('Pit Conversion SLK Item').Value__c;
            String fliPitItem = settings.get('Pit Conversion FLI Item').Value__c;
            String fliBasicFLTItem = settings.get('Basic FLT FLI Item').Value__c;
            String inventorySiteMukuru = settings.get('Inventory Site - Mukuru').Value__c;
            String dim1;
            
            //Get Dimension 1
            List<c2g__codaDimension1__c> dimensions = [SELECT Id,Name
                                                       FROM c2g__codaDimension1__c
                                                       WHERE Name='Pit Conversion'
                                                       OR Name='Fresh Life - Customer Support'
                                                       OR Name='Fresh Life Operations - Installation'];
            
            //Check if BIB Work Order has been created
            if(opp.BIB_WO_Created__c == false){
                
                //Get Opportunity_BIB_Item__c that belong to Fresh Life
                List<Opportunity_BIB_Item__c> items = [SELECT Id, Name, Inventory_Item__c, Item_Division__c, Quantity__c,
                                                       Opportunity_Item__r.InventoryItem__r.unit_cost__c,Opportunity_Item__r.InventoryItem__r.Currency_Config__c
                                                       FROM Opportunity_BIB_Item__c
                                                       WHERE Opportunity__c = :opp.Id
                                                       AND Item_Division__c='aEBD0000000kA4j'];
                
                if(items.size() > 0){
                    
                    Map<String, List<Opportunity_BIB_Item__c>> itemMap = new Map<String, List<Opportunity_BIB_Item__c>>();
                    
                    for(Opportunity_BIB_Item__c item : items){
                        List<Opportunity_BIB_Item__c> itemList = itemMap.get(item.Item_Division__c);
                        
                        if(itemList != null){
                            itemList.add(item);
                        } else {
                            itemList = new  List<Opportunity_BIB_Item__c>();
                            itemList.add(item);
                            itemMap.put(item.Item_Division__c, itemList);
                        }
                    }
                    if(itemMap.size() > 0){
                        
                        Set<String> keys = itemMap.keySet();
                        
                        for(String key: keys){
                            
                            List<Opportunity_BIB_Item__c> itemList = itemMap.get(key);
                            
                            if(itemList.size() > 0){
                                
                                String itemId = fliBibItem;
                                
                                if(key.equals(fliDivision)){
                                    itemId = fliBibItem;
                                }
                                
                                Work_Order__c wo = new Work_Order__c(
                                    Inventory_Item__c = itemId,
                                    Site__c = inventorySiteMukuru ,
                                    Inventory_Item_Quantity__c =  opp.FLTs_Approved__c,
                                    Company__c= key,
                                    Opportunity__c = opp.Id,
                                    Status__c = 'Firmed'
                                );
                                
                                insert wo;
                                
                                List<Work_Order_Item__c> wo_comps = new List<Work_Order_Item__c>();
                                
                                Map<String, Work_Order_Item__c > mergedItems = new Map<String, Work_Order_Item__c >();
                                
                                for(Opportunity_BIB_Item__c itms : itemList){
                                    
                                    Work_Order_Item__c cmp = mergedItems.get(itms.Inventory_Item__c);
                                    
                                    if(cmp == null){
                                        
                                        cmp = new Work_Order_Item__c(
                                            Work_Order__c = wo.Id,
                                            Inventory_Item__c = itms.Inventory_Item__c,
                                            BOM_Quantity__c = itms.Quantity__c,
                                            Unit_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c,
                                            Currency__c = itms.Opportunity_Item__r.InventoryItem__r.Currency_Config__c,
                                            Planned_Material_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c * itms.Quantity__c
                                        );
                                        
                                        wo_comps.add(cmp);
                                        mergedItems.put(itms.Inventory_Item__c, cmp);
                                        
                                    } else{
                                        cmp.BOM_Quantity__c=cmp.BOM_Quantity__c+itms.Quantity__c;
                                        cmp.Planned_Material_Cost__c=cmp.BOM_Quantity__c * cmp.Unit_Cost__c;
                                    }
                                }
                                
                                if(wo_comps.size() > 0){
                                    System.debug(JSON.serialize(wo_comps));
                                    insert wo_comps;
                                }
                                
                                //Create Opportunity_Work_Order__c
                                Opportunity_Work_Order__c wOrder = new Opportunity_Work_Order__c();
                                wOrder.Opportunity__c = opp.Id;
                                wOrder.WorkOrder__c = wo.Id;
                                wOrder.Work_Order_Type__c = 'Business in a Box';
                                INSERT wOrder;
                                
                                // Loop through c2g__codaDimension1__c
                                for(c2g__codaDimension1__c dimension : dimensions){                                    
                                    // Check if Work_Order_Type__c ='Business in a Box'                                    
                                    if(dimension.Name=='Fresh Life - Customer Support' && wOrder.Work_Order_Type__c=='Business in a Box'){
                                        dim1 = dimension.Id;                                     
                                    }
                                }
                                
                                //Update Work Order
                                wo.Dimension_1__c=dim1;
                                UPDATE wo;                                
                                
                            }
                        }// End for loop
                        
                        opp.BIB_WO_Created__c = true;                        
                    }
                }
            }//End if(opp.BIB_WO_Created__c == false)
            
            //Check if this is a 'Basic FLT' Opportunity && No 'Structure' Work Order has been created
            if(opp.Basic_FLT__c == false && opp.Structure_WO_Created__c == false){
                
                List<Opportunity_WO_Item__c> items = [SELECT Id, Name, Inventory_Item__c, Item_Division__c, Quantity__c,
                                                      Opportunity_Item__r.InventoryItem__r.unit_cost__c,Opportunity_Item__r.InventoryItem__r.Currency_Config__c
                                                      FROM Opportunity_WO_Item__c
                                                      WHERE Opportunity__c = :opp.Id
                                                      AND Item_Division__c='aEBD0000000kA4j'];
                
                if(items.size() > 0){
                    
                    Map<String, List<Opportunity_WO_Item__c>> itemMap = new Map<String, List<Opportunity_WO_Item__c>>();
                    
                    for(Opportunity_WO_Item__c item : items){
                        List<Opportunity_WO_Item__c> itemList = itemMap.get(item.Item_Division__c);
                        
                        if(itemList != null){
                            itemList.add(item);
                            System.debug('OPPORTUNITY WORK ORDER ITEM: ' + item.Name + ',' + item.Item_Division__c);
                        } else {
                            itemList = new  List<Opportunity_WO_Item__c>();
                            itemList.add(item);
                            itemMap.put(item.Item_Division__c, itemList);
                        }
                    }
                    
                    if(itemMap.size() > 0){
                        
                        Set<String> keys = itemMap.keySet();
                        
                        for(String key: keys){
                            System.debug('WORK ORDER COMPANY KEY: ' + key);
                            List<Opportunity_WO_Item__c> itemList = itemMap.get(key);
                            
                            if(itemList.size() > 0){
                                
                                String itemId = fliStructItem;
                                
                                System.debug('COMPANY: ' + fliDivision);
                                System.debug('ITEM ID: ' +itemId);
                                
                                if(key.equals(fliDivision)){
                                    itemId = fliStructItem;
                                }
                                
                                Work_Order__c wo = new Work_Order__c(
                                    Inventory_Item__c = itemId,
                                    Site__c = inventorySiteMukuru ,
                                    Inventory_Item_Quantity__c = opp.FLTs_Approved__c,
                                    Company__c= key,
                                    Opportunity__c = opp.Id,
                                    Status__c = 'Firmed'
                                );
                                
                                insert wo;
                                System.debug('WORK ORDER ******************');
                                List<Work_Order_Item__c> wo_comps = new List<Work_Order_Item__c>();
                                
                                Map<String, Work_Order_Item__c > mergedItems = new Map<String, Work_Order_Item__c >();
                                
                                for(Opportunity_WO_Item__c itms : itemList){
                                    
                                    Work_Order_Item__c cmp = mergedItems.get(itms.Inventory_Item__c);
                                    
                                    if(cmp == null){
                                        
                                        cmp = new Work_Order_Item__c(
                                            Work_Order__c = wo.Id,
                                            Inventory_Item__c = itms.Inventory_Item__c,
                                            BOM_Quantity__c = itms.Quantity__c,
                                            Unit_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c,
                                            Currency__c = itms.Opportunity_Item__r.InventoryItem__r.Currency_Config__c,
                                            Planned_Material_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c * itms.Quantity__c
                                        );
                                        
                                        wo_comps.add(cmp);
                                        mergedItems.put(itms.Inventory_Item__c, cmp);
                                        
                                    } else{
                                        cmp.BOM_Quantity__c=cmp.BOM_Quantity__c+itms.Quantity__c;
                                        cmp.Planned_Material_Cost__c=cmp.BOM_Quantity__c * cmp.Unit_Cost__c;
                                    }
                                }//End Opportunity_WO_Item__c FOR LOOP
                                
                                if(wo_comps.size() > 0){
                                    System.debug(JSON.serialize(wo_comps));
                                    insert wo_comps;
                                }
                                
                                //Create Opportunity_Work_Order__c
                                Opportunity_Work_Order__c wOrder = new Opportunity_Work_Order__c();
                                wOrder.Opportunity__c = opp.Id;
                                wOrder.WorkOrder__c = wo.Id;
                                wOrder.Work_Order_Type__c = 'Structure';
                                INSERT wOrder;
                                
                                // Loop through c2g__codaDimension1__c
                                for(c2g__codaDimension1__c dimension : dimensions){
                                    // Check if Work order type = Structure                                    
                                    if(dimension.Name=='Fresh Life Operations - Installation' && wOrder.Work_Order_Type__c=='Structure'){
                                        dim1 = dimension.Id;                    
                                    }
                                }                                    
                                
                                //Update Work Order
                                wo.Dimension_1__c=dim1;
                                UPDATE wo;
                                
                            }
                        }// End for loop
                        
                        opp.Structure_WO_Created__c = true;
                    }
                }
            }// End if(opp.Basic_FLT__c == false && opp.Structure_WO_Created__c == false)         
                 
            //Check if this is a 'Basic FLT' Opportunity && No 'Basic FLT' Work Order has been created
            if(opp.Basic_FLT__c == true && opp.Basic_FLT_WO_Created__c == false){
                
                //Get Opportunity_WO_Items that belong to Fresh Life
                List<Opportunity_WO_Item__c> items = [SELECT Id, Name, Inventory_Item__c, Item_Division__c, Quantity__c,Opportunity_Item__r.Name,
                                                      Opportunity_Item__r.InventoryItem__r.unit_cost__c,Opportunity_Item__r.InventoryItem__r.Currency_Config__c,
                                                      Opportunity_Item__r.Grouping__c
                                                      FROM Opportunity_WO_Item__c
                                                      WHERE Opportunity__c = :opp.Id
                                                      AND Item_Division__c='aEBD0000000kA4j'];
                System.debug('Basic FLT --> Opportunity_WO_Item__c === ' + items);
                
                if(items.size() > 0){
                    
                    Map<String, List<Opportunity_WO_Item__c>> itemMap = new Map<String, List<Opportunity_WO_Item__c>>();
                    
                    for(Opportunity_WO_Item__c item : items){
                        List<Opportunity_WO_Item__c> itemList = itemMap.get(item.Item_Division__c);
                        
                        if(itemList != null){
                            itemList.add(item);
                            System.debug('OPPORTUNITY WORK ORDER ITEM: ' + item.Name + ',' + item.Item_Division__c);
                        } else {
                            itemList = new  List<Opportunity_WO_Item__c>();
                            itemList.add(item);
                            itemMap.put(item.Item_Division__c, itemList);
                        }
                    }
                    
                    if(itemMap.size() > 0){
                        
                        Set<String> keys = itemMap.keySet();
                        
                        for(String key: keys){
                            System.debug('WORK ORDER COMPANY KEY: ' + key);
                            List<Opportunity_WO_Item__c> itemList = itemMap.get(key);
                            
                            if(itemList.size() > 0){
                                
                                String itemId = fliBasicFLTItem;
                                
                                System.debug('COMPANY: ' + fliDivision);
                                System.debug('ITEM ID: ' +itemId);
                                
                                if(key.equals(fliDivision)){
                                    itemId = fliBasicFLTItem;
                                }
                                
                                Work_Order__c wo = new Work_Order__c(
                                    Inventory_Item__c = itemId,
                                    Site__c = inventorySiteMukuru ,
                                    Inventory_Item_Quantity__c = opp.FLTs_Approved__c,
                                    Company__c= key,
                                    Opportunity__c = opp.Id,
                                    Status__c = 'Firmed'
                                );
                                
                                insert wo;
                                System.debug('WORK ORDER ******************');
                                List<Work_Order_Item__c> wo_comps = new List<Work_Order_Item__c>();
                                
                                Map<String, Work_Order_Item__c > mergedItems = new Map<String, Work_Order_Item__c >();
                                
                                for(Opportunity_WO_Item__c itms : itemList){
                                    
                                    Work_Order_Item__c cmp = mergedItems.get(itms.Inventory_Item__c);
                                    
                                    if(cmp == null){
                                        
                                        cmp = new Work_Order_Item__c(
                                            Work_Order__c = wo.Id,
                                            Inventory_Item__c = itms.Inventory_Item__c,
                                            BOM_Quantity__c = itms.Quantity__c,
                                            Unit_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c,
                                            Currency__c = itms.Opportunity_Item__r.InventoryItem__r.Currency_Config__c,
                                            Planned_Material_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c * itms.Quantity__c
                                        );
                                        
                                        wo_comps.add(cmp);
                                        mergedItems.put(itms.Inventory_Item__c, cmp);
                                        
                                    } else{
                                        cmp.BOM_Quantity__c=cmp.BOM_Quantity__c+itms.Quantity__c;
                                        cmp.Planned_Material_Cost__c=cmp.BOM_Quantity__c * cmp.Unit_Cost__c;
                                    }
                                }//End Opportunity_WO_Item__c FOR LOOP
                                
                                if(wo_comps.size() > 0){
                                    System.debug(JSON.serialize(wo_comps));
                                    insert wo_comps;
                                }
                                
                                //Create Opportunity_Work_Order__c
                                Opportunity_Work_Order__c wOrder = new Opportunity_Work_Order__c();
                                wOrder.Opportunity__c = opp.Id;
                                wOrder.WorkOrder__c = wo.Id;
                                wOrder.Work_Order_Type__c = 'Basic FLT';
                                INSERT wOrder;
                                
                                // Loop through c2g__codaDimension1__c
                                for(c2g__codaDimension1__c dimension : dimensions){
                                    // Check if Work order type = Structure                                    
                                    if(dimension.Name=='Fresh Life Operations - Installation' && wOrder.Work_Order_Type__c=='Basic FLT'){
                                        dim1 = dimension.Id;                    
                                    }
                                }                                    
                                
                                //Update Work Order
                                wo.Dimension_1__c=dim1;
                                UPDATE wo;
                                
                            }
                        }// End for loop
                        
                        opp.Basic_FLT_WO_Created__c = true;
                    }
                }
            }// End if(opp.Basic_FLT__c == true && opp.Basic_FLT_WO_Created__c == false)
          
            //Check if this is a Pit Conversion Opportunity
            if(opp.Pit_Conversion__c == true){
                
                //Check if Pit Conversion Items have been approved
                if(opp.Pit_Conversion_Items_Approved__c){                
                    
                    //Check if Pit Conversion Work Order has been created
                    if(!opp.Pit_Conversion_WO_Created__c){
                        
                        List<Pit_Conversion_Item__c> items = [SELECT Id, Name, Inventory_Item__c, Item_Division__c, Quantity__c,
                                                              Opportunity_Item__r.InventoryItem__r.unit_cost__c,
                                                              Opportunity_Item__r.InventoryItem__r.Currency_Config__c
                                                              FROM Pit_Conversion_Item__c
                                                              WHERE Opportunity__c = :opp.Id
                                                              AND Item_Division__c='aEBD0000000kA4j'];
                        
                        if(items.size() > 0){
                            
                            Map<String, List<Pit_Conversion_Item__c>> itemMap = new Map<String, List<Pit_Conversion_Item__c>>();
                            
                            for(Pit_Conversion_Item__c item : items){
                                List<Pit_Conversion_Item__c> itemList = itemMap.get(item.Item_Division__c);
                                
                                if(itemList != null){
                                    itemList.add(item);
                                } else {
                                    itemList = new  List<Pit_Conversion_Item__c>();
                                    itemList.add(item);
                                    itemMap.put(item.Item_Division__c, itemList);
                                }
                            }
                            if(itemMap.size() > 0){
                                
                                Set<String> keys = itemMap.keySet();
                                
                                for(String key: keys){
                                    
                                    List<Pit_Conversion_Item__c> itemList = itemMap.get(key);
                                    
                                    if(itemList.size() > 0){
                                        
                                        String itemId = fliPitItem;
                                        
                                        if(key.equals(fliDivision)){
                                            itemId = fliPitItem;
                                        }
                                        
                                        Work_Order__c wo = new Work_Order__c();
                                        wo.Inventory_Item__c = itemId;
                                        wo.Site__c = inventorySiteMukuru;
                                        wo.Inventory_Item_Quantity__c = opp.No_of_approved_pit_s_to_be_converted__c;
                                        wo.Company__c = key;
                                        wo.Opportunity__c = opp.Id;
                                        wo.Status__c = 'Firmed'; 
                                        INSERT wo;
                                        
                                        List<Work_Order_Item__c> wo_comps = new List<Work_Order_Item__c>();
                                        
                                        Map<String, Work_Order_Item__c > mergedItems = new Map<String, Work_Order_Item__c >();
                                        
                                        for(Pit_Conversion_Item__c itms : itemList){
                                            
                                            // Create Work Order Item Instance
                                            Work_Order_Item__c cmp = mergedItems.get(itms.Inventory_Item__c);
                                            
                                            if(cmp == null){
                                                
                                                // Create Work Order Item
                                                cmp = new Work_Order_Item__c();
                                                cmp.Work_Order__c = wo.Id;
                                                cmp.Inventory_Item__c = itms.Inventory_Item__c;
                                                cmp.BOM_Quantity__c = itms.Quantity__c;
                                                cmp.Unit_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c;
                                                cmp.Currency__c = itms.Opportunity_Item__r.InventoryItem__r.Currency_Config__c;
                                                cmp.Planned_Material_Cost__c = itms.Opportunity_Item__r.InventoryItem__r.unit_cost__c * itms.Quantity__c;                                        
                                                
                                                wo_comps.add(cmp);
                                                mergedItems.put(itms.Inventory_Item__c, cmp);
                                                
                                            } else{
                                                cmp.BOM_Quantity__c = cmp.BOM_Quantity__c + itms.Quantity__c;
                                                cmp.Planned_Material_Cost__c = cmp.BOM_Quantity__c * cmp.Unit_Cost__c;
                                            }
                                        }
                                        
                                        if(wo_comps.size() > 0){
                                            System.debug(JSON.serialize(wo_comps));
                                            INSERT wo_comps;
                                        }
                                        
                                        // Create Opportunity Work Order
                                        Opportunity_Work_Order__c wOrder = new Opportunity_Work_Order__c();
                                        wOrder.Opportunity__c = opp.Id;
                                        wOrder.WorkOrder__c = wo.Id;
                                        wOrder.Work_Order_Type__c = 'Pit Conversion';                         
                                        INSERT wOrder;
                                        
                                        // Loop through c2g__codaDimension1__c
                                        for(c2g__codaDimension1__c dimension : dimensions){
                                            // Check if Work_Order_Type__c ='Pit Conversion'                                    
                                            if(dimension.Name=='Pit Conversion' && wOrder.Work_Order_Type__c=='Pit Conversion'){
                                                dim1 = dimension.Id;                    
                                            }
                                        }
                                        
                                        //Update Work Order
                                        wo.Dimension_1__c=dim1;
                                        UPDATE wo;                                
                                    }
                                }
                                opp.Pit_Conversion_WO_Created__c = true;
                            }
                        }
                    }//end pitWoCreated
                    
                    UPDATE opp;
                    
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Pit Conversion Approval.'));
                }//end pitApproved
                
            }//End if(opp.Pit_Conversion__c == true)      
            
            //Update Opportunity
            UPDATE opp;
            
            // Redirect to the opportunity Record
            return new PageReference('/' + opp.Id);
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'All approvals need to be done before you can continue with this process'));
            
            if(!opp.Engineering_Items_Approved__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Engineering Approval'));
            }
            
            if(!opp.Marketing_Items_Approved__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Marketing Approval'));
            }
            
            if(!opp.BIB_Items_Approved__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Operations Approval'));
            }
            
            /*if(!pitApproved){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Missing Pit Conversion Approval'));
            }*/
            
            // Warn the user if (s)he tries to create another Work Order
            if(opp.Structure_WO_Created__c == true || opp.BIB_WO_Created__c == true || opp.Pit_Conversion_WO_Created__c == true || opp.Basic_FLT_WO_Created__c == true){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Work Order(s) already exist.\n You can\'t run this process again.'));
            }            
        }
        return null;
    }
    
}