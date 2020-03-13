trigger ValidateOpportunityLocation on Opportunity_Toilet_Location__c (before update, before insert) {
    
    /*
    for(Opportunity_Toilet_Location__c OTL:Trigger.new){
    
    
    
       
        //ensure that if FLO is not existing, then location is not set as existing
        Opportunity Opp=[SELECT Existing_FLO__c, Pricebook2Id, Financing_Method__c
                         FROM Opportunity
                         WHERE ID=:OTL.Opportunity__c];
       
       //Ensure the Payment option is selected
       if(OTL.Payment_Option__c==null){
           OTL.addError('Payment option has to be set');  
       }
                         
       //ensure that location is not set as existing if FLO  is new                
       if(Opp.Existing_FLO__c==false && OTL.Existing_Location__c==true){
             OTL.addError('This Opportunity Toilet location cannot be set to existing because it is linked to a new FLO');
         }
       
       //ensure that location is selected if FLO is existing
       /*
       if(OTL.Existing_Location__c==true && OTL.Location__c==null){
            OTL.addError('The location should be specified if it is existing');  
       }
       */
       //ensure that location is not selected if it is new
       /*
       
       if(OTL.Existing_Location__c==false && OTL.Location__c!=null){
            OTL.addError('Location should not be specified if it is not existing');  
       }*/
       
       
       
       /*
       
         
       //Enforce integrity on the payment options
       if(OTL.Payment_Option__c!=null && Opp.Financing_Method__c.equals('Upfront') && OTL.Payment_Option__c!='Upfront'){
            OTL.addError(OTL.Payment_Option__c+' is not a valid payment choice for this opportunity location.');  
       }
       
       //Enforce integrity on the payment options
       if(OTL.Payment_Option__c!=null && Opp.Financing_Method__c.equals('Credit') && OTL.Payment_Option__c.equals('Upfront')){
           OTL.addError(OTL.Payment_Option__c+' is not a valid payment choice for this opportunity location.');  
       }
        
        if((Trigger.isUpdate && Trigger.oldMap.get(OTL.ID).Firm__c!=OTL.Firm__c)){
         
                //Check if the record is firmed and add products
                 if(OTL.Firm__c==true){
            
                    //Firm action has occurred. Add products
                    Integer numToilets=OTL.No_of_Toilets__c.intValue();
                    boolean ExistingFLO=Opp.Existing_FLO__c;
                    boolean ExistingLocation=OTL.Existing_Location__c;
                    
                    //get the priccebook name
                    List<Pricebook2> pricebook=[SELECT Name FROM Pricebook2 WHERE ID =:Opp.Pricebook2Id];
                    
                   
                    
                    //Get the physical toilet product associated with the pricebook
                    List<PricebookEntry> toiletEntry = [SELECT Id, UnitPrice FROM PricebookEntry 
                                               WHERE Name ='COMPLETE FLT' AND Pricebook2Id = :Opp.Pricebook2Id];
                                               
                   //Get the same location discount product associated with the pricebook
                    List<PricebookEntry> SupplementaryNewFLO = [SELECT Id, UnitPrice FROM PricebookEntry 
                                               WHERE Name ='Supplementary-New FLO' AND Pricebook2Id = :Opp.Pricebook2Id];  
                                               
                    //Get the new location discount product associated with the pricebook
                    List<PricebookEntry> SupplementaryExistingFLO = [SELECT Id, UnitPrice FROM PricebookEntry 
                                               WHERE Name ='Supplementary-Existing FLO' AND Pricebook2Id = :Opp.Pricebook2Id];                          
                    
                     
                    
                    
                    //This list will hold all the products to be added.                           
                    List<OpportunityLineItem> OLI_ToBeAdded=new List<OpportunityLineItem>();
                    
                    
                     if(pricebook.size()>0){
                     
                        //Add products for a one year loan
                        if(pricebook.get(0).Name.equals('FLT Sales - Credit 1 Year')){
                        
                            AddOneYearLoanProducts.addProducts(numToilets,ExistingFLO,ExistingLocation,SupplementaryNewFLO,
                                SupplementaryExistingFLO, toiletEntry, OTL );
                        }
                        
                         //Add products for a two year loan
                        else if(pricebook.get(0).Name.equals('FLT Sales - Credit 2 Year')){
                            AddTwoYearLoanProducts.addProducts(numToilets,ExistingFLO,ExistingLocation, toiletEntry,SupplementaryNewFLO,
                               SupplementaryExistingFLO, OTL );
                        
                        }
                        
                         //Add products for an upfront payment
                        else if(pricebook.get(0).Name.equals('FLT Sales - Upfront')){
                            
                            AddUpfrontPaymentProducts.addProducts(numToilets,ExistingFLO,ExistingLocation,SupplementaryNewFLO,
                                SupplementaryExistingFLO, toiletEntry, OTL );
                        
                        }
                        
                        //if the wrong pricebook is chosen
                        else{
                             OTL.addError('An invalid pricebook has been chosen for this opportunity.');
                        }
                    
                    
                    }
                    else{
                        OTL.addError('Could not find the pricebook.');
                    
                    }
              }
              
              //OTL has been unfirmed. Remove products
              else if(OTL.Firm__c==false){
                  List<OpportunityLineItem> OLI=[SELECT ID FROM OpportunityLineItem 
                                                 WHERE Opportunity_Toilet_Location__c=:OTL.ID];
                                                 
                   if(OLI.size()>0){
                       delete OLI;
                   }
              }
         
        }
    }
    */
}