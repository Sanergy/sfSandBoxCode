trigger ValidateEPR on Electronic_Payment_Request__c (before insert, before update) {
    
    Electronic_Payment_Request__c EPR=Trigger.new.get(0);
    /*---------------------------If trigger is an insert trigger-----------------------------------------------------*/
    if(Trigger.isInsert){
        if(EPR.Status__c!='Open'){
            EPR.addError('Status field has to be set to Open.');
        }
        
        if(EPR.Payment_Type__c==null){
            EPR.addError('Specify a payment type');
        }
        //set the company account from FFA Config
        List<String> FFAConfigCompanyName = SanergyUtils.GetFFAConfigCompanyName(EPR.Company__c );
        system.debug('EPR.Company__c = ' + EPR.Company__c);
        if(FFAConfigCompanyName != NULL){
                EPR.Requesting_Company__c = FFAConfigCompanyName[1];
                EPR.RespectiveCompany__c = FFAConfigCompanyName[2];
            }
        
        //set the currency value for the account
        List<Account> vendorAccount=[SELECT c2g__CODAAccountTradingCurrency__c 
                                     FROM Account 
                                     WHERE ID=:EPR.Vendor_Company__c
                                    ];
        
        if(vendorAccount.size() > 0){
            EPR.Currency__c=vendorAccount.get(0).c2g__CODAAccountTradingCurrency__c;
        }
        
        if(EPR.department__c!=null){
            List<FFA_Config_Object__c> department=[SELECT name, Teamlead__c, Teamlead__r.name, Teamlead__r.Team_Lead__c, Delegated_approver__c
                                                   FROM FFA_Config_Object__c
                                                   WHERE ID=:EPR.department__c];
            system.debug('department = ' + department);
            //Get details of Creator and Requestor
            Employee__c empCreator = new Employee__c();
            empCreator = 
                [
                    SELECT Id, Name, Employee_SF_Account__c, Line_Manager_SF_Account__c
                    FROM Employee__c
                    WHERE Employee_SF_Account__c =: System.UserInfo.getUserId()  LIMIT 1 // will insert EPR.CreatedById
                ];
            system.debug('empCreator = ' + empCreator);
            //check if teamlead made the request, in which case, Sanj approves
            if((EPR.ownerId=='005D0000001qyr7' || 
                EPR.ownerId=='005D0000001rH3B' || 
                EPR.ownerId=='005D0000001qz2K' ) &&
               department.get(0).name=='Directors'){
                   EPR.Approving_Teamlead__c=department.get(0).Teamlead__r.Team_Lead__c;
               }
            else if(EPR.Approving_Teamlead__c == empCreator.Employee_SF_Account__c){
                //if creator is the same as Approving TL
                EPR.Approving_Teamlead__c = empCreator.Line_Manager_SF_Account__c;
                system.debug('EPR.Approving_Teamlead__c == empCreator.Employee_SF_Account__c >> ' + EPR.Approving_Teamlead__c + ' == ' + empCreator.Employee_SF_Account__c);
            }
            //if resulting approver is the same as the creator, choose the teamlead of the creator as the approver 
            else if(department.get(0).Teamlead__c!=null && department.get(0).Teamlead__c==EPR.OwnerId){
                EPR.Approving_Teamlead__c=department.get(0).Teamlead__r.Team_Lead__c;
                system.debug('department.get(0).Teamlead__c==EPR.OwnerId >> ' + department.get(0).Teamlead__c + ' == ' + EPR.OwnerId);
            }  
            else{
                EPR.Approving_Teamlead__c=department.get(0).Delegated_approver__c;
                system.debug('Else >> ' + department.get(0).Delegated_approver__c);
            }   
        }
    }  
    
    else if(Trigger.isUpdate){    
        if(EPR.department__c!=null && Trigger.oldMap.get(EPR.id).department__c!=EPR.department__c){
            List<FFA_Config_Object__c> department=[SELECT Teamlead__c, Teamlead__r.name,Teamlead__r.Team_Lead__c, name, Delegated_approver__c
                                                   FROM FFA_Config_Object__c
                                                   WHERE ID=:EPR.department__c];
            
            //Get details of Creator and Requestor
            Employee__c empCreator = 
                [
                    SELECT Id, Name, Employee_SF_Account__c, Line_Manager_SF_Account__c
                    FROM Employee__c
                    WHERE Employee_SF_Account__c =: EPR.CreatedById LIMIT 1
                ];
            
            //check if teamlead made the request, in which case, Sanj approves
            if((EPR.ownerId=='005D0000001qyr7' || 
                EPR.ownerId=='005D0000001rH3B' || 
                EPR.ownerId=='005D0000001qz2K' ) &&
               department.get(0).name=='Directors'){
                   EPR.Approving_Teamlead__c=department.get(0).Teamlead__r.Team_Lead__c;
               }
            else if(EPR.Approving_Teamlead__c == empCreator.Employee_SF_Account__c){
                //if creator is the same as Approving TL
                EPR.Approving_Teamlead__c = empCreator.Line_Manager_SF_Account__c;
            }
            //if resulting approver is the same as the creator, choose the teamlead of the creator as the approver 
            else if(department.get(0).Teamlead__c!=null && department.get(0).Teamlead__c==EPR.OwnerId){
                EPR.Approving_Teamlead__c=department.get(0).Teamlead__r.Team_Lead__c;
            }  
            else{
                EPR.Approving_Teamlead__c=department.get(0).Delegated_approver__c;
            }   
        }
        
        //if company changed
        system.debug('Company__c' + EPR.Company__c + ' *** ' + Trigger.oldMap.get(EPR.id).Company__c);
        if(EPR.Company__c != Trigger.oldMap.get(EPR.id).Company__c || EPR.Requesting_Company__c == NULL){
            List<String> FFAConfigCompanyName = SanergyUtils.GetFFAConfigCompanyName(EPR.Company__c );
            system.debug('Company__c 11' + FFAConfigCompanyName);
            if(FFAConfigCompanyName != NULL){
                EPR.Requesting_Company__c = FFAConfigCompanyName[1];
                EPR.RespectiveCompany__c = FFAConfigCompanyName[2];
            }
        }
    }
}