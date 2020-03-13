public class PurchaseOrderActionController{
    
    private ApexPages.StandardController standardController;
    Public Purchase_Order__c po {get;set;}
    List<WrapperItems> openLineList{get;set;}
    List<WrapperItems> openLineListByInventoryItem{get;set;}
    List<wrpPOLineItems> POLineItems{get;set;}
    
    List<Purchase_Order_Line_Item__c> openItems = new List<Purchase_Order_Line_Item__c>();
    List<Purchase_Order_Line_Item__c> openItemsByInventoryItem = new List<Purchase_Order_Line_Item__c>();
    List<Purchase_Order_Line_Item__c> POLIList {get;set;}
    List<Purchase_Order__c> OpenVendorPOs {get;set;}
    Set<Id> SourceDocsIds  = new Set<Id>();
    Set<Id> poiIds  = new Set<Id>();
    Set<Id> inventoryItemIds  = new Set<Id>();
    
    List<Purchase_Order_Item__c> poIdList  = new List<Purchase_Order_Item__c>();
    public Integer Counter = 0;
    public Integer attIndex = 0;
    public Boolean attFound = TRUE;
    public Boolean noteFound = TRUE;
    public Boolean gDocFound = TRUE;
    public Boolean attFileDuplicate = TRUE;
    public Boolean attGDocDuplicate = TRUE;
    Public String POComments{get;set;}
    Public Date PODeliveryDate{get;set;}
    Public String PODeliveryMode{get;set;}
    Public String PODeliveryAddress{get;set;}
    
    public PurchaseOrderActionController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        po=(Purchase_Order__c)standardController.getRecord();
        po = 
            [
                SELECT id, Name, Vendor_Account__c, Vendor_Account__r.Name, Vendor_Account__r.c2g__CODAInvoiceEmail__c, 
                Order_Status__c,PO_Currency__c, Total_Amount__c, Delivery_Date__c, Delivery_Mode__c, Delivery_Address__c
                FROM Purchase_Order__c
                WHERE Id =: po.Id
            ];
        PODeliveryDate = po.Delivery_Date__c;
        PODeliveryAddress = po.Delivery_Address__c;
        PODeliveryMode = po.Delivery_Mode__c;
    }
    
    public void test(){
        POFirm();
        boolean priceCheck;
        priceCheck = PriceVarIsOK (0,0,0);
        priceCheck = PriceVarIsOK (10,30,20);
        priceCheck = PriceVarIsOK (10,20,30);
    }
    
    private void cloneAttachments(){
        //Get the associated PR IDs to this PO
        //Loop through the PO Line Items
        
        //copy over attachments from PR - ID= aDBD0000000TNIp
        List<Attachment> attachments = [
            SELECT id, Name, Body, BodyLength
            FROM Attachment
            WHERE ParentID IN :SourceDocsIds
        ];
        
        //Get current attachments on the PO
        List<Attachment> currPOAttachments = [
            SELECT id, Name, Body, BodyLength
            FROM Attachment
            WHERE ParentID =: po.id
        ];  
        
        System.debug('attachments >>' + attachments +  '**** currPOAttachments >>>>' + currPOAttachments);
        //Create list of attachments
        List<Attachment> attachmentsToInsert = new List<Attachment>();
        for(Attachment file : attachments) {
            Attachment newFile = file.clone();
            newFile.ParentId = po.id;
            newFile.Name = '[**]: ' + file.Name;
            newFile.Body = file.body;
            
            attachmentsToInsert.add(newFile);    
        }
        /* 
//to avoid duplication check if name and body length is the same
attFileDuplicate = TRUE;
for(Attachment ati : attachmentsToInsert){
//system.debug('ati = ' + ati);
//system.debug('file = ' + file);
if(newFile.Name == ati.name && newFile.BodyLength == ati.BodyLength){
system.debug('in here ');
attFileDuplicate = TRUE;
break;
}else{
attFileDuplicate = FALSE; 
}
}
*/
        system.debug('attachmentsToInsert = ' + attachmentsToInsert);
        //Clone List to insert
        List<Attachment> attachmentsToInsertFinal = currPOAttachments.clone();
        //Clear list and get ready to insert
        attachmentsToInsertFinal.clear();  
        
        //if there aren't any attachments in the current PO then we can insert without need to search for duplicates
        if(currPOAttachments == NULL || currPOAttachments.size() == 0){
            //clone attachments list
            attachmentsToInsertFinal = attachmentsToInsert.clone();
        }else {
            //Check if any duplicates existing
            for(Attachment att : attachmentsToInsert  ){
                system.debug('ffff' + att.Name);
                //loop through attachments to insert. If does not exist, add to final list
                
                //Set Default
                attFound = TRUE;
                for(Attachment attToIns : currPOAttachments){
                    if(attToIns.Name == att.Name){
                        system.debug ('attToIns.Name == att.Name: ' + attIndex + ' >> '  + attToIns.Name + ' ** ' + att.Name);
                        attFound = TRUE;
                        break;
                    }else {
                        //Not found to be added
                        attFound = FALSE;
                    }
                }
                if(attFound == FALSE){
                    //add item
                    attachmentsToInsertFinal.add(att); 
                }
            }
        }
        // finally, insert the cloned attachments
        system.debug('attachmentsToInsert = ' + attachmentsToInsertFinal);
        if(attachmentsToInsertFinal != NULL && attachmentsToInsertFinal.size()>0){
            insert attachmentsToInsertFinal; 
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'Cloning Complete');
            ApexPages.addmessage(msg);
        } 
    }    
    
    private void cloneNotes(){
        //copy over Notes from PRs
        List<Note> notes = [
            SELECT Body,Id,OwnerId,ParentId,Title
            FROM Note
            WHERE ParentID IN :SourceDocsIds
        ];
        
        //Get current attachments on the PO
        List<Note> currPONotes = [
            SELECT Body,Id,OwnerId,ParentId,Title
            FROM Note
            WHERE ParentID =: po.id
        ];  
        
        //Create list of Notes
        List<Note> notesToInsert = new List<Note>();
        for(Note poNote : notes) {
            Note newNote = poNote.clone();
            newNote.ParentId = po.id;
            newNote.Title = '[**]: ' + poNote.Title;
            newNote.Body = poNote.body;
            
            notesToInsert.add(newNote);    
        }
        
        //Clone List to insert
        List<Note> notesToInsertFinal = currPONotes.clone();
        //Clear list and get ready to insert
        notesToInsertFinal.clear();  
        
        //if there aren't any Notes in the current PO then we can insert without need to search for duplicates
        if(currPONotes == NULL || currPONotes.size() == 0){
            //clone NOtes list
            notesToInsertFinal = notesToInsert.clone();
        }else {
            //Check if any duplicates existing
            for(Note nt : notesToInsert ){
                //loop through notes to insert. If does not exist, add to final list
                
                //Set Default
                noteFound = TRUE;
                for(Note noteToIns : currPONotes){
                    if(noteToIns.Title == nt.Title){
                        noteFound = TRUE;
                        break;
                    }else {
                        //Not found to be added
                        noteFound = FALSE;
                    }
                }
                if(noteFound == FALSE){
                    //add item
                    notesToInsertFinal.add(nt); 
                }
            }
        }
        // finally, insert the cloned notes
        if(notesToInsertFinal != NULL && notesToInsertFinal.size()>0){
            insert notesToInsertFinal; 
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'Cloning Notes Complete');
            ApexPages.addmessage(msg);
        } 
    }
    
    Private void cloneGoogleDocs(){
        //copy over GoogleDocs from PRs
        //Using Group BY to get distinct URL.
        AggregateResult[] gDoc = 
            [SELECT  MAX(Name)GDocName, URL 
             FROM GoogleDoc 
             WHERE ParentId IN :SourceDocsIds
             GROUP BY URL 
            ];
        
        //Get current Google Docs on the PO
        Set<GoogleDoc> currPOGDocs = new Set<GoogleDoc>([
            SELECT URL
            FROM GoogleDoc
            WHERE ParentID =: po.id
        ]);  
        
        //Create list of GoogleDoc
        List<GoogleDoc> gDocsToInsert = new List<GoogleDoc>();
        
        if (gDoc != NULL && gDoc.size() > 0){
            for(AggregateResult ar : gDoc){
                //if currPOGDocs empty then insert all
                if(currPOGDocs == NULL || currPOGDocs.size() == 0){
                    GoogleDoc newGDoc = new GoogleDoc();
                    newGDoc.ParentId = po.id;
                    newGDoc.Name = '[**]: ' + ar.get('GDocName') ;
                    newGDoc.url = String.valueOf(ar.get('Url'));
                    gDocsToInsert.add(newGDoc);
                }else
                {
                    //Loop through an check if another Doc with same URL exists
                    gDocFound = TRUE;
                    for(GoogleDoc gd: currPOGDocs){
                        if(gd.Url == ar.get('Url')){
                            gDocFound = TRUE;
                            break;
                        } else {
                            gDocFound = FALSE;
                        }                 
                    }
                    if(gDocFound == FALSE){
                        GoogleDoc newGDoc = new GoogleDoc();
                        newGDoc.ParentId = po.id;
                        newGDoc.Name = '[**]:' + ar.get('GDocName') ;
                        newGDoc.url = String.valueOf(ar.get('Url'));
                        gDocsToInsert.add(newGDoc);
                    }
                }
            }      
            
        }
        
        // finally, insert the cloned Google Docs
        if(gDocsToInsert != NULL && gDocsToInsert.size()>0){
            insert gDocsToInsert; 
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'Cloning Google Docs Complete');
            ApexPages.addmessage(msg);
        } 
        
    }  
    
    public PageReference POFirm() {
        cloneAttachments();
        cloneNotes();
        cloneGoogleDocs();
        //Get if the open Po Line items all have comments provided for them
        Counter = 0;
        for(WrapperItems OpenItem: openLineList){
            system.debug('OpenItem' + OpenItem);
            if ((OpenItem.Comments == null || OpenItem.Comments == '') && (openLineList.size() > 0)){
                Counter = Counter + 1;
            }
        } 
        System.debug('Counter' + Counter); 
        // throw an error if all the comments are not provided but 
        if(Counter > 0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Provide a reasons For all the Line(s) Below');
            ApexPages.addmessage(msg); 
            Counter = 0;
            return null;
        }
        else{
            po.Firm_Date__c = Date.today();
            po.Delivery_Date__c = PODeliveryDate;
            po.Delivery_Address__c = PODeliveryAddress;
            po.Delivery_Mode__c = PODeliveryMode;
            
            //update the Po and the POLI 
            for(WrapperItems OpenItm: openLineList){
                system.debug('OpenItm' + OpenItm);
                
                for(Purchase_Order_Line_Item__c poli: openItems ){
                    if (OpenItm.item.Id == poli.Id){
                        poli.Firm_Comments__c = OpenItm.Comments;
                    }
                }
                
            } 
            //Submit for approval
            if(SubmitForApproval()==TRUE){
                update po;
                update openItems;  
                return new PageReference('/'+po.id);
            }else {
                //Display error
                return null;
            }
        }     
    }
    
    private Boolean SubmitForApproval(){
        // Create an approval request
        try{
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting PO request for approval.');
            req1.setObjectId(po.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(UserInfo.getUserId()); 
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            return TRUE;
        }
        catch(exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addmessage(msg); 
            return FALSE;
        }
    }
    
    public PageReference POApprove() {       
        po.Order_Status__c='Approved';                    
        update po;
        return new PageReference('/'+po.id);        
    }
    public PageReference testThere(){
        po.Order_Status__c='Approved';                    
        update po;
        return new PageReference('/'+po.id); 
    }
    
    public PageReference PODecline() {       
        po.Order_Status__c='Declined';                    
        update po;
        return new PageReference('/'+po.id);        
    }
    
    public PageReference POVendorNotify() {
        List<Purchase_Order__c> pOrder=[SELECT Order_Status__c
                                        FROM Purchase_Order__c 
                                        WHERE id=:po.Id];
        if(pOrder.size()>0){
            pOrder.get(0).Order_Status__c='Vendor Notified';
            update pOrder;
            sendEmailToVendor();
            apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'PO Updated to Vendor Notified Status'));
        }    
        
        //return new PageReference('/'+po.id); 
        return NULL;     
    }
    
    public PageReference POClose() {
        List<Purchase_Order__c> pOrder=[SELECT Order_Status__c
                                        FROM Purchase_Order__c 
                                        WHERE id =: po.Id];
        //Check if any open POLI
        AggregateResult[] aggVIPO = [SELECT COUNT(Name)Records FROM Vendor_Invoice_PO__c WHERE Purchase_Order__c =: po.Id];
        AggregateResult[] aggVIPOLI = [SELECT COUNT(Name)Records 
                                       FROM Vendor_Invoice_Purchase_Order_Line_Item__c 
                                       WHERE Purchase_Order_Line_Item__r.Purchase_Order__c =: po.Id];
        AggregateResult[] aggVII = [SELECT COUNT(Name)Records 
                                    FROM Vendor_Invoice_Items__c 
                                    WHERE Purchase_Order_Line_Item__r.Purchase_Order__c =: po.Id];
        
        //if any records returned don't cancel PO
        if((Integer.valueOf(aggVIPO[0].get('Records')) + Integer.valueOf(aggVIPOLI[0].get('Records')) + Integer.valueOf(aggVII[0].get('Records')))>0){
            apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This PO Cannot be cancelled'));
            if(Integer.valueOf(aggVIPO[0].get('Records')) > 0){
                apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'It is associated with ' + aggVIPO[0].get('Records') + ' VI PO Records'));
            }
            if(Integer.valueOf(aggVIPOLI[0].get('Records')) > 0){
                apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'It is associated with ' + aggVIPOLI[0].get('Records') + ' VI PO Line Item Records'));
            }
            if(Integer.valueOf(aggVII[0].get('Records')) > 0){
                apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'It is associated with ' + aggVII[0].get('Records') + ' VI Item Records'));
            }
        }else
        {
            //if no errors set PO and PO Line Item Status to cancelled
            //Check if any PO Line items exist
            List<Purchase_Order_Line_Item__c> poli = 
                [
                    SELECT id, Status__c
                    FROM Purchase_Order_Line_Item__c
                    WHERE Purchase_Order__c =: po.Id
                ];
            
            if(poli != NULL && poli.size() > 0){
                for(Purchase_Order_Line_Item__c item : poli){
                    item.Status__c = 'Cancelled';
                }
                UPDATE poli;
                apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'PO Line Items have been Cancelled'));
            }
            
            //update PO
            if(pOrder.size() > 0){
                pOrder.get(0).Order_Status__c='Cancelled';
                UPDATE pOrder;
                apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'PO has been Cancelled'));
            } 
        }
        
        return NULL;         
    }
    
    //Get PO Line Items
    public List<Purchase_Order_Line_Item__c> getPOLineItems(){
        POLIList = [SELECT Id, Name,Purchase_Order__c, Purchase_Order_Item__c, Purchase_Order_Item__r.Inventory_Item__c,
                    Purchase_Order_Item__r.Inventory_Item__r.Name, Status__c,
                    Purchase_Order_Item__r.Name, Quantity_Requested__c, Quantity_Accepted__c,
                    UoM__c, Notes__c, Variation_Notes__c, Unit_Net_Price__c, Unit_Gross_Price__c,
                    Total_Net_Price__c, Total_Price__c, PTS_Line_Item__c, PTS_Line_Item__r.Name,
                    PTS_Line_Item__r.Procurement_Tracking_Sheet__c, PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Name,
                    Reorder_Level__c,  Reorder_Quantity__c, Quantity_At_Hand__c
                    FROM Purchase_Order_Line_Item__c 
                    WHERE Purchase_Order__c =: po.Id
                   ];
        
        for(Purchase_Order_Line_Item__c POLI: POLIList){
            Purchase_Order_Item__c poid = [SELECT Id 
                                           FROM Purchase_Order_Item__c 
                                           WHERE ID =:POLI.Purchase_Order_Item__c 
                                          ];
            
            poIdList.add(poid);
            poiIds.add(poli.id);
            SourceDocsIds.add(poli.PTS_Line_Item__c);
            SourceDocsIds.add(poli.PTS_Line_Item__r.Procurement_Tracking_Sheet__c);  
            //add the Inventory Item ID
            inventoryItemIds.add(poli.Purchase_Order_Item__r.Inventory_Item__c);
        }
        system.debug('SourceDocsIds' + SourceDocsIds);
        
        return POLIList;
    }
    
    public List<WrapperItems> getopenLineList(){
        openLineList = new List<WrapperItems>();
        
        //Get all the Open POLI that relate to the POI of the POLI On the PO, 
        //the POLI on the PO where the Amount on the Line Item varies with the one on the POI 
        //AND also where the primary Vendor has not been used.
        
        openItems = [SELECT Purchase_Order__r.Name, Purchase_Order__r.Firm_Date__c,Purchase_Order__r.Delivery_Date__c,
                     Name,Total_Price__c,PTS_Line_Item__c,Unit_Net_Price__c,Receipt_Variance__c, UoM__c,Purchase_Order_Item__r.Name, 
                     PO_Line_Receipt_Status__c,Status__c, Requesting_Company__c,Purchase_Order_Item__r.Unit_Net_Price__c,Firm_Comments__c,
                     Quantity_Requested__c, Quantity_Accepted__c,Quantity_Remaining__c,Item__c,Unit_Price__c,
                     Purchase_Order_Item__r.Primary_Vendor__c,Unit_Net_Price_Difference__c, Purchase_Order__r.Vendor_Account__c ,
                     Purchase_Order__r.Vendor_Account__r.Name, VI_Avg_Unit_Price__c, VI_Recon_Qty_s__c, Min_Price_Var__c, Max_Price_Var__c 
                     FROM Purchase_Order_Line_Item__c
                     WHERE
                     (
                         Quantity_Remaining__c > 0 
                         AND Receipt_Variance__c = null
                         AND CreatedDate > 2019-01-01T00:00:00.000Z 
                         AND Purchase_Order_Item__c IN: poIdList
                         AND Purchase_Order__c !=: po.Id AND (Status__c != 'Closed' AND Status__c != 'Cancelled')
                     )	
                     OR(Purchase_Order__c =: po.Id  AND Purchase_Order_Item__r.Primary_Vendor__c = FALSE AND (Status__c != 'Closed' AND Status__c != 'Cancelled') )
                     OR (Purchase_Order__c =: po.Id  AND Unit_Net_Price_Difference__c != 0 AND (Status__c != 'Closed' AND Status__c != 'Cancelled'))
                     ORDER BY Purchase_Order__r.Delivery_Date__c ASC, Name
                    ];
        
        //From the list get the type of Error from each of the POLI returned on the List
        for(Purchase_Order_Line_Item__c itm: openItems){
            WrapperItems itms = new WrapperItems(itm);
            if((itm.Purchase_Order__c == po.Id)&&(itm.Purchase_Order_Item__r.Primary_Vendor__c == FALSE)&& (itm.Unit_Net_Price_Difference__c > 0  && (itm.Receipt_Variance__c == null || itm.Receipt_Variance__c == ''))){
                itms.errorType = 'Primary Vendor & Price Difference';
            }
            else  if((itm.Purchase_Order__c == po.Id)&&(itm.Purchase_Order_Item__r.Primary_Vendor__c == FALSE)){
                itms.errorType = 'Primary Vendor';
            }
            
            else if((itm.Purchase_Order__c == po.Id) && (PriceVarIsOK(itm.Min_Price_Var__c, itm.Max_Price_Var__c, itm.Unit_Net_Price__c)==FALSE  && (itm.Receipt_Variance__c == null || itm.Receipt_Variance__c == ''))){
                itms.errorType = 'Price Difference';
            }
            
            else{
                itms.errorType = 'Open PO';
            }
            
            itms.Comments = itm.Firm_Comments__c;
            openLineList.add(itms);
        }
        
        return openLineList;
        
    }
    
    public List<WrapperItems> getopenLineListByInventoryItem(){
        openLineListByInventoryItem = new List<WrapperItems>();
        
        //Get all the Open POLI that relate to the Inventory Item the PO Item Has
        
        openItemsByInventoryItem = 
            [
                SELECT Purchase_Order__r.Name, Purchase_Order__r.Firm_Date__c,Purchase_Order__r.Delivery_Date__c,
                Purchase_Order_Item__r.Inventory_Item__c, Purchase_Order_Item__r.Inventory_Item__r.Name,
                Name,Total_Price__c,PTS_Line_Item__c,Unit_Net_Price__c,Receipt_Variance__c, UoM__c,Purchase_Order_Item__r.Name,
                PO_Line_Receipt_Status__c,Status__c, Requesting_Company__c,Purchase_Order_Item__r.Unit_Net_Price__c,
                Firm_Comments__c, Quantity_Requested__c, Quantity_Accepted__c,Quantity_Remaining__c,Item__c,Unit_Price__c,
                Purchase_Order_Item__r.Primary_Vendor__c,Unit_Net_Price_Difference__c, Purchase_Order__r.Vendor_Account__c ,
                Purchase_Order__r.Vendor_Account__r.Name, VI_Avg_Unit_Price__c, VI_Recon_Qty_s__c
                FROM Purchase_Order_Line_Item__c
                WHERE
                (
                    CreatedDate > 2019-01-01T00:00:00.000Z 
                    AND Purchase_Order_Item__r.Inventory_Item__c IN: inventoryItemIds
                    AND Purchase_Order__c !=: po.Id 
                    AND (Status__c != 'Closed' AND Status__c != 'Cancelled')
                    AND Purchase_Order__r.Approved__c = TRUE
                    //AND Purchase_Order__r.Firm_Date__c != NULL
                )	
                OR
                ( //Get any open POs from this vendor for any items
                    CreatedDate > 2019-01-01T00:00:00.000Z 
                    AND Purchase_Order__r.Vendor_Account__c =: po.Vendor_Account__c 
                    AND Purchase_Order__c !=: po.Id 
                    AND (Status__c != 'Closed' AND Status__c != 'Cancelled')
                    AND Purchase_Order__r.Approved__c = TRUE
                    //AND Purchase_Order__r.Firm_Date__c != NULL
                )
                ORDER BY Purchase_Order__r.Delivery_Date__c ASC, Name
            ];
        system.debug('openItemsByInventoryItem = ' + openItemsByInventoryItem);        
        //From the list get the type of Error from each of the POLI returned on the List
        for(Purchase_Order_Line_Item__c itm: openItemsByInventoryItem){
            WrapperItems itms = new WrapperItems(itm);
            //poiIds
            if(poiIds.contains(itm.Purchase_Order_Item__c)){
                itms.errorType = '';
            }
            
            if(itm.Quantity_Accepted__c >= itm.Quantity_Requested__c ){
                itms.Comments = 'Full Receipts';
            }
            else if(itm.Quantity_Remaining__c > 0 && itm.Quantity_Remaining__c < itm.Quantity_Requested__c){
                itms.Comments = 'Partial Receipts';
            }            
            else if(itm.Quantity_Remaining__c >= itm.Quantity_Requested__c || itm.Quantity_Accepted__c == 0){
                itms.Comments = 'No Receipts';
            }
            
            if(itm.VI_Avg_Unit_Price__c == 0 ){
                itms.Comments = itms.Comments + ' / No Payments';
            }else if(itm.VI_Avg_Unit_Price__c > 0 )
            {
                itms.Comments = itms.Comments + ' / Payments Applied';
            }
            
            openLineListByInventoryItem.add(itms);
        }
        
        return openLineListByInventoryItem;
    }
    
    public List<Purchase_Order__c> getOpenVendorPOs(){
        //get all open POs for this Vendor
        List<Purchase_Order__c> openPOs = new List<Purchase_Order__c>();
        openPOs = 
            [
                SELECT id, Name, Company__c, Vendor_Account__c, Firm_Date__c, Expected_Date__c, Total_Amount__c, 
                Order_Status__c, Payment_Status__c
                FROM Purchase_Order__c
                WHERE Vendor_Account__c =: po.Vendor_Account__c AND Count_PO_Line_Items_Open__c > 0
            ];
        return openPOs;
    }
    
    public String processId;
    
    public PageReference testTwo(){
        List<Purchase_Order__c> pOrder=[SELECT Order_Status__c
                                        FROM Purchase_Order__c 
                                        WHERE id=:po.Id];
        if(pOrder.size()>0){
            pOrder.get(0).Order_Status__c='Closed';
            update pOrder;
        } 
        
        return new PageReference('/'+po.id);  
    }
    
    //Approve the PO 
    public PageReference Approve(){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        processId = ApexPages.currentPage().getParameters().get('id');
        //Process INstance gives you the Approval process you are currently working on 
        ProcessInstance pi = [SELECT ID, ProcessDefinitionId,TargetObjectId  FROM ProcessInstance WHERE TargetObjectId =: po.id And Status !='closed' ORDER BY CreatedDate Desc LIMIT 1];
        // processInstanceWorkItem gives you the Instance of the Approval that is currently being worked on 
        processinstanceworkitem pwi = [ SELECT ID FROM processinstanceworkitem  WHERE processInstance.TargetObjectId=: pi.TargetObjectId];
        
        string x = pwi.id;
        system.debug('XXXXXXXXX'+ x);
        string res =  x.substring(0,x.length()-3);
        
        req.setComments(POComments);
        req.setAction('Approve');
        req.setNextApproverIds(null); 
        system.debug('Respoooo567896789789899ooooooooooonse' + res);
        req.setWorkitemId(x);
        
        Approval.ProcessResult result =  Approval.process(req);
        po.Order_Status__c='Approved';                    
        update po;
        
        //Send Email to Requestor
        SendEmailToRequestor('Approved', POComments);
        return new PageReference('/'+po.id) ;
    }
    
    //Reject the PO
    public PageReference Reject(){
        //Reject PO
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        processId = ApexPages.currentPage().getParameters().get('id');
        ProcessInstance pi = [SELECT ID, ProcessDefinitionId,TargetObjectId  FROM ProcessInstance WHERE TargetObjectId =: po.id And Status !='closed' ORDER BY CreatedDate Desc LIMIT 1];
        processinstanceworkitem pwi = [ SELECT ID FROM processinstanceworkitem  WHERE processInstance.TargetObjectId=: pi.TargetObjectId];
        
        string x = pwi.id;
        system.debug('XXXXXXXXX'+ x);
        string res =  x.substring(0,x.length()-3);
        
        req.setComments(POComments);
        req.setAction('Reject');
        req.setNextApproverIds(null); 
        system.debug('Response' + res);
        req.setWorkitemId(x);
        
        Approval.ProcessResult result =  Approval.process(req);
        po.Order_Status__c='Declined';                    
        update po;
        
        //Send Email to Requestor
        SendEmailToRequestor('Declined', POComments);
        
        return new PageReference('/'+po.id) ;          
    }
    
    public void SendEmailToRequestor(String strApprovedorRejected, String strPOComments){
        //get the requestors in this PO and send email
        AggregateResult[] aggPRRequestors = 
            [
                SELECT PTS_Line_Item__r.Procurement_Tracking_Sheet__c PRGUID, 
                MAX(PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Name) PRName, 
                PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Requestor__c RequestorGUID, PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Requestor__r.Name RequestorName,
                PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c RequestorEmail
                FROM Purchase_Order_Line_Item__c
                WHERE Purchase_Order__c =: po.id
                GROUP BY PTS_Line_Item__r.Procurement_Tracking_Sheet__c, 
                PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Requestor__c, 
                PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Requestor__r.Name,
                PTS_Line_Item__r.Procurement_Tracking_Sheet__r.Requestor__r.Work_Email__c
            ];
        
        // Send email to recipient
        List<String> sendTo = new List<String>();
        List<String> PRList = new List<String>();
        
        system.debug('aggPRRequestors = ' + aggPRRequestors);
        
        for(AggregateResult agg : aggPRRequestors){
            sendTo.add((String)agg.get('RequestorEmail'));
            PRList.add((String)agg.get('PRName'));
        }
        // Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Set recipient address
        mail.setToAddresses(sendTo);
        
        // Set the email sender
        mail.setReplyTo('procurement@saner.gy');
        mail.setSenderDisplayName('SANERGY');
        
        // Set people to be BCCed
        //List<String> bccTo = new List<String>();
        //bccTo.add('');
        //mail.setBccAddresses(bccTo);
        
        // Create the email body
        mail.setSubject('Purchase Order: ' + po.Name + ' - ' + strApprovedorRejected);
        String body = '<p>Hi </p>';   
        body += '<p>The PO [' + po.Name + '] for your Requested PRs below has been <b>' + strApprovedorRejected + '</b>.</p><p></p>';
        body += '<p><b>PR List:</b> ' + PRList + '.</p><p></p>';
        body += '<h3>Approval Comments</h3>' + strPOComments + '. <p></p>';
        body += '<p>Contact <a href="mailto:procurement@saner.gy" target="_top">procurement@saner.gy</a> for further follow-up</p>.';
        mail.setHtmlBody(body);
        
        //flag to false to stop inserting activity history
        mail.setSaveAsActivity(false);
        
        //Send email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    public PageReference sendEmailToVendor(){
        //Send notification email to vendor
        List<String> sendTo = new List<String>();
        sendTo.add('procurement@saner.gy');
        if(po.Vendor_Account__r.c2g__CODAInvoiceEmail__c != NULL){
            sendTo.add(po.Vendor_Account__r.c2g__CODAInvoiceEmail__c);
            apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Email sent to the Vendor'));
        }
        else {
            apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email not sent to the Vendor: Missing Email address'));
        }
        
        
        PageReference ref = page.GeneratePODocument;
        ref.getParameters().put('id', po.Id);
        //Need this to avoid error when running test: "Methods defined as TestMethod do not support getContent call"
        Blob b ;
        if(Test.isRunningTest()){
            b = blob.valueOf('Unit.Test');
        }else{
            b = ref.getContentAsPDF();
        }
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName(po.Name + '.pdf');
        efa1.setBody(b);
        
        String addresses;
        email.setSubject( 'Sanergy Purchase Order #' + po.Name + ' ['+ String.valueOf(DateTime.now()) + ']');
        email.setToAddresses( sendTo  );
        email.setHtmlBody
            (
                'Dear Sir/Madam ' + 
                '<br><br><p>I hope you are well.</p>' +
                '<p>Kindly arrange to service the attached PO.</p>'
            );
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        return NULL;
    }
    // Create a wrapper Class  
    public Class wrpPOLineItems{
        public Purchase_Order_Line_Item__c item{get;set;}
        
        public wrpPOLineItems(Purchase_Order_Line_Item__c itm){
            item = itm;
        }
    }
    
    //Open POLI List Wrapper Class
    public Class WrapperItems{
        public Purchase_Order_Line_Item__c item{get;set;}
        public String errorType{get;set;}
        Public String Comments{get;set;}
        
        public WrapperItems(Purchase_Order_Line_Item__c itm){
            item = itm;
        }
    }    
    
    public Boolean PriceVarIsOK(decimal minValue, decimal maxValue, decimal priceToCheck){
        //check if the variance within the required bounds
        if(minValue == 0 && maxValue == 0){
            return TRUE;
        } else if(minValue != 0 && maxValue != 0){
            //check if price between the 2 values
            if(minValue <= priceToCheck && priceToCheck <= maxValue){
                return TRUE;
            } else
            {
                return FALSE;
            }
        }
        return FALSE;
    }
}