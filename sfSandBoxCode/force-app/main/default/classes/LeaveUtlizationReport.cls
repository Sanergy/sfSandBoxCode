public class LeaveUtlizationReport {
    
    private ApexPages.StandardController standardController;
    
    //Employee
    public Employee__c employee {get; set;} 
    public Leave_Entitlement_Utilization__c  leaveEntilementUtilization {get;set;}
    //create disabled
    public Boolean  ishide {get; set;}
    public Date mystartdate = system.today();
    public Date lastdayofyear = Date.newinstance(mystartdate.year(), 12, 31);
    //Employee Leave Request
    public Employee_Leave_Request__c leaveRequest {get; set;}
    public List<LeaveRequestUtilization> leaveUtilizationList {get; set;}
    public String dptUnitApprover;
    public Date EndYear;
    public Double accruedToEndDate{get;set;}
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    public Double accruedToEoY{get;set;}
    public Double BalToEndYear{get;set;}
    
    
    public LeaveUtlizationReport(ApexPages.StandardController controller){
        // this.controller = controller;
        
        ishide = false;
        //leaveRequest = new Employee_Leave_Request__c();
        leaveEntilementUtilization = (Leave_Entitlement_Utilization__c)controller.getRecord();
        // employee = (Employee__c)controller.getRecord();       
        
        System.debug('EMPLOYEE: ' + employee);
        
        
    }  
    
    public PageReference getLeaveRequestUtilizations(){
        
        leaveUtilizationList = new List<LeaveRequestUtilization>();
        
        if(StartDate != null && EndDate != null){ 
            
            List<Leave_Entitlement_Utilization__c> utilizationLineItems = [SELECT Name,Leave_Entitlement_Type_Config__c,
                                                                           Leave_Entitlement_Type_Config__r.Name,Employee__c,
                                                                           Leave_Entitlement_Type_Config__r.Leave_Group__r.Name,
                                                                           Employee__r.Name,Leave_Type__c,Total_No_of_Leave_Days__c,
                                                                           Leave_Days_Accrued__c,Leave_Days_Used__c,
                                                                           Employee__r.Termination_Date__c,
                                                                           Employee__r.Job_Title__c,
                                                                           Employee__r.Leave_Group__r.Name,
                                                                           Accrued_To_Date_Selected__c,
                                                                           Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c,
                                                                           Leave_Days_Remaining__c,Employee__r.Leave_Accrual_Start_Date__c  
                                                                           FROM Leave_Entitlement_Utilization__c 
                                                                           WHERE Leave_Type__c = 'Annual Leave'
                                                                           ORDER BY Leave_Type__c ASC];
            
            Double fullMonths = 0.0;
            
            for(Leave_Entitlement_Utilization__c itm: utilizationLineItems){
                
               // fullMonths = SanergyUtils.monthsBetween(itm.Employee__r.Leave_Accrual_Start_Date__c,lastdayofyear);
              //  accruedToEoY = fullMonths * itm.Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c;
              //  BalToEndYear = accruedToEoY - itm.Leave_Days_Used__c;
                
               // Date StartDateInput = date.parse(StDate);
               // Date EndDateInput = date.parse(EdDate);
                
                // StartDate = Date.valueOf(StartDateInput);
               //  EndDate = date.valueOf(EndDateInput);
              system.debug('Date' + StartDate); 
              system.debug('lSd'+itm.Employee__r.Leave_Accrual_Start_Date__c );
                
                if((itm.Employee__r.Leave_Accrual_Start_Date__c < StartDate)){
                    fullMonths = SanergyUtils.monthsBetween(StartDate,EndDate);
                    system.debug('fullMonths' + fullMonths); 
                    accruedToEndDate = fullMonths * itm.Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c;
                    itm.Accrued_To_Date_Selected__c = accruedToEndDate;
                }
                
                else if((itm.Employee__r.Leave_Accrual_Start_Date__c >  StartDate)){
                    fullMonths = SanergyUtils.monthsBetween(itm.Employee__r.Leave_Accrual_Start_Date__c,EndDate); 
                     system.debug('fullMonthsTwo' + fullMonths); 

                    accruedToEndDate = fullMonths * itm.Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c; 
                    itm.Accrued_To_Date_Selected__c = accruedToEndDate;
                } 
                leaveUtilizationList.add(new LeaveRequestUtilization(itm));
                system.debug('List' + itm.Accrued_To_Date_Selected__c);
            }
            
            
        }
        
        return null;  
        
    }
    public pageReference Export(){
        ishide = true;
        system.debug('ishide'+ ishide);
        return null;
    }
    
    // Leave Request wrapper class
    public class LeaveRequestUtilization{
        public Leave_Entitlement_Utilization__c  utilization {get; set;}
        public Double accruedToEndDate{get;set;}

        
        //Constructor
        public LeaveRequestUtilization(Leave_Entitlement_Utilization__c leaveUtilization) {
            utilization = leaveUtilization;	
            accruedToEndDate = accruedToEndDate;
        }        
    }    
    
    
    
    
}