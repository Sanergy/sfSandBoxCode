@isTest(seeAllData = true)
public class BulkApprovalControllerTest_Lite {
    public static TestMethod void BulkApprovalControllerTester_Lite(){
        //Get dim1                              
        
        
        //Get Company
        List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company'AND Name = 'Sanergy Limited'and isActive__c=true LIMIT 1];       
        
        //Get the location
        List<FFA_Config_Object__c> location=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim2'  AND isActive__c=true LIMIT 1];         
      
        //Get gla
        List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' AND (Name='2000 - Accounts Payable Control' OR Name='2050 - Accrued Accounts Payable Control')AND isActive__c=true LIMIT 2];

        //Get DIM 1-4 
        List<FFA_Config_Object__c> department = [SELECT Id,Name,Type__c,isActive__c,Delegate_s_Threshold_Amount__c,Teamlead__c FROM FFA_Config_Object__c WHERE Type__c = 'dim1'AND Name LIKE 'Information Technology'AND isActive__c = true LIMIT 1];       
        List<FFA_Config_Object__c> dim2 = [SELECT Id,Name,Type__c,isActive__c FROM FFA_Config_Object__c WHERE Type__c = 'dim2' AND isActive__c = true LIMIT 1];  
        List<FFA_Config_Object__c> dim3=[SELECT id FROM FFA_Config_Object__c WHERE Type__c='dim3'  AND isActive__c=true LIMIT 1];
        List<FFA_Config_Object__c> dim4 = [SELECT Id,Name,Type__c,isActive__c FROM FFA_Config_Object__c WHERE Type__c = 'dim4' AND isActive__c = true LIMIT 1];                       
        
        //Create Account
        Account account1 = new Account();
        account1.Name='John Doe';
        account1.CurrencyIsoCode = 'KES';
        account1.RecordTypeId = '012D0000000KE7iIAG';//Sanergy Employee Accounts
        INSERT account1;
        
        System.debug('account1 = ' + account1);  		
        
        //create EPR
        Electronic_Payment_Request__c epr=new Electronic_Payment_Request__c();
        epr.department__c=department.get(0).Id;
        epr.Company__c='Sanergy Ltd';
        epr.Vendor_Company__c = account1.Id;
        epr.Invoice_Number__c='INVOICE1234'; 
        //epr.Vendor_Invoice_Number__c = vi.Id;
        epr.Scheduled_Payment_Date__c=Date.today();              
        epr.Payment_Type__c='Prepayment';
        epr.Preferred_Payment_Method__c = 'Check';
        epr.Status__c='Open';
        epr.Team_Lead_Approval_Status__c=null;          
        INSERT epr;      

        //Create EPR Line items
        EPR_Payable_Item__c eprPayable=new EPR_Payable_Item__c();
        eprPayable.EPR__c=epr.id;
        eprPayable.Item__c='test Item';
        eprPayable.Unit_Price__c=department.get(0).Delegate_s_Threshold_Amount__c+1;
        eprPayable.Quantity__c=1;
        eprPayable.Department_dim1__c=department.get(0).Id;
        eprPayable.Location_Dim2__c=location.get(0).Id;
        eprPayable.Dim_3__c=dim3.get(0).Id;
        eprPayable.Grant_Funding_Availale_dim4__c=dim4.get(0).Id;
        eprPayable.GLA__c=gla.get(0).Id;    
        INSERT eprPayable;
        
         // Get the EPR we just updated            
        Approval.ProcessSubmitRequest appEpr = new Approval.ProcessSubmitrequest();
        appEpr.setObjectId(epr.Id);                
        Approval.ProcessResult result1 = Approval.process(appEpr);
        
         //Reassign to current user
        Set<Id> AppObjectIds = new Set<Id>();
        AppObjectIds.add(epr.id);
        List<ProcessInstanceWorkItem> pi = [SELECT Id, ActorId FROM ProcessInstanceWorkItem 
                                      WHERE ProcessInstance.TargetObjectId IN : AppObjectIds];
        //loop through and assign to current user
        for(ProcessInstanceWorkItem item: pi){
            item.ActorId = UserInfo.getUserId();
        }
        
        UPDATE pi;
        
        PageReference pageRef = Page.BulkApprovalController;
        Test.setCurrentPage(pageRef);
        //create instance of BulkApprovalController controller
        BulkApprovalController controller = new BulkApprovalController();
 
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperEPRs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
       }      
                    
       
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperSPRs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }
        for(BulkApprovalController.ApprovalsWrapper w : controller.getMaintenanceTaskWrapper()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperRecruitRequisition()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperEmpRoles()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }       
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperELRs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPRs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
        }
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPRLINEs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
        }
        /*
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperFLEET()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
        }
        
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperJOBs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
        }
		*/
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPOs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }
        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperPOIs()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
            
        }

        for(BulkApprovalController.ApprovalsWrapper w : controller.getWrapperALLOWANCES()){
            w.selectedApprovalOption = 'Approve';
            pageRef.getParameters().put('objectType', w.objectType);
            controller.save();
        }        
       // Test.stopTest();
        //get approvals
        controller.getWrapperALLOWANCES();
        //mark allowances reject
        controller.markAllAllowancesRej();
        
        //mark allowances approve
        controller.markAllAllowancesApp();
        controller.getPURCHASE_ORDER_ITEM();        
        controller.getEPR_NAME();
        controller.getPR_NAME();
        controller.getPR_LINE_NAME();
        //controller.getFLEET_NAME();
        //controller.getCONTRACTOR_JOB_NAME();
        controller.getSTAFF_ALLOWANCES_NAME();
        controller.getPURCHASE_ORDER_NAME(); 
        
        controller.getSPECIAL_PROCUREMENT_NAME();
        controller.getRECRUITMENT_REQUISITION();
        controller.getEMPLOYEE_Role();
        controller.getASSET_MAINTENANCE_TASK();
        
        //Approve Allowances
        controller.saveAllowanceActions();
        
        controller.save();
        controller.a();
        //controller.b();
        //controller.c();
        //controller.d();
        //controller.e();
        
        //}
    }
}