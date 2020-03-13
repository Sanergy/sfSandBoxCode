trigger NotifyPTSRequester on Procurement_Tracking_Sheet__c (before update) {
    
   /* for(Procurement_Tracking_Sheet__c pts:Trigger.new){

    Procurement_Tracking_Sheet__c pt=Trigger.oldMap.get(pts.Id);
    
    if(pts.Requestor__c != null){
     
        List<Employee__c> em=[SELECT Work_Email__c,Name
                                  FROM Employee__c
                                  WHERE ID=:pts.Requestor__c];
        
        List<User> emp=[SELECT Email,Name
                                  FROM User
                                  WHERE ID=:pts.OwnerId];
        
          if(pts.Team_Lead_Approval_Status__c=='Declined By Maintenance Team Lead'||pts.Team_Lead_Approval_Status__c=='Approved'|| pts.Team_Lead_Approval_Status__c=='Declined By Requesting Department Team Lead'|| pts.Team_Lead_Approval_Status__c=='Declined'||pts.Team_Lead_Approval_Status__c=='Declined By Finance'){
              if(pts.Team_Lead_Approval_Status__c!=pt.Team_Lead_Approval_Status__c){    
              
         if(em.size()>0){
             if(emp.size()>0){
                 if(em.get(0).Work_Email__c!=null && em.get(0).Work_Email__c!=emp.get(0).Email){                                          
                                    
                     String [] address=new String[]{em.get(0).Work_Email__c};
                     String subject='PTS APPROVAL STATUS';
                     String body='<p>Hi '+StringUtils.ignoreNull(em.get(0).Name)+',</p><p>Your PTS Request has been '+StringUtils.ignoreNull(pts.Team_Lead_Approval_Status__c)+'</p><p>PTS Link: <br>https://sanergy.my.salesforce.com/'+pts.id+'</p><p>Regards,</p>';
                     
                     
                     //send the email
                      EmailSender email=new EmailSender(address,subject,body);
                      email.sendMessage(true);
                     }
                 /*if(emp.size()>0){
                 if(pts.Requestor__c!=pts.CreatedById){                                          
                                    
                     String [] address=new String[]{emp.get(0).Work_Email__c};
                     String subject='PTS APPROVAL STATUS';
                     String body='<p>Hi '+StringUtils.ignoreNull(em.get(0).Name)+',</p><p>Your PTS Request has been '+StringUtils.ignoreNull(pts.Team_Lead_Approval_Status__c)+'</p><p>PTS Link: <br>https://sanergy.my.salesforce.com/'+pts.id+'</p><p>Regards,</p>';
                     
                     
                     //send the email
                      EmailSender email=new EmailSender(address,subject,body);
                      email.sendMessage(true);
                     }*/
               /*  }
                 
                }
             }
         }
         
        }
     
    }*/
    
 }