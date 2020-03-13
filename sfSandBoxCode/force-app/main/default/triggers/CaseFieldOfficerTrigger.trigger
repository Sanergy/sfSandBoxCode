trigger CaseFieldOfficerTrigger on Case (before insert, before update) {
    for (Case c: Trigger.new) {
      /* ,Member_Role__c*/
        
              
        List<Toilet__c> tl = [SELECT ID,Location__c
                                           FROM Toilet__c
                                            WHERE ID=:c.Toilet__c];
        
        c.Location__c=tl.get(0).Location__c;
        
       List<Location_Team__c> lc = [SELECT ID,Member_Role__c,Team_Member__c
                                           FROM Location_Team__c
                                            WHERE Location__c=:c.Location__c
                                            AND (Member_Role__c='Field Officer'
                                            OR Member_Role__c='Senior Field Officer')];
        
      for ( Location_Team__c loc : lc ){
             if(loc.Member_Role__c=='Senior Field Officer'){
                 c.Case_Senior_Field_Officer__c=loc.Team_Member__c;                 
                }
            if(loc.Member_Role__c=='Field Officer'){
               
                 c.Case_Field_Officer__c=loc.Team_Member__c;                 
          }
        }  
    }
}