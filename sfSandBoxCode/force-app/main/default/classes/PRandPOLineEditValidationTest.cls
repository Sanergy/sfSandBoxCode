@isTest(SeeAllData = true)
public class PRandPOLineEditValidationTest {
    static testMethod void testPOLineEditValidation(){
        
      try {
         List<Purchase_Order_Line_Item__c> poLine = [SELECT Id,Invoice_Assigned__c, Name,Status__c,PTS_Line_Item__c
                                                   FROM Purchase_Order_Line_Item__c
                                                   WHERE Status__c = 'Open' Limit 3];
        if(poLine.size()>0){
           /* poLine.get(0).Invoice_Assigned__c = false;
            poLine.get(0).Vatable__c = false;
            poLine.get(0).Variation_Notes__c = 'n';
            update poLine;
            
            poLine.get(0).Invoice_Assigned__c = true;
            poLine.get(0).Vatable__c = true;
            update poLine;*/
            
            poLine.get(0).Invoice_Assigned__c = true;
            poLine.get(0).Status__c = 'Cancelled';
            poLine.get(0).Variation_Notes__c = 'n';
            update poLine;
            
            poLine.get(0).Invoice_Assigned__c = false;
            poLine.get(0).Status__c = 'Cancelled';
            poLine.get(0).Variation_Notes__c = 'n';
            update poLine;
            
            poLine.get(0).Variation_Notes__c = 'open';
            poLine.get(0).Vatable__c = true;
            update poLine;
           
        }
       List<Purchase_Order_Line_Item__c> poLine2 = [SELECT Id,Unit_Price__c,Invoice_Assigned__c, Name,Status__c,PTS_Line_Item__c
                                                   FROM Purchase_Order_Line_Item__c
                                                   WHERE Status__c = 'Open' Limit 3];
        if(poLine.size()>0){
           
            poLine2.get(0).Status__c = 'Cancelled';
            poLine2.get(0).Quantity_Accepted__c = 2;
            poLine2.get(0).Unit_Price__c = 1000;
            poLine2.get(0).Invoice_Assigned__c = false;
            update poLine2;
           
        }
          } catch (Exception e) {
                 e.getMessage();
            }
            
        }
    static testMethod void testPRLineEditValidation(){
        
      try {
         
          List<PTS_Line_Item__c> prLine = [SELECT Id,Item__c, Name,Status__c,Quantity__c
                                             From PTS_Line_Item__c
                                             WHERE Status__c = 'Open' Limit 3];
            if(prLine.size()>0){
                prLine.get(0).Status__c = 'Cancelled';
                update prLine;
                prLine.get(0).Item__c = 'item x';
                update prLine;
             }
            } catch (Exception e) {
                 e.getMessage();
            }
            
        }
}