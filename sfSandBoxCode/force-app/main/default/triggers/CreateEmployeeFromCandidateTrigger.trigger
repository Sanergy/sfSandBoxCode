trigger CreateEmployeeFromCandidateTrigger on Candidate__c (before update) {
    for(Candidate__c candidate:Trigger.New){
        if(candidate.Candidate_Status__c == 'Offer Accepted'){
            
            Double hrNumber = 0;
            //get recruitment requisition for this candidate
            List<Recruitment_Requisition__c> recruitmentRequisitions = [SELECT ID,Employee_Role__r.Company_Division__c,Employee_Role__r.Department__c,Employee_Role__r.Line_Manager__c,Requesting_Department_Team_Lead__c,Employee_Role__r.Sanergy_Department_Unit__c,
                                                                        Employee_Role__r.Sanergy_Department__c,Employee_Role__r.Id, Type_of_employment__c,
                                                                        Requesting_Department__c,Location__c,Employee_Role__c FROM Recruitment_Requisition__c
                                                                        WHERE ID =: candidate.Recruitment_Requisition__c ];
            if(recruitmentRequisitions.size()>0){

                Employee__c employee = new Employee__c();
            	employee.Employee_First_Name__c = candidate.First_Name__c;
            	employee.Employee_Last_Name__c = candidate.Last_Name__c;
            	employee.Employee_Middle_Name__c = candidate.Middle_Name__c;
            	employee.Employee_Role__c = recruitmentRequisitions.get(0).Employee_Role__c;
            	employee.Employment_Start_Date__c = Date.today();
            	employee.Employment_Status__c = recruitmentRequisitions.get(0).Type_of_employment__c;
            	employee.Identification_Document__c = 'National ID';
            	employee.Identification_Number__c = candidate.ID_Number__c;
            	employee.Job_Title__c = null;
            	employee.Line_Manager__c = recruitmentRequisitions.get(0).Employee_Role__r.Line_Manager__c;
            	employee.Primary_Phone__c = candidate.Phone_Number__c;
                employee.Recruitment_Requisition__c = candidate.Recruitment_Requisition__c;
            	employee.Sanergy_Department__c = recruitmentRequisitions.get(0).Employee_Role__r.Department__c;
            	employee.Sanergy_Department_Unit__c = recruitmentRequisitions.get(0).Employee_Role__r.Sanergy_Department_Unit__c;
                employee.Company_Division__c = recruitmentRequisitions.get(0).Employee_Role__r.Company_Division__c;
             	employee.Tickets_Created__c = false;                
                INSERT employee;
                
                List<Recruitment_Request_Config__c> roleConfig = [SELECT Id,Name,Employee_Role__c,Type__c,Returnable__c,Maximum__c,Amount__c
                                                         		  FROM Recruitment_Request_Config__c 
                                                          		  WHERE Employee_Role__c =: recruitmentRequisitions.get(0).Employee_Role__r.Id ];
                
                for(Recruitment_Request_Config__c recruitmentRequestConfig: roleConfig){
                    
                	if(recruitmentRequestConfig.Type__c == 'Email Account' || recruitmentRequestConfig.Type__c == 'Salesforce Account' || recruitmentRequestConfig.Type__c == 'Dropbox Account' || recruitmentRequestConfig.Type__c == 'Intranet Account'){                    
                		Recruitment_Requisition_Line_Item__c recruitmentRequisitionLineItem1 = new Recruitment_Requisition_Line_Item__c();
                        recruitmentRequisitionLineItem1.Status__c = 'Pending';
                        recruitmentRequisitionLineItem1.Type__c = recruitmentRequestConfig.Type__c;
                        recruitmentRequisitionLineItem1.Employee__c = employee.Id;
                        recruitmentRequisitionLineItem1.Recruitment_Requisition__c = employee.Recruitment_Requisition__c;
                		INSERT recruitmentRequisitionLineItem1;
                        
                	}else if(recruitmentRequestConfig.Type__c == 'Phone' || recruitmentRequestConfig.Type__c == 'Computer' || recruitmentRequestConfig.Type__c == 'Accessory' || recruitmentRequestConfig.Type__c == 'Vehicle'){
                        Recruitment_Requisition_Line_Item__c recruitmentRequisitionLineItem2 = new Recruitment_Requisition_Line_Item__c();
                        recruitmentRequisitionLineItem2.Asset_is_Returnable__c = recruitmentRequestConfig.Returnable__c;
                        recruitmentRequisitionLineItem2.Status__c = 'Pending';
                        recruitmentRequisitionLineItem2.Type__c = recruitmentRequestConfig.Type__c;
                        recruitmentRequisitionLineItem2.Employee__c = employee.Id;
                        recruitmentRequisitionLineItem2.Recruitment_Requisition__c = employee.Recruitment_Requisition__c;
                		INSERT recruitmentRequisitionLineItem2;                        
                        
                	}else if(recruitmentRequestConfig.Type__c == 'Airtime Allowance' || recruitmentRequestConfig.Type__c == 'Meal Allowance' || 
                             recruitmentRequestConfig.Type__c == 'Transport Allowance' || recruitmentRequestConfig.Type__c == 'Overtime Allowance' || 
                             recruitmentRequestConfig.Type__c == 'Bonus Allowance' || recruitmentRequestConfig.Type__c == 'Referral Allowance'){
                                 
                        Recruitment_Requisition_Line_Item__c recruitmentRequisitionLineItem3 = new Recruitment_Requisition_Line_Item__c();
                        recruitmentRequisitionLineItem3.Maximum_amount__c = recruitmentRequestConfig.Maximum__c;
                        recruitmentRequisitionLineItem3.Status__c = 'Pending';
                        recruitmentRequisitionLineItem3.Type__c = recruitmentRequestConfig.Type__c;
                        recruitmentRequisitionLineItem3.Employee__c = employee.Id;
                        recruitmentRequisitionLineItem3.Recruitment_Requisition__c = employee.Recruitment_Requisition__c;
                        INSERT recruitmentRequisitionLineItem3;
                        
                       Staff_Allowances__c staffAllowances = new Staff_Allowances__c();
                                 
						if(recruitmentRequestConfig.Type__c == 'Airtime Allowance'){                                                                        
                            //Staff_Allowances__c staffAllowances = new Staff_Allowances__c();
                            staffAllowances.RecordTypeId = '012D0000000caMS';                            
                            staffAllowances.Allowance_Type__c = recruitmentRequestConfig.Type__c;                           
                            staffAllowances.Employee__c = employee.Id;
                            staffAllowances.Allowance_Description__c = recruitmentRequestConfig.Type__c;
                            staffAllowances.Start_Date__c = employee.Employment_Start_Date__c;
                            staffAllowances.Department_Unit__c = employee.Sanergy_Department_Unit__c;
                            staffAllowances.Allowance_Frequency__c = 'Monthly';
                            staffAllowances.End_Date__c = employee.Employment_Start_Date__c;
                            staffAllowances.Sanergy_Department__c = employee.Sanergy_Department__c;
                            //INSERT staffAllowances;
                        }else{
                            
                            //Staff_Allowances__c staffAllowances = new Staff_Allowances__c();
                            staffAllowances.RecordTypeId = '012D0000000caMQ';
                            staffAllowances.Allowance_Type__c = recruitmentRequestConfig.Type__c;                           
                            staffAllowances.Employee__c = employee.Id;
                            staffAllowances.Allowance_Description__c = recruitmentRequestConfig.Type__c;
                            staffAllowances.Start_Date__c = employee.Employment_Start_Date__c;
                            staffAllowances.Department_Unit__c = employee.Sanergy_Department_Unit__c;
                            staffAllowances.Allowance_Frequency__c = 'Monthly';
                            staffAllowances.End_Date__c = employee.Employment_Start_Date__c;
                            staffAllowances.Sanergy_Department__c = employee.Sanergy_Department__c;
                            //INSERT staffAllowances;                            
                        }
						INSERT staffAllowances; 
                    }
                }
            }
        }
    }
}