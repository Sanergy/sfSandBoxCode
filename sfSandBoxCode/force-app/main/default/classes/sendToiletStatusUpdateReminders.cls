public class sendToiletStatusUpdateReminders{
    
    public static void sendRemindersToSOPs(){
        //get the users with the profile
        List<user> sfoUsers=[Select ID
                             FROM User 
                             WHERE ProfileId IN(
                                SELECT ID 
                                FROM Profile 
                                WHERE Name='Sanergy - Sales & Operations - Senior Field Officer')];
                              
        if(sfoUsers.size()>0){
             //get the email template
             List<EmailTemplate> templateList=[SELECT ID
                                           FROM EmailTemplate
                                           WHERE Name='Remind SFOs to update toilet statuses for Renewal Opportunity Creation'];
                                           
              if(templateList.size()>0){
                 
                 for(User sfo:sfoUsers){
                     EmailSender sender=new EmailSender(null,null,null);
                     sender.sendMessage(true, templateList.get(0).id, sfo.id);
                 }
              }
        }
    }
}