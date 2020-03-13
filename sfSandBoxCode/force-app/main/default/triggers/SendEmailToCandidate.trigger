// Send an email notification to each new Candidate after receiving their application
trigger SendEmailToCandidate on Candidate__c (after insert) {
    
    //Get the email template
    /*EmailTemplate emailTemplate =[Select Id,Name 
                      			    FROM EmailTemplate 
                      			    WHERE Name=:'Notify Candidate After Receiving Their Application'];
    
    
    // List of emails to send
  	List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
    
    for(Candidate__c candidate: Trigger.new){
        if(candidate.Email__c != null){
            // Create a new Email
      		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            
	        // Send email to recipient
          	List<String> sendTo = new List<String>();
          	sendTo.add(candidate.Email__c);
          	mail.setToAddresses(sendTo);
            
      		// Set the email sender
      		mail.setReplyTo('info@saner.gy');
      		mail.setSenderDisplayName('SANERGY');
            
      		// Set people to be BCCed
     		List<String> bccTo = new List<String>();
      		//bccTo.add('info@saner.gy');
      		//mail.setBccAddresses(bccTo); 
            
      		// Create the email body
      		mail.setSubject('APPLICATION RECEIVED');
      		String body = '<p>Hi ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c + ',</p>';            
      		//body += '<p>Thank you for your application for the <b><i>' + candidate.Recruitment_Requisition__r.Employee_Role__r.Name + '</i></b> position.</p>';
      		body += '<p>We have received your application.</p>';
            body += '<p>We are currently reviewing all applications for the role and we will be in contact with you if you are successful in being shortlisted.</p>';
      		body += '<p>We wish you the best of luck.</p>';
            body += '<br/>';
            body += '<p style="font-weight: bold; text-decoration: underline;">NOTE TO APPLICANTS</p>';
            body += '<p>SANERGY AND FRESH LIFE <b><u>DO NOT</u></b> CHARGE A FEE AT ANY STAGE OF THE RECRUITMENT PROCESS ';
            body += '(APPLICATION, INTERVIEW MEETING, PROCESSING, OR TRAINING). SANERGY AND FRESH LIFE <b><u>DO NOT</u></b> ';
            body += 'ASK FOR INFORMATION ON YOUR BANK ACCOUNTS AND ANY OTHER PERSONAL INFORMATION OUTSIDE THE RECRUITMENT PROCESS.</p>';
			body += '<p>IF YOU RECEIVE ANY SUCH SOLICITATION KINDLY CONTACT US AT <b><i>info@saner.gy</i></b></p>';
            body += '<br/>';
      		body += '<p style="font-weight: bold; font-style: italic;">SANERGY</p>';
      		body += '<p style="font-weight: bold; font-style: italic;"><sub>Building healthy,prosperous communities.</sub></p>';      		
      		mail.setHtmlBody(body);
            
            //flag to false to stop inserting activity history
            mail.setSaveAsActivity(false);
            
            //Add email to the list
          	mails.add(mail);            
                        
            //Set object Id
            //mail.setTargetObjectId(candidate.Id);

            //Set template Id
            //mail.setTemplateId(emailTemplate.Id);
        }        
    }
  	// Send email
  	Messaging.sendEmail(mails);*/
}