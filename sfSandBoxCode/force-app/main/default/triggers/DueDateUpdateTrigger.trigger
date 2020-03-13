trigger DueDateUpdateTrigger on Case (before insert, before update) {
            
         if(Trigger.isUpdate){
              for (Case c: Trigger.new) {
                  List<Case_Timeliness__c> ct= [SELECT ID,Agreed_Upon_Time_For_Resolution__c,Priority_Level__c,Case_Category__c
                                                FROM Case_Timeliness__c
                                                WHERE ID =:c.Case_Type__c];
                  if(ct.size()> 0 && ct.get(0).Agreed_Upon_Time_For_Resolution__c != null && c.Date_Reportedd__c != null) {
                      
                      
                      //update including Saturdays but exclude holidays
                      //c.Due_Date__c = c.CreatedDate + Integer.valueOf(ct.get(0).Agreed_Upon_Time_For_Resolution__c);
                      Integer daysForRes = Integer.valueOf(ct.get(0).Agreed_Upon_Time_For_Resolution__c);
                      
                      //Converting DateTime to Date
                      Date StartDate= c.CreatedDate.date();
                      
                      //get working days
                      c.Due_Date__c = SanergyUtils.AddBusinessDays(StartDate, daysForRes,TRUE ); 
                      c.Priority=ct.get(0).Priority_Level__c;
                      c.Case_Category__c=ct.get(0).Case_Category__c;
                      
            }
             
         }
      }else if(Trigger.isInsert){
          for (Case c2: Trigger.new) {
              
              List<Case_Timeliness__c> cl2= [SELECT ID,Agreed_Upon_Time_For_Resolution__c,Case_Category__c,Priority_Level__c
                                             FROM Case_Timeliness__c
                                             WHERE ID =:c2.Case_Type__c];
              if(cl2.size()> 0) {
                  
                  //DateTime f=DateTime.now();
                  //c2.Due_Date__c = f+ Integer.valueOf(cl2.get(0).Agreed_Upon_Time_For_Resolution__c);

                  Integer daysForRes2 = Integer.valueOf(cl2.get(0).Agreed_Upon_Time_For_Resolution__c);
                  
                  //get working days and include Saturdays
                  c2.Due_Date__c = SanergyUtils.AddBusinessDays(date.today(), daysForRes2,TRUE ); 
                  c2.Priority=cl2.get(0).Priority_Level__c;
                  c2.Case_Category__c=cl2.get(0).Case_Category__c;
                  
              }
          }
    }
}