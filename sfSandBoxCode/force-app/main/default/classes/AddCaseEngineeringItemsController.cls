public class AddCaseEngineeringItemsController {
    
    private ApexPages.StandardController standardController;
    public Integer noOfFLTs {get; set;}
    public Integer upstructures {get; set;}
    
    public List<SelectOption> fltVersions{
        get {
            List<String> versions = new List<String> { 'V2', 'V3', 'V2-V3 Hybrid'};
            fltVersions = new List<SelectOption>();
            for(String temp : versions){
                fltVersions.add(new SelectOption(temp, temp));
            }
            return fltVersions;
        }
        set;
    }
    
    public String fltVersion {get; set;}
        
    public AddCaseEngineeringItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        //default number of toilets to 1
        this.noOfFLTs=1;
        this.upstructures=0;
    }

    public PageReference createItems() {
        
        Opportunity opp = (Opportunity) standardController.getRecord();
        Integer fltCount = this.noOfFLTs;
        Integer upstructure = this.upstructures;
        
        if(!opp.Structure_Items_Added__c){
            
            List<Opportunity_Item__c> oppItems = new List<Opportunity_Item__c>();
            
            if(fltVersion.equals('V2-V3 Hybrid')){
                oppItems = [SELECT Id, Grouping__c, InventoryItem__c, Default_Quantity__c
                            FROM Opportunity_Item__c 
                            WHERE (Grouping__c = 'Structure Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false)
                               OR (Grouping__c = 'Paint Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false)
                               OR (Grouping__c = 'Substructure Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false)
                               OR (Grouping__c = 'Upstructure Package' AND Hybrid__c = true AND Manual_Add__c = false AND Deactivate_Item__c=false)];
                               
                              
            }else{
                oppItems = [SELECT Id, Grouping__c, InventoryItem__c, Default_Quantity__c
                            FROM Opportunity_Item__c 
                            WHERE (Structure_Version__c = :fltVersion AND Grouping__c = 'Structure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = :fltVersion AND Grouping__c = 'Paint Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = :fltVersion AND Grouping__c = 'Substructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = :fltVersion AND Grouping__c = 'Upstructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = null AND Grouping__c = 'Structure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = null AND Grouping__c = 'Paint Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = null AND Grouping__c = 'Substructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)
                                OR  (Structure_Version__c = null AND Grouping__c = 'Upstructure Package' AND Manual_Add__c = false AND Deactivate_Item__c=false)];
            }

            
                                                         
            List<Case_Opportunity_Item__c> caseItems = new List<Case_Opportunity_Item__c>();
            
            if(oppITems.size() > 0 && fltCount > 0){
                
                Map<id,Opportunity_Item__c> idMap=new Map<id,Opportunity_Item__c>();
                List<id> idList=new List<String>();
                
                for(Opportunity_Item__c item : oppItems){
                    idMap.put(item.InventoryItem__c, item);
                    idList.add(item.InventoryItem__c);
                }
                
                List<Rootstock_Inventory_Item__c> rstkItems=[SELECT ID,InventoryItem__c FROM Rootstock_Inventory_Item__c 
                                                         WHERE InventoryItem__c IN :idList];
                
                for(Rootstock_Inventory_Item__c item : rstkItems){
                
                    if(idMap.get(item.InventoryItem__c).Grouping__c== 'Upstructure Package'){
                        
                        if(upstructure != null && upstructure > 0){
                            Case_Opportunity_Item__c upsItem = new Case_Opportunity_Item__c();
                            upsItem.Opportunity__c = opp.Id;
                            upsItem.Rstk_Inventory_Item__c = item.id;
                            upsItem.Quantity__c = (idMap.get(item.InventoryItem__c).Default_Quantity__c * upstructure);
                            
                            caseItems.add(upsItem);
                        }
                        
                    } else {
                       Case_Opportunity_Item__c opItem = new Case_Opportunity_Item__c(
                                Opportunity__c = opp.Id,
                                Rstk_Inventory_Item__c = item.id,
                                Quantity__c = (idMap.get(item.InventoryItem__c).Default_Quantity__c * fltCount)
                            ); 
                        caseItems.add(opItem);
                    }
                }
            }
            
            if(caseItems.size() > 0){
                insert caseItems;
                
                opp.Structure_Items_Added__c = true;
                update opp;
            }
            
            // Redirect to the opportunity Record
             return new PageReference('/' + opp.Id);
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This process has already been run'));
        }
        return null;
    }
}