trigger LocationDemolition on Location_Demolition__c (before update) {
    
    for(Location_Demolition__c LD: Trigger.new){
         
         //ensure that if 'firm toilet' field is checked, there has to exist atleast one toilet                          
         if(LD.Firm_Toilets__c==true && LD.No_of_Toilets__c<1){
             LD.addError('Record cannot be saved if "Firm Toilets" field is checked and no Location Demolition Toilet has been added');
         }
         if(Trigger.isUpdate){
            //when stage changes
            if(LD.Stage__c!=Trigger.oldMap.get(LD.ID).Stage__c ){
                if(LD.Stage__c==null){}
                else{
                    //create history record
                    CreateLocationDemolitionHistoryRecords.createRecord('Stage changed to '+LD.Stage__c,LD.Stage__c,LD.ID);
                    //Validation when stage changes to closed
                    if(LD.Stage__c.equals('Closed')){
                        List<Location_Demolition_Toilets__c> LDT=[SELECT Toilet_Status__c
                                                                  FROM Location_Demolition_Toilets__c
                                                                  WHERE Location_Demolition__c=:LD.ID];
                        boolean toiletOk=false;
                        Integer countFalse=0;
                        //loop through location toilets and find a toilet with a pending status
                         for(Location_Demolition_Toilets__c ldt_record:LDT){
                             if(ldt_record.Toilet_Status__c==null){
                                 toiletOk=true;
                                 countFalse++;
                             }
                         }
                         if(toiletOk==true){
                             if(countFalse==1){
                                 LD.addError('Cannot change stage to closed: '+countFalse+' toilet has a pending status' );
                             }
                             else{
                                 LD.addError('Cannot change stage to closed: '+countFalse+' toilets have pending statuses' );
                             }   
                         }
                    }
                }
            } 
            //when toilet is firmed, send emails
            if(LD.Firm_Toilets__c!=Trigger.oldMap.get(LD.ID).Firm_Toilets__c && LD.Firm_Toilets__c==true){
                //create History Record
                CreateLocationDemolitionHistoryRecords.createRecord('Toilet addition has been firmed',LD.Stage__c,LD.ID);  
                //send emails to notify location team
                List<Location_Team__c> LT=[SELECT Team_Member__c
                                           FROM Location_Team__c
                                           WHERE Location__c=:LD.Demolished_Location__c];
                Location__c loc=[ SELECT Name
                                  FROM Location__c
                                  WHERE ID=:LD.Demolished_Location__c];
               if(LT.size()>0){
                   //Email parameters
                   String subject='New location demolition created';
                   String[] teamToEmail=new String[LT.size()]; 
                   String url='https://sanergy--ffa.cs8.my.salesforce.com/'+LD.ID;
                   String message='A new location demolition has been raised in Location '+loc.Name+'.\nView on <a href="'+url+'">Salesforce</a>';
                   //get the location team for each location
                   for(Integer i=0; i<LT.size(); i++){
                       List<User> user=[SELECT username
                                        FROM User
                                        WHERE ID=:LT.get(i).Team_Member__c];
   
                      if(user.size()>0){
                          teamToEmail[i]=user.get(0).username;                      
                      }
                   }
                  // String [] testSender=new String[]{'brian.onyando@saner.gy'};
                   EmailSender sender=new EmailSender(teamToEmail,subject,message);
                   sender.sendMessage(true);
               } 
            } 
        }// end of Update
    }   
}