global class ToiletsClosedReminder implements Database.Batchable<sObject>, Database.Stateful{
    
    String query2;
    
    // Start notification 90 days after toilet is closed
    Date d2 = date.today() - 90;
    
    //Status for closed toilets
    String status2 = 'Closed';
    
    //Closure type - Temporary
    String closureType2 = 'Temporary';
    
    List<ClosedToiletsReminder> closedToiletsReminder = new List<ClosedToiletsReminder>();    
    
    // Get all Toilets that were closed 90 days ago
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        query2 = 'SELECT Id,Name,Opportunity__r.Account.Name,Account_Name__c,' +
            ' Operational_Status__c,Current_Specific_Status__c,Closure_Type__c,' +
            ' Current_Status_Change_date__c,Operational_Status_Description__c' +
            ' FROM Toilet__c' +
            ' WHERE Operational_Status__c =: status2' +
            ' AND Closure_Type__c =: closureType2' +
            ' AND Current_Status_Change_date__c =: d2';
        
        return Database.getQueryLocator(query2);
    }
    
    // Get all Toilets that were closed
    global void execute(Database.BatchableContext bc, List<Toilet__c> scope){
        
        // Loop through the list of Contracts
        for(Toilet__c t : scope){
            
            ClosedToiletsReminder toiletsReminder = new ClosedToiletsReminder();            
            toiletsReminder.id = t.Id;
            toiletsReminder.toiletName = t.Name;
            toiletsReminder.accountName = t.Opportunity__r.Account.Name;
            toiletsReminder.operationalStatus = t.Operational_Status__c;
            toiletsReminder.typeOfClosure = t.Closure_Type__c;
            toiletsReminder.currentSpecificStatus = t.Current_Specific_Status__c;
            toiletsReminder.currentStatusChangeDate = t.Current_Status_Change_date__c;            
            
            // Add closed toilets to the list
            closedToiletsReminder.add(toiletsReminder);
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
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(ClosedToiletsReminder ct : closedToiletsReminder){
            
            String siteURL = 'https://sanergy.my.salesforce.com/';
            
            // Create an instance of the Messaging.SingleEmailMessage class.
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            String[] toAddresses = new String[] {'dev@saner.gy','florence@saner.gy','jgithinji@saner.gy','sifuna@saner.gy','rose.kavuli@saner.gy'};
            email.setToAddresses(toAddresses);
            email.setSenderDisplayName('Sanergy - Salesforce');
            email.setSubject('90 Days Reminder on Toilets Closed(Temporary) - Toilet No: ' + ct.toiletName);           		   
            email.setHtmlBody
                ('<p>Hi,</p>'+
                 '<p>Toilet No: <em><strong>' +  ct.toiletName + ' </strong></em> for <strong><em> ' + ct.accountName + ' </strong></em> was closed <strong><em>90 days ago</strong></em>.</p>' +
                 '<p>This is a reminder for you to follow up on this toilet.</p>' +
                 '<h4>SUMMARY</h4>' +
                 '<hr/>'+           
                 '<p><strong>Toilet No: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>' +  ct.toiletName + '</p>' +
                 '<p><strong>Account Name: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>' +  ct.accountName  + '</p>' +
                 '<p><strong>Operational Status: &nbsp;&nbsp;</strong>' +  ct.operationalStatus + '</p>' +
                 '<p><strong>Closure Type: &nbsp;&nbsp;</strong>' +  ct.typeOfClosure + '</p>' +
                 '<p><strong>Current Specific Status: &nbsp;&nbsp;&nbsp;</strong>' +  ct.currentSpecificStatus + '</p>' +
                 '<p><strong>Current Status Change Date: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>' +  ct.currentStatusChangeDate + '</p>'+
                 '<p>For more details visit ' + siteURL + ct.id + ' </p>' +
                 '<hr/>'+
                 '<p style="color:red; font-size:70%;">Job Status: ' + a.Status + '</p>');
            
            emails.add(email);
        }        
        Messaging.sendEmail(emails);        
        
        System.debug(emails);
    }    
    
    // Request data
    public class ClosedToiletsReminder{
        public String id;
        public String toiletName;        
        public String accountName;
        public String operationalStatus;
        public String typeOfClosure;
        public String currentSpecificStatus;
        public Date currentStatusChangeDate;
    }
}