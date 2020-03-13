public with sharing class ClonePINController {

    private ApexPages.StandardController standardController;

    public ClonePINController(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
     public PageReference clonePin() {
     
         // Record being cloned
        c2g__codaPurchaseInvoice__c originalPin = (c2g__codaPurchaseInvoice__c) standardController.getRecord();
         
        String soql = Utils.getCreatableFieldsSOQL('c2g__codaPurchaseInvoice__c', 'Id=\'' + originalPin.Id + '\'');
        c2g__codaPurchaseInvoice__c completePin = (c2g__codaPurchaseInvoice__c)Database.query(soql);
         
        c2g__codaPurchaseInvoice__c pin = completePin.clone(false, false, false, false);
        
        pin.c2g__Transaction__c = null;
        pin.c2g__InvoiceStatus__c = 'In Progress';
        pin.ffbext__Approved__c = false;
        pin.c2g__AccountInvoiceNumber__c = 'CLONED-' + DateTime.now().getTime();
        pin.c2g__Period__c = null;
        pin.ffap__DerivePeriod__c = true;
        pin.c2g__InvoiceDate__c = System.today();
        pin.c2g__DueDate__c = System.today();
         
        insert pin;
         
         if(pin.Id != null){
             //Select Items
             String itemQry = Utils.getCreatableFieldsSOQL('c2g__codaPurchaseInvoiceExpenseLineItem__c', 'c2g__PurchaseInvoice__c=\'' + originalPin.Id + '\'');
             
             List<c2g__codaPurchaseInvoiceExpenseLineItem__c> items = (List<c2g__codaPurchaseInvoiceExpenseLineItem__c>)Database.query(itemQry);
             List<c2g__codaPurchaseInvoiceExpenseLineItem__c> itemsToInsert=new List<c2g__codaPurchaseInvoiceExpenseLineItem__c>();
             
             if(items != null && items.size() > 0){
                 for(c2g__codaPurchaseInvoiceExpenseLineItem__c item : items){
                     
                     c2g__codaPurchaseInvoiceExpenseLineItem__c cItem = item.clone(false, false, false, false);
                     cItem.c2g__PurchaseInvoice__c = pin.Id;
                     
                     itemsToInsert.add(cItem);
                 }
                 
                 insert itemsToInsert;
             }
             
             // Redirect to the new cloned record
             return new PageReference('/' + pin.Id);
         }
         
         return null;
    }
}