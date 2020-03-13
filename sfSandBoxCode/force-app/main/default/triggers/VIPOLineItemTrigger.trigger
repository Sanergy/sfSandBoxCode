trigger VIPOLineItemTrigger on Vendor_Invoice_Purchase_Order_Line_Item__c (before delete) {
  //Get the list of available VIPOLI and assign it to null
    List<Vendor_Invoice_Purchase_Order_Line_Item__c> vipolitems = null;
    System.debug('vipolitems One' + vipolitems);
    
    //check if the trigger is doing delete and and use the old values 
    if(Trigger.isDelete){
        vipolitems = Trigger.old;
   }
    //Check the size of the list 
    if(vipolitems != null && vipolitems.size() > 0 ){
        System.debug('vipolitems' + vipolitems);
        Vendor_Invoice_Purchase_Order_Line_Item__c vipoli =  vipolitems.get(0);
        System.debug('vipoli' + vipoli);
        String x = vipoli.Vendor_Invoice__c;
        system.debug('XXXXXX' + x);
        //ect from the vendor invoice to get the status 
       Vendor_Invoice__c VI = [SELECT ID,Name,VI_Status__c
                                FROM Vendor_Invoice__c 
                                WHERE ID =: x
                               ];
        //If the status is Firmed or the status is closed then throw an error 
        if(VI.VI_Status__c == 'Firmed' || VI.VI_Status__c == 'Closed'){
                System.debug('status' + VI.VI_Status__c);
                Vendor_Invoice_Purchase_Order_Line_Item__c VendorInvoicePOLI =  vipolitems.get(0);
                System.debug('VendorInvoicePOLI' + VendorInvoicePOLI);
                if(VendorInvoicePOLI != null){
                    VendorInvoicePOLI.adderror('You are not permitted to perform this action once the VI has been Firmed or Closed');
                    
                }
            } 
                 
    }
    
 
}