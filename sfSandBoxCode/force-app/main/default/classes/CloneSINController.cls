public class CloneSINController {
    private ApexPages.StandardController standardController;
    
    public CloneSINController(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
    public PageReference cloneSin() {
        
        // Record being cloned
        c2g__codaInvoice__c originalSin = (c2g__codaInvoice__c) standardController.getRecord();
        
        String soql = Utils.getCreatableFieldsSOQL('c2g__codaInvoice__c', 'Id=\'' + originalSin.Id + '\'');
        c2g__codaInvoice__c completeSin = (c2g__codaInvoice__c)Database.query(soql);
        
        c2g__codaInvoice__c sin = completeSin.clone(false, false, false, false);
        
        
        sin.c2g__Transaction__c = null;
        sin.c2g__InvoiceStatus__c = 'In Progress';
        sin.ffbext__Approved__c = false;
        sin.c2g__Period__c = null;
        sin.c2g__DerivePeriod__c = true;
        sin.c2g__InvoiceDate__c = System.today();
        sin.c2g__DueDate__c = System.today();
        sin.c2g__FirstDueDate__c=System.today();
        sin.c2g__PrintStatus__c = 'Not Printed';
        
        insert sin;
        
        if(sin.Id != null){
            //Select Items
            String itemQry = Utils.getCreatableFieldsSOQL('c2g__codaInvoiceLineItem__c', 'c2g__Invoice__c=\'' + originalsin.Id + '\'');
            
            List<c2g__codaInvoiceLineItem__c> items = (List<c2g__codaInvoiceLineItem__c>)Database.query(itemQry);
            List<c2g__codaInvoiceLineItem__c> itemsToInsert=new List<c2g__codaInvoiceLineItem__c>();
            
            if(items != null && items.size() > 0){
                for(c2g__codaInvoiceLineItem__c item : items){
                    
                    c2g__codaInvoiceLineItem__c cItem = item.clone(false, false, false, false);
                    cItem.c2g__Invoice__c = sin.Id;
                    
                    itemsToInsert.add(cItem);
                }
                
                BatchInsertUtil batch=new BatchInsertUtil (itemsToInsert);
                Database.executeBatch(batch, 100);
            }
            
            // Redirect to the new cloned record
            return new PageReference('/' + sin.Id);
        }
        
        return null;
    }
}