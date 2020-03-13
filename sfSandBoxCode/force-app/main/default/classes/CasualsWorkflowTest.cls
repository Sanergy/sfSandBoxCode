@isTest(seeAllData=true)
private class CasualsWorkflowTest{
    static testMethod void CasualsWorkflowTester() {
        /*--------------------create a new Casual Job------------------------------- 
        //get a department
        List<Sanergy_Department__c> deptList=[SELECT id FROM Sanergy_Department__c 
                                              WHERE Team_Lead__c <> null LIMIT 1];
                                              
         if(deptList.size()>0){
             Casuals_Job__c job=new Casuals_Job__c(
                 Sanergy_Department__c=deptList.get(0).id,
                 Start_Date__c=Date.today(),
                 End_Date__c=Date.today().addMonths(3),
                 Description__c='Some random decsription'
             );
             
             insert job;
             System.debug('Job Inserted');
             
           
           
           /*--------------------create a new Casual Job Line Item-------------------------------
             //create FFA Config Object records 
             c2g__codaDimension1__c dim1=new c2g__codaDimension1__c(name='AS Finance', c2g__ReportingCode__c='1');  insert dim1;
             c2g__codaDimension2__c dim2=new c2g__codaDimension2__c(name='Kilimani', c2g__ReportingCode__c='2');  insert dim2;
             c2g__codaDimension3__c dim3=new c2g__codaDimension3__c(name='Products', c2g__ReportingCode__c='3');  insert dim3;
             c2g__codaDimension4__c dim4=new c2g__codaDimension4__c(name='Of farm', c2g__ReportingCode__c='4');  insert dim4;
             
             List<FFA_Config_Object__c> ffaConfigList=new List<FFA_Config_Object__c>();
             
             FFA_Config_Object__c ffaConfigDim1=[SELECT ID FROM FFA_Config_Object__c  WHERE Name='AS Finance' AND lookup_ID__c=:dim1.id];
             FFA_Config_Object__c ffaConfigDim2=[SELECT ID FROM FFA_Config_Object__c  WHERE Name='Kilimani' AND lookup_ID__c=:dim2.id];
             FFA_Config_Object__c ffaConfigDim3=[SELECT ID FROM FFA_Config_Object__c  WHERE Name='Products' AND lookup_ID__c=:dim3.id];
             FFA_Config_Object__c ffaConfigDim4=[SELECT ID FROM FFA_Config_Object__c  WHERE Name='Of farm' AND lookup_ID__c=:dim4.id];
             
             Casual_Job_Line_Item__c testJobLine=new Casual_Job_Line_Item__c(
                 Casuals_Job__c=job.id,
                 Grade__c='General Labouror',
                 Start_Date__c=date.today(),
                 End_Date__c=date.today().addMonths(3),
                 Department_Dim_1__c=ffaConfigDim1.id,
                 Location_Dim_2__c=ffaConfigDim2.id,
                 Grant_Dim_4__c=ffaConfigDim4.id,
                 Rate__c=500,
                 Rate_Units__c='Per Day',
                 Quantity__c=10
             );
             
             insert testJobLine;
              System.debug('Job Line Inserted');
              
              
             
               
               
               /*--------------------create a new Casual Record-------------------------------
               Account acc=[SELECT id FROM Account WHERE Type='Vendor' LIMIT 1];
               Casual__c testCasual=new Casual__c(
                   Account__c=acc.id,
                   Contractual_Start_Date__c=Date.today(),
                   Contractual_End_Date__c=Date.today().addMonths(3),
                   ID_Number__c='11111111'
               );
               insert testCasual;
               
               c2g__codaCompany__c company=[Select Id From c2g__codaCompany__c WHERE Name='Sanergy Limited' LIMIT 1];
               
               /*--------------------create a new Casual-job assignment------------------------------
                Casuals_Job_Assignment__c testAssignment=new Casuals_Job_Assignment__c(
                    Casual_Job_Line_Item__c=testJobLine.id,
                    Casual__c=testCasual.id,
                    Grade__c='General Labouror',
                    FFA_Company__c=company.id,
                    Start_Date__c=Date.today(),
                    End_Date__c=Date.today().addMonths(3),
                    Location__c='Nairobi'
                );
                
                insert testAssignment;
               /* Integer countAssignmentAllowance=[SELECT count() FROM Casual_Job_Assignment_Allowances__c 
                                         WHERE Casual_Job_Assignment__c=:testAssignment.id];
                                         
                  System.assert(countAssignmentAllowance==1);
                  */
                  
              /*--------------------create a new Casual Timesheet------------------------------
              Casuals_Timesheet__c testTimeSheet=new Casuals_Timesheet__c(
                  Job_Requisition__c=testAssignment.id,
                   Start_Date__c=Date.today(),
                  End_Date__c=Date.today().addDays(20),
                  Total_Days__c=20,
                  Total_hours__c=200,
                  Rate_Units_Quantity__c=12
              );
              insert testTimeSheet;
              
               Integer countTimesheetAllowance=[SELECT count() FROM Casuals_Timesheet_Allowance__c
                                         WHERE Casuals_Timesheet__c=:testTimeSheet.id];
                                         
               System.assert(countTimesheetAllowance==1);
          
            }   
         */ } 
    }