@isTest(seealldata=true)
public class OccurencesTestClass {
     
    
    
     /*----------------------------------Test sending emails when occurence is created------------------------------------------- */
  
      static testMethod void CreateNewOccurence(){
             //create a department
      Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
      
      // Create Sanergy Department Unit        
      Sanergy_Department_Unit__c sanergyDeptUnit = new Sanergy_Department_Unit__c();

      // Create Employee Role
        Employee_Role__c empRole = new Employee_Role__c();          
      
      // Create Employee
      Employee__c employee = new Employee__c();  

        //Create Department
        sanergyDept.Name = 'It department';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        INSERT sanergyDept;
        
        //create department unit
        sanergyDeptUnit.Name = 'Information Technology System';
        sanergyDeptUnit.Unit_Code__c = 'CORE';
        sanergyDeptUnit.Sanergy_Department__c = sanergyDept.Id;
        sanergyDeptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        sanergyDeptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        sanergyDeptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        sanergyDeptUnit.Talent_Partner__c = '005D0000003Ykhb';
        sanergyDeptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        INSERT sanergyDeptUnit;
          
                //Insert Employee Role 
        empRole.Name = 'Business Analyst';
        empRole.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        empRole.Company_Division__c = 'Sanergy';
        empRole.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        empRole.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        empRole.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        empRole.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        empRole.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        empRole.Talent_Partner__c = 'aAsD0000000GmgM';
        INSERT empRole;
        system.debug('Employee Role' + empRole);
          
        List<Recruitment_Requisition__c> recruitmentRequisitions = [SELECT ID,Name,Employee_Role__r.Department__c,Number_of_Required_Staff__c,Employee_Role__r.Line_Manager__c,
                                                                    Requesting_Department_Team_Lead__c,Employee_Role__r.Sanergy_Department_Unit__c,
                                                                  	Employee_Role__r.Sanergy_Department__c,Employee_Role__r.Id,Stage__c,
                                                                  	Requesting_Department__c,Location__c,Employee_Role__c
                                                                    //Number_Of_Created_Employees__c
                                                                  	FROM Recruitment_Requisition__c
                                                                  	Limit 1];  
          if(recruitmentRequisitions.size()>0){
       //Create an Employee
      //CREATE EMPLOYEE
        employee.Name = 'Jason';
        employee.Employee_First_Name__c = 'Jason';
        employee.Employee_Last_Name__c = 'Statham';
        employee.Recruitment_Requisition__c = recruitmentRequisitions.get(0).Id;
        employee.Primary_Phone__c = '0712345678';
        employee.Employment_Start_Date__c = date.today()+50;
        employee.Employee_Active__c = true;
        employee.Gender__c = 'Male';
        employee.Employment_Status__c = 'Permanent';
        employee.Employee_Role__c = empRole.Id;
        employee.Sanergy_Department_Unit__c = sanergyDeptUnit.Id;
        employee.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        employee.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        employee.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        employee.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        employee.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        employee.Talent_Partner__c = 'aAsD0000000GmgM';
        employee.Employee_SF_Account__c = '005D0000004ZrkJ';
        employee.Leave_Accrual_Start_Date__c = date.today()-50;
        employee.Employment_Start_Date__c = date.today() - 100;
       employee.Tickets_Created__c = false;

        INSERT employee;
      
      

      
      //create an Occurence
      Occurrence__c oc=new Occurrence__c(
                                      Name='',
                                      Sanergy_Department__c=sanergyDept.ID,
                                      Full_Description__c='Injury',
                                      Injured_Employee__c= employee.ID,
                                      Occurrence_Date__c=Date.today(),
                                      Why_1__c='Reason 1',
                                      Why_2__c='Reason 2',
                                      Why_3__c='Reason 3'
                                  );
      insert oc;
          }
 
      }
}