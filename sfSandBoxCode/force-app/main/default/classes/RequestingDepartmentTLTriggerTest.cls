@isTest(seealldata=true)
public class RequestingDepartmentTLTriggerTest {
    static testMethod void testTeamLeadsTrigger(){
        
         //Get dim1                              
         List<FFA_Config_Object__c> dept = [SELECT Name,Id,Teamlead__c,Type__c,lookup_ID__c 
                                            FROM FFA_Config_Object__c 
                                            WHERE Type__c = 'dim1'                                                   
                                            AND Teamlead__c <> null LIMIT 1];
         //Get employee
         List<Employee__c> empList = [SELECT ID FROM Employee__c WHERE Work_Email__c <> null LIMIT 1];  
            
         if(dept.size()>0){
             if(empList.size()>0){
                 
                 //Get Department
       			 List<FFA_Config_Object__c> department = [SELECT id 
                                                          FROM FFA_Config_Object__c 
                                                          WHERE type__c='dim1' AND isActive__c=true LIMIT 1];
                 //Get dim2                                    
                 List<FFA_Config_Object__c> dim2 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                    WHERE Type__c = 'dim2' AND isActive__c = true LIMIT 1];
                    
                 //Get dim3                                   
                 List<FFA_Config_Object__c> dim3 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                    WHERE Type__c = 'dim3' AND isActive__c = true LIMIT 1];
                    
                 //Get dim4                                     
                 List<FFA_Config_Object__c> dim4 = [SELECT Name,Id,Type__c,lookup_ID__c FROM FFA_Config_Object__c 
                                                    WHERE Type__c = 'dim4' AND isActive__c = true LIMIT 1];
                                                         
                 //Get GLA
                 List<FFA_Config_Object__c> gla = [SELECT Name, lookup_ID__c,Id,Type__c FROM FFA_Config_Object__c 
                                                   WHERE Type__c = 'gla' AND isActive__c = true LIMIT 1];
                                                         
                 //Get Company
                 List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c 
                                                      WHERE type__c='company' and isActive__c=true LIMIT 1];
                 //Get employee
                 List<Employee__c> employee = [SELECT id FROM Employee__c 
                                               WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];         
                     
                 //Get a vendor
                 List<Account> vendor = [SELECT id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' LIMIT 1];
                 
                 //Create Special Procurement               
                 Special_Procurement__c sp = new Special_Procurement__c();
                 sp.Requestor__c = 'aAsD0000000GmgM';
                 sp.Required_Date__c = date.today();
                 sp.Comments__c = 'Tyre bust on KBG 123 X';
                 sp.Requesting_Department__c = department.get(0).Id;
                 sp.Vendor__c = vendor.get(0).Id;         
                 sp.Stage__c = 'Director Approved';
                 sp.Dim_2__c = dim2.get(0).Id;
                 sp.Dim_3__c = dim3.get(0).Id;
                 sp.GLA__c = gla.get(0).Id;
                 sp.Grant__c = dim4.get(0).Id;
                 sp.Requesting_Company__c = company.get(0).Id;
                 INSERT sp;      
        		 System.debug('REQUESTOR:' + sp.Requestor__c + 'REQUESTING DEPT TL: ' + sp.Requesting_Department_TL__c);
                 
                 //Create Special Procurement Line Items
                 Special_Procurement_Line_Item__c spLineItems = new Special_Procurement_Line_Item__c();
                 spLineItems.Special_Procurement__c = sp.Id;
                 spLineItems.Item__c = '18 Inch Car Tyre';
                 spLineItems.Specifications__c = '18 Inch car tyre for Toyota Corolla';                 
                 spLineItems.Quantity_Requested__c = 2;
                 spLineItems.Unit_Price__c = 3000;
                 spLineItems.Status__c = 'Approved';
                 INSERT spLineItems;    
 
             }
         }        
    }
}