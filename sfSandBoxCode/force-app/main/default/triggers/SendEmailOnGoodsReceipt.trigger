trigger SendEmailOnGoodsReceipt on Procurement_Tracking_Sheet__c (after update) {

  for(Procurement_Tracking_Sheet__c PTS:Trigger.new){
   if(PTS.No_of_Items_received__c!=null && Trigger.oldMap.get(PTS.ID).No_of_Items_received__c!=null){
      if(PTS.No_of_Items_received__c > Trigger.oldMap.get(PTS.ID).No_of_Items_received__c){
          //Send email to requestor to notify of email receipt
          
          //get the email of the requestor
          List<Employee__c> empList=[SELECT Work_Email__c
                        FROM Employee__c
                        WHERE ID=:PTS.Requestor__c];
                        
          if(empList.get(0).Work_Email__c!=null){
                String [] email=new String[]{empList.get(0).Work_Email__c};
                String subject='PTS '+PTS.Name+': Arrival of requested items';
                String message='Items requested using PTS <a href="https://sanergy--ffa.cs8.my.salesforce.com/'+PTS.ID+'">'+PTS.Name+'</a> have arrived at the warehouse';
                
                //send email
                EmailSender sender=new EmailSender(email, subject, message);
                sender.sendMessage(true);
  
          
          }
        
        }
      }
  
  }
}