@isTest(seeAllData=True)
public class ReimbursementTest {
    static testMethod void ReimbursementTest(){
        
        
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
         // DIM2        
        List<FFA_Config_Object__c> 	dimTwo = [SELECT Id,Name,Type__c,isActive__c 
                                              FROM FFA_Config_Object__c 
                                              WHERE Type__c = 'dim2' 
                                              AND isActive__c = true LIMIT 1];
        //DIM3
        List<FFA_Config_Object__c> 	dimThree = [SELECT Id,Name,Type__c,isActive__c 
                                                FROM FFA_Config_Object__c 
                                                WHERE Type__c = 'dim3' 
                                                AND isActive__c = true LIMIT 1];
       //GLA 
        List<FFA_Config_Object__c> 	generalLedgerAcc = [SELECT Id,Name,Type__c,isActive__c 
                                                        FROM FFA_Config_Object__c 
                                                        WHERE Type__c = 'gla' 
                                                        AND isActive__c = true LIMIT 1];
        //Requesting Company
        List<FFA_Config_Object__c> 	reqCompany = [SELECT Id,Name,Type__c,isActive__c 
                                                  FROM FFA_Config_Object__c 
                                                  WHERE Type__c = 'company' 
                                                  AND isActive__c = true LIMIT 1];        
       
         //Grant 
        List<FFA_Config_Object__c> 	gran = [SELECT Id,Name,Type__c,isActive__c 
                                                  FROM FFA_Config_Object__c 
                                                  WHERE Type__c = 'dim4' 
                                                  AND isActive__c = true LIMIT 1];        

        
        
        //Create Department
        Sanergy_Department__c dept = new Sanergy_Department__c();
        dept.Name = 'It department';
        dept.Company__c = 'Sanergy';
        dept.Department_Code__c = 'CORE';
        dept.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        dept.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        INSERT dept;
        
        //create department unit
        Sanergy_Department_Unit__c deptUnit = new Sanergy_Department_Unit__c();
        deptUnit.Name = 'Information Technology System';
        deptUnit.Unit_Code__c = 'CORE';
        deptUnit.Sanergy_Department__c = dept.Id;
        deptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        deptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        deptUnit.Talent_Partner__c = '005D0000003Ykhb';
        deptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        INSERT deptUnit;
        
        //Insert Employee Role 
        Employee_Role__c empRole = new Employee_Role__c();
        empRole.Name = 'Business Analyst';
        empRole.Sanergy_Department_Unit__c = deptUnit.Id;
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
        
        //CREATE EMPLOYEE
      Employee__c emp = new Employee__c();
        emp.Name = 'Jason';
        emp.Employee_First_Name__c = 'Jason';
        emp.Employee_Last_Name__c = 'Statham';
        emp.Recruitment_Requisition__c = requisition.Id;
        emp.Primary_Phone__c = '0712345678';
        emp.Employment_Start_Date__c = date.today()+50;
        emp.Employee_Active__c = true;
        emp.Employment_Status__c = 'Permanent';
        emp.Employee_Role__c = empRole.Id;
        emp.Sanergy_Department_Unit__c = deptUnit.Id;
        emp.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        emp.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        emp.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        emp.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        emp.Talent_Partner_SF_Account__c = '005D0000003Ykhb';
        emp.Talent_Partner__c = 'aAsD0000000GmgM';
        
        INSERT emp;
        
        //Create Account 
        Account  acc = new Account();
        acc.Name = 'Dome Computers';
        acc.CurrencyIsoCode ='KES';
        acc.Type = 'Prospect';
        //acc.RecordType = 'Sanergy Toilet Sale - Prospect';
        insert acc;
        
        // Create Special Peocurement 
        Special_Procurement__c spr =  new Special_Procurement__c();
        spr.Requestor__c = 'aAsD0000000GmgM';
        spr.Type__c = 'Special Procurement';
        spr.Required_Date__c = date.today()+20;
        spr.Comments__c = 'spr comments';
        spr.Requesting_Department__c = department.get(0).Id;
        spr.Vendor__c = acc.Id;
        spr.CurrencyIsoCode ='KES';
        spr.Dim_2__c  = dimTwo.get(0).Id;
        spr.Dim_3__c =  dimThree.get(0).Id;
        spr.GLA__c = generalLedgerAcc.get(0).Id;
        spr.Grant__c = gran.get(0).Id;
        spr.Requesting_Company__c = reqCompany.get(0).Id;
        insert spr;
        
        //Create SPR Reconciliations
        Renconciling_Object__c recon = new Renconciling_Object__c();
        recon.Special_Payment_Request__c  = spr.Id;
        recon.CurrencyIsoCode = 'KES';
        recon.Expense_Description__c = 'A';
        insert recon;
     
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(spr);        
        Reimbursement reimbursementInstance = new Reimbursement(controller);

        reimbursementInstance.addRow();
        reimbursementInstance.save();
       // reimbursementInstance.deleteRow();
        
    }
}