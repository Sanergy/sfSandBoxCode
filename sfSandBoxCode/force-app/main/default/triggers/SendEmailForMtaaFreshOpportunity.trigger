trigger SendEmailForMtaaFreshOpportunity on Opportunity (before update) {
    for(Opportunity opp: Trigger.new){
        if(opp.RecordTypeId=='012D0000000Qsni' && opp.StageName=='Confirmed'){
            
            // Create a list to hold the emails we'll send
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            String siteURL = 'https://sanergy.my.salesforce.com/';
            
            // Create an instance of the Messaging.SingleEmailMessage class.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String[] toAddresses = new String[] {'wali.mwalugongo@saner.gy','lindsay@saner.gy',
                'douglas.lifede@saner.gy','valbett.adera@saner.gy','jacinta.mutevu@saner.gy','kanyi@saner.gy',
                'samuel.kariuki@saner.gy','kimathi@saner.gy','musyoka@saner.gy','jacktone.odera@saner.gy'};
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Sanergy - Salesforce');
            mail.setSubject('Mtaa Fresh Opportunity: ' + opp.Name);           		   
            mail.setHtmlBody
                ('<p>Hi Team,</p>' +
                 '<p>Opportunity <em><strong>' +  opp.Name + ' </strong></em> has been <strong><em> ' + opp.StageName + ' </strong></em>.' +                     
                 '<br/>'+
                 '<hr/>'+
                 '<p>For more details visit ' + siteURL + opp.id + ' </p>');
            
            mails.add(mail);
            
            Messaging.sendEmail(mails);        
            
            System.debug(mails);            
        }
        
    }
}