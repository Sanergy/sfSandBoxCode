global class ToiletsClosedNotification implements Database.Batchable<sObject>, Database.Stateful {
    
    String query1;
    
    // Start notification 60 days after toilet is closed
    Date d = date.today() - 60;
    
    //Status for closed toilets
    String status = 'Closed';
    
    //Closure type - Temporary
    String closureType = 'Temporary';
    
    List<ClosedToilets> closedToilets = new List<ClosedToilets>();    
    
    // Get all Toilets that were closed 60 days ago
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        query1 = 'SELECT Id,Name,Opportunity__r.Account.Name,Account_Name__c,' +
            ' Operational_Status__c,Current_Specific_Status__c,Closure_Type__c,' +
            ' Current_Status_Change_date__c,Operational_Status_Description__c' +
            ' FROM Toilet__c' +
            ' WHERE Operational_Status__c =: status' +
            ' AND Closure_Type__c =: closureType' +
            ' AND Current_Status_Change_date__c =: d';
        system.debug ('query1 = ' +query1);
        return Database.getQueryLocator(query1);
    }
    
    // Get all Toilets that were closed
    global void execute(Database.BatchableContext bc, List<Toilet__c> scope){
        
        // Loop through the list of Contracts
        for(Toilet__c t : scope){
            
            ClosedToilets toilets = new ClosedToilets();
            
            toilets.id = t.Id;
            toilets.toiletName = t.Name;
            toilets.accountName = t.Opportunity__r.Account.Name;
            toilets.operationalStatus = t.Operational_Status__c;
            toilets.typeOfClosure = t.Closure_Type__c;
            toilets.currentSpecificStatus = t.Current_Specific_Status__c;
            toilets.currentStatusChangeDate = t.Current_Status_Change_date__c;            
            
            // Add closed toilets to the list
            closedToilets.add(toilets);
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
        
        for(ClosedToilets ct : closedToilets){
            
            String siteURL = 'https://sanergy.my.salesforce.com/';
            
            // Create an instance of the Messaging.SingleEmailMessage class.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String[] toAddresses = new String[] {'dev@saner.gy','florence@saner.gy','jgithinji@saner.gy','sifuna@saner.gy','rose.kavuli@saner.gy'};
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Sanergy - Salesforce');
            mail.setSubject('Notification on Toilets Closed(Temporary) - Toilet No: ' + ct.toiletName);           		   
            mail.setHtmlBody
                ('<p>Toilet No: <em><strong>' +  ct.toiletName + ' </strong></em> for <strong><em> ' + ct.accountName + ' </strong></em> was closed <strong><em>60 days ago</strong></em>.</p>' +
                 '<p>Kindly follow up on the way forward.</p>' +
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
            
            mails.add(mail);
        }        
        Messaging.sendEmail(mails);        
        
        System.debug(mails);
    }    
    
    // Request data
    public class ClosedToilets{
        public String id;
        public String toiletName;        
        public String accountName;
        public String operationalStatus;
        public String typeOfClosure;
        public String currentSpecificStatus;
        public Date currentStatusChangeDate;
    }    
}