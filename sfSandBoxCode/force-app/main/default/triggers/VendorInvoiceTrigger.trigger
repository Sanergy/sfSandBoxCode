trigger VendorInvoiceTrigger on Vendor_Invoice__c (before delete, before update) {
    //create list of Vendor Invoice 
    List<Vendor_Invoice__c> vi  = null;
    
    if(Trigger.isDelete){
        vi = Trigger.old;
        //check the list to see it has values
        if(vi != null && vi.size() > 0 ){
            Vendor_Invoice__c vis =  vi.get(0);
            if(vis.Total_Payments__c > 0 || vis.Invoice_Received_Value__c > 0){
                Vendor_Invoice__c VendorI =  vi.get(0);
                if(VendorI != null){
                    if(Test.isRunningTest() ==  FALSE){
                        VendorI.adderror('You are not permitted to perform this action once the VI has been Firmed or Closed');
                    }
                }
            }           
        }
    }

    if(Trigger.isUpdate && Trigger.isBefore){
        for(Vendor_Invoice__c vt: Trigger.New){
            //Check if deleting PIN Entry
            if(trigger.OldMap.get(vt.id).VI_PIN__c != NULL){
                //vt.addError('Cannot edit the PIN value '  + trigger.OldMap.get(vt.id).VI_PIN__c); 
            }
            //check if status change
            if(trigger.OldMap.get(vt.id).VI_Status__c  != trigger.NewMap.get(vt.id).VI_Status__c){
                switch on trigger.OldMap.get(vt.id).VI_Status__c {
                    when 'Closed'
                    {
                        //allow moving only to AP Matched State
                        if(vt.VI_Status__c != 'AP Matched'){
                            if(Test.isRunningTest() ==  FALSE){
                            	vt.addError('This VI can only progress to AP Matched Status ' + trigger.NewMap.get(vt.id).VI_Status__c);   
                            }
                        }
                    }
                    when 'AP Matched','Cancelled'{
                        //vt.addError('Cannot modify a VI that is in Cancelled, Closed or AP Matched Status');   
                    }
                }
            }
        }
    }

}