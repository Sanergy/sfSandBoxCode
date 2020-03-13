@istest(seeAllData=true)
 public class FleetRequestTestClass{
 
    //test for tripLegTrigger trigger
    static testMethod void tripLegTriggerTest() {
       
       
        
         //get an employee
         List<Employee__c> employee=[SELECT ID FROM Employee__c WHERE Employee_Active__c=true LIMIT 1];
         
         //create a Sanergy Employee record
         Employee_Drivers__c empDriver=new Employee_Drivers__c(
             Employee__c=employee.get(0).id
         );
         
         insert empDriver;
         
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
         
         
          List<Fleet_Requests__c> legs=new List<Fleet_Requests__c>();
          
          Fleet_Requests__c tripLeg=new Fleet_Requests__c(
            Reason_for_Trip__c='some reason goes here...',
            Fleet_Request_Status__c='Request Open',
            Company__c='Sanergy Ltd',
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
            Vehicle_Type__c='No Preference',
            Fleet_Request__c=request.id,
            Total_Estimated_Cost__c=1000
        );
        
         Fleet_Requests__c tripLeg2=new Fleet_Requests__c(
            Reason_for_Trip__c='some reason goes here...',
            Fleet_Request_Status__c='Request Open',
            Company__c='Sanergy Ltd',
            Location_Dim_2__c=location.get(0).ID,
            Dim_3__c=dim3.get(0).ID,
            Grant_Funding_Availale_Dim_4__c=dim4.get(0).ID,
            Pickup_Location__c='Kilimani',
            Destination__c='Mukuru',
            Departure_Date__c= Date.today()+30,
            Departure_Time__c='12:00',
            Cargo__c='No',
            Number_of_Passengers__c=2,
            Driver_Required__c='No',
            Vehicle_Type__c='No Preference',
            Fleet_Request__c=request.id,
            Total_Estimated_Cost__c=1000
        );
        
        legs.add(tripLeg);
        legs.add(tripLeg2);
        
        insert legs;
        
        //change department
         request.Requesting_Department__c=department.get(1).id;
         request.Status__c='Team Lead Approved';
         update request;
        
        delete tripLeg2;
        
        //change amount
        tripLeg.Total_Estimated_Cost__c=2000;
        tripLeg.Fleet_Request_Status__c='Trip Completed';
        update tripLeg; 
        
        
    }
   
    
   
    //test for CreateEPRFromtripLeg controller
    static testMethod void CreateEPRFromtripLegTest() {
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
        
        test.StartTest();
        PageReference pageRef = Page.Create_EPR_From_Fleet_Request;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(tripLeg);
        CreateEPRFromFleetRequest controller = new CreateEPRFromFleetRequest(sc);
        controller.createEPR();
        test.StopTest(); 
    }
 
    
     //test for CreateJournalEntryFromtripLeg controller
    static testMethod void CreateJournalEntryFromtripLegTest() {
        //get an employee
         List<Employee__c> employee=[SELECT ID FROM Employee__c WHERE Employee_Active__c=true LIMIT 1];
         
         //create a Sanergy Employee record
         Employee_Drivers__c empDriver=new Employee_Drivers__c(
             Employee__c=employee.get(0).id
         );
         
         insert empDriver;
         
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
            Requesting_Employee__c=employee.get(0).ID,
            Requesting_Department__c=department.get(0).ID,
            Reason_for_Trip__c='some reason goes here...',
            Fleet_Request_Status__c='Request Open',
            Company__c='Sanergy Ltd',
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
            Fleet_Request_Category__c='Internal Fleet',
            End_Mileage__c=  111111,
            Start_Mileage__c=111100,
            Designated_Driver__c=empDriver.id,
            Fleet_Request__c=request.id
        );
        
        insert tripLeg;
        
        //create a journal scheduler
        List<c2g__codaJournal__c> journal=[SELECT ID FROM c2g__codaJournal__c WHERE
                                           c2g__JournalStatus__c='In Progress' AND c2g__OwnerCompany__r.Name = 'Sanergy Limited' LIMIT 1];
        
        Fleet_Journal_Scheduler__c fjs=new Fleet_Journal_Scheduler__c(
            Company__c=tripLeg.Company__c,
            Current_Journal__c=true,
            End_date__c=(tripLeg.Departure_Date__c).addMonths(1).toStartOfMonth(),
            Journal__c=journal.get(0).id,
            Start_date__c=(tripLeg.Departure_Date__c).toStartOfMonth()
        );
        
        insert fjs;
        
        test.StartTest();
        
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
         System.runAs(userFFA.get(0)){
                PageReference pageRef = Page.Create_Journal_Line_From_Fleet_Request;
                Test.setCurrentPage(pageRef);
                ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(tripLeg);
                CreateJournalEntryFromFleetRequest controller = new CreateJournalEntryFromFleetRequest(sc);
                //controller.createJournalLineEntry(); //Commented 2020-03-05 causing error on JNL Creation and not using Fleet any more
            }
         }
        test.StopTest(); 
     }
    
    
}