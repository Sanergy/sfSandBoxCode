global class ToiletsClosedReminderSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        // Instantiate the ToiletsClosedReminder class
        // Process the Toilets in batches
        ToiletsClosedReminder toiletsClosedReminder = new ToiletsClosedReminder();
        database.executeBatch(toiletsClosedReminder);
    }
}