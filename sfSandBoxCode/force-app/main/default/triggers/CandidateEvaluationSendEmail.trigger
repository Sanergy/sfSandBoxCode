// Send an email notification to the Candidate after receiving their application
trigger CandidateEvaluationSendEmail on Candidate_Requisition__c (after insert) {
    
    //Get the email template
    /*EmailTemplate emailTemplate =[Select Id,Name 
    FROM EmailTemplate 
    WHERE Name=:'Notify Candidate After Receiving Their Application'];
    */
    
    // List of emails to send
    List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
    
    for(Candidate_Requisition__c candidateRequisition: Trigger.new){
        
        System.debug('candidateRequisition.Id: ' + candidateRequisition.Id);
        System.debug('candidateRequisition.Recruitment_Requisition__c: ' + candidateRequisition.Recruitment_Requisition__c);
        System.debug('candidateRequisition.Candidate__c: ' + candidateRequisition.Candidate__c);
        
        Candidate_Requisition__c requistion = [SELECT Id,Name,Recruitment_Requisition__c,Recruitment_Requisition__r.Name
                                               FROM Candidate_Requisition__c
                                               WHERE Recruitment_Requisition__c =: candidateRequisition.Recruitment_Requisition__c
                                               LIMIT 1];
        
        Candidate__c candidate = [SELECT Id,Name,Email__c,First_Name__c,Last_Name__c,Recruitment_Requisition__c,
                                  Recruitment_Requisition__r.Name
                                  FROM Candidate__c 
                                  WHERE Id =: candidateRequisition.Candidate__c
                                  LIMIT 1];
        
        if(candidate == null){
            
            candidateRequisition.adderror('Error submitting your application.');
            
        }else{        
            //Check if Owner is Web App 005D0000008xILI 
            if(candidateRequisition.OwnerId == '005D0000008xILI' || candidateRequisition.OwnerId == '0057E000006fPwo'){
                
                if(candidate.Email__c != null){
                    // Create a new Email
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    // Send email to recipient
                    List<String> sendTo = new List<String>();
                    sendTo.add(candidate.Email__c);
                    mail.setToAddresses(sendTo);
                    
                    // Set the email sender
                    //mail.setOrgWideEmailAddressId('freshlife@saner.gy');   //Use line 48 or 50
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
                    body += '<p>We have received your application for the ' + requistion.Recruitment_Requisition__r.Name + ' role.</p>';
                    body += '<p>We are currently reviewing all applications for the role and we will be in contact with you if you are successful in being shortlisted.</p>';
                    body += '<p>If you have not heard from any Sanergy team member within 2 weeks,please consider your application unsuccessful at this time.</p>';
                    body += '<p>We have however stored your application in our database for future reference.</p>';
                    body += '<p>We wish you the best of luck.</p>';
                    body += '<br/>';
                    body += '<p style="font-weight: bold; text-decoration: underline;">NOTE TO APPLICANTS</p>';
                    body += '<p>SANERGY AND FRESH LIFE <b><u>DO NOT</u></b> CHARGE A FEE AT ANY STAGE OF THE RECRUITMENT PROCESS ';
                    body += '(APPLICATION, INTERVIEW MEETING, PROCESSING, OR TRAINING). SANERGY AND FRESH LIFE <b><u>DO NOT</u></b> ';
                    body += 'ASK FOR INFORMATION ON YOUR BANK ACCOUNTS AND ANY OTHER PERSONAL INFORMATION OUTSIDE THE RECRUITMENT PROCESS.</p>';
                    body += '<p>IF YOU RECEIVE ANY SUCH SOLICITATION KINDLY CONTACT US AT <b><i>info@saner.gy</i></b></p>';
                    body += '<br/>';
                    body += '<p>THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT REPLY DIRECTLY TO THIS EMAIL.</p>';
                    body += '<br/>';
                    body += '<p style="font-weight: bold; font-style: italic;">SANERGY</p>';
                    body += '<p style="font-weight: bold; font-style: italic;"><sub>Building healthy,prosperous communities.</sub></p>';
                    mail.setHtmlBody(body);
                    
                    //flag to false to stop inserting activity history
                    mail.setSaveAsActivity(false);
                    
                    //Add email to the list
                    mails.add(mail); 
                    System.debug('EMAIL: ' + mails);
                    //Set object Id
                    //mail.setTargetObjectId(candidate.Id);
                    
                    //Set template Id
                    //mail.setTemplateId(emailTemplate.Id);
                }// End if(candidateRequisition.Candidate__r.Email__c != null)
            }// End if(candidateRequisition.Owner.Name == 'Web App')
        }//End if(candidate == null)
    }
    
    // Send email
    Messaging.sendEmail(mails);    
    
}