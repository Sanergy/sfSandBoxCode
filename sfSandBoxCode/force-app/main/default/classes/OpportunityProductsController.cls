public class OpportunityProductsController{

    Opportunity Opp;
    private ApexPages.StandardController standardController;
    
    public OpportunityProductsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
    
    }
 
    
    public PageReference addProducts(){  
        Opportunity oppRecord=(Opportunity)standardController.getRecord(); 
        this.Opp=[SELECT Franchise_Type__c  FROM Opportunity WHERE ID=:oppRecord.id];
        String franchiseType=Opp.Franchise_Type__c;
        
        if(franchiseType=='Commercial' || franchiseType=='Institution'){
            AddCommercialProducts com=new AddCommercialProducts(oppRecord);
            com.addProducts();
        }
        else if(franchiseType=='Residential'){
            AddResidentialProducts res=new AddResidentialProducts(oppRecord);
            res.addProducts();
        }
        else if(franchiseType=='School'){
            AddSchoolProducts school=new AddSchoolProducts(oppRecord);
            school.addProducts();
        }
      
        return  new PageReference('/' + Opp.Id);    
    }
    
     public PageReference removeAllProducts(){  
          Opportunity oppRecord=(Opportunity)standardController.getRecord(); 
          List<OpportunityLineItem> opportunityProducts=[SELECT ID FROM OpportunityLineItem WHERE OpportunityId=:oppRecord.id];
          
          delete opportunityProducts;
        return  new PageReference('/' + oppRecord.Id);    
     }
}