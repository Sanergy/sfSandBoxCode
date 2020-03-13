@isTest(SeeAllData=true)
public class TestCountC2CforAgriculturalSaleOpp {
    static testMethod void testCountC2C(){
         /*(RecordTypeId ='012D0000000KGCKIA4' OR RecordTypeId ='012D0000000KGBlIAO'
                                        OR RecordTypeId ='012D0000000KGCtIAO' OR RecordTypeId ='012D0000000KGB7IAO' 
                                        OR RecordTypeId ='012D0000000KFz6IAG')*/
       /* List<Farmstar_C2C_Visit__c> c22 = [SELECT Id,Name,Opportunity__c,Opportunity_Stage__c,Close_Date__c,Delivery_Method__c,
                                           Sales_Order_Signed__c,Create_Opportunity__c,
                                           Delivery_instructions__c,Payment_Method__c,Payment_Schedule__c,Primary_Salesperson__c,
                                           Preferred_Delivery_Pickup_Date_Time__c,Deposit_Amount_Received__c,Free_or_Discounted_Trial__c
                                          FROM Farmstar_C2C_Visit__c WHERE Opportunity__c != null 
                                          // AND Create_Opportunity__c = false
                                          AND Sales_Order_Signed__c != 'Yes'];
        if(c22.size()>0){
            //c22.get(0).Opportunity_Stage__c = 'Closing';
            c22.get(0).Opportunity__c = null;
            c22.get(0).Close_Date__c = Date.today()+90;
            c22.get(0).Delivery_Method__c = 'Delivery';
            c22.get(0).Delivery_instructions__c = 'assds';
            c22.get(0).Payment_Method__c = 'Cash';
            c22.get(0).Payment_Schedule__c = 'Upfront';
			
            c22.get(0).Preferred_Delivery_Pickup_Date_Time__c = dateTime.now();
            c22.get(0).Deposit_Amount_Received__c = 100000;
            c22.get(0).Free_or_Discounted_Trial__c = 'No';
           // c22.get(0).Sales_Order_Signed__c = 'Yes'; 
            //update c22;
            
            c22.get(0).Create_Opportunity__c = true;
            c22.get(0).Opportunity_Stage__c = 'Sale Confirmed';
            update c22;
        }*/
        
        Opportunity opportunity = [SELECT Id,AccountId, StageName,Primary_Salesperson__c 
                                   FROM Opportunity
                                   WHERE RecordTypeId = '012D0000000KGBlIAO' 
                                   AND StageName = 'Sale Confirmed'
                                   Limit 1];
        
        opportunity.Opportunity_Type__c = 'KuzaPro Sale'; 
        UPDATE opportunity;
        
        if(opportunity!= null){
            
            List<Product2> product = [SELECT Id,Name FROM Product2 WHERE Name = 'EVERGROW - [25KG]'];
            if(product.size()>0){
                List<Product2> product2 = [SELECT Id,Name FROM Product2 WHERE Name = 'Evergrow - [35Kg]'];
                if(product2.size()>0){
                    List<Product2> product3 = [SELECT Id,Name FROM Product2 WHERE Name = 'Evergrow - [50Kg]'];
                    if(product3.size()>0){
                        List<Product2> product4 = [SELECT Id,Name FROM Product2 WHERE Name = 'Evergrow - [5Kg]'];
                        if(product4.size()>0){
                            
                            Farmstar_C2C_Visit__c c2c = new Farmstar_C2C_Visit__c();
                            c2c.Account__c = opportunity.AccountId;
                            c2c.Earlier_fruit_pod_formation__c = true;
                            c2c.Collected_renewal_order__c = true;
                            c2c.Close_Date__c = date.today()+90;
                            c2c.Sales_Order_Signed__c = 'Yes';
                            
                            c2c.Bigger_fruits__c = true;
                            c2c.Opportunity_Product__c = product3.get(0).Id;
                            c2c.Opportunity_Product2__c = product2.get(0).Id;
                            c2c.Opportunity_Product3__c = product.get(0).Id;
                            c2c.Opportunity_Product4__c = product4.get(0).Id;
                            c2c.Evergrow_25Kg_Quantity__c = 1;
                            c2c.Evergrow_35Kg_Quantity__c = 1;
                            c2c.Evergrow_50Kg_Quantity__c = 1;
                            c2c.Evergrow_5Kg_Quantity__c = 1;
                            c2c.Create_Opportunity__c = true;
                            c2c.Very_Next_Step__c = 'wer';
                            c2c.Very_Next_Step_Date__c = date.today() +1;
                            c2c.Opportunity_Stage__c = 'Sale Confirmed';
                            c2c.Close_Date__c = Date.today()+90;
                            c2c.Delivery_Method__c = 'Delivery';
                            c2c.Delivery_instructions__c = 'assds';
                            
                            c2c.Opportunity__c = opportunity.Id;
                            c2c.Payment_Method__c = 'Cash';
                            c2c.Payment_Schedule__c = 'Upfront';
                            c2c.Primary_Salesperson__c = opportunity.Primary_Salesperson__c;
                            c2c.Preferred_Delivery_Pickup_Date_Time__c = dateTime.now();
                            c2c.Deposit_Amount_Received__c = 100000;
                            c2c.Free_or_Discounted_Trial__c = 'No';
                            insert c2c;                
                            
                            
                            Farmstar_C2C_Visit__c c2 = new Farmstar_C2C_Visit__c();
                            c2.Account__c = opportunity.AccountId;
                            c2.Earlier_fruit_pod_formation__c = true;
                            c2.Collected_renewal_order__c = true;
                            c2.Close_Date__c = date.today()+90;
                            c2.Sales_Order_Signed__c = 'Yes';
                            
                            c2.Bigger_fruits__c = true;
                            c2.Opportunity_Product__c = product3.get(0).Id;
                            c2.Opportunity_Product2__c = product2.get(0).Id;
                            c2.Opportunity_Product3__c = product.get(0).Id;
                            c2.Opportunity_Product4__c = product4.get(0).Id;
                            c2.Evergrow_25Kg_Quantity__c = 1;
                            c2.Evergrow_35Kg_Quantity__c = 1;
                            c2.Evergrow_50Kg_Quantity__c = 1;
                            c2.Evergrow_5Kg_Quantity__c = 1;
                            c2.Create_Opportunity__c = true;
                            c2.Very_Next_Step__c = 'wer';
                            c2.Very_Next_Step_Date__c = date.today() +1;
                            c2.Opportunity_Stage__c = 'Closing';
                            c2.Close_Date__c = Date.today()+90;
                            c2.Delivery_Method__c = 'Delivery';
                            c2.Delivery_instructions__c = 'assds';
                            
                            c2.Opportunity__c = null;
                            c2.Payment_Method__c = 'Cash';
                            c2.Payment_Schedule__c = 'Upfront';
                            c2.Primary_Salesperson__c = opportunity.Primary_Salesperson__c;
                            c2.Preferred_Delivery_Pickup_Date_Time__c = dateTime.now();
                            c2.Deposit_Amount_Received__c = 100000;
                            c2.Free_or_Discounted_Trial__c = 'No';
                            
                            insert c2;
                            c2.Very_Next_Step__c = 'true';
                            c2.Very_Next_Step_Date__c = date.today();
                            update c2;
                            
                            c2.Create_Opportunity__c = false;
                            update c2; 
                            
                            c2.Create_Opportunity__c = true;
                            update c2; 
                            
                            c2.Create_Opportunity__c = false;
                            update c2; 
                            
                            /*c2.Create_Opportunity__c = true;
c2.Opportunity_Stage__c = 'Sale Confirmed';
update c2;*/
                            
                            opportunity.Sale_Made__c = 'No';
                            opportunity.Ag_Sales_Dummy_Stage__c  = 'Close Sale';
                            Update opportunity;
                            
                            
                            
                            opportunity.Sale_Made__c = 'Yes';
                            opportunity.Ag_Sales_Dummy_Stage__c  = 'Schedule Followup';
                            Update opportunity;
                            
                            opportunity.Ag_Sales_Dummy_Stage__c  = 'Collect Deposit Balance';
                            Update opportunity;
                            
                            opportunity.Ag_Sales_Dummy_Stage__c  = 'Lost';
                            Update opportunity;
                            
                            c2c.Opportunity_Stage__c = 'Closing';
                            
                            
                            update c2c;
                        }
                    }
                }
            }
        }
        
    }
    
}