@isTest(seeAllData = true)
public class CreateEPRFromSpecialProcurementTrigger {
    static testMethod void testCreateEPRFromSpecialProcurement(){
        
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
        //Get employee
        //James ID - need to make sure emp selected has a TL for the sharing reasons to work 
        List<Employee__c> employee = [SELECT Id,Name,Employee_Active__c,Work_Email__c 
                                      FROM Employee__c 
                                      WHERE Employee_Active__c=true 
                                      AND Id = 'aAsD0000000GmgM' LIMIT 1];         
        
        //Get a vendor
        List<Account> vendor = [SELECT Id FROM Account WHERE RecordType.Name = 'Sanergy Vendor' LIMIT 1];
        
        //Create Special Procurement               
        Special_Procurement__c spr = new Special_Procurement__c();
        spr.Requestor__c = 'aAsD0000000GmgM';
        spr.Type__c = 'Cash Advance';
        spr.Required_Date__c = date.today();
        spr.Comments__c = 'Two tyres for Toyota Corolla';         
        spr.Requesting_Department__c = department.get(0).Id;
        spr.Vendor__c = vendor.get(0).Id;       
        spr.Approval_Status__c = 'Approved By Team Lead';
        spr.Dim_2__c = dim2.get(0).Id;
        spr.Dim_3__c = dim3.get(0).Id;
        spr.GLA__c = gla.get(0).Id;
        spr.Grant__c = dim4.get(0).Id;
        spr.Requesting_Company__c = company.Id;
        INSERT spr;
        
        System.debug('SPR: ' + spr.Requesting_Company__c);
        
        //Create Special Procurement Line Items
        Special_Procurement_Line_Item__c spLineItems = new Special_Procurement_Line_Item__c();
        spLineItems.Special_Procurement__c = spr.Id;
        spLineItems.Item__c = 'Two 18 Inch Car Tyress';
        spLineItems.Specifications__c = 'Two 18 Inch car tyres for Toyota Corollas';                  
        spLineItems.Quantity_Requested__c = 2;
        spLineItems.Unit_Price__c = 600;
        spLineItems.Status__c = 'Approved';
        INSERT spLineItems;
        
        //Update SPR
        spr.Stage__c='SPR Approved';
        UPDATE spr;
        
        //test to UPDATE a VI
        Vendor_Invoice__c vi = new Vendor_Invoice__c();
        vi = [SELECT Id, Name FROM Vendor_Invoice__c WHERE Count_VIPOLI__c > 1 ORDER BY CreatedDate DESC LIMIT 1];
        if(vi != NULL){
            vi.Status__c = 'Closed';
            UPDATE vi;
            vi.Status__c = 'AP Matched';
            UPDATE vi;
        }
        
        //test to delete a VI
        Vendor_Invoice__c viDEL = new Vendor_Invoice__c();
        viDEL.Vendor__c = vendor.get(0).Id;
        viDEL.Status__c = 'Open';
        INSERT viDEL;
        DELETE viDEL;
        
        Vendor_Invoice_Purchase_Order_Line_Item__c vipoli = new Vendor_Invoice_Purchase_Order_Line_Item__c();
        vipoli = [SELECT Id FROM Vendor_Invoice_Purchase_Order_Line_Item__c
		WHERE Vendor_Invoice__r.VI_Status__c = 'Open' LIMIT 1];
        if(vipoli != NULL){
            DELETE vipoli;
        }
    } 
}