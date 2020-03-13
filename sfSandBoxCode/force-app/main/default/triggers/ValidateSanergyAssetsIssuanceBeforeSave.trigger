trigger ValidateSanergyAssetsIssuanceBeforeSave on Sanergy_Assets_Issuance__c (before insert, before update) {

     for (Sanergy_Assets_Issuance__c issuance : Trigger.new) {
         
         String assetId = issuance.Asset_ID__c;
         String requisitionId = issuance.Asset_Requisition__c;
         boolean allowSave = true;
         Sanergy_Asset__c asset = null;
         String errorMsg = null;
         
         if(assetId != null && !assetId.equals('')){
         
             asset = [SELECT ID, Asset_Name__c, Asset_Status__c, name, Make__c,Model__c,Asset_Purchase_Price__c FROM Sanergy_Asset__c WHERE ID = :assetId ];
             
             if(Trigger.isInsert){
                 if(asset.Asset_Status__c == null){
                     errorMsg = 'The asset status cannot be determined before issuance';
                     allowSave = false;
                 } else if(!asset.Asset_Status__c.equalsIgnoreCase('Inventory')){
                     errorMsg = 'You can only issue an asset that is in the Inventory';
                     allowSave = false;
                 }
             }
         }
         
         if(requisitionId != null && !requisitionId.equals('')){
         
             Asset_Requisition__c requisition = [SELECT ID, Asset_status__c, Employee__c FROM Asset_Requisition__c WHERE ID = :requisitionId];
             
             issuance.Employee__c = requisition.Employee__c;
             
             if(requisition.Asset_status__c != null){
             
                 if(requisition.Asset_status__c.equals('Issued')){
                     if(Trigger.isInsert){
                         allowSave = false;
                         errorMsg = 'The requisition has already been issued. Create another request to continue';
                     }
                 } else {
                     requisition.Asset_status__c = 'Issued';
                     update requisition;
                 }
             }
         }
         
         if(issuance.Employee__c == null){
         
              errorMsg = 'You have not selected the employee to assign the asset';
              allowSave = false;
         
         }
         
         if(allowSave){
         
             if(issuance.Issue_Type__c != null && issuance.Issue_Type__c.equalsIgnoreCase('Permanent Issue to Staff')){
                 issuance.Date_Due__c = null;
             }
             
             if(Trigger.isInsert){
                 
                 Employee__c emails=[SELECT name, Line_Manager__r.Work_Email__c,Work_Email__c,Line_Manager__r.name 
                                      FROM Employee__c
                                      WHERE ID=:issuance.Employee__c ];
                 
                 Sanergy_Asset__c currentAsset = [SELECT Id, name, Asset_Name__c, Make__c,Model__c, 
                                           Asset_Purchase_Price__c, Asset_Status__c
                                           FROM Sanergy_Asset__c WHERE Id =: issuance.Asset_ID__c]; 
                 
                //get list of other Issued assets
                 List<Sanergy_Assets_Issuance__c> assets=[SELECT Asset_ID__r.name, Asset_ID__r.Asset_Name__c, Asset_ID__r.Make__c,Asset_Returned__c,
                                                          Asset_ID__r.Model__c,Asset_ID__r.Asset_Purchase_Price__c,Asset_ID__r.Asset_Status__c
                                                          FROM Sanergy_Assets_Issuance__c 
                                                          WHERE Employee__c=:issuance.Employee__c
                                                          AND Asset_ID__c!=:issuance.Asset_ID__c];
           
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
                              String message='<p>Hi,</p><p>An asset has been Issued to '+ emails.name + ' .</p>';
                              message+='<h5>DETAILS</h5>';
                              message+='<table border="1" cellpadding="5"><tr><th>Field</th><th>Value</th></tr>';
                              message+='<tr><td>Asset ID</td><td>'+currentAsset.name+'</td></tr>';
                              message+='<tr><td>Asset Name</td><td>'+currentAsset.Asset_Name__c+'</td></tr>';
                              message+='<tr><td>Asset Make</td><td>'+currentAsset.Make__c+'</td></tr>';
                              message+='<tr><td>Asset Model</td><td>'+currentAsset.Model__c+'</td></tr>';
                              message+='<tr><td>Asset Status</td><td>'+currentAsset.Asset_Status__c+'</td></tr>';
                              message+='<tr><td>Purchase Amount</td><td>KSh.'+currentAsset.Asset_Purchase_Price__c+'</td></tr>';
                              message+='</table>';
                             
                              message+='<p>Link to the Asset:https://sanergy.my.salesforce.com/'+currentAsset.id+'</p>';
                              
                              message+='<h5>PREVIOUSLY ISSUED ITEMS ('+assets.size()+')</h5>';
                              message+=assetTable;
                              message+='<p>Regards</p>';
                             
                              EmailSender sender=new EmailSender(email,subject,message);
                             
                                      if(email.size() > 0 ){
                                           sender.sendMessage(true);
                                      }
                               }
                 
                 asset.Asset_Status__c = 'Issued';
                 asset.Employee__c = issuance.Employee__c;
                 
                 update asset;
                 
                 issuance.Asset_Returned__c = false;
                 issuance.Date_Returned__c = null;
                 issuance.Item_Condition_on_Return__c = null;
                 issuance.Item_Condition_on_Return_Comments__c = null;
             }
             
             if(Trigger.isUpdate){
                 //if(issuance.Asset_Returned__c){
                     if(issuance.Item_Condition_on_Return__c == 'Lost'){
                     
                         //get email of Teamlead
                         List<Employee__c> emails=[SELECT name, Line_Manager__r.Work_Email__c,Work_Email__c FROM Employee__c
                                                     WHERE ID=:issuance.Employee__c];
                                                     
                          //get list of other lost assets
                          List<Sanergy_Assets_Issuance__c> lostAssets=[SELECT Asset_ID__r.name, Asset_ID__r.Asset_Name__c, Asset_ID__r.Make__c,Asset_ID__r.Model__c,
                                                                       Asset_ID__r.Asset_Purchase_Price__c,Comments__c
                                                                       FROM Sanergy_Assets_Issuance__c 
                                                                       WHERE Employee__c=:issuance.Employee__c
                                                                       AND Item_Condition_on_Return__c='Lost'
                                                                       AND ID!=:issuance.id];
                           
                           
                           String lostAssetTable='<table border="1" cellpadding="5"><tr><th>Asset ID</th><th>Asset Name</th><th>Make</th><th>Model</th><th>Purchase Price</th><th>Comments</th></tr>';
                           
                           for(Sanergy_Assets_Issuance__c ast :lostAssets){
                               lostAssetTable+='<tr><tr><td>'+ast.Asset_ID__r.name+'</td><td>'+ast.Asset_ID__r.Asset_Name__c+'</td><td>'+ast.Asset_ID__r.Make__c+'</td><td>'+ast.Asset_ID__r.Model__c+'</td><td>KSh. '+ast.Asset_ID__r.Asset_Purchase_Price__c+'</td><td>KSh. '+ast.Comments__c+'</td></tr>';
                           }
                           lostAssetTable+='</table>';
                         if(emails.size()>0){
                          
                              
                              String[] email= new String[]{};
                              String iTL = 'james.nguyo@saner.gy';
                              if(emails.get(0).Line_Manager__r.Work_Email__c!=null){
                                 email.add(emails.get(0).Line_Manager__r.Work_Email__c);
                              }
                               if(emails.get(0).Line_Manager__r.Work_Email__c != null && emails.get(0).Line_Manager__r.Work_Email__c != iTL){
                                 email.add(iTL);
                              }
                              if(emails.get(0).Work_Email__c!=null){
                                  email.add(emails.get(0).Work_Email__c);
                              }
                                                           
                              String subject='Sanergy Asset Loss';
                              String message='<p>Hi.</p><p>An asset assigned to '+emails.get(0).name+' has been flagged as Lost</p>';
                              message+='<h5>DETAILS</h5>';
                              message+='<table border="1" cellpadding="5"><tr><th>Field</th><th>Value</th></tr>';
                              message+='<tr><td>Asset ID</td><td>'+asset.name+'</td></tr>';
                              message+='<tr><td>Asset Name</td><td>'+asset.Asset_Name__c+'</td></tr>';
                              message+='<tr><td>Asset Make</td><td>'+asset.Make__c+'</td></tr>';
                              message+='<tr><td>Asset Model</td><td>'+asset.Model__c+'</td></tr>';
                              message+='<tr><td>Purchase Amount</td><td>KSh.'+asset.Asset_Purchase_Price__c+'</td></tr>';
                              message+='<tr><td>Comments</td><td>KSh.'+issuance.Comments__c+'</td></tr>';
                              message+='</table>';
                              
                              message+='<h5>PREVIOUSLY LOST ITEMS ('+lostAssets.size()+')</h5>';
                              message+=lostAssetTable;
                              
                              EmailSender sender = new EmailSender(email,subject,message);
                              
                              if(email.size() > 0){
                                   sender.sendMessage(true);
                              }
                          }
                          
                         asset.Asset_Status__c = 'Lost';
                         issuance.Asset_Returned__c = false;
                         
                         
                     } else {
                         asset.Asset_Status__c = 'Inventory';
                         asset.Employee__c = null;
                     }
                     update asset;
                 //}
             }
        } else {
            issuance.addError(errorMsg);
        }              
    }

}