public class ConvertLeadToOpportunity {
    
    //Create Standard Controller
    private ApexPages.StandardController controller;
    
    //Lead
    public Lead lead {get; set;}
    
    //Opportunity
    public Opportunity opportunity {get; set;}    
    
    public ConvertLeadToOpportunity(ApexPages.StandardController controller){
        this.controller = controller;
        lead = (Lead)controller.getRecord();
        
        lead =[SELECT Id,Name,Company,Phone,Sub_Area_Lookup__r.Area__c,
               Sub_Area_Lookup__c,Primary_Salesperson__c,Deposit_Paid__c,
               FLR_Lease__c,Franchise_Type__c,Primary_Salesperson__r.Name,
               Sub_Area_Lookup__r.Name,Plot_Completed__c,Plot_Occupied__c,
               Existing_FLO__c,FLTS_Requested__c,LeadSource,OwnerId,
               Sub_Area_Lookup__r.Area_Name__c,Existing_Location__c,
               Location__c,Location__r.Name
               FROM Lead
               WHERE Id =: this.lead.Id];
        
    }
    
    //Convert Lead to Opportunity
    public PageReference convertLeadToOpportunity(){
        
        //Get todays date
        Date todaysDate = date.today();
        //Get the start date of the current month
        Date firstDayOfCurrentMonth = todaysDate.toStartOfMonth();
        //Get no. of days in current month
        Integer noOfDaysInCurrentMonth = date.daysInMonth(firstDayOfCurrentMonth.year(), firstDayOfCurrentMonth.month());
        //Get the last date of the current month
        Date opportunityCloseDate = firstDayOfCurrentMonth + noOfDaysInCurrentMonth - 1;
        
        //Create an instance of Opportunity
        Opportunity opportunity = new Opportunity();
        
        if(lead.Deposit_Paid__c == true && lead.FLR_Lease__c == true){
            //Create Account
            Account account = new Account();
            account.Name = lead.Company;
            account.Phone = lead.Phone;
            account.Type = 'Prospect'; //Customer
            account.Mobile_Payment_Payee__c = lead.Company;
            //account.Mobile_Payment_Phone_Number__c = lead.Phone;
            account.Area__c =  lead.Sub_Area_Lookup__r.Area__c;
            account.SubArea__c = lead.Sub_Area_Lookup__c;
            account.Primary_Salesperson__c = lead.Primary_Salesperson__c;
            account.OwnerId = lead.OwnerId; //lead.Primary_Salesperson__c
            account.RecordTypeId = '012D0000000KE7nIAG';// Sanergy Toilet Sale - Prospect
            INSERT account;
            
            //Create Opportunity from Lead
            //opportunity.RecordTypeId = '012D0000000K1bvIAC';//Toilet Sale - Prospect Management
            //opportunity.StageName ='Sale Open';// change to 'Pending Govt Approval'
            opportunity.StageName ='Pending Govt Approval';
            opportunity.RecordTypeId = '012D0000000KE82IAG';//Toilet Sale - Application Management            
            opportunity.AccountId = account.Id;
            opportunity.Name = account.Name;
            opportunity.Existing_FLO__c = lead.Existing_FLO__c;
            opportunity.Existing_Location__c = lead.Existing_Location__c;
            opportunity.Location__c = lead.Location__c;
            opportunity.No_of_FLTs__c = lead.FLTS_Requested__c;
            //opportunity.CM_Deposit__c = lead.Deposit_Paid__c;
            opportunity.Primary_Salesperson__c = lead.Primary_Salesperson__c;
            opportunity.LeadSource = lead.LeadSource;
            opportunity.CloseDate =  opportunityCloseDate;
            opportunity.Area_Name__c = lead.Sub_Area_Lookup__r.Area_Name__c;
            opportunity.Sub_Area_Lookup__c = lead.Sub_Area_Lookup__c;
            opportunity.OwnerId = lead.OwnerId; //lead.Primary_Salesperson__c
            if(lead.Plot_Completed__c == 'Yes'){
                opportunity.Plot_Complete__c = true;
            }
            if(lead.Plot_Occupied__c == 'Yes'){
                opportunity.Plot_Occupied__c = true;
            }
            if(lead.Franchise_Type__c == 'Plot'){
                opportunity.Franchise_Type__c = 'Residential';
            }else if(lead.Franchise_Type__c == 'Commercial'){
                opportunity.Franchise_Type__c = 'Commercial';
            }else if(lead.Franchise_Type__c == 'School'){
                opportunity.Franchise_Type__c = 'School';
            }else if(lead.Franchise_Type__c == 'Institution'){
                opportunity.Franchise_Type__c = 'Institution';
            }
            
            INSERT opportunity;
            
            return new PageReference('/'+ opportunity.Id);
        }else{
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Please ensure the Deposit Paid & FLR Lease fields are checked!');
            ApexPages.addmessage(errorMessage); 
        
            return null;
        }
    }
    
}