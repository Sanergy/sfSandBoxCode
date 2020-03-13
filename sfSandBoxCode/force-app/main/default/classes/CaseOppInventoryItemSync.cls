global class CaseOppInventoryItemSync implements Schedulable{


    global void execute(SchedulableContext SC) {
        SyncCaseOppInventoryItems.syncItems();       
    }


    public static void scheduleThis(){
        String cronExp='0 0 3 * * ?';
        
        try{
            System.schedule('CaseOppInventoryItemSync', cronExp, new CaseOppInventoryItemSync());
        }
        catch(Exception e){
          
        }
        
    }

}