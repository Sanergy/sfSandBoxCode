trigger NotifyHelpDeskPTSRequestTrigger on Procurement_Tracking_Sheet__c (before update) {
   /* for(Procurement_Tracking_Sheet__c pts: Trigger.new){
        List<Employee__c> em=[SELECT Name
                                  FROM Employee__c
                                  WHERE ID=:pts.Requestor__c];
        List<FFA_Config_Object__c> mDTl= [SELECT ID,Name,Teamlead__c FROM FFA_Config_Object__c 
                                           WHERE Name='Information Technology'] ;
         List<FFA_Config_Object__c> depName= [SELECT ID,Name FROM FFA_Config_Object__c 
                                              WHERE Id=:pts.Requesting_Department__c];
        String dep;
        if(depName.size()>0){
            dep=depName.get(0).Name;
        }       
        if(pts.Maintenance_Department__c==mDTL.get(0).Id && pts.Team_Lead_Approval_Status__c=='Approved'&& pts.Team_Lead_Approval_Status__c != Trigger.oldMap.get(pts.ID).Team_Lead_Approval_Status__c){
            if(em.size()>0){
                                   
                String [] address=new String[]{'helpdesk@saner.gy'};
                 String subject='PTS REQUEST';
                 String body='<p>Hi Helpdesk, </p><p>'+StringUtils.ignoreNull(em.get(0).Name)+' has requested for items on Approved PTS name: '+pts.Name+'</p><p>PTS Link: <br>https://sanergy.my.salesforce.com/'+pts.id+'</p>';
              
                 
                 //send the email
                  EmailSender email=new EmailSender(address,subject,body);
                  email.sendMessage(true);
             
                 
           	 }
        }
        if(pts.Team_Lead_Approval_Status__c=='Approved' && pts.Team_Lead_Approval_Status__c != Trigger.oldMap.get(pts.ID).Team_Lead_Approval_Status__c){
            if(em.size()>0){
                                   
                LIST<PTS_Line_Item__c> line=[SELECT name,Procurement_Tracking_Sheet__c,Currency__c,Item__c,Purchase_URL__c,Quantity__c,Specifications__c,Total_Estimate_Amount__c,Unit_Price__c,Units__c 
                                             FROM PTS_Line_Item__c   WHERE Procurement_Tracking_Sheet__c=:pts.Id];
                
                String assetTable='<table border="1" cellpadding="5"><tr><th>NAME</th><th>ITEM</th><th>UNITS</th><th>QUANTITY</th><th>UNIT ESTIMATE PRICE</th></th><th>TOTAL ESTIMATE PRICE</th></tr>';
                           
                           for(PTS_Line_Item__c lin :line){
                               assetTable+='<tr><tr><td>'+lin.name+'</td><td>'+lin.Item__c+'</td><td>'+lin.Units__c+'</td><td>'+lin.Quantity__c+'</td><td>'+lin.Unit_Price__c+'</td><td>'+lin.Total_Estimate_Amount__c+'</td></tr>';
                           }
                           assetTable+='</table>';
                
                 String [] address=new String[]{'barrack@saner.gy','team-finance@saner.gy','kimathi@saner.gy','mutinda@saner.gy','priscilla.salano@saner.gy'};
                 String subject='APPROVED PTS REQUEST';
                 String body='<p>Hi Team, </p><p>Request for items on '+pts.Name+'&nbsp;for '+StringUtils.ignoreNull(em.get(0).Name)+' has been Approved. </p>';
                 body+='<h5>DETAILS</h5>';
                 body+='<table border="1" cellpadding="5"><tr><th>Field</th><th>Value</th></tr>';
                 body+='<tr><td>PTS NAME</td><td>'+pts.name+'</td></tr>';
                 body+='<tr><td>REQUESTING DEPARTMENT</td><td>'+dep+'</td></tr>';
                List<FFA_Config_Object__c> depNam= [SELECT ID,Name FROM FFA_Config_Object__c 
                                              WHERE Id=:pts.Maintenance_Department__c];
       		     if(depName.size()>0){
         		   dep=depNam.get(0).Name;
      			  }
                 body+='<tr><td>MAINTENANCE DEPARTMENT</td><td>'+dep+'</td></tr>';
                 body+='<tr><td>PRIORITY</td><td>'+pts.Priority__c+'</td></tr>';
                 Decimal rA = pts.Total_Amount__c;
				 List<String> args = new String[]{'0','number','###,###,##0.00'};
				 String s = String.format(rA.format(), args);
                 body+='<tr><td>TOTOL AMOUNT</td><td>'+pts.CurrencyIsoCode+'&nbsp;'+s+'</td></tr>';
                 body+='</table>';
                                
                
                 body+='<h5>PTS LINE ITEMS ('+line.size()+')</h5>';
                 body+=assetTable;
                 body+='<p>Link to the PTS:https://sanergy.my.salesforce.com/'+pts.id+'</p>';
                                         
                 body+='<p>Regards</p>';
                 
                 //send the email
                  EmailSender email=new EmailSender(address,subject,body);
                  email.sendMessage(true);
                
            }
        }
    }
*/
}