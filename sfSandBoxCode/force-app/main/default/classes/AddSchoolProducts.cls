public class AddSchoolProducts{
    private Opportunity Opp;
    private String errorMessage='';
    private List<Pricebook2> pricebook;
    private List<PricebookEntry> toiletEntry;
    private List<PricebookEntry> Supplementary;
    private List<PricebookEntry> FinancingCharge;
    private List<Location__c> location;
    private List<PricebookEntry> pitConversionCharge;
    private List<PricebookEntry> pitConversionChargeAddOn;
    
    //constructor
    public AddSchoolProducts(Opportunity op){
        this.Opp=[SELECT Pricebook2Id, Location__c, Loan_Amount__c,Loan_Duration__c, 
                  Existing_FLO__c,Existing_Location__c,FLTs_Approved__c,Pit_Conversion__c
                  FROM Opportunity 
                  WHERE ID=:op.id];
    }
    
    
    //add products
    public void addProducts(){
        boolean successInit=init();
        
        
        //unsuccessful init
        if(successInit==false){
        
            
            
        }
        
        
        //successful init
        else{
        
        List<OpportunityLineItem> OLILIST=new List<OpportunityLineItem>();
           //Upfront payment
            if(Opp.FLTs_Approved__c>0){
                
                if(Opp.Existing_Location__c==false){
                    
                  //create a new toilet product 
                    OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                         OpportunityId=Opp.id,
                         Quantity=Opp.FLTs_Approved__c,
                         PricebookEntryId = toiletEntry.get(0).id,
                         UnitPrice = toiletEntry.get(0).UnitPrice,
                         is_a_toilet__c=true,
                         Location__c=Opp.Location__c
                    ); 
                    
                    
                    
                    //create a Supplementary product 
                    OpportunityLineItem OLI_SP=new OpportunityLineItem(
                         OpportunityId=Opp.id,
                         Quantity=1,
                         PricebookEntryId = Supplementary.get(0).id,
                         UnitPrice = Supplementary.get(0).UnitPrice,
                         is_a_toilet__c=false,
                         Location__c=Opp.Location__c
                    ); 
                   
                    
                    OLILIST.add(OLI_CFLT);
                    OLILIST.add(OLI_SP);
                  
                }
                
                //Existing location
                else{
                    
                  //create a new toilet product 
                    OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                         OpportunityId=Opp.id,
                         Quantity=Opp.FLTs_Approved__c,
                         PricebookEntryId = toiletEntry.get(0).id,
                         UnitPrice = toiletEntry.get(0).UnitPrice,
                         is_a_toilet__c=true,
                         Location__c=Opp.Location__c
                    );
                    OLILIST.add(OLI_CFLT);
                }
                
                 //School loans
                if(Opp.Loan_Duration__c=='6 Months' ||
                        Opp.Loan_Duration__c=='12 Months (9 payments)' ||
                        Opp.Loan_Duration__c=='12 Months (12 payments)'){
                    
                    //specify quantity for financing option
                    Integer financingOptionQuantity=Opp.Loan_Duration__c=='6 Months'? 2: Opp.Loan_Duration__c=='12 Months (9 payments)'? 3: 4; 
                        
                        //create a Primary toilet Supplementary product 
                        OpportunityLineItem OLI_FCSP=new OpportunityLineItem(
                             OpportunityId=Opp.id,
                             Quantity=financingOptionQuantity,
                             PricebookEntryId = FinancingCharge.get(0).id,
                             UnitPrice = FinancingCharge.get(0).UnitPrice,
                             is_a_toilet__c=false,
                             Location__c=Opp.Location__c
                        ); 
                        
                        OLILIST.add(OLI_FCSP);
                }
                
                 //If it is a pit conversion, add respective pit conversion charge based on whether primary
                //or add-on toilet
                if(Opp.Pit_Conversion__c==true){
                    if(Opp.Existing_Location__c==false){
                         
                         //add primary Pit Conversion toilet product
                         OpportunityLineItem OLI_PPC=new OpportunityLineItem(
                             OpportunityId=Opp.id,
                             Quantity=1,
                             PricebookEntryId = pitConversionCharge.get(0).id,
                             UnitPrice = pitConversionCharge.get(0).UnitPrice,
                             is_a_toilet__c=false,
                             Location__c=Opp.Location__c
                        ); 
                        
                         //add add on Pit Conversion toilet product
                         OpportunityLineItem OLI_APC=new OpportunityLineItem(
                             OpportunityId=Opp.id,
                             Quantity=Opp.FLTs_Approved__c-1,
                             PricebookEntryId = pitConversionChargeAddOn.get(0).id,
                             UnitPrice = pitConversionChargeAddOn.get(0).UnitPrice,
                             is_a_toilet__c=false,
                             Location__c=Opp.Location__c
                        ); 
                        
                        
                        OLILIST.add(OLI_PPC);
                        
                        if(Opp.FLTs_Approved__c>1){
                            OLILIST.add(OLI_APC);
                        }
                     
                    }
                    else if(Opp.Existing_Location__c==true){
                         //add add on Pit Conversion toilet product
                         OpportunityLineItem OLI_APC=new OpportunityLineItem(
                             OpportunityId=Opp.id,
                             Quantity=Opp.FLTs_Approved__c,
                             PricebookEntryId = pitConversionChargeAddOn.get(0).id,
                             UnitPrice = pitConversionChargeAddOn.get(0).UnitPrice,
                             is_a_toilet__c=false,
                             Location__c=Opp.Location__c
                        ); 
                        OLILIST.add(OLI_APC);
                    
                    }
                }
                
                insert OLILIST;
            }
            
        }
    }
    
 
    //function to initialize parameters for adding products
    private boolean init(){
        boolean success=false;
        
        try{
            //get the priccebook name
            pricebook=[SELECT Name FROM Pricebook2 WHERE ID =:Opp.Pricebook2Id];
            
            //Get the physical toilet product associated with the pricebook
            toiletEntry = [SELECT Id, UnitPrice FROM PricebookEntry 
                                       WHERE Name ='COMPLETE FLT' AND Pricebook2Id = :Opp.Pricebook2Id];
                                       
           //Get the primary toilet supplement associated with the pricebook
            Supplementary= [SELECT Id, UnitPrice FROM PricebookEntry 
                                       WHERE Name ='Supplement' AND Pricebook2Id = :Opp.Pricebook2Id];  
                                      
             //Get the financing charge product associated with the pricebook
            FinancingCharge = [SELECT Id, UnitPrice FROM PricebookEntry 
                                       WHERE Name ='Financing Charge' AND Pricebook2Id = :Opp.Pricebook2Id];   
                                       
             //Get the pit conversion charge product associated with the pricebook
            pitConversionCharge = [SELECT Id, UnitPrice FROM PricebookEntry 
                                       WHERE Name ='Pit Conversion Charge' AND Pricebook2Id = :Opp.Pricebook2Id];     
                                       
             //Get the pit conversion addon charge product associated with the pricebook
            pitConversionChargeAddOn= [SELECT Id, UnitPrice FROM PricebookEntry 
                                       WHERE Name ='Pit Conversion Charge - Addon' AND Pricebook2Id = :Opp.Pricebook2Id];   
                                       
                         
            
    
            if(pricebook==null ||
               toiletEntry==null ||
               Supplementary==null ||
               FinancingCharge==null ){
                   success=false;
                   this.errorMessage='Some product(s) or the pricebook could not be found';
                   Opp.addError( this.errorMessage);
            }
            else{
                 success=true;
            } 
                  
        }catch(Exception e){
            success=false;
            this.errorMessage=e.getMessage();
            Opp.addError( this.errorMessage);
        }   
        
        return success;
    }
}