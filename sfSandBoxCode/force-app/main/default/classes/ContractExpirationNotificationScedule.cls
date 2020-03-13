global class ContractExpirationNotificationScedule implements Schedulable {
    global void execute(SchedulableContext sc){
        // Instantiate the ContractExpirationNotification class
        // Process the contracts in batches
        ContractExpirationNotification c = new ContractExpirationNotification();
        database.executeBatch(c);
    }
}