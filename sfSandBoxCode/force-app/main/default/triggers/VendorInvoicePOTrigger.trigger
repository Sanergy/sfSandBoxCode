trigger VendorInvoicePOTrigger on Vendor_Invoice_PO__c (before delete) {
    //get the list of the existing items from the vendor invoice PO items 
    List<Vendor_Invoice_PO__c> viPOItems  = null;
    
    if(Trigger.isDelete){
        viPOItems = Trigger.old;
    }
    //check the list to see it has values
    if(viPOItems != null && viPOItems.size() > 0 ){
        Vendor_Invoice_PO__c viPOI =  viPOItems.get(0);
        String x = viPOI.Vendor_Invoice__c;
        //get the status of the vendor invoice 
        Vendor_Invoice__c VI = [SELECT ID,Name,VI_Status__c
                                FROM Vendor_Invoice__c 
                                WHERE ID =: x
                               ];
        if(VI.VI_Status__c == 'Firmed' || VI.VI_Status__c == 'Closed'){
            Vendor_Invoice_PO__c VendorInvoicePOItems =  vipoItems.get(0);
            if(VendorInvoicePOItems != null){
                VendorInvoicePOItems.adderror('You are not permitted to perform this action once the VI has been Firmed or Closed');  
            }
        }      
    }
    
}