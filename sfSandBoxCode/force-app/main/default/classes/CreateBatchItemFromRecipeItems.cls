public class CreateBatchItemFromRecipeItems {
    
    public ApexPages.StandardController standardController;
    public  Windrow_Batch__c windrowBatch{get; set;}
    public List<RecipeItems> itemList {get; set;}
    //public Double weight{get; set;}
    
    public CreateBatchItemFromRecipeItems(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.windrowBatch = (Windrow_Batch__c)standardController.getRecord();
        this.windrowBatch = [select id, name, Recipe__c, FLI_Waste_Quantity_kgs__c
                            from Windrow_Batch__c where id =: this.windrowBatch.Id];
    	itemList = new List<RecipeItems>();

        
        List<Recipe_Items__c> items = [SELECT Id,Name, Item_Name__c, Quantity_Recipe_line_item__c, Ratio__c, Recipe__c
                                                     FROM Recipe_Items__c where Recipe__c =:  this.windrowBatch.Recipe__c
                                                                                                       
                                      ];

        for(Recipe_Items__c item:items){
            RecipeItems wr = new RecipeItems(item);
           itemList.add(wr);
        }
    } 
    
       public PageReference selectAll() {
        if(itemList != null){
            for(RecipeItems lg:itemList){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(itemList != null){
            for(RecipeItems lg:itemList){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    public PageReference  processSelected() {
        
         if(itemList != null && itemList.size() > 0){
            
            integer issued = 0;
            integer expected = 0;
            
            for(RecipeItems item : itemList){
                
                if(item.selected ){
                    
                    expected +=1;

                    item.batchItem.Quantity_Required_Kg__c =  this.windrowBatch.FLI_Waste_Quantity_kgs__c * item.item.Ratio__c;
                    item.batchItem.Windrow_Batch__c = this.windrowBatch.Id;
                    insert item.batchItem;
                                        
                   
                } issued +=1;
            }
        
            if(expected == issued){
                return new PageReference('/' + this.windrowBatch.Id);
            } else {
                return new PageReference('/' + this.windrowBatch.Id);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Some Items Were not Issued');
                ApexPages.addmessage(msg);
                return null;
            }
            
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly confirm that the selected recipe has items'));
            return null;
        }
        return null;
    }
    
    public class RecipeItems{
        
        public Windrow_Batch_Line_Item__c batchItem {get; set;}
        public Recipe_Items__c item {get; set;}
        public Boolean selected {get; set;}

        public  RecipeItems(Recipe_Items__c line) {
            item = line;
            
            batchItem = new Windrow_Batch_Line_Item__c();
           
            batchItem.Recipe_Item_Name__c = line.Name;
            this.selected = true;
        }
    }
}