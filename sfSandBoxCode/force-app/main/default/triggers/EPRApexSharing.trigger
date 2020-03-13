trigger EPRApexSharing on Electronic_Payment_Request__c (after insert) {
    //Create an Apex Sharing record for the EPR object
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
        // Create a new list of sharing objects for EPR Record
        List<Electronic_Payment_Request__Share> EPRShrs  = new List<Electronic_Payment_Request__Share>();
        
        // Declare variables for EPR users
        Electronic_Payment_Request__Share finShr;
        Electronic_Payment_Request__Share AccShr;
        Electronic_Payment_Request__Share TLShr;
        Electronic_Payment_Request__Share ProcShr;
        Electronic_Payment_Request__Share OwnerShr;
        Electronic_Payment_Request__Share RequestorShr;
        Electronic_Payment_Request__Share RequestorDeptTLShr;
        Electronic_Payment_Request__Share DirectorShr;
        
        for(Electronic_Payment_Request__c EPR : trigger.new){
            // Instantiate the sharing objects
            finShr = new Electronic_Payment_Request__Share();
            AccShr = new Electronic_Payment_Request__Share();
            TLShr = new Electronic_Payment_Request__Share();
            //ProcShr = new Electronic_Payment_Request__Share();
            OwnerShr = new Electronic_Payment_Request__Share();
            RequestorShr = new Electronic_Payment_Request__Share();
            RequestorDeptTLShr = new Electronic_Payment_Request__Share();
            DirectorShr = new Electronic_Payment_Request__Share();
            
            //set the ID of the record being shared
            finShr.ParentId = EPR.id;
            AccShr.ParentId = EPR.id;
            TLShr.ParentId = EPR.id;
            
            OwnerShr.ParentId = EPR.id;
            RequestorShr.ParentId = EPR.id;
            RequestorDeptTLShr.ParentId = EPR.id;
            DirectorShr.ParentId = EPR.id;
            
            // Set the User/Group ID of record being shared
            OwnerShr.UserOrGroupId  = EPR.OwnerId; 
            // Select User(Group) Ids from EPR Requestor record 
            /*
            Employee__c emp = [SELECT Employee_SF_Account__c, Team_Lead_SF_Account__c
                               FROM Employee__c
                               WHERE Id =: EPR.Requestor__c
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
            */
            //default to TempRS
            RequestorShr.UserOrGroupId  = '005D0000003Ykhb';
            TLShr.UserOrGroupId  = '005D0000003Ykhb';
            
            RequestorDeptTLShr.UserOrGroupId = EPR.Approving_Teamlead__c;
            AccShr.UserOrGroupId  = AccShrGroupID;//'00G7E000003snUa'; //Accounting Group
            
            // if FLI/SLK choose correct User/Group ID
            system.debug('EPR.Requesting_Company__c : ' + EPR.Requesting_Company__c );
            if(EPR.Requesting_Company__c == compSLKID || EPR.Requesting_Company__c == compFPID){//SLK or FP
                system.debug('EPR.Requesting_Company__c : in here :' + EPR.Requesting_Company__c );
                finShr.UserOrGroupId  = SLKfinShrGroupId;
                DirectorShr.UserOrGroupId = SLKDirectorShrGroupID;
            } else if (EPR.Requesting_Company__c== compFLIID || EPR.Requesting_Company__c == compNPID){//FLI
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
            finShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Fin__c;
            AccShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Acc__c;
            TLShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_TL__c;
            RequestorShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Requestor__c;
            RequestorDeptTLShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Requestor_Dept_TL__c;
            
            OwnerShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Owner__c;
            DirectorShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Director__c;
            
            // Add objects to list for insert
            EPRShrs.add(finShr);
            EPRShrs.add(AccShr);
            EPRShrs.add(TLShr);
            
            EPRShrs.add(RequestorShr);
            EPRShrs.add(RequestorDeptTLShr);
            
            EPRShrs.add(OwnerShr);
            EPRShrs.add(DirectorShr);
            
            //only to be done if a Procurement. Everything else should not be availabe to PPs
            if(EPR.EPR_Type__c == 'Special Procurement'){
                ProcShr = new Electronic_Payment_Request__Share();  
                ProcShr.ParentId = EPR.id;
                
                // if FLI/SLK choose correct User/Group ID
                if(EPR.Requesting_Company__c == compSLKID || EPR.Requesting_Company__c == compFPID){
                    system.debug('EPR.Requesting_Company__c : in here 2 :' + EPR.Requesting_Company__c );
                    ProcShr.UserOrGroupId = SLKProcShrGroupID;//'00G7E000003sKTB'; //SLK Procurement
                } else if (EPR.Requesting_Company__c== compFLIID || EPR.Requesting_Company__c == compNPID){
                    ProcShr.UserOrGroupId = FLIProcShrGroupID;//'00G7E000003sL58'; //FLI Procurement
                }
                
                ProcShr.AccessLevel = 'Edit';
                ProcShr.RowCause = Schema.Electronic_Payment_Request__Share.RowCause.EPR_Sharing_Procurement__c;
                EPRShrs.add(ProcShr);
                
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
        Database.SaveResult[] lsr = Database.insert(EPRShrs,false);
        
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
                    trigger.newMap.get(EPRShrs[i].ParentId).
                        addError(
                            'Unable to grant sharing access due to following exception: '
                            + err.getMessage());
                }
            }
            i++;
        }   
    }
}