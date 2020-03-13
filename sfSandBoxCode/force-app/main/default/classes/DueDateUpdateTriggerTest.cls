@isTest(seealldata=true)
public class DueDateUpdateTriggerTest {
	static testMethod void testDueDateTrigger(){
     
 // Generate test model
 	List<Toilet__c> t = [SELECT id,Name,Location__c,location__r.name
                                           FROM Toilet__c 
                         WHERE Location__c !='' Limit 1];
     System.debug('Toilet: '+t.get(0).name+'  Location: '+t.get(0).location__r.name);
       
     List<Case_Timeliness__c> tm = [SELECT Name,Agreed_Upon_Time_For_Resolution__c,Priority_Level__c,Case_Category__c
                                           FROM Case_Timeliness__c
                                    WHERE Case_Category__c='Logistics' Limit 1];
     System.debug(tm);   
     Case ces=new Case(); 
     ces.Case_Type__c=tm.get(0).Id;    
     
     ces.Case_Root_Cause__c='Logistics error'; 
     ces.Toilet__c=t.get(0).Id;
     ces.Location__c=t.get(0).Location__c;
   //  ces.Date_Reported__c=DateTime.now(); 
     
     insert ces;  
    
     // Perform test logic and Assert logic
    System.assertEquals(ces.Location__c,t.get(0).Location__c);
    
    for ( Case_Timeliness__c lc:[SELECT Name,Agreed_Upon_Time_For_Resolution__c,Priority_Level__c,Case_Category__c
                                 FROM Case_Timeliness__c WHERE ID=:ces.Case_Type__c ] ){
                                     ces.Priority=lc.Priority_Level__c;
                                    // System.assertEquals(ces.Date_Reported__c,DateTime.now());
                                     System.assertEquals(ces.Priority,lc.Priority_Level__c);
     System.debug('LC: '+lc.Agreed_Upon_Time_For_Resolution__c);                                
    ces.Due_Date__c = DateTime.now()+ Integer.valueOf(lc.Agreed_Upon_Time_For_Resolution__c);
                                    System.debug(ces.Due_Date__c); 
                                     update ces;
                                 }
   }
}