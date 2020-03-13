trigger SPRLineItemTrigger on Special_Procurement_Line_Item__c (before insert, before update, before delete) {
    //do not allow deletion of SPR Line
    for(Special_Procurement_Line_Item__c spli: Trigger.new){
        if(Trigger.isInsert) {
            //reset fields in case cloned
            if(spli.Status__c != 'Approved'){
                spli.Create_PR_Line_Item__c = FALSE;
            }
        }
        if(Trigger.isDelete && Trigger.isBefore) {
            spli.addError('Cannot delete a SPR Line Item once created. Set to Status to Discarded ');
        }
        //do not allow updates to SPR Line Items if attached to active PRs, SPRs, EPRs etc
        //check if we are changing values of the source docs
        if(Trigger.isUpdate && Trigger.isBefore){
            if(Trigger.oldMap.get(spli.Id).Record_Status__c == 'Locked'){
                //allow Sys Admin to change
                if(userinfo.getProfileId() == Id.valueOf('00eD0000001kXVa') && spli.Record_Status__c == 'Open'){
                    spli.Record_Status__c = 'Open';
                }else 
                {
                 //   spli.addError('Cannot Edit SPR Line Item as it is in a Locked Status ' + userinfo.getProfileId());
                }
            }
            if(
                (Trigger.oldMap.get(spli.Id).Balance_Carried_Forward__c == TRUE && spli.Balance_Carried_Forward__c == FALSE) || 
                (Trigger.oldMap.get(spli.Id).Procurement_Request_Line_Item__c != NULL && spli.Procurement_Request_Line_Item__c != Trigger.oldMap.get(spli.Id).Procurement_Request_Line_Item__c)  || 
                (Trigger.oldMap.get(spli.Id).EPR_Created__c == TRUE && spli.EPR_Created__c == FALSE) || 
                (Trigger.oldMap.get(spli.Id).EPR_Line_Item__c != NULL && spli.EPR_Line_Item__c != Trigger.oldMap.get(spli.Id).EPR_Line_Item__c ) 
            ) {
                
                spli.addError('Cannot Edit SPR Line Items attached to Active Source Documents'  + 
                              spli.Balance_Carried_Forward__c + '***' +
                              spli.Procurement_Request_Line_Item__c + '*** ' +   spli.EPR_Created__c + ' ** ' + spli.EPR_Line_Item__c      );
            }
            
            //check if PO Item values differ from budget values
            if(spli.Purchase_Order_Item__c != NULL){
                Purchase_Order_Item__c poi = [
                    SELECT Id, Name, Gross_Value__c, Vatable__c, VAT_Inclusive__c, VAT_Percentage__c   
                    FROM Purchase_Order_Item__c
                    WHERE Id =: spli.Purchase_Order_Item__c
                ];
                if (poi != NULL && spli.Unit_Price__c != poi.Gross_Value__c && spli.Overide_PO_Item_Price__c == FALSE){
                    spli.Unit_Price__c = poi.Gross_Value__c;
                    spli.Vatable__c = poi.Vatable__c;
                    spli.VAT_Percentage__c = poi.VAT_Percentage__c;
                    spli.VAT_Inclusive__c = poi.VAT_Inclusive__c;
                }
            }
            //IF Line Item not approved 
            if(spli.Status__c != 'Approved'){
                spli.Create_PR_Line_Item__c = FALSE;
                spli.Total_Price__c = 0;
            }
            else if (spli.Status__c == 'Approved'){
                spli.Status_Flag__c = 0;
                spli.Record_Status__c = 'Locked';
                spli.Total_Price__c = spli.Net_Total_Amount__c + spli.Total_VAT__c;
                spli.Create_PR_Line_Item__c = TRUE;
            }
        }
    }
}