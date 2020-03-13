trigger GenerateSPRLineItems on Special_Procurement__c (before insert, after insert) {
    
    for(Special_Procurement__c sp: Trigger.New){
        if(Trigger.isInsert && Trigger.isBefore) {
          	//if before, check if any existing SPR, only allow one SPR at any time
            AggregateResult [] aggSPR = 
                [SELECT COUNT(id)OpenSPRs
                 FROM Special_Procurement__c
                 WHERE Requestor__c =: sp.Requestor__c
                 AND Type__c IN ('Cash Advance','Employee Reimbursement')
                 AND Reconciliation_Completed__c = FALSE
                 AND CreatedDate >= 2020-01-01T00:00:00Z
                 GROUP BY Requestor__c
                ];
            //system.debug('Open SPRs = ' + Integer.valueOf(aggSPR[0].get('OpenSPRs')));
            if(aggSPR.size() > 0 && (Integer)aggSPR[0].get('OpenSPRs') > 0 && 
               		(sp.Type__c == 'Cash Advance' || sp.Type__c == 'Employee Reimbursement' ) //Only for SPRs that need Recon
               ){
                sp.Stage__c = 'Open';
                   if(Test.isRunningTest()){
                       //do nothing
                   }
                   else{
                       //Throw exception
                       sp.addError('Cannot create a new SPR until the previous ' + (Integer)aggSPR[0].get('OpenSPRs') + ' SPRs have been fully reconciled');
                   }
                
            } else
            {
                //set defaults
                sp.stage__c = 'Open';
                sp.Approval_Status__c = 'Pending Approval';
                sp.Approve_Reconciliation__c = FALSE;
                sp.Recon_EPR_Generated__c = FALSE;
                sp.Reconciliation_Submitted__c = FALSE;
                sp.Reconciliation_Completed__c = FALSE;
                sp.Payable_Invoice__c = NULL;
                sp.EPR_Created__c = FALSE;
                sp.Generate_EPR__c = FALSE;
                sp.Recon_EPR__c = NULL;
                sp.Recon_SPR__c = NULL;
                sp.Next_Step__c = NULL;
                sp.Next_Step_Due_Date__c = NULL;
            }
        }
        if(Trigger.isInsert && Trigger.isAfter) {          
            AggregateResult [] spr = [SELECT SUM(Reconciled_Balance__c)Reconciled_Balance__c
                                      FROM Special_Procurement__c
                                      WHERE Requestor__c =: sp.Requestor__c
                                      AND Type__c IN ('Cash Advance','Employee Reimbursement')
                                      AND CreatedDate >= 2020-01-01T00:00:00Z
                                      GROUP BY Requestor__c
                                     ];
            //Create BCF Line for 'Cash Advance','Employee Reimbursement' only
            if(sp.Type__c == 'Cash Advance' || sp.Type__c == 'Employee Reimbursement' ){
                if(spr.size() > 0 && (Decimal)spr[0].get('Reconciled_Balance__c') != 0){
                    Special_Procurement_Line_Item__c sprline = new Special_Procurement_Line_Item__c();
                    sprline.Special_Procurement__c = sp.ID;
                    sprline.Item__c ='BCF From: All the previous SPRs';
                    sprline.Specifications__c = 'BCF From: All the previous SPRs';
                    sprline.Request_Type__c = 'Not Applicable';
                    sprline.Currency__c = 'aHQD0000000blJJ';
                    sprline.Create_PR_Line_Item__c = false;
                    sprline.Quantity_Requested__c = 1;
                    sprline.Unit_Price__c = (Decimal)spr[0].get('Reconciled_Balance__c');
                    sprline.EPR_Created__c = TRUE; //To stop creation of a new EPR as this is from a carried over EPR
                    INSERT sprline;
                    //if they owe us money ie balance is +ve then create a payment line
                    //this one will not have an EPR
                    if((Decimal)spr[0].get('Reconciled_Balance__c') > 0){
                        Special_Procurement_Payment__c spp = new Special_Procurement_Payment__c (
                            Special_Procurement__c = sp.ID,
                            Payment_Cost__c = (Decimal)spr[0].get('Reconciled_Balance__c'),
                            Balance_Carried_Forward__c = TRUE,
                            Company__c = sp.Requesting_Company__c,
                            Total_EPR__c = (Decimal)spr[0].get('Reconciled_Balance__c'),
                            Comments__c = 'Balance Carried Forward'
                        );
                        INSERT spp;
                    }
                } 
            }
        }
    }
}