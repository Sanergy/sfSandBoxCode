global class InventoryItemsReplenisher implements Database.Batchable<sObject>,Database.Stateful
{

    public Boolean success;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       
        this.success= false;
        String query = 'SELECT id,Inventory_Stock__c,Minimum_Quantity__c, Policy_Quantity__c,Default_Site__c,Planning_Policy__c,Pending_Replenishment_Quantity__c,Item_Source__c,Item_Company__c FROM Inventory_Item__c WHERE Requires_Replenishment__c = true';
        
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<Inventory_Item__c> itemsToCreate)
    {
       if(itemsToCreate.size() > 0){
        
            List<RecordType> purchaseRecordType = [SELECT id FROM RecordType
                                                   WHERE Name = 'Purchase Request Replenishment'
                                                   AND SObjectType = 'Inventory_Replenishment_Tracker__c'];
                                                   
            List<RecordType> manufactureRecordType = [SELECT id FROM RecordType
                                                     WHERE Name = 'Work Order Replenishment'
                                                     AND SObjectType = 'Inventory_Replenishment_Tracker__c'];
            
            Map<String, Sanergy_Settings_Supply_Chain__c> settings = Sanergy_Settings_Supply_Chain__c.getAll();
            
            List<Purchase_Order_Item__c> poItems = [SELECT id,Gross_Value__c, UOM_Conversion_Factor__c,Item_Cost__c,Vatable__c,VAT_Inclusive__c,VAT_Percentage__c,
                                                   Currency__c, Vendor__c,Inventory_Item__c, Inventory_Item__r.Item_Source__c, inventory_item__r.Policy_Quantity__c,
                                                   Inventory_Item__r.Item_Description__c,Inventory_Item__r.Item_Company__c
                                                   FROM Purchase_Order_Item__c
                                                   WHERE Vendor_Type__c = 'Primary'
                                                   AND Primary_Vendor__c =  true
                                                   AND Inventory_Item__c IN :itemsToCreate
                                                   AND Inventory_Item__r.Item_Source__c = 'Purchased'];
            
            List<Inventory_Replenishment_Tracker__c> trackerList = new List<Inventory_Replenishment_Tracker__c>();
            
            //Purchase Requests                                      
            if(poItems.size() > 0){
                List<PTS_Line_Item__c> prLines = new List<PTS_Line_Item__c>();
                
                Procurement_Tracking_Sheet__c pr =  new Procurement_Tracking_Sheet__c(
                    Requestor_Type__c = 'Reorder Level',
                    Requestor__c = settings.get('WH Inventory Requestor').value__c,//Basil Warehouse Officer
                    Required_Date__c = Date.today() + 14,
                    Requesting_Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                    Maintenance_Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                    Requesting_Company__c = poItems.get(0).Inventory_Item__r.Item_Company__c,                    
                    Next_Step__c = 'Pending Team Lead Approval',
                    Stage__c = 'Open',
                    Priority__c = 'High',
                    Is_Retrospective__c	 = 'No',
                    High_Priority_Comments__c = 'Generated from Inventory Replenisher'           
                );
                   
                   
                insert pr; 
                for(Purchase_Order_Item__c item : poItems ){
                       
                    Decimal quantityAfterUoM = item.Inventory_Item__r.Policy_Quantity__c / ((item.UOM_Conversion_Factor__c==null || item.UOM_Conversion_Factor__c<1) ? 1 : item.UOM_Conversion_Factor__c) ;
                    //Create PR 
                    
                    //Create PR Lines
                    PTS_Line_Item__c pLines= new PTS_Line_Item__c(
                        Item__c = item.Inventory_Item__r.Item_Description__c,
                        Specifications__c = item.Inventory_Item__r.Item_Description__c,
                        Department__c = settings.get('Dimension 1 - Supply Chain').value__c,
                        Dim_2__c = settings.get('Dimension 2 - Mukuru').value__c,
                        Dim_3__c = settings.get('Dimension 3 - Not Applicable').value__c,
                        Grant__c = settings.get('Dimension 4 - Not Applicable').value__c,
                        GLA__c = settings.get('GLA - Inventory Items').value__c,
                        Requesting_Company__c = item.Inventory_Item__r.Item_Company__c ,//settings.get('Company - Sanergy').value__c,
                        Quantity__c = item.Inventory_Item__r.Policy_Quantity__c,
                        Budget_Amount__c = (quantityAfterUoM  * item.Gross_Value__c ),
                        Currency_Config__c = item.Currency__c,
                        Vendor__c = item.Vendor__c,
                        Inventory_Item__c = item.Inventory_Item__c,
                        Purchase_Order_Item__c = item.id,
                        Quote_Currency__c = item.Currency__c,
                        Unit_Quote_Price__c = item.Item_Cost__c,
                        Vatable__c = item.Vatable__c,
                        VAT_Inclusive__c = item.VAT_Inclusive__c,
                        VAT_Percentage__c = item.VAT_Percentage__c,
                        Procurement_Tracking_Sheet__c = pr.id,
                        RequestType__c = 'Stock'
                    );
                    
                    prLines.add(pLines);
                    
                }
                
                insert prLines;
                
                Set<id> prLinesInserted = new Set<id>();
                
                for(PTS_Line_Item__c  line : prLines){
                    prLinesInserted.add(line.id); 
                }
                
                prLines = [SELECT Quantity_Remaining__c, id, Inventory_Item_Id__c,UoM_conversion_factor__c
                           FROM PTS_Line_Item__c  
                           WHERE id IN : prLinesInserted ];
                
                for(PTS_Line_Item__c  line : prLines){
                    Inventory_Replenishment_Tracker__c tracker = new Inventory_Replenishment_Tracker__c(
                        recordTypeId = purchaseRecordType.get(0).id,
                        Inventory_Item__c = line.Inventory_Item_Id__c,
                        Procurement_Request_Line_Item__c = line.id,
                        Quantity_Pending__c = line.Quantity_Remaining__c           
                    );
                                        
                    trackerList.add(tracker);
                }
                
            
            }
            
            //Manufacturing Requests
            List<Inventory_Item__c> itemsToManufacture = new List<Inventory_Item__c>();
            
            List<Work_Order__c> woList = new List<Work_Order__c>();
            
            for(Inventory_Item__c i : itemsToCreate){
                if(i.Item_Source__c == 'Manufactured'){
                    itemsToManufacture.add(i);  
                }
            }
            
            if(itemsToManufacture.size() > 0){
                for(Inventory_Item__c i : itemsToManufacture ){
                    Work_Order__c wo = new Work_Order__c(
                        Inventory_Item__c = i.id,
                        Inventory_Item_Quantity__c = i.Policy_Quantity__c,
                        Site__c = i.Default_Site__c,
                        Company__c = i.Item_Company__c,
                        Work_Order_Type__c = 'WO-Manufactured',
                        Status__c = 'Planned'
                    );
                    
                    woList.add(wo);
                }
                
                insert woList;
                
                
                for(Work_Order__c wo : woList){
                    Inventory_Replenishment_Tracker__c tracker = new Inventory_Replenishment_Tracker__c(
                        recordTypeId = manufactureRecordType.get(0).id,
                        Inventory_Item__c = wo.Inventory_Item__c,
                        Work_Order__c = wo.id,
                        Quantity_Pending__c = wo.Inventory_Item_Quantity__c 
                    );
                    
                    trackerList.add(tracker);
                }
            }
            
            if(trackerList.size() > 0){
                insert trackerList;
            }
        }
        
        this.success= true;
    }  
    global void finish(Database.BatchableContext BC){
        
        String resultMessage = 'successful';
        
        if(this.success == false){
            resultMessage = ' not successful';
        }
        
        List<User> u = [SELECT email, name FROM USER WHERE id= :UserInfo.getUserId()];
        
        if(u.size() > 0 && u.get(0).email != null){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { u.get(0).email};
            message.subject = 'Inventory Replenish Batch Job results';
            message.plainTextBody = 'Inventory Replenish Batch Job run by user '+u.get(0).name+' at '+DateTime.now()+ ' was'+ resultMessage;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
        }
        
    }
}