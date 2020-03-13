public class AddServiceItems {
    
    //variables
    public List<Purchase_Order_Item__c> purchase_order_item {get;set;}
    public Asset_Maintenance_Task__c amt;
    public ApexPages.StandardController controller;
    Public Integer quantity{get;set;}
    public Maintenance_Service_Items__c del;
    Public Asset_Service_Item__c mainIt {get;set;}
    //Public Asset_Service_Item__c service {get;set;}
    
    
    public List<Maintenance_Service_Items__c> addattendeeList  {get;set;}
    public List<Maintenance_Service_Items__c> delattendeeList {get;set;}
    public List<Maintenance_Service_Items__c> attendeeList  {get;set;}
    public Integer totalCount {get;set;}
    public Integer rowIndex {get;set;}
    Public string specifications{get;set;}
    Public Decimal costPrice{get;set;}
    
    //Maintenance Service Items
    //Maintenance_Service_Items__c maintenance_service = new Maintenance_Service_Items__c();
    
    public List<Maintenance_Service_Items__c> delAttendees {get; set;} 
    
    //constructor
    Public AddServiceItems(ApexPages.StandardController standardController){
        
        amt = (Asset_Maintenance_Task__c)standardController.getRecord();
        
        amt = [SELECT NAME, ID ,Requesting_Company__c
               FROM Asset_Maintenance_Task__c 
               WHERE Id =: amt.Id
              ];  
        
        attendeeList = [SELECT Name,Asset_Maintenance_Task__c,Asset_Service_Item__c,Asset_Service_Item__r.Name,Cost_Price__c,Company__c,Inventory_Item__c,Inventory_UoM__c,
                        Item_Description__c,Purchase_Order_Item__c,Quantity__c,RecordType__c,Specification__c,Unit_Item_Cost__c,Uom_Conversion_Factor__c,
                        Vendor__c
                        FROM Maintenance_Service_Items__c 
                        WHERE Id =: amt.Id];
        
        //System.debug(amt.Requesting_Company__c);
        
        totalCount = attendeeList.size();
        
        delattendeeList = new List<Maintenance_Service_Items__c>();
        delattendees = new List<Maintenance_Service_Items__c>();
        
        //getAllPOitems();
        //getItems();
    }
    
    //adding a row
    public void addRow(){
        
         //System.debug('BEFORE --------> ' + attendeeList);
        //addattendeeList = new List<Maintenance_Service_Items__c>();
        attendeeList.add(new Maintenance_Service_Items__c());
       // System.debug('AFTER --------> '+attendeeList);
  
    }
    //saving the list of items
    public PageReference save(){
        system.debug('ATTENDEE KIST'+ attendeeList);
        
        attendeeList.add(new Maintenance_Service_Items__c(Asset_Maintenance_Task__c = amt.Id,Quantity__c = quantity));
        
        upsert attendeeList;
        delete delattendeeList;
        return (new ApexPages.StandardController(amt)).view();
        
    } 
    //Delete a row from the added items
    public void deleteRow(){
        
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        System.debug('rowbe deleted ' + rowIndex );
        System.debug('rowm to be deleted '+attendeeList[rowIndex]);
        del = attendeeList.remove(rowIndex);
        delattendeeList.add(del);
        
    }
    
    //method to autopopulate
    public void autopopulate(){
        
        //get the asset service item of the row
        for(Maintenance_Service_Items__c itm : attendeeList){
            
            //query to get theee details required
            mainIt = [SELECT Id, Name,Inventory_Uom__c,Inventory_Item__c,Purchase_Order_Item__c 
                      FROM Asset_Service_Item__c
                      WHERE Id =: itm.Asset_Service_Item__c
                      
                     ]; 
            //Asset_Service_Item__c mainIt = new Asset_Service_Item__c();
            //System.debug('Main it >>>>' + mainIt +'itm.Id' + itm.ID  );
            //attendeeList.add(new Maintenance_Service_Items__c(Asset_Maintenance_Task__c = amt.Id));
        }  
        
        
    }
    
}