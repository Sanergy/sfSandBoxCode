public class SendEmailToCandidateAfterApproval {
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    //Candidate
    public Candidate__c candidate {get; set;}    
    private List<Candidate__c> candidates {get; set;}
    
    // Constructor
    public SendEmailToCandidateAfterApproval(ApexPages.StandardController controller){               
        this.controller = controller;                
        candidate = (Candidate__c)controller.getRecord();
		candidate = [SELECT Id,Name,Recruitment_Requisition__c,First_Name__c,Last_Name__c,
                     Phone_Number__c,Email__c,Date_Available__c,Candidate_Status__c,
                     Country__c,Resume__c,Recruitment_Requisition__r.Employee_Role__r.Name,
                     Recruitment_Requisition__r.Employee_Role__r.Department__r.Name,
                     Recruitment_Requisition__r.Employee_Role__r.Line_Manager__r.Name,
                     Recruitment_Requisition__r.Proposed_Employee_required_Date__c,
                     Recruitment_Requisition__r.Contract_End_Date__c,
                     Recruitment_Requisition__r.Duration_of_Fixed_term_Contract_Months__c,
					 Recruitment_Requisition__r.Location__c                     
                     FROM Candidate__c
                     WHERE Id =: candidate.Id];       
            
        System.debug('CANDIDATE: ' + candidate);
    }

	// Get Candidate
    public List<Candidate__c> getItems() {
        
        candidates= new List<Candidate__c>();
        
        if(candidate.Candidate_Status__c=='Pending Notification'){
            
            List<Candidate__c> lineItems = [SELECT Id,Name,	Recruitment_Requisition__c,First_Name__c,Last_Name__c,
                                            Phone_Number__c,Email__c,Date_Available__c,Candidate_Status__c,
                                            Country__c,Resume__c,Recruitment_Requisition__r.Employee_Role__r.Name,
                                            Recruitment_Requisition__r.Employee_Role__r.Department__r.Name,
                                            Recruitment_Requisition__r.Employee_Role__r.Line_Manager__r.Name,
                                            Recruitment_Requisition__r.Proposed_Employee_required_Date__c,
                                            Recruitment_Requisition__r.Contract_End_Date__c,
                                            Recruitment_Requisition__r.Duration_of_Fixed_term_Contract_Months__c,
                                            Recruitment_Requisition__r.Location__c
                                          	FROM Candidate__c
                                            WHERE Id =: candidate.Id];
            
            for(Candidate__c lineItem : lineItems){
                candidates.add(lineItem);
            }
        }
        return candidates;
    }
    
    //Create Email Notification to notify candidate
    public PageReference createEmailNotification(){
        
        // List of emails to send
  		List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        
        if(candidate.Email__c != null && candidate.Candidate_Status__c=='Pending Notification'){
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
            //List<String> bccTo = new List<String>();
            //bccTo.add('michael.kamau@saner.gy');
            //mail.setBccAddresses(bccTo);
            
            //flag to false to stop inserting activity history
            mail.setSaveAsActivity(false);             
            
            // Create the email body
            mail.setSubject('OFFER LETTER');
            String body = '<p>Dear ' + candidate.First_Name__c + ' ' + candidate.Last_Name__c + ',</p>';           
            body += '<p>At Sanergy, we bring on teammates who deeply share our commitment to transformative change in the communities in which';
            body += 'we work,and to living out our values: Relentless pursuit of excellence, Pragmatic innovation, Collaboration among our'; 
            body += 'team and customers,Providing enduring value for our customers, and Authenticity in all that we do.</p>';
            body += '<p>We think you are exactly that type of teammate.</p>';
            body += '<p>We are excited to offer you the position of <b>' + candidate.Recruitment_Requisition__r.Employee_Role__r.Name + '</b>.';
            body += 'You will find detailed information about the role below, but first, we want to highlight some key benefits of working at Sanergy.</p>';
            body += 'You will hold key responsibilities, critical for the growth and success of Sanergy. You will be able to leverage your current';
            body += 'strengths and be challenged to develop new skills. You will have opportunities to advance your technical and leadership skills.';
            body += 'You will be surrounded by 250 teammates who are innovative, passionate, and results-driven. You will get to tackle some of the';
            body += 'most pressing challenges of our time as we build healthy, prosperous communities for everyone, forever.';
            body += '<p><b>Role: </b>' + candidate.Recruitment_Requisition__r.Employee_Role__r.Name + '</p>';
            body += '<p><b>Team: </b>' + candidate.Recruitment_Requisition__r.Employee_Role__r.Department__r.Name + '</p>';
            body += '<p><b>Reporting to: </b>' + candidate.Recruitment_Requisition__r.Employee_Role__r.Line_Manager__r.Name + '</p>';
            body += '<p><b>Term: </b>Your probationary contract will commence on ' + candidate.Recruitment_Requisition__r.Proposed_Employee_required_Date__c;
            body += 'and end on ' + candidate.Recruitment_Requisition__r.Contract_End_Date__c + '; and upon successful completion of probation, you will be issued with ';
            body += 'a <b>' + candidate.Recruitment_Requisition__r.Duration_of_Fixed_term_Contract_Months__c + '</b> months contract.';
            body += '<p><b>Place of Work: </b>Your primary place of work is <b>' + candidate.Recruitment_Requisition__r.Location__c + '</b>, but you may need to '; 
            body += 'report to work anywhere in <b>[COUNTY(ies)]</b> when required.</p>';
            body += '<p><b>Benefits: </b> Group personal accident cover and group life, Medical, Pension </p>';
            body += '<p><b>Paid Leave: </b>For every 12-month period, you will have 21 working days of paid leave, 7 working days of paid sick ';
            body += 'leave and 7 working days of sick leave with half pay, 3 working days of exam leave, 90 calendar days of maternity and ';
            body += '14 calendar days of paternity leave</p>';
            body += '<p>A detailed job description is attached to this letter for your review.This offer is contingent upon you submitting '; 
            body += 'the required documentation and signing a formal contract of employment.</p>';
            body += '<p>Join us, </p><br/>';
            body += '<p style="font-weight: bold; font-style: italic;">SANERGY</p>';
            body += '<p style="font-weight: bold; font-style: italic;"><sub>Building healthy,prosperous communities</sub></p>';      		
            mail.setHtmlBody(body);
            
            //Add email to the list
            mails.add(mail);            

        }
        // Send email
        Messaging.sendEmail(mails);
        
        //Update Candidate Status
        candidate.Candidate_Status__c = 'Pending Offer Acception';
        UPDATE candidate;
        
        return new PageReference('/'+ candidate.Id);
    }    
    
}