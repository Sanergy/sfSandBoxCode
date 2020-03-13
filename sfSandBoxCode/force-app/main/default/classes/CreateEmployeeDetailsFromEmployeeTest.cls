@isTest(seeAllData=True)
public class CreateEmployeeDetailsFromEmployeeTest {
    static testMethod void CreateEmployeeDetailsFromEmployeeTest(){
        
        
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
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
        
        //Test AllowanceApprover Trigger on Update
        deptUnit.Approver__c = '005D0000001qz2K';
        UPDATE deptUnit;
        
        deptUnit.Approver__c = '005D0000003Ykhb';
        UPDATE deptUnit;
        
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
        
        //insert user
        User usr = new User();
        usr.LastName = 'David';
        usr.Alias = 'Dave';
        usr.Email = 'johndoe12345@saner.gy';
        usr.Username = 'johndoe12345@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        INSERT usr; 
        
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
        emp.User__c = usr.id;
        
        INSERT emp;
 
         
        //Select User           
        //List<User> usr = [SELECT LastName,Alias,Email,Username,CommunityNickname,ProfileId,EmailEncodingKey FROM User LIMIT 1];
       
        //Testing PayrollModificationApprovers
        emp.User__c = '005D0000003Ykhb';
        UPDATE emp;

        emp.User__c = '005D0000001qz2K';
        UPDATE emp;
        
        //Create Dimension2
        /** c2g__codaDimension2__c dim2 = new c2g__codaDimension2__c();
dim2.Name = 'Chukadd';
dim2.c2g__ReportingCode__c = 'Chuka5667';
INSERT dim2;**/
        
        //Select Dim2
        c2g__codaDimension2__c dim2 = [SELECT Name,c2g__ReportingCode__c FROM c2g__codaDimension2__c LIMIT 1];
        
        
        //create companies
        c2g__codaCompany__c comp = new c2g__codaCompany__c();
        comp.Name = 'Sanergy';
        comp.CurrencyIsoCode = 'KES';
        INSERT comp;
        
        //Create Dimension1
        c2g__codaDimension1__c dim1 = new c2g__codaDimension1__c();
        dim1.Name = 'Finance';
        dim1.c2g__ReportingCode__c = 'FIN-567890';
        INSERT dim1;
        
        //create employee job info
        Employee_Job_Information__c jobInfo = new Employee_Job_Information__c();
        jobInfo.Effective_Date__c = date.today()+2;
        jobInfo.Location__c = dim2.Id;
        jobInfo.Company__c = comp.Id;
        jobInfo.Department__c = dim1.id;
        jobInfo.Job_Title__c = empRole.Id;
        jobInfo.Reports_To__c = emp.Id;
        INSERT jobInfo;
        
        //Create Leave Entilement Utilization
        Leave_Entitlement_Utilization__c entl = new Leave_Entitlement_Utilization__c();
        entl.Employee__c = emp.Id;
        INSERT entl;
        
        //Create Leave Accrual 
        Leave_Accrual__c accrual = new Leave_Accrual__c();
        //accrual.Name = 'Exam Leave';
        accrual.Leave_Entitlement_Utilization__c = entl.Id;
        accrual.CurrencyIsoCode = 'KES';
        INSERT accrual;
        
        //Create Employee Leave Request
        Employee_Leave_Request__c leaveRequest = new Employee_Leave_Request__c();
        leaveRequest.Leave_Entitlement_Utilization__c = entl.Id;
        leaveRequest.Employee__c = emp.Id;
        leaveRequest.Leave_Start_Date__c = date.today()+2;
        leaveRequest.Leave_End_Date__c = date.today()+10;
        leaveRequest.Department_Team_Lead__c = '005D0000003Ykhb';
        INSERT leaveRequest;
        
        //CREATE EMPLOYEE ASSET
        Sanergy_Asset__c asset = new Sanergy_Asset__c();
        asset.Asset_Name__c = 'Laptop';
        asset.Operating_System__c ='Mac';
        asset.Manufacturer__c = 'apple';
        asset.Make__c = 'lg';
        asset.Model__c = 'first Generation';
        asset.Active__c = True;
        INSERT asset; 
        
        //Create Employee Asset
        // Sanergy_Asset__c asset = [SELECT Asset_Name__c FROM Sanergy_Asset__c LIMIT 1];
        
        //Create sanergy asset issuance
        Sanergy_Assets_Issuance__c assetIssuance = new Sanergy_Assets_Issuance__c();
        assetIssuance.Asset_ID__c = asset.Id;
        assetIssuance.Employee__c = emp.Id;
        assetIssuance.Issue_Type__c = 'Permanent issue to employee';
        assetIssuance.Date_Issued__c = date.today()+3;
        INSERT assetIssuance;
        
        assetIssuance.Date_Issued__c = date.today()+4;
        UPDATE assetIssuance;
        
        //Create Payroll Modification
        /**Staff_Allowances__c allowance = new Staff_Allowances__c();
        allowance.Allowance_Type__c = 'Meal Allowance';
        allowance.Employee__c = emp.Id;
        allowance.Allowance_Description__c = 'Should be given';
        allowance.Start_Date__c = date.today()+20;
        allowance.Allowance_Frequency__c = 'Monthly';
        allowance.Department_Unit__c = deptUnit.Id;
        allowance.Sanergy_Department__c = dept.id;
        allowance.End_Date__c = date.today()+60;
        INSERT allowance; **/
        List<Staff_Allowances__c> allowance = [SELECT Id,Allowance_Type__c,Employee__c,Allowance_Description__c,Start_Date__c,Allowance_Frequency__c,
                                               Department_Unit__c,Sanergy_Department__c,End_Date__c
                                               FROM Staff_Allowances__c 
                                               WHERE Employee__c =:  emp.Id 
                                               LIMIT 1];
        
        //Create Employee Vaccinations
        Employee_Vaccination__c vaccine = new Employee_Vaccination__c();
        vaccine.Employee__c = emp.Id;
        vaccine.Vaccination__c = 'cholera';
        vaccine.Dose__c = '3';
        vaccine.Due_Date__c = date.today()+4;
        INSERT vaccine;
        
        //Create Employee Banking Information
        Employee_Banking_Information__c bank = new Employee_Banking_Information__c();
        bank.Employee__c = emp.Id;
        bank.BI_Effective_Date__c = date.today()+10;
        bank.BI_Bank_Name__c = 'Equity';
        bank.BI_Bank_Branch__c ='CBD TOWN CENTER';
        bank.BI_Bank_Account_Number__c = '300009833';
        bank.BI_Bank_Title__c = 'No Title';
        bank.BI_Comments__c = 'No comments';
        bank.CurrencyIsoCode = 'KES';
        INSERT bank;
        
        // Create  Employee Training Record
        Employee_Training_Programme__c empTrainingRec = new  Employee_Training_Programme__c();
        empTrainingRec.Name__c = 'Record One';
        empTrainingRec.Category__c = 'Leadership';
        empTrainingRec.Mandatory__c ='yes';
        INSERT empTrainingRec;
        
        //Create Currency Config
        Currency_Config__c currencyCon = new Currency_Config__c();
        currencyCon.Name = 'Currency Name';
        currencyCon.Start__c = date.today()+20;
        currencyCon.Value__c = 4567;
        currencyCon.Currency_Name__c = 'Euro';
        INSERT currencyCon;      
        
        //Create Employee Training 
        Employee_Training__c empTraining = new Employee_Training__c();
        empTraining.Employee__c = emp.Id;
        empTraining.Employee_Training_Record__c = empTrainingRec.Id;
        empTraining.Training_Completion_Date__c = date.today()+10;
        empTraining.Currency__c = currencyCon.Id;
        INSERT empTraining;
        
        
        //Create Employee Benefit plan 
        Employee_Benefits_Plan__c empBenefitPlan = new Employee_Benefits_Plan__c();
        empBenefitPlan.CurrencyIsoCode = 'KES';
        INSERT empBenefitPlan;
        
        
        //Create Employee Emergency Contacts 
        Employee_Emergency_Contacts__c emrgyContact = new Employee_Emergency_Contacts__c();
        emrgyContact.Employee__c = emp.Id;
        emrgyContact.Contact_Name__c = 'Steevi';
        emrgyContact.CurrencyIsoCode = 'KES';
        INSERT emrgyContact;
                
        //Create Employee Union 
        Employee_Union__c empUnion = new Employee_Union__c();
        empUnion.CurrencyIsoCode = 'KES';
        INSERT empUnion;
        
         
        //Create Employee Benefit Dependents 
        Employee_Benefits_Dependents__c empBenDependent = new Employee_Benefits_Dependents__c();
        empBenDependent.Employee_Name__c = emp.Id;
        empBenDependent.First_Name__c = 'Steevi';
        empBenDependent.Last_Name__c = 'Stone';
        empBenDependent.Relationship__c = 'Spouse';
        INSERT empBenDependent;
        
        
        CreateEmployeeDetailsFromEmployee empDetails = new CreateEmployeeDetailsFromEmployee();
        empDetails.fetchEmployeeDetails();
        empDetails.getLeaveUtilization();
        empDetails.getLeaveAccruals();
        empDetails.getEmployeeLeaveRequest();
        empDetails.getEmployeeJobInfo();
        empDetails.getEmployeesUnderAManager();
        empDetails.getIssuedAssets();
        empDetails.payrollModifications();
        empDetails.employeeVaccination();
        empDetails.getBankingInfo();
        empDetails.employeeTrainings();
        empDetails.employeeBenefitPlan();
        empDetails.employeeEmergencyContacts();
        empDetails.employeeUnion();
        empDetails.employeeBenDependents();
    }
}