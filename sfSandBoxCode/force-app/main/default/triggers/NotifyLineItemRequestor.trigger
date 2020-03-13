trigger NotifyLineItemRequestor on PTS_Line_Item__c (before update) {
   /* for(PTS_Line_Item__c itm:Trigger.new){
        
        
         if(itm.Qty_Delivered__c != Trigger.oldMap.get(itm.ID).Qty_Delivered__c && itm.Qty_Delivered__c > Trigger.oldMap.get(itm.ID).Qty_Delivered__c){
         
             List<Procurement_Tracking_Sheet__c> pts=[SELECT Requestor__c
                                                         FROM Procurement_Tracking_Sheet__c
                                                         WHERE ID=:itm.Procurement_Tracking_Sheet__c];
             
             List<Employee__c> em=[SELECT Work_Email__c,Name
                          FROM Employee__c
                          WHERE ID=:pts.get(0).Requestor__c];
             Double Quantity=itm.Quantity__c;
             Double QDelivered=itm.Qty_Delivered__c;
            
             Double Oqd=Trigger.oldMap.get(itm.ID).Qty_Delivered__c; 
             if(QDelivered >Oqd ){  
             if(em.size()>0){
                 if(em.get(0).Work_Email__c!=null){
                             String r=String.valueOf(QDelivered-Oqd);
                             String s=String.valueOf(oqd);
                             Double vr;
             if(QDelivered>Quantity){vr=0;}else vr=itm.Quantity__c-itm.Qty_Delivered__c;
                             String var=vr.format();
                             String q=String.valueOf(Quantity);
                             String qd=String.valueOf(QDelivered);
                             String [] address=new String[]{em.get(0).Work_Email__c};
                             String subject='RECEIVED ITEMS';
                             String body='<p>Hi '+StringUtils.ignoreNull(em.get(0).Name)+',</p><p>You had received '+StringUtils.ignoreNull(s)+' '+StringUtils.ignoreNull(itm.Item__c)+' items and now you have received '+StringUtils.ignoreNull(r)+' more items of '+StringUtils.ignoreNull(q)+' '+StringUtils.ignoreNull(itm.Item__c)+ ' items you requested. Therefore, total received items are '+StringUtils.ignoreNull(qd)+' '+StringUtils.ignoreNull(itm.Item__c)+' and total remaining items are '+StringUtils.ignoreNull(var)+' '+StringUtils.ignoreNull(itm.Item__c)+'.</p><p>PTS Line Item Link: <br>https://sanergy.my.salesforce.com/'+itm.id+'</p><p></p><p>Regards</p>';
                                                          
                             //send the email
                              EmailSender email=new EmailSender(address,subject,body);
                              
                             try{
                                  email.sendMessage(true);
                             }catch(Exception e){}
                              
                              
                              }
                 
                     }
                          
                }    
             }
           
         }

*/    
}