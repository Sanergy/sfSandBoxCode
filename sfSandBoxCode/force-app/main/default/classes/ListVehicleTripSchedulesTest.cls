@istest(seeAllData=true)
 public class ListVehicleTripSchedulesTest{
 
    
   
    //test for CreateEPRFromtripLeg controller
    static testMethod void ListVehicleTripSchedulesTester() {
         //get an employee
         List<Employee__c> employee=[SELECT ID FROM Employee__c WHERE Employee_Active__c=true LIMIT 1];
         List<Account> vendor=[SELECT ID FROM Account WHERE RecordType.Name='Sanergy Vendor' LIMIT 1];
         
         List<user> owner=[SELECT ID FROM User WHERE Profile.name='System Administrator' AND IsActive=true];
       
         
         //get department
         List<FFA_Config_Object__c> department=[SELECT ID FROM FFA_Config_Object__c WHERE Type__c='dim1' AND isActive__c=true LIMIT 2];
          //get location
         List<FFA_Config_Object__c> location=[SELECT ID FROM FFA_Config_Object__c WHERE Type__c='dim2' AND isActive__c=true LIMIT 1];
          //get dim 3
         List<FFA_Config_Object__c> dim3=[SELECT ID FROM FFA_Config_Object__c WHERE Type__c='dim3' AND isActive__c=true LIMIT 1];
          //get dim 4(Grant)
         List<FFA_Config_Object__c> dim4=[SELECT ID FROM FFA_Config_Object__c WHERE Type__c='dim4' AND isActive__c=true LIMIT 1];
         
         //create fleet request
         Fleet_Request__c request=new Fleet_Request__c(
             Company__c='Sanergy Ltd',
             Reason_For_Trip__c='Reason',
             Requesting_Department__c=department.get(0).id,
             Requesting_Employee__c=employee.get(0).id,
             Status__c='Open'
         );
         
         insert request;
         
          Fleet_Requests__c tripLeg=new Fleet_Requests__c(
            Fleet_Request_Status__c='Request Open',
            Reason_for_Trip__c='some reason goes here...',
            Company__c='Fresh Life Initiative Ltd',
            Location_Dim_2__c=location.get(0).ID,
            Dim_3__c=dim3.get(0).ID,
            Grant_Funding_Availale_Dim_4__c=dim4.get(0).ID,
            Pickup_Location__c='Kilimani',
            Destination__c='Mukuru',
            Departure_Date__c= Date.today()+30,
            Departure_Time__c='09:00',
            Cargo__c='No',
            Number_of_Passengers__c=2,
            Driver_Required__c='No',
            Vehicle_Type__c='Double Cab',
            Fleet_Request_Category__c='External Fleet',
            Recommended_Vendor__c=vendor.get(0).id,
            Scheduled_Payment_Date__c=Date.today()+14,
            Total_Estimated_Cost__c=5000,
            Total_Actual_Cost__c=5000,
            Fleet_Request__c=request.id
        );
        
        insert tripLeg;
        
        List<Sanergy_Asset__c> vehicles=[SELECT Registration_Number__c,name,id
                                     FROM Sanergy_Asset__c
                                     WHERE RecordType.name='Vehicles' LIMIT 1];
        
        test.StartTest();
        PageReference pageRef = Page.List_Fleet_Trip_Vehicle_Schedules;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(tripLeg);
        ListVehicleTripSchedules controller = new ListVehicleTripSchedules(sc);
        controller.getVehicles();
        controller.getSelectedVehice();
        
        if(vehicles.size()>0){
            controller.processSelected();
            controller.setSelectedVehice(vehicles.get(0).id);
            controller.selectVehicle();
        }
        
        
        test.StopTest(); 
    }  
}