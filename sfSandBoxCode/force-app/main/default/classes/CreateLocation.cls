public class CreateLocation {
    
    //Create Standard Controller
    @TestVisible private ApexPages.StandardController controller;
    
    //Opportunity
    @TestVisible public Opportunity opportunity {get; set;}
    
    //Location
    @TestVisible public Location__c location {get; set;}   
    
    //Toilet
    @TestVisible public List<Toilet> toiletList {get; set;}
    @TestVisible public List<Toilet> toiletsToLaunch {get; set;}     

    //Variables
    @TestVisible public Boolean checkLocationExists {get; set;}
    @TestVisible public Boolean showLocationButton {get; set;}    
    @TestVisible public Boolean showToiletButton {get; set;}
    @TestVisible public Boolean showToiletPendingLaunchButton {get; set;} 
    @TestVisible public Decimal numberOfFLTSToCreate {get; set;}
    //@TestVisible public Boolean selectAllCheckbox {get; set;}
    
    public CreateLocation(ApexPages.StandardController controller){
        this.controller = controller;
        this.opportunity = (Opportunity)controller.getRecord();
        
        this.opportunity =[SELECT Id,Name,Area__c,Sub_Area_Lookup__c,Sub_Area_Lookup__r.Name,Area_Name__c,
                           Area_Name__r.Last_Location_No__c,StageName,Franchise_Type__c,Next_Stage__c,FLTs_Approved__c,
                           Primary_Salesperson__c,Primary_Salesperson__r.Name,Account.Name,Location__c,Location__r.Name,
                           Sub_Area_Lookup__r.Area_Name__r.Area_Abbreviation__c,Location__r.Last_FLT__c,
                           Sub_Area_Lookup__r.Area_Name__r.Last_Location_No__c,No_of_FLTs__c,OwnerId
                           FROM Opportunity
                           WHERE Id =: this.opportunity.Id ];
        
        //Check if Location is provided
        this.checkLocationExists = String.isNotBlank(this.opportunity.Location__c) ? true : false;
        
        System.debug('this.checkLocationExists: - On Page Load: ' + this.checkLocationExists);
        
        //Activate/Deactivate Buttons
        activateDeactivateButton();
        
        //Get all Toilets
        getAllToilets();
        
        //Get toilets pending launch
        getToiletsPendingLaunch();
        
    }
    
    public void activateDeactivateButton(){
        
        //Check if Location is provided
        if(this.checkLocationExists==true){
            //Hide the Create Location button
            this.showLocationButton = false;
            
            //Show the Create Toilet button if Location exists
            this.showToiletButton = true;
        }else{
            
            //Show the Create Location button
            this.showLocationButton = true;
            
            //Hide the Create Toilet button
            this.showToiletButton = false;
        }
        
        // Check if there are any toilets pending launch
        if(toiletsToLaunch != null ){
            showToiletPendingLaunchButton = true;
        }else{
            showToiletPendingLaunchButton = false;
        }        
    }     

    //Create Location
    public PageReference createNewLocation(){
        System.debug('LAST LOCATION NO: = ' + opportunity.Sub_Area_Lookup__r.Area_Name__r.Last_Location_No__c + 1);
        Decimal newLocationNumber = opportunity.Sub_Area_Lookup__r.Area_Name__r.Last_Location_No__c + 1;
        String locationName = opportunity.Sub_Area_Lookup__r.Area_Name__r.Area_Abbreviation__c + '-' + newLocationNumber;
        
        //Create Location
        Location__c location = new Location__c();
        location.Name = locationName;
        location.Sub_Area__c = opportunity.Sub_Area_Lookup__c;
        location.Last_FLT__c = 0;
        
        if(opportunity.Franchise_Type__c == 'Residential'){
            location.Franchise_Type__c = 'Non-Commercial-Plot';            
            location.Waste_User_Ratio__c = 0.3020;
        }else if(opportunity.Franchise_Type__c == 'School'){
            location.Franchise_Type__c = 'Non-Commercial-School';
            location.Waste_User_Ratio__c = 0.2236;
        }else if(opportunity.Franchise_Type__c == 'Institution'){
            location.Franchise_Type__c = 'Non-Commercial-Institution';
            location.Waste_User_Ratio__c = 0.3020;
        }
        
        INSERT location;
        
        //Update Opportunity
        opportunity.Location__c = location.Id;
        opportunity.Sub_Area_Lookup__r.Area_Name__r.Last_Location_No__c = newLocationNumber;
        UPDATE opportunity;
        
        System.debug('opportunity.Location__c: ' + opportunity.Location__c);
        
        //Get Area__c
        Area__c area = [SELECT ID,Name,
                        Last_Location_No__c
                        FROM Area__c
                        WHERE Id=: opportunity.Sub_Area_Lookup__r.Area_Name__c];
        
        //Update Area 
        area.Last_Location_No__c = newLocationNumber;
        UPDATE area;        
        
        System.debug('area.Last_Location_No__c: ' + area.Last_Location_No__c);
        
        //return null;
        return new PageReference('/'+ opportunity.Id);
    }

    // Get all toilets in current location
    public List<Toilet> getAllToilets(){
        System.debug('opportunity.Location__c: '+ opportunity.Location__c);
        
        if(this.checkLocationExists == true){
            
            toiletList = new List<Toilet>();
            
            List<Toilet__c> freshLifeToilets = [SELECT Id,Name,Location__c,Opportunity__c,Operational_Status__c,
                                                Collection_Route__c,Current_Specific_Status__c,Opportunity__r.Name,
                                                Location__r.Name,Opening_Date__c
                                                FROM Toilet__c
                                                WHERE Location__c =: opportunity.Location__c
                                                AND Opportunity__c =: opportunity.Id
                                                ORDER BY Name ASC];     
            
            for(Toilet__c flt : freshLifeToilets){                
                //Add all records to the list
                toiletList.add(new Toilet(flt));
            }//End for(Toilet__c flt : freshLifeToilets)
            
        }//End if(opportunity.Location__c != null)        
        
        
        return toiletList;
    }

    // Get all toilets Pending Launch in current location
    public List<Toilet> getToiletsPendingLaunch(){
        System.debug('opportunity.Location__c: '+ opportunity.Location__c);
        
        if(this.checkLocationExists == true){
            
            toiletsToLaunch = new List<Toilet>();
            
            List<Toilet__c> freshLifeToilets = [SELECT Id,Name,Location__c,Opportunity__c,Operational_Status__c,
                                                Collection_Route__c,Current_Specific_Status__c,Opportunity__r.Name,
                                                Location__r.Name,Opening_Date__c
                                                FROM Toilet__c
                                                WHERE Location__c =: opportunity.Location__c
                                                AND Opportunity__c =: opportunity.Id
                                                AND Operational_Status__c = 'Pending Launch'
                                                ORDER BY Name ASC];     
            
            for(Toilet__c flt2 : freshLifeToilets){                
                //Add all records to the list
                toiletsToLaunch.add(new Toilet(flt2));
            }//End for(Toilet__c flt2 : freshLifeToilets)
            
        }//End if(opportunity.Location__c != null)        
        
        
        return toiletsToLaunch;
    }    
    
    //Create Toilet
    public PageReference createNewToilet(){
        
        Decimal newToiletNumber;
        String toiletName;
        
        //No. of Existing FLTS in this location
        Integer numberOfFLTsInThisLocation = toiletList.size();
        
        System.debug('numberOfFLTsInThisLocation: = ' + numberOfFLTsInThisLocation);
        System.debug(' opportunity.No_of_FLTs__c: = ' +  opportunity.No_of_FLTs__c);
        
        //Maximum No. of FLTS you can create should be less than or equal to No. of FLTS requested
        Decimal maxNumberOfToiletsToCreate = opportunity.No_of_FLTs__c - numberOfFLTsInThisLocation;
        
        System.debug('maxNumberOfToiletsToCreate: = ' + maxNumberOfToiletsToCreate);
        
        if(opportunity.StageName == 'Pending Launch'){
            
            if(numberOfFLTSToCreate <= maxNumberOfToiletsToCreate && this.checkLocationExists == true){
                
                //Get Location
                Location__c loc = [SELECT Id,Name,Last_FLT__c,
                                   Area__c,Area_Name__c
                                   FROM Location__c
                                   WHERE Id =: opportunity.Location__c
                                   LIMIT 1];
                
                //Create no. of toilets specified
                for(Integer i=0; i<numberOfFLTSToCreate; i++){
                    
                    newToiletNumber = loc.Last_FLT__c + 1;
                    toiletName = loc.Name + '.' + newToiletNumber;
                    
                    //Create Toilet
                    Toilet__c toilet = new Toilet__c();
                    toilet.RecordTypeId = '012D0000000K64jIAC'; //Sanergy
                    toilet.Name = toiletName;
                    toilet.Location__c = opportunity.Location__c;
                    toilet.Opportunity__c = opportunity.Id;
                    toilet.Operational_Status__c = 'Pending Launch';
                    toilet.Collection_Route__c = 'CLOSED';
                    toilet.Current_Specific_Status__c = 'Pending Launch';
                    INSERT toilet;
                    
                    //Update Location 
                    loc.Last_FLT__c =  newToiletNumber;
                    UPDATE loc;                 
                }
                
                
            }else{
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'You have reached the maximum no. of toilets allowed in this location!');
                ApexPages.addmessage(errorMessage);             
            }// End if(numberOfFLTSToCreate <= maxNumberOfToiletsToCreate && this.checkLocationExists == true)            
            
        }else{
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'You can\'t create a toilet if Opportunity Stage is not "Pending Launch"!');
            ApexPages.addmessage(errorMessage);               
        }
        
        return null;        
    }
    
    //Toilet Pending Launch Notification
    public PageReference toiletPendingLaunchNotification(){
        
        //Get FLT Launch RecordType
        RecordType fltLaunchRecordType = [SELECT Id,Name 
                                          FROM RecordType 
                                          WHERE Name ='FLT Launches' 
                                          LIMIT 1];        
        
        for(Toilet t: toiletsToLaunch){
            
            //Check if toilet is selected
            if(t.selected==true){
            
                //Create a task for Sales Associate
                Task task = new Task();
                task.RecordTypeId = fltLaunchRecordType.Id;//FLT Launches
                task.OwnerId = opportunity.OwnerId;//Task assigned to who
                task.Subject = t.toilets.Name + ' is ' + t.toilets.Operational_Status__c;
                task.Goals__c = 'Launch ' + t.toilets.Name;
                task.WhatId = t.toilets.Id;
                task.Related_To_Text__c = t.toilets.Name;
                task.Opportunity__c = opportunity.Id;
                task.ActivityDate = date.today(); //Due Date
                task.Description = t.toilets.Name + ' is ' + t.toilets.Operational_Status__c;//	Comments
                task.Status  = 'Not Started';
                task.Priority = 'Normal';
                task.Task_Source__c = 'Visualforce Page';
                INSERT task;
                
                System.debug('Create Task ' + task); 
            }
            
        }
        
        return null;
        
    }
    
    /*public void selectUnselectAll() {
        System.debug('toiletsToLaunch 1: ' + toiletsToLaunch);
        
        if(toiletsToLaunch != null){
            System.debug('toiletsToLaunch 2: ' + toiletsToLaunch);	
            for(Toilet t: toiletsToLaunch){
                System.debug('toiletsToLaunch 3: ' + toiletsToLaunch);
                System.debug('selectAllCheckbox 3: ' + selectAllCheckbox);
                if(selectAllCheckbox==true){
                    System.debug('selectAllCheckbox 4: ' + selectAllCheckbox);
                    t.selected=true;
                }else{
                    System.debug('selectAllCheckbox 5: ' + selectAllCheckbox);
                    t.selected=false;
                }                             
            }
        }               
    }*/       
    
    // Toilet wrapper class
    public class Toilet{        
    @TestVisible public Toilet__c toilets {get; set;}
    //@TestVisible public Boolean showToiletLaunchButton {get; set;}
    @TestVisible public Boolean selected {get; set;}
        
        //Constructor
        public Toilet(Toilet__c toilet) {
            toilets = toilet;
            selected = false;            	
            
            /*if(toilets.Operational_Status__c == 'Pending Launch'){
                showToiletLaunchButton = true;
            }else{
                showToiletLaunchButton = false;
            }*/
        }
    }    
}