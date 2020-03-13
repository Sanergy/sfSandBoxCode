@isTest(seeAllData=true)
public class CreateCandidateFromWebPageTest {
    static testMethod void testCreateCandidateFromWebPage(){
        
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
        Employee_Role__c employeeRole = new Employee_Role__c();        
        
        // Create Employee Manager
        Employee__c employeeManager = new Employee__c();       
        
        // Create Employee
        Employee__c employee = new Employee__c();  
        
        //Create Candidate
        Candidate__c candidate = new Candidate__c();
        
        //Create Recruitment requisition
        Recruitment_Requisition__c recruitmentRequisition = new Recruitment_Requisition__c();
        recruitmentRequisition.Name = 'System Analyst';
        recruitmentRequisition.Requestor__c = employeeManager.Id;
        recruitmentRequisition.Requesting_Department__c = department.get(0).Id;
        recruitmentRequisition.Talent_Partner__c = department.get(0).Teamlead__c;
        recruitmentRequisition.Request_Date__c = date.today();
        recruitmentRequisition.Stage__c = 'New';
        recruitmentRequisition.Number_of_Required_Staff__c = 3;
        recruitmentRequisition.Job_Description__c = 'Job description text';
        recruitmentRequisition.Justification_for_Additional_staff__c = 'Assist in completion of projects';
        recruitmentRequisition.Type_of_employment__c = 'Permanent';
        recruitmentRequisition.Duration_of_Fixed_term_Contract_Months__c = 3;
        recruitmentRequisition.Is_recruitment_budgeted__c = 'Yes';
        recruitmentRequisition.Candidate_Specification__c = 'Kenyan';
        recruitmentRequisition.Proposed_Employee_required_Date__c = date.today()+30;
        recruitmentRequisition.Location__c = 'Sameer';
        INSERT recruitmentRequisition;       
        
        System.debug('RECRUITMENT REQUISITION: ' + recruitmentRequisition);
        
        //insert candidate
        candidate.Name = 'Test Test';
        candidate.Recruitment_Requisition__c = recruitmentRequisition.id;
        candidate.Email__c = 'test@test.com';
        candidate.Resume__c = 'https://www.saner.gy/careers';
        candidate.Country__c = 'Kenya';
        candidate.Date_Available__c = date.today()+5;
        
        INSERT candidate;
            
            
    }
    
}