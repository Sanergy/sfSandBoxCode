trigger CreateEPRFromSpecialProcurementTrigger on Special_Procurement__c (before update) {
    if(1==1){system.debug('Empty test results');}
    /*
    //create standard controller
    private ApexPages.StandardController controller;
    Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();
    Special_Procurement_Payment__c spp = new Special_Procurement_Payment__c();
    
    for(Special_Procurement__c sp: Trigger.new){
        
        if(sp.Generate_EPR__c== true && sp.EPR_Created__c ==false){
            //Create EPR
            // Create an instance of EPR
            
            if(sp.Approval_Status__c == 'Approved By Director' || (sp.Approval_Status__c == 'Approved By Team Lead' && sp.Total_Amount__c <= 1000)){
                // Select Special Procurement Line Items
                List<Special_Procurement_Line_Item__c> spLineItems = 
                    [SELECT Id,Name,Special_Procurement__c,Item__c,Status__c, Specifications__c,EPR_Created__c,
                     Status_Flag__c,Quantity_Requested__c, Unit_Price__c,Total_Price__c, Total_Unapproved_Value__c
                     FROM Special_Procurement_Line_Item__c
                     WHERE Status__c = 'Approved'                                                                  
                     AND EPR_Created__c = False
                     AND Special_Procurement__c =: sp.Id
                     ORDER BY Name DESC
                    ];        
                
                if(spLineItems != NULL && spLineItems.size() > 0){
                    //Create EPR
                    switch on sp.Requesting_Company__r.Name {
                        when 'Sanergy Limited' {epr.Company__c = 'Sanergy Ltd';}
                        when 'Fresh Life Initiative Limited' {epr.Company__c = 'Fresh Life Initiative Ltd';}
                        when 'Sanergy, Inc. (FP)' {epr.Company__c = 'Sanergy Inc (FP)';}
                        when 'Sanergy, Inc. (NP)' {epr.Company__c = 'Sanergy Inc (NP)';}
                    }
                    
                    epr.department__c = sp.Requesting_Department__c;
                    epr.Vendor_Company__c = sp.Vendor__c;
                    epr.Invoice_Number__c = sp.Name;                              
                    epr.Scheduled_Payment_Date__c = date.today();                
                    epr.Notes__c='Payment for items bought at '+ sp.Vendor__r.name +' as per Special Payment Request'+ sp.Name;
                    epr.Payment_Type__c = sp.Type__c; 
                   
                    INSERT epr;
                    
                    sp.EPR_Created__c = true;
                    
                    
                    // Loop through the list of Special Procurement Line Items
                    for(Special_Procurement_Line_Item__c spli : spLineItems){               
                        
                        // Create EPR Payable Item
                        EPR_Payable_Item__c eprLineItems = new EPR_Payable_Item__c();            
                        eprLineItems.epr__c=epr.id;
                        eprLineItems.Department_dim1__c = epr.department__c;
                        eprLineItems.Item__c = spli.Item__c;
                        eprLineItems.Quantity__c = spli.Quantity_Requested__c;
                        eprLineItems.Unit_Price__c = spli.Unit_Price__c;
                        eprLineItems.Location_Dim2__c = sp.Dim_2__c;
                        eprLineItems.Dim_3__c = sp.Dim_3__c;                
                        eprLineItems.GLA__c = sp.GLA__c;
                        
                        INSERT eprLineItems;
                        
                        // Update Special Procurement Line Item
                        spli.EPR_Created__c = True;
                        UPDATE spli;                            
                    }
                    //Run SOQL to get EPR calculation of Gross Amount to pass down to SPP
                    Electronic_Payment_Request__c eprSaved = 
                        [SELECT id, Gross_Payment_Amount__c FROM Electronic_Payment_Request__c WHERE id =: sp.id ];
                    
                    // Special Procurement Payment
                    spp.Company__c=sp.Requesting_Company__c;
                    spp.EPR__c=epr.id;
                    spp.Special_Procurement__c=sp.id;
                    spp.Payment_Cost__c= eprSaved.Gross_Payment_Amount__c;
                    
                    INSERT spp;             
                    
                    // spp.Total_EPR__c = spp.Total_EPR_Value__c;
                    //  update spp; 
                    
                    // sp.Stage__c = 'EPR Generated';                
                    
                    // Create an approval request for the EPR
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting request for approval.');
                    req.setObjectId(epr.Id);
                    
                    // Submit the EPR for approval
                    Approval.ProcessResult result = Approval.process(req);            
                    
                }
                
            }
        }      
    }
*/
}