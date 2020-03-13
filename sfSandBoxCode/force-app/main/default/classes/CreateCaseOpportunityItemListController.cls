public class CreateCaseOpportunityItemListController{
     
     //class to hold items  
     public class OpportunityItems 
        {  
            public String itemName      {get; set;}       
            public String uom            {get; set;}       
            public Decimal quantity      {get; set;}
            public Decimal unitCost       {get; set;}
            public Decimal totalCost      {get; set;}    
            public OpportunityItems (){} //empty constructor                    
        }     
        
    
    Opportunity op;
    public List<OpportunityItems> items {get; set;}    
    
    //contructor
    public CreateCaseOpportunityItemListController(ApexPages.StandardController controller)
    {
        items = new List<OpportunityItems>();          
        op= (Opportunity)controller.getRecord();    //Get Opportunity from controller.
        for (Case_Opportunity_Item__c caseItem : [Select Rstk_Inventory_Item__r.name, UOM__c, Quantity__c,Total_Cost__c,Cost__c from Case_Opportunity_Item__c where Opportunity__c= :op.Id])    
        {
            OpportunityItems item= new OpportunityItems();  
            item.itemName= caseItem.Rstk_Inventory_Item__r.name;
            item.uom= caseItem.UOM__c;
            item.quantity= caseItem.Quantity__c;
            item.unitCost= caseItem.Cost__c;
            item.totalCost= caseItem.Total_Cost__c;
            items.add(item);
        }
        
       
    }
    public void UpdateOpportunityStage(){
        //change opportunty stage to pending Approval
        op.StageName='Pending Approval';
        update op;
    }
}