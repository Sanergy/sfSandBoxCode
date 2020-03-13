@isTest(seeAllData=True)
public class BulkCandidateStatusUpdateTest {
    static testMethod void BulkCandidateStatusUpdateTest(){            
        
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        
        User webAppUser = [SELECT Id FROM User WHERE Name = 'Web App' LIMIT 1];
        
        // Create Sanergy Department - RecordType - Sanergy
        Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
        sanergyDept.RecordTypeId = '012D0000000KIvqIAG';        
        sanergyDept.Name = 'Core Services';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Department_Status__c = true;
        sanergyDept.Team_Lead__c = 'aAsD000000001S7';
        INSERT sanergyDept;
        
        System.debug('SANERGY DEPARTMENT: ' + sanergyDept); 
        //create department unit
        Sanergy_Department_Unit__c deptUnit = new Sanergy_Department_Unit__c();
        deptUnit.Name = 'Information Technology System';
        deptUnit.Unit_Code__c = 'CORE';
        deptUnit.Sanergy_Department__c = sanergyDept.Id;
        deptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        deptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        deptUnit.Talent_Partner__c = '005D0000003Ykhb';
        deptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        deptUnit.Active__c = TRUE;
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
        
        Reg_Config__c regCon = new Reg_Config__c
            (
                Name = 'ANALY-A',
                REG_Code__c = 'ANALY',
                Reg_Factor__c = 'Analysis',
                Level__c = 'A',
                Level_Description__c = 'DDD',
                Guiding_Question__c = 'QQQ'
            );
        INSERT regCon;        
  
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
        
        //Create requirement requisition
        Recruitment_Requisition__c requisition = new Recruitment_Requisition__c();
        requisition.Name = 'Business Analyst';
        requisition.Requestor__c = 'aAsD000000001S7';
        requisition.Talent_Partner__c = usr.Id;
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
        
        //Create requirement requisition
        Recruitment_Requisition__c requisition2 = new Recruitment_Requisition__c();
        requisition2.Name = 'Business Analyst - Role 2';
        requisition2.Requestor__c = 'aAsD000000001S7';
        requisition2.Talent_Partner__c = usr.Id;
        requisition2.Employee_Role__c = empRole.Id;
        requisition2.Request_Date__c = date.today()+30;
        requisition2.Number_of_Required_Staff__c = 5;
        requisition2.Job_Description__c = 'ANALYSIS Role 2';
        requisition2.Justification_for_new_position__c = 'Test';
        requisition2.Type_of_employment__c = 'Permanent';
        requisition2.Duration_of_Fixed_term_Contract_Months__c = 1;
        requisition2.Is_recruitment_budgeted__c = 'yes';
        requisition2.Candidate_Specification__c = 'Kenyan';
        requisition2.Proposed_Employee_required_Date__c = date.today()+40;
        requisition2.Location__c = 'Mukuru';
        requisition2.Requesting_Department__c = department.get(0).Id;
        INSERT requisition2;
        
        //Create Recruitment Request Config - RecordType - Account
        Recruitment_Request_Config__c recruitmentRequestConfig1 = new Recruitment_Request_Config__c();   
        recruitmentRequestConfig1.RecordTypeId = '012D0000000Qrta';
        recruitmentRequestConfig1.Employee_Role__c = empRole.Id;
        recruitmentRequestConfig1.Amount__c = 100;
        recruitmentRequestConfig1.Maximum__c = 100;
        recruitmentRequestConfig1.Type__c = 'Airtime Allowance';
        INSERT recruitmentRequestConfig1;
        
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
        
        //Create Candidate Evaluation Stage
        Candidate_Requisition__c candidateEvaluation  = new Candidate_Requisition__c(); 
        candidateEvaluation.Recruitment_Requisition__c = requisition.Id;
        candidateEvaluation.Candidate__c = candidate.Id;
        candidateEvaluation.Candidate_Rating__c = '1';
        candidateEvaluation.Date_Available__c = candidate.Date_Available__c;
        candidateEvaluation.Years_Of_Experience__c = '2';
        candidateEvaluation.Status__c = 'Open';
        if(SanergyUtils.IsSandBox() == 'YES'){  //set webapp user
            candidateEvaluation.OwnerId = '0057E000006fPwo';
        }  
        else 
        {
            candidateEvaluation.OwnerId = webAppUser.Id; //Doing this as ID might change in SandBox?
        }
        
        INSERT candidateEvaluation;
        System.debug('CANDIDATE EVALUATION STAGE; ' + candidateEvaluation); 
        
        //Create Candidate Evaluation Stage
        Candidate_Evaluation_Stage__c ces  = new Candidate_Evaluation_Stage__c(); 
        ces.Recruitment_Requisition__c = requisition.Id;
        ces.Candidate_Evaluation__c = candidateEvaluation.Id;
        ces.Candidate__c = candidate.Id;
        ces.Candidate_Rating__c = '1';
        ces.Date_Available__c = candidate.Date_Available__c;
        ces.Years_Of_Experience__c = '2';
        ces.Evaluation_Status__c = 'Open';
        INSERT ces;
        
        List<Candidate_Evaluation_Stage__c> cesList = new List<Candidate_Evaluation_Stage__c>();
        cesList.add(ces);
        
        //UPDATE CANDIDATE EVALUATION
        candidateEvaluation.Status__c = 'Declined';
        UPDATE candidateEvaluation;
        
        ApexPages.Standardcontroller controller1 = new ApexPages.Standardcontroller(requisition);
        BulkCandidateStatusUpdate candi = new BulkCandidateStatusUpdate(controller1);
        
        BulkCandidateStatusUpdate.CandidateEvaluation evaluation = new BulkCandidateStatusUpdate.CandidateEvaluation(candidateEvaluation,cesList); 
        candi.EvalAllStatus = '--';
        candi.getCandidateEvaluations(); //test get all records  
        
        candi.EvalAllStatus = 'Declined';
        candi.getCandidateEvaluations(); //test specific status
        
        //return to open status
        candidateEvaluation.Status__c = 'Open';
        UPDATE candidateEvaluation;
        
        candi.EvalAllStatus = 'Open';
        candi.getCandidateEvaluations(); //populate EvalList
        System.debug('CANDIDATE EVALUATION' + candi.getCandidateEvaluations());        
        candi.getAllCandidates();
        
        for(BulkCandidateStatusUpdate.CandidateEvaluation  c: candi.candidateEvaluationList){
            c.selected = TRUE;
            c.selectedOption = 'Shortlisted';
            c.newCandidateRating = '5';
            c.evaluation.Candidate_Rating__c = '3';
            c.ReassignToNewRR.value = requisition2.id;
            c.ShowUpdatedRows();
            c.evalStagesRendered = FALSE;
            c.RenderEvalStages();
            c.RenderEvalStages();
            c.ConvertToEmp();
        }
        candi.selectAllCheckbox = true; 
        candi.selectUnselectAll();
        
        
        candi.newCandidateStatus = 'Shortlisted';
        candi.updateCandidateStatusDropDown();
        candi.updateCandidateStatus(); 
        
        system.debug('Apex Messages = ' + apexpages.getMessages());
        
        system.test.startTest();
        //Update Test Accepted
        for(BulkCandidateStatusUpdate.CandidateEvaluation  c: candi.candidateEvaluationList){
            c.selected = TRUE;
            c.selectedOption = 'Accepted';
            c.newCandidateRating = '5';
            c.evaluation.Candidate_Rating__c = '3';
            c.ShowUpdatedRows();
            c.ConvertToEmp();
            
        }
        candi.selectAllCheckbox = true; 
        candi.selectUnselectAll();
        
        
        candi.newCandidateStatus = 'Shortlisted';
        candi.updateCandidateStatusDropDown();
        candi.updateCandidateStatus(); 
        system.debug('Apex Messages = ' + apexpages.getMessages());
        
        //Test ConvertCandidateTo Employee
        
        PageReference pgRefConvCand = Page.ConvertCandidateToEmployee;
        Test.setCurrentPage(pgRefConvCand);
        pgRefConvCand.getParameters().put('Id', candidate.Id);
        pgRefConvCand.getParameters().put('RecReqId', requisition.Id);
        
        ApexPages.Standardcontroller ctrlCon = new ApexPages.Standardcontroller(candidate);
        ConvertCandidateToEmployee convCand = new ConvertCandidateToEmployee(ctrlCon);
        candidate.Candidate_Status__c = 'Offer Accepted';
        //UPDATE candidate;
        convCand.ConvertCandidate();
        
        //Test Close Recruitment Rec
        ApexPages.Standardcontroller recReq = new ApexPages.Standardcontroller(requisition);
        CloseRecruitmentRequisition clsRecReq = new CloseRecruitmentRequisition(recReq);
        clsrecreq.unSelectAll();
        clsrecreq.selectAll();
        clsRecReq.CloneAndSave();
        clsRecReq.CloseReq();
        system.test.StopTest();
    }
    
    static testMethod void TestRegMap(){ 
        //Test Reg Mapping
        // Create Sanergy Department - RecordType - Sanergy
        Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
        sanergyDept.RecordTypeId = '012D0000000KIvqIAG';        
        sanergyDept.Name = 'Core Services';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Department_Status__c = true;
        sanergyDept.Team_Lead__c = 'aAsD000000001S7';
        INSERT sanergyDept;
        
        System.debug('SANERGY DEPARTMENT: ' + sanergyDept); 
        //create department unit
        Sanergy_Department_Unit__c deptUnit = new Sanergy_Department_Unit__c();
        deptUnit.Name = 'Information Technology System';
        deptUnit.Unit_Code__c = 'CORE';
        deptUnit.Sanergy_Department__c = sanergyDept.Id;
        deptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        deptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        deptUnit.Talent_Partner__c = '005D0000003Ykhb';
        deptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        deptUnit.Active__c = TRUE;
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
        
        Reg_Config__c regCon = new Reg_Config__c
            (
                Name = 'ANALY-A',
                REG_Code__c = 'ANALY',
                Reg_Factor__c = 'Analysis',
                Level__c = 'A',
                Level_Description__c = 'DDD',
                Guiding_Question__c = 'QQQ'
            );
        INSERT regCon;   
        //Test Reg Mapping
        ApexPages.Standardcontroller ctrlMap = new ApexPages.Standardcontroller(empRole);
        CreateRegConfigFromEmployeeRole regMap = new CreateRegConfigFromEmployeeRole(ctrlMap);
        regMap.createRegMap(); 
        /* 
PageReference pageRef = new PageReference('/apex/CreateRegConfigFromEmplyeeRole');
pageRef.getParameters().put('Id',empRole.Id);
pageRef.setRedirect(true);        

List<Reg_Config__c> regConRecords= new List<Reg_Config__c>();
List<Reg_Mapping__c> existingRegMap = 
[
SELECT id, Name, Reg_Factor__c, Reg_Factor__r.Guiding_Question__c
FROM Reg_Mapping__c
WHERE Employee_Role__c = : empRole.id
];
for(Reg_Config__c c : [SELECT REG_Code__c, Guiding_Question__c, Level__c, Level_Description__c, Name,
Reg_Factor__c FROM Reg_Config__c ORDER  BY Reg_Code__c ASC ])
{
regConRecords.add(c);
}
*/
        //CreateRegConfigFromEmployeeRole.RegConfigWrapper wrpRegMap = new CreateRegConfigFromEmployeeRole.RegConfigWrapper(regConRecords,existingRegMap);
        
    }
    
    static testMethod void TestDelegateMyApprovals(){
        
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Teamlead__c
                                                 FROM FFA_Config_Object__c 
                                                 WHERE Type__c = 'dim1' 
                                                 AND Name = 'Information Technology'
                                                 AND isActive__c = true LIMIT 1];
        
        User webAppUser = [SELECT Id FROM User WHERE Name = 'Web App' LIMIT 1];
        
        // Create Sanergy Department - RecordType - Sanergy
        Sanergy_Department__c sanergyDept = new Sanergy_Department__c();
        sanergyDept.RecordTypeId = '012D0000000KIvqIAG';        
        sanergyDept.Name = 'Core Services';
        sanergyDept.Company__c = 'Sanergy';
        sanergyDept.Department_Code__c = 'CORE';
        sanergyDept.Department_Status__c = true;
        sanergyDept.Team_Lead__c = 'aAsD000000001S7';
        INSERT sanergyDept;
        
        System.debug('SANERGY DEPARTMENT: ' + sanergyDept); 
        //create department unit
        Sanergy_Department_Unit__c deptUnit = new Sanergy_Department_Unit__c();
        deptUnit.Name = 'Information Technology System';
        deptUnit.Unit_Code__c = 'CORE';
        deptUnit.Sanergy_Department__c = sanergyDept.Id;
        deptUnit.Team_Lead__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Team_Lead_SF_Account__c = '005D0000003Ykhb'; //user obejct
        deptUnit.Line_Manager__c = 'aAsD0000000GmgM'; //employee object
        deptUnit.Line_Manager_SF_Account__c = '005D0000003Ykhb'; //user obejct 
        deptUnit.Talent_Partner__c = '005D0000003Ykhb';
        deptUnit.Talent_Partner_Emp_Account__c = 'aAsD0000000GmgM';
        deptUnit.Active__c = TRUE;
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
        
        Reg_Config__c regCon = new Reg_Config__c
            (
                Name = 'ANALY-A',
                REG_Code__c = 'ANALY',
                Reg_Factor__c = 'Analysis',
                Level__c = 'A',
                Level_Description__c = 'DDD',
                Guiding_Question__c = 'QQQ'
            );
        INSERT regCon;        
        
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
        
        //Create requirement requisition
        Recruitment_Requisition__c requisition = new Recruitment_Requisition__c();
        requisition.Name = 'Business Analyst';
        requisition.Requestor__c = 'aAsD000000001S7';
        requisition.Talent_Partner__c = usr.Id;
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
        
        //Create Recruitment Request Config - RecordType - Account
        Recruitment_Request_Config__c recruitmentRequestConfig1 = new Recruitment_Request_Config__c();   
        recruitmentRequestConfig1.RecordTypeId = '012D0000000Qrta';
        recruitmentRequestConfig1.Employee_Role__c = empRole.Id;
        recruitmentRequestConfig1.Amount__c = 100;
        recruitmentRequestConfig1.Maximum__c = 100;
        recruitmentRequestConfig1.Type__c = 'Airtime Allowance';
        INSERT recruitmentRequestConfig1;
        
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
        
        //Run as Admin user that also has Dept, Dept Unit and FFA Configs set as approver
        User u = [Select Id ,Alias FROM User WHERE id = '005D0000003Ykhb'];//James SF ID
        System.runAs(u) {
            
            //Test Delegate My Approvals
            ApexPages.Standardcontroller ctrDelApps = new ApexPages.Standardcontroller(emp);
            DelegateTLApprovals DelApps = new DelegateTLApprovals(ctrDelApps);
            
            delApps.empToDelegate.value = 'aAsD0000000Gmhr'; //Ani
            //update Dept wrp class
            for(DelegateTLApprovals.DepartmentWrapper d: DelApps.TLDeptsWrp){
                d.selected = TRUE;
            }
            
            //update Dept Unitwrp class
            for(DelegateTLApprovals.DepartmentUnitWrapper du: DelApps.TLDeptUnitsWrp){
                du.selected = TRUE;
            }
            
            //update FFA Config class
            for(DelegateTLApprovals.FFAConfigWrapper ff: DelApps.ffaConfigsWrp){
                ff.selected = TRUE;
            }
            delApps.updateDelegatedApprovals();
            
            PageReference pageRef = new PageReference('/apex/DelegateTLApprovals');
            pageRef.getParameters().put('EmployeeId','aAsD0000000GmgM'); //James ID
            pageRef.setRedirect(true);
        }
    }
}