@isTest(seeAllData = true)
public class REST_InventoryServiceTest {
   
    static testMethod void testIssueFromInventory() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/inventory_adjust';
                
        System.RestContext.response = new RestResponse();
        
  
           
            //get a user
            rstk__syusr__c rstkUser = [SELECT Name, rstk__syusr_lastdiv__c, rstk__syusr_employee__c
                                         FROM rstk__syusr__c
                                         WHERE rstk__syusr_lastdiv__c <> null
                                         AND rstk__syusr_employee__r.IsActive=true
                                         AND Name='Stephen Kanyi'];
             
            User user=[SELECT ID,Name FROM User where ID=:rstkUser.rstk__syusr_employee__c];
            
            System.runAs(user) {
            
            System.debug(user.Name);
                
            //Location
            List<rstk__iclocitem__c> location = [SELECT id,rstk__iclocitem_locqty__c, rstk__iclocitem_icitem__c
                                                 FROM rstk__iclocitem__c 
                                                 WHERE rstk__iclocitem_locqty__c > 0
                                                 AND rstk__iclocitem_icitem__r.rstk__icitem_div__c= :rstkUser.rstk__syusr_lastdiv__c
                                                 LIMIT 1];
            
            
            
            //department
            List <Sanergy_Department__c> dept=[SELECT ID 
                                               FROM Sanergy_Department__c
                                               LIMIT 1];
                                               
                                               
            //dimensions
            List <c2g__codaDimension1__c> dim1=[SELECT ID
                                                FROM c2g__codaDimension1__c
                                                LIMIT 1];
                                                
             List <c2g__codaDimension2__c> dim2=[SELECT ID
                                                FROM c2g__codaDimension2__c
                                                LIMIT 1];
             List <c2g__codaDimension3__c> dim3=[SELECT ID
                                                FROM c2g__codaDimension3__c
                                                LIMIT 1];
                                                
             List <c2g__codaDimension4__c> dim4=[SELECT ID
                                                FROM c2g__codaDimension4__c
                                                LIMIT 1];
                                                
            //gla
            List <c2g__codaGeneralLedgerAccount__c> gla=[SELECT ID
                                                         FROM c2g__codaGeneralLedgerAccount__c
                                                         LIMIT 1];
            
          
          
            REST_InventoryService.IssueRequest  req=new  REST_InventoryService.IssueRequest();
            req.requestingDepartment=dept.get(0).ID;
            req.dimension1=dim1.get(0).ID;
            req.requestingUser=user.ID;
            req.dimension2=dim2.get(0).ID;
            req.dimension3=dim3.get(0).ID;
            req.dimension4=dim4.get(0).ID;
            req.glaAccount=gla.get(0).ID;
            req.quantity=location.get(0).rstk__iclocitem_locqty__c;
            req.itemId=location.get(0).rstk__iclocitem_icitem__c;
            req.locationId=location.get(0).ID;
            
            String jsonString=JSON.serialize(req);
           // String jsonString='[{"requestingDepartment":"aDVL00000004C93OAE","dimension1":"a1ID0000002cWZcMAM","dimension2":"a1JD0000005DmbDMAS","dimension3":"a1KD0000000lnKEMAY","dimension4":"a1LD0000001GowTMAS","glaAccount":"a1QD000000BVOFsMAP","quantity":12.0,"itemId":"a3BD0000000PRnxMAG","locationId":"a3NL00000006xLVMAY"}]';
        
            REST_InventoryService.Message recs = REST_InventoryService.issueFromInventory(jsonString);
        
            System.assert(recs.issued ==true);
            
           }
            
       
    } 
}