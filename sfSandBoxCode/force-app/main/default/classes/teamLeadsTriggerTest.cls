@isTest(seealldata=true)
public class teamLeadsTriggerTest {
    static testMethod void testTeamLeadsTrigger(){
        
        List<FFA_Config_Object__c> dept=[SELECT Id,Name,Type__c,isActive__c,Teamlead__c 
                                         FROM FFA_Config_Object__c 
                                         WHERE Type__c = 'dim1' 
                                         AND Name = 'Information Technology'
                                         AND isActive__c = true LIMIT 1];
        
        List<Employee__c> empList=[SELECT ID FROM Employee__c WHERE Work_Email__c <> null LIMIT 1]; 
        
        if(dept.size()>0){   
            if(empList.size()>0){
                //Get Department
       List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true LIMIT 2];      
       //Get Dim 2
       List<FFA_Config_Object__c> dim2= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];
       //Get dim3
       List<FFA_Config_Object__c> dim3= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];
       //Get dim4
       List<FFA_Config_Object__c> dim4= [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];
       
       //Get gla
       List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 1];
       
       //Get Company
       List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
       
       //Get employee
       List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
       
       //get Currenct
       List<Currency_Config__c> curr = [SELECT id FROM Currency_Config__c WHERE Current__c = true LIMIT 1];
       
       //Get Purchase Order Item
       List<Purchase_Order_Item__c> poI = [SELECT id,Inventory_Item__c,Inventory_Item__r.Item_Company__c FROM Purchase_Order_Item__c WHERE Status__c='Active' LIMIT 2];
      
        //Create PR
        Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
        pr.Requestor_Type__c = 'Employee';
        pr.Required_Date__c = Date.today() + 14;
        pr.Requesting_Department__c = department.get(0).id;
        pr.Maintenance_Department__c = department.get(0).id;
        pr.Priority__c = 'Low';
        pr.Remarks__c = 'Some remarks'; 
        pr.Requestor__c = employee.get(0).id; 
       pr.High_Priority_Comments__c = 'comment';
        pr.Requesting_Company__c = poI.get(0).Inventory_Item__r.Item_Company__c;
        insert pr;
                Date d=Date.today();
                pr.Required_Date__c = d.addDays(34);
        		update pr;
                
               //Create PRLine
        PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
        prItem.Procurement_Tracking_Sheet__c = pr.Id;
        prItem.Department__c = department.get(0).id;
        prItem.Dim_2__c = dim2.get(0).id;
        prItem.Dim_3__c = dim3.get(0).id;
        prItem.Grant__c = dim4.get(0).id;
        prItem.Inventory_Item__c = poI.get(0).Inventory_Item__c;
        prItem.GLA__c = gla.get(0).id;
        prItem.Requesting_Company__c = poI.get(0).Inventory_Item__r.Item_Company__c;
        prItem.Item__c = 'Test Item';
        prItem.Override_PR_Item_Cost_Check__c = true;
		prItem.Override_Justification__c = 'just';
        prItem.Specifications__c = 'Test Specifications';
        prItem.Quantity__c = 2;
        prItem.Budget_Amount__c= 10;
        prItem.non_primary_vendor_description__c = 'coment';
        prItem.Currency_Config__c = curr.get(0).id; 
        prItem.Purchase_Order_Item__c = poI.get(0).id;
        prItem.RequestType__c = 'Stock';
        insert prItem;                 
        pr.Team_Lead_Approval_Status__c='Approved';
        update pr;
                
        RFE__c rf= new RFE__c();
                rf.Kickoff_Date__c = date.today();
                rf.Project_Name__c =  'testp';
                rf.Requesting_Department__c = dept.get(0).Id;
                rf.Quantity__c = 1;
                rf.Project_Cost__c = 100;
                
                insert rf;
                
        
            }
        }        
    }
}