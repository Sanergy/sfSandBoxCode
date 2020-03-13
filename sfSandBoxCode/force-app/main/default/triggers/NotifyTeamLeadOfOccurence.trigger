trigger NotifyTeamLeadOfOccurence on Occurrence__c (before insert, before update) {
    for(Occurrence__c oc:Trigger.new){
    //update Department and related user fields only on updates or inserts
        if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)){
            
            
            //if status is Employee
            if(oc.Nature_of_Person__c == 'Employee'){
                List<Employee__c> InjEmp = [SELECT id, Employee_Active__c,Termination_Date__c,Employment_Status__c,Employee_Role__c,
                                            Line_Manager_SF_Account__c,Team_Lead_SF_Account__c,Job_Title__c,Talent_Partner_SF_Account__c,
                                            Company_Division__c ,Department_Unit__c,Department__c,Line_Manager__c,
                                            Sanergy_Department__c,Sanergy_Department_Unit__c,End_Date__c
                                            FROM Employee__c 
                                            WHERE Id =: oc.Injured_Employee__c 
                                            LIMIT 1
                                           ];
                if(InjEmp.size()==1){
                    //Update TL/TP 
                    oc.Sanergy_Department_Unit__c = InjEmp.get(0).Department_Unit__c;
                    oc.Sanergy_Department__c = InjEmp.get(0).Sanergy_Department__c;
                    oc.Team_Lead_SF_Account__c = InjEmp.get(0).Team_Lead_SF_Account__c;
                    oc.Line_Manager_SF_Account__c = InjEmp.get(0).Line_Manager_SF_Account__c;
                    oc.Talent_Partner_SF_Account__c = InjEmp.get(0).Talent_Partner_SF_Account__c;
                    
                    if(InjEmp.get(0).Company_Division__c == 'Sanergy'){
                        oc.QHSE__c = '005D0000008jBA0IAM';//QHSE - Eunice
                        oc.Director__c = '005D0000002QVPcIAO';//Director - Michael
                    } else if (InjEmp.get(0).Company_Division__c == 'Fresh Life'){
                        oc.QHSE__c = '005D0000008jYDqIAM';//QHSE - Kandie
                        oc.Director__c = '005D0000008jesVIAQ';//Director - Titus
                    }
                    
                } 
            } else if (oc.Nature_of_Person__c == 'Casual' || oc.Nature_of_Person__c == 'Visitor' ){
                //else if casual/visitor if status not Employee - require Dept Unit and then set Dept, TL, DIR, QHSE, TP
                List<Sanergy_Department_Unit__c> ocDept = [SELECT id, Sanergy_Department__c, Sanergy_Department__r.Company__c,
                                            Line_Manager_SF_Account__c,Team_Lead_SF_Account__c,Talent_Partner__c
                                            FROM Sanergy_Department_Unit__c 
                                            WHERE Id =: oc.Sanergy_Department_Unit__c 
                                            LIMIT 1
                                           ];
                 if(ocDept.size()==1){
                    //Update TL/TP 
                    oc.Sanergy_Department__c = ocDept.get(0).Sanergy_Department__c;
                    oc.Team_Lead_SF_Account__c = ocDept.get(0).Team_Lead_SF_Account__c;
                    oc.Line_Manager_SF_Account__c = ocDept.get(0).Line_Manager_SF_Account__c;
                    oc.Talent_Partner_SF_Account__c = ocDept.get(0).Talent_Partner__c;
                    
                    if(ocDept.get(0).Sanergy_Department__r.Company__c == 'Sanergy'){
                        oc.QHSE__c = '005D0000008jBA0IAM';//QHSE - Eunice
                        oc.Director__c = '005D0000002QVPcIAO';//Director - Michael
                    } else if (ocDept.get(0).Sanergy_Department__r.Company__c == 'Fresh Life'){
                        oc.QHSE__c = '005D0000008jYDqIAM';//QHSE - Kandie
                        oc.Director__c = '005D0000008jesVIAQ';//Director - Titus
                    }
                    
                } 
            }
            else {
                //reset fields
                oc.Sanergy_Department_Unit__c = NULL;
                oc.Sanergy_Department__c = NULL;
                oc.Sanergy_Department_Unit__c = NULL;
                oc.Team_Lead_SF_Account__c = NULL;
                oc.Line_Manager_SF_Account__c = NULL;
                oc.Talent_Partner_SF_Account__c = NULL;
                oc.Director__c = NULL;
            }
        }    
       
        
    /*
        if(oc.Status__c!=null && Trigger.oldMap.get(oc.id).Status__c!=null && 
        oc.Status__c!=Trigger.oldMap.get(oc.id).Status__c
        && oc.Status__c=='EHS Review'){
        //get the department
        List<Sanergy_Department__c> sd=[SELECT Team_Lead__c
        FROM Sanergy_Department__c
        WHERE ID=:oc.Sanergy_Department__c];
        
        if(sd.size()>0){
        //get the email address
        List<Employee__c> emp=[SELECT Work_Email__c
        FROM Employee__c
        WHERE ID=:sd.get(0).Team_Lead__c];
        
        if(emp.size()>0 && emp.get(0).Work_Email__c!=null){
        //get the recordType Name
        RecordType recType=[SELECT Name 
        FROM RecordType
        WHERE ID=:oc.RecordTypeId];
        
        //get name of employee
        List<Employee__c> empInjured=[SELECT Name FROM Employee__c WHERE ID=:oc.Injured_Employee__c];
        
        String [] address=new String[]{emp.get(0).Work_Email__c};
        String subject= StringUtils.ignoreNull(oc.Type_of_Accident__c)+''+StringUtils.ignoreNull(oc.Type_of_incident__c)+' at '+StringUtils.ignoreNull(oc.Actual_Location__c);
        String body='<p>Hi,</p><p>This is to notify you that an '+StringUtils.ignoreNull(recType.Name)+' occurred at '+StringUtils.ignoreNull(oc.Actual_Location__c)+' on '+oc.Occurrence_Date__c+'</p><p>Type of '+StringUtils.ignoreNull(recType.Name)+': '+StringUtils.ignoreNull(oc.Type_of_Accident__c)+''+StringUtils.ignoreNull(oc.Type_of_incident__c)+' <br>Name of person involved: '+StringUtils.ignoreNull(empInjured.get(0).Name)+''+StringUtils.ignoreNull(oc.Visitor_s_Name__c)+' <br>Description: '+StringUtils.ignoreNull(oc.Full_Description__c)+'<br>Immediate action taken: '+StringUtils.ignoreNull(oc.Immediate_action_taken__c)+' </p><p>Click on the link below to access the full details <br>https://sanergy.my.salesforce.com/'+oc.id+'</p>';
        
        
        //send the email
        EmailSender email=new EmailSender(address,subject,body);
        email.sendMessage(true);
        
        }
        }  
        
        }       
        */
   }
}