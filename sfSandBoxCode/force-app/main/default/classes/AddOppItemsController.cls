public class AddOppItemsController {
    
    private ApexPages.StandardController standardController;
    
    public List<SelectOption> fltVersions{
        get {
            List<String> versions = new List<String> { 'V2', 'V3', 'V2-V3 Hybrid','Basic FLT'};
            fltVersions = new List<SelectOption>();
            for(String temp : versions){
                fltVersions.add(new SelectOption(temp, temp));
            }
            return fltVersions;
        }
        set;
    }
    
    //Opportunity
    public Opportunity opp {get; set;}  
    
    public String fltVersion {get; set;}
        
    public AddOppItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        opp = (Opportunity) standardController.getRecord();
    }

    public PageReference createItems() {
        
        List<Opportunity_WO_Item__c> opportunityWOItemList = new List<Opportunity_WO_Item__c>();
        
        if(!opp.Structure_Items_Added__c){
            
            List<Opportunity_Item__c> opportunityItems = new List<Opportunity_Item__c>();
            
            if(fltVersion.equals('V2-V3 Hybrid')){                
                //Execute if fltVersion = V2-V3 Hybrid                
                opportunityItems = [SELECT Id, Grouping__c, Default_Quantity__c,Shared_Item__c
                                    FROM Opportunity_Item__c 
                                    WHERE (Grouping__c = 'Structure Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR (Grouping__c = 'Paint Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR (Grouping__c = 'Substructure Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR (Grouping__c = 'Upstructure Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')];
                
            }else if(fltVersion.equals('Basic FLT')){
                //Execute if fltVersion = Basic FLT
                opportunityItems = [SELECT Id, Grouping__c, Default_Quantity__c,Shared_Item__c
                                    FROM Opportunity_Item__c 
                                    WHERE Structure_Version__c = 'Basic FLT'
                                    AND (Grouping__c = 'Basic FLT Package'
                                         OR Grouping__c = 'Basic FLT Package - Upstructure')
                                    AND Manual_Add__c = false
                                    AND Deactivate_Item__c=false
                                    AND Description__c != 'Supplementary Item'];
                
            }else{
                //Execute if fltVersion = V2 or fltVersion = V3
                opportunityItems = [SELECT Id, Grouping__c, Default_Quantity__c,Shared_Item__c
                                    FROM Opportunity_Item__c 
                                    WHERE (Structure_Version__c = :fltVersion AND Grouping__c = 'Structure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = :fltVersion AND Grouping__c = 'Paint Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = :fltVersion AND Grouping__c = 'Substructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = :fltVersion AND Grouping__c = 'Upstructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = null AND Grouping__c = 'Structure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = null AND Grouping__c = 'Paint Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = null AND Grouping__c = 'Substructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')
                                    OR  (Structure_Version__c = null AND Grouping__c = 'Upstructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false AND Description__c != 'Supplementary Item')];
            }
            
            if(opportunityItems.size() > 0 && opp.FLTs_Approved__c > 0){
                
                for(Opportunity_Item__c opportunityItem : opportunityItems){
                    
                    //Check if this is a Basic FLT
                    if(fltVersion.equals('Basic FLT')){
                        
                        if(opportunityItem.Grouping__c == 'Basic FLT Package' && opportunityItem.Shared_Item__c == true){
                            
                            //Create Basic FLT Items
                            Opportunity_WO_Item__c opportunityWOItem = new Opportunity_WO_Item__c();
                            opportunityWOItem.Opportunity__c = opp.Id;
                            opportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                            opportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opp.FLTs_Approved__c);
                            
                            opportunityWOItemList.add(opportunityWOItem);
                            
                        }else if(opportunityItem.Grouping__c == 'Basic FLT Package' && opportunityItem.Shared_Item__c == false){
                            
                            //Create Basic FLT Items
                            Opportunity_WO_Item__c opportunityWOItem = new Opportunity_WO_Item__c();
                            opportunityWOItem.Opportunity__c = opp.Id;
                            opportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                            opportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opp.FLTs_Approved__c);
                            
                            opportunityWOItemList.add(opportunityWOItem);                            
                            
                        }else if(opportunityItem.Grouping__c == 'Basic FLT Package - Upstructure' && opportunityItem.Shared_Item__c == false 
                                 && opp.Upstructure_required__c == true && opp.Upstructures_Required__c > 0 ){
                            
                            //Create Basic FLT Upstructure Items
                            Opportunity_WO_Item__c opportunityWOItem = new Opportunity_WO_Item__c();
                            opportunityWOItem.Opportunity__c = opp.Id;
                            opportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                            opportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opp.Upstructures_Required__c);
                            
                            opportunityWOItemList.add(opportunityWOItem);                            
                            
                        }//End if(opportunityItem.Grouping__c == 'Basic FLT Package')
                        
                        //Flag the Opportunity as a Basic FLT
                        opp.Basic_FLT__c = true;
                        
                    }else{
                        //Execute if fltVersion = 'V2-V3 Hybrid' or fltVersion = 'V2' or fltVersion = 'V3'
                        if(opportunityItem.Grouping__c == 'Upstructure Package'){
                            
                            if(opp.Upstructures_Required__c != null && opp.Upstructures_Required__c > 0){
                                
                                //Create Upstructure Items
                                Opportunity_WO_Item__c upstructureOpportunityWOItem = new Opportunity_WO_Item__c();
                                upstructureOpportunityWOItem.Opportunity__c = opp.Id;
                                upstructureOpportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                                upstructureOpportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opp.Upstructures_Required__c);
                                
                                opportunityWOItemList.add(upstructureOpportunityWOItem);
                            }// End if(opp.Upstructures_Required__c != null && opp.Upstructures_Required__c > 0)
                            
                        } else {
                            //Create Standard Items
                            Opportunity_WO_Item__c opportunityWOItem = new Opportunity_WO_Item__c();
                            opportunityWOItem.Opportunity__c = opp.Id;
                            opportunityWOItem.Opportunity_Item__c = opportunityItem.Id;
                            opportunityWOItem.Quantity__c = (opportunityItem.Default_Quantity__c * opp.FLTs_Approved__c);
                            
                            opportunityWOItemList.add(opportunityWOItem);
                            
                        }// End if(opportunityItem.Grouping__c == 'Upstructure Package')                        
                        
                        //Flag the Opportunity as a Basic FLT
                        opp.Basic_FLT__c = false;
                        
                    }//End if(fltVersion.equals('Basic FLT'))                    

                }//End for(Opportunity_Item__c opportunityItem : opportunityItems)
            }// End if(opportunityItems.size() > 0 && opp.FLTs_Approved__c > 0)
            
            if(opportunityWOItemList.size() > 0){
                INSERT opportunityWOItemList;
                
                opp.Structure_Items_Added__c = true;
                UPDATE opp;
            }//End if(opportunityWOItemList.size() > 0)
            
            // Redirect to the opportunity Record
             return new PageReference('/' + opp.Id);
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This process has already been run'));
        }
        return null;
    }
}