trigger UpdateMeterReadingAssetMaintenanceTask on Asset_Maintenance_Task__c (before insert,before update) {
    
    //variable declarations
   /* List<Asset_Maintenance_Task__c> task = new List<Asset_Maintenance_Task__c>();
    Asset_Usage_Reading__c usage = new Asset_Usage_Reading__c();
    
    for(Asset_Maintenance_Task__c maint : Trigger.New){
        
        
        //update asset usage reading if meter reading is more than the last saved meter reading
        task = [SELECT Id, Meter_Reading__c from Asset_Maintenance_Task__c  order by Id desc limit 1];
        
        if(task.size() > 0){
            
            if(task.get(0).Meter_Reading__c > maint.Meter_Reading__c && task.get(0).Meter_Reading__c != null ){
                //save it to the  Asset Usage Reading Object
                usage.Date__c = maint.Service_Date__c;
                usage.Sanergy_Asset__c = maint.assetId__c;
                //usage.Units__c = maint.Metric__c;
                
                Insert maint;
                
                //get last meter reading and add the proposed meter reading to it
                if(task.get(0).Meter_Reading__c == null){
                    //assign a 0 to 
                    task.get(0).Meter_Reading__c = 0.0;
                    Integer meterRead = Integer.valueOf(task.get(0).Meter_Reading__c);
                    meterRead += Integer.valueOf(maint.Meter_Reading__c);
                    
                    //update the value
                    maint.Meter_Reading__c = meterRead;
                }
                
            }
        }
                
    }
*/
    
}