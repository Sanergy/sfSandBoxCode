@isTest(SeeAllData=true)
public class BatchItemFromRecipeItemTest {
    static testMethod void BatchItemTest(){
         List<Recipe_Items__c> recipeItem = [SELECT Id,Name, Item_Name__c, Quantity_Recipe_line_item__c, Ratio__c, Recipe__c
                                                    FROM Recipe_Items__c WHERE  Recipe__c != null
                                            Limit 1];
        if(recipeItem.size()>0){
         List<Windrow_Batch__c> windrowBatch = [select id, name, Recipe__c, FLI_Waste_Quantity_kgs__c
                            							from Windrow_Batch__c Limit 1];
         if(windrowBatch.size()>0){
             windrowBatch.get(0).Recipe__c  = recipeItem.get(0).Recipe__c;
             windrowBatch.get(0).FLI_Waste_Quantity_kgs__c = 1000;
             update windrowBatch;
             
                PageReference pageRef = Page.CreateBatchItemFromRecipeItem;
            
                Test.setCurrentPage(pageRef);
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(windrowBatch.get(0));
                CreateBatchItemFromRecipeItems controller = new CreateBatchItemFromRecipeItems(sc);
                controller.selectAll();
                controller.processSelected();
                controller.unselectAll();
         }
         }
    }
}