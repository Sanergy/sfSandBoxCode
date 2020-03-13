public class CreatePRFromAssetMaintenanceTask {
    
    public ApexPages.StandardController standardController;
    public Asset_Maintenance_Task__c assetTask;
    public Boolean HighPriority{get;set;}
    public List<Maintenance_Service_Items__c> POArray{get;set;}
    public List<Maintenance_Service_Items__c> POArrayList{get;set;}
    public Integer x{get;set;}
    public Integer y{get;set;}
    @testvisible Public Sanergy_Asset__c asst{get;set;}
    
    //CREATE INSTANCE OF pr
    Procurement_Tracking_Sheet__c pr = new Procurement_Tracking_Sheet__c();
    //instance of inventory
    Inventory_Requisition__c invent = new Inventory_Requisition__c();
   
    public List<Maintenance_Service_Items__c> maintainServeItem {get; set;}
    LIST<Inventory_Requisition__c> inventoryReq = new List<Inventory_Requisition__c>();
    
    //constructor
    public CreatePRFromAssetMaintenanceTask(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.assetTask = (Asset_Maintenance_Task__c)standardController.getRecord();
        this.assetTask =[
            SELECT Id,Name,Maintenance_Type__c,Dim_1__c,assetId__c,GLA__c,Service_Date__c,Proposed_Service_Date__c,
            Completion_Date__c,Assigned_To__c,Repair_Cost__c,Requesting_Company__c,Is_Retrospective__c
            FROM Asset_Maintenance_Task__c
            WHERE Id =: this.assetTask.Id 
        ]; 
        
       getServiceItems();
        
    }
    public List<Maintenance_Service_Items__c>getServiceItems(){
                 //select to get if the item is of type po or inventory
        maintainServeItem = [SELECT id,Name,Asset_Maintenance_Task__c,Cost_Price__c,
                             Inventory_Item__c,Inventory_UoM__c,Item_Description__c,Purchase_Order_Item__c,Asset_Service_Item__c,
                             Quantity__c,Specification__c,Unit_Item_Cost__c,Uom_Conversion_Factor__c,Vendor__c,RecordType__c
                             FROM Maintenance_Service_Items__c
                             WHERE Asset_Maintenance_Task__c =: this.assetTask.Id
                            ]; 
        
        return maintainServeItem;
    }
    //test function
    public void testMeth(){
       // CreatePR();
    }
    
    public Integer testMethtwo(){
        Integer x = 10;
        return x;
    }
   
    public Integer testMethThree(){
        Integer y = 30;
        return y;
    }
    //End of Test functions
    
    //function to create pr
    public PageReference CreatePR(){

       //Create two arrays to hold all the line items
        
        List<Maintenance_Service_Items__c> POArray = new List<Maintenance_Service_Items__c>();
        List<Maintenance_Service_Items__c> InventoryArray = new List<Maintenance_Service_Items__c>();
        
        for(Maintenance_Service_Items__c serve: maintainServeItem){
            if(serve.RecordType__c == 'Inventory Consumables'){
                //ADD ALL ITEMS TO ARRAY WITH SAME RECORD TYPE
                InventoryArray.add(serve);
                
            }else{
                //add all items to inventory array
                POArray.add(serve);
            }
        }
        
        //CHECK IF Po items array has items in it then create pr and add line items
        //else if inventory array has items also create inventory
        if(POArray.size() > 0 ){
            //create PR AND LOOP THGROUTH THE ARRAY TO CREATE THE LINE ITEMS
            
            //get the userid from employeeinfo
            Employee__c employee =  [select id from Employee__c where Employee_SF_Account__c =:userinfo.getuserid()];
            
            FFA_Config_Object__c idMaintenanceDpt =[SELECT id,Name 
                                                From FFA_Config_Object__c 
                                                WHERE Name =  'Maintenance'
                                                LIMIT 1
                                               ]; 
            //Get the the Requesting Compnay and Requesting Department form the Assets
            Sanergy_Asset__c asst = [SELECT Id,Sanergy_Department__c,Requesting_Company__c
                                    FROM Sanergy_Asset__c
                                    WHERE Id =: assetTask.assetId__c  
                                    ];
            
            //create pr
            pr.Asset_Maintenance_Task__c = assetTask.id;
            pr.Requestor_Type__c = 'Employee';
            pr.Required_Date__c = assetTask.Proposed_Service_Date__c;
            pr.Requesting_Department__c = asst.Sanergy_Department__c;
            pr.Maintenance_Department__c = idMaintenanceDpt.Id; 
            pr.Requestor__c = employee.id;
            pr.Requesting_Company__c = asst.Requesting_Company__c;
            
            //get curr date
            Date todaysDate = system.today();
            
            //check if service date is less than today then set retrospective to true
           // if(assetTask.Proposed_Service_Date__c < todaysDate){}
          // else if(assetTask.Proposed_Service_Date__c >= todaysDate && assetTask.Proposed_Service_Date__c <= todaysDate+7 ){ }
            if( HighPriority == true){
                 //set priority to high
                pr.Priority__c = 'High';
                pr.High_Priority_Comments__c = 'Repairs Needed';
                pr.Is_Retrospective__c = 'No';
                pr.PR_Source__c = '	Asset Maintenance Task - BM';
                
            }
            else {
                pr.Priority__c = 'Low';
                pr.Is_Retrospective__c = 'No';
                pr.PR_Source__c = assetTask.Maintenance_Type__c;  
            }
            insert pr;
            
            //add the created pr lnk to the asset maintenance
            assetTask.Procurement_Request__c = pr.id;
            update assetTask;
            
            //insert prline items
            createPRLineItem(POArray);
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(pr.Id);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1); 
            
        } 
        //check if inventory has items
        if (InventoryArray.size() > 0){ //if inventory array has items then create inventory
            
            Employee__c employee =  [select id from Employee__c where Employee_SF_Account__c =:userinfo.getuserid()];
            
            //create inventory
            invent.Asset_Maintenance_Task__c = assetTask.id;
            invent.Creator__c = employee.ID;
            invent.Requestor__c = employee.ID;
            invent.Request_Date__c = Date.today();
            invent.Required_Date__c = assetTask.Proposed_Service_Date__c;
            invent.Company__c = assetTask.Requesting_Company__c;
            invent.Department__c = assetTask.Dim_1__c;
            invent.Dimension_3__c = 'aEBD00000008SGk';
            invent.Stage__c = 'Open';
            
            //insert the details in the object
            insert invent;
            
            //insert Inventory items;
            createInventoryItem(InventoryArray);
            
            //add the created pr lnk to the asset maintenance
            assetTask.Inventory_Requisition__c = invent.id;
            update assetTask;
        }
        
        //redirect to the created pr page
        return new PageReference('/' + assetTask.Id);
    }
    
    
    
    //method to add inventory line items
    public void createInventoryItem(List<Maintenance_Service_Items__c> InventoryArray){
        //loop through inventory array to create inventory line items
        for(Maintenance_Service_Items__c inv : InventoryArray){
            
            //create inventory items
            Inventory_Requisition_Item__c invItem = new Inventory_Requisition_Item__c();
            
            invItem.Inventory_Requisition__c = invent.id;
            invItem.Inventory_Item__c = inv.Inventory_Item__c;
            invItem.Quantity__c = inv.Quantity__c;
            invItem.GLA__c = assetTask.GLA__c;
            
            //insert it to the object
            insert invItem; 
        }
    }
    
    //method to add pr line items
    public void createPRLineItem(List<Maintenance_Service_Items__c> POArray){
        
        //LOOP THROUGH MAINTSERVE ARRAY TO GET ALL ELEMENTS TO CREATE PRLINEITEMS
        for(Maintenance_Service_Items__c serveItem: POArray){
            
            //create prline for the elements
            PTS_Line_Item__c prItem = new PTS_Line_Item__c(Procurement_Tracking_Sheet__c = pr.Id); 
            //prItem.Procurement_Tracking_Sheet__c = pr.Id;
            prItem.Department__c = assetTask.Dim_1__c;
            prItem.Inventory_Item__c = serveItem.Inventory_Item__c;
            prItem.Requesting_Company__c = assetTask.Requesting_Company__c;
            prItem.Item__c = serveItem.Name;
            prItem.Specifications__c = serveItem.Specification__c;
            prItem.Quantity__c = serveItem.Quantity__c;
            prItem.Currency_Config__c = 'aHQD0000000blJJ';
            prItem.Budget_Amount__c= serveItem.Cost_Price__c;
            
            //Get the POI
            Purchase_Order_Item__c poi = [SELECT Id
                                         FROM Purchase_Order_Item__c 
                                         WHERE Id =: serveItem.Purchase_Order_Item__c	
                                         ];
                
            prItem.Purchase_Order_Item__c = poi.id; 
            //prItem.non_primary_vendor_description__c = 'coment';
            prItem.RequestType__c = 'Service';
            prItem.Dim_2__c = 'aEBD00000008SFA';
            prItem.Dim_3__c = 'aEBD00000008SGk';
            prItem.Grant__c = 'aEBD00000008SHk';
            prItem.GLA__c = assetTask.GLA__c;
            prItem.Specifications__c = serveItem.Specification__c;
            prItem.Asset_Id__c = assetTask.assetId__c;
            
            //insert it to the object
            insert prItem;   
        }
    }
    
}