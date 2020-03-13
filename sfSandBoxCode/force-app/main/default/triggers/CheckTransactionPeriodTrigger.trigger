trigger CheckTransactionPeriodTrigger on c2g__codaTransaction__c (after insert) {
    
    //disabled due to issues
    /**
    //Create a master list to hold the emails we'll send
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    //step 2.1: get list of people to send email to
    Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll(); 
    
    //holds the transaction name
    String transactId = '';
    
    for(c2g__codaTransaction__c transAct : Trigger.New){
        
        if(transAct.c2g__DocumentNumber__c != null || transAct.c2g__DocumentNumber__c != ''){
            
            //get the first three characters of the document number and check if its cash or not
            //if not cash then trigger continues else skip normal trigger behaviour
            String docValChar = String.valueOf(transAct.c2g__DocumentNumber__c).substring(0,3);
            
            //if transaction is non cash then continue with trigger process
            if( !docValChar.equals('CSH')){
                
                Date todayDate = date.today();
                
                //Query to fetch current period
                c2g__codaPeriod__c period1 = [SELECT NAME FROM c2g__codaPeriod__c 
                                              WHERE c2g__StartDate__c < :todayDate  
                                              AND c2g__EndDate__c >= :todayDate
                                              AND c2g__OwnerCompany__c =: transAct.c2g__OwnerCompany__c
                                             ];
                
                System.debug('period1 ---> ' + period1 );
                
                //query to fetch all periods less than or equal to  current period
                List<c2g__codaPeriod__c> period2 = [SELECT NAME FROM c2g__codaPeriod__c 
                                                    WHERE  c2g__OwnerCompany__c =: transAct.c2g__OwnerCompany__c
                                                    AND Name <= :period1.NAME
                                                    ORDER BY Name Desc
                                                    LIMIT 2 ];
                
                System.debug('period2 ---> ' + period2 );
                
                //check if current month minus entered month is less than or equal to 2
                //send email if true else just save
                
                //System.debug('Second period --> ' + period2.get(1).NAME);
                //get the second record and see if the entered value is greater than the fetched value
                String periodAndYear = period2.get(1).NAME;
                String[] periodYear = periodAndYear.split('\\/');
                
                // to get the month from periodYear Array we select the second item in the array - periodYear[1]
                //query to fetch the name from the periods object because transAct.c2g__Period__r.Name not working
                c2g__codaPeriod__c periodValue = [SELECT NAME 
                                                  FROM c2g__codaPeriod__c 
                                                  WHERE id =: transAct.c2g__Period__c
                                                  LIMIT 1
                                                 ];
                
                //SPLIT periodValue To get period and year
                String PeriodValueName = periodValue.NAME;
                String[] splitPeriodValue = PeriodValueName.split('\\/');
                
                System.debug('entered period --->' + splitPeriodValue[0] + '  >> current period --->' + periodYear[0]);
                
                //check if the entered period year is the same year as current period
                if(Integer.valueOf(splitPeriodValue[0]) == Integer.valueOf(periodYear[0]) ) {
                    // if similar year then check month if is greater than twice curr period 
                    // if yes notify(Via Email)
                    
                    System.debug('entered value month ---> ' + splitPeriodValue[1] +'>>> Current period month ---> ' + periodYear[1] );
                    
                    //check if entered value month is two months less than current period
                    Integer Monthdiff = Integer.valueOf(periodYear[1]) - Integer.valueOf(splitPeriodValue[1]);
                    System.debug('Difference  : ' + Monthdiff);
                    
                    //check if difference is greater than or equal to 1
                    if(Monthdiff > 0 ){
                        // Create email to send 
                        
                        // Step 1: Create a new Email
                        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                        
                        // Step 2: Set list of people who should get the email
                        List<String> sendTo = new List<String>();
                        
                        // get company from user value
                        // sanergy --->  a19D00000026xGa
                        // sanergy,inc(FP) ---> a19D0000004Tbl1
                        // Sanergy, Inc (USFP) -----> a19D00000026xJD
                        // --------------------------------------------------------
                        // Sanergy, Inc (NP) <------ freshlife   ---> a19D0000004vTfL
                        // Sanergy, Inc (USNP) <---- FRESHLIFE  -----> a19D00000026xJz
                        // fresh life ---> a19D00000026xHv
                        String sanerSetting = '';
                        if(transAct.c2g__OwnerCompany__c == 'a19D00000026xGa' || transAct.c2g__OwnerCompany__c == 'a19D0000004Tbl1' || transAct.c2g__OwnerCompany__c == 'a19D00000026xJD' ){
                            sanerSetting = 'SanerPeriodNotificationEmails';
                        }else if(transAct.c2g__OwnerCompany__c == 'a19D00000026xHv' || transAct.c2g__OwnerCompany__c =='a19D00000026xJz' || transAct.c2g__OwnerCompany__c =='a19D0000004vTfL'){
                            sanerSetting = 'FLIPeriodNotificationEmails';
                        }
                        
                        String notificationEmail = String.valueOf(settings.get(sanerSetting).value__c);
                        
                        //list to hold emails to send emails to
                        List<String> allowedEmails = notificationEmail.split(',');
                        
                        //loop through the array to add the emails to send method
                        for(String SendEmails : allowedEmails){
                            sendTo.add(SendEmails);
                        }
                        
                        mail.setToAddresses(sendTo);
                        
                        // Step 3: Set who the email is sent from
                        mail.setReplyTo('helpdesk@saner.gy');
                        mail.setSenderDisplayName('Salesforce Transactions');
                        
                        
                        if(trigger.isAfter){
                            //if trigger is after
                            if(Trigger.isInsert){
                                c2g__codaTransaction__c transactionName = [SELECT ID, NAME FROM c2g__codaTransaction__c
                                                                           ORDER BY NAME DESC LIMIT 1];
                                
                                transactId = transactionName.ID;
                                
                                // Step 4. Set email contents - you can use variables!
                                mail.setSubject('Transaction Period');
                                String body = 'Hi <br/><br/> <a href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+transactId+'">'+transactionName.NAME+'</a> has been posted for the period ' + PeriodValueName + ' on date : ' + date.today() +'<br/><br/>Regards';
                                
                                mail.setHtmlBody(body);
                                
                                // Step 5. Add your email to the master list
                                mails.add(mail);
                                
                                // Step 6: Send all emails in the master list
                                Messaging.sendEmail(mails);
                            }
                        }
                    }
                    
                }else{
                    //if entered period is not same year then send email
                    // Send email function
                    // Step 1: Create a new Email
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    // Step 2: Set list of people who should get the email
                    List<String> sendTo = new List<String>();
                    
                    // get company from user value
                    // sanergy --->  a19D00000026xGa
                    // sanergy,inc(FP) ---> a19D0000004Tbl1
                    // Sanergy, Inc (USFP) -----> a19D00000026xJD
                    // --------------------------------------------------------
                    // Sanergy, Inc (NP) <------ freshlife   ---> a19D0000004vTfL
                    // Sanergy, Inc (USNP) <---- FRESHLIFE  -----> a19D00000026xJz
                    // fresh life ---> a19D00000026xHv
                    String sanerSetting = '';
                    if(transAct.c2g__OwnerCompany__c == 'a19D00000026xGa' || transAct.c2g__OwnerCompany__c == 'a19D0000004Tbl1' || transAct.c2g__OwnerCompany__c == 'a19D00000026xJD' ){
                        sanerSetting = 'SanerPeriodNotificationEmails';
                    }else if(transAct.c2g__OwnerCompany__c == 'a19D00000026xHv' || transAct.c2g__OwnerCompany__c =='a19D00000026xJz' || transAct.c2g__OwnerCompany__c =='a19D0000004vTfL'){
                        sanerSetting = 'FLIPeriodNotificationEmails';
                    }
                    
                    System.debug('sanerSetting >>>>>>> ' +sanerSetting);
                    
                    String notificationEmail = String.valueOf(settings.get(sanerSetting).value__c);
                    
                    System.debug('notificationEmail >>>>>>> ' + notificationEmail);
                    
                    //list to hold emails to send emails to
                    List<String> allowedEmails = notificationEmail.split(',');
                    
                    //loop through the array to add the emails to send method
                    for(String SendEmails : allowedEmails){
                        sendTo.add(SendEmails);
                    }
                    //System.debug(sendTo);
                    mail.setToAddresses(sendTo);
                    
                    // Step 3: Set who the email is sent from
                    mail.setReplyTo('dev@saner.gy');
                    mail.setSenderDisplayName('Salesforce Transactions');
                    
                    
                    if(trigger.isAfter){
                        //if trigger is after
                        if(Trigger.isInsert){
                            c2g__codaTransaction__c transactionName = [SELECT ID,NAME FROM c2g__codaTransaction__c
                                                                       ORDER BY NAME DESC LIMIT 1];
                            
                            transactId = transactionName.ID;
                            
                            // Step 4. Set email contents - you can use variables!
                            mail.setSubject('Transaction Period');
                            String body = 'Hi <br/><br/> <a href="https://'+URL.getSalesforceBaseUrl().getHost()+'/'+transactId+'">'+transactionName.NAME+'</a> has been posted for the period ' + PeriodValueName + ' on date : ' + date.today() +'<br/><br/>Regards<br/>';
                            
                            mail.setHtmlBody(body);
                            
                            // Step 5. Add your email to the master list
                            mails.add(mail);
                            
                            // Step 6: Send all emails in the master list
                            Messaging.sendEmail(mails);
                        }
                    } 
                } 
            }
        }
    } 
**/
}