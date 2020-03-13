trigger SetTimeBeforeSave on SweetSense_Sanergy_Int__c (before insert, before update) {
    
    for(SweetSense_Sanergy_Int__c sss: Trigger.new){
        if(sss.timeStamp__c != null){
            
            DateTime dt = DateTime.newInstance(sss.timeStamp__c.longValue());
            
            sss.Time__c = dt;
        }
    }
}