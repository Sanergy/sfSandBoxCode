public class CreateLeaveAccrual {
    //create standard controller
    private ApexPages.StandardController controller;
    
    public List<Leave_Accrual_Schedule__c> accrualScheduleList {get;set;}
    
    public Leave_Accrual_Schedule__c page{get;set;}
    
    
    public Date empStartDate; //Employee start date
    private Date x;
    private Date empEndDate; //Employee End date
    private Date jobStartDate; //The day the job is starting
    private Date startPreviousMonth;// previous Month start date 
    private Date endPreviousMonth;//Previous Month End date
    private String prevPeriod;//Previous period YYYY-MM format
    private ID Y;
    //Get fullmonths in between
    Double fullMonths = 0.0;
    Double accrualFactor =0.0;
    String periodName;
    
    //leaveAccruals Constructor
    public CreateLeaveAccrual (ApexPages.StandardController controller){
        this.controller = controller;
        page = (Leave_Accrual_Schedule__c)controller.getRecord();
        page = [SELECT Name,Period_Start_Date__c,Comments__c,Job_Run__c 
                FROM Leave_Accrual_Schedule__c LIMIT 1];
        accrualScheduleList = [SELECT Name,Period_Start_Date__c,Comments__c,Job_Run__c 
                               FROM Leave_Accrual_Schedule__c LIMIT 1];       
    }
    
    public PageReference ProcessJob(){   
        
        // x = date.today();// get the date today
        
        List<Leave_Accrual__c> C = new List<Leave_Accrual__c>();
        
        x = accrualScheduleList.get(0).Period_Start_Date__c; //get the set period date
        
        jobStartDate = x.toStartOfMonth(); // get the beginning of that month
        
        startPreviousMonth = jobStartDate.addMonths(-1); // get the beginning of the previous month
        
        endPreviousMonth = jobStartDate.addDays(-1); //get the end date of the previous month
        Integer prevYear = endPreviousMonth.year(); // Getting year for which accruals will be done]
        // DateTime endOfPreviousMonth = (DateTime )
        // 	prevPeriod = Datetime.newInstance(endPreviousMonth).format('YYYY-MM');//get the period name YYYY-MM of the previous month
        prevPeriod =  DateTime.newInstance(endPreviousMonth.year(),endPreviousMonth.month(),endPreviousMonth.day()).format('yyyy-MM');
        periodName = DateTime.newInstance(startPreviousMonth.year(),startPreviousMonth.month(),startPreviousMonth.day()).format('yyyy-MM');
        
        
        
        list<Leave_Accrual__c> listAccrual = [SELECT Leave_Entitlement_Utilization__c,Employee__c,Period__c
                                              FROM Leave_Accrual__c
                                              WHERE Period__c =: prevPeriod ];
        system.debug('listAccrual'+ listAccrual);
        
        List<Leave_Entitlement_Utilization__c> listAll = [SELECT Name,Leave_Type__c, Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c,
                                                          Employee__r.Name, Employee__r.Leave_Accrual_Start_Date__c, Employee__r.Termination_Date__c,
                                                          Leave_Entitlement_Type_Config__r.Proratable__c, Leave_Year__c
                                                          FROM Leave_Entitlement_Utilization__c
                                                          WHERE Leave_Entitlement_Type_Config__r.Proratable__c = true
                                                          AND Employee__r.Leave_Accrual_Start_Date__c <=: endPreviousMonth
                                                          AND Leave_Year__c =: prevYear
                                                          AND Leave_Entitlement_Type_Config__r.Display_to_User__c = true
                                                          AND (Employee__r.Termination_Date__c = null OR Employee__r.Termination_Date__c >: startPreviousMonth)
                                                          AND ID NOT IN (SELECT Leave_Entitlement_Utilization__c  
                                                                         FROM Leave_Accrual__c
                                                                         WHERE Period__c =: prevPeriod 
                                                                        )
                                                         ];
        system.debug('listAll' + listAll);
        
        //loop through the entire list 
        for(Leave_Entitlement_Utilization__c oneEmp: listAll){
            empStartDate = oneEmp.Employee__r.Leave_Accrual_Start_Date__c; //get the employee start date
            empEndDate = oneEmp.Employee__r.Termination_Date__c; // get the employee termination date 
            system.debug('XXX' + oneEmp.Employee__r.Name + '***' +  empStartDate + '***' + empEndDate  + '***' + accrualFactor + '***' + fullMonths  + '***' + oneEmp.Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c);
            
            // check if the employee start date is less than the start of the previous month 
            if(empStartDate != null && empStartDate < startPreviousMonth){
                empStartDate =  startPreviousMonth; 
            }
            else if(empStartDate != null && empStartDate > endPreviousMonth){
                empStartDate = endPreviousMonth;
            }
            // check if the employee end date is null or if the employee end date is greater than the end of the previous month            
            if(empEndDate == null || empEndDate > endPreviousMonth ){
                empEndDate = endPreviousMonth;
            }
            else if (empEndDate < startPreviousMonth){
                empEndDate =  startPreviousMonth;   
            }
            //reset to zero
            fullMonths = 0.0;
            accrualFactor =0.0;
            
            //Confirm start and end dates not null
            if(empStartDate != null && empEndDate != null){
                fullMonths = SanergyUtils.monthsBetween(empStartDate,empEndDate);
                System.debug ('in here');
            }
            //Get Accrual Factor and multiply by months between
            accrualFactor = fullMonths*oneEmp.Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c;
            
            system.debug('AAA' + oneEmp.Employee__r.Name + '***' +  empStartDate + '***' + empEndDate  + '***' + accrualFactor + '***' + fullMonths  + '***' + oneEmp.Leave_Entitlement_Type_Config__r.Days_Accrued_Per_Month__c);
            
            //Create an instance for the leave accruals
            Leave_Accrual__c  accrual = new Leave_Accrual__c();	 
            //accrual.Name = oneEmp.Name;
            accrual.Period__c = periodName;
            accrual.Employee__c = oneEmp.Employee__c;
            accrual.Leave_Entitlement_Utilization__c = oneEmp.Id;
            accrual.Days_Accrued__c = accrualFactor;
            
            //C is a list that you add all the items of the loop, then you do one insert for all the inserted items
            C.add(accrual);
            
            //INSERT accrual;
            
        } 
        INSERT C;
        
        system.debug('ACCRUAL FINISHED' + C);  
        
        return new PageReference('/'+ page.Id);
    }
    
    
    
    
    
    
}