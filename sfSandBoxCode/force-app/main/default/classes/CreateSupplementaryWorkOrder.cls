public class CreateSupplementaryWorkOrder {
    
    //Standard Controller
    private ApexPages.StandardController controller;
    
    // Opportunity
    @TestVisible public Opportunity opportunity {get; set;}
    
    //OpportunityWorkOrderItem
    public Opportunity_WO_Item__c del;
    @TestVisible public List<Opportunity_WO_Item__c> opportunityWorkOrderItemsPendingApprovalList {get; set;}
    @TestVisible public List<Opportunity_WO_Item__c> opportunityWorkOrderItemList {get; set;}
    @TestVisible public List<Opportunity_BIB_Item__c> opportunityBibItemsList{get; set;}
    @TestVisible public List<Opportunity_BIB_Item__c> bibItemsPendingApprovalList {get; set;}
    public OpportunityItem itemsToDelete;
    @TestVisible public List<Opportunity_Item__c> opportunityItemList {get; set;}
    @TestVisible public List<Opportunity_Item__c> deleteOpportunityItemList {get; set;}
    @TestVisible public List<OpportunityItem> opportunityItemWrapperClassList {get; set;}
    @TestVisible public List<OpportunityItem> deleteOpportunityItemWrapperClassList {get; set;}
    
    
    public Integer totalCount {get;set;}
    public Integer rowIndex {get;set;}  
    public Boolean checkInitialWorkOrdersCreated {get; set;}
    public Boolean displayCreateWorkOrderButton{get; set;}    
    // Get all the Sanergy Settings we have in custom settings.
    Map<String, Sanergy_Settings__c> sanergySettings = Sanergy_Settings__c.getAll();
    String loggedInUserID = UserInfo.getUserId();
    String loggedInUserEmail = UserInfo.getUserEmail();
    String authorizedUsers {get; set;}
    List<String> authorizedUsersList{get; set;}
    
    // Constructor
    public CreateSupplementaryWorkOrder(ApexPages.StandardController controller){
        
        this.controller = controller;
        this.opportunity = (Opportunity)controller.getRecord();
        
        this.opportunity =[SELECT Id,Name,Area__c,Sub_Area_Lookup__c,Sub_Area_Lookup__r.Name,Area_Name__c,
                           Area_Name__r.Last_Location_No__c,StageName,Franchise_Type__c,Next_Stage__c,
                           Primary_Salesperson__c,Primary_Salesperson__r.Name,Account.Name,Location__c,Location__r.Name,
                           Sub_Area_Lookup__r.Area_Name__r.Area_Abbreviation__c,Location__r.Last_FLT__c,
                           Sub_Area_Lookup__r.Area_Name__r.Last_Location_No__c,No_of_FLTs__c,OwnerId,
                           Basic_FLT__c,BIB_Items_Approved__c,Engineering_Items_Approved__c,
                           Marketing_Items_Approved__c,Pit_Conversion_Items_Approved__c,Structure_WO_Created__c,
                           BIB_WO_Created__c,Pit_Conversion_WO_Created__c,Basic_FLT_WO_Created__c,FLTs_Approved__c,
                           Pit_Conversion__c,No_of_approved_pit_s_to_be_converted__c,Upstructure_required__c,
                           Upstructures_Required__c,Existing_Location__c
                           FROM Opportunity
                           WHERE Id =: opportunity.Id ];
        
        //Check if original work orders have been created & render the page if true
        if((opportunity.Structure_WO_Created__c == true && opportunity.BIB_WO_Created__c == true) || 
           (opportunity.Basic_FLT_WO_Created__c == true && opportunity.BIB_WO_Created__c == true)){               
               
               checkInitialWorkOrdersCreated = true;
               
               opportunityItemList = new List<Opportunity_Item__c>();
               opportunityItemWrapperClassList = new List<OpportunityItem>();
               deleteOpportunityItemWrapperClassList = new List<OpportunityItem>();
               
               //Initialize total count
               totalCount = opportunityItemWrapperClassList.size();
               
               //Clear the List if its not empty
               if(totalCount > 0){
                   opportunityItemWrapperClassList.clear();
               }
               
               //Loop through the Sanergy Settings
               for(Sanergy_Settings__c settings : sanergySettings.values()) {
                   if (settings.Name == 'Supplementary Work Order Approvers') {                
                       authorizedUsers = settings.Value__c;                
                   }//End if (settings.Name == 'Supplementary Work Order Approvers')
               }//End for(Sanergy_Settings__c settings : sanergySettings.values())
               
               //Split the values stored in 'Supplementary Work Order Approvers' setting
               authorizedUsersList = authorizedUsers.split(',');
               System.debug('PERMITTED USERS: = ' + authorizedUsers);
               System.debug('PERMITTED USERS LIST: = ' + authorizedUsersList);
               
               for (String authorizedUserID : authorizedUsersList) {
                   
                   if(loggedInUserID == authorizedUserID){
                       
                       displayCreateWorkOrderButton = true;
                       
                       // Get Opportunity Work Order Items pending approval
                       getOpportunityWorkOrderItemsPendingApproval();
                       
                       // Get BIB Items pending approval
                       getBIBItemsPendingApproval();
                       
                   }//End if(loggedInUserID == authorizedUser)
                   
                   System.debug('loggedInUserID: =' + loggedInUserID);
                   System.debug('authorizedUserID: =' + authorizedUserID);
               }//End for (String authorizedUserId : authorizedUsersList)
               
           }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You cannot proceed creating supplementary work orders! \n Run the original work orders.'));
        }//End if((opportunity.Structure_WO_Created__c == true && opportunity.BIB_WO_Created__c == true)
    }//End CreateSupplementaryWorkOrder(ApexPages.StandardController controller)
	    
    // Get BIB Items pending approval
    public List<Opportunity_BIB_Item__c> getBIBItemsPendingApproval(){
        
        bibItemsPendingApprovalList = new List<Opportunity_BIB_Item__c>();
        
        List<Opportunity_BIB_Item__c> bibItems = [SELECT Id,Name,Opportunity__c,Opportunity__r.Name,
                                                  Opportunity_Item__r.Name,Opportunity_Item__c,Approved_Supplementary_Item__c,
                                                  Item_Group__c,Quantity__c,Opportunity_Item__r.InventoryItem__r.Name,
                                                  Opportunity_Item__r.Description__c,Item_Division__c,Inventory_Item__c,
                                                  Opportunity_Item__r.InventoryItem__r.unit_cost__c,
                                                  Opportunity_Item__r.InventoryItem__r.Currency_Config__c,
                                                  Opportunity_Item__r.Add_Item_Linearly__c
                                                  FROM Opportunity_BIB_Item__c
                                                  WHERE Opportunity__c =: opportunity.Id
                                                  AND Approved_Supplementary_Item__c = false
                                                  AND Opportunity_Item__r.Description__c = 'Supplementary Item'
                                                  AND Item_Group__c = 'BIB Package'
                                                  ORDER BY Name];
        
        if(bibItems.size() > 0){
            for(Opportunity_BIB_Item__c bib : bibItems){                
                //Add all records to the list
                bibItemsPendingApprovalList.add(bib);
            }//End for(Opportunity_BIB_Item__c bib : bibItems)
            
            return bibItemsPendingApprovalList;
        }else{            
            return null;
        }//End if(bibItems.size() > 0)
    }
    
    // Get Opportunity Work Order Items pending approval
    public List<Opportunity_WO_Item__c> getOpportunityWorkOrderItemsPendingApproval(){
        
        opportunityWorkOrderItemsPendingApprovalList = new List<Opportunity_WO_Item__c>();
        
        List<Opportunity_WO_Item__c> oppWorkOrderItems = [SELECT Id,Name,Opportunity__c,Opportunity__r.Name,
                                                          Opportunity_Item__r.Name,Opportunity_Item__c,Approved_Supplementary_Item__c,
                                                          Item_Group__c,Quantity__c,Opportunity_Item__r.InventoryItem__r.Name,
                                                          Opportunity_Item__r.Description__c,Item_Division__c,Inventory_Item__c,
                                                          Opportunity_Item__r.InventoryItem__r.unit_cost__c,
                                                          Opportunity_Item__r.InventoryItem__r.Currency_Config__c
                                                          FROM Opportunity_WO_Item__c
                                                          WHERE Opportunity__c =: opportunity.Id
                                                          AND Approved_Supplementary_Item__c = false
                                                          AND Opportunity_Item__r.Description__c = 'Supplementary Item'
                                                          AND (Item_Group__c = 'Structure Package'
                                                               OR Item_Group__c = 'Upstructure Package')
                                                          ORDER BY Name];
        
        if(oppWorkOrderItems.size() > 0){
            for(Opportunity_WO_Item__c oppWoItem : oppWorkOrderItems){                
                //Add all records to the list
                opportunityWorkOrderItemsPendingApprovalList.add(oppWoItem);
            }//End for(Opportunity_WO_Item__c woItem : oppWorkOrderItems)
            
            return opportunityWorkOrderItemsPendingApprovalList;
        }else{
            return null;
        }
    }
    
    // Add an item to the list
    public void addRow(){
        
        //Create an instance of Opportunity Item
        Opportunity_Item__c opportunityItem = new Opportunity_Item__c();        
        
        opportunityItemWrapperClassList.add(new OpportunityItem(opportunityItem));
        
        System.debug('ITEM ADDED :=> addRow() == '+ opportunityItemWrapperClassList);    
    }
    
    //Delete an item from the list    
    public void deleteRow(){
        
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        System.debug('rowbe deleted ' + rowIndex );
        System.debug('rowm to be deleted '+opportunityItemWrapperClassList[rowIndex]);
        itemsToDelete = opportunityItemWrapperClassList.remove(rowIndex);
        deleteOpportunityItemWrapperClassList.add(itemsToDelete);        
        
    }
    
    //Save items which are in the list
    public PageReference saveItems(){
        
        System.debug('saveItems()  --> BEFORE LOOP opportunityItemWrapperClassList: = '+ opportunityItemWrapperClassList);           
        
        //Check if wrapper class list is empty
        if(opportunityItemWrapperClassList.size() > 0 && opportunityItemWrapperClassList != null){
            
            for(OpportunityItem item : opportunityItemWrapperClassList){
                
                opportunityItemList.add(new Opportunity_Item__c(
                    Name = 'Item Name',
                    Description__c = 'Supplementary Item',
                    Grouping__c = item.itemGrouping,  
                    InventoryItem__c = item.oppItem.InventoryItem__c,
                    Default_Quantity__c = item.oppItem.Default_Quantity__c,
                    Add_Item_Linearly__c = item.oppItem.Add_Item_Linearly__c
                ));                
                
                //Create an instance of Opportunity Item
                /* Opportunity_Item__c opportunityItem = new Opportunity_Item__c(
                Name = 'Item Name',
                Description__c = 'Supplementary Item',
                Grouping__c = item.itemGrouping,  
                InventoryItem__c = item.oppItem.InventoryItem__c,
                Default_Quantity__c = item.oppItem.Default_Quantity__c
                ); */                
            }// End for(OpportunityItem oppItem : opportunityItemWrapperClassList)
            
            //Save the list of items
            INSERT opportunityItemList;
            
            System.debug('saveItems()  -->AFTER LOOP opportunityItemList: = ' + opportunityItemList);
            
            //Check if Opportunity Item List is empty
            if(opportunityItemList.size() > 0 && opportunityItemList != null){
                
                opportunityBibItemsList = new List<Opportunity_BIB_Item__c>();
                opportunityWorkOrderItemList = new List<Opportunity_WO_Item__c>();            
                
                for(Opportunity_Item__c opportunityItem : opportunityItemList){
                    
                    if(opportunityItem.Grouping__c == 'BIB Package' ){
                        if(opportunity.FLTs_Approved__c > 0 && opportunity.Existing_Location__c == true){
                            
                            // Check if Item is Linear
                            if(opportunityItem.Add_Item_Linearly__c == true){
                                
                                // Create Opportunity_BIB_Item__c
                                Opportunity_BIB_Item__c bib = new Opportunity_BIB_Item__c();
                                bib.Opportunity__c = opportunity.Id;
                                bib.Opportunity_Item__c = opportunityItem.Id;                            
                                bib.Quantity__c = opportunityItem.Default_Quantity__c * opportunity.FLTs_Approved__c;
                                
                                opportunityBibItemsList.add(bib);
                            }                        
                            
                        }// End if(opportunity.FLTs_Approved__c > 0 && opportunity.Existing_Location__c == true)
                        else if(opportunity.FLTs_Approved__c > 0 && opportunity.Existing_Location__c == false){
                            
                            // Create Opportunity_BIB_Item__c
                            Opportunity_BIB_Item__c bib2 = new Opportunity_BIB_Item__c();
                            bib2.Opportunity__c = opportunity.Id;
                            bib2.Opportunity_Item__c = opportunityItem.Id;                           
                            
                            // Check if Item is Linear
                            if(opportunityItem.Add_Item_Linearly__c){
                                bib2.Quantity__c = opportunityItem.Default_Quantity__c * opportunity.FLTs_Approved__c;
                            }else{
                                bib2.Quantity__c = opportunityItem.Default_Quantity__c;
                            }
                            
                            opportunityBibItemsList.add(bib2);                        
                            
                        }//End else if(opportunity.FLTs_Approved__c > 0 && opportunity.Existing_Location__c == false)
                        
                    }// End if(opportunityItem.Grouping__c == 'BIB Package' )
                    else if(opportunityItem.Grouping__c == 'Upstructure Package' && opportunity.Upstructure_required__c == true && opportunity.Upstructures_Required__c > 0 ){
                        
                        //Create Upstructure Opportunity WO Items
                        Opportunity_WO_Item__c upstructureOpportunityWOItem = new Opportunity_WO_Item__c();
                        upstructureOpportunityWOItem.Opportunity__c = opportunity.Id;
                        upstructureOpportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                        upstructureOpportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opportunity.Upstructures_Required__c);
                        
                        opportunityWorkOrderItemList.add(upstructureOpportunityWOItem);                         
                        
                    }//End else if(opportunityItem.Grouping__c == 'Upstructure Package' && opportunity.Upstructure_required__c == true && opportunity.Upstructures_Required__c > 0 )
                    else if(opportunityItem.Grouping__c == 'Structure Package' ){
                        
                        //Create Standard Opportunity WO Items
                        Opportunity_WO_Item__c standardOpportunityWOItem = new Opportunity_WO_Item__c();
                        standardOpportunityWOItem.Opportunity__c = opportunity.Id;
                        standardOpportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                        standardOpportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opportunity.FLTs_Approved__c);
                        
                        opportunityWorkOrderItemList.add(standardOpportunityWOItem); 
                    }//End else if(opportunityItem.Grouping__c == 'Structure Package' )
                }//End for(Opportunity_Item__c opportunityItem : opportunityItemList)
                
                if(opportunityBibItemsList.size() > 0){
                    
                    //Insert BIB Items
                    INSERT opportunityBibItemsList;
                    
                    System.debug('saveItems()  --> opportunityBibItemsList: = ' + opportunityBibItemsList);
                }//End if(opportunityBibItemsList.size() > 0)
                
                if(opportunityWorkOrderItemList.size() > 0){
                    
                    //Insert Opportunity WO Items
                    INSERT opportunityWorkOrderItemList;
                    
                    System.debug('saveItems()  --> opportunityWorkOrderItemList: = ' + opportunityWorkOrderItemList);   
                }//End if(opportunityWorkOrderItemList.size() > 0)
                
                if(opportunityWorkOrderItemList.size() > 0 || opportunityBibItemsList.size() > 0){
                    //Send Email
                    sendEmailNotification();
                }//End if((opportunityWorkOrderItemList.size() > 0) || if(opportunityBibItemsList.size() > 0))
                
            }//End if(opportunityItemList.size() > 0 && opportunityItemList != null)            
            
            // Redirect to the opportunity Record
            return new PageReference('/' + opportunity.Id);
        }
        else{            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No items found for saving!'));
            
            return null;
        }//End if(opportunityItemWrapperClassList.size() > 0 && opportunityItemWrapperClassList != null)        

    }//End saveItems()
    
    public void sendEmailNotification(){
        
        //Get Salesforce Instance URL
        String loggedInUsersName = UserInfo.getName();
        String loggedInUsersEmail = UserInfo.getUserEmail();
        String SalesforceCurrentInstanceURL = URL.getSalesforceBaseUrl().toExternalForm();
        String supplementaryWorkOrderURL = '/apex/CreateSupplementaryWorkOrder?scontrolCaching=1&id=';
        
        // Create a list to hold the emails we'll send
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();        
        
        // Create an instance of the Messaging.SingleEmailMessage class.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
        // Set the email sender
        mail.setReplyTo('noreply@saner.gy');
        mail.setSenderDisplayName('SALESFORCE');
        
        // Send email to recipient
        List<String> sendTo = new List<String>();
        sendTo.add('joab@saner.gy');
        mail.setToAddresses(sendTo);
        
        // Set people to be CCed
        List<String> ccTo = new List<String>();
        ccTo.add('basil@saner.gy');
        ccTo.add('jgithinji@saner.gy');
        mail.setBccAddresses(ccTo); 
        
        mail.setSubject('Supplementary Work Order Notification');           		   
        mail.setHtmlBody
            ('<p> Hi,</p>' +
             '<p>The following opportunity is awaiting creation of a supplementary work order.Items were added by ' + loggedInUsersName + '</p>' +
             '<h4>SUMMARY</h4>' +
             '<hr/>'+           
             '<p><strong>Opportunity: &nbsp;&nbsp;</strong>' +  opportunity.Name + '</p>' +
             '<p><strong>Stage: &nbsp;&nbsp;</strong>' +  opportunity.StageName  + '</p>' +
             '<p><strong>Location: &nbsp;&nbsp;</strong>' +  opportunity.Location__r.Name + '</p>' +
             '<p><strong>No. of FLTs Approved: &nbsp;&nbsp;</strong>' +  opportunity.FLTs_Approved__c + '</p>' +
             '<p><strong>Is an Upstructure required: &nbsp;&nbsp;</strong>' +  opportunity.Upstructure_required__c + '</p>' +
             '<p><strong>No. of Upstructures Required: &nbsp;&nbsp;</strong>' +  opportunity.Upstructures_Required__c + '</p>'+
             '<p>For more details visit ' + SalesforceCurrentInstanceURL + supplementaryWorkOrderURL + opportunity.Id +' </p>' +
             '<hr/>'+
             '<p style="color:red; font-size:70%;"></p>');
        
        mails.add(mail);
        
        Messaging.sendEmail(mails);        
        
        System.debug(mails); 
        
    }    
    
    public PageReference createWorkOrders(){
        
        System.debug('createWorkOrders() --- > bibItemsPendingApprovalList: 1 = ' + bibItemsPendingApprovalList);
        System.debug('createWorkOrders() --- > opportunityWorkOrderItemsPendingApprovalList: 1 = ' + opportunityWorkOrderItemsPendingApprovalList);
        
        if(bibItemsPendingApprovalList.size() > 0){
            UPDATE bibItemsPendingApprovalList;
        }
        
        if(opportunityWorkOrderItemsPendingApprovalList.size() > 0){
            UPDATE opportunityWorkOrderItemsPendingApprovalList;
        }
        
        System.debug('createWorkOrders() --- > bibItemsPendingApprovalList: 2 = ' + bibItemsPendingApprovalList);
        System.debug('createWorkOrders() --- > opportunityWorkOrderItemsPendingApprovalList: 2 = ' + opportunityWorkOrderItemsPendingApprovalList);
        
        //Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll();
        String fliDivision = sanergySettings.get('FLIK Division Id').Value__c;
        String fliStructItem = sanergySettings.get('Structure FLI Item').Value__c;
        String fliBibItem = sanergySettings.get('Bib FLI Item').Value__c;
        String fliPitItem = sanergySettings.get('Pit Conversion FLI Item').Value__c;
        String fliBasicFLTItem = sanergySettings.get('Basic FLT FLI Item').Value__c;
        String inventorySiteMukuru = sanergySettings.get('Inventory Site - Mukuru').Value__c;
        String dim1;
        
        //Get Dimension 1
        List<c2g__codaDimension1__c> dimensions = [SELECT Id,Name
                                                   FROM c2g__codaDimension1__c
                                                   WHERE Name='Pit Conversion'
                                                   OR Name='Fresh Life - Customer Support'
                                                   OR Name='Fresh Life Operations - Installation'];
        
        //Check if 'BIB' Work Order has been created
        if(opportunity.BIB_WO_Created__c == true){
            
            System.debug('INSIDE if(opportunity.BIB_WO_Created__c == true) : = ' + bibItemsPendingApprovalList);
            
            if(bibItemsPendingApprovalList.size() > 0){
                
                System.debug('INSIDE if(bibItemsPendingApprovalList.size() > 0) = ' + bibItemsPendingApprovalList);                
                
                Map<String, List<Opportunity_BIB_Item__c>> itemMap = new Map<String, List<Opportunity_BIB_Item__c>>();
                
                for(Opportunity_BIB_Item__c item : bibItemsPendingApprovalList){
                    
                    if(item.Approved_Supplementary_Item__c == true){
                        List<Opportunity_BIB_Item__c> itemList = itemMap.get(item.Item_Division__c);
                        
                        if(itemList != null){
                            itemList.add(item);
                        } else {
                            itemList = new  List<Opportunity_BIB_Item__c>();
                            itemList.add(item);
                            itemMap.put(item.Item_Division__c, itemList);
                        }
                    }//End if(item.Approved_Supplementary_Item__c == true)
                }//End for(Opportunity_BIB_Item__c item : approvedBIBItemsList)
                if(itemMap.size() > 0){
                    
                    Set<String> keys = itemMap.keySet();
                    
                    for(String key: keys){
                        
                        List<Opportunity_BIB_Item__c> itemList = itemMap.get(key);
                        
                        if(itemList.size() > 0){
                            
                            String itemId = fliBibItem;
                            
                            if(key.equals(fliDivision)){
                                itemId = fliBibItem;
                            }//End if(key.equals(fliDivision))
                            
                            Work_Order__c wo = new Work_Order__c(
                                Inventory_Item__c = itemId,
                                Site__c = inventorySiteMukuru ,
                                Inventory_Item_Quantity__c =  opportunity.FLTs_Approved__c,
                                Company__c= key,
                                Opportunity__c = opportunity.Id,
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
                                }//End if(cmp == null)
                            }
                            
                            if(wo_comps.size() > 0){
                                System.debug(JSON.serialize(wo_comps));
                                insert wo_comps;
                            }//End if(wo_comps.size() > 0)
                            
                            //Create Opportunity_Work_Order__c
                            Opportunity_Work_Order__c wOrder = new Opportunity_Work_Order__c();
                            wOrder.Opportunity__c = opportunity.Id;
                            wOrder.WorkOrder__c = wo.Id;
                            wOrder.Work_Order_Type__c = 'Business in a Box';
                            INSERT wOrder;
                            
                            // Loop through c2g__codaDimension1__c
                            for(c2g__codaDimension1__c dimension : dimensions){                                    
                                // Check if Work_Order_Type__c ='Business in a Box'                                    
                                if(dimension.Name=='Fresh Life - Customer Support' && wOrder.Work_Order_Type__c=='Business in a Box'){
                                    dim1 = dimension.Id;                                     
                                }
                            }//End for(c2g__codaDimension1__c dimension : dimensions)
                            
                            //Update Work Order
                            wo.Dimension_1__c=dim1;
                            UPDATE wo;                                
                            
                        }
                    }// End for loop                      
                }
            } //End if(approvedBIBItemsList.size() > 0)           
            
        }//End if(opportunity.BIB_WO_Created__c == true)        
        
        //Check if this is a 'Basic FLT' Opportunity && 'Structure' Work Order has been created
        if(opportunity.Basic_FLT__c == false && opportunity.Structure_WO_Created__c == true){
            
            System.debug('INSIDE if(opportunity.Basic_FLT__c == false && opportunity.Structure_WO_Created__c == true) : = ' + opportunityWorkOrderItemsPendingApprovalList);
            
            if(opportunityWorkOrderItemsPendingApprovalList.size() > 0){
                
                System.debug('INSIDE if(opportunityWorkOrderItemsPendingApprovalList.size() > 0) = ' + opportunityWorkOrderItemsPendingApprovalList);
                
                Map<String, List<Opportunity_WO_Item__c>> itemMap = new Map<String, List<Opportunity_WO_Item__c>>();               
                
                for(Opportunity_WO_Item__c item : opportunityWorkOrderItemsPendingApprovalList){
                    if(item.Approved_Supplementary_Item__c == true){
                        
                        List<Opportunity_WO_Item__c> itemList = itemMap.get(item.Item_Division__c);
                        
                        System.debug('INSIDE for(Opportunity_WO_Item__c item : opportunityWorkOrderItemsPendingApprovalList): = ' + opportunityWorkOrderItemsPendingApprovalList);
                        
                        if(itemList != null){
                            itemList.add(item);
                            System.debug('OPPORTUNITY WORK ORDER ITEM: ' + item.Name + ',' + item.Item_Division__c);
                        } else {
                            itemList = new  List<Opportunity_WO_Item__c>();
                            itemList.add(item);
                            itemMap.put(item.Item_Division__c, itemList);
                        }
                    }//End if(item.Approved_Supplementary_Item__c == true)
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
                                Inventory_Item_Quantity__c = opportunity.FLTs_Approved__c,
                                Company__c= key,
                                Opportunity__c = opportunity.Id,
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
                            wOrder.Opportunity__c = opportunity.Id;
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
                }
            }// End if(opportunityWorkOrderItemList.size() > 0)
        }// End if(opp.Basic_FLT__c == false && opp.Structure_WO_Created__c == false)         
        
        //Check if this is a 'Basic FLT' Opportunity && 'Basic FLT' Work Order has been created
        if(opportunity.Basic_FLT__c == true && opportunity.Basic_FLT_WO_Created__c == true){            
            
            System.debug('INSIDE if(opportunity.Basic_FLT__c == true && opportunity.Basic_FLT_WO_Created__c == true) : = ' + opportunityWorkOrderItemsPendingApprovalList);
            
            if(opportunityWorkOrderItemsPendingApprovalList.size() > 0){
                
                System.debug('INSIDE if(opportunityWorkOrderItemsPendingApprovalList.size() > 0) = ' + opportunityWorkOrderItemsPendingApprovalList);                
                
                Map<String, List<Opportunity_WO_Item__c>> itemMap = new Map<String, List<Opportunity_WO_Item__c>>();
                
                for(Opportunity_WO_Item__c item : opportunityWorkOrderItemsPendingApprovalList){
                    if(item.Approved_Supplementary_Item__c == true){
                        
                        List<Opportunity_WO_Item__c> itemList = itemMap.get(item.Item_Division__c);
                        
                        System.debug('INSIDE for(Opportunity_WO_Item__c item : opportunityWorkOrderItemsPendingApprovalList): = ' + opportunityWorkOrderItemsPendingApprovalList);
                        
                        if(itemList != null){
                            itemList.add(item);
                            System.debug('OPPORTUNITY WORK ORDER ITEM: ' + item.Name + ',' + item.Item_Division__c);
                        } else {
                            itemList = new  List<Opportunity_WO_Item__c>();
                            itemList.add(item);
                            itemMap.put(item.Item_Division__c, itemList);
                        }
                    }//End if(item.Approved_Supplementary_Item__c == true)
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
                                Inventory_Item_Quantity__c = opportunity.FLTs_Approved__c,
                                Company__c= key,
                                Opportunity__c = opportunity.Id,
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
                            wOrder.Opportunity__c = opportunity.Id;
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
                    
                }
            }
        }// End if(opp.Basic_FLT__c == true && opp.Basic_FLT_WO_Created__c == false) 
        
        // Redirect to the opportunity Record
        return new PageReference('/' + opportunity.Id);
        
    }

    // Opportunity Item wrapper class
    public class OpportunityItem{        
        public Opportunity_Item__c oppItem {get; set;}
        public String itemGrouping {get; set;}
        public List<SelectOption> pickListValues {get; set;}
        
        //Constructor
        public OpportunityItem(Opportunity_Item__c item) {
            oppItem = item;
            
            //Set drop down values for Opportunity Item grouping
            pickListValues = new List<SelectOption>();
            pickListValues.add(new SelectOption('','---None---'));
            pickListValues.add(new SelectOption('Structure Package','Structure Package'));
            pickListValues.add(new SelectOption('Upstructure Package','Upstructure Package'));
            pickListValues.add(new SelectOption('BIB Package','BIB Package'));
            //pickListValues.add(new SelectOption('Pit Conversion Package','Pit Conversion Package'));
        }
    }
    
    /*public List<Opportunity_Item__c> getItemsAddedToList(List<Opportunity_Item__c> itemsAdded){
        opportunityItemList = itemsAdded;
        
        System.debug('ITEMS ADDED TO LIST 1 :=> getItemsAddedFromList() == ' + opportunityItemList);
        
        return opportunityItemList;
    }*/
    
    /*public void createAdditionalWorkOrder(){
        
        //Return the list of all items added via Visual Force Page        
        getItemsAddedToList(opportunityItemList);
        System.debug('GET ALL ITEMS ADDED TO THE LIST :=> createAdditionalWorkOrder() == ' + opportunityItemList);
        
        //Check if any items were added to the list
        if(opportunityItemList.size() > 0){
            
            //Create Work Orders
            createWorkOrders();
            
        }//End if(opportunityItemList.size() > 0)
        
    }*/    
    
    /*public List<SelectOption> getPickListValue()
        
    {
        
        List<SelectOption> optionsToSelect = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity_Item__c.Grouping__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple)
            
        {
            
            if(f.getValue() == 'Supplementary Item' || f.getValue() == 'Supplementary Item - Upstructure' )
                
            {
                
                optionsToSelect.add(new SelectOption(f.getLabel(), f.getValue()));
                
            }
            
        } 
        
        return optionsToSelect;           
        
    }*/
        
}