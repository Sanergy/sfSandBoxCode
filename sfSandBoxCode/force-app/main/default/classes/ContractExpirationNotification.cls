global class ContractExpirationNotification implements Database.Batchable<sObject>, Database.Stateful {
    
    String query;
    
    //Get Salesforces' Current Instance URL
    String SalesforceCurrentInstanceURL = URL.getSalesforceBaseUrl().toExternalForm();    
    
    //Set no. of days
    Integer numberOfDays = 45;
    
    // Start notification 45 days before contract expires
    Date notificationDate = date.today() + 45;
    
    List<ExpiringContracts> expiringcontracts = new List<ExpiringContracts>();    
    
    // Get all Contracts that are expiring in 45 days
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        query = 'SELECT Id,ContractNumber,Account.Name,' +
            ' StartDate,EndDate,Contract_Expired__c' +
            ' FROM Contract' +
            ' WHERE Contract_Expired__c = false' +
            ' AND EndDate =: notificationDate';
        
        return Database.getQueryLocator(query);
    }
    
    // Get all contracts that are expiring
    global void execute(Database.BatchableContext bc, List<Contract> scope){
        
        // Loop through the list of Contracts
        for(Contract c : scope){
            
            ExpiringContracts contracts = new ExpiringContracts();
            
            contracts.id = c.Id;
            contracts.contractNumber = c.ContractNumber;
            contracts.accountName = c.Account.Name; 
            contracts.contractStartDate = c.StartDate;
            contracts.contractEndDate = c.EndDate;            
            contracts.contractExpired = c.Contract_Expired__c;
            
            // Add expiring contracts to the list
            expiringcontracts.add(contracts);
        }                
    }
    
    global void finish(Database.BatchableContext bc){
        
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status,CreatedBy.Email
                          FROM AsyncApexJob 
                          WHERE Id = :bc.getJobId()];
        
        // Create a list to hold the emails we'll send
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(ExpiringContracts e : expiringcontracts){
            
            // Create an instance of the Messaging.SingleEmailMessage class.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set the email sender
            mail.setReplyTo('noreply@saner.gy');
            mail.setSenderDisplayName('SALESFORCE');
            
            // Send email to recipients
            List<String> sendTo = new List<String>();
            //sendTo.add('susan.gathigia@saner.gy');
            //sendTo.add('susan.waweru@saner.gy');
            //sendTo.add('dsalano@saner.gy');
            //sendTo.add('priscilla.salano@saner.gy');
            sendTo.add('michael.kamau@saner.gy');
            
            mail.setToAddresses(sendTo);            
            mail.setSubject('Notification On Expiring Contract No: ' + e.contractNumber);           		   
            mail.setHtmlBody
                ('<p>Contract No: <em><strong>' +  e.contractNumber + ' </strong></em> for <strong><em> ' + e.accountName+ ' </strong></em> is expiring in <strong><em>' + numberOfDays + '</strong></em>.</p>' +
                 '<h4>SUMMARY</h4>' +
                 '<hr/>'+           
                 '<p><strong>Contract No: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>' +  e.contractNumber + '</p>' +
                 '<p><strong>Account Name: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>' +  e.accountName  + '</p>' +
                 '<p><strong>Contract Start Date: &nbsp;&nbsp;</strong>' +  e.contractStartDate + '</p>' +
                 '<p><strong>Contract End Date: &nbsp;&nbsp;&nbsp;</strong>' +  e.contractEndDate + '</p>' +
                 '<p><strong>Contract Expired: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>' +  e.contractExpired + '</p>'+
                 '<p>For more details visit ' + SalesforceCurrentInstanceURL + '/' + e.id + '</p>' +
                 '<hr/>'+
                 '<p style="color:red; font-size:70%;">Job Status: ' + a.Status + '</p>');
            
            mails.add(mail);
        }        
        Messaging.sendEmail(mails);        
        
        System.debug(mails);
    }    
    
    // Request data
    public class ExpiringContracts{
        public String id;
        public String contractNumber;        
        public String accountName;
        public Date contractStartDate;
        public Date contractEndDate;        
        public Boolean contractExpired;
    }
}