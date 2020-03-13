public class AddCommercialResidentialProducts{
    private Opportunity Opp;
    private String errorMessage='';
    private List<Pricebook2> pricebook;
    private List<PricebookEntry> toiletEntry;
    private List<PricebookEntry> SupplementaryPrimaryToilet ;
    private List<PricebookEntry> SupplementarySameLocation ;
    private List<PricebookEntry> SupplementaryDiffLocation ;
    private List<PricebookEntry> FinancingCharge;
    private List<PricebookEntry> pitConversionCharge;
    private List<PricebookEntry> pitConversionChargeAddOn;
    private List<Location__c> location;
    
    //constructor
    public AddCommercialResidentialProducts(Opportunity op){
        this.Opp=[SELECT Pricebook2Id, Location__c, Loan_Amount__c,Loan_Duration__c, 
                  Existing_FLO__c,Existing_Location__c,FLTs_Approved__c, Pit_Conversion__c
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
        else
        {
            List<OpportunityLineItem> OLILIST=new List<OpportunityLineItem>();
            //Upfront payment
            if(Opp.Loan_Duration__c=='Upfront payment'){
                //new FLO for upfront payment
                if(Opp.Existing_FLO__c==false){
                    //new FLO  at new Location for upfront payment
                    if(Opp.Existing_Location__c==false && Opp.FLTs_Approved__c>0){    
                        //create a new toilet product 
                        OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = toiletEntry.get(0).id,
                            UnitPrice = toiletEntry.get(0).UnitPrice,
                            is_a_toilet__c=true,
                            Location__c=Opp.Location__c
                        ); 

                        //create a Primary toilet Supplementary product 
                        OpportunityLineItem OLI_PTSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = SupplementaryPrimaryToilet.get(0).id,
                            UnitPrice = SupplementaryPrimaryToilet.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        ); 
                        
                        //create X-1 Same Location Supplementary product 
                        OpportunityLineItem OLI_ASST=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c-1,
                            PricebookEntryId = SupplementarySameLocation.get(0).id,
                            UnitPrice = SupplementarySameLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                
                        OLILIST.add(OLI_CFLT);
                        OLILIST.add(OLI_PTSP);
                        
                        if(Opp.FLTs_Approved__c>1){
                            OLILIST.add(OLI_ASST);
                        }
                    }
                }
                
                //Existing FLO for upfront payment
                else if(Opp.Existing_FLO__c==true){              
                    //Existing FLO  at new Location for upfront payment
                    if(Opp.Existing_Location__c==false && Opp.FLTs_Approved__c>0){                   
                        //create a new toilet product 
                        OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = toiletEntry.get(0).id,
                            UnitPrice = toiletEntry.get(0).UnitPrice,
                            is_a_toilet__c=true,
                            Location__c=Opp.Location__c
                        ); 
                  
                        //create a new location Supplementary product 
                        OpportunityLineItem OLI_ADSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = SupplementaryDiffLocation.get(0).id,
                            UnitPrice = SupplementaryDiffLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        ); 
                        
                        //create X-1 Same Location Supplementary product 
                        OpportunityLineItem OLI_ASST=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c-1,
                            PricebookEntryId = SupplementarySameLocation.get(0).id,
                            UnitPrice = SupplementarySameLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );                        
                        
                        OLILIST.add(OLI_ADSP);
                        OLILIST.add(OLI_CFLT);
                        
                        if(Opp.FLTs_Approved__c>1){
                            OLILIST.add(OLI_ASST);
                        }
                    }
                    
                    //Existing FLO  at existing Location for upfront payment
                    else if(Opp.Existing_Location__c==true && Opp.FLTs_Approved__c>0){
                        //create a new toilet product 
                        OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = toiletEntry.get(0).id,
                            UnitPrice = toiletEntry.get(0).UnitPrice,
                            is_a_toilet__c=true,
                            Location__c=Opp.Location__c
                        ); 
                        
                        //create X Same Location Supplementary product 
                        OpportunityLineItem OLI_ASST=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = SupplementarySameLocation.get(0).id,
                            UnitPrice = SupplementarySameLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                        
                        OLILIST.add(OLI_CFLT);
                        OLILIST.add(OLI_ASST);                 
                    }
                }
            }
            
            //One Year Loan
            else if(Opp.Loan_Duration__c=='One Year'){
                //new FLO for One Year Loan payment
                if(Opp.Existing_FLO__c==false){
                    //new FLO  at new Location for One Year Loan payment
                    if(Opp.Existing_Location__c==false && Opp.FLTs_Approved__c>0){
                        
                        //create a new toilet product 
                        OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = toiletEntry.get(0).id,
                            UnitPrice = toiletEntry.get(0).UnitPrice,
                            is_a_toilet__c=true,
                            Location__c=Opp.Location__c
                        ); 
                
                        //create a Primary toilet Supplementary product 
                        OpportunityLineItem OLI_PTSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = SupplementaryPrimaryToilet.get(0).id,
                            UnitPrice = SupplementaryPrimaryToilet.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        ); 
                        
                        //create X-1 Same Location Supplementary product 
                        OpportunityLineItem OLI_ASST=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c-1,
                            PricebookEntryId = SupplementarySameLocation.get(0).id,
                            UnitPrice = SupplementarySameLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                        
                        //create financing charge Supplementary product 
                        OpportunityLineItem OLI_FCSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = FinancingCharge.get(0).id,
                            UnitPrice = FinancingCharge.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                        
                        OLILIST.add(OLI_CFLT);
                        OLILIST.add(OLI_PTSP);
                        OLILIST.add(OLI_FCSP);
                        
                        if(Opp.FLTs_Approved__c>1){
                            OLILIST.add(OLI_ASST);
                        }
                    }
                }
                
                //Existing FLO for One Year Loan payment
                else if(Opp.Existing_FLO__c==true){              
                    //Existing FLO  at new Location for One Year Loan payment
                    if(Opp.Existing_Location__c==false && Opp.FLTs_Approved__c>0){                        
                        //create a new toilet product 
                        OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = toiletEntry.get(0).id,
                            UnitPrice = toiletEntry.get(0).UnitPrice,
                            is_a_toilet__c=true,
                            Location__c=Opp.Location__c
                        ); 
    
                        //create a new location Supplementary product 
                        OpportunityLineItem OLI_ADSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = SupplementaryDiffLocation.get(0).id,
                            UnitPrice = SupplementaryDiffLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        ); 
                        
                        //create X-1 Same Location Supplementary product 
                        OpportunityLineItem OLI_ASST=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c-1,
                            PricebookEntryId = SupplementarySameLocation.get(0).id,
                            UnitPrice = SupplementarySameLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                        
                        //create financing charge Supplementary product 
                        OpportunityLineItem OLI_FCSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = FinancingCharge.get(0).id,
                            UnitPrice = FinancingCharge.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                                                
                        OLILIST.add(OLI_ADSP);
                        OLILIST.add(OLI_CFLT);
                        OLILIST.add(OLI_FCSP);
                        
                        if(Opp.FLTs_Approved__c>1){
                            OLILIST.add(OLI_ASST);
                        }
                    }
                    
                    //Existing FLO  at existing Location for One Year Loan payment
                    else if(Opp.Existing_Location__c==true && Opp.FLTs_Approved__c>0){
                        //create a new toilet product 
                        OpportunityLineItem OLI_CFLT=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = toiletEntry.get(0).id,
                            UnitPrice = toiletEntry.get(0).UnitPrice,
                            is_a_toilet__c=true,
                            Location__c=Opp.Location__c
                        ); 
                        
                        //create X Same Location Supplementary product 
                        OpportunityLineItem OLI_ASST=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=Opp.FLTs_Approved__c,
                            PricebookEntryId = SupplementarySameLocation.get(0).id,
                            UnitPrice = SupplementarySameLocation.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                        
                        //create financing charge Supplementary product 
                        OpportunityLineItem OLI_FCSP=new OpportunityLineItem(
                            OpportunityId=Opp.id,
                            Quantity=1,
                            PricebookEntryId = FinancingCharge.get(0).id,
                            UnitPrice = FinancingCharge.get(0).UnitPrice,
                            is_a_toilet__c=false,
                            Location__c=Opp.Location__c
                        );
                        
                        OLILIST.add(OLI_CFLT);
                        OLILIST.add(OLI_ASST);
                        OLILIST.add(OLI_FCSP);         
                    }
                }
            }
            
            //Lease
            else if(Opp.Loan_Duration__c=='Lease'){
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
            SupplementaryPrimaryToilet = [SELECT Id, UnitPrice FROM PricebookEntry 
                                          WHERE Name ='supplement - Primary Toilet' AND Pricebook2Id = :Opp.Pricebook2Id];  
            
            //Get the same location supplement product associated with the pricebook
            SupplementarySameLocation = [SELECT Id, UnitPrice FROM PricebookEntry 
                                         WHERE Name ='supplement - Add-on Same Location' AND Pricebook2Id = :Opp.Pricebook2Id];    
            
            //Get the new location supplement product associated with the pricebook
            SupplementaryDiffLocation = [SELECT Id, UnitPrice FROM PricebookEntry 
                                         WHERE Name ='supplement - Add-on Different Location' AND Pricebook2Id = :Opp.Pricebook2Id];     
            
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
               SupplementaryPrimaryToilet==null ||
               SupplementarySameLocation==null ||
               SupplementaryDiffLocation==null ||
               FinancingCharge==null ||
               pitConversionCharge == null ||
               pitConversionChargeAddOn == null){
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