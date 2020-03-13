global class SchoolsRenewalOpportunityCreator implements Schedulable{

    global void execute(SchedulableContext SC) {
        BatchCreateRenewalopportunitySchools batch = new BatchCreateRenewalopportunitySchools();
        database.executeBatch(batch,100);        
    }


    public static void scheduleThis(){
        String cronExp='0 0 4 15 * ?';
        
        try{
            System.schedule('SchoolsRenewalOpportunityCreator', cronExp, new SchoolsRenewalOpportunityCreator());
        }
        catch(Exception e){
          
        }
        
    }

}