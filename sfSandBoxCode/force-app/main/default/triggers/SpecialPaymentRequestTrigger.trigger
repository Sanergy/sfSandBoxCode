trigger SpecialPaymentRequestTrigger on Special_Procurement__c (before update) {
    for(Special_Procurement__c inv: Trigger.new){
        //validate entries
        FFA_Config_Object__c dim4 = 
            [
                SELECT Type__c 
                FROM FFA_Config_Object__c
                WHERE Id =: inv.Grant__c
            ];
        if(dim4 != NULL && dim4.Type__c != 'dim4'){
            inv.addError('The Grant Type selected should be a valid DIM 4');
        }
        system.debug('SPR = ' + inv);
        //Check if payment type is Advance or Reimbursement, if so do not allow for creation for PR
        if(inv.Requires_PR__c == true && (inv.Type__c == 'Cash Advance' || inv.Type__c == 'Employee Reimbursement')){
            system.debug('SPR test = ' + inv);
            //payment type is Advance or Reimbursement, if so do not allow for creation for PR
            inv.addError('This SPR cannot trigger the creation of a PR.');
            
        }else{
            
            if(inv.Stage__c == 'SPR Approved' && inv.Type__c == 'Special Procurement' && inv.Requires_PR__c == true && inv.Procurement_Request__c == NULL){
                system.debug('Procurement_Request__c '+ inv.Procurement_Request__c);
                // inv.Approval_Status__c = 'Approved By Director';
                //confirm Line items have been approved for creating PR                
                if(inv.No_Of_PR_Line_Items__c == 0){
                    inv.addError('The SPR Line Items have not been approved for the creation of a PR.');
                }
                // Select From special Procurement 
                Special_Procurement__c spr = 
                    [
                        SELECT Requestor__c,Requesting_Company__c	,Requesting_Department__c,Requesting_Department_TL__c,
                        Stage__c,Dim_2__c,Vendor__c, Dim_3__c,GLA__c,Grant__c,Next_Step__c,Next_Step_Due_Date__c,
                        Approval_Status__c,Required_Date__c,Requires_PR__c,No_of_Line_Items__c
                        FROM Special_Procurement__c
                        WHERE Id =: inv.Id
                    ];
                System.debug('SPECIAL PROCUREMENT' + spr);
                // Select Special Procurement Line Items
                List<Special_Procurement_Line_Item__c> spLineItems = 
                    [
                        SELECT Id,Name,Special_Procurement__c,Item__c,Status__c,
                        Specifications__c,EPR_Created__c,Status_Flag__c,
                        Quantity_Requested__c,Unit_Price__c,Total_Price__c,Purchase_Order_Item__c, 
                        Purchase_Order_Item__r.Inventory_Item__c,
                        Total_Unapproved_Value__c,Request_Type__c,Procurement_Request_Line_Item__c,Currency__c
                        FROM Special_Procurement_Line_Item__c
                        WHERE Special_Procurement__c =: spr.Id
                        AND  Create_PR_Line_Item__c = true
                        AND Item__c != 'Balance Carried Forward'
                                                                     ]; 
                System.debug('SPECIAL LINE PROCUREMENT' + spLineItems);
                
                //Create Peocurement Request From the Special Procurement 
                Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
                pr.Requestor__c = spr.Requestor__c;
                pr.Requesting_Company__c = spr.Requesting_Company__c;
                pr.Requesting_Department__c = spr.Requesting_Department__c;
                pr.Required_Date__c = spr.Required_Date__c;
                pr.Next_Step__c = 'Pending Team Lead Approval';
                pr.Stage__c = 'Open';
                pr.Priority__c = 'High';
                pr.Is_Retrospective__c	 = 'No';
                pr.High_Priority_Comments__c = 'PR Generated From SPR';
                pr.Maintenance_Department__c = spr.Requesting_Department__c;
                pr.Team_Ld__c = spr.Requesting_Department_TL__c;
                pr.Special_Payment_Request__c = spr.id;
                pr.PR_Source__c = 'Special Payment Request';
                INSERT pr;
                System.debug('PROCUREMENT REQUEST' + pr);
                //Insert Pr
                inv.Procurement_Request__c = pr.Id;	
                
                //attach any SPR documents to the PR
                Set<id> sprIDs = new Set<id>();
                sprIDs.add(spr.id);
                
                
                //Create Procurement Request Line Items
                for(Special_Procurement_Line_Item__c spL: spLineItems){
                    PTS_Line_Item__c prli = new PTS_Line_Item__c();
                    prli.Item__c = spL.Item__c;
                    prli.Specifications__c = spL.Specifications__c;
                    prli.Quantity__c = spL.Quantity_Requested__c;
                    prli.Budget_Amount__c = spL.Total_Price__c;
                    prli.RequestType__c  = spL.Request_Type__c;
                    prli.Currency_Config__c = spL.Currency__c;
                    prli.Vendor__c = spr.Vendor__c;
                    prli.Department__c = spr.Requesting_Department__c;
                    prli.Dim_2__c = spr.Dim_2__c;
                    prli.Dim_3__c = spr.Dim_3__c;
                    prli.GLA__c = spr.GLA__c;
                    prli.Inventory_Item__c = spL.Purchase_Order_Item__r.Inventory_Item__c;
                    prli.Purchase_Order_Item__c = spL.Purchase_Order_Item__c;
                    
                    prli.non_primary_vendor_description__c = 'Raised from SPR';
                    //prli.Grant__c = spr.Grant__c;
                    prli.Requesting_Company__c = spr.Requesting_Company__c;
                    prli.Status__c = 'Open';
                    prli.Procurement_Tracking_Sheet__c = pr.Id;
                    // prli.Status__c = 'Pending Purchase Order';
                    
                    //override the GLA if the selected item has a different GLA
                    if(spL.Purchase_Order_Item__r.Inventory_Item__c != NULL){
                        Group_Details__c grpGLA = new Group_Details__c();
                        grpGLA = 
                            [
                                SELECT Id, Inventory_Item_Group__c,Config_Account__c,Config_Account__r.Name
                                FROM Group_Details__c 
                                WHERE Inventory_Item_Group__c IN
                                (SELECT Item_Group__c FROM Inventory_Item__c WHERE Id =: spL.Purchase_Order_Item__r.Inventory_Item__c)
                                AND Credit_Debit__c = 'Debit'
                                AND Transaction_ID__c = 'PORCPT'
                            ];
                        if(grpGLA != NULL && grpGLA.Config_Account__c != spr.GLA__c){
                            prli.Override_Gla__c = TRUE;
                        }
                    }

                    INSERT prli;
                    System.debug('PROCUREMENT LINE REQUEST' + prli); 
                    //Update at this point to allow the Inventory item to reflect and as such PO Item
                    UPDATE prli;
                    spL.Procurement_Request_Line_Item__c = prli.Id;
                    spL.Record_Status__c = 'Locked'; //Lock the SPLI to restrict editing
                    //UPDATE spL;
                    
                    //Add SPR Line Item to set 
                    sprIDs.add(spL.id);
                }
                system.debug('New PR = ' + pr);
                
                
                if(pr.Id != null){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(pr.Id);
                    // Submit the approval request for the account
                    //Approval.ProcessResult result = Approval.process(req1);  
                    
                    //clone attachments if any
                    if(sprIDs.size() > 0){
                        SanergyUtils.CloneAttachments(sprIDs, pr.Id, '');  
                        SanergyUtils.CloneNotes(sprIDs, pr.Id, '');  
                        SanergyUtils.CloneGoogleDocs(sprIDs, pr.Id, '');  
                    }
                }
            }           
        }  
    }
}