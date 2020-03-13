trigger CreateAgSaleOpportunityFromC2C on Farmstar_C2C_Visit__c (before insert,before update) {
    for(Farmstar_C2C_Visit__c visit:Trigger.New){
        if(Trigger.isInsert){
            if(visit.Very_Next_Step__c != null && visit.Very_Next_Step_Date__c != null){
                List<Opportunity> opportune = [SELECT Name,Id,StageName,Very_Next_Step__c,Very_Next_Step_Date__c,CreatedDate,AccountId
                                              FROM Opportunity WHERE AccountId =: visit.Account__c AND StageName = 'Closing'
                                              ORDER BY CreatedDate ASC
                                              Limit 3 ];
                if(opportune.size()>0){
                    opportune.get(0).Very_Next_Step__c = visit.Very_Next_Step__c;
                    opportune.get(0).Very_Next_Step_Date__c = visit.Very_Next_Step_Date__c;
                    Update opportune;
                }
            }
            if(visit.Create_Opportunity__c && visit.Opportunity_Stage__c == 'Sale Confirmed' && visit.Opportunity__c == null &&( visit.Opportunity_Product__c != null || visit.Opportunity_Product2__c != null || visit.Opportunity_Product3__c != null || visit.Opportunity_Product4__c != null)){
            String str;
           try{
            //create a new AG Sale Opp
                Opportunity	newOp = new Opportunity();
                    newOp.Name = 'x';
                    newOp.RecordTypeId = '012D0000000KGB7IAO';
                    newOp.AccountId = visit.Account__c;
                    newOp.Additional_Notes__c = visit.Additional_Notes__c;
                    newOp.Acres_Evergrow_will_be_used_on__c = visit.Acres_Evergrow_will_be_used_on__c;
                    newOp.Balance_Amount_Owed__c =  visit.Balance_Amount_Owed__c;
                    newOp.CloseDate = visit.Close_Date__c;
                    newOp.Crop_Evergrow_will_be_Used_On__c = visit.Crop_Evergrow_will_be_Used_On__c;
                    newOp.Delivery__c = visit.Delivery_instructions__c;
                    newOp.Delivery_Method__c = visit.Delivery_Method__c;
                    newOp.Deposit_Amount_Received__c = visit.Deposit_Amount_Received__c;
                    newOp.Expected_Close_Date__c = visit.Expected_Close_Date__c;
                    newOp.Expected_ROI_per_Acre__c = visit.Expected_ROI_per_Acre__c;
                    newOp.Free_or_Discounted_Trial__c = visit.Free_or_Discounted_Trial__c;
                    newOp.GPS_Latitude__c = visit.GPS_Latitude__c;
                    newOp.GPS_Longitude__c = visit.GPS_Longitude__c;
                    newOp.M_Pesa_Code__c = visit.M_Pesa_Code__c;
                    newOp.Next_Planting_Crop__c = visit.Next_Planting_Crop__c;
                    newOp.Next_Sale_Target__c = visit.Next_Sale_Target__c;
                    newOp.Opening_Date__c = visit.Opening_Date__c;
                    newOp.StageName = 'Closing';
                    newOp.Payment_Method__c = visit.Payment_Method__c;
                    newOp.Payment_Schedule__c = visit.Payment_Schedule__c;
                    newOp.Phone_Number__c = visit.Phone_Number__c;
                    newOp.Planned_Balance_Collection_Date__c = visit.Planned_Balance_Collection_Date__c;
                    newOp.Planned_Planting_Date__c = visit.Planned_Planting_Date__c;
                    newOp.Preferred_Delivery_Pickup_Date_Time__c = visit.Preferred_Delivery_Pickup_Date_Time__c;
                    newOp.Primary_Salesperson__c = visit.Primary_Salesperson__c;
                    newOp.Priority__c = visit.Priority__c;
                    newOp.Probability = visit.Probability__c;
                    newOp.Purchase_Tons__c = visit.Purchase_Kgs__c;
                    newOp.Reason_Why_Lost_other__c = visit.Reason_Why_Lost_other__c;
                    newOp.Sales_Order_Signed__c = visit.Sales_Order_Signed__c;
                    newOp.Target_Sales_Volume__c = visit.Target_Sales_Volume__c;
                    newOp.Territory_Pocket__c = visit.Territory_Pocket__c;
                   
                    insert newOp;                      
		            str = newOp.Id;
                 
        if(visit.Opportunity_Product__c != null && visit.Evergrow_50Kg_Quantity__c != null ){
            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product__c];
				List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_50Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                }
            }        
        }
            
            if(visit.Opportunity_Product2__c != null && visit.Evergrow_35Kg_Quantity__c != null){
              
            
            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product2__c];
              	List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_35Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                }
            }        
            }
            
            if(visit.Opportunity_Product3__c != null && visit.Evergrow_25Kg_Quantity__c!= null){
                
            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product3__c];
               	List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_25Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                }
            }
            }
            
            if(visit.Opportunity_Product4__c != null && visit.Evergrow_5Kg_Quantity__c != null){

            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product4__c];
              	List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_5Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                }
            }
            }
            
                newOp.StageName = visit.Opportunity_Stage__c;
        		update newOp;
            } catch(System.DmlException q){
                visit.addError(q.getMessage());
            }
        }
            if(visit.Create_Opportunity__c && visit.Opportunity_Stage__c == 'Closing' && visit.Opportunity__c == null && visit.Close_Date__c != null && visit.Sales_Order_Signed__c != null){
            
              Opportunity newOp = new Opportunity();
                    newOp.Name = 'x';
                    newOp.RecordTypeId = '012D0000000KGB7IAO';
                    newOp.AccountId = visit.Account__c;
                    newOp.Additional_Notes__c = visit.Additional_Notes__c;
                    newOp.Acres_Evergrow_will_be_used_on__c = visit.Acres_Evergrow_will_be_used_on__c;
                    newOp.Balance_Amount_Owed__c =  visit.Balance_Amount_Owed__c;
                    newOp.CloseDate = visit.Close_Date__c;
                    newOp.Crop_Evergrow_will_be_Used_On__c = visit.Crop_Evergrow_will_be_Used_On__c;
                    newOp.Delivery__c = visit.Delivery_instructions__c;
                    newOp.Delivery_Method__c = visit.Delivery_Method__c;
                    newOp.Deposit_Amount_Received__c = visit.Deposit_Amount_Received__c;
                    newOp.Expected_Close_Date__c = visit.Expected_Close_Date__c;
                    newOp.Expected_ROI_per_Acre__c = visit.Expected_ROI_per_Acre__c;
                    newOp.Free_or_Discounted_Trial__c = visit.Free_or_Discounted_Trial__c;
                    newOp.GPS_Latitude__c = visit.GPS_Latitude__c;
                    newOp.GPS_Longitude__c = visit.GPS_Longitude__c;
                    newOp.M_Pesa_Code__c = visit.M_Pesa_Code__c;
                    newOp.Next_Planting_Crop__c = visit.Next_Planting_Crop__c;
                    newOp.Next_Sale_Target__c = visit.Next_Sale_Target__c;
                    newOp.Opening_Date__c = visit.Opening_Date__c;
                    newOp.StageName = visit.Opportunity_Stage__c;
                    newOp.Payment_Method__c = visit.Payment_Method__c;
                    newOp.Payment_Schedule__c = visit.Payment_Schedule__c;
                    newOp.Phone_Number__c = visit.Phone_Number__c;
                    newOp.Planned_Balance_Collection_Date__c = visit.Planned_Balance_Collection_Date__c;
                    newOp.Planned_Planting_Date__c = visit.Planned_Planting_Date__c;
                    newOp.Preferred_Delivery_Pickup_Date_Time__c = visit.Preferred_Delivery_Pickup_Date_Time__c;
                    newOp.Primary_Salesperson__c = visit.Primary_Salesperson__c;
                    newOp.Priority__c = visit.Priority__c;
                    newOp.Probability = visit.Probability__c;
                    newOp.Purchase_Tons__c = visit.Purchase_Kgs__c;
                    newOp.Reason_Why_Lost_other__c = visit.Reason_Why_Lost_other__c;
                    newOp.Sales_Order_Signed__c = visit.Sales_Order_Signed__c;
                    newOp.Target_Sales_Volume__c = visit.Target_Sales_Volume__c;
                    newOp.Territory_Pocket__c = visit.Territory_Pocket__c;
                  
                    insert newOp;
        } 
        }
    if(Trigger.isUpdate){
        if(visit.Very_Next_Step__c != Trigger.oldMap.get(visit.Id).Very_Next_Step__c && visit.Very_Next_Step_Date__c != Trigger.oldMap.get(visit.Id).Very_Next_Step_Date__c ){
            List<Opportunity> opportune = [SELECT Name,Id,StageName,Very_Next_Step__c,Very_Next_Step_Date__c,CreatedDate,AccountId
                                          FROM Opportunity WHERE AccountId =: visit.Account__c AND StageName = 'Closing'
                                          ORDER BY CreatedDate ASC
                                          Limit 3 ];
            if(opportune.size()>0){
                opportune.get(0).Very_Next_Step__c = visit.Very_Next_Step__c;
                opportune.get(0).Very_Next_Step_Date__c = visit.Very_Next_Step_Date__c;
                Update opportune;
            }
        }
        if(visit.Create_Opportunity__c && visit.Create_Opportunity__c != Trigger.oldMap.get(visit.Id).Create_Opportunity__c && visit.Opportunity_Stage__c == 'Sale Confirmed' && visit.Opportunity__c == null &&( visit.Opportunity_Product__c != null || visit.Opportunity_Product2__c != null || visit.Opportunity_Product3__c != null || visit.Opportunity_Product4__c != null)){
            String str;
           try{
            //create a new AG Sale Opp
                Opportunity	newOp = new Opportunity();
                    newOp.Name = 'x';
                    newOp.RecordTypeId = '012D0000000KGB7IAO';
                    newOp.AccountId = visit.Account__c;
                    newOp.Additional_Notes__c = visit.Additional_Notes__c;
                    newOp.Acres_Evergrow_will_be_used_on__c = visit.Acres_Evergrow_will_be_used_on__c;
                    newOp.Balance_Amount_Owed__c =  visit.Balance_Amount_Owed__c;
                    newOp.CloseDate = visit.Close_Date__c;
                    newOp.Crop_Evergrow_will_be_Used_On__c = visit.Crop_Evergrow_will_be_Used_On__c;
                    newOp.Delivery__c = visit.Delivery_instructions__c;
                    newOp.Delivery_Method__c = visit.Delivery_Method__c;
                    newOp.Deposit_Amount_Received__c = visit.Deposit_Amount_Received__c;
                    newOp.Expected_Close_Date__c = visit.Expected_Close_Date__c;
                    newOp.Expected_ROI_per_Acre__c = visit.Expected_ROI_per_Acre__c;
                    newOp.Free_or_Discounted_Trial__c = visit.Free_or_Discounted_Trial__c;
                    newOp.GPS_Latitude__c = visit.GPS_Latitude__c;
                    newOp.GPS_Longitude__c = visit.GPS_Longitude__c;
                    newOp.M_Pesa_Code__c = visit.M_Pesa_Code__c;
                    newOp.Next_Planting_Crop__c = visit.Next_Planting_Crop__c;
                    newOp.Next_Sale_Target__c = visit.Next_Sale_Target__c;
                    newOp.Opening_Date__c = visit.Opening_Date__c;
                    newOp.StageName = 'Closing';
                    newOp.Payment_Method__c = visit.Payment_Method__c;
                    newOp.Payment_Schedule__c = visit.Payment_Schedule__c;
                    newOp.Phone_Number__c = visit.Phone_Number__c;
                    newOp.Planned_Balance_Collection_Date__c = visit.Planned_Balance_Collection_Date__c;
                    newOp.Planned_Planting_Date__c = visit.Planned_Planting_Date__c;
                    newOp.Preferred_Delivery_Pickup_Date_Time__c = visit.Preferred_Delivery_Pickup_Date_Time__c;
                    newOp.Primary_Salesperson__c = visit.Primary_Salesperson__c;
                    newOp.Priority__c = visit.Priority__c;
                    newOp.Probability = visit.Probability__c;
                    newOp.Purchase_Tons__c = visit.Purchase_Kgs__c;
                    newOp.Reason_Why_Lost_other__c = visit.Reason_Why_Lost_other__c;
                    newOp.Sales_Order_Signed__c = visit.Sales_Order_Signed__c;
                    newOp.Target_Sales_Volume__c = visit.Target_Sales_Volume__c;
                    newOp.Territory_Pocket__c = visit.Territory_Pocket__c;
                   
                    insert newOp;
                       
            //visit.Opportunity__c = newOp.Id;
            str = newOp.Id;
            //System.debug('DDDDDDDDDD'+newOp.Id);
                 
        if(visit.Opportunity_Product__c != null && visit.Evergrow_50Kg_Quantity__c != null ){
            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product__c];
                //System.debug('DDDDDDDDDD'+p.Name);
                // Find relevant entries
				List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    //System.debug('DDDDDDDDDD'+record.get(0).Name);
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_50Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                    //System.debug('DDDDDDDDDD'+product.Name);
                }
            }        
        }
            
            if(visit.Opportunity_Product2__c != null && visit.Evergrow_35Kg_Quantity__c != null){
              
            
            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product2__c];
                //System.debug('DDDDDDDDDD'+p.Name);
                // Find relevant entries
				List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    //System.debug('DDDDDDDDDD'+record.get(0).Name);
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_35Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                    //System.debug('DDDDDDDDDD'+product.Name);
                }
            }        
            }
            
            if(visit.Opportunity_Product3__c != null && visit.Evergrow_25Kg_Quantity__c!= null){
                
            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product3__c];
                //System.debug('DDDDDDDDDD'+p.Name);
                // Find relevant entries
				List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    //System.debug('DDDDDDDDDD'+record.get(0).Name);
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_25Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                    //System.debug('DDDDDDDDDD'+product.Name);
                }
            }
            }
            
            if(visit.Opportunity_Product4__c != null && visit.Evergrow_5Kg_Quantity__c != null){

            List<pricebook2> pb = [select id from pricebook2 where name = 'Agricultural Products Sales'];
            if(pb.size()>0){
                Product2 p = [SELECT Id,Name FROM Product2 WHERE Id =: visit.Opportunity_Product4__c];
                //System.debug('DDDDDDDDDD'+p.Name);
                // Find relevant entries
				List<PricebookEntry> record =[select id,Name,unitprice,product2id,product2.name 
                                              from PricebookEntry 
                                              where product2.name =: p.Name 
                                              and pricebook2id =:pb.get(0).id];
                if(record.size()>0){
                    //System.debug('DDDDDDDDDD'+record.get(0).Name);
                    OpportunityLineItem product = new OpportunityLineItem();
                	product.OpportunityId = newOp.Id;
                    product.Quantity = visit.Evergrow_5Kg_Quantity__c;
               		product.PricebookEntryId = record.get(0).Id;
                    product.UnitPrice = record.get(0).unitprice;
                    insert product;
                    //System.debug('DDDDDDDDDD'+product.Name);
                }
            }
            }
            
                newOp.StageName = visit.Opportunity_Stage__c;
        		update newOp;
            } catch(System.DmlException q){
                visit.addError(q.getMessage());
            }
        }
        if(visit.Create_Opportunity__c && visit.Create_Opportunity__c != Trigger.oldMap.get(visit.Id).Create_Opportunity__c  && visit.Opportunity_Stage__c == 'Closing' && visit.Opportunity__c == null && visit.Close_Date__c != null && visit.Sales_Order_Signed__c != null){
            
              Opportunity newOp = new Opportunity();
                    newOp.Name = 'x';
                    newOp.RecordTypeId = '012D0000000KGB7IAO';
                    newOp.AccountId = visit.Account__c;
                    newOp.Additional_Notes__c = visit.Additional_Notes__c;
                    newOp.Acres_Evergrow_will_be_used_on__c = visit.Acres_Evergrow_will_be_used_on__c;
                    newOp.Balance_Amount_Owed__c =  visit.Balance_Amount_Owed__c;
                    newOp.CloseDate = visit.Close_Date__c;
                    newOp.Crop_Evergrow_will_be_Used_On__c = visit.Crop_Evergrow_will_be_Used_On__c;
                    newOp.Delivery__c = visit.Delivery_instructions__c;
                    newOp.Delivery_Method__c = visit.Delivery_Method__c;
                    newOp.Deposit_Amount_Received__c = visit.Deposit_Amount_Received__c;
                    newOp.Expected_Close_Date__c = visit.Expected_Close_Date__c;
                    newOp.Expected_ROI_per_Acre__c = visit.Expected_ROI_per_Acre__c;
                    newOp.Free_or_Discounted_Trial__c = visit.Free_or_Discounted_Trial__c;
                    newOp.GPS_Latitude__c = visit.GPS_Latitude__c;
                    newOp.GPS_Longitude__c = visit.GPS_Longitude__c;
                    newOp.M_Pesa_Code__c = visit.M_Pesa_Code__c;
                    newOp.Next_Planting_Crop__c = visit.Next_Planting_Crop__c;
                    newOp.Next_Sale_Target__c = visit.Next_Sale_Target__c;
                    newOp.Opening_Date__c = visit.Opening_Date__c;
                    newOp.StageName = visit.Opportunity_Stage__c;
                    newOp.Payment_Method__c = visit.Payment_Method__c;
                    newOp.Payment_Schedule__c = visit.Payment_Schedule__c;
                    newOp.Phone_Number__c = visit.Phone_Number__c;
                    newOp.Planned_Balance_Collection_Date__c = visit.Planned_Balance_Collection_Date__c;
                    newOp.Planned_Planting_Date__c = visit.Planned_Planting_Date__c;
                    newOp.Preferred_Delivery_Pickup_Date_Time__c = visit.Preferred_Delivery_Pickup_Date_Time__c;
                    newOp.Primary_Salesperson__c = visit.Primary_Salesperson__c;
                    newOp.Priority__c = visit.Priority__c;
                    newOp.Probability = visit.Probability__c;
                    newOp.Purchase_Tons__c = visit.Purchase_Kgs__c;
                    newOp.Reason_Why_Lost_other__c = visit.Reason_Why_Lost_other__c;
                    newOp.Sales_Order_Signed__c = visit.Sales_Order_Signed__c;
                    newOp.Target_Sales_Volume__c = visit.Target_Sales_Volume__c;
                    newOp.Territory_Pocket__c = visit.Territory_Pocket__c;
                  
                    insert newOp;
        } 
        //else {visit.addError('Please at least fill Opportunity Stage, Close Date And Sales Order Signed Fields for the Opportunity you want to Create');}
    }
    }
}