trigger POLineItemEditingValidation on Purchase_Order_Line_Item__c (before update) {
    for(Purchase_Order_Line_Item__c poLine:Trigger.new){
        if(poLine.Purchase_Order__c != null){
            if(Trigger.oldMap.get(poLine.Id).Unit_Net_Price__c != poLine.Unit_Net_Price__c
               || Trigger.oldMap.get(poLine.Id).Unit_Price__c != poLine.Unit_Price__c
               || Trigger.oldMap.get(poLine.Id).Purchase_Order_Item__c != poLine.Purchase_Order_Item__c
               || Trigger.oldMap.get(poLine.Id).VAT_Percentage__c != poLine.VAT_Percentage__c
               || Trigger.oldMap.get(poLine.Id).Vatable__c != poLine.Vatable__c
               || Trigger.oldMap.get(poLine.Id).VAT_inclusive__c != poLine.VAT_inclusive__c
               || Trigger.oldMap.get(poLine.Id).PTS_Line_Item__c != poLine.PTS_Line_Item__c
               || Trigger.oldMap.get(poLine.Id).Quantity_Requested__c != poLine.Quantity_Requested__c
              ){
                  poLine.addError('You are not allowed to Edit PO Line Item after it has been created');
              }
        }
        if(poLine.Invoice_Assigned__c == true && poLine.Purchase_Order__c != null){
            if(Trigger.oldMap.get(poLine.Id).Unit_Net_Price__c != poLine.Unit_Net_Price__c
               || Trigger.oldMap.get(poLine.Id).Unit_Price__c != poLine.Unit_Price__c
               || Trigger.oldMap.get(poLine.Id).Purchase_Order_Item__c != poLine.Purchase_Order_Item__c
               || Trigger.oldMap.get(poLine.Id).VAT_Percentage__c != poLine.VAT_Percentage__c
               || Trigger.oldMap.get(poLine.Id).Vatable__c != poLine.Vatable__c
               || Trigger.oldMap.get(poLine.Id).VAT_inclusive__c != poLine.VAT_inclusive__c
               || Trigger.oldMap.get(poLine.Id).PTS_Line_Item__c != poLine.PTS_Line_Item__c
               || Trigger.oldMap.get(poLine.Id).Quantity_Requested__c != poLine.Quantity_Requested__c
               
               || poLine.Status__c == 'Cancelled'){
                   poLine.addError('You are not allowed to Edit or Cancel PO Line Item after Invoice has been generated');
               }
        }
        //Change in status
        if(Trigger.oldMap.get(poLine.Id).Status__c != poLine.Status__c && poLine.Status__c == 'Cancelled'){
            List<PTS_Line_Item__c> prLine = [SELECT Id,Name,Quantity__c,Quantity_Requested_On_PO_Line_Items__c,Status__c
                                             FROM PTS_Line_Item__c
                                             WHERE Id =: poLine.PTS_Line_Item__c];
            if(prLine.size()>0){
                System.debug('Current PR'+prLine.get(0).Name);
                Double d;
                d = prLine.get(0).Quantity_Requested_On_PO_Line_Items__c != null?
                    prLine.get(0).Quantity_Requested_On_PO_Line_Items__c - poLine.Quantity_Requested__c :
                0;
                prLine.get(0).Quantity_Requested_On_PO_Line_Items__c =  d;
                prLine.get(0).Status__c = 'Pending Purchase Order';
                update prLine;
                System.debug('Quantity requested on POs : '+d+' On PR:  '+prLine.get(0).Quantity_Requested_On_PO_Line_Items__c+' On PO: '+poLine.Quantity_Requested__c );
            }
            poLine.Quantity_Requested__c = 0;
            if(Trigger.oldMap.get(poLine.Id).Unit_Net_Price__c != poLine.Unit_Net_Price__c
               || Trigger.oldMap.get(poLine.Id).Unit_Price__c != poLine.Unit_Price__c
               || Trigger.oldMap.get(poLine.Id).Purchase_Order_Item__c != poLine.Purchase_Order_Item__c
               || Trigger.oldMap.get(poLine.Id).VAT_Percentage__c != poLine.VAT_Percentage__c
               || Trigger.oldMap.get(poLine.Id).Vatable__c != poLine.Vatable__c
               || Trigger.oldMap.get(poLine.Id).VAT_inclusive__c != poLine.VAT_inclusive__c
               || Trigger.oldMap.get(poLine.Id).PTS_Line_Item__c != poLine.PTS_Line_Item__c
               //|| Trigger.oldMap.get(poLine.Id).Quantity_Requested__c != poLine.Quantity_Requested__c
               || Trigger.oldMap.get(poLine.Id).Quantity_Accepted__c != poLine.Quantity_Accepted__c
               || Trigger.oldMap.get(poLine.Id).Quantity_Remaining__c != poLine.Quantity_Remaining__c
              ){
                  poLine.addError('You are not allowed to Edit PO Line Item after it has been Cancelled');
              }
        }
        if(Trigger.oldMap.get(poLine.Id).Status__c == 'Cancelled' && poLine.Status__c != 'Cancelled'){
            poLine.addError('You are not allowed to change PO Line Item Status after it has been Cancelled');
        } 
        
        //calculate VI_Avg_Unit_Price__c and set Payment Status on the PO LINE
        decimal viAvgUnitPrice = 0.0; 
        decimal polineUnitPrice = 0.0; 

        try{
            if(poLine.VI_Recon_Total__c * poLine.VI_Recon_Qty_s__c > 0){
                viAvgUnitPrice = (poLine.VI_Recon_Total__c / poLine.VI_Recon_Qty_s__c);
                viAvgUnitPrice = viAvgUnitPrice.setScale(2); //Round Off
                polineUnitPrice = poLine.Unit_Gross_Price__c;
                polineUnitPrice = polineUnitPrice.setScale(2);
                
                if(viAvgUnitPrice <= 0){
                    poLine.Payment_Status__c = 'NO PAYMENTS MADE';
                } else if(viAvgUnitPrice < polineUnitPrice ){
                    poLine.Payment_Status__c = 'PARTIAL PAYMENTS DONE';
                } else if(viAvgUnitPrice > polineUnitPrice){
                    poLine.Payment_Status__c = 'OVERPAYMENT DONE';
                } else if(viAvgUnitPrice == polineUnitPrice && viAvgUnitPrice > 0){
                    poLine.Payment_Status__c = 'ALL PAYMENTS DONE';
                }
            } else {
                poLine.Payment_Status__c = 'NO PAYMENTS MADE';
            }
        }
        catch(Exception e){
            
        }
        
        
        //Update PO Line Receipt Status
        if(poLine.Quantity_Accepted__c > 0 && poLine.Quantity_Remaining__c > 0){
            poLine.Po_line_Receipt_Status__c = 'Items Partially Received';
            poLine.Status__c = 'Firmed';
        } else if(poLine.Quantity_Requested__c == poLine.Quantity_Accepted__c && poLine.Quantity_Requested__c <> 0){
            poLine.Po_line_Receipt_Status__c = 'All items Received';
            poLine.Status__c = 'Firmed';
        } else
        {
            poLine.Po_line_Receipt_Status__c = 'Open';
        }
        
        //Update PO Line Status
        //Set to closed 
        Double QtyRequested = poLine.Quantity_Requested__c == NULL ? 0 : poLine.Quantity_Requested__c;
        Double QtyAccepted = poLine.Quantity_Accepted__c == NULL ? 0 : poLine.Quantity_Accepted__c;
        String PaymentVariance = poLine.Payment_Variance__c == NULL ? '' : poLine.Payment_Variance__c;
        String ReceiptVariance = poLine.Receipt_Variance__c == NULL ? '' : poLine.Receipt_Variance__c;
        if(
            (	poLine.VI_Avg_Unit_Price__c * poLine.Unit_Gross_Price__c > 0 && 	// Both <> 0
                poLine.VI_Avg_Unit_Price__c == poLine.Unit_Gross_Price__c &&		//Reconciled values = POLI Price
                poLine.Quantity_Accepted__c == poLine.Quantity_Requested__c &&		//All Items Received
                poLine.Quantity_Accepted__c * poLine.Quantity_Requested__c > 0		//Both <> 0
            )
           || //if Payment or Receipt variance exists and has been reconciled
            (
                (	
                    poLine.VI_Avg_Unit_Price__c * poLine.Unit_Gross_Price__c > 0 && 		// both <> 0
                    (poLine.VI_Avg_Unit_Price__c != poLine.Unit_Gross_Price__c && PaymentVariance.contains('POLI CLOSE OVERRIDE')== TRUE) 	//Reconciled but variance exists and has been overriden
                )
                ||
                (
                    QtyAccepted * QtyRequested > 0 &&	//Both <> 0
                    (QtyAccepted != QtyRequested && ReceiptVariance.contains('POLI CLOSE OVERRIDE')== TRUE )
                )
            )
        ){
            poLine.Status__c = 'Closed';
        }
    }
    
}



/*
trigger POLineItemEditingValidation on Purchase_Order_Line_Item__c (before update) {
for(Purchase_Order_Line_Item__c poLine:Trigger.new){
if(poLine.Purchase_Order__c != null){
if(Trigger.oldMap.get(poLine.Id).Unit_Net_Price__c != poLine.Unit_Net_Price__c
|| Trigger.oldMap.get(poLine.Id).Unit_Price__c != poLine.Unit_Price__c
|| Trigger.oldMap.get(poLine.Id).Purchase_Order_Item__c != poLine.Purchase_Order_Item__c
|| Trigger.oldMap.get(poLine.Id).VAT_Percentage__c != poLine.VAT_Percentage__c
|| Trigger.oldMap.get(poLine.Id).Vatable__c != poLine.Vatable__c
|| Trigger.oldMap.get(poLine.Id).VAT_inclusive__c != poLine.VAT_inclusive__c
|| Trigger.oldMap.get(poLine.Id).PTS_Line_Item__c != poLine.PTS_Line_Item__c
|| Trigger.oldMap.get(poLine.Id).Quantity_Requested__c != poLine.Quantity_Requested__c
){
poLine.addError('You are not allowed to Edit PO Line Item after it has been created');
}
}
if(poLine.Invoice_Assigned__c == true && poLine.Purchase_Order__c != null){
if(Trigger.oldMap.get(poLine.Id).Unit_Net_Price__c != poLine.Unit_Net_Price__c
|| Trigger.oldMap.get(poLine.Id).Unit_Price__c != poLine.Unit_Price__c
|| Trigger.oldMap.get(poLine.Id).Purchase_Order_Item__c != poLine.Purchase_Order_Item__c
|| Trigger.oldMap.get(poLine.Id).VAT_Percentage__c != poLine.VAT_Percentage__c
|| Trigger.oldMap.get(poLine.Id).Vatable__c != poLine.Vatable__c
|| Trigger.oldMap.get(poLine.Id).VAT_inclusive__c != poLine.VAT_inclusive__c
|| Trigger.oldMap.get(poLine.Id).PTS_Line_Item__c != poLine.PTS_Line_Item__c
|| Trigger.oldMap.get(poLine.Id).Quantity_Requested__c != poLine.Quantity_Requested__c

|| poLine.Status__c == 'Cancelled'){
poLine.addError('You are not allowed to Edit or Cancel PO Line Item after Invoice has been generated');
}
}
if(Trigger.oldMap.get(poLine.Id).Status__c != poLine.Status__c && poLine.Status__c == 'Cancelled'){
List<PTS_Line_Item__c> prLine = [SELECT Id,Name,Quantity__c,Quantity_Requested_On_PO_Line_Items__c,Status__c
FROM PTS_Line_Item__c
WHERE Id =: poLine.PTS_Line_Item__c];

if(prLine.size()>0){

System.debug('Current PR'+prLine.get(0).Name);
Double d;
d = prLine.get(0).Quantity_Requested_On_PO_Line_Items__c != null?
prLine.get(0).Quantity_Requested_On_PO_Line_Items__c - poLine.Quantity_Requested__c :
0;
prLine.get(0).Quantity_Requested_On_PO_Line_Items__c =  d;
prLine.get(0).Status__c = 'Pending Purchase Order';
update prLine;
System.debug('Quantity requested on POs : '+d+' On PR:  '+prLine.get(0).Quantity_Requested_On_PO_Line_Items__c+' On PO: '+poLine.Quantity_Requested__c );
}
poLine.Quantity_Requested__c = 0;
if(Trigger.oldMap.get(poLine.Id).Unit_Net_Price__c != poLine.Unit_Net_Price__c
|| Trigger.oldMap.get(poLine.Id).Unit_Price__c != poLine.Unit_Price__c
|| Trigger.oldMap.get(poLine.Id).Purchase_Order_Item__c != poLine.Purchase_Order_Item__c
|| Trigger.oldMap.get(poLine.Id).VAT_Percentage__c != poLine.VAT_Percentage__c
|| Trigger.oldMap.get(poLine.Id).Vatable__c != poLine.Vatable__c
|| Trigger.oldMap.get(poLine.Id).VAT_inclusive__c != poLine.VAT_inclusive__c
|| Trigger.oldMap.get(poLine.Id).PTS_Line_Item__c != poLine.PTS_Line_Item__c
//|| Trigger.oldMap.get(poLine.Id).Quantity_Requested__c != poLine.Quantity_Requested__c
|| Trigger.oldMap.get(poLine.Id).Quantity_Accepted__c != poLine.Quantity_Accepted__c
|| Trigger.oldMap.get(poLine.Id).Quantity_Remaining__c != poLine.Quantity_Remaining__c
){
poLine.addError('You are not allowed to Edit PO Line Item after it has been Cancelled');
}
}
if(Trigger.oldMap.get(poLine.Id).Status__c == 'Cancelled' && poLine.Status__c != 'Cancelled'){
poLine.addError('You are not allowed to change PO Line Item Status after it has been Cancelled');
} 

}
}
*/