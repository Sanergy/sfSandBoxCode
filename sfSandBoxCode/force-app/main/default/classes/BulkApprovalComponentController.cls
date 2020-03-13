public with sharing class BulkApprovalComponentController {
    public String getBulkApprovalControllerPage(){
        return (new PageReference('/apex/GeneratePODocument?id=a0a7E000008uwE7').getContent().toString());
    }
}