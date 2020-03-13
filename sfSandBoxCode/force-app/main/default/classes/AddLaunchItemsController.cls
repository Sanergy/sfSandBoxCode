public class AddLaunchItemsController{
    
    private ApexPages.StandardController standardController; 
    
    public AddLaunchItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;       
    }
    
    public PageReference createItems() {
        
        Opportunity opp = (Opportunity) standardController.getRecord();
        Decimal fltCount = opp.FLTs_Approved__c;
        String franchise = opp.Franchise_Type__c;
        boolean allAddons = opp.Existing_Location__c;
        
        
        if(!opp.BIB_Items_Added__c){
            List<Opportunity_Item__c> oppItems = [SELECT Id, Grouping__c, Default_Quantity__c, 
                                                  Secondary_Toilet__c,Add_Item_Linearly__c
                                                  FROM Opportunity_Item__c 
                                                  WHERE (Grouping__c = 'Location Support Package' AND Franchise_Type__c = :franchise AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                                  OR (Grouping__c = 'Toilet Support Package' AND Franchise_Type__c = :franchise AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                                  OR (Grouping__c = 'Location Support Package' AND Franchise_Type__c = null AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                                  OR (Grouping__c = 'Toilet Support Package' AND Franchise_Type__c = null AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')];
            
            List<Opportunity_BIB_Item__c> woItemList = new List<Opportunity_BIB_Item__c>();
            
            if(oppITems.size() > 0 && fltCount > 0){
                
                //decimal primaryFlt = 0;
                //decimal secondaryFlt = 0;
                
                //secondaryFlt = fltCount;
                // Check if this is an existing location
                /*if(allAddons){
                secondaryFlt = fltCount;
                } else {
                
                //primaryFlt = 1;
                
                if(fltCount > 1){
                secondaryFlt = fltCount - 1;
                } 
                }*/
                
                for(Opportunity_Item__c item : oppItems){
                    
                    // Check if this is an existing location
                    if(fltCount > 0 && allAddons==true){
                        // Check if Item is Linear
                        if(item.Add_Item_Linearly__c==true){
                            
                            // Create Opportunity_BIB_Item__c
                            Opportunity_BIB_Item__c woItem2 = new Opportunity_BIB_Item__c();
                            woItem2.Opportunity__c = opp.Id;
                            woItem2.Opportunity_Item__c = item.Id;                            
                            woItem2.Quantity__c = item.Default_Quantity__c * fltCount;
                            
                            woItemList.add(woItem2);
                        }
                    }
                    
                    /*if(item.Secondary_Toilet__c){
                    if(secondaryFlt > 0){
                    Opportunity_BIB_Item__c secFlt = new Opportunity_BIB_Item__c(
                    Opportunity__c = opp.Id,
                    Opportunity_Item__c = item.Id,
                    Quantity__c = (item.Default_Quantity__c * secondaryFlt)
                    );   
                    woItemList.add(secFlt);
                    }
                    
                    }*/ //else {
                    //if(primaryFlt > 0){
                    if(fltCount > 0 && allAddons==false){
                        // Create Opportunity_BIB_Item__c
                        Opportunity_BIB_Item__c woItem = new Opportunity_BIB_Item__c();
                        woItem.Opportunity__c = opp.Id;
                        woItem.Opportunity_Item__c = item.Id;                           
                        
                        // Check if Item is Linear
                        if(item.Add_Item_Linearly__c){
                            woItem.Quantity__c = item.Default_Quantity__c * fltCount;
                        }else{
                            woItem.Quantity__c = item.Default_Quantity__c;
                        }
                        
                        woItemList.add(woItem);
                    }
                    //}//End if(item.Secondary_Toilet__c)
                }// End for(Opportunity_Item__c item : oppItems)
            }
            
            if(woItemList.size() > 0){
                INSERT woItemList;
                
                opp.BIB_Items_Added__c = true;
                UPDATE opp;
            }
            
            // Redirect to the opportunity Record
            return new PageReference('/' + opp.Id);
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This process has already been run'));
        }
        return null;
    }
    
}