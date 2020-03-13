@isTest(seeAllData=true)
public class LeaveStartedScheduleTest {
    // Tests for LeaveStarted class.    
    @isTest static void testLeaveStarted(){ 
        
        Date d = date.today() + 1;
        
        // Create a list of Leave Requests
        List<Employee_Leave_Request__c> a = [SELECT Id,Leave_Started__c,Leave_Start_Date__c
                                             FROM Employee_Leave_Request__c
                                             WHERE Leave_Start_Date__c =: d];        
        
        // Create a contract
       // Contract contract1 = new Contract (AccountId=a.get(0).Id, Status='Draft',StartDate=d, ContractTerm=1,
                                         //  Payment_Terms__c='15 Days',Primary_Contract__c=false);
      //  INSERT contract1;
        
        // Create an instance of LeaveStarted
        LeaveStarted c = new LeaveStarted();
        Database.executeBatch(c);           
    }
    
    // Tests for LeaveStartedSchedule class.     
    @isTest static void testLeaveStartedSchedule(){
        // Execute the job on midnight, 31 December 2022
        String cronExpr = '0 0 0 31 12 ? 2022';
        
        // Create an instance of LeaveStartedSchedule         
        LeaveStartedSchedule ns = new LeaveStartedSchedule();
        
        // Schedule the test job        
        String jobId = System.schedule('This is a Sandbox Test Job', cronExpr, ns);
        ns.execute(null);
        
    } 
}