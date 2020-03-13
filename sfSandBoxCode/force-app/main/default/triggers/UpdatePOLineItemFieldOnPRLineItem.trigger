trigger UpdatePOLineItemFieldOnPRLineItem on Purchase_Order_Line_Item__c (after insert) {
    for(Purchase_Order_Line_Item__c poLine:Trigger.New){
       /* List<PTS_Line_Item__c> prLine = [SELECT Id,Name,Purchase_Order_Line_Item__c,non_primary_vendor_description__c FROM PTS_Line_Item__c
                        				WHERE Id =: poLine.PTS_Line_Item__c];
        if(prLine.size()>0){
            
            prLine.get(0).Purchase_Order_Line_Item__c = poLine.Id;
            prLine.get(0).non_primary_vendor_description__c = 'Default description Please change';
            update prLine;
        }*/
    }

}