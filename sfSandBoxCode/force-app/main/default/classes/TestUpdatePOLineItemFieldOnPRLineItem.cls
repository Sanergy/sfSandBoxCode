@isTest(SeeAllData=true)
public class TestUpdatePOLineItemFieldOnPRLineItem {
    static testMethod void testUpdatePOLineItemFieldOnPRLineItem() {
       /* List<Purchase_Order__c> po = [SELECT Id,Name,Company__c FROM Purchase_Order__c
                                     ];
        if(po.size()>0){
            
            List<PTS_Line_Item__c> prLine = [SELECT Id,Name FROM PTS_Line_Item__c];
            if(prLine.size()>0){
                
                Purchase_Order_Line_Item__c poLine = new Purchase_Order_Line_Item__c();
                poLine.Purchase_Order__c = po.get(0).Id;
                poLine.Quantity_Requested__c = 1;
                poLine.Status__c = 'Open';
                poLine.Unit_Price__c = 100;
                poLine.Variation_Notes__c = 'notes';

                poLine.PTS_Line_Item__c = prLine.get(0).Id;
                poLine.Requesting_Company__c = po.get(0).Company__c;
                
                insert poLine;
            
                }
        }*/
    }

}