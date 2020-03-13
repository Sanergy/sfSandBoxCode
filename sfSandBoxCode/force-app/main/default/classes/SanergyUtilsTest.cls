@isTest(seeAllData = true)
public class SanergyUtilsTest {
    static testMethod void testMonthsBetween(){		
        SanergyUtils.monthsBetween(date.today(), date.today()+1); //Probably in same month
        SanergyUtils.monthsBetween(date.today(), date.today()+60);
        SanergyUtils.monthsBetween(date.today(), date.today()+366); //try for the next year
        SanergyUtils.AddBusinessDays(Date.today(), 14,FALSE ); //Test Positive
        SanergyUtils.AddBusinessDays(Date.today(),-14,FALSE ); //Test Negative
        
        //Test Generation of One Time Passcode
        SanergyUtils.generateOTP(6,FALSE);
		SanergyUtils.generateOTP(6,TRUE);
        
        //Test SanergyUtils.AssignEmpToBambooHRPermSet(emp.Id); Need at least one active employee
        Employee__c emp = [SELECT Id,Employee_SF_Account__c, Employee_Active__c
                           FROM Employee__c 
                           WHERE Employee_Active__c =TRUE AND Employee_SF_Account__c != NULL LIMIT 1
                          ];
        SanergyUtils.AssignEmpToBambooHRPermSet(emp.Id);
        
        //Test KRA Rounding Off
        SanergyUtils.KRARound(35.89);
        
        //Test  GetFFAConfigCompanyName(String CompanyName){
        SanergyUtils.GetFFAConfigCompanyName('Sanergy Limited');
        SanergyUtils.GetFFAConfigCompanyName('Fresh Life Initiative Limited');
        SanergyUtils.GetFFAConfigCompanyName('Sanergy Inc. (FP)');
        SanergyUtils.GetFFAConfigCompanyName('Sanergy Inc (NP)');

        //Test Creation of Cloning docs
        Set<id> SourceDocIDs = new  Set<id>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity Opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        SourceDocIDs.add(acc.Id);
        //Add Attachments
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=acc.id); 
        insert attach;
        
        Attachment attachPO =new Attachment(Name='Unit Test Attachment', body = bodyBlob, parentId=acc.id); 
        insert attachPO;
        
        //Add Note
        Note notePR =new Note(Title = 'Note 1', body = 'bodyBlob' , parentId=acc.id); 
        insert notePR;
        
        Note notePO =new Note(Title ='Note 2', body = 'bodyBlob', parentId=acc.id); 
        insert notePO;
        
        //Add GoogleDoc
        GoogleDoc gDoc =new GoogleDoc(Name = 'GDoc1', url = 'https://docs.google.com/spreadsheets/d/1l1U4A0Bb3E8TUrNmmdibqejqSL9vsfS_AkOK3ez5lGE/edit#gid=0',  parentId=acc.id); 
        insert gDoc;
        
        GoogleDoc gDocPO =new GoogleDoc(Name = 'GDoc2', url ='https://docs.google.com/document/d/1ReLwDzRZDHWh4m6NeX9XMtmKV_sQZTCYme7mbRpx5Iw/edit', parentId=acc.id); 
        insert gDocPO;

        SanergyUtils.CloneAttachments(SourceDocIDs, Opp.Id, '');  
        SanergyUtils.CloneNotes(SourceDocIDs, Opp.Id, '');  
        SanergyUtils.CloneGoogleDocs(SourceDocIDs, Opp.Id, '');  
        
        //Test existing docs
        SanergyUtils.CloneAttachments(SourceDocIDs, Opp.Id, '');  
        SanergyUtils.CloneNotes(SourceDocIDs, Opp.Id, '');  
        SanergyUtils.CloneGoogleDocs(SourceDocIDs, Opp.Id, ''); 
        
        // Test Is SandBox
        SanergyUtils.IsSandBox(); 
    }
}