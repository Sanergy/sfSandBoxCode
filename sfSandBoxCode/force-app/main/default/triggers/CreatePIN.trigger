trigger CreatePIN on Electronic_Payment_Request__c (before update) {
    for(Electronic_Payment_Request__c EPR:Trigger.new){
    
   
        if(EPR.Create_PIN__c!=Trigger.oldMap.get(EPR.ID).Create_PIN__c && EPR.Create_PIN__c==true){
        
          if(EPR.Payable_Invoice__c==null && EPR.Pin_Created__c==true){
         
              EPR.addError('Cannot create a new PIN since another PIN had already been created for this EPR.');
          }
          
        
          if(EPR.Payable_Invoice__c==null && EPR.Pin_Created__c==false){
          
            
            Integer countPINexisting=[SELECT count()
                                      FROM c2g__codaPurchaseInvoice__c
                                      WHERE c2g__Account__c=:EPR.Vendor_Company__c
                                      AND c2g__AccountInvoiceNumber__c=:EPR.Invoice_Number__c ];
            
            if(countPINexisting>0){
                EPR.addError('PIN cannot be created because this Vendor Invoice Number already exists for this account');    
            }
            
            c2g__codaPurchaseInvoice__c PIN;
            
            //get the correct currency
            if(EPR.RespectiveCompany__c!=null && EPR.Currency__c !=null){
                List<c2g__codaAccountingCurrency__c> currencyList=[SELECT ID FROM c2g__codaAccountingCurrency__c
                                                               WHERE Name=:EPR.Currency__c 
                                                               AND c2g__OwnerCompany__c=:EPR.RespectiveCompany__c];
                                                               
                if(currencyList.size()>0){
                    //create new PIN
                  PIN=new c2g__codaPurchaseInvoice__c(
                                    c2g__Account__c=EPR.Vendor_Company__c,
                                    c2g__InvoiceDate__c=Date.Today(),
                                    c2g__DueDate__c=EPR.Scheduled_Payment_Date__c,
                                    c2g__AccountInvoiceNumber__c=EPR.Invoice_Number__c,
                                    EPR__c=EPR.ID,
                                    c2g__InvoiceCurrency__c=currencyList.get(0).ID,
                                    c2g__InvoiceDescription__c='Size is '+currencyList.size()
                                    );
                  }
                  
                  else{
                        //create new PIN
                       PIN=new c2g__codaPurchaseInvoice__c(
                                        c2g__Account__c=EPR.Vendor_Company__c,
                                        c2g__InvoiceDate__c=Date.Today(),
                                        c2g__DueDate__c=EPR.Scheduled_Payment_Date__c,
                                        c2g__AccountInvoiceNumber__c=EPR.Invoice_Number__c,
                                        EPR__c=EPR.ID,
                                        c2g__InvoiceDescription__c='Size is '+currencyList.size()
                                        );
                   } 
            }
            
            else{
               //create new PIN
               PIN=new c2g__codaPurchaseInvoice__c(
                                                    c2g__Account__c=EPR.Vendor_Company__c,
                                                    c2g__InvoiceDate__c=Date.Today(),
                                                    c2g__DueDate__c=EPR.Scheduled_Payment_Date__c,
                                                    c2g__AccountInvoiceNumber__c=EPR.Invoice_Number__c,
                                                    EPR__c=EPR.ID,
                                                    c2g__InvoiceDescription__c='Null fields'
                                                    );
             }                                   
             insert PIN;
            
             EPR.Payable_Invoice__c=PIN.ID; 
             
             //add line items
             List<EPR_Payable_Item__c> EPR_Line=[SELECT Item__c,Quantity__c,Gross_price__c, GLA__c,Grant_Funding_Availale_dim4__c,Location_Dim2__c,Department_dim1__c
                                                 FROM EPR_Payable_Item__c
                                                 WHERE EPR__c=:EPR.ID]; 
                                                 
              if(EPR_Line.size()>0){
                  //List to hold new PIN Line Items
                  List<c2g__codaPurchaseInvoiceExpenseLineItem__c> PIN_Line=new List<c2g__codaPurchaseInvoiceExpenseLineItem__c>();
                  
                  
                  List<String> idStr=new List<String>();
                  
                  //loop through EPR line items and create array of strings
                  for(EPR_Payable_Item__c eprLine:EPR_Line){
                     idStr.add(eprLine.GLA__c);
                     idStr.add(eprLine.Grant_Funding_Availale_dim4__c);
                     idStr.add(eprLine.Location_Dim2__c);
                     idStr.add(eprLine.Department_dim1__c);
                  }
                  
                 
                  List<FFA_Config_Object__c> ECO = [SELECT ID,lookup_ID__c
                                                   FROM FFA_Config_Object__c
                                                   WHERE ID IN :idStr];
                                                   
                  //Create a map of the records
                  Map<String, String> ECO_Map=new Map<String, String>();
                  
                  for(FFA_Config_Object__c ecoLine:ECO){
                      ECO_Map.put(ecoLine.ID, ecoLine.lookup_ID__c);
                  }
                  
                  
                  //loop through EPR Line items and create corresponding line items
                  for(EPR_Payable_Item__c eprLine:EPR_Line){
                    String GLA=ECO_Map.get(eprLine.GLA__c);
                    String Location=ECO_Map.get(eprLine.Location_Dim2__c);
                    String Department=ECO_Map.get(eprLine.Department_dim1__c);
                    String GrantFunding=ECO_Map.get(eprLine.Grant_Funding_Availale_dim4__c);
                    
                    c2g__codaPurchaseInvoiceExpenseLineItem__c pinLine=new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                                                                          c2g__PurchaseInvoice__c=PIN.ID,
                                                                          ffap__SetGLAToDefault__c=false,
                                                                          c2g__LineDescription__c=eprLine.Item__c + ' (' + eprLine.Quantity__c + ')',
                                                                          c2g__NetValue__c=eprLine.Gross_price__c,
                                                                          ffap__SetTaxCodeToDefault__c=false,
                                                                          ffap__CalculateTaxValueFromRate__c=true,
                                                                          ffap__DeriveTaxRateFromCode__c=true,
                                                                          c2g__GeneralLedgerAccount__c=GLA,
                                                                          c2g__Dimension1__c=Department,
                                                                          c2g__Dimension2__c=Location,
                                                                          c2g__Dimension4__c=GrantFunding
                                                                         );
                   PIN_Line.add(pinLine);
                  }
                  
                  insert PIN_Line;
                  
              }
         }
        }
    }
}