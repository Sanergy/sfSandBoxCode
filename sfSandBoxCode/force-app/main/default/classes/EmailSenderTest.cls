@isTest(SeeAllData=true)
private class EmailSenderTest{

     /*------------------Test Class for EmailSender------------------------- */  
      static testMethod void sendEmail() {
          EmailSender senderNoHtlm=new EmailSender(
              new String[]{'test@email.com'},
              'subject',
              'message'
          );
          
           EmailSender senderHtlm=new EmailSender(
              new String[]{'test@email.com'},
              'subject',
              'message'
          );
          
           EmailSender senderTemplate=new EmailSender(
              new String[]{'test@email.com'},
              'subject',
              'message'
          );
          
          //get template
            List<EmailTemplate> template =[SELECT ID FROM EmailTemplate LIMIT 1];
            
          //get user
          List<User> user=[SELECT ID FROM User LIMIT 1];
          
          senderNoHtlm.sendMessage();
          senderHtlm.sendMessage(true);
          
          
          if(template.size()>0 && user.size()>0){
              senderTemplate.sendMessage(true,template.get(0).id, user.get(0).id);
          }
          
      }
}