public class ListVehicleTripSchedules{
        
    //create standard controller
    private ApexPages.StandardController standardController;
    
    //Initialize object
    Fleet_Requests__c fr=null;
    
    //initialize list of vehicles
    List<Sanergy_Asset__c> vehicles=[SELECT Registration_Number__c,name,id
                                     FROM Sanergy_Asset__c
                                     WHERE RecordType.name='Vehicles'];
    String selectedVehice=null;

    
    public List<LegsWrapper> tripLegs{get; set;}
    
    //constructor
    public ListVehicleTripSchedules(ApexPages.StandardController controller){
        this.standardController=controller;
        fr=(Fleet_Requests__c) standardController.getRecord();
    }
    
    public List<SelectOption> getVehicles() {
        List<SelectOption> options = new List<SelectOption>();
        
        for(Sanergy_Asset__c vehicle: vehicles){
            options.add(new SelectOption(vehicle.id,vehicle.Registration_Number__c));
        }
        return options;
    }
    
    public String getSelectedVehice() {
        return this.selectedVehice;
    }


    public void setSelectedVehice(String selectedVehice) {
        this.selectedVehice= selectedVehice;
    }


   public PageReference processSelected() {
        tripLegs= new List<LegsWrapper>();
        for(Fleet_Requests__c r: [SELECT Id,Grant_Funding_Availale_Dim_4__c,Dim_3__c,
                                  Location_Dim_2__c,Fleet_Request__r.Requesting_Department__c, Recommended_Vendor__r.name, 
                                  Fleet_Request_Status__c, Name, Fleet_Request__r.name,Vehicle__r.Registration_Number__c,
                                  Fleet_Request__r.Requesting_Employee__r.name, Pickup_Location__c, Other_Pickup_Location__c,
                                  Destination__c, Other_Destination__c, Departure_Date__c, Departure_Time__c,
                                  Reason_for_Trip__c, Total_Actual_Cost__c, EPR_Payable_Item__c
                                  FROM Fleet_Requests__c
                                  WHERE Vehicle__c =:this.selectedVehice
                                  AND Departure_Date__c >= :Date.today()
                                  ]) {
            
          tripLegs.add(new LegsWrapper(r));
            
        }
        return null;
    }
    
    public PageReference selectVehicle() {
        if(this.selectedVehice!=null){
            this.fr.Vehicle__c =this.selectedVehice;
            update this.fr;
        }
         return new PageReference('/' + this.fr.Id);
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