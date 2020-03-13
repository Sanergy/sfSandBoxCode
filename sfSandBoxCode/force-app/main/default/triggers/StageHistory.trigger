trigger StageHistory on Opportunity (before update,after insert, before insert) {
    //Integer counter=0;
    DateTime currentTimeStamp = DateTime.now();
    LIST<Opportunity_Stage__c> previousOpportunityStages;
    
    RecordType toiletLaunchOpportunityRecordType = [SELECT Id,Name,DeveloperName
                                         FROM RecordType
                                         WHERE Name = 'Toilet Sale - Launch Management'];
    
    /////////////////////////////////////START OF CODE//////////////////////////////////////////////
    
    for(Opportunity opportunity: Trigger.New){
        
        if(opportunity.RecordTypeId == toiletLaunchOpportunityRecordType.Id){
            
            if(Trigger.isUpdate){
                
                // Check if the Opportunity Stage has changed
                if(Trigger.oldMap.get(opportunity.id).StageName != opportunity.StageName){
                    
                    LIST<Opportunity_Stage__c> opportunityStageList = [SELECT ID,Projected_Launch_Date__c,Opportunity_Id__c,Active_Stage__c,
                                                                       Actual_End_Date__c,Expected_End_Date__c,Next_Stage__c,Opportunity_Name__c,Start_Date__c
                                                                       FROM Opportunity_Stage__c
                                                                       WHERE Opportunity_Id__c =: opportunity.Id
                                                                       AND Active_Stage__c = true];
                    
                    if(opportunityStageList.size() > 0 && opportunityStageList != null){
                        
                        for(Opportunity_Stage__c oppStage: opportunityStageList){
                            oppStage.Active_Stage__c = false;
                            oppStage.Actual_End_Date__c = currentTimeStamp;
                            previousOpportunityStages.add(oppStage);
                        }
                        
                        UPDATE previousOpportunityStages;
                        
                    }// End if(opportunityStageList.size() > 0 && opportunityStageList != null)
                    
                    //Create Opportunity_Stage__c
                    Opportunity_Stage__c opportunityStage = new Opportunity_Stage__c();
                    opportunityStage.Opportunity_Id__c = opportunity.Id;
                    opportunityStage.Active_Stage__c = true;
                    opportunityStage.Start_Date__c = currentTimeStamp;                
                    opportunityStage.Opportunity_Stage__c = Trigger.oldMap.get(opportunity.id).StageName;//From Stage
                    opportunityStage.Next_Stage__c = opportunity.StageName;//To Stage
                    
                    if(opportunity.StageName == 'Pending Govt Approval'){
                        opportunityStage.Expected_End_Date__c = currentTimeStamp + opportunityStage.Timeline_For_Pending_GR_Stage__c;
                    }else if(opportunity.StageName == 'Pending Install Start'){
                        opportunityStage.Expected_End_Date__c = currentTimeStamp + opportunityStage.Timeline_For_Pending_Install_Start_Stage__c;
                    }else if(opportunity.StageName == 'FLT Transported'){
                        opportunityStage.Expected_End_Date__c = currentTimeStamp + opportunityStage.Timeline_For_FLT_Transported_Stage__c;
                    }else if(opportunity.StageName == 'Install in Progress'){
                        opportunityStage.Expected_End_Date__c = currentTimeStamp + opportunityStage.Timeline_For_In_Progress_Stage__c;
                    }else if(opportunity.StageName == 'Pending Launch'){
                        opportunityStage.Expected_End_Date__c = currentTimeStamp + opportunityStage.Timeline_For_Pending_Launch_Stage__c;
                    }
                    
                    INSERT opportunityStage;                
                    
                }//End if(Trigger.oldMap.get(opportunity.id).StageName != opportunity.StageName)
                
            }//End if(Trigger.isUpdate)
            
        } //End if(opportunity.RecordTypeId == toiletLaunchRecordType.Id)
        
    }//End for(Opportunity opportunity: Trigger.New)
    
    
    /////////////////////////////////////END OF CODE///////////////////////////////////////////////
    
    
}