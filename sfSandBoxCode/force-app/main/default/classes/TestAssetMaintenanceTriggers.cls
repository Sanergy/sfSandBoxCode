@isTest(seealldata=true)
public class TestAssetMaintenanceTriggers {
    
    
    static testMethod void TestOutbound() {

        Sanergy_Asset__c asset = new Sanergy_Asset__c(
          RecordType = new RecordType(Name = 'Computers'),
          Asset_Name__c = 'Test Asset',
          Manufacturer__c='Dell',
          Make__c='Latitude',
          Model__c='E 6400',
          Operating_System__c = 'Windows',
          Active__c=true
        );
        insert asset;
        
        Account a = new Account(Name = 'Nala', RecordType = new RecordType(Name = 'Sanergy Vendor'));
        insert a;
        
        AssetMaintenance__c maintenance = new AssetMaintenance__c(
            Service_Reason__c = 'Test Reason',
            Vendor__c = a.Id,
            Asset__c = asset.Id,
            Date_Taken__c = System.today()
        );
        insert maintenance;
        
        Sanergy_Asset__c savedasset = [SELECT ID, Asset_Name__c, Asset_Status__c FROM Sanergy_Asset__c WHERE ID = :asset.ID];
       
        System.assertEquals(savedasset.Asset_Status__c, 'Out for 3rd Party Repair');
    }
    
   
    static testMethod void TestReceive() {
        // Get dim1                              
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
                
               
        // Create Sanergy Department - RecordType - Sanergy
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

        //
        Recruitment_Requisition__c requisition = new Recruitment_Requisition__c();
        requisition.Name = 'Business Analyst';
        requisition.Requestor__c = 'aAsD000000001S7';
        requisition.Talent_Partner__c = '005D0000003Ykhb';
        requisition.Employee_Role__c = empRole.Id;
        requisition.Request_Date__c = date.today()+30;
        requisition.Number_of_Required_Staff__c = 5;
        requisition.Job_Description__c = 'ANALYSIS';
        requisition.Justification_for_new_position__c = 'Test';
        requisition.Type_of_employment__c = 'Permanent';
        requisition.Duration_of_Fixed_term_Contract_Months__c = 1;
        requisition.Is_recruitment_budgeted__c = 'yes';
        requisition.Candidate_Specification__c = 'Kenyan';
        requisition.Proposed_Employee_required_Date__c = date.today()+40;
        requisition.Location__c = 'Mukuru';
        requisition.Requesting_Department__c = department.get(0).Id;
        INSERT requisition;         
        
        
        
        Sanergy_Asset__c asset = new Sanergy_Asset__c(
          RecordType= new RecordType(Name = 'Computers'),
          Asset_Name__c = 'Test Asset',
          Manufacturer__c='Dell',
          Make__c='Latitude',
          Model__c='E 6400',
          Operating_System__c = 'Windows',
          Active__c=true
        );
        insert asset;
        
        Account a = new Account(Name = 'Nala', RecordType = new RecordType(Name = 'Sanergy Vendor'));
        insert a;
       
         AssetMaintenance__c maintenance = new AssetMaintenance__c(
            Service_Reason__c = 'Test Reason',
            Vendor__c = a.Id,
            Asset__c = asset.Id,
            Date_Taken__c = System.today()
        );
        insert maintenance;
        
        System.assertNotEquals(maintenance.ID, Null);

      //CREATE EMPLOYEE
        employee.Name = 'Jason';
        employee.Employee_First_Name__c = 'Jason';
        employee.Employee_Last_Name__c = 'Statham';
        employee.Recruitment_Requisition__c = requisition.Id;
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
        
        maintenance.Diagnosis__c = 'Service Ok';
        maintenance.Solution__c = 'Parts replaced';
        maintenance.Cost_of_Repairs__c = 100.00;
        maintenance.Received_On__c = System.today();
        maintenance.Received_by__c = employee.Id;
        maintenance.Status__c = 'Fixed';
        
        update maintenance;
        
        Sanergy_Asset__c savedasset = [SELECT Id, Asset_Name__c, Asset_Status__c FROM Sanergy_Asset__c WHERE ID = :asset.ID];
       
        System.assertEquals(savedasset.Asset_Status__c, 'Inventory');
    }
}