trigger UpdateSPPAfterEPRUpdate on Electronic_Payment_Request__c (after update) {
    
    for(Electronic_Payment_Request__c epr: Trigger.New){
        if(epr.Team_Lead_Approval_Status__c == 'Approved' ){
            
            Integer count = [SELECT count() FROM Special_Procurement_Payment__c where EPR__c =: epr.id];
            
            if(count > 0){
                Special_Procurement_Payment__c spp = [SELECT ID,Name,Total_EPR__c,EPR__c,Special_Procurement__c
                                                      FROM Special_Procurement_Payment__c
                                                      WHERE EPR__c =: epr.id
                                                     ];
                
                
                spp.Total_EPR__c = epr.Gross_Payment_Amount__c;
                update spp;
                
                Special_Procurement__c	spr = [SELECT ID,EPR_Status__c,Total_Approved_EPR_Value__c,Total_Amount__c
                                               FROM Special_Procurement__c
                                               WHERE ID =: spp.Special_Procurement__c
                                              ];
                
                
                if(spr.Total_Approved_EPR_Value__c == spr.Total_Amount__c){
                    spr.EPR_Status__c = 'Fully Paid';
                }
                if(spr.Total_Approved_EPR_Value__c < spr.Total_Amount__c){
                    spr.EPR_Status__c = 'Partially Paid';
                }
                if(spr.Total_Approved_EPR_Value__c > spr.Total_Amount__c){
                    spr.EPR_Status__c = 'Over Paid';
                }
                
                
                update spr;   
            }
            
        }
    }
    
}