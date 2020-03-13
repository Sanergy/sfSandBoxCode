public class CreateEPRFromTimesheet{
    
    //Controller
    ApexPages.StandardController controller;
    //timesheet
    Casuals_Timesheet__c timesheet {get; set;}
    
    //Constructor
    public CreateEPRFromTimesheet(ApexPages.StandardController controller){
        this.controller = controller;
        timesheet = (Casuals_Timesheet__c )controller.getRecord();
        
        timesheet=[SELECT Job_Requisition__r.Casual__r.account__c,EPR_Created__c,
                   name, Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Company__c, Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Department__c,
                   Job_Requisition__r.Casual_Job_Line_Item__r.Location_Dim_2__c, Job_Requisition__r.Casual_Job_Line_Item__r.Dim3__c,
                    Job_Requisition__r.Casual_Job_Line_Item__r.Grant_Dim_4__c, Total_Amount__c, Job_Requisition__r.Casual_Job_Line_Item__r.GLA__c
                    FROM Casuals_Timesheet__c 
                    WHERE id =: timesheet.id];
    }
    
    //create EPR
    public PageReference createEPR(){
		// Create an instance of EPR
        Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();         
        
        if(timesheet.EPR_Created__c == false){
            
            // Select a Vendor Invoice
            List<Vendor_Invoice__c> vi = [SELECT Id,Name,Vendor__c,Status__c                                                     
                                          FROM Vendor_Invoice__c
                                          WHERE Vendor__c =: timesheet.Job_Requisition__r.Casual__r.account__c
                                          ORDER BY Name DESC                                              
                                          LIMIT 1];        
            
            // Loop through the list of Vendor Invoices
            for(Vendor_Invoice__c v : vi){
                
                //Create EPR
                epr.department__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Department__c;
                epr.Vendor_Company__c = timesheet.Job_Requisition__r.Casual__r.account__c;
                epr.Invoice_Number__c = timesheet.name;
                epr.Company__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Company__c;
                epr.Vendor_Invoice_Number__c = vi.get(0).Id;               
                epr.Scheduled_Payment_Date__c = date.today();
                epr.Notes__c='Payment for Contractor Services as per Timesheet number '+timesheet.name;
                epr.Payment_Type__c = 'Payment on Invoice';
                
                insert epr;         
                
                // Create EPR Payable Item
                EPR_Payable_Item__c payableItem = new EPR_Payable_Item__c(            
                    epr__c=epr.id,
                    Department_dim1__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Department__c,
                    Location_Dim2__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Location_Dim_2__c,
                    Dim_3__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Dim3__c,
                    Grant_Funding_Availale_dim4__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Grant_Dim_4__c, 
                    Item__c = epr.Notes__c,
                    Quantity__c = 1,
                    Unit_Price__c = timesheet.Total_Amount__c,
                    GLA__c = timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.GLA__c
                    
                );
                
                insert payableItem;
                
                timesheet.EPR__c = epr.id;
                timesheet.EPR_Created__c = true;
                update timesheet;                
            }            
            return new PageReference('/'+epr.id);
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'An EPR has already been created for this timesheet record'));
            return null;
        }
       
    }
}