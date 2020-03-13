global class ToiletsClosedNotificationSchedule implements Schedulable {
    global void execute(SchedulableContext sc){
        // Instantiate the ToiletsClosedNotification class
        // Process the Toilets in batches
        ToiletsClosedNotification toiletsClosed = new ToiletsClosedNotification();
        database.executeBatch(toiletsClosed);
    }
}