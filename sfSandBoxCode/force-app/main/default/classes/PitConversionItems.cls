public class PitConversionItems {
    
    private ApexPages.StandardController standardController;
    
    //Pit Conversion Items
    public Opportunity opp {get; set;}    
    
    public PitConversionItems(ApexPages.StandardController standardController){
        this.standardController = standardController;
        opp = (Opportunity)standardController.getRecord(); 
        
        opp = [SELECT Name,AccountId,StageName,Primary_Salesperson__c,
               CloseDate,Pit_Conversion__c,Pit_Conversion_Items_Added__c
               FROM Opportunity
               WHERE Id =: opp.Id];
    }
    
    public PageReference createPitConversionItems() {
        
        //Check if Opportunity is for Pit Conversion
        if(opp.Pit_Conversion__c){            
            
            //Check if Pit Conversion Items have been added
            if(!opp.Pit_Conversion_Items_Added__c){
                
                List<Opportunity_Item__c> opportunityItems = new List<Opportunity_Item__c>();
                
                opportunityItems = [SELECT Id, Grouping__c, Default_Quantity__c
                                    FROM Opportunity_Item__c 
                                    WHERE Structure_Version__c = 'Pit Conversion'
                                    AND Grouping__c = 'Pit Conversion Package'
                                    AND Manual_Add__c = false
                                    AND Deactivate_Item__c=false];
                
                List<Pit_Conversion_Item__c> pitConversionItems = new List<Pit_Conversion_Item__c>();
                
                if(opportunityItems.size() > 0){
                    
                    for(Opportunity_Item__c opportunityItem : opportunityItems){
                        
                        if(opportunityItem.Grouping__c == 'Pit Conversion Package'){
                            
                            // Create Pit Conversion Items
                            Pit_Conversion_Item__c pitConversionItem = new Pit_Conversion_Item__c();
                            pitConversionItem.Opportunity__c = opp.Id;
                            pitConversionItem.Opportunity_Item__c = opportunityItem.Id;
                            pitConversionItem.Quantity__c = opportunityItem.Default_Quantity__c; 
                            
                            //Add Pit Conversion Items to list
                            pitConversionItems.add(pitConversionItem);                     
                        }
                    }
                }
                
                if(pitConversionItems.size() > 0){
                    
                    //Insert Pit Conversion Items
                    INSERT pitConversionItems;
                    
                    // Update Opportunity
                    opp.Pit_Conversion_Items_Added__c = true;
                    UPDATE opp;
                }
                
                // Redirect to the opportunity record
                return new PageReference('/' + opp.Id);
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Pit Conversion Items already exist!'));
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This is not a Pit Conversion Opportunity!'));
        }
        return null;
    }   
}