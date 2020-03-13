public class CreateEPRLinesFromTripLegs{
        
    //create standard controller
    private ApexPages.StandardController standardController;
    
    //Initialize object
     Electronic_Payment_Request__c epr=null;
    
    public List<LegsWrapper> tripLegs{get; set;}
    
    //constructor
    public CreateEPRLinesFromTripLegs(ApexPages.StandardController controller){
        this.standardController=controller;
        epr=(Electronic_Payment_Request__c ) standardController.getRecord();
    }

    public List<LegsWrapper> getLegs() {
        if(tripLegs== null) {
            tripLegs= new List<LegsWrapper>();
            for(Fleet_Requests__c r: [SELECT Id,Grant_Funding_Availale_Dim_4__c,Dim_3__c,Requesting_Department__c,
                                      Location_Dim_2__c,Fleet_Request__r.Requesting_Department__c, Recommended_Vendor__r.name, 
                                      Fleet_Request_Status__c, Name, Fleet_Request__r.name, 
                                      Fleet_Request__r.Requesting_Employee__r.name, Pickup_Location__c, Other_Pickup_Location__c,
                                      Destination__c, Other_Destination__c, Departure_Date__c, Departure_Time__c,
                                      Reason_for_Trip__c, Total_Actual_Cost__c, EPR_Payable_Item__c
                                      FROM Fleet_Requests__c
                                      WHERE Recommended_Vendor__c=:epr.Vendor_Company__c
                                      AND Payment_Processed__c = false
                                      AND Fleet_Request_Category__c='External Fleet'
                                      AND Total_Actual_Cost__c !=null
                                      ]) {
                
                tripLegs.add(new LegsWrapper(r));
            }
        }
        return tripLegs;
    }


   public PageReference processSelected() {
        List<Fleet_Requests__c > selectedLegs= new List<Fleet_Requests__c >();

         Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll(); 
            for(LegsWrapper lg: getLegs()) {
                if(lg.selected == true) {
                
                    EPR_Payable_Item__c payableItem=new EPR_Payable_Item__c(
                        Department_dim1__c=lg.tripLegs.Requesting_Department__c,
                        Location_Dim2__c=lg.tripLegs.Location_Dim_2__c,
                        Dim_3__c=lg.tripLegs.Dim_3__c,
                        Grant_Funding_Availale_dim4__c=lg.tripLegs.Grant_Funding_Availale_Dim_4__c, 
                        Item__c='Transportation Services from '+lg.departure+' to '+lg.destination+'. Fleet Trip: '+lg.tripLegs.name,
                        Quantity__c=1,
                        Unit_Price__c=lg.tripLegs.Total_Actual_Cost__c,
                        EPR__c=epr.id,
                        GLA__c=settings.get('External Fleet GLA').value__c 
                    );
                    
                  //  try{
                        insert payableItem;
                        lg.tripLegs.EPR_Payable_Item__c=payableItem.id;
                        lg.tripLegs.Fleet_Request_Status__c='Trip Completed';
                        selectedLegs.add(lg.tripLegs);
                /*    }catch(Exception e){}*/
                    
                    
                    
                    
                }
            }
            
            if(selectedLegs.size()>0){
                  update selectedLegs;
            }
    
             return new PageReference('/' + epr.Id);
       
       
    }
    
    public PageReference selectAll() {
        if(tripLegs!=null){
            for(LegsWrapper lg:tripLegs){
                lg.selected=true;
            }
        }
        
        return null;
    }
    
    public PageReference unselectAll() {
        if(tripLegs!=null){
            for(LegsWrapper lg:tripLegs){
                lg.selected=false;
            }
        }
        
        return null;
    }


    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class LegsWrapper{
        public Fleet_Requests__c tripLegs {get; set;}
        public Boolean selected {get; set;}
        public String departure{get; set;}
        public String destination{get; set;}
        public String dateFrom{get; set;}
        

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public LegsWrapper(Fleet_Requests__c legs) {
            tripLegs= legs;
            selected = true;
            departure= legs.Pickup_Location__c!='Other'? legs.Pickup_Location__c : legs.Other_Pickup_Location__c;
            destination= legs.Destination__c!='Other'? legs.Destination__c: legs.Other_Destination__c;
            dateFrom=String.valueOf(legs.Departure_Date__c)+' : '+String.valueOf(legs.Departure_Time__c);
        }
    }

    }