trigger SendTicketsWhenEmploymentStatusPendingOnboarding on Employee__c (before update) {
    for(Employee__c employee:Trigger.New){
        /*
        //check if SF Account ID that has been applied belongs to another user. Ignore user Profiles with Sys Admin
        //as they might be in use for deployment purposes
        if(employee.Employee_SF_Account__c != '' && employee.Employee_Active__c == TRUE && Trigger.oldMap.get(employee.ID).Employee_SF_Account__c != employee.Employee_SF_Account__c){
            //run only if SF Account ID has been updated and for active employees only
            AggregateResult[] emp = [
                                SELECT Employee_SF_Account__c, MAX(Name) DupEmpName, COUNT(id)
                                FROM Employee__c 
                                WHERE Employee_SF_Account__c =: employee.Employee_SF_Account__c 
                				AND Employee_SF_Account__c <> ''
                				AND Employee_Active__c = TRUE
                                AND id <>: employee.id //do not include the current employee
                                AND Employee_SF_Account__c IN 
                                (
                                    SELECT id 
                                    FROM user 
                                    WHERE  IsActive = TRUE 
                                    AND (NOT profile.name LIKE '%System Administrator%') //Do not include Admins
                                )
                                GROUP BY Employee_SF_Account__c
                                LIMIT 1
                           ];
            if(emp != NULL && emp.size() > 0){
                //a duplicate has been found; throw error
                employee.AddError('The Saleforce User ID has already been assigned to another Employee :[' + emp[0].get('DupEmpName') + ']');
            }
        }
        */
        if(Trigger.oldMap.get(employee.ID).Employment_Status__c != employee.Employment_Status__c && employee.Employment_Status__c == 'Pending Onboarding' && employee.Tickets_Created__c == false){
        
        List<Recruitment_Requisition__c>   requisition = [SELECT Id,Name,Employee_Role__r.Department__r.Name 
                                                          FROM Recruitment_Requisition__c
                                                         WHERE Id =: employee.Recruitment_Requisition__c]; 
        if(requisition.size()> 0 ){
            
        List<Recruitment_Requisition_Line_Item__c> RLine = [SELECT Id,Name,RecordTypeId,Employee__c,Asset_is_Returnable__c,Maximum_amount__c, Status__c,Type__c
                                                           FROM Recruitment_Requisition_Line_Item__c
                                                           WHERE Employee__c =: employee.Id
                                                           AND RecordTypeId != '0120E0000004MfaQAE'];
                    
        for(Recruitment_Requisition_Line_Item__c line:RLine){
            
            System.debug('DDDDDDDDDDDD'+line.Id+''+line.name);
        	String [] address=new String[]{'helpdesk@saner.gy'};
        	//String [] address=new String[]{'abel.wafula@saner.gy','vkhaoya@saner.gy'};
        	String subject = line.Type__c +' Request';
        	String body='<p>Hi Helpdesk, </p><p>'+StringUtils.ignoreNull(employee.Name)+' is joining sanergy on '+employee.Employment_Start_Date__c+' in '+requisition.get(0).Employee_Role__r.Department__r.Name+' department with refference to Recruitment Request: '+requisition.get(0).Name+'. </p><p>'+line.Type__c+' is therefore required for the above Employee. </p><p>RR Link: <br>https://sanergy.my.salesforce.com/'+requisition.get(0).Id+'</p>';
                            
        	//send the email
        	EmailSender email=new EmailSender(address,subject,body);
        	email.sendMessage(true); 

			employee.Tickets_Created__c = true;  
        }            
        
        }
            List<Recruitment_Request_Config__c> ConfigLine = [SELECT Id,Scheduled__c,Done__c,Schedule_Date__c,Name,Employee_Role__c,RecordTypeId, Type__c
                                                           FROM Recruitment_Request_Config__c
                                                           WHERE Employee_Role__c =: employee.Employee_Role__c
                                                           AND RecordTypeId = '0120E0000004MfaQAE'];
                    
        for(Recruitment_Request_Config__c line:ConfigLine){
            
            System.debug('DDDDDDDDDDDD'+line.Id+''+line.name);
        	On_Offboarding_Checklist__c onboarding = new On_Offboarding_Checklist__c();
            onboarding.Employee__c = employee.Id;
            onboarding.Task_Name__c = line.Name;
            onboarding.Scheduled__c = line.Scheduled__c;
            onboarding.Schedule_Date__c = line.Schedule_Date__c;
            onboarding.Done__c = line.Done__c;
            insert onboarding;
        }
            
        }
    }
}