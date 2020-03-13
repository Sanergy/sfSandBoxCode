trigger EmployeeSharingTrigger on Employee__c (after insert) {
    /*if(trigger.isInsert){
        // Create a new list of sharing objects for Employee
        List<Employee__Share> EmployeeShrs  = new List<Employee__Share>();
        // Declare variables for recruiting and hiring manager sharing
        Employee__Share lineManagerShr;
        Employee__Share teamLeadShr;
        for(Employee__c Employee : trigger.new){
            // Instantiate the sharing objects
            lineManagerShr = new Employee__Share();
            teamLeadShr = new Employee__Share();

            // Set the ID of record being shared
            lineManagerShr.ParentId = Employee.Id;
            teamLeadShr.ParentId = Employee.Id;
            // Set the ID of user or group being granted access
            lineManagerShr.UserOrGroupId = Employee.Line_Manager_SF_Account__c;
            teamLeadShr.UserOrGroupId = Employee.Team_Lead_SF_Account__c;
            // Set the access level
            lineManagerShr.AccessLevel = 'edit';
            teamLeadShr.AccessLevel = 'read';
            // Set the Apex sharing reason for hiring manager and recruiter
            lineManagerShr.RowCause = Schema.Employee__Share.RowCause.Line_Manager_Reason__c;
            teamLeadShr.RowCause = Schema.Employee__Share.RowCause.Team_Lead_Reason__c;
            // Add objects to list for insert
            EmployeeShrs.add(lineManagerShr);
            EmployeeShrs.add(teamLeadShr);
        }
        // Insert sharing records and capture save result
        // The false parameter allows for partial processing if multiple records are passed
        // into the operation
        Database.SaveResult[] lsr = Database.insert(EmployeeShrs,false);
        // Create counter
        Integer i=0;
         
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default
                // access level are not allowed.
                // These sharing records are not required and thus an insert exception is
                // acceptable.
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION 
                                               &&  err.getMessage().contains('AccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    trigger.newMap.get(EmployeeShrs[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }  

    }
*/

}