global class LeaveStarted  implements Database.Batchable<sObject>, Database.Stateful{
    String query;
    // Start the schedule depending on the date today
    Date d = date.today();
    List<LeaveThatHaveStarted> leaveStart = new List<LeaveThatHaveStarted>();
    List<Employee_Leave_Request__c> EMPLR{get;set;}
    
    
    // Get all Leave Requests  that are starting today
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        query = 'SELECT Id,Leave_Started__c,Leave_Start_Date__c' +
            ' FROM Employee_Leave_Request__c' +
            ' WHERE Leave_Start_Date__c =: d';
        
        return Database.getQueryLocator(query);
    }
    
    // Get all leaves that have started 
    global void execute(Database.BatchableContext bc, List<Employee_Leave_Request__c> scope){
        
        // Loop through the list of Contracts
        for(Employee_Leave_Request__c c : scope){
            
            LeaveThatHaveStarted startedLeaves = new LeaveThatHaveStarted();
            
            startedLeaves.id = c.Id;
            startedLeaves.leaveStartDate = c.Leave_Start_Date__c;
            startedLeaves.started = c.Leave_Started__c; 
            
            // Add the started leaves to the list
            leaveStart.add(startedLeaves);
        }                
    }
    
    global void finish(Database.BatchableContext bc){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status,CreatedBy.Email
                          FROM AsyncApexJob 
                          WHERE Id = :bc.getJobId()];
        
        for(LeaveThatHaveStarted e : leaveStart){
            e.started  = true;
            EMPLR = [SELECT Id,Leave_Started__c,Leave_Start_Date__c
                     FROM Employee_Leave_Request__c
                     WHERE (Leave_Start_Date__c =: d OR Leave_Start_Date__c <: d)
                     AND Approval_Status__c = 'Approved by HR'
                     AND Leave_Started__c = False
                     AND CreatedDate > 2019-01-01T00:00:00.000Z 
                    ];
            for(Employee_Leave_Request__c emp: EMPLR){
                emp.Leave_Started__c = true;
                update emp;
                system.debug('Leave emp'+ emp );
               // system.debug('Yesterday'+ yesterday );
                system.debug('Leave Started'+ emp.Leave_Started__c );
            }

            // EMPLR.Leave_Started__c = true;
        } 
       // update EMPLR; 
      //  system.debug('Employee Leave Request'+ EMPLR );
        
        
    }     
    
    
    // Request data
    public class LeaveThatHaveStarted{
        public String id;
        public Date leaveStartDate;
        public Boolean started;
        public Employee_Leave_Request__c item{get; set;}
        
    }
    
}