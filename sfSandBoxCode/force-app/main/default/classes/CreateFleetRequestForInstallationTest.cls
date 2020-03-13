@isTest(seeAllData=true)
private class CreateFleetRequestForInstallationTest{


     /*------------------Test Class for the ValidateEPR Trigger------------------------- */  
      static testMethod void CreateFleetRequestForInstallationTester() {
      
         List<Employee__c> employee=[SELECT ID FROM Employee__c WHERE Employee_Active__c=true LIMIT 1];
         List<Account> vendor=[SELECT ID FROM Account WHERE RecordType.Name='Sanergy Vendor' LIMIT 1];
         List<Opportunity> op=[SELECT id,Area__c,Sub_Area_Lookup__r.name,GPS_Longitude__c,GPS_Latitude__c FROM Opportunity WHERE RecordType.name='Toilet Sale - Launch Management' LIMIT 1];


          //get the department
          FFA_Config_Object__c department=[SELECT id, Delegate_s_Threshold_Amount__c FROM FFA_Config_Object__c WHERE Type__c='dim1' AND isActive__c=true AND Delegate_s_Threshold_Amount__c > 0 LIMIT 1];
          
           //get the location
          FFA_Config_Object__c location=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim2'  AND isActive__c=true LIMIT 1];


         //get the dim3
          FFA_Config_Object__c dim3=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim3'  AND isActive__c=true LIMIT 1];


         //get the dim4
          FFA_Config_Object__c grant=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim4'  AND isActive__c=true LIMIT 1];

            //create fleet request
         Fleet_Request__c request=new Fleet_Request__c(
             Company__c='Sanergy Ltd',
             Reason_For_Trip__c='Reason',
             Requesting_Department__c=department.id,
             Requesting_Employee__c=employee.get(0).id,
             Status__c='Open'
         );
         
         
          Fleet_Requests__c tripLeg=new Fleet_Requests__c(
            Fleet_Request_Status__c='Request Open',
            Reason_for_Trip__c='some reason goes here...',
            Company__c='Sanergy Ltd',
            Location_Dim_2__c=location.ID,
            Dim_3__c=dim3.ID,
            Grant_Funding_Availale_Dim_4__c=grant.ID,
            Pickup_Location__c='Kilimani',
            Destination__c='Mukuru',
            Departure_Date__c= Date.today()+30,
            Departure_Time__c='09:00',
            Cargo__c='Yes',
            Number_of_Passengers__c=2,
            Driver_Required__c='Yes',
            Cargo_Details__c='FLT Installation Materials',
            Vehicle_Type__c='Double Cab',
            Fleet_Request__c=request.id
        );
        
          
          
          
          test.StartTest();
          PageReference pageRef = Page.Create_Fleet_Request_For_Installation;
          Test.setCurrentPage(pageRef);
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(op.get(0));
          CreateFleetRequestForInstallation controller = new CreateFleetRequestForInstallation(sc);
          controller.fleet=request;
          controller.leg=tripLeg;
          controller.createRequest();
          test.StopTest(); 
    } 
  }