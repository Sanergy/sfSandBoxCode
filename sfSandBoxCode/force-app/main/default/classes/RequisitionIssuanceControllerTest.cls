@isTest(SeeAllData=true)
public class RequisitionIssuanceControllerTest {
    
    static testMethod void TestIssuance(){
        
         //Get Department
       List<FFA_Config_Object__c> department = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim1' and isActive__c=true AND Teamlead__c <> null LIMIT 1];      
       //Get Department
       List<FFA_Config_Object__c> dim2 = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim2' and isActive__c=true LIMIT 1];      
		//Get Department
       List<FFA_Config_Object__c> dim3 = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim3' and isActive__c=true LIMIT 1];      
       //Get Department
       List<FFA_Config_Object__c> dim4 = [SELECT id FROM FFA_Config_Object__c WHERE type__c='dim4' and isActive__c=true LIMIT 1];      
                            
        //Get Company
       List<FFA_Config_Object__c> company= [SELECT id FROM FFA_Config_Object__c WHERE type__c='company' and isActive__c=true LIMIT 1];
       
        //Get employee
       List<Employee__c> employee = [SELECT id FROM Employee__c WHERE Employee_Active__c=true AND Work_Email__c!=null LIMIT 1];
       
        //Get gla
       List<FFA_Config_Object__c> gla= [SELECT id FROM FFA_Config_Object__c WHERE type__c='gla' and isActive__c=true LIMIT 2];
        
        // Create a Currency Config
		Currency_Config__c cc = new Currency_Config__c();
        cc.Name = 'KES';
        cc.Start__c = date.today();
        cc.End__c = date.today();
        cc.Value__c = 1;
        cc.Currency_Name__c='Kenyan Shilling';
        cc.Current__c = true;
        INSERT cc;
        
		// Create Inventory_UoM__c
        Inventory_UoM__c iUom = new Inventory_UoM__c();
        iUom.Name = 'Dummy Inventory UOM 1';
        iUom.Description__c = 'Dummy Inventory UOM one';
        iUom.Uom_Code__c = '101';
        iUom.CurrencyIsoCode = 'KES';
        INSERT iUom;
        
		// Create Inventory_Item_Group__c
        Inventory_Item_Group__c invItemGroup = new Inventory_Item_Group__c();
        invItemGroup.Name = 'New Inventory Item Group';
        invItemGroup.Commodity_Code__c = 'New Commodity code';
		invItemGroup.Description__c = 'Brief description';
            
        INSERT invItemGroup;
        
        Group_Details__c debitAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Debit', 
            Transaction_ID__c = 'INVLOCADJ',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(0).Id
        );
        
        insert debitAc;
        
        Group_Details__c creditAc = new Group_Details__c(
            Inventory_Item_Group__c = invItemGroup.Id,
            Credit_Debit__c = 'Credit', 
            Transaction_ID__c = 'INVLOCADJ',
            Is_GL_Account__c = true,
            Config_Account__c = gla.get(1).Id
        );
        
        insert creditAc;
        
        Inventory_Location__c site = new Inventory_Location__c(
           Name = 'Mukuru'
        );
        insert site;
        
		// Create Inventory_Item__c
        Inventory_Item__c invItem = new Inventory_Item__c();
        invItem.Name='Inventory Item 1';
        invItem.Item_Number__c = '123456';
        invItem.Item_Description__c = 'brief description';
        invItem.Item_Type__c = 'Stock';
        invItem.Item_Company__c = company.get(0).Id;
        invItem.Responsible_Department__c = department.get(0).Id;
        invItem.Inventory_UoM__c = iUom.Id;
        invItem.Item_Group__c = invItemGroup.Id;
        invItem.Default_Location__c = 'Mukuru';
        invItem.Default_Lot__c = '3';
        invItem.Currency_Config__c = cc.Id;
        invItem.unit_cost__c = 20;
            
        INSERT invItem;
        
        Inventory_Item_Location__c itmloc = new Inventory_Item_Location__c(
            Name = site.Name,
            Location_Name__c = '001',
            Location__c = site.Id,
            Inventory_Item__c = invItem.Id,
            Max_Location_Quantity__c = 100
        );
        
        insert itmloc;
        
        Item_Location_Lot__c lot = new Item_Location_Lot__c(
            Lot_Name__c = '001',
            Quantity__c = 10,
            Item_Location__c = itmloc.Id
        );
                
        insert lot;
        
        Inventory_Requisition__c requisition = new Inventory_Requisition__c(
            Creator__c = employee.get(0).Id,
            Requestor__c = employee.get(0).Id,
            Request_Date__c = System.today(),
            Required_Date__c = System.today(),
            Company__c = company.get(0).Id,
            Department__c = department.get(0).Id,
            Dimension_2__c = dim2.get(0).Id,
            Dimension_3__c = dim3.get(0).Id,
            Dimension_4__c = dim4.get(0).Id
        );
        
        insert requisition;
        
        Inventory_Requisition_Item__c requisitionItem = new Inventory_Requisition_Item__c(
            Inventory_Item__c = invItem.Id,
            Inventory_Requisition__c = requisition.Id,
            GLA__c = gla.get(0).Id,
            Quantity__c = 5
        );
        
        insert requisitionItem;
            
        List<User> u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        
        System.runAs(u.get(0)) {
            PageReference pageRef = Page.InventoryItemIssue;
            
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(requisition);
            RequisitionIssuanceController controller = new RequisitionIssuanceController(sc);
            controller.unselectAll();
            controller.selectAll();
            controller.getSites();
            
            for(RequisitionIssuanceController.IssuanceItem item : controller.getIssuanceList()){
                item.issueQuantity = 5;
                item.site = site.Id;
                item.setLocs();
                item.location = itmloc.Id;
                item.setLots();
                item.lot = lot.Id;
                item.selectLot();
            }
            
            controller.processSelected();
            
            //create an issuance record to test the issuance trigger on over issuance
            Inventory_Requisition_Issuance__c issReq = new Inventory_Requisition_Issuance__c();
            issReq.Inventory_Requisition_Item__c = requisitionItem.id;
            issReq.Quantity__c = 5000;
            issReq.Date_Issued__c = date.today();
            issReq.Received_By__c = employee.get(0).Id; 
            issReq.Issued_By__c = employee.get(0).Id; 
            try {
               INSERT issReq; 
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            }
            
        }
    }
}