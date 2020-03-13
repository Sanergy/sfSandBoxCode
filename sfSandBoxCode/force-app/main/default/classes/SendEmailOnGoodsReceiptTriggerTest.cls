@isTest(SeeAllData=true)
private class SendEmailOnGoodsReceiptTriggerTest {
    
    static testmethod void SendEmailOnPTSGoodsReceipt() {
        
        //create an employee
        List<Employee__c> empList=[SELECT ID FROM Employee__c WHERE Work_Email__c <> null LIMIT 1];
        
        //select the department
        
        List<FFA_Config_Object__c> dept=[SELECT ID,Teamlead__c  
                                         FROM FFA_Config_Object__c 
                                         WHERE Type__c='dim1' AND Teamlead__c <> null LIMIT 1];
        List<User> usr=[SELECT ID,Name FROM User WHERE ID=:dept.get(0).Teamlead__c];
        //User usr=u.get(0).Id;
        
        if(empList.size()>0){                                          
            
            if(dept.size()>0){
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
                
                
                //Create PRLine
                PTS_Line_Item__c prItem = new PTS_Line_Item__c();        
                prItem.Procurement_Tracking_Sheet__c = pr.Id;
                prItem.Department__c = department.get(0).id;
                prItem.Dim_2__c = dim2.get(0).id;
                prItem.Dim_3__c = dim3.get(0).id;
                prItem.Grant__c = dim4.get(0).id;
                prItem.GLA__c = gla.get(0).id;
                prItem.Requesting_Company__c = poI.get(0).Inventory_Item__r.Item_Company__c;
                prItem.Inventory_Item__c = poI.get(0).Inventory_Item__c;
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
                prItem.Override_Gla__c = true;                     
                insert prItem; 
                
                //  User u=pts.Team_Ld__c;
                
                System.runAs(usr.get(0)){
                    pr.Team_Lead_Approval_Status__c='Declined By Maintenance Team Lead';
                    update pr;
                    
                    pr.Team_Lead_Approval_Status__c='Approved';
                    update pr;
                }
                
                prItem.Qty_Delivered__c=2;
                
                update prItem;
            } 
        }
    }
}