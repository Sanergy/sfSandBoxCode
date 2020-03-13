public class CreateLeaveEntitlementUtilization {
    private Leave_Entitlement_Type_Config__c typeConfig;
    private ApexPages.StandardController standardController;
    public  List<empWrapper> emps{get; set;}
    public List<empWrapper>employeeList{get;set;}
    private List<String> genderFilter = new List<String>{'male','female'};
    public  Leave_Entitlement_Type_Config__c config{get; set;}
    public List<Leave_Entitlement_Utilization__c> utilizationList;
    public List<Leave_Accrual__c> accrualsList;
    
    public CreateLeaveEntitlementUtilization(ApexPages.StandardController standardController){
        this.standardController = standardController;
        //  standardController.addFields(new List<String> {'Leave_Type__c'});
        this.typeConfig = (Leave_Entitlement_Type_Config__c)standardController.getRecord();
        

    } 
    
    
    
    public List<empWrapper> getEmployees() {
        
      Leave_Entitlement_Type_Config__c config = [SELECT id,Leave_Type__c,Total_No_of_Leave_Days__c,Leave_Group__c,Proratable__c,Year_Start_Date__c,Year_End_Date__c,Year__c 
                                                   FROM Leave_Entitlement_Type_Config__c
                                                   WHERE id =: typeConfig.Id
                                                  ];
        system.debug ('Configdddd' + config);
        system.debug('typeconfig' + typeConfig.Id);
        if(emps== null) {
            employeeList= new List<empWrapper>();
            
            if(config.Leave_Type__c =='Paternity Leave'){
                genderFilter.clear();
                genderFilter.add('male');
            }else if (config.Leave_Type__c == 'Maternity Leave') {
                genderFilter.clear();
                genderFilter.add('female'); 
            }else {
                genderFilter.clear();
                genderFilter.add('male');
                genderFilter.add('female');
            }
            
            system.debug ('List Values : ' + genderFilter );
            
            
            List<Leave_Entitlement_Utilization__c> vv= [SELECT Employee__c, Name, Leave_Entitlement_Type_Config__c 
                                                        FROM Leave_Entitlement_Utilization__c
                                                        WHERE Leave_Type__c =: config.Leave_Type__c 
                                                        AND Leave_Year__c =: config.Year__c  
                                                        AND Leave_Entitlement_Type_Config__r.Leave_Group__c =: config.Leave_Group__c
                                                        ];
            system.debug('ccvvvvv' + vv);
            
            
            List<Employee__c> empsItems=[SELECT Id, Name, Leave_Group__c,Employment_Start_Date__c, Gender__c , Employee_Active__c FROM Employee__c
                                         WHERE Leave_Group__c =: config.Leave_Group__c  AND id NOT IN (SELECT Employee__c FROM Leave_Entitlement_Utilization__c
                                                                                                       WHERE Leave_Type__c =: config.Leave_Type__c 
                                                                                                       AND Leave_Year__c =: config.Year__c  
                                                                                                       AND Leave_Entitlement_Type_Config__r.Leave_Group__c =: config.Leave_Group__c
                                                                                                      )
                                        AND Employee_Active__c = TRUE  
                                        AND (Employment_Start_Date__c <=: config.Year_Start_Date__c OR (Employment_Start_Date__c >=: config.Year_Start_Date__c  AND Employment_Start_Date__c <=: config.Year_End_Date__c))
                                        AND Gender__c IN : genderFilter
                                         ORDER BY NAME
                                        ];
               system.debug('employeeListIIIIIIII' + empsItems);     
            
            for(Employee__c empItem : empsItems){
                empWrapper itm = new empWrapper(empItem);
                employeeList.add(itm);
            }
            
        }
        system.debug('employeeList' + employeeList);
        return employeeList;
        
    }
    
    public PageReference createUtilizations(){
                
      Leave_Entitlement_Type_Config__c config = [SELECT id,Leave_Type__c,Total_No_of_Leave_Days__c,Leave_Group__c,Proratable__c,Year_Start_Date__c,Year_End_Date__c,Year__c 
                                                   FROM Leave_Entitlement_Type_Config__c
                                                   WHERE id =: typeConfig.Id
                                                  ];
        
        if(employeeList != null && employeeList.size() > 0){
            
            utilizationList = new List<Leave_Entitlement_Utilization__c>();

            for(empWrapper empItem : employeeList){
                if(empItem.selected == true){
                     //Create Leave Entitlement Utilizations for the Employee
                    Leave_Entitlement_Utilization__c leaveUtilization = new Leave_Entitlement_Utilization__c();
                    leaveUtilization.Leave_Entitlement_Type_Config__c = typeConfig.Id;
                    leaveUtilization.Employee__c = empItem.emp.Id;
                    utilizationList.add(leaveUtilization);
                }
            }
            INSERT utilizationList;    
            
            accrualsList = new List<Leave_Accrual__c>();
            //Create Leave Accruals for inserted LEUs
            for(Leave_Entitlement_Utilization__c lvutl: utilizationList){
                Leave_Accrual__c leaveAccrual = new Leave_Accrual__c();
                //leaveAccrual.Name = leaveTypeConfig.Leave_Type__c;
                leaveAccrual.Leave_Entitlement_Utilization__c = lvutl.Id;
                leaveAccrual.Employee__c = lvutl.Employee__c;
                //leaveAccrual.Period__c = System.today().year() + ' - ' + System.today().month();
                leaveAccrual.Period__c = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day()).format('yyyy-MM');
                
                if(config.Proratable__c==true){
                    leaveAccrual.Days_Accrued__c = 0.0;
                }else{
                    leaveAccrual.Days_Accrued__c = config.Total_No_of_Leave_Days__c;
                }    
                accrualsList.add(leaveAccrual);
            }
            //Insert Leave Accruals List
            INSERT accrualsList;
        }

         return new PageReference('/' + typeConfig.Id); 
    }
    
    public PageReference selectAll() {
        if(emps!= null){
            for(empWrapper lg:employeeList){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(emps!= null){
            for(empWrapper lg:employeeList){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    
    public class empWrapper{
        public Boolean selected {get; set;}
        public Employee__c emp {get; set;}
        
        public empWrapper(Employee__c em) {
            emp = em;
            selected = true;
        }
    }
    
}