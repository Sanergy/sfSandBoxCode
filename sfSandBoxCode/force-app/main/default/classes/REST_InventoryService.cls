@RestResource(urlMapping='/inventory_adjust')
global with sharing class REST_InventoryService {
   
    global class IssueRequest {
        public String requestingDepartment;
        public String site;
        public String requestingUser;
        public String dimension1;
        public String dimension2;
        public String dimension3;
        public String dimension4;
        public String glaAccount;
        public String project;
        public Double quantity;
        public String itemId;
        public String locationId;
    }
    
    global class Message {
        public String item;
        public String message;
        public Double quantityIssued;
        public Boolean issued;
        public Boolean error;
    }

  //Issue inventory item 
  @HttpPost
   
   global static Message issueFromInventory(String jsonRequest) {

      Message message = new Message();
      IssueRequest request = (IssueRequest) System.JSON.deserialize(jsonRequest, IssueRequest.class);
       
      if(request != null){
          
          rstk__syusr__c rstkUser = [SELECT id, name, rstk__syusr_lastcmpno__c, rstk__syusr_lastdiv__c
                                         FROM rstk__syusr__c
                                         WHERE rstk__syusr_employee__c = :UserInfo.getUserId()];
              
          List<rstk__icitem__c> item = [SELECT Id, Name FROM rstk__icitem__c 
                                        WHERE Id = :request.itemId 
                                       AND rstk__icitem_div__c = :rstkUser.rstk__syusr_lastdiv__c];
          
          if(item.size() == 0){
              
              message.message = 'Confirm that the item being issued is in the same division as the system user';
              message.quantityIssued = 0.0;
              message.issued = false;
              message.error = true;
              
          } else {
              message.item = request.itemId;
              Map<String, Object> adj = new Map<String, Object>();
              
              adj.put('dept', request.requestingDepartment);
              adj.put('user', request.requestingUser);
              adj.put('dim1', request.dimension1);
              adj.put('dim2', request.dimension2);
              adj.put('dim3', request.dimension3);
              adj.put('dim4', request.dimension4);
              adj.put('gla', request.glaAccount);
              
              String jsonAdj = JSON.serialize(adj);
              
              if(request.locationId != null && !request.locationId.equals('')){
                  
                  rstk__iclocitem__c location = [SELECT Id, Name, rstk__iclocitem_locid__c, rstk__iclocitem_locqty__c,
                                                 rstk__iclocitem_locnum__c, rstk__iclocitem_icitem__c,
                                                 rstk__iclocitem_div__c, rstk__iclocitem_proj__c, rstk__iclocitem_site__c
                                                 FROM rstk__iclocitem__c WHERE Id = :request.locationId];
                  
                  if(location != null && location.rstk__iclocitem_locqty__c >= request.quantity){
                      
                      if(request.quantity != 0){
                          
                          rstk__sydata__c sydata = new rstk__sydata__c(
                              rstk__sydata_txntype__c = 'Loc Adjust',
                              rstk__sydata_sydiv__c = location.rstk__iclocitem_div__c,
                              rstk__sydata_sysite__c = location.rstk__iclocitem_site__c,
                              rstk__sydata_pjproj__c = location.rstk__iclocitem_proj__c,
                              rstk__sydata_locnum__c = location.rstk__iclocitem_locnum__c,
                              rstk__sydata_icitem__c = location.rstk__iclocitem_icitem__c,
                              rstk__sydata_txnqty__c = (request.quantity),
                              rstk__sydata_sylocid__c = location.rstk__iclocitem_locid__c,
                              rstk__sydata_txncomments__c = jsonAdj);
                          
                          
                          insert sydata;
                          
                          message.message = 'Success => ' + sydata.Id;
                          message.quantityIssued = request.quantity;
                          message.issued = true;
                          message.error = false;
                          
                      } else {
                          message.message = 'Quantity not set';
                          message.quantityIssued = 0.0;
                          message.issued = false;
                          message.error = false;
                      }
                      
                  } else {
                      message.message = 'Cannot Issue quantity greater than location quantity';
                      message.quantityIssued = 0.0;
                      message.issued = false;
                      message.error = true;
                  }      
              }
          }       
      }
      return message;
  
  } 
}