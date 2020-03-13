trigger SPRApexSharing on Special_Procurement__c (after insert ) {
    //Create an Apex Sharing record for the SPR object
    /*
        List<AccountShare> sharesToDelete = [SELECT Id 
        FROM AccountShare 
        WHERE AccountId IN :trigger.newMap.keyset() 
        AND RowCause = 'Manual'];
        if(!sharesToDelete.isEmpty()){
        Database.Delete(sharesToDelete, false);
    }
    */
    String FLIfinShrGroupID;
    String SLKfinShrGroupID;
    String AccShrGroupID;
    String FLIProcShrGroupID;
    String SLKProcShrGroupID;
    String FLIDirectorShrGroupID;
    String SLKDirectorShrGroupID;
    
    ID compSLKId = 'aEBD0000000k9yMOAQ'; //aEBD0000000k9yMOAQ
    ID compFPId = 'aEBD0000000kA4oOAE';
    ID compFLIId = 'aEBD0000000kA4jOAE';
    ID compNPId = 'aEBD0000000kA4tOAE';
    
    if(trigger.isInsert){
        //Get the list of IDs for the main UserGroups - Accounting, Finance, Directors, PPs
        List <Group> userGroup = 	[
            SELECT id, DeveloperName, Type FROM Group
            WHERE Type = 'Regular' AND DeveloperName IN
            ('Accounting','FLI_Directors','SLK_Directors','FLI_Finance','SLK_Finance','FLI_Procurement','SLK_Procurement')
        ];
        if(userGroup != NULL && userGroup.size() >0){
            for(Group grp : userGroup){
                switch on grp.DeveloperName {
                    when 'Accounting' {
                        AccShrGroupID = grp.id;
                    }	
                    when 'FLI_Directors' {
                        FLIDirectorShrGroupID = grp.id;
                    }
                    when 'FLI_Finance'{
                      	FLIfinShrGroupID = grp.Id;
                    }
                    when 'FLI_Procurement'{
                        FLIProcShrGroupID = grp.Id;
                    } 
                    when 'SLK_Directors' {
                        SLKDirectorShrGroupID = grp.id;
                    }
                    when 'SLK_Finance' {
                      	SLKfinShrGroupID = grp.Id;
                    }
                    when 'SLK_Procurement' {
                        SLKProcShrGroupID = grp.Id;
                    } 
                }
            }   
        }
        system.debug('userGroup : ' + userGroup);
        // Create a new list of sharing objects for SPR Record
        List<Special_Procurement__Share> sprShrs  = new List<Special_Procurement__Share>();
        
        // Declare variables for SPR users
        Special_Procurement__Share finShr;
        Special_Procurement__Share AccShr;
        Special_Procurement__Share TLShr;
        Special_Procurement__Share ProcShr;
        Special_Procurement__Share OwnerShr;
        Special_Procurement__Share RequestorShr;
        Special_Procurement__Share RequestorDeptTLShr;
        Special_Procurement__Share DirectorShr;
        
        for(Special_Procurement__c spr : trigger.new){
            // Instantiate the sharing objects
            finShr = new Special_Procurement__Share();
            AccShr = new Special_Procurement__Share();
            TLShr = new Special_Procurement__Share();
            //ProcShr = new Special_Procurement__Share();
            OwnerShr = new Special_Procurement__Share();
            RequestorShr = new Special_Procurement__Share();
            RequestorDeptTLShr = new Special_Procurement__Share();
            DirectorShr = new Special_Procurement__Share();
            
            //set the ID of the record being shared
            finShr.ParentId = spr.id;
            AccShr.ParentId = spr.id;
            TLShr.ParentId = spr.id;
            
            OwnerShr.ParentId = spr.id;
            RequestorShr.ParentId = spr.id;
            RequestorDeptTLShr.ParentId = spr.id;
            DirectorShr.ParentId = spr.id;
            
            // Set the User/Group ID of record being shared
            OwnerShr.UserOrGroupId  = spr.OwnerId; 
            // Select User(Group) Ids from SPR Requestor record 
            Employee__c emp = [SELECT Employee_SF_Account__c, Team_Lead_SF_Account__c
                               FROM Employee__c
                               WHERE Id =: spr.Requestor__c
                               LIMIT 1
                              ];
            //Some records might not have the emp account entered, default to TempRS Account
            if (emp.Employee_SF_Account__c != NULL){
                //found, use details found
                RequestorShr.UserOrGroupId  = emp.Employee_SF_Account__c;
            	TLShr.UserOrGroupId  = emp.Team_Lead_SF_Account__c;
            } 
            else {
                //default to TempRS
                RequestorShr.UserOrGroupId  = '005D0000003Ykhb';
            	TLShr.UserOrGroupId  = '005D0000003Ykhb';
            }
                
            RequestorDeptTLShr.UserOrGroupId = spr.Requesting_Department_TL__c;
            AccShr.UserOrGroupId  = AccShrGroupID;//'00G7E000003snUa'; //Accounting Group
            
            // if FLI/SLK choose correct User/Group ID
            system.debug('spr.Requesting_Company__c : ' + spr.Requesting_Company__c );
            if(spr.Requesting_Company__c == compSLKID || spr.Requesting_Company__c == compFPID){//SLK or FP
                system.debug('spr.Requesting_Company__c : in here :' + spr.Requesting_Company__c );
                finShr.UserOrGroupId  = SLKfinShrGroupId;
            	DirectorShr.UserOrGroupId = SLKDirectorShrGroupID;
            } else if (spr.Requesting_Company__c== compFLIID || spr.Requesting_Company__c == compNPID){//FLI
                finShr.UserOrGroupId  = FLIfinShrGroupId;
            	DirectorShr.UserOrGroupId = FLIDirectorShrGroupID;
            }
            
            // Set the access level
            finShr.AccessLevel = 'read';
            AccShr.AccessLevel = 'read';
            TLShr.AccessLevel = 'read';
            RequestorShr.AccessLevel = 'Edit';
            RequestorDeptTLShr.AccessLevel = 'Read';
            OwnerShr.AccessLevel = 'edit';
            DirectorShr.AccessLevel = 'Read';
            
            // Set the Apex sharing reasons
            finShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Fin__c;
            AccShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Acc__c;
            TLShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_TL__c;
            RequestorShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Requestor__c;
            RequestorDeptTLShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Requestor_Dept_TL__c;
            
            OwnerShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Owner__c;
            DirectorShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Director__c;
            
            // Add objects to list for insert
            sprShrs.add(finShr);
            sprShrs.add(AccShr);
            sprShrs.add(TLShr);
            
            sprShrs.add(RequestorShr);
            sprShrs.add(RequestorDeptTLShr);

            sprShrs.add(OwnerShr);
            sprShrs.add(DirectorShr);
            
            //only to be done if a Procurement. Everything else should not be availabe to PPs
            if(spr.Type__c == 'Special Procurement'){
                ProcShr = new Special_Procurement__Share();
                system.debug('TLShr.UserOrGroupId = ' + emp);  
                ProcShr.ParentId = spr.id;

                // if FLI/SLK choose correct User/Group ID
                if(spr.Requesting_Company__c == compSLKID || spr.Requesting_Company__c == compFPID){
                    system.debug('spr.Requesting_Company__c : in here 2 :' + spr.Requesting_Company__c );
                    ProcShr.UserOrGroupId = SLKProcShrGroupID;//'00G7E000003sKTB'; //SLK Procurement
                } else if (spr.Requesting_Company__c== compFLIID || spr.Requesting_Company__c == compNPID){
                    ProcShr.UserOrGroupId = FLIProcShrGroupID;//'00G7E000003sL58'; //FLI Procurement
                }

                ProcShr.AccessLevel = 'Edit';
                ProcShr.RowCause = Schema.Special_Procurement__Share.RowCause.SPR_Sharing_Procurement__c;
                sprShrs.add(ProcShr);
                
                system.debug('ProcShr: ' + ProcShr);
            }
            
        }
        system.debug('finShr: ' + finShr);
        system.debug('AccShr : ' + AccShr);
        system.debug('TLShr :' + TLShr );
        
        system.debug('RequestorShr: ' + RequestorShr);
        system.debug('RequestorShr: ' + RequestorDeptTLShr);
        system.debug('OwnerShr: ' + OwnerShr);
        system.debug('DirectorShr: ' + DirectorShr);
        	
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(sprShrs,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  err.getMessage().contains('AccessLevel'))){
                         // Throw an error when the error is not related to trivial access level.
                         trigger.newMap.get(sprShrs[i].ParentId).
                             addError(
                                 'Unable to grant sharing access due to following exception: '
                                 + err.getMessage());
                    
                     }
            }
            i++;
        }   
    }
}