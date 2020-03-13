trigger VIPaymentTrigger on Vendor_Invoice_Payment__c (before insert) {
    //check if the VI
    /*
    Map<String, Sanergy_Settings__c> sanergySettings = Sanergy_Settings__c.getAll();
    String loggedInUserID = UserInfo.getUserId();
    String authorizedUsers {get; set;}
    List<String> authorizedUsersList{get; set;}
    //Loop through the Sanergy Settings
    for(Sanergy_Settings__c settings : sanergySettings.values()) {
        if (settings.Name == 'Manual VI Payment') {                
            authorizedUsers = settings.Value__c;                
        }
    }
    //Split the values stored in 'Manual VI Payment' setting
    authorizedUsersList = authorizedUsers.split(',');
    System.debug('PERMITTED USERS: = ' + authorizedUsers);
    System.debug('PERMITTED USERS LIST: = ' + authorizedUsersList);
    
    for (String authorizedUserID : authorizedUsersList) {
        if(loggedInUserID == authorizedUserID){

            
        }//End if(loggedInUserID == authorizedUser)
        
        System.debug('loggedInUserID: =' + loggedInUserID);
        System.debug('authorizedUserID: =' + authorizedUserID);
    }//End f
*/
}