trigger ValidatePRLineItemAndPOLineItemQuantity on Purchase_Order_Line_Item__c (after insert,after update) {
    for(Purchase_Order_Line_Item__c poLineItem:Trigger.new){
        //check if there is a related PR Line Item. We want to update the Quantity_Requested_On_PO_Line_Items__c field on the PR Line Item
        //Run this only if POLI has a PR Line Item
        if(poLineItem.PTS_Line_Item__c != NULL){
            List<PTS_Line_Item__c> prLineItem = 
                [
                    SELECT id,Name ,Item__c, Quantity__c,PO_Quantity__c, Quantity_Requested_On_PO_Line_Items__c
                    FROM PTS_Line_Item__c 
                    WHERE Id =: poLineItem.PTS_Line_Item__c
                ];
            if(prLineItem.size()>0){
                //Get total items requested
                AggregateResult [] gr = 
                    [
                        SELECT SUM(Quantity_Requested__c)totalQuantityRequested 
                        FROM Purchase_Order_Line_Item__c 
                        WHERE PTS_Line_Item__c =: poLineItem.PTS_Line_Item__c
                    ];
                
                if(gr.size() > 0 ){
                    //pr found, check if exceeded PR Line Item Qty
                    decimal totQtyRequested = (decimal) double.valueOf(gr[0].get('totalQuantityRequested'));
                    decimal prliQtyRequested =  (decimal) prLineItem.get(0).PO_Quantity__c;
                    //if total ordered so far will exceed PR Line Item value. To take care of variances eg 14.44 > 14.444
                    //also check if variance is greater than 1%
                    if(totQtyRequested > prliQtyRequested && (((totQtyRequested - prliQtyRequested)/prliQtyRequested)*100)>1){
                        poLineItem.addError('You have exceeded the Quantity on the PR Line Item' + 'Quantity Requested'+ gr[0].get('totalQuantityRequested') + 'PO Quanity' + prLineItem.get(0).PO_Quantity__c + 'PRLINE NUMBER' + prLineItem);
                    }
                    //if(double.valueOf(gr[0].get('totalQuantityRequested')) > prLineItem.get(0).PO_Quantity__c ){
                    //    poLineItem.addError('You have exceeded the Quantity on the PR Line Item' + 'Quantity Requested'+ gr[0].get('totalQuantityRequested') + 'PO Quanity' + prLineItem.get(0).PO_Quantity__c + 'PRLINE NUMBER' + prLineItem);
                    //} 
                    else {
                        //Update PR Line Item
                        prLineItem.get(0).Quantity_Requested_On_PO_Line_Items__c = double.valueOf(gr[0].get('totalQuantityRequested'));
                        UPDATE prLineItem;
                    }                
                }   
            }  
        }
    }
}

    
    /* //commented 2019-07-19 - To reduce Too Many SOQL error
trigger ValidatePRLineItemAndPOLineItemQuantity on Purchase_Order_Line_Item__c (after insert,after update) {
for(Purchase_Order_Line_Item__c poLineItem:Trigger.new){
Double totalQuantityRequested = 0;
List<Purchase_Order_Line_Item__c> lineItems = [SELECT id,Name , Company__c , Requesting_Company__c , CompanyName__c , Dimension_1__c  ,Dimension_2__c ,Dimension_3__c , Dimension_4__c,
Electronic_Payment_Request__c  ,EPR_Line_Item__c   ,GLA__c , Invoice_Assigned__c   ,Item_Type__c   , Item__c   ,Vatable__c, PIN__c  ,PIN_Line_Item__c   ,
PTS_Line_Item__c   ,Purchase_Order__c, Purchase_Order_Item__c  ,Quantity_Accepted__c   ,Quantity_Remaining__c  ,Quantity_Requested__c  ,Quantity_RTV__c    ,
Status__c  ,Terms_Conditions__c    ,Total_Price__c ,Total_Item_Value__c ,Total_Net_Price__c  ,Total_VAT_Amount__c  ,
Unit_Net_Price__c  ,Unit_Price__c  ,VAT_Amount__c, VAT_inclusive__c, VAT_Percentage__c, Vendor_id__c
FROM Purchase_Order_Line_Item__c 
WHERE PTS_Line_Item__c =: poLineItem.PTS_Line_Item__c 
];
for(Purchase_Order_Line_Item__c item:lineItems){
totalQuantityRequested += item.Quantity_Requested__c;  
}
System.debug('totalQuantityRequested: '+totalQuantityRequested);
List<PTS_Line_Item__c> prLineItem = [SELECT id,Name ,Item__c,Specifications__c, Quantity__c,PO_Quantity__c, Qty_Delivered__c,Item_Type__c,Currency_Config__c,
Procurement_Tracking_Sheet__r.name,Quote_Currency__c,Total_Quote_Price__c,Purchase_Order_Item__c,
Procurement_Tracking_Sheet__r.Requestor__r.name,Vendor__c,Vendor__r.name,Quote_Currency__r.name,
Procurement_Tracking_Sheet__r.Requesting_Department__r.name,  Currency_Config__r.name,Vatable__c,
Po_Line_attached__c, Quantity_Remaining__c ,Department__c,Dim_2__c,Unit_Quote_Price__c ,VAT_Percentage__c,
Dim_3__c,Grant__c,GLA__c, Company__c, Requesting_Company__c,Requesting_Company__r.Name,Status__c ,
VAT_Inclusive__c,Quantity_Requested_On_PO_Line_Items__c,RequestType__c
FROM PTS_Line_Item__c WHERE Id =: poLineItem.PTS_Line_Item__c
];
if(prLineItem.size()>0){
prLineItem.get(0).Quantity_Requested_On_PO_Line_Items__c = 0;
update prLineItem;
prLineItem.get(0).Quantity_Requested_On_PO_Line_Items__c = totalQuantityRequested;
update prLineItem;
if(totalQuantityRequested > prLineItem.get(0).PO_Quantity__c ){
poLineItem.addError('You have exceeded the Quantity on the PR Line Item');
}
}

}

}
*/