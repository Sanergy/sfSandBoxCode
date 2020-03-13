global class ToiletStatusUpdateRemindersScheduler implements Schedulable{


    global void execute(SchedulableContext SC) {
        sendToiletStatusUpdateReminders.sendRemindersToSOPs(); 
    }


    public static void scheduleThis(){
        String cronExp='0 0 7 1 * ?';
        
        try{
            System.schedule('ToiletStatusUpdateRemindersScheduler', cronExp, new ToiletStatusUpdateRemindersScheduler());
        }
        catch(Exception e){
          
        }
        
    }

}