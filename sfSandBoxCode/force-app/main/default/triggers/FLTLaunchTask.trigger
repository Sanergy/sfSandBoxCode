trigger FLTLaunchTask on Task (before update, after update) {
    
    //Format Date
    date launchDate = date.today();
    String fltLaunchDate = launchDate.format();
    
    //Get details of current logged in user
    String userId = UserInfo.getUserId();    
    String userName = UserInfo.getName();   
    
    List<Task> taskList = new List<Task>();
    
    //Get FLT Launch RecordType
    RecordType fltLaunchRecordType = [SELECT Id,Name 
                                      FROM RecordType 
                                      WHERE Name ='FLT Launches' 
                                      LIMIT 1];
    
    for(Task currentTask: Trigger.new){
        
        //Execute if RecordType = FLT Launches
        if(currentTask.RecordTypeId == fltLaunchRecordType.Id){
            
            //Execute Before Update Trigger
            if (Trigger.isBefore && Trigger.isUpdate){
                
                //Update Current Task
                if(currentTask.Follow_Up__c == 'No' || currentTask.Follow_Up__c == 'Yes'){
                    currentTask.Status = 'Completed';
                }// End if(currentTask.Follow_Up__c == 'No' || currentTask.Follow_Up__c == 'Yes')
                
                //Update Current Task
                if(currentTask.Follow_Up__c == 'No' && currentTask.Task_Source__c == 'Sales Associate'){
                    currentTask.Outcomes__c = 'Sucessfully launched ' + currentTask.Related_To_Text__c;
                    currentTask.Description = currentTask.Related_To_Text__c + ' was launched by ' + userName + ' on ' + fltLaunchDate;                    
                }
                
            }else if (Trigger.isAfter && Trigger.isUpdate){                
                        
                String siteURL = 'https://sanergy.my.salesforce.com/';
                
                // A list to hold the emails we'll send
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                
                //Get the Team that Launches Toilets
                List<User> fltLaunchTeam = [SELECT Id, Name, Email, IsActive, Profile.Name, UserRole.Name, UserType
                                            FROM User 
                                            WHERE Id in 
                                            (SELECT userorgroupid FROM groupmember where group.name = 'FLT Launching Team')]; 
                
                
                //Execute if Sales Associate says 'NO' follow-up is required
                if(currentTask.Follow_Up__c == 'No' && currentTask.Task_Source__c == 'Visualforce Page'){
                    
                    //Loop through all the members that are suppossed to launch FLTs
                    for(User member: fltLaunchTeam){
                        
                        //Create a new Task for each member
                        Task newTask = new Task();
                        newTask.RecordTypeId = currentTask.RecordTypeId;//'0127E000000fQrAQAU';//FLT Launches                       
                        newTask.OwnerId = member.Id;//Task assigned to FLT launch team
                        newTask.Subject = currentTask.Subject;
                        newTask.Goals__c = currentTask.Goals__c;
                        newTask.Outcomes__c = currentTask.Outcomes__c;
                        newTask.WhatId = currentTask.WhatId;
                        newTask.Related_To_Text__c = currentTask.Related_To_Text__c;
                        newTask.Opportunity__c = currentTask.Opportunity__c;
                        newTask.ActivityDate = date.today(); //Due Date
                        newTask.Description = currentTask.Description;//Comments
                        //newTask.Follow_Up__c = currentTask.Follow_Up__c;
                        //newTask.Follow_Up_Date__c = currentTask.Follow_Up_Date__c;
                        newTask.Follow_Up_Comments__c = currentTask.Follow_Up_Comments__c;
                        newTask.Handover_Checklist_Photo_URL__c = currentTask.Handover_Checklist_Photo_URL__c;
                        newTask.Status  = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Task_Source__c = 'Sales Associate';
                        INSERT newTask;
                        
                        System.debug('Create Task 1 ' + newTask);
                        
                        // Create an instance of the Messaging.SingleEmailMessage class.
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        //Add the email
                        String[] toAddresses = new String[] {member.Email};
                            
                        //Create the Structure of Email
                        mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Sanergy - Salesforce');
                        mail.setSubject(newTask.Subject);           		   
                        mail.setHtmlBody
                            ('<p>Hi ' + member.Name + ',</p>' +
                             '<p><em><strong>' + newTask.Related_To_Text__c + ' </strong></em> is <strong><em> Pending Launch</strong></em>.</p>' +
                             '<p>Click on this link and complete the task: ' + siteURL + newTask.id + ' </p>');
                        
                        mails.add(mail);
                        
                        //Send email
                        Messaging.sendEmail(mails); 
                        
                    }//End for(User member: fltLaunchTeam)                    
                    
                }//End if(currentTask.Follow_Up__c == 'No' && currentTask.Status=='Not Started' && currentTask.Task_Source__c=='Visualforce Page')
                
                //Execute if Christell/Florence/Polycarp says 'NO' follow-up is required
                if(currentTask.Follow_Up__c == 'No' && currentTask.Task_Source__c == 'Sales Associate'){
                    
                    //Get FLT to Launch
                    Toilet__c fltToLaunch = [SELECT Id,Name,Location__c,Opportunity__c,Operational_Status__c,
                                             Collection_Route__c,Current_Specific_Status__c,Opportunity__r.Name,
                                             Location__r.Name,Opening_Date__c,Opportunity__r.StageName
                                             FROM Toilet__c
                                             WHERE Id =: currentTask.WhatId
                                             AND Opportunity__c =: currentTask.Opportunity__c
                                             LIMIT 1]; 				
                    
                    //Launch Toilet
                    fltToLaunch.Opening_Date__c = launchDate;
                    fltToLaunch.Operational_Status__c = 'Open';
                    fltToLaunch.Current_Specific_Status__c = 'Open - New';
                    UPDATE fltToLaunch;
                    
                    //Loop through all the members that are suppossed to launch FLTs
                    for(User member: fltLaunchTeam){
                        
                        // Create an instance of the Messaging.SingleEmailMessage class.
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        //Add the email
                        String[] toAddresses = new String[] {member.Email};
                            
                        //Create the Email Structure
                        mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Sanergy - Salesforce');
                        mail.setSubject('Launched ' + fltToLaunch.Name);           		   
                        mail.setHtmlBody
                            ('<p>Hi ' + member.Name + ',</p>' +
                             '<p><em><strong>' + fltToLaunch.Name + ' </strong></em> was successfully launched by <strong><em>' + 
                             userName + '</strong></em> on <em><strong>' + fltLaunchDate + '</strong></em></p>' +
                            '<p>Click on this link to view the toilet: ' + siteURL + fltToLaunch.id + ' </p>');
                        
                        mails.add(mail);
                        
                        //Send email
                        Messaging.sendEmail(mails); 
                        
                    }//End for(User member: fltLaunchTeam)                    
                    
                    //Get Tasks similar to the one that has been completed
                    List<Task> similarTasks = [SELECT Id,Subject,WhatId
                                               FROM Task
                                               WHERE Follow_Up__c = ''//No
                                               AND Status = 'Not Started'
                                               AND Task_Source__c = 'Sales Associate'
                                               AND WhatId =: currentTask.WhatId
                                               AND Opportunity__c =: currentTask.Opportunity__c
                                               AND Subject =: currentTask.Subject
                                               AND Id !=: currentTask.Id];
                    
                    //Loop through the tasks
                    for(Task t: similarTasks){
                        t.Status = 'Completed';
                        t.Outcomes__c = 'Sucessfully launched ' + currentTask.Related_To_Text__c;
                        t.Description = currentTask.Related_To_Text__c + ' was launched by ' + userName + ' on ' + fltLaunchDate;
                        taskList.add(t);
                    }
                    //UPDATE Tasks
                    UPDATE taskList;
                }//End if(currentTask.Follow_Up__c == 'No' && currentTask.Status=='Completed' && currentTask.Task_Source__c=='Sales Associate')            
                
                //Execute if Sales Associate says 'YES' a follow-up is required
                if(currentTask.Follow_Up__c == 'Yes' && currentTask.Task_Source__c=='Visualforce Page'){ 
                    
                    //Loop through all the members that are suppossed to launch FLTs
                    for(User member: fltLaunchTeam){
                        
                        //Create a new Task for each member
                        Task newTask = new Task();
                        newTask.RecordTypeId = currentTask.RecordTypeId;//'0127E000000fQrAQAU';//FLT Launches                       
                        newTask.OwnerId = member.Id;//Task assigned to FLT launch team
                        newTask.Subject = currentTask.Subject;
                        newTask.Goals__c = currentTask.Goals__c;
                        newTask.Outcomes__c = currentTask.Outcomes__c;
                        newTask.WhatId = currentTask.WhatId;
                        newTask.Related_To_Text__c = currentTask.Related_To_Text__c;
                        newTask.Opportunity__c = currentTask.Opportunity__c;
                        newTask.ActivityDate = date.today(); //Due Date
                        newTask.Description = currentTask.Description;//Comments
                        //newTask.Follow_Up__c = currentTask.Follow_Up__c;
                        //newTask.Follow_Up_Date__c = currentTask.Follow_Up_Date__c;
                        newTask.Follow_Up_Comments__c = currentTask.Follow_Up_Comments__c;
                        newTask.Handover_Checklist_Photo_URL__c = currentTask.Handover_Checklist_Photo_URL__c;
                        newTask.Status  = 'Not Started';
                        newTask.Priority = 'Normal';
                        newTask.Task_Source__c = 'Sales Associate';
                        INSERT newTask;
                        
                        System.debug('Create Task 2 ' + newTask);
                        
                        // Create an instance of the Messaging.SingleEmailMessage class.
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        //Add the email
                        String[] toAddresses = new String[] {member.Email};
                            
                        //Create the Email Structure
                        mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Sanergy - Salesforce');
                        mail.setSubject(newTask.Subject);           		   
                        mail.setHtmlBody
                            ('<p>Hi ' + member.Name + ',</p>' +
                             '<p><em><strong>' + newTask.Related_To_Text__c + ' </strong></em> is <strong><em> Pending Launch</strong></em>.</p>' + 
                             '<p>Click on this link and complete the task: ' + siteURL + newTask.id + ' </p>');
                        
                        mails.add(mail);
                        
                        //Send email
                        Messaging.sendEmail(mails); 
                                             
                    }//End for(User member: fltLaunchTeam)
                    
                }//End if(currentTask.Follow_Up__c == 'Yes' && currentTask.Status=='Not Started' && currentTask.Task_Source__c=='Visualforce Page')                
                
            }// End if (Trigger.isBefore && Trigger.isUpdate)         
            
        } // End if(currentTask.RecordTypeId == fltLaunchRecordType.Id)
    }     
    
}