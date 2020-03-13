trigger CreateNewRequisitions on Employee__c (after insert, before delete) {
        //Create the requisitions for assets as obtained from the RPM
        if(Trigger.isInsert){
        Employee__c[] employees=Trigger.new;
        
        //loop through array and find newly inserted record(s)
        for(Employee__c newEmployee:employees){
            Role_Property_Master__c[] RPM=[SELECT Item__c  FROM Role_Property_Master__c 
                                                    WHERE Job_Title__c=:newEmployee.Job_Title__c ];
                                                    
            //Loop through the RPM and create a requisition record for each item
            List<Asset_Requisition__c> requisitions=new List<Asset_Requisition__c>();
            for(Role_Property_Master__c requirements: RPM){
                requisitions.add(new Asset_Requisition__c(
                                                    Asset_status__c='Pending',
                                                    Date_From__c=Datetime.now(),
                                                    Department__c='IT',
                                                    Description__c=requirements.Item__c,
                                                    Duration__c='Long Term',
                                                    Employee__c=newEmployee.ID
                                                    //Name=newEmployee.Name
                                                    ));
            
            }//end inner for
            
            insert requisitions;
        }//end outer for
        }//end if
        
        
        //Delete all asset requisitions linked to the deleted employee
        else if(Trigger.isDelete){
            Employee__c[] employees=Trigger.old;
            for(Employee__c deletedEmployee:employees){
                List<Asset_Requisition__c> reqsToDelete=[SELECT Asset_status__c,
                                                                Date_From__c,
                                                                Date_Issued__c,
                                                                Date_To__c,
                                                                Department__c,
                                                                Description__c,
                                                                Duration__c,
                                                                Employee__c
                                                          FROM Asset_Requisition__c
                                                          WHERE Employee__c=:deletedEmployee.ID];
                                                          
              delete reqsToDelete;
            
            }
            
        }
}