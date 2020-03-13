global class LeaveStartedSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
     // instantiate the LeaveStarted class
     // Process the leaves that have started\
        LeaveStarted c = new LeaveStarted();
        database.executeBatch(c);       
    }
}