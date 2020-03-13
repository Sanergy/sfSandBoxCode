trigger ValidateToiletSaleOpportunity on Opportunity (before update, before insert, after insert) {
  
    Integer counter=0;
    for(Opportunity opp:Trigger.new){
    
   
      /*RecordType RecordTypeName=[SELECT Name
                       FROM RecordType
                       WHERE ID=:opp.RecordTypeId];*/
           
      //String recordName= recordTypeMap.get(opp.recordTypeId); 
      
      Map<String, String> recordTypeMap=new Map<String, String>();
      recordTypeMap.put('012D0000000K1bvIAC','Toilet Sale - Prospect Management');
      recordTypeMap.put('012D0000000KE82IAG','Toilet Sale - Application Management'); 
      recordTypeMap.put('012D0000000KE85IAG','Toilet Sale - Deposit Management'); 
      recordTypeMap.put('012D0000000K1c5IAC','Toilet Sale - Launch Management');  
     
                  
     //Lock this implementation to only toilet-sale record_types
    if(opp.recordTypeId!=null && recordTypeMap.get(opp.recordTypeId)!=null){
                
       if(Trigger.isUpdate){
               //Create history record when account is changed
              if(opp.AccountId!=Trigger.oldMap.get(opp.ID).AccountId){
                   
                   
                   List<Account> newAccount=[SELECT Name
                                             FROM Account
                                             WHERE ID=:opp.AccountId];
                   List<Account> oldAccount=[SELECT Name
                                             FROM Account
                                             WHERE ID=:Trigger.oldMap.get(opp.ID).AccountId];
                 CreateOpportunityHistoryRecords.createRecord(opp.ID,recordTypeMap.get(opp.recordTypeId), 'Account changed from '+oldAccount.get(0).Name+' to '+newAccount.get(0).Name);
              }
              
                 //Create history record when GR Checklist signed
              if(opp.GR_Checklist_signed_by_AGRO__c!=Trigger.oldMap.get(opp.ID).GR_Checklist_signed_by_AGRO__c && opp.GR_Checklist_signed_by_AGRO__c==true){
                   
                 CreateOpportunityHistoryRecords.createRecord(opp.ID,recordTypeMap.get(opp.recordTypeId), 'GR Checklist signed.');
              }
              
                  //Create history record when Pre-app Submitted and Signed
              if(opp.Pre_app_Submitted_and_Signed__c!=Trigger.oldMap.get(opp.ID).Pre_app_Submitted_and_Signed__c && opp.Pre_app_Submitted_and_Signed__c==true){
                   
                 CreateOpportunityHistoryRecords.createRecord(opp.ID,recordTypeMap.get(opp.recordTypeId), 'Pre-app Submitted and Signed.');
              }
              
                 //Create history record when deposit is paid
              if(opp.CM_Deposit__c!=Trigger.oldMap.get(opp.ID).CM_Deposit__c && opp.CM_Deposit__c==true){
                   
                 CreateOpportunityHistoryRecords.createRecord(opp.ID,recordTypeMap.get(opp.recordTypeId), 'Deposit Paid.');
              }
              
              
              
               //Insert record history when franchise type changes
              if(opp.Franchise_Type__c!=null && opp.Franchise_Type__c!=Trigger.oldMap.get(opp.ID).Franchise_Type__c){  
                    String name=null;
                    
                    //if franchise type changes to Commercial
                    if(opp.Franchise_Type__c.equals('Commercial') || opp.Franchise_Type__c.equals('Institution')){
                         name='COMMERCIAL FLT';
                     }
                     
                     
                     //if franchise type changes to School
                     else if(opp.Franchise_Type__c.equals('School')){
                         name='SCHOOL FLT'; 
                     }
                     
                     //if franchise type changes to Residential
                     else if(opp.Franchise_Type__c.equals('Residential') || opp.Franchise_Type__c.equals('Institution')){
                         name='RESIDENTIAL FLT';
                     }
                     
                     if(name!=null){
                        List<Pricebook2> pricebook=[SELECT ID
                                                     FROM Pricebook2
                                                     WHERE Name=:name
                                                     LIMIT 1];
                         if(pricebook.size()>0){
                         
                             //set the pricebook
                             opp.Pricebook2Id=pricebook.get(0).ID;
                             
                         }
                     }
                  
            
                //insert History Record
               CreateOpportunityHistoryRecords.createRecord(opp.ID, recordTypeMap.get(opp.recordTypeId),'Franchise Type changed to '+opp.Franchise_Type__c);
              }
              
                 //Create history record when deposit is paid
              if(opp.Primary_Salesperson__c!=Trigger.oldMap.get(opp.ID).Primary_Salesperson__c && opp.Primary_Salesperson__c!=null){
                 List<Opportunity_Promary_salesperson__c> opsList=[SELECT End_Date__c,Current_Salesperson__c 
                                                               FROM Opportunity_Promary_salesperson__c
                                                               WHERE Opportunity__c=:opp.id
                                                               AND Current_Salesperson__c=true] ;
                 
                 for(Opportunity_Promary_salesperson__c ops:opsList){
                     ops.Current_Salesperson__c = false;
                     ops.End_Date__c=Date.today();
                 }
                 
                 Opportunity_Promary_salesperson__c opsNew=new Opportunity_Promary_salesperson__c(
                     Opportunity__c=opp.id,
                     Primary_Salesperson__c=opp.Primary_Salesperson__c,
                     Start_Date__c=Date.today(),
                     Current_Salesperson__c=true
                 );
                 
                 insert opsNew;
                 update opsList;
              }
              
          
    
    
    /*------------------------------------------DEPOSIT MANAGEMENT-----------------------------------------------------*/   
    
              //Insert record history when financing method changes
              if(opp.Financing_Method__c!=Trigger.oldMap.get(opp.ID).Financing_Method__c){
                  CreateOpportunityHistoryRecords.createRecord(opp.ID, recordTypeMap.get(opp.recordTypeId),'Financing Method changed to '+opp.Financing_Method__c);
              } 
              
          
     
      /*------------------------------------------LAUNCH MANAGEMENT-----------------------------------------------------*/   
    
              //Update Opportunity Products when opportunity location is set
              if(opp.Location__c!=Trigger.oldMap.get(opp.ID).Location__c){
                  List<OpportunityLineItem> oliList=[SELECT Location__c
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId=:opp.id];
                                                     
                 if(oliList.size()>0){
                     for(OpportunityLineItem oli:oliList){
                         oli.Location__c =opp.Location__c;
                     }
                     update oliList;
                 }  
                 
                 if(opp.Location__c!=null){
                     Location__c loc=[SELECT GPS_Latitude__c, GPS_Longitude__c FROM Location__c WHERE ID=:opp.Location__c];
                 
                     //update GPS co-ordinates on Location
                     if(loc.GPS_Latitude__c==null){
                        loc.GPS_Latitude__c=opp.GPS_Latitude__c;
                     }
                     
                     if(loc.GPS_Longitude__c==null){
                        loc.GPS_Longitude__c=opp.GPS_Longitude__c;
                     }  
                     
                     update loc; 
                 }                                  
              } 
              
              if((Trigger.oldMap.get(opp.id).GPS_Longitude__c != opp.GPS_Longitude__c)
               || (Trigger.oldMap.get(opp.id).GPS_Latitude__c != opp.GPS_Latitude__c)){
                  if(opp.Location__c!=null){
                     Location__c loc=[SELECT GPS_Latitude__c, GPS_Longitude__c FROM Location__c WHERE ID=:opp.Location__c];
                 
                     //update GPS co-ordinates on Location                     
                     loc.GPS_Latitude__c=opp.GPS_Latitude__c;
                     loc.GPS_Longitude__c=opp.GPS_Longitude__c;
                     
                     update loc; 
                 }  
              }
              
              //create history records for approvals
              if(opp.Marketing_Items_Approved__c==true && Trigger.oldMap.get(opp.id).Marketing_Items_Approved__c!=opp.Marketing_Items_Approved__c){
                   CreateOpportunityHistoryRecords.createRecord(opp.ID, recordTypeMap.get(opp.recordTypeId),'Painting Items Approved');
              }
              
              if(opp.Engineering_Items_Approved__c==true && Trigger.oldMap.get(opp.id).Engineering_Items_Approved__c!=opp.Engineering_Items_Approved__c){
                   CreateOpportunityHistoryRecords.createRecord(opp.ID, recordTypeMap.get(opp.recordTypeId),'Engineering Items Approved');
              }
              
              if(opp.BIB_Items_Approved__c==true && Trigger.oldMap.get(opp.id).BIB_Items_Approved__c!=opp.BIB_Items_Approved__c){
                   CreateOpportunityHistoryRecords.createRecord(opp.ID, recordTypeMap.get(opp.recordTypeId),'BiB Items Approved');
              
              }
    
    
    /*------------------------------------------CHANGE OF STAGES-----------------------------------------------------*/    
          
          //if the stage changes
          if(opp.StageName!=Trigger.oldMap.get(opp.ID).StageName){
          
          
             //If stage changes to 'FLO Launched'
           if(opp.StageName.equals('FLO Launched')){
               
               //ensure that each toilet product has a location
               List<OpportunityLineItem> OLI=[SELECT Location__c FROM OpportunityLineItem WHERE OpportunityId=:opp.ID AND is_a_toilet__c=true];
               
               boolean toiletsNotAdded=false;
               for(OpportunityLineItem oli_records:OLI){
                   if(oli_records.Location__c==null){
                      toiletsNotAdded=true;
                   }
               }
               
               if(toiletsNotAdded==true){
                   opp.addError('Select a location for all Toilet products');
               }
            } 
            
            
           //Create History Records
           CreateOpportunityHistoryRecords.createRecord(opp.ID, recordTypeMap.get(opp.recordTypeId), 'Opportunity stage changed to  '+opp.StageName);
          }
          
          }
         
         else if (Trigger.isInsert){
             /*
              //Notify CM of Creation of opportunity
              List<User> notifiedUsers=[SELECT Name, Email FROM User WHERE UserRoleId IN (SELECT ID FROM UserRole WHERE Name IN('Credit Manager','Government Relations Officer','Government Relations Manager'))];
              String subject='New toilet-sale Opportunity '+opp.Name+' created';
              
              for(User cm:notifiedUsers){
                   //String [] toAddesses=new String[]{'brian.onyando@saner.gy'};  
                  String [] toAddesses=new String[]{cm.Email};  
                  String HTMLMessage='<p>Hello '+cm.Name+'</p><p>A new Toilet Sale Opportunity <a href='https://sanergy.my.salesforce.com/'+opp.ID+''>'+opp.Name+'</a> has been created</p>';
                 
                  EmailSender email=new EmailSender(toAddesses,subject,HTMLMessage);
                  email.sendMessage(true);  
              }
              
              */
            if(Trigger.isBefore ){
                       //set pricebook if franchise type is set
                  if(opp.Franchise_Type__c!=null){  
                     
                    String name=null;
                    
                    //if franchise type changes to Commercial
                    if(opp.Franchise_Type__c.equals('Commercial') || opp.Franchise_Type__c.equals('Institution')){
                         name='COMMERCIAL FLT';
                     }
                     
                     
                     //if franchise type changes to School
                     else if(opp.Franchise_Type__c.equals('School')){
                         name='SCHOOL FLT'; 
                     }
                     
                     //if franchise type changes to Residential
                     else if(opp.Franchise_Type__c.equals('Residential')){
                         name='RESIDENTIAL FLT';
                     }
                     
                     if(name!=null){
                        List<Pricebook2> pricebook=[SELECT ID
                                                     FROM Pricebook2
                                                     WHERE Name=:name
                                                     LIMIT 1];
                         if(pricebook.size()>0){
                         
                             //set the pricebook
                             opp.Pricebook2Id=pricebook.get(0).ID;
                             
                         }
                     }
                     
                  }
            }
            else if(Trigger.isAfter){
                 //create primary salesperson record
               if(opp.Primary_Salesperson__c!=null){
                    Opportunity_Promary_salesperson__c opsNew=new Opportunity_Promary_salesperson__c(
                         Opportunity__c=opp.id,
                         Primary_Salesperson__c=opp.Primary_Salesperson__c,
                         Start_Date__c=Date.today(),
                         Current_Salesperson__c=true
                     );
                     
                      insert opsNew;
               }
            }     
         }
     }

   }
}
/*------------------------------------------END OF TRIGGER-----------------------------------------------------*/