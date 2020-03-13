trigger RFETeamLeadTrigger on RFE__c (before insert) {
    
    for(RFE__c rfe: Trigger.new){
        
        List<FFA_Config_Object__c> RDTl= [SELECT ID,Name,Teamlead__c,Teamlead__r.Team_Lead__c FROM FFA_Config_Object__c 
                                           WHERE Id=:rfe.Requesting_Department__c];
        if(RDTl.size()>0){
            
            if(RDTl.get(0).Teamlead__c!=null && RDTl.get(0).Teamlead__c!=rfe.OwnerId){
                
                rfe.Team_Lead__c=RDTL.get(0).Teamlead__c;                
            }
            else if(RDTl.get(0).Teamlead__c!=null && RDTl.get(0).Teamlead__c==rfe.OwnerId){
                 
                   rfe.Team_Lead__c=RDTl.get(0).Teamlead__r.Team_Lead__c;
               }
        }
       
    }

}