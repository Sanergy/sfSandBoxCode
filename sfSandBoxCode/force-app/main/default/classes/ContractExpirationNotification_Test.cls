@isTest(seeAllData=true)
public class ContractExpirationNotification_Test {
    
	// Tests for ContractExpirationNotification class.    
    @isTest static void testExpiringContract(){      
        
        Date notificationDate = date.today() + 45;
        
        // Get an Account
        Account acc = [SELECT Id,Name
                       FROM Account
                       WHERE Name = 'Tuffsteel Ltd'
                       LIMIT 1];        
        
        // Create a contract
        Contract contract1 = new Contract ();
        contract1.AccountId = acc.Id; 
        contract1.Status = 'Draft';
        contract1.StartDate = date.today() - 45 ;
        contract1.ContractTerm = 2;
        contract1.Payment_Terms__c = '15 Days';
        contract1.Primary_Contract__c = true;
        INSERT contract1;
        
        System.debug('CONTRACT DETAILS: ' + contract1);
        
        // Create an instance of ContractExpirationNotification
        ContractExpirationNotification c = new ContractExpirationNotification();
        Database.executeBatch(c);           
    }
    
	// Tests for ContractExpirationNotificationScedule class.     
    @isTest static void testNotificationSchedule(){
        // Execute the job on midnight, 31 December 2022
        String cronExpr = '0 0 0 31 12 ? 2022';

		// Create an instance of ContractExpirationNotificationScedule         
        ContractExpirationNotificationScedule ns = new ContractExpirationNotificationScedule();
        
        // Schedule the test job        
        String jobId = System.schedule('This is a Sandbox Test Job', cronExpr, ns);
        ns.execute(null);
        
    }
}