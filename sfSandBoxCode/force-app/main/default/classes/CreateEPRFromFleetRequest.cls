public class CreateEPRFromFleetRequest{
    
    private ApexPages.StandardController standardController;
    
    public CreateEPRFromFleetRequest(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
    
    public PageReference createEPR() {
        Fleet_Requests__c fleetReq= (Fleet_Requests__c) standardController.getRecord();
        
        //check if request type is external
        if(fleetReq.Fleet_Request_Category__c!='External Fleet'){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An EPR can only be created for an External Fleet Request Category.'));
            return null;
        }
        
        //check if EPR is already created
        else if(fleetReq.EPR__c!=null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An EPR has already been created for this request.'));
            return null;
        }
        //check that required fields are specified
        else if(fleetReq.Company__c==null ||
           fleetReq.Fleet_Request_Category__c==null ||
           fleetReq.Requesting_Department__c==null ||
           fleetReq.Recommended_Vendor__c==null ||
           fleetReq.Scheduled_Payment_Date__c==null ||
           fleetReq.Total_Actual_Cost__c==null ||
           fleetReq.Requesting_Department__c==null ||
           fleetReq.Location_Dim_2__c==null ||
           fleetReq.Dim_3__c==null ||
           fleetReq.Grant_Funding_Availale_Dim_4__c==null){
        
         Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kindly ensure all the required fields are filled.'));
          return null;
        
        }
       
        else{
            
            Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll(); 
            
            
            //create new EPR
            Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c(
                department__c=fleetReq.Requesting_Department__c,
                Company__c=fleetReq.Company__c,
                Vendor_Company__c=fleetReq.Recommended_Vendor__c,
                Invoice_Number__c=fleetReq.Invoice_Number__c,
                CurrencyIsoCode=fleetReq.CurrencyIsoCode,
                Scheduled_Payment_Date__c=fleetReq.Scheduled_Payment_Date__c,
                Status__c='Open',
                Team_Lead_Approval_Status__c='Pending',
                Approving_Teamlead__c=fleetReq.Team_Lead__c,
                Payment_Type__c='Payment on Invoice',
                Notes__c='Payment for hiring a '+fleetReq.Vehicle_Type__c+' car on '+fleetReq.Departure_Date__c+'.\nQuote Number: '+fleetReq.name+'\nEstimated Cost: '+fleetReq.Total_Estimated_Cost__c+'\nRequesting Employee: '+fleetReq.Requesting_Employee__r.name+'\nPickup: '+fleetReq.Pickup_Location__c+'\nDestination: '+fleetReq.Destination__c+'\nReturn: '+fleetReq.Return_Location__c
            
            );
            
            insert epr;
            
            //create EPR Line items
            EPR_Payable_Item__c eprLine=new EPR_Payable_Item__c(
                Department_dim1__c=fleetReq.Requesting_Department__c,
                Location_Dim2__c=fleetReq.Location_Dim_2__c,
                Dim_3__c=fleetReq.Dim_3__c,
                Grant_Funding_Availale_dim4__c=fleetReq.Grant_Funding_Availale_Dim_4__c, 
                Item__c='Transportation Services',
                Quantity__c=1,
                Unit_Price__c=fleetReq.Total_Actual_Cost__c,
                EPR__c=epr.id,
                GLA__c=settings.get('External Fleet GLA').value__c
            );
            
            insert eprLine;
            
            //attach EPR to Fleet Request
            fleetReq.EPR__c=epr.id;
            fleetReq.Fleet_Request_Status__c='Trip Completed';
            update fleetReq;
            
         
            return new PageReference('/' + fleetReq.Id);
        }
    }

}