trigger ToiletOperationalStatusUpdateCurrentRecord on Toilet_Operational_Status__c (before insert) {
    Toilet_Operational_Status__c[] Status=Trigger.new;
     for(Toilet_Operational_Status__c stat:Status){
         String ID=stat.Toilet_Status__c;
            List<Toilet_Operational_Status__c> CurrentToilet=[SELECT Date_To__c,Current_Record__c FROM Toilet_Operational_Status__c 
                                                          WHERE Current_Record__c=true
                                                          AND Toilet_Status__c=:ID];
                                                          
            for(Toilet_Operational_Status__c CurentStatus:CurrentToilet){
                if(stat.Current_Record__c==true && CurentStatus.Date_To__c==null){
                CurentStatus.Current_Record__c=false;
                CurentStatus.Date_To__c=date.today();
                }
           
            
            }
            update CurrentToilet;
     } 
}