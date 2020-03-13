global class AssetMaintenanceScheduler implements Schedulable {


    public date myDate = date.today();		
	public Integer day = myDate.day();		
	static Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
	public String dayOfWeek = dt.format('EEEE');
	
	   
           global void execute(SchedulableContext sc)
        {
            getTasks();
        }

    public void getTasks(){
              	        
        List<Asset_Maintenance_Schedule__c> listAMS = [SELECT ID,Employee__c,OwnerId,Active__c,User__c,User__r.Id,Checkpoint__c,Name,Comments__c,Date__c,
                                                       Frequency__c,Maintenance_Type__c,Owner__c,Sanergy_Asset__c,
                                                       Status__c,Task_Name__c,Tool__c
                                                       FROM Asset_Maintenance_Schedule__c 
                                                       WHERE Active__c = true AND Status__c = 'Confirmed' AND
                                                      Frequency__c = 'Daily' AND User__c != null];

        for(Asset_Maintenance_Schedule__c AMS : listAMS)
            {
                Task task = new Task();
                task.Employee__c = AMS.Employee__c;
                task.OwnerId = AMS.User__r.Id;
                task.Subject = 'Other';
                task.WhatId = AMS.Sanergy_Asset__c;
                task.ActivityDate = Date.today();
                task.Goals__c = AMS.Name;
                task.Description = AMS.Task_Name__c;
                //task.WhoId = AMS.;
                insert task;
            }
        
        if(dayOfWeek == 'Monday'){
            
             List<Asset_Maintenance_Schedule__c> listAMS2 = [SELECT ID,OwnerId,User__r.Id, User__c,Active__c,Checkpoint__c,Name,Comments__c,Date__c,
                                                       Employee__c,Frequency__c,Maintenance_Type__c,Owner__c,Sanergy_Asset__c,
                                                       Status__c,Task_Name__c,Tool__c
                                                       FROM Asset_Maintenance_Schedule__c 
                                                       WHERE Active__c = true AND Status__c = 'Confirmed' AND
                                                      Frequency__c = 'Weekly' AND User__c != null];

        for(Asset_Maintenance_Schedule__c AMS : listAMS2)
            {
                Task task = new Task();
                task.Employee__c = AMS.Employee__c;
                task.OwnerId = AMS.User__r.Id;
                task.Subject = 'Other';
                task.WhatId = AMS.Sanergy_Asset__c;
                task.ActivityDate = Date.today();
                task.Goals__c = AMS.Name;
                task.Description = AMS.Task_Name__c;
                //task.WhoId = AMS.id;
                insert task;
            }
        	}
        if(day == 1 ){
            
             List<Asset_Maintenance_Schedule__c> listAMS3 = [SELECT ID,OwnerId,User__r.Id,User__c,Active__c,Checkpoint__c,Name,Comments__c,Date__c,
                                                       Frequency__c,Maintenance_Type__c,Owner__c,Sanergy_Asset__c,
                                                       Status__c,Task_Name__c,Tool__c
                                                       FROM Asset_Maintenance_Schedule__c 
                                                       WHERE Active__c = true AND Status__c = 'Confirmed' AND
                                                       Frequency__c = 'Monthly' AND User__c != null];

        for(Asset_Maintenance_Schedule__c AMS : listAMS3)
            {
                Task task = new Task();
                task.Employee__c = AMS.Employee__c;
                task.OwnerId = AMS.User__r.Id;
                task.Subject = 'Other';
                task.WhatId = AMS.Sanergy_Asset__c;
                task.ActivityDate = Date.today();
                task.Goals__c = AMS.Name;
                task.Description = AMS.Task_Name__c;
                //task.WhoId = AMS.;
                insert task;
            }
        	}


        }
         
}