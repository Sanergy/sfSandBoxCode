@isTest(seeAllData = true)
public class UpdateSPPAfterEPRUpdateTest {
    static testMethod void UpdateSPPAfterEPRUpdateTest(){
                 //Get dim1                              
         List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c 
                                                  FROM FFA_Config_Object__c 
                                                  WHERE Type__c = 'dim1' 
                                                  AND Name = 'Information Technology'
                                                  AND isActive__c = true LIMIT 1];
            System.debug('' + department);
         //Get dim2                                    
         List<FFA_Config_Object__c> dim2 = [SELECT Id,Name,Type__c,isActive__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim2' 
                                            AND isActive__c = true LIMIT 1];
            
         //Get dim3                                   
         List<FFA_Config_Object__c> dim3 = [SELECT Id,Name,Type__c,isActive__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim3' 
                                            AND isActive__c = true LIMIT 1];
            
         //Get dim4                                     
         List<FFA_Config_Object__c> dim4 = [SELECT Id,Name,Type__c,isActive__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim4' 
                                            AND isActive__c = true LIMIT 1];
                                                 
         //Get GLA
        /* List<FFA_Config_Object__c> gla = [SELECT Id,Name,Type__c,isActive__c 
                                           FROM FFA_Config_Object__c 
                                           WHERE Type__c = 'gla' 
                                           AND isActive__c = true LIMIT 1];*/
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla'
                                         AND (Name='2000 - Accounts Payable Control'
                                         OR Name='2050 - Accrued Accounts Payable Control')
                                         AND isActive__c=true LIMIT 2];
                                                 
         //Get Company
         List<FFA_Config_Object__c> company= [SELECT Id,Name,Type__c,isActive__c 
                                              FROM FFA_Config_Object__c 
                                              WHERE type__c='company' 
                                              AND isActive__c=true LIMIT 5];
        
        //Get employee
        //James ID - need to make sure emp selected has a TL for the sharing reasons to work 
        List<Employee__c> employee = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                      FROM Employee__c 
                                      WHERE Employee_Active__c=true 
                                      AND Id = 'aAsD0000000GmgM' LIMIT 1];               
             
         //Get a vendor
         List<Account> vendor = [SELECT Id 
                                 FROM Account 
                                 WHERE RecordType.Name = 'Sanergy Vendor'
                                 AND ID =: '001D000001APxbJ'
                                 LIMIT 1];
         
         //Get Company
         FFA_Config_Object__c company1 = [SELECT Id,Name,Type__c,isActive__c 
                                          FROM FFA_Config_Object__c 
                                          WHERE type__c = 'company' 
                                          AND isActive__c = true 
                                          AND Name = 'Sanergy Limited'
                                          LIMIT 1];         

         //Create Special Procurement               
         Special_Procurement__c sp1 = new Special_Procurement__c();
         sp1.Requestor__c = 'aAsD0000000GmgM';
         sp1.Type__c = 'Cash Advance';
         sp1.Required_Date__c = date.today();
         sp1.Comments__c = 'Two tyres for Toyota Corolla';         
         sp1.Requesting_Department__c = department.get(0).Id;
         sp1.Vendor__c = vendor.get(0).Id;       
         sp1.Approval_Status__c = 'Approved By Team Lead';
         sp1.Dim_2__c = dim2.get(0).Id;
         sp1.Dim_3__c = dim3.get(0).Id;
         sp1.GLA__c = gla.get(0).Id;
         sp1.Grant__c = dim4.get(0).Id;
         sp1.Requesting_Company__c = company1.Id;
         INSERT sp1;
		 
         System.debug('SPR: ' + sp1.Requesting_Company__c);
         
         //Create Special Procurement Line Items
		 Special_Procurement_Line_Item__c spLineItems1 = new Special_Procurement_Line_Item__c();
         spLineItems1.Special_Procurement__c = sp1.Id;
         spLineItems1.Item__c = 'Two 18 Inch Car Tyress';
         spLineItems1.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
         spLineItems1.Quantity_Requested__c = 2;
         spLineItems1.Unit_Price__c = 600;
         spLineItems1.Status__c = 'Approved';
         INSERT spLineItems1;
         		 
       
        //CREATE EPR 
        Electronic_Payment_Request__c epr = new Electronic_Payment_Request__c();
        epr.department__c = sp1.Requesting_Department__c;
        epr.Company__c = 'Sanergy Ltd';
        epr.Vendor_Company__c = sp1.Vendor__c;
        epr.Invoice_Number__c = sp1.Name;                              
        epr.Scheduled_Payment_Date__c = date.today();                
        epr.Notes__c='Payment for items bought';
        epr.Payment_Type__c = sp1.Type__c;         
        insert epr;
        
        sp1.EPR_Created__c = true;
        update sp1;
        
        
        EPR_Payable_Item__c eprLineItems = new EPR_Payable_Item__c();            
        eprLineItems.epr__c=epr.id;
        eprLineItems.Department_dim1__c = epr.department__c;
        eprLineItems.Item__c = spLineItems1.Item__c;
        eprLineItems.Quantity__c = spLineItems1.Quantity_Requested__c;
        eprLineItems.Unit_Price__c = spLineItems1.Unit_Price__c;
        eprLineItems.Location_Dim2__c = sp1.Dim_2__c;
        eprLineItems.Dim_3__c = sp1.Dim_3__c;                
        eprLineItems.GLA__c = sp1.GLA__c;
        
        INSERT eprLineItems;
       
        spLineItems1.EPR_Created__c = True;
        update spLineItems1;
        
        
        // Special Procurement Payment
        Special_Procurement_Payment__c spp = new Special_Procurement_Payment__c();
        spp.Company__c=sp1.Requesting_Company__c;
        spp.EPR__c=epr.id;
        spp.Special_Procurement__c=sp1.id;
        spp.Payment_Cost__c=sp1.Total_Amount__c;
        spp.Total_EPR__c = sp1.Total_Amount__c;
        
        INSERT spp;	
        UpdateSPPAfterEPRUpdateTest updateSPP = new UpdateSPPAfterEPRUpdateTest();
    }
}