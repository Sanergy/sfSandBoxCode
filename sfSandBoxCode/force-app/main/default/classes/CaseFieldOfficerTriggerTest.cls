@isTest(seealldata=true)
public class CaseFieldOfficerTriggerTest {
 static testMethod void testInstance(){
     
 // Generate test model
     
    List<Location_Team__c> loc = [SELECT Member_Role__c,Team_Member__c,Location__c, Location__r.of_Toilets__c
                                           FROM Location_Team__c
                                            WHERE Location__r.of_Toilets__c > 0
                                            AND (Member_Role__c='Associate'
                                            OR Member_Role__c='Assistant Manager')
                                            LIMIT 10];     
                                            
    List<Toilet__c> t = [SELECT id,Name,Location__c,location__r.name
                         FROM Toilet__c 
                         WHERE Location__c= :loc.get(0).Location__c
                         Limit 1];
     System.debug('Toilet: '+t.get(0).name+'  Location: '+t.get(0).location__r.name);
    
     List<Case_Timeliness__c> tm = [SELECT Name,Case_Category__c
                                           FROM Case_Timeliness__c
                                            WHERE Case_Category__c='Logistics' Limit 10];
     Case ces=new Case(); 
     ces.Toilet__c=t.get(0).Id;
     ces.Case_Type__c=tm.get(0).Id;    
     
     ces.Case_Root_Cause__c='Logistics error'; 
     
     ces.Location__c=t.get(0).Location__c;/*
     ces.Case_Field_Officer__c='';
     ces.Case_Senior_Field_Officer__c='';   */        
     insert ces;  
    
     // Perform test logic and Assert logic
    /*for(Case c:[SELECT Location__c FROM Case WHERE ID=:ces.Id]) {

                c.Location__c = t.get(0).Location__c;

            }*/
    // update ces;
    // System.assertEquals(ces.Location__c,t.get(0).Location__c);
    
    for ( Location_Team__c lc:[SELECT Member_Role__c,Team_Member__c FROM Location_Team__c WHERE ID=:loc.get(0).Id ] ){
    
    
             if(lc.Member_Role__c=='Assistant Manager'){
                  for(Case c:[SELECT Case_Senior_Field_Officer__c FROM Case WHERE ID=:ces.Id]) {

                     c.Case_Senior_Field_Officer__c = loc.get(0).Team_Member__c;
                       update ces;

                    }
                                 
                }
         //System.assertEquals(ces.Case_Senior_Field_Officer__c,null);
         
         
            if(lc.Member_Role__c=='Associate'){
                for(Case c:[SELECT Case_Field_Officer__c FROM Case WHERE ID=:ces.Id]) {

                     c.Case_Field_Officer__c = loc.get(0).Team_Member__c;

                    }              
                           
             }
         update ces;
       //  System.assertEquals(ces.Case_Field_Officer__c,null);
        }
   }
}