global class InventoryItemsReplenisherScheduler implements Schedulable{


    global void execute(SchedulableContext SC) {
        Map<String, Sanergy_Settings__c> settings=Sanergy_Settings__c.getAll();        
        Integer batchSize = Integer.valueOf(settings.get('Inventory Replenisher Batch Size').value__c);
        
        InventoryItemsReplenisher batch=new InventoryItemsReplenisher();
        database.executeBatch(batch,batchSize );       
    }


    public static void scheduleThis(String name){
        String cronExp='0 0 1,13 * * ?';
        String jobName = (name == null || name == '') ? 'InventoryItemsReplenisherScheduler' : name;
        
        try{
            System.schedule('InventoryItemsReplenisherScheduler', cronExp, new InventoryItemsReplenisherScheduler());
        }
        catch(Exception e){
          
        }
        
    }

}