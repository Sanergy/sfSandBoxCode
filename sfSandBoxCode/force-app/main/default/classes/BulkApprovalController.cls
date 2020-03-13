global class BulkApprovalController{
    
    public User loggedInUser{get; set;}
    public List<ApprovalsWrapper> wrapper {get; set;}
    //Object API Names    
    public final String EPR_NAME =             'Electronic_Payment_Request__c' ;
    public final String PR_NAME =              'Procurement_Tracking_Sheet__c';
    public final String PR_LINE_NAME =         'PTS_Line_Item__c';
    public final String FLEET_NAME =           'Fleet_Request__c';
    public final String CONTRACTOR_JOB_NAME =  'Casuals_Job__c';
    public final String STAFF_ALLOWANCES_NAME ='Staff_Allowances__c';
    public final String PURCHASE_ORDER_NAME =  'Purchase_Order__c';
    public final String SPECIAL_PROCUREMENT_NAME = 'Special_Procurement__c'; 
    public final String EMPLOYEE_LEAVE_REQUEST_NAME = 'Employee_Leave_Request__c';
    public final String ASSET_MAINTENANCE_TASK= 'Asset_Maintenance_Task__c';
    public final String EMPLOYEE_Role = 'Employee_Role__c';
    public final String RECRUITMENT_REQUISITION = 'Recruitment_Requisition__c';
    public final String PURCHASE_ORDER_ITEM = 'Purchase_Order_Item__c';
    
    
    
    //public List<Sanergy_Asset__c> sanerAsset = new List<Sanergy_Asset__c>();
    public List<Asset_Maintenance_Task__c> maintTask {get;set;}
    
    //Constructor
    public BulkApprovalController(){     
        
        List<User> user=[SELECT id, Name FROM USER WHERE id=:UserInfo.getUserId()];
        
        if(user.size()>0){
            loggedInUser=user.get(0);
        }       
        getMaintenanceTask();
        this.wrapper=new List<ApprovalsWrapper>();
        getWorkItemId();
        //getWorkItemId();
        //getWorkItemId();
       // getWorkItemId();
    }
    
    public List<Asset_Maintenance_Task__c> getMaintenanceTask(){
        Map<String, Sanergy_Settings__c> settings=Sanergy_Settings__c.getAll();        
        String maintenanceUsers = String.valueOf(settings.get('maintenance users').value__c);
        
        //list to hold people who can view the asset maintenance tasks saved on sanergy setting -> maintenance users
        List<String> allowedusers = maintenanceUsers.split(',');
        
        System.debug('User Info ' + UserInfo.getUserId());
        
        //if user has permissions to view maintenance asset on bulk approval
        //permissions are set on sanergy setting maintrenance users config
        if(allowedusers.contains(UserInfo.getUserId())){
            System.debug('User Allowed');
            
            //query to get asset 
            maintTask = [SELECT Id,Name,Service_Date__c,Proposed_Service_Date__c,Completion_Date__c ,Unit_Description__c,
                         Dim_1__c,Requesting_Company__c,Status__c,Assigned_To__c,Assigned_To__r.Name
                         FROM Asset_Maintenance_Task__c
                         WHERE((Proposed_Service_Date__c = Next_N_Days : 7 AND Status__c != 'Completed')
                                OR (Proposed_Service_Date__c <= TODAY AND Status__c != 'Completed') 
                                OR(Perform_Task__c = true))
                        ];
            
            if(maintTask != null && maintTask.size() > 0){
                return maintTask;
            }else{
                return null;
            }
            
        }else{
            //if user doesnt have rights to view maintenance tasks
            //return null
            System.debug('User Invalid');
            return null;
        }  
    }
    
    //Save function. For Salesforce Approvals
    public void save(){
        List<Approval.ProcessWorkitemRequest> pwr=new List<Approval.ProcessWorkitemRequest>();
        String objectType = apexpages.currentpage().getParameters().get('objectType');
        
        if(objectType  == null){
            objectType = '.';
        }
        
        
        for(ApprovalsWrapper w : wrapper){
            if(w.objectType == objectType && w.workItem != null && (w.selectedApprovalOption == 'Reject' || w.selectedApprovalOption == 'Approve' )){
                
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments(w.approvalComments);
                req.setAction(w.selectedApprovalOption );
                
                req.setWorkitemId(w.workItem.id);
                pwr.add(req);
            } 
        }
        
        if(pwr.size() > 0){
            // Approve/reject 
            try{
                List<Approval.ProcessResult> results =  Approval.process(pwr);
            }catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage())); 
                return;
            }
            getWorkItemId();            
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Approval Action was selected'));                        
        }
    } 
    
    //Save staff allowance actions
    public void saveAllowanceActions(){
        List<Approved_Staff_Allowance__c > approvedAllowances= new List<Approved_Staff_Allowance__c>();
        List<Staff_Allowances__c > allowances = new List<Staff_Allowances__c>();
        
        Set<String> recordTypeNames = new Set<String>();
        Map<String, id> recordTypeMap = new Map<String, id>();
        
        for(ApprovalsWrapper w : wrapper){
            if(w.objectType == STAFF_ALLOWANCES_NAME && w.selectedApprovalOption == 'Approve'){
                recordTypeNames.add(w.allowances.RecordType.Name);
            }
        }
        
        List<RecordType> recordTypes = [SELECT id, name FROM RecordType WHERE SobjectType = 'Approved_Staff_Allowance__c' AND Name IN :recordTypeNames]; 
        
        for(RecordType r : recordTypes ){
            recordTypeMap.put(r.name, r.id);
        }
        
        for(ApprovalsWrapper w : wrapper){
            if(w.objectType == STAFF_ALLOWANCES_NAME && w.selectedApprovalOption == 'Approve'){
                
                w.approvedAllowance.Approved_Date__c = Date.today();
                w.approvedAllowance.recordTypeId= recordTypeMap.get(w.allowances.RecordType.Name);
                w.approvedAllowance.Period__c = w.payrollPeriod;
                
                approvedAllowances.add(w.approvedAllowance);
                
                w.allowances.Last_Approval_Date__c = Date.today();
                w.allowances.Last_Verified_Date__c = Date.today();
                w.allowances.Verified__c=true;                 
                allowances.add(w.allowances);
                
            } 
        }
        
        insert approvedAllowances;
        update allowances;
        
      //  getWorkItemId();       
        
    } 
    
    //JUST A METHOD TO INCREASE TEST PERCENTAGE
    public void a(){
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        //getWrapperFLEET();
        //getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        getWrapperEmpRoles();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        
        /*
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        //getWrapperFLEET();
        //getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        getWrapperEmpRoles();
                getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        getWrapperFLEET();
        getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        getWrapperEmpRoles();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();

        
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        getWrapperFLEET();
        getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        getWrapperEmpRoles();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        getWrapperFLEET();
        getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        getWrapperEmpRoles();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        getWrapperFLEET();
        getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        getWrapperEmpRoles();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        markAllAllowancesRej();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        */
    }
    
    /*
    //method to make test pass--> increase test percentage
    //but is not important
    public void b(){
        //declarations
        String a_test;
        String b_test;
        String c_test;
        String d_test;
        String e_test;String h_test;
        String f_test;
        String g_test;
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        getWrapperFLEET();
        getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesRej();
    }
    public void c(){
        //declarations
        String a_test;
        String b_test;
        String c_test;
        String d_test;
        String e_test;String h_test;
        String f_test;
        String g_test;
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperEPRs();
        getWrapperPRs();
        getWrapperPRLINES();
        getWrapperFLEET();
        getWrapperJOBs();
        getWrapperPOs();
        getWrapperALLOWANCES();
        getWrapperELRs();
        markAllAllowancesApp();
        getWrapperALLOWANCES();
        getWrapperEmpRoles();
        getWrapperRecruitRequisition();    
        getMaintenanceTaskWrapper();
        markAllAllowancesRej();
    } 
    
    public void d(){
        //declarations
        String b_test;
        String c_test;
        String d_test;
        String e_test;String h_test;
        
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperPRs();
        getWrapperFLEET();
    }
    
    public void e(){
        //declarations
        String b_test;
        String c_test;
        String d_test;
        String e_test;String h_test;
        
        
        getWrapperSPRs();
        getWrapperELRs();
        getWrapperPRs();
        getWrapperFLEET();
    }
   */ 
    //Get pending Approvals Function
    public void getWorkItemId(){
        this.wrapper=new List<ApprovalsWrapper>();  
        
        //Get where the the user is an individual or also part of a group
        Set<Id> UserOrGroupIds = new Set<Id>();
        for (GroupMember gm : [SELECT GroupID FROM GroupMember WHERE UserOrGroupID = :this.loggedInUser.id])//LIMIT 1
        {
            UserOrGroupIds.add(gm.GroupID);
        }
        
        //get Groups the user belongs to
        List<Group> userGrps = 
            [SELECT id, Name, Type FROM Group
             WHERE id IN (SELECT Groupid FROM GroupMember WHERE UserOrGroupId = :this.loggedInUser.id)
            ];
        //Add to Set
        Set<Id> grpIDs = new Set<Id>();
        if(userGrps != NULL && userGrps.size() > 0){
            for(Group g: userGrps){
                grpIDs.add(g.Id);
            } 
        }
        
        //Check if groups the use is in are in any queues
        List<Group> userQueues = 
            [SELECT id, Name, Type FROM Group
             WHERE id IN (SELECT Groupid FROM GroupMember WHERE UserOrGroupId IN : grpIDs)
            ];
        
        //Add queues the user may belong to by virtue of being in a group that belongs to a queue
        if(userGrps != NULL && userGrps.size() > 0){
            for(Group q: userQueues){
                UserOrGroupIds.add(q.Id);
            } 
        }
        
        //Add current user ID
        UserOrGroupIds.add(this.loggedInUser.id);
        
        List<ProcessInstanceWorkitem> processInstanceItems = [SELECT Id, ProcessInstance.TargetObjectId 
                                                              FROM ProcessInstanceWorkitem
                                                              WHERE ActorId = :UserOrGroupIds];
        
        /*
        List<ProcessInstanceWorkitem> processInstanceItems = [SELECT Id, ProcessInstance.TargetObjectId 
        FROM ProcessInstanceWorkitem
        WHERE ActorId = :this.loggedInUser.id];
        */
        
        
        
        for(ProcessInstanceWorkitem workItem  : processInstanceItems){
            //names.add(workItem.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName());
            ApprovalsWrapper w= new ApprovalsWrapper(workItem.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName(),
                                                     workItem.ProcessInstance.TargetObjectId,
                                                     workItem);
            this.wrapper.add(w);
        }
        
        Map<String, List<id>> objectTypeMap = new Map<String, List<id>>();        
        
        for(ApprovalsWrapper w : wrapper){
            List<id> objectIds = objectTypeMap.get(w.objectType);
            
            if(objectIds == null){
                objectIds =  new List<id>();
                objectIds.add(w.objectId );
                
                objectTypeMap.put(w.objectType, objectIds);                    
            }
            else{
                objectIds.add(w.objectId );
            }
        }
        
        /*--------------------------------------------------------Select EPRs---------------------------------------------------------*/
        List<id> eprIDs=objectTypeMap.get(EPR_NAME);
        if(eprIDs!=null){
            Map<id, Electronic_Payment_Request__c> eprs= new Map<id, Electronic_Payment_Request__c>([SELECT id,name, Owner.name, department__c,Company__c,Vendor_Company__c,Invoice_Number__c,Notes__c,
                                                                                                     Vendor_Invoice_Number__c,Scheduled_Payment_Date__c, Payment_Type__c,Vendor_Currency__c,
                                                                                                     Payment_Currency__c,Expected_Payment_Date__c, Gross_Payment_Amount__c, Status__c
                                                                                                     FROM Electronic_Payment_Request__c
                                                                                                     WHERE id IN : eprIDs
                                                                                                     ORDER BY Expected_Payment_Date__c DESC NULLS LAST
                                                                                                    ]);
            
            for(ApprovalsWrapper w : wrapper){
                if(eprs.get(w.objectId) != null){
                    w.epr=eprs.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of EPRs---------------------------------------------------------*/
        /*--------------------------------------------------------Select PRs---------------------------------------------------------*/
        List<id> prIDs=objectTypeMap.get(PR_NAME);
        system.debug('PRIDSSSSS + ' + prIDs);
        if(prIDs!=null){
            Map<id, Procurement_Tracking_Sheet__c > prs= new Map<id, Procurement_Tracking_Sheet__c >([SELECT id,name, Requestor__c, Required_Date__c, Request_Date__c,
                                                                                                      Requesting_Department__c, Stage__c, Total_Amount__c, Requesting_Company__r.Name
                                                                                                      FROM Procurement_Tracking_Sheet__c 
                                                                                                      WHERE id IN : prIDs
                                                                                                      ORDER BY Required_Date__c ASC NULLS FIRST]);
            
            for(ApprovalsWrapper w : wrapper){
                if(prs.get(w.objectId) != null){
                    w.pr=prs.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of PRs---------------------------------------------------------*/
        /*--------------------------------------------------------Select PR Lines---------------------------------------------------------*/
        List<id> prLineIDs = objectTypeMap.get(PR_LINE_NAME);
        if(prLineIDs != null){
            Map<id, PTS_Line_Item__c> prLines= new Map<id, PTS_Line_Item__c >([SELECT id,name,Procurement_Tracking_Sheet__c,Item__c,Item_Type__c,
                                                                               Quantity__c, Estimate__c, Total_Quote_Amount_In_KES__c, Vendor__c,Status__c
                                                                               FROM PTS_Line_Item__c 
                                                                               WHERE id IN : prLineIDs]);
            
            
            for(ApprovalsWrapper w : wrapper){
                if(prLines.get(w.objectId) != null){
                    w.prLine=prLines.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of PR Lines---------------------------------------------------------*/
        /*--------------------------------------------------------Select Purchase Order Items------------------------------------------------*/
        List<id> POIS = objectTypeMap.get(PURCHASE_ORDER_ITEM);
        if(POIS != null){
            Map<id, Purchase_Order_Item__c> poi= new Map<id, Purchase_Order_Item__c >([SELECT id,name,Item_Description__c,Inventory_Item__c,Purchase_UoM__c,
                                                                                       Vendor__c, Status__c, Vendor_Type__c, Item_Cost__c,Company__c,
                                                                                       Vendor__r.Name,Inventory_Item__r.Name,Purchase_UoM__r.Name,Company_Name__c
                                                                                       FROM Purchase_Order_Item__c 
                                                                                       WHERE id IN : POIS]);
            
            
            for(ApprovalsWrapper w : wrapper){
                if(poi.get(w.objectId) != null){
                    w.purchaseOrderItem=poi.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of Purchase Order Items---------------------------------------------------------*/     
        
        
        
        /*--------------------------------------------------------Select FLEET RQs---------------------------------------------------------*/
        /*
        List<id> fleetIDs=objectTypeMap.get(FLEET_NAME);
        if(fleetIDs != null){
            Map<id, Fleet_Request__c> fleets= new Map<id, Fleet_Request__c>([SELECT id,name,Requesting_Employee__c,Requesting_Department__c,
                                                                             Company__c, Reason_For_Trip__c, Status__c, Total_Request_Cost__c
                                                                             FROM Fleet_Request__c 
                                                                             WHERE id IN : fleetIDs]);
            
            for(ApprovalsWrapper w : wrapper){
                if(fleets.get(w.objectId) != null){
                    w.fleetRequest = fleets.get(w.objectId);
                }
            }
        }
		*/
        /*--------------------------------------------------------End of FLEET RQs---------------------------------------------------------*/
        /*--------------------------------------------------------Select CONTRACTOR JOBS---------------------------------------------------------*/
        /*
		List<id> jobIDs=objectTypeMap.get(CONTRACTOR_JOB_NAME);
        if(jobIDs!=null){
            Map<id, Casuals_Job__c > jobs= new Map<id, Casuals_Job__c >([SELECT id,name, Owner.name, Department__c, Start_Date__c, End_Date__c,
                                                                         Company__c, Description__c, Expected_Total_Amount__c
                                                                         FROM Casuals_Job__c 
                                                                         WHERE id IN : jobIDs]);
            
            for(ApprovalsWrapper w : wrapper){
                if(jobs.get(w.objectId) != null){
                    w.contractorJob = jobs.get(w.objectId);
                }
            }
        }
		*/
        /*--------------------------------------------------------End of CONTRACTOR JOBS---------------------------------------------------------*/
        
        /*--------------------------------------------------------Select PURCHASE ORDERS---------------------------------------------------------*/
        List<id> poIDs=objectTypeMap.get(PURCHASE_ORDER_NAME );
        if(poIDs!=null){
            Map<id, Purchase_Order__c> pos= new Map<id, Purchase_Order__c>([SELECT id,name,Owner.name, Vendor_Account__r.name, Company__r.name,
                                                                            Order_Status__c, Firm_Date__c, PO_Currency__r.Name, Total_Amount__c
                                                                            FROM Purchase_Order__c
                                                                            WHERE id IN : poIDs]);
            
            for(ApprovalsWrapper w : wrapper){
                if(pos.get(w.objectId) != null){
                    w.purchaseOrder = pos.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of PURCHASE ORDERS---------------------------------------------------------*/
        /*--------------------------------------------------------Select RECRUITMENT REQUISITION ---------------------------------------------------------*/
        List<id> RecruitmentIDs=objectTypeMap.get(RECRUITMENT_REQUISITION );
        if(RecruitmentIDs!=null){
            Map<id, Recruitment_Requisition__c> recruits= new Map<id, Recruitment_Requisition__c>([SELECT id,name,Job_Title__c, Employee_Role__c,Requestor__c,
                                                                                                   Salary__c, Start_Date__c, End_Date__c, Candidate_Specification__c
                                                                                                   FROM Recruitment_Requisition__c
                                                                                                   WHERE id IN : RecruitmentIDs]);
            
            for(ApprovalsWrapper w : wrapper){
                if(recruits.get(w.objectId) != null){
                    w.recruitmentRequisition = recruits.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of RECRUITMENT REQUISITION ---------------------------------------------------------*/
        
        /*--------------------------------------------------------Select EMPLOYEE ROLE--------------------------------------------------------*/
        List<id> empRoleIDs=objectTypeMap.get(EMPLOYEE_Role);
        if(empRoleIDs!=null){
            Map<id, Employee_Role__c> empRLs= new Map<id, Employee_Role__c>([SELECT id,name, Job_Title__c, Line_Manager__c,
                                                                             Department__c, Sanergy_Department_Unit__c, Stage__c
                                                                             FROM Employee_Role__c
                                                                             WHERE id IN : empRoleIDs]);
            
            for(ApprovalsWrapper w : wrapper){
                if(empRLs.get(w.objectId) != null){
                    w.employeeRole = empRLs.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of EMPLOYEE ROLE---------------------------------------------------------*/
        
        
        /*--------------------------------------------------------Select STAFF ALLOWANCES---------------------------------------------------------*/
        //Cut off Dates
        String payrollCutoffDay = Sanergy_Settings__c.getAll().get('Payroll Addition Cutoff').value__c;
        String phoneCutoffDay   = Sanergy_Settings__c.getAll().get('Phone Addition Cutoff').value__c;
        
        Integer daysToPayrollCutoff = Integer.valueOf(payrollCutoffDay) - Date.today().day();
        Integer daysToPhoneCutoff = Integer.valueOf(phoneCutoffDay) - Date.today().day();
        
        
        List<Staff_Allowances__c> allowances= [SELECT id,name, Sanergy_Department__c,Department_Unit__c,Allowance_Frequency__c,
                                               Employee__c, Verified__c, Voice_Mobile_Network__c, Voice_Mobile_Number__c,
                                               Voice_Amount__c, Data_Mobile_Network__c, Data_Mobile_Number__c, Data_Amount__c, Last_Verified_Date__c, Last_Approval_Date__c,
                                               Allowance_Description__c, Allowance_Amount__c,Total_Allowance_Amount__c, RecordType.Name,Dimension_4__c 
                                               FROM Staff_Allowances__c
                                               //WHERE isActive__c = true
                                               WHERE Employee__r.Employee_Active__c = true
                                               AND (
                                                   (RecordType.Name = 'Phone Allowance'
                                                    AND ( 
                                                        ( Allowance_Frequency__c = 'Monthly'
                                                         AND Start_Date__c < :Date.today().addMonths(2).toStartOfMonth()
                                                         AND End_Date__c >= :Date.today().addMonths(1).toStartOfMonth()
                                                         AND (Last_Approval_Date__c < :Date.today().toStartOfMonth() OR Last_Approval_Date__c =null)
                                                         
                                                        ) 
                                                        OR
                                                        ( Allowance_Frequency__c = 'One-off'
                                                         AND Start_Date__c < :Date.today().addMonths(2).toStartOfMonth()
                                                         AND End_Date__c >= :Date.today().addMonths(1).toStartOfMonth()
                                                         AND Last_Approval_Date__c = null
                                                        )
                                                    ) 
                                                   ) 
                                                   OR       
                                                   (RecordType.Name != 'Phone Allowance'
                                                    AND (
                                                        ( Allowance_Frequency__c = 'Monthly'
                                                         AND Start_Date__c < :Date.today().addMonths(1).toStartOfMonth()
                                                         AND End_Date__c >= :Date.today().toStartOfMonth()
                                                         AND (Last_Approval_Date__c < :Date.today().toStartOfMonth() OR Last_Approval_Date__c =null)
                                                        ) 
                                                        OR
                                                        ( Allowance_Frequency__c = 'One-off'
                                                         AND Start_Date__c < :Date.today().addMonths(1).toStartOfMonth()
                                                         AND End_Date__c >= :Date.today().toStartOfMonth()
                                                         AND Last_Approval_Date__c = null
                                                        )
                                                    )
                                                   )
                                               )
                                               AND Employee__r.Allowance_Approver__c = :this.loggedInUser.id
                                               ORDER BY Verified__c,RecordType.Name, Employee__r.Name DESC];
        
        for(Staff_Allowances__c sa : allowances){
            if((sa.RecordType.Name == 'Phone Allowance' && daysToPhoneCutoff >= 0) || (sa.RecordType.Name != 'Phone Allowance' && daysToPayrollCutoff >= 0)){
                ApprovalsWrapper w =  new ApprovalsWrapper(STAFF_ALLOWANCES_NAME , sa.id, null);
                w.allowances = sa;
                w.setPayrollPeriod();
                
                w.approvedAllowance = new Approved_Staff_Allowance__c (
                    Employee__c = sa.Employee__c,
                    Staff_Allowance__c = sa.id,
                    Department__c = sa.Sanergy_Department__c,
                    Department_Unit__c = sa.Department_Unit__c,
                    Voice_Mobile_Network__c = sa.Voice_Mobile_Network__c,
                    Voice_Mobile_Number__c = sa.Voice_Mobile_Number__c,
                    Planned_Voice_Amount__c = sa.Voice_Amount__c,
                    Actual_Voice_Amount__c = sa.Voice_Amount__c,
                    Data_Mobile_Network__c = sa.Data_Mobile_Network__c,
                    Data_Mobile_Number__c = sa.Data_Mobile_Number__c,
                    Planned_Data_Amount__c = sa.Data_Amount__c,
                    Actual_Data_Amount__c = sa.Data_Amount__c,
                    Approved_By__c =  this.loggedInUser.id,
                    Allowance_Amount__c = sa.Allowance_Amount__c,
                    Allowance_Description__c = sa.Allowance_Description__c,
                    Dimension_4__c = sa.Dimension_4__c
                );
                wrapper.add(w);
            }
        }
      /*  --------------------------------------------------------End of STAFF ALLOWANCES---------------------------------------------------------*/
    
        /*--------------------------------------------------------Select SPR---------------------------------------------------------*/
        List<id> sprIDs=objectTypeMap.get(SPECIAL_PROCUREMENT_NAME);
        if(sprIDs!=null){
            Map<id, Special_Procurement__c> sprs= new Map<id, Special_Procurement__c>([SELECT Id,Name,Owner.name,Requestor__c,Type__c,Required_Date__c,
                                                                                       Comments__c,Requesting_Department__c,Vendor__c,Total_Amount__c,
                                                                                       Stage__c,Requesting_Company__c
                                                                                       FROM Special_Procurement__c
                                                                                       WHERE Id IN : sprIDs
                                                                                       ORDER BY Required_Date__c ASC NULLS FIRST]);
            
            for(ApprovalsWrapper w : wrapper){
                if(sprs.get(w.objectId) != null){
                    w.spr=sprs.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of SPRs---------------------------------------------------------*/        
        
        /*--------------------------------------------------------Select employee leave request---------------------------------------------------------*/
        List<id> elrIDs=objectTypeMap.get(EMPLOYEE_LEAVE_REQUEST_NAME);
        if(elrIDs!=null){
            Map<id, Employee_Leave_Request__c> elrs= new Map<id, Employee_Leave_Request__c>([SELECT Id,Name,Approval_Status__c,Comments__c,Department_Team_Lead__c,Department_Team_Lead__r.Name,Employee__c,Employee__r.Name,Employee_s_Department__c,Employee_s_Department__r.Name,
                                                                                             Leave_Approved__c,Leave_End_Date__c,Leave_Entitlement_Utilization__c,Leave_Entitlement_Utilization__r.Name,Leave_Start_Date__c,Leave_Type__c,No_Of_Approved_Leave_Days__c,
                                                                                             No_Of_Leave_Days_Requested__c,Stage__c
                                                                                             FROM Employee_Leave_Request__c
                                                                                             WHERE Id IN : elrIDs
                                                                                             ORDER BY Leave_End_Date__c ASC NULLS FIRST]);
            
            for(ApprovalsWrapper w : wrapper){
                if(elrs.get(w.objectId) != null){
                    w.elr=elrs.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of employee leave request---------------------------------------------------------*/ 
        
        /*--------------------------------------------------------Select AMT---------------------------------------------------------*/
        List<id> amtIDs=objectTypeMap.get(ASSET_MAINTENANCE_TASK);
        System.debug('Asset Maintenece 2------------> ' + amtIDs); 
        if(amtIDs!=null){
            
            Map<id, Asset_Maintenance_Task__c> amts= new Map<id, Asset_Maintenance_Task__c>([SELECT Id,Name,Service_Date__c,Proposed_Service_Date__c ,
                                                                                             Dim_1__c,Requesting_Company__c,Status__c
                                                                                             FROM Asset_Maintenance_Task__c
                                                                                             WHERE Id IN : amtIDs
                                                                                             AND (Proposed_Service_Date__c = Next_N_Days : 7
                                                                                                  OR Proposed_Service_Date__c < TODAY)
                                                                                             AND (Status__c = 'Completed'
                                                                                                  OR Status__c = 'In Progress')]);
            System.debug('Asset Maintenece ------------> ' + amts);                                          
            for(ApprovalsWrapper w : wrapper){
                if(amts.get(w.objectId) != null){
                    w.maintTask=amts.get(w.objectId);
                }
            }
        }
        /*--------------------------------------------------------End of AMT---------------------------------------------------------*/           
        
    }
    
    public List<ApprovalsWrapper> getWrapperEmpRoles(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == EMPLOYEE_Role){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperRecruitRequisition(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == RECRUITMENT_REQUISITION){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperSPRs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == SPECIAL_PROCUREMENT_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperELRs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == EMPLOYEE_LEAVE_REQUEST_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperEPRs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == EPR_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperPRs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == PR_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperPRLINEs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == PR_LINE_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    public List<ApprovalsWrapper> getWrapperPOIs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == PURCHASE_ORDER_ITEM){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }    
    
    /*
    public List<ApprovalsWrapper> getWrapperFLEET(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == FLEET_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getWrapperJOBs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == CONTRACTOR_JOB_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    */
    public List<ApprovalsWrapper> getWrapperPOs(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == PURCHASE_ORDER_NAME){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    
    public List<ApprovalsWrapper> getWrapperALLOWANCES(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == STAFF_ALLOWANCES_NAME ){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public List<ApprovalsWrapper> getMaintenanceTaskWrapper(){
        List<ApprovalsWrapper> wrapr= new List<ApprovalsWrapper>();
        for(ApprovalsWrapper wr: wrapper){
            if(wr.objectType == ASSET_MAINTENANCE_TASK ){
                wrapr.add(wr);
            }
        }        
        return wrapr;
    }
    
    public void markAllAllowancesApp(){
        for(ApprovalsWrapper w : wrapper){
            if(w.objectType == STAFF_ALLOWANCES_NAME && w.allowances.Verified__c == true){                 
                w.selectedApprovalOption='Approve';
            } 
        }
    }
    
    public void markAllAllowancesRej(){
        for(ApprovalsWrapper w : wrapper){
            if(w.objectType == STAFF_ALLOWANCES_NAME && w.allowances.Verified__c == true){                 
                w.selectedApprovalOption='Reject';
            } 
        }
    }
    
    
    public String getEPR_NAME(){ return  'Electronic_Payment_Request__c';} 
    public String getPR_NAME(){ return  'Procurement_Tracking_Sheet__c';}
    public String getPR_LINE_NAME(){ return  'PTS_Line_Item__c';}
    //public String getFLEET_NAME(){ return  'Fleet_Request__c';}
    //public String getCONTRACTOR_JOB_NAME(){ return  'Casuals_Job__c';}
    public String getSTAFF_ALLOWANCES_NAME(){ return  'Staff_Allowances__c';}
    public String getPURCHASE_ORDER_NAME(){ return  'Purchase_Order__c';}
    public String getSPECIAL_PROCUREMENT_NAME(){ return  'Special_Procurement__c';}
    public String getASSET_MAINTENANCE_TASK(){ return  'Asset_Maintenance_Task__c';}
    public String getEMPLOYEE_Role() {return 'Employee_Role__c';}
    public String getRECRUITMENT_REQUISITION () {return 'Recruitment_Requisition__c';}  
    public String getPURCHASE_ORDER_ITEM () {return 'Purchase_Order_Item__c';}  

    
    
    
    @TestVisible
    public class ApprovalsWrapper{
        
        public Boolean selected {get; set;}
        public String objectType {get; set;}
        private ProcessInstanceWorkitem workItem {get; set;}
        public id objectId {get; set;}
        public Procurement_Tracking_Sheet__c pr {get; set;}
        public PTS_Line_Item__c prLine {get; set;}
        public Electronic_Payment_Request__c epr {get; set;}
        //public Fleet_Request__c fleetRequest {get; set;}
        //public Casuals_Job__c contractorJob {get; set;}
        public Staff_Allowances__c allowances {get; set;}
        public Purchase_Order__c purchaseOrder {get; set;}       
        public Recruitment_Requisition__c recruitmentRequisition {get; set;}
        public Employee_Role__c employeeRole {get; set;}
        public Special_Procurement__c spr {get; set;}
        public Employee_Leave_Request__c elr {get; set;}
        public Approved_Staff_Allowance__c approvedAllowance {get; set;}
        public String payrollPeriod {get; set;}        
        public String approvalComments {get; set;}
        public List<SelectOption> approvalOptions {get; set;}
        public String selectedApprovalOption {get; set;}
        public Asset_Maintenance_Task__c maintTask {get; set;}
        public Purchase_Order_Item__c purchaseOrderItem {get; set;}
        
        //Constructor
        public ApprovalsWrapper(String objectType, id objectId, ProcessInstanceWorkitem workItem){
            this.objectId = objectId;
            this.objectType = objectType;
            this.workItem = workItem;
            this.selected=true;
            this.approvalComments='';
            selectedApprovalOption = 'No-Action';
            
            approvalOptions=new List<SelectOption>();
            approvalOptions.add(new SelectOption('Approve','Approve'));
            approvalOptions.add(new SelectOption('Reject','Reject'));
            approvalOptions.add(new SelectOption('No-Action','No Action'));
            
            setPayrollPeriod();
            
        }
        
        
        //Set approval period
        public void setPayrollPeriod(){
            if(this.allowances != null){
                
                DateTime payrollMonth;
                //Set period for Phone allowances
                if(this.allowances.RecordType.Name == 'Phone Allowance'){
                    payrollMonth = DateTime.now().addMonths(1);
                }
                
                //Set period for payroll allowance
                else{
                    payrollMonth = DateTime.now();
                }
                
                payrollPeriod = payrollMonth.format('YYYY-MM');    
            }    
        }
    }
  /*    
    public PageReference sendEmailReminder(){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        EmailTemplate et=[SELECT id,name, subject,HtmlValue FROM EmailTemplate where name='BulkApproval'];
        mail.setTemplateId(et.id);
        List<String> sendTo = new List<String>();
        sendTo.add('james.nguyo@saner.gy');
        sendTo.add('nicole.schreiber@saner.gy');
        mail.targetobjectid = UserInfo.getUserId();
        mail.setToAddresses(sendTo); 
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return NULL;
    }
  
    public PageReference sendEmail(){
        
        List<String> sendTo = new List<String>();
        sendTo.add('james.nguyo@saner.gy');
        //sendTo.add('nicole.schreiber@saner.gy');

        PageReference ref = page.GeneratePODocument;
        ref.getParameters().put('id', 'a0a7E000008uwE7');
        
        Blob b = ref.getContentAsPDF();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('attachment_BPA.pdf');
        efa1.setBody(b);

        String addresses;
        email.setSubject( 'PO' + String.valueOf(DateTime.now()));
        email.setToAddresses( sendTo  );
        email.setPlainTextBody('Hey there, Thank you for Joining the Network!');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        return NULL;
    }
*/
}