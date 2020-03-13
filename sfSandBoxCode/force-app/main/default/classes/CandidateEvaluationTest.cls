@isTest(seeAllData=True)
public class CandidateEvaluationTest {
    
    static testMethod void CandidateEvaluationTests(){
        
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c
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
        
        
        
        //Create requirement requisition
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
        
        System.debug('DDFDDD' + requisition);        
        
        
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
        
        //insert user
        User usr = new User();
        usr.LastName = 'John';
        usr.Alias = 'Doe';
        usr.Email = 'johndoe@saner.gy';
        usr.Username = 'johndoe@saner.gy';
        usr.CommunityNickname = 'IT';
        usr.ProfileId = '00eD00000016NEhIAM';
        usr.TimeZoneSidKey =  'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.Team_Lead__c = '005D0000003Ykhb';
        usr.LocaleSidKey = 'en_US';
        INSERT usr;                 
        

        
        // Create Candidate
        Candidate__c candidate = new Candidate__c();
        candidate.Name = 'Pauline Mbabu';
        candidate.Recruitment_Requisition__c = requisition.Id;
        candidate.First_Name__c = 'John';
        candidate.Last_Name__c = 'Doe';
        candidate.ID_Number__c = '12345678';
        candidate.Phone_Number__c = '+254736271518';
        candidate.Email__c = 'johndoe@saner.gy';
        candidate.Resume__c = 'https://www.google.com/';
        candidate.Country__c = 'Las Vegas';
        candidate.Date_Available__c = date.today();
        candidate.Candidate_Status__c = 'Open';
        candidate.Candidate_Rating__c ='2';
        candidate.Date_Available__c = date.today()+20;
        candidate.Date_of_Application__c = date.today()+10;
        candidate.Requesting_Department__c = department.get(0).Id;
        candidate.Requesting_Department_Team_Lead__c = usr.Team_Lead__c;
        candidate.Status_For_All_Candidates__c = 'Open';
        INSERT candidate; 
        System.debug('CANDIDATE: ' + candidate);
        
        // Create Candidate
        Candidate__c candidate2 = new Candidate__c();
        candidate2.Name = 'Pauline Mbabu';
        candidate2.Recruitment_Requisition__c = requisition.Id;
        candidate2.First_Name__c = 'John';
        candidate2.Last_Name__c = 'Doe';
        candidate2.ID_Number__c = '12345678';
        candidate2.Phone_Number__c = '+254736271518';
        candidate2.Email__c = 'johndoe@saner.gy';
        candidate2.Resume__c = 'https://www.google.com/';
        candidate2.Country__c = 'Las Vegas';
        candidate2.Date_Available__c = date.today();
        candidate2.Candidate_Status__c = 'Open';
        candidate2.Candidate_Rating__c ='2';
        candidate2.Date_Available__c = date.today()+20;
        candidate2.Date_of_Application__c = date.today()+10;
        candidate2.Requesting_Department__c = department.get(0).Id;
        candidate2.Requesting_Department_Team_Lead__c = usr.Team_Lead__c;
        candidate2.Status_For_All_Candidates__c = 'Open';
        INSERT candidate2; 
        System.debug('CANDIDATE: ' + candidate2); 

        
        //Create Candidate Evaluation Stage
        Candidate_Requisition__c candidateEvaluation  = new Candidate_Requisition__c(); 
        candidateEvaluation.Recruitment_Requisition__c = requisition.Id;
        candidateEvaluation.Candidate__c = candidate.Id;
        candidateEvaluation.Candidate_Rating__c = '1';
        candidateEvaluation.Date_Available__c = candidate.Date_Available__c;
        candidateEvaluation.Years_Of_Experience__c = '2';
        candidateEvaluation.Status__c = 'Open';
        INSERT candidateEvaluation;
        System.debug('CANDIDATE EVALUATION STAGE; ' + candidateEvaluation); 
        
        //UPDATE CANDIDATE EVALUATION
        candidateEvaluation.Candidate_Rating__c = '3';
        candidateEvaluation.Status__c = 'Declined';
        candidateEvaluation.In_Review__c = 'Shortlisted';
        candidateEvaluation.In_Offer__c = 'Documents Check';
		candidateEvaluation.Comments__c = 'OK';
        UPDATE candidateEvaluation;
        
        //Create Candidate Evaluation Stage
        Candidate_Evaluation_Stage__c evaluationStage  = new Candidate_Evaluation_Stage__c(); 
        evaluationStage.Recruitment_Requisition__c = requisition.Id;                
        evaluationStage.Candidate_Evaluation__c = candidateEvaluation.Id;
        evaluationStage.Candidate__c = candidate.Id;
        evaluationStage.Candidate_Rating__c = '4';
        evaluationStage.Date_Available__c = candidateEvaluation.Date_Available__c;
        evaluationStage.Years_Of_Experience__c = candidateEvaluation.Years_Of_Experience__c;
        evaluationStage.Evaluation_Status__c = candidateEvaluation.Status__c;
        evaluationStage.Comments__c = candidateEvaluation.Comments__c;
        INSERT evaluationStage;          
        
        ApexPages.Standardcontroller controller = new ApexPages.Standardcontroller(candidateEvaluation);
        CandidateEvaluation.CandidateEvaluationStage evaluation = new CandidateEvaluation.CandidateEvaluationStage(evaluationStage);
        CandidateEvaluation ce = new CandidateEvaluation(controller);
        ce.getCandidateEvaluationStages();
        ce.getAllEvaluationStages();
        ce.updateCandidateEvaluation();
        
        delete candidate2;
        
    }
}