trigger CasualTeamLeadTrigger on Casuals_Job__c (before insert, before update) {
    for(Casuals_Job__c p: Trigger.new){
        
        List<FFA_Config_Object__c> RDTl= [SELECT ID,Name,Teamlead__c,Teamlead__r.Team_Lead__c FROM FFA_Config_Object__c 
                                           WHERE Id=:p.Department__c];
        if(RDTl.size()>0){
            if(RDTl.get(0).Teamlead__c!=null && RDTl.get(0).Teamlead__c!=p.OwnerId){
                p.Team_Lead__c=RDTL.get(0).Teamlead__c;                
            }
            else if(RDTl.get(0).Teamlead__c!=null && RDTl.get(0).Teamlead__c==p.OwnerId){
                 
                   p.Team_Lead__c=RDTl.get(0).Teamlead__r.Team_Lead__c;
               }
        }
       
    }

}