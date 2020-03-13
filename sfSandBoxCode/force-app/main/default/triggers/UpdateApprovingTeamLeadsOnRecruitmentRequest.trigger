trigger UpdateApprovingTeamLeadsOnRecruitmentRequest on Recruitment_Requisition__c (before insert,before update) {
    for(Recruitment_Requisition__c request: Trigger.New){
        //Only if Role has changed or during INSERT
        if(trigger.isInsert || Trigger.oldMap.get(request.id).Employee_Role__c != request.Employee_Role__c ){
            List<Employee_Role__c> req = 
                [
                    SELECT Name, Sanergy_Department_Unit__c, 
                    Sanergy_Department_Unit__r.Name,
                    Team_Lead_SF_Account__c, Talent_Partner_SF_Account__c, Line_Manager__c,
                    Sanergy_Department_Unit__r.Sanergy_Department__c,
                    Sanergy_Department_Unit__r.Sanergy_Department__r.Name,
                    Sanergy_Department_Unit__r.Sanergy_Department__r.Company__c
                    FROM Employee_Role__c
                    WHERE Id =: request.Employee_Role__c
                    LIMIT 1
                ];
            
            if(req != NULL && req.size() ==1){
                request.Talent_Partner__c = req.get(0).Talent_Partner_SF_Account__c; 
                request.Line_Manager__c = req.get(0).Line_Manager__c;
                //request.Requesting_Department__c = req.get(0).Sanergy_Department_Unit__r.Sanergy_Department__c; 
                request.Requesting_Department_Team_Lead__c = req.get(0).Team_Lead_SF_Account__c; 
                request.Stage__c = 'New';
                
                //update Director
                Map<String, Sanergy_Settings__c> settings=Sanergy_Settings__c.getAll();        
                if (req.get(0).Sanergy_Department_Unit__r.Sanergy_Department__r.Company__c == 'Sanergy'){
                    request.Approving_Director__c = String.valueOf(settings.get('Director-SLK').value__c);
                } else if (req.get(0).Sanergy_Department_Unit__r.Sanergy_Department__r.Company__c == 'Fresh Life'){
                    request.Approving_Director__c = String.valueOf(settings.get('Director-FLI').value__c);
                }else {
                    //Default to Ani
                    request.Approving_Director__c = '005D0000001qz2K'; //Ani
                }
            }      
        }
        
/*        
        List<FFA_Config_Object__c> RDTl= [SELECT ID,Name,Teamlead__c, Teamlead__r.Name,Teamlead__r.Team_Lead__c FROM FFA_Config_Object__c 
                                               WHERE Id =: request.Requesting_Department__c];
                       
        if(Trigger.isInsert){           
    
            if(RDTl.size()>0){
                    if(RDTl.get(0).Teamlead__c != null){
                    
                    List<User> emp = [SELECT Name,Id FROM User
                                     WHERE Name =: RDTL.get(0).Teamlead__r.Name];
                    if(emp.size()>0){
                                       
                        request.Requesting_Department_Team_Lead__c = RDTL.get(0).Teamlead__c; 
                        request.Approving_Director__c = RDTL.get(0).Teamlead__r.Team_Lead__c;
                        request.Stage__c = 'New';
                        //update request;
                            }
                    }
                }
            }        
        
        else if(Trigger.isUpdate){            
                   
            //if Requesting department changes
            if(Trigger.oldMap.get(request.id).Requesting_Department__c != request.Requesting_Department__c){
                if(RDTl.size()>0){
                    if(RDTl.get(0).Teamlead__c!=null){
                        
                        List<User> emp = [SELECT Name,Id FROM User
                                     WHERE Name =: RDTL.get(0).Teamlead__r.Name];
                        if(emp.size()>0){
                                           
                            request.Requesting_Department_Team_Lead__c = RDTL.get(0).Teamlead__c; 
                            request.Approving_Director__c = RDTL.get(0).Teamlead__r.Team_Lead__c;
                            request.Stage__c = 'New';
                            //update request;
                                }
                    }
                }
            }
    	}
*/
    }
}