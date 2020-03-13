public class EmailSender{
    
    String[] toAddresses;
    String Subject;
    String message;
    Integer timeForReply;
    
    //constructor
    public EmailSender(String[] to, String subject, String message){
        this.toAddresses=to;
        this.Subject=subject;
        this.message=message;
        this.timeForReply=1;
    }
    
    
    //function to send email
    public List<Messaging.SendEmailResult> sendMessage(){
        return sendMessage(false,null,null);
    }
    
     //function to send email
    public List<Messaging.SendEmailResult> sendMessage(boolean html){
        return sendMessage(html,null,null);
    }
    
    public List<Messaging.SendEmailResult> sendMessage(boolean html, String templateId,String targetObjectId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        
        if(templateId!=null){
        
          //get users name
          List<User> user=[SELECT Name
                           FROM User 
                           WHERE ID=:UserInfo.getUserId()];
            if(user.get(0).Name!=null){
                mail.setSenderDisplayName(user.get(0).Name);
            
            }
            else{
                mail.setSenderDisplayName('Sanergy Salesforce');
            
            }
            mail.setTemplateId(templateId);
            mail.setTargetObjectId(targetObjectId);
            
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);
        }
        else{
            if(html){
            mail.setHtmlBody(message);
            } else {
                mail.setPlainTextBody(message);
            } 
            
             mail.setToAddresses(toAddresses); 
             mail.setSubject(Subject);
        }
        
       
        
       // mail.setReplyTo('locationdemolitionfeedback@3wakjpoc9i1wtbjb09dgy9opptk16vasgwkuygbbpdxmajy5o.l-5sm2imaq.cs8.apex.sandbox.salesforce.com');

        List<Messaging.SendEmailResult> results =Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
        return results;
    }
    
    
    
    
}