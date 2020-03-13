trigger VendorInvoiceItemsTrigger on Vendor_Invoice_Items__c (before insert , before delete ) {
    //Before insert check the Company matches the one one the VI
    if(trigger.isBefore && trigger.isUpdate){
        for(Vendor_Invoice_Items__c vii: Trigger.New){
            //if the first VII, set the VI company to the Company on the VII
            AggregateResult [] aggVI = 
                [SELECT Company__c, Company__r.Name CompanyName, COUNT(id)VICOs
                 FROM Vendor_Invoice_Items__c
                 WHERE Vendor_Invoice__c =: vii.Vendor_Invoice__c
                 AND CreatedDate >= 2020-01-01T00:00:00Z
                 GROUP BY Company__c, Company__r.Name
                ];
            //if one record found and company matches vii company do nothing that's ok
            if(aggVI.size() > 0 && aggVI.size() == 1 && aggVI[0].get('Company__c') == vii.Company__c){
                //do nothing
            }
            //record found and no Company found, set the company on the VI assuming this is the first VII to be added
            else if(aggVI.size() > 0 && (Integer)aggVI[0].get('VICOs') == 0 ){
                Vendor_Invoice__c vi = [SELECT Id FROM Vendor_Invoice__c WHERE id =: vii.Vendor_Invoice__c];
                vi.VI_Company__c = vii.Company__c;
                UPDATE vi;
            }
            else {
                vii.addError('Company on the VI must match that of the VI Items');
            }
        }    
    }
    if(Trigger.isDelete){
        //get the list of the existing items from the vendor invoice items 
        List<Vendor_Invoice_Items__c> viItems  = null;
        viItems = Trigger.old;
        //check the list to see it has values
        if(viItems != null && viItems.size() > 0 ){
            Vendor_Invoice_Items__c vii =  viItems.get(0);
            String x = vii.Vendor_Invoice__c;
            //get the status of the vendor invoice 
            Vendor_Invoice__c VI = 
                [
                    SELECT ID,Name,VI_Status__c
                    FROM Vendor_Invoice__c 
                    WHERE ID =: x
                ];
            if(VI.VI_Status__c == 'Firmed' || VI.VI_Status__c == 'Closed'){
                Vendor_Invoice_Items__c VendorInvoiceItems =  viItems.get(0);
                if(VendorInvoiceItems != null){
                    VendorInvoiceItems.adderror('You are not permitted to perform this action once the VI has been Firmed or Closed');
                }
            }        
        }
    }
}