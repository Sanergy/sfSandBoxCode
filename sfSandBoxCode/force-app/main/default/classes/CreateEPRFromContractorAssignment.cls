public class CreateEPRFromContractorAssignment {
    /*
      private ApexPages.StandardController standardController;
      private Casual__c contractor;
      public List<TimesheetWrapper> timesheets {get; set;}
    
        public CreateEPRFromContractorAssignment(ApexPages.StandardController standardController){
            this.standardController = standardController;
            this.contractor = (Casual__c)standardController.getRecord();
            getProducts();
            
        }
        
         public PageReference selectAll() {
            if(timesheets!=null){
                for(TimesheetWrapper ts: timesheets){
                    ts.selected=true;
                }
            }
            return null;
        }
        
        public PageReference unselectAll() {
            if(timesheets!=null){
                for(TimesheetWrapper ts: timesheets){
                    ts.selected=false;
                }
            }
            return null;
        }
        
        public void getProducts() {
        
            timesheets= new List<TimesheetWrapper>();
            
             List<Casuals_Timesheet__c > timeSheetsFetched= [Select name, Job_Requisition__r.Assignment_Department__c,epr__c,
                                                      Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Department__c,
                                                      Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Company__c,
                                                      Job_Requisition__r.Casual__r.account__c,Rate__c,Rate_Units__c,Rate_Units_Quantity__c,
                                                      Start_Date__c,End_Date__c, Job_Requisition__r.Grade__c,
                                                      Job_Requisition__r.Casual_Job_Line_Item__r.Location_Dim_2__c,
                                                      Job_Requisition__r.Casual_Job_Line_Item__r.Dim3__c,
                                                      Job_Requisition__r.Casual_Job_Line_Item__r.Grant_Dim_4__c,
                                                      Job_Requisition__r.Casual_Job_Line_Item__r.GLA__c,
                                                      Job_Requisition__r.Job_Status__c,Total_Amount__c,EPR_Created__c,
                                                      Job_Requisition__r.name, Job_Requisition__r.Casual_Job_Line_Item__r.General_Description__c
                                                      FROM Casuals_Timesheet__c 
                                                      WHERE Job_Requisition__r.Casual__c = :contractor.Id AND EPR__c=null];
                                                              
            
            for(Casuals_Timesheet__c ts: timeSheetsFetched){
                TimesheetWrapper wrapper = new TimesheetWrapper(ts);
                timesheets.add(wrapper );
            }        
        }
        
        public PageReference createEPR(){        
            
            if(timesheets != null && timesheets.size() > 0){
            
                List<Electronic_Payment_Request__c> eprs=new List<Electronic_Payment_Request__c>();
                List<EPR_Payable_Item__c> eprLines=new List<EPR_Payable_Item__c>();
                List<Casuals_Timesheet__c > tsToUpdate=new List<Casuals_Timesheet__c >();
                
                Integer selected = 0;
                
                for(TimesheetWrapper ts: timesheets){                    
                    if(ts.selected == true ){ 
                                              
                         Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c(
                             
                             department__c = ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Department__c,
                             Vendor_Company__c = ts.timesheet.Job_Requisition__r.Casual__r.account__c,
                             Invoice_Number__c = ts.timesheet.name,
                             Company__c=ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Company__c,
                             Scheduled_Payment_Date__c = date.today(),
                             Notes__c='Payment for Contractor for Timesheet '+ts.timesheet.name+'. ('+ts.timesheet.Rate__c+' '+ts.timesheet.Rate_Units__c+' * '+ts.timesheet.Rate_Units_Quantity__c+')',
                             Payment_Type__c = 'Payment on Invoice'                                 
                          );  
                          
                         insert epr;                          
                         eprs.add(epr);
                            
                        EPR_Payable_Item__c payableItem = new EPR_Payable_Item__c(
                            
                            epr__c=epr.id,
                            Department_dim1__c = ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Casuals_Job__r.Department__c,
                            Location_Dim2__c = ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Location_Dim_2__c,
                            Dim_3__c = ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Dim3__c,
                            Grant_Funding_Availale_dim4__c = ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.Grant_Dim_4__c, 
                            Item__c = epr.Notes__c,
                            Quantity__c = 1,
                            Unit_Price__c = ts.timesheet.Total_Amount__c,
                            GLA__c = ts.timesheet.Job_Requisition__r.Casual_Job_Line_Item__r.GLA__c
                            
                        );
                        
                         eprLines.add(payableItem); 
                         ts.timesheet.epr__c=epr.id;
                         ts.timesheet.EPR_Created__c=true;
                         tsToUpdate.add(ts.timesheet);                      
                         selected ++;
                      }
                    }                
                
                    if(selected <= 0){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No timesheet was selected.');
                        ApexPages.addmessage(msg);                    
                        return null;  
                    } else{
                   
                       insert eprLines;
                       update tsToUpdate;
                       return new PageReference('/' + contractor.Id);
                    }
            }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is not timesheet to process.');
                ApexPages.addmessage(msg);                    
                return null;  
            }
                       
        }
        
         public class TimesheetWrapper{
            public Casuals_Timesheet__c timesheet {get; set;}
            public Boolean selected {get; set;}
           
            public TimesheetWrapper(Casuals_Timesheet__c ts){
                this.timesheet=ts;
                selected = true;
            }
        }      
*/
}