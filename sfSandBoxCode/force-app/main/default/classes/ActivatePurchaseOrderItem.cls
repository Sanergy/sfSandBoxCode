public class ActivatePurchaseOrderItem{

    ApexPages.Standardcontroller controller;
    public Purchase_Order_Item__c poItem {get; set;}
    
    public ActivatePurchaseOrderItem(ApexPages.Standardcontroller controller){
        this.controller = controller;
        this.poItem = (Purchase_Order_Item__c)controller.getRecord();
    }
      /*
    public PageReference activate(){
      List<Purchase_Order_Item__c> poItemList = [SELECT Inventory_Item__r.Item_Group__r.Requires_Contract__c FROM Purchase_Order_Item__c
                                               WHERE id = :this.poItem.id];
                                               
        //if(poItemList.size() > 0 && poItemList.get(0).Inventory_Item__r.Item_Group__r.Requires_Contract__c == true){
           if(poItemList.size() > 0){
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(this.poItem.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(UserInfo.getUserId()); 
            
            req1.setProcessDefinitionNameOrId('Purchase_Order_Item_Approval_V3');

            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            
            if(result.isSuccess()){
                 this.poItem.Status__c = 'Pending Contract';
                 update this.poItem;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not submit record for approval'));
                return null;
            }
        }
        
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not submit record for approval'));
                return null;
            }
        
        /*else{
            this.poItem.Status__c = 'Active';
            update this.poItem;
        }*/
        
        
        
     /*   return new PageReference('/'+this.poItem.id);
    }*/
}