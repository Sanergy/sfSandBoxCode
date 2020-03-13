trigger IssuanceNotificationToTeamLead on Sanergy_Asset__c (after update) {
    Integer count = 0;
    for(Sanergy_Asset__c ass:Trigger.new){
        Sanergy_Asset__c s=Trigger.oldMap.get(ass.Id);
        if(s.Asset_Status__c!=ass.Asset_Status__c && ass.Asset_Status__c=='Issued'){
            count ++;
            //get the emails of team lead and user
            Employee__c emails=[SELECT name, Line_Manager__r.Work_Email__c,Work_Email__c,Line_Manager__r.name 
                                      FROM Employee__c
                                      WHERE ID=:ass.Employee__c ];
            //get list of other Issued assets
             List<Sanergy_Assets_Issuance__c> assets=[SELECT Asset_ID__r.name, Asset_ID__r.Asset_Name__c, Asset_ID__r.Make__c,Asset_Returned__c,
                                                      Asset_ID__r.Model__c,Asset_ID__r.Asset_Purchase_Price__c,Asset_ID__r.Asset_Status__c
                                                      FROM Sanergy_Assets_Issuance__c 
                                                      WHERE Employee__c=:ass.Employee__c
                                                      AND Asset_ID__c!=:ass.id];
           
            String assetTable='<table border="1" cellpadding="5"><tr><th>Asset ID</th><th>Asset Name</th><th>Make</th><th>Model</th><th>Asset Status</th><th>Purchase Price</th><th>Asset Returned</th></tr>';
                           
                           for(Sanergy_Assets_Issuance__c ast :assets){
                               assetTable+='<tr><tr><td>'+ast.Asset_ID__r.name+'</td><td>'+ast.Asset_ID__r.Asset_Name__c+'</td><td>'+ast.Asset_ID__r.Make__c+'</td><td>'+ast.Asset_ID__r.Model__c+'</td><td>'+ast.Asset_ID__r.Asset_Status__c+'</td><td>KSh. '+ast.Asset_ID__r.Asset_Purchase_Price__c+'</td><td>'+ast.Asset_Returned__c+'</td></tr>';
                           }
                           assetTable+='</table>';
                         if(emails != null){                         
                              
                              String[] email= new String[]{};
                              
                             if(emails.Line_Manager__r.Work_Email__c != null){
                                // email.add(emails.get(0).Line_Manager__r.Work_Email__c);
                              }
                              if(emails.Work_Email__c != null){
                                  email.add(emails.Work_Email__c); 
                              }
                                                        
                              String subject='SANERGY ASSET ISSUED';
                              String message='<p>Hi,</p><p>An asset has been Issued to '+JSON.serialize(email) + ' ' + count +'.</p>';
                              message+='<h5>DETAILS</h5>';
                              message+='<table border="1" cellpadding="5"><tr><th>Field</th><th>Value</th></tr>';
                              message+='<tr><td>Asset ID</td><td>'+ass.name+'</td></tr>';
                              message+='<tr><td>Asset Name</td><td>'+ass.Asset_Name__c+'</td></tr>';
                              message+='<tr><td>Asset Make</td><td>'+ass.Make__c+'</td></tr>';
                              message+='<tr><td>Asset Model</td><td>'+ass.Model__c+'</td></tr>';
                              message+='<tr><td>Asset Status</td><td>'+ass.Asset_Status__c+'</td></tr>';
                              message+='<tr><td>Purchase Amount</td><td>KSh.'+ass.Asset_Purchase_Price__c+'</td></tr>';
                              message+='</table>';
                             
                              message+='<p>Link to the Asset:https://sanergy.my.salesforce.com/'+ass.id+'</p>';
                              
                              message+='<h5>PREVIOUSLY ISSUED ITEMS ('+assets.size()+')</h5>';
                              message+=assetTable;
                              message+='<p>Regards</p>';
                             
                              EmailSender sender=new EmailSender(email,subject,message);
                             
                                      if(email.size() > 0 && count == 1){
                                           sender.sendMessage(true);
                                      }
                               }
                               /*       
                              String assetTable2='<table border="1" cellpadding="5"><tr><th>Asset ID</th><th>Asset Name</th><th>Make</th><th>Model</th><th>Purchase Price</th></tr>';
                                   
                                   for(Sanergy_Assets_Issuance__c ast2 :assets){
                                       assetTable2+='<tr><tr><td>'+ast2.Asset_ID__r.name+'</td><td>'+ast2.Asset_ID__r.Asset_Name__c+'</td><td>'+ast2.Asset_ID__r.Make__c+'</td><td>'+ast2.Asset_ID__r.Model__c+'</td><td>KSh. '+ast2.Asset_ID__r.Asset_Purchase_Price__c+'</td></tr>';
                                   }
                                   assetTable2+='</table>';
                                 if(emails.size()>0){                         
                                      
                                      String[] email2= new String[]{};
                                      String[] userAddress=new String []{'abel.wafula@saner.gy'};    
                                      if(emails.get(0).Line_Manager__r.Work_Email__c!=null){
                                         //email.add(emails.get(0).Line_Manager__r.Work_Email__c);
                                      }
                                      if(emails.get(0).Work_Email__c!=null){
                                          //email.add(emails.get(0).Work_Email__c);
                                      }
                                                                
                                      String userSubject='SANERGY ASSET ISSUED TO YOU';
                                      String message2='<p>Hi '+emails.get(0).name+',</p><p>An asset has been Issued to you.</p>';
                                     
                                      message2+='<h5>DETAILS</h5>';
                                     
                                      message2+='<table border="1" cellpadding="5"><tr><th>Field</th><th>Value</th></tr>';
                                      message2+='<tr><td>Asset ID</td><td>'+ass.name+'</td></tr>';
                                      message2+='<tr><td>Asset Name</td><td>'+ass.Asset_Name__c+'</td></tr>';
                                      message2+='<tr><td>Asset Make</td><td>'+ass.Make__c+'</td></tr>';
                                      message2+='<tr><td>Asset Model</td><td>'+ass.Model__c+'</td></tr>';
                                      message2+='<tr><td>Purchase Amount</td><td>KSh.'+ass.Asset_Purchase_Price__c+'</td></tr>';
                                      message2='</table>';
                                     
                                      message2+='<p>Link to the Asset:https://sanergy.my.salesforce.com/'+ass.id+'</p>';
                                      
                                      message2+='<h5>PREVIOUSLY ISSUED ITEMS ('+assets.size()+')</h5>';
                                      message2+=assetTable2;
                                      message2+='<p>Regards</p>';
                                     
                                      EmailSender sendToUser=new EmailSender(userAddress,userSubject,message2);
                                                                                             
                                      //if(email.size() > 0){
                                           sendToUser.sendMessage(true);
                                      //}
                                  }*/
        }
    }

}