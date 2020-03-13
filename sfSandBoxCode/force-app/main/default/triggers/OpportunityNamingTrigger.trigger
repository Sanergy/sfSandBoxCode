trigger OpportunityNamingTrigger on Opportunity (before insert,before update) {
    
    for(Opportunity opportunity: Trigger.new){
        
        //Current timestamp
        Datetime dt = datetime.now();        
        
        //Check if created date is null
        if(opportunity.CreatedDate == null){
            //Convert Date to DateTime
            Date dateToday = Date.today();
            dt = dateToday;
        }else{
            dt = opportunity.CreatedDate;
        }
        
        //Format the DateTime
        String todaysDate = dt.format('dd/MM/YYYY');
        String formattedDate = ' , (' + todaysDate + ') - ';
        
        System.debug('opportunity.RecordTypeId: = ' + opportunity.RecordTypeId);
        
        //Agricultural Product Sales - Payment Opportunity     
        if(opportunity.RecordTypeId == '012D0000000KGBlIAO'){
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId];
            
            System.debug('Agricultural Sales Opportunities: = ' + customerAccount);
            
            opportunity.Name = customerAccount.Name + formattedDate + opportunity.Opportunity_Type__c;
            
            /*Check if Opportunity type is empty/null/whitespace
            if(String.isBlank(opportunity.Opportunity_Type__c)){
                
                opportunity.adderror('You must select the Opportunity Type');
                
            }else{
                
                Account customerAccount = [SELECT Id,Name
                                           FROM Account
                                           WHERE ID =: opportunity.AccountId];
                
                System.debug('Agricultural Sales Opportunities: = ' + customerAccount);
                
                opportunity.Name = customerAccount.Name + formattedDate + opportunity.Opportunity_Type__c;
                
            } //End if(String.isBlank(opportunity.Opportunity_Type__c))*/
            
        }//End Agricultural Product Sales - Payment Opportunity
        
        //Toilet Sale Opportunity - ('Toilet Sale - Prospect Management' / 'Toilet Sale - Launch Management'/
        //'Toilet Sale - Application Management' / 'Toilet Sale - Deposit Management')
        if(opportunity.RecordTypeId == '012D0000000K1bvIAC' || opportunity.RecordTypeId == '012D0000000K1c5IAC' ||
           opportunity.RecordTypeId == '012D0000000KE82IAG' || opportunity.RecordTypeId == '012D0000000KE85IAG'){
               
               Account customerAccount = [SELECT Id,Name
                                          FROM Account
                                          WHERE ID =: opportunity.AccountId];
               
               System.debug('Toilet Sales Opportunities: = ' + customerAccount);
               
               opportunity.Name = customerAccount.Name + formattedDate + 'Toilet Sale';
               
           }//End Toilet Sale Opportunity
        
        //Toilet Renewal Sale Opportunity
        if(opportunity.RecordTypeId == '012D0000000KE84IAG'){
            
            Toilet__c customerToilet = [SELECT Id,Name,Opportunity__c,Opportunity__r.Name
                                        FROM Toilet__c 
                                        WHERE Id =: opportunity.Toilet__c
                                       ];
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId];
            
            System.debug('Toilet Renewal Sales Opportunities: = ' + customerAccount);
            
            opportunity.Name = customerAccount.Name + ' , ' + customerToilet.Name + formattedDate + 'Renewal Sale';
            
        }//End Toilet Renewal Sale Opportunity       
        
        //Fresh Fit Sale Opportunity
        if(opportunity.RecordTypeId == '012D0000000cZyaIAE'){
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId];
            
            System.debug('Fresh Fit Sales Opportunities: = ' + customerAccount);
            
            opportunity.Name = customerAccount.Name + formattedDate + 'Fresh Fit Sale';
            
        }//End Fresh Fit Sale Opportunity 
        
        //Fresh Fit Sale Renewal Opportunity
        if(opportunity.RecordTypeId == '012D0000000QrwxIAC'){
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId];
            
            System.debug('Fresh Fit Sales Renewals Opportunities: = ' + customerAccount);
            
            opportunity.Name = customerAccount.Name + formattedDate + 'Fresh Fit Renewal';
            
        }//End Fresh Fit Sale Renewal Opportunity
        
        //Maintenance Case Opportunity      
        if(opportunity.RecordTypeId == '012D00000003H8DIAU'){
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId];
            
            System.debug('Maintenance Case Opportunities: = ' + customerAccount);
            
            opportunity.Name = customerAccount.Name + formattedDate + 'Maintenance Case';
            
        }//End Maintenance Case Opportunity        
        
        /*Mtaa Fresh Sale Opportunity      
        if(opportunity.RecordTypeId == '0127E000000UKUMQA4' || opportunity.RecordTypeId == '012D0000000QsniIAC'){
            
            Account customerAccount = [SELECT Id,Name
                                       FROM Account
                                       WHERE ID =: opportunity.AccountId];
            
            System.debug('Mtaa Fresh Sales Opportunities: = ' + customerAccount);
            
            opportunity.Name = customerAccount.Name + formattedDate + 'Mtaa Fresh Sale';
            
        }//End Mtaa Fresh Sale Opportunity*/
        
    }
 /*       
        if(opportunity.Sale_Made__c == 'Yes'){
                        
            List<Farmstar_C2C_Visit__c> c2c = [SELECT Id,Opportunity__c,Account__c FROM Farmstar_C2C_Visit__c
                                               WHERE Account__c =: opportunity.AccountId AND Opportunity__c = null];
            
            for(Farmstar_C2C_Visit__c visit:c2c){
                visit.Sales_Order_Signed__c = opportunity.Sales_Order_Signed__c;
                visit.Close_Date__c = opportunity.CloseDate;
                visit.Delivery_Method__c = opportunity.Delivery_Method__c;
                visit.Delivery_instructions__c = 'assds';
                visit.Opportunity_Stage__c = opportunity.StageName;
                visit.Opportunity__c = opportunity.Id;
                
                opportunity.Number_Of_Visits__c = c2c.size();
                
                
            }
            update c2c;
        }// End if(op.Sale_Made__c == 'Yes')
        
        if(opportunity.Sale_Made__c == 'No'){
            
            List<Farmstar_C2C_Visit__c> c2c2 = [SELECT Id,Opportunity__c,Account__c FROM Farmstar_C2C_Visit__c
                                                WHERE  Opportunity__c =: opportunity.Id];
            
            for(Farmstar_C2C_Visit__c visit:c2c2){
                
                visit.Opportunity__c = null;
                 
            }
            update c2c2; 
            opportunity.Number_Of_Visits__c = 0;
        }// End if(op.Sale_Made__c == 'No')        
        
    }// End for(Opportunity opportunity: Trigger.new)
 */
}