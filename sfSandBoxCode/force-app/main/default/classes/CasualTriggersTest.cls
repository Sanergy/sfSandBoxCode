@isTest(seealldata=true)
public class CasualTriggersTest {
    
    static testMethod void testCasualTriggers(){
        
        List<FFA_Config_Object__c> dept=[SELECT ID,Teamlead__c  
                                         FROM FFA_Config_Object__c 
                                         WHERE Type__c='dim1' AND Teamlead__c <> null AND isActive__c=true  
                                         AND Name='Administration'
                                         LIMIT 1];
        
        List<FFA_Config_Object__c> loc=[SELECT ID,Teamlead__c  
                                        FROM FFA_Config_Object__c 
                                        WHERE Type__c='dim2' AND isActive__c=true LIMIT 1];
        
        List<FFA_Config_Object__c> notApp=[SELECT ID,Teamlead__c  
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c='dim3' AND isActive__c=true LIMIT 1];
        
        List<FFA_Config_Object__c> grant=[SELECT ID,Teamlead__c  
                                          FROM FFA_Config_Object__c 
                                          WHERE Type__c='dim4' AND isActive__c=true AND (not Name like '%XXX') LIMIT 1];
        
        List<Employee__c> empList=[SELECT ID FROM Employee__c WHERE Work_Email__c <> null LIMIT 1]; 
        
        List<Account> ac=[SELECT Id,Name FROM Account WHERE Type='Vendor' LIMIT 1];
        
        if(ac.size()>0){
            
            if(dept.size()>0){  
                
                if(empList.size()>0){
                    
                    if(loc.size()>0){
                        
                        if(notApp.size()>0){
                            
                            if(grant.size()>0){
                                
                                Casual__c cas=new Casual__c();
                                
                                cas.Account__c = ac.get(0).Id;
                                cas.Contractual_Start_Date__c = date.today();
                                cas.Contractual_End_Date__c = date.today();
                                cas.ID_Number__c = '12243543';
                                cas.Grade__c = 'General Laborer';
                                
                                insert cas;
                                
                                Casuals_Job__c cJob=new Casuals_Job__c();
                                
                                cJob.Department__c=dept.get(0).Id;
                                cJob.Start_Date__c=date.today();
                                cJob.End_Date__c=date.today();
                                cJob.Company__c='Sanergy Ltd';
                                
                                insert cJob;
                                
                                FFA_Config_Object__c gla=[SELECT Id FROM FFA_Config_Object__c 
                                                          WHERE Type__c='gla' 
                                                          AND Name='2000 - Accounts Payable Control'
                                                          AND isActive__c=true LIMIT 1];
                                
                                Casual_Job_Line_Item__c spec=new Casual_Job_Line_Item__c();
                                
                                spec.Casuals_Job__c = cJob.Id;
                                spec.Department_Dim_1__c = dept.get(0).Id;
                                spec.Dim3__c = notApp.get(0).Id;
                                spec.Grant_Dim_4__c = grant.get(0).Id;
                                spec.Location_Dim_2__c = loc.get(0).Id;
                                spec.Start_Date__c = date.today();
                                spec.End_Date__c = date.today();
                                spec.Grade__c = 'General Laborer';
                                spec.Number_Of_Casuals__c = 1;
                                spec.Rate__c = 500;
                                spec.Rate_Units__c='Per Day';
                                spec.Quantity__c = 1;
                                spec.Allowance_Per_Person__c = 1000;
                                spec.Allowance_Description__c = 'Lunch';
                                spec.GLA__c = gla.Id;                    
                                insert spec; 
                                
                                Casuals_Job_Assignment__c assign = new Casuals_Job_Assignment__c();
                                
                                assign.Casual_Job_Line_Item__c = spec.Id;
                                assign.Casual__c = cas.Id;
                                
                                insert assign;
                                
                                Casuals_Timesheet__c tSheet = new Casuals_Timesheet__c();
                                
                                tSheet.Job_Requisition__c = assign.Id;
                                tSheet.Start_Date__c = date.today();
                                tSheet.End_Date__c = date.today();
                                tSheet.Total_Allowancess__c = 0;
                                tSheet.Rate_Units_Quantity__c = 1;
                                
                                insert tSheet;
                                
                                tSheet.Total_Allowancess__c = 200;
                                
                                update tSheet;
                                
                                spec.Allowance_Per_Person__c = null;
                                
                                update spec;
                            }
                        }
                    }
                }
            }
        }
    }
}