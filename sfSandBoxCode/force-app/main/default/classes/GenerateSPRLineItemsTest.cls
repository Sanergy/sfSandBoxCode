@isTest(seeAllData = true)
public class GenerateSPRLineItemsTest {
    static testMethod void GenerateSPRLineItemsTest(){
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
            System.runAs(userFFA.get(0)){
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
                List<FFA_Config_Object__c> gla = [SELECT Id,Name,Type__c,isActive__c 
                                                  FROM FFA_Config_Object__c 
                                                  WHERE Type__c = 'gla' 
                                                  AND isActive__c = true LIMIT 1];
                
                //Get Company
                FFA_Config_Object__c company= [SELECT Id,Name,Type__c,isActive__c 
                                               FROM FFA_Config_Object__c 
                                               WHERE type__c = 'company' 
                                               AND isActive__c = true 
                                               AND Name = 'Sanergy Limited'
                                               LIMIT 1];
                /*Get employee
                List<Employee__c> employee = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                              FROM Employee__c 
                                              WHERE id = 'aAsD0000000GmgM' LIMIT 1];*/ //James ID - need to make sure emp selected has a TL for the sharing reasons to work    
                
                //Get a vendor
                List<Account> vendor = [SELECT Id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' LIMIT 1];      
                
                //Create Special Procurement               
                Special_Procurement__c sp1 = new Special_Procurement__c();
                sp1.Requestor__c = 'aAsD0000000GmgM';
                sp1.Type__c = 'Special Procurement';
                sp1.Required_Date__c = date.today();
                sp1.Comments__c = 'Two tyres for Toyota Corolla';         
                sp1.Requesting_Department__c = department.get(0).Id;
                sp1.Vendor__c = vendor.get(0).Id;       
                sp1.Approval_Status__c = 'Approved By Team Lead';
                sp1.Dim_2__c = dim2.get(0).Id;
                sp1.Dim_3__c = dim3.get(0).Id;
                sp1.GLA__c = gla.get(0).Id;
                sp1.Grant__c = dim4.get(0).Id;
                sp1.Requesting_Company__c = company.Id;
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
                
                GenerateSPRLineItemsTest gen = new GenerateSPRLineItemsTest();
            }
        }
    }
}