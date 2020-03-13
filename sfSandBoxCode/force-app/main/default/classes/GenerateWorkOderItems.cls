public class GenerateWorkOderItems {
    
    @TestVisible public ApexPages.StandardController standardController;
    @TestVisible Public Work_Order__c workOder{get;set;}
    @TestVisible public String workOrderId {get;set;}
    @TestVisible public List<String> createdWOIs {get; set;}
    @TestVisible public List<ItemWrapper> items {get; set;}
    @TestVisible public string recipeId {get; set;}
    @TestVisible public List<SelectOption> recipies {get; set;}
    @TestVisible public string  recip {get; set;}
    @TestVisible public string  Recipe {get; set;}
    @TestVisible public Double  quantity {get; set;}
    
    public GenerateWorkOderItems(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.workOder = (Work_Order__c)standardController.getRecord();
        this.workOder =[SELECT Id,Work_Order_Type__c,Inventory_Item__r.Id,Actual_End_Date__c ,Expected_End_Date__c  ,Inventory_Item_Quantity__c,
                        Inventory_Item__c ,Labor_Cost__c  , Material_Cost__c,Firmed__c,Work_Order__c,
                        Site__c, Start_Date__c,Status__c, Inventory_Item__r.Currency_Config__c ,
                        Inventory_Item__r.unit_cost__c, Inventory_Item__r.Has_BOM__c, Inventory_Item__r.Count_of_non_empty_Recipes__c
                        FROM Work_Order__c
                        WHERE Id =: this.workOder.Id ];
        createdWOIs = new List<String>();
        recipies = getRecipies();
        String recipeId;
        this.workOrderId = this.workOder.Id;
        this.quantity = this.workOder.Inventory_Item_Quantity__c;
        items = getItms();
        

        
        
    }
    @TestVisible public List<SelectOption> getRecipies() {
        List<SelectOption> recipeOption = new List<SelectOption>();
        SelectOption defopt = new SelectOption('NA', 'Default BOM');
        recipeOption.add(defopt);
        
        @TestVisible List<Inventory_Item_Recipe__c> recipies = [Select Id, Name, Count_of_Items__c, Parent_Item__c 
                                                                From Inventory_Item_Recipe__c
                                                                WHERE Parent_Item__c =: this.workoder.Inventory_Item__r.Id];
        for(Inventory_Item_Recipe__c recip : recipies){
            SelectOption option = new SelectOption(recip.Id, recip.Name);
            recipeOption.add(option);
        }
        
        return recipeOption;
    }
    
    @TestVisible public void setRecs() {  
        this.recipeId = Recipe;
        changeListWithSelectedRecipe(Recipe);     
    }
    
    public void changeListWithSelectedRecipe(String recipeId){
        
        items = new List<ItemWrapper>();
        
        @TestVisible List<Inventory_Item_Recipe_Item__c> lineItems = [SELECT id,Name , Inventory_Item__c, BOM_Factor__c,Inventory_Item_Recipe__c, Inventory_Item__r.Currency_Config__c ,Quantity_Per__c, Inventory_Item__r.unit_cost__c
                                                                      FROM Inventory_Item_Recipe_Item__c 
                                                                      WHERE  Inventory_Item_Recipe__c =: recipeId
                                                                     ];
        
        if(lineItems.size() == 0){
            
            
            @TestVisible List<Inventory_Item_BOM__c> bomLineItems = [SELECT id,Name , BOM_Item__c,BOM_Factor__c, BOM_Item__r.Currency_Config__c , Parent_Item__c,Quantity_Per__c, BOM_Item__r.unit_cost__c
                                                                     FROM Inventory_Item_BOM__c 
                                                                     WHERE  Parent_Item__c =: this.workOder.Inventory_Item__c
                                                                    ];
            if(bomLineItems.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'The Inventory Item on this Work Order does not have New BOM Items'));
                
            }
            for(Inventory_Item_BOM__c lineItem : bomLineItems){
                ItemWrapper wrapper = new ItemWrapper(lineItem, workOrderId,quantity);
                items.add(wrapper);
            }
        }
        else{
            for(Inventory_Item_Recipe_Item__c lineItem : lineItems){
                
                ItemWrapper wrapper = new ItemWrapper( lineItem, workOrderId,quantity);
                items.add(wrapper);
            } 
            
        }
        
        
    }
    
    @TestVisible public List<ItemWrapper> getItms(){
        List<ItemWrapper> itms=null;
        if(itms == null) {
            itms=new List<ItemWrapper>();
            
            String workOrderId = this.workOder.Id;
            
            List<Inventory_Item_Recipe__c> recipe = [SELECT Id, Name, Count_of_Items__c, Parent_Item__c
                                                     FROM Inventory_Item_Recipe__c
                                                     WHERE Id =: recipeId];
            if(recipe != null && recipe.size()>0 ){
                
                
                
                
                
                @TestVisible List<Inventory_Item_Recipe_Item__c> lineItems = [SELECT id,Name , Inventory_Item__c, BOM_Factor__c,Inventory_Item_Recipe__c, Inventory_Item__r.Currency_Config__c ,Quantity_Per__c, Inventory_Item__r.unit_cost__c
                                                                              FROM Inventory_Item_Recipe_Item__c 
                                                                              WHERE  Inventory_Item_Recipe__c =: recipe.get(0).Id 
                                                                             ];
                
                if(lineItems.size() == 0){
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Recipe does not have Items'));
                    return null;
                }
                
                for(Inventory_Item_Recipe_Item__c lineItem : lineItems){
                    
                    ItemWrapper wrapper = new ItemWrapper( lineItem, workOrderId,quantity);
                    itms.add(wrapper);
                }
                
            }
            else {
                
                
                
                @TestVisible List<Inventory_Item_BOM__c> lineItems = [SELECT id,Name , BOM_Item__c, BOM_Item__r.Currency_Config__c , BOM_Factor__c,Parent_Item__c,Quantity_Per__c, BOM_Item__r.unit_cost__c
                                                                      FROM Inventory_Item_BOM__c 
                                                                      WHERE  Parent_Item__c =: this.workOder.Inventory_Item__c
                                                                     ];
                if(lineItems.size() == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'The Inventory Item on this Work Order does not have BOM Items'));
                    return null;
                }
                for(Inventory_Item_BOM__c lineItem : lineItems){
                    ItemWrapper wrapper = new ItemWrapper(lineItem, workOrderId,this.quantity);
                    itms.add(wrapper);
                }
                
            }
            
        }
        return itms;
    }
    
    
    public List<ItemWrapper> getLines(){
        List<ItemWrapper> linesWrapper=new List<ItemWrapper>();
        
        for(ItemWrapper lw:items){
            
            linesWrapper.add(lw);
            
        }
        return linesWrapper;
    } 
    
    public List<Work_Order_Item__c> getCreatedWOIs(){ 
        List<Work_Order_Item__c> workOderItemList =[SELECT id
                                                    FROM Work_Order_Item__c
                                                    WHERE id IN :this.createdWOIs];
        
        return workOderItemList;
    }        
    
    public PageReference generateWOItems(){
        
        List<ItemWrapper> selectedLines = getLines();
        
        if(selectedLines.size()>0){
            
            List<Work_Order_Item__c> WOIs = new List<Work_Order_Item__c>();
            
            List<id> idString = new List<id>();
            
            //get account from WO items
            for(ItemWrapper lw: selectedLines){
                lw.woItem.Work_Order__c=workOrderId;
                System.debug('WoId=>'+workOrderId);
                WOIs.add(lw.woItem);
            }
            
            insert WOIs;
            
            workOder.Status__c = 'Work in progress'; 
            update workOder;
            
            
            return new PageReference('/' + workOder.Id);
        }
        else{
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'The Inventory Item on this Work Order does not have BOM Items'));
            return null;    
        }
        
        
    }
   
    
    public PageReference FirmWorkOder() {
        
        workOder.Status__c = 'Firmed';
        workOder.Firmed__c = true;
        
        update  workOder;
        
        
        return new PageReference('/' + workOder.Id);
        
    }
    
    
    public class ItemWrapper{
        public Double quantity {get; set;} 
        public String workOrderId {get; set;}             
        public Work_Order_Item__c woItem {get;set;}
        @TestVisible public String rec {get; set;}
        @TestVisible public String Recipe {get; set;}
        @TestVisible public List<SelectOption> recipies {get; set;}
        @TestVisible public string  Line {get; set;}
        @TestVisible public string  recip {get; set;}
        
        
        
        //This is the contructor method
        public ItemWrapper(Inventory_Item_Recipe_Item__c line, String workOrderId, Double quantity) {
            
            
            
            //Work_Order_Item__c wItems = [SELECT Id,Inventory_Item__c FROM Work_Order_Item__c WHERE  Name =: line.Inventory_Item__c];
            
            //if(wItems == null){
            
            woItem = new Work_Order_Item__c();
            
            woItem.Work_Order__c = workOrderId;
            
            woItem.Currency__c = line.Inventory_Item__r.Currency_Config__c;
            woItem.Unit_Cost__c = line.Inventory_Item__r.unit_cost__c;
            woItem.Inventory_Item__c = line.Inventory_Item__c;
            
            if(woItem.Planned_Material_Cost__c == null && line.BOM_Factor__c == 'Linear'){
                woItem.Planned_Material_Cost__c = line.Quantity_Per__c * quantity;
                woItem.BOM_Quantity__c = line.Quantity_Per__c * quantity;
            }else if(woItem.Planned_Material_Cost__c == null && line.BOM_Factor__c != 'Linear'){
                woItem.Planned_Material_Cost__c = line.Quantity_Per__c;
                woItem.BOM_Quantity__c = line.Quantity_Per__c;
            }
            
            /*Work_Order__c wk =[SELECT Id,Status__c FROM Work_Order__c WHERE Id =: workOrderId ];
wk.Status__c = 'Picklist Generated';
*/
            //}
        }
        
        public ItemWrapper(Inventory_Item_BOM__c line, String workOrderId,Double qty) {
            
            //Work_Order_Item__c wItems = [SELECT Id,Inventory_Item__c FROM Work_Order_Item__c WHERE  Inventory_Item__c =: line.BOM_Item__c];
            
            //if(wItems == null){
            System.debug('DEBUG::::'+qty);   
            woItem = new Work_Order_Item__c();
            
            woItem.Work_Order__c = workOrderId;
            woItem.BOM_Quantity__c = line.Quantity_Per__c;
            woItem.Currency__c = line.BOM_Item__r.Currency_Config__c;
            woItem.Unit_Cost__c = line.BOM_Item__r.unit_cost__c;
            woItem.Inventory_Item__c = line.BOM_Item__c;
            
            if(woItem.Planned_Material_Cost__c == null && line.BOM_Factor__c == 'Linear' /*&& quantity != null*/){
                woItem.Planned_Material_Cost__c = line.Quantity_Per__c * qty;
                woItem.BOM_Quantity__c = line.Quantity_Per__c * qty;
            }else if(woItem.Planned_Material_Cost__c == null && line.BOM_Factor__c != 'Linear'){
                woItem.Planned_Material_Cost__c = line.Quantity_Per__c;
                woItem.BOM_Quantity__c = line.Quantity_Per__c;
            }
            
            
            //}
            
            
        }
    }
}