global class RenewalOpportunityCreator implements Schedulable{


    global void execute(SchedulableContext SC) {
        BatchCreateRenewalOpportunity batch = new BatchCreateRenewalOpportunity();
        database.executeBatch(batch,100);        
    }


    public static void scheduleThis(){
        String cronExp='0 0 4 15 * ?';
        
        try{
            System.schedule('RenewalOpportunityCreator', cronExp, new RenewalOpportunityCreator());
        }
        catch(Exception e){
          
        }
        
    }

}