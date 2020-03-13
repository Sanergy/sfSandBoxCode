@isTest(seeAllData = true)
public class updateEPRonPostingTest {
    static testMethod void updateEPRAfterPosting(){
        //Get dim1                              
        FFA_Config_Object__c department = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'dim1' 
                                           AND Name = 'Information Technology'
                                           AND isActive__c = true LIMIT 1];
        System.debug('' + department);
        //Get dim2                                    
        FFA_Config_Object__c dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim2' 
                                     AND isActive__c = true LIMIT 1];
        
        //Get dim3                                   
        FFA_Config_Object__c dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim3' 
                                     AND isActive__c = true LIMIT 1];
        
        //Get dim4                                     
        FFA_Config_Object__c dim4 = [SELECT Id,Name,Type__c,isActive__c 
                                     FROM FFA_Config_Object__c 
                                     WHERE Type__c = 'dim4' 
                                     AND isActive__c = true LIMIT 1];
        
        //Get GLA                                    
        FFA_Config_Object__c gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla'
                                   AND (Name='2000 - Accounts Payable Control'
                                        OR Name='2050 - Accrued Accounts Payable Control')
                                   AND isActive__c=true LIMIT 1];
        //Get employee
        Employee__c employee = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                FROM Employee__c 
                                WHERE Employee_Active__c=true 
                                AND Work_Email__c!=null LIMIT 1];         
        
        //Get a vendor
        Account vendor = [SELECT Id 
                          FROM Account 
                          WHERE RecordType.Name = 'Sanergy Vendor'
                          AND ID =: '001D000001APxbJ'
                          LIMIT 1];

        //Create Cash Entry
        c2g__codaCashEntry__c cashEntry =  new c2g__codaCashEntry__c();
        //cashEntry.
       
        //CREATE EPR 
        Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();
        epr.department__c = department.Id;
        epr.Company__c = 'Sanergy Ltd';
        epr.Vendor_Company__c = vendor.Id;
        //epr.Invoice_Number__c = sp1.Name;                              
        epr.Scheduled_Payment_Date__c = date.today();                
        epr.Notes__c='Payment for items bought';
        epr.Payment_Type__c = 'Employee Reimbursement';
        epr.Cash_Entry__c = NULL;
        INSERT epr;        
        
        //CREATE EPR LINE ITEM
        EPR_Payable_Item__c eprLineItems = new EPR_Payable_Item__c();            
        eprLineItems.epr__c=epr.id;
        eprLineItems.Department_dim1__c = epr.department__c;
        eprLineItems.Item__c = 'Steel';
        eprLineItems.Quantity__c = 2;
        eprLineItems.Unit_Price__c = 2000;
        eprLineItems.Location_Dim2__c = dim2.Id;
        eprLineItems.Dim_3__c = dim3.Id;
        eprLineItems.Grant_Funding_Availale_dim4__c = dim4.Id;
        eprLineItems.GLA__c = gla.Id;        
        INSERT eprLineItems;        
        
        UPDATE epr;
    }
}