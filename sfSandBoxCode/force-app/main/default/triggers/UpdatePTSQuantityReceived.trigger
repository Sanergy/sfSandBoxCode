trigger UpdatePTSQuantityReceived on Purchase_Order_Line_Item__c (after update) {
    /*for(Purchase_Order_Line_Item__c poLine: Trigger.new){
       if(poLine.Quantity_Accepted__c!=null && Trigger.oldMap.get(poLine.id).Quantity_Accepted__c!=poLine.Quantity_Accepted__c
          && poLine.PTS_Line_Item__c!=null){
           
           Decimal newValue = poLine.Quantity_Accepted__c;

           Decimal oldValue = Trigger.oldMap.get(poLine.id).Quantity_Accepted__c == null? 0 : Trigger.oldMap.get(poLine.id).Quantity_Accepted__c;
           
           Decimal difference=newValue - oldValue;
           
           //get the PTS Line
           List<PTS_Line_Item__c> ptsLine=[SELECT Qty_Delivered__c 
                                           FROM PTS_Line_Item__c
                                           WHERE ID=:poLine.PTS_Line_Item__c];
                                           
           if(ptsLine.size()>0 && Utils.transactionHasOccurred()==false){
              ptsLine.get(0).Qty_Delivered__c = ptsLine.get(0).Qty_Delivered__c == null ? difference : ptsLine.get(0).Qty_Delivered__c+difference;
             
              
              update ptsLine;
          }
       }
    }*/
}