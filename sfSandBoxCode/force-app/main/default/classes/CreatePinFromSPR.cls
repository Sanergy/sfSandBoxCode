public class CreatePinFromSPR {
    
    private ApexPages.StandardController standardController;
    Special_Procurement__c spr;
    //Renconciling_Object__c sprRecon;
    public Boolean disableCreatePIN {get; set;}
    
    public CreatePinFromSPR(ApexPages.StandardController standardController){
        this.standardController = standardController;
        spr = (Special_Procurement__c)standardController.getRecord();
        spr = 
            [
                SELECT Name,GLA__c,Dim_2__c,Dim_3__c,Payable_Invoice__c,Payable_Invoice__r.Name,Requesting_Company__c,Requesting_Company__r.Name,
                Vendor__c, EPR_Created__c, Vendor_Currency__c,Payment_Method__c,Scheduled_Payment_Date__c,
                Approve_Reconciliation__c,Total_Approved_EPR_Value__c
                FROM Special_Procurement__c 
                WHERE ID =: spr.Id    
            ];
        
        //confirm we have the info to create the PIN
        if (spr.Payable_Invoice__c == null && spr.EPR_Created__c == TRUE && spr.Approve_Reconciliation__c == TRUE && spr.Payment_Method__c != ''){
            disableCreatePIN = FALSE;
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'To create the PIN; PIN = NULL, EPR Created = TRUE, Payment Method = Selected, Approve Reconciliation = TRUE'));
            disableCreatePIN = TRUE;
        }
    }
    
    public PageReference CreatePin(){
        if (spr.Payable_Invoice__c == null && spr.EPR_Created__c == TRUE && spr.Approve_Reconciliation__c == true && spr.Payment_Method__c != ''){
            system.debug('SPR CCCOMPANY' + spr.Requesting_Company__r.Name);
            
            String company= spr.Requesting_Company__r.Name;
            String bankName;
            
            //If company is Sanergy
            if(company=='Sanergy Limited'){
                system.debug('CooOMPANY' + company + ' '+ bankName);
                
                //if payment is Check or EFT
                if(spr.Payment_Method__c=='Check' || spr.Payment_Method__c=='EFT'){
                    system.debug('Bank Name' + company + ' '+ bankName);
                    if(spr.Vendor_Currency__c=='KES'){
                        bankName='SL - PBH - KES';
                    }
                    else if(spr.Vendor_Currency__c=='USD'){
                        bankName='SL - PBR - USD';
                    }
                    else if(spr.Vendor_Currency__c=='EUR'){
                        bankName='SL - PBR - EUR';
                    }
                    else if(spr.Vendor_Currency__c=='GBP'){
                        bankName='SL - PBR - GBP';
                    }
                }
                //if payment is Electronic.
                else if(spr.Payment_Method__c=='Electronic'){
                    bankName='SL - SCB - KES';
                    system.debug('Bank Name' + company + ' '+ bankName);
                    
                }   
            }
            
            //If company is Fresh Life
            else if(company=='Fresh Life Initiative Limited'){
                //if payment is Check or EFT
                if(spr.Payment_Method__c=='Check' || spr.Payment_Method__c=='EFT'){
                    if(spr.Vendor_Currency__c=='KES'){
                        bankName='FLI - PBH - KES';
                    }
                    else if(spr.Vendor_Currency__c=='USD'){
                        bankName='FLI - PBR - USD';
                    }
                    else if(spr.Vendor_Currency__c=='EUR'){
                        bankName='FLI - PBR - EUR';
                    }
                    else if(spr.Vendor_Currency__c=='GBP'){
                        bankName='FLI - PBR - GBP';
                    }
                }
                //if payment is Electronic.
                else if(spr.Payment_Method__c=='Electronic'){
                    bankName='FLI - SCB - KES';
                }  
            }  
            
            //If company is Sanergy FP
            else if(company=='Sanergy Inc (FP)'){
                bankName='FP Checking';
            }
            
            //If company is Sanergy NP
            else if(company=='Sanergy Inc (NP)'){
                bankName='NP Checking';
            }   
            
            List<c2g__codaBankAccount__c > bankAcc=[SELECT Id,c2g__BankAccountCurrency__c 
                                                    FROM c2g__codaBankAccount__c
                                                    WHERE Name=:bankName];            
            
            
            if(bankAcc.size() > 0){
                system.debug('BANK ACC' +' '+ bankAcc.get(0).c2g__BankAccountCurrency__c);
                
                c2g__codaPurchaseInvoice__c PIN=new c2g__codaPurchaseInvoice__c();
                PIN.c2g__Account__c= spr.Vendor__c;
                PIN.c2g__InvoiceDate__c=Date.Today();
                PIN.c2g__DueDate__c= spr.Scheduled_Payment_Date__c;
                PIN.c2g__AccountInvoiceNumber__c=spr.Name;
                // PIN.c2g__InvoiceCurrency__c=bankAcc.get(0).c2g__BankAccountCurrency__c;
                
                INSERT PIN; 
                
                spr.Payable_Invoice__c=PIN.ID;
                UPDATE spr;
                
                system.debug('PIN' + spr.Payable_Invoice__c);
                system.debug('SPR' + spr);
                
                List<Renconciling_Object__c> sprRecon = 
                    [
                        SELECT id, Date__c, Expense_Description__c, GLA__c,Total_Reconciled__c,
                        DIM1__c,Item_Amount__c,Supplier__c,Special_Payment_Request__c,Special_Payment_Request__r.Reconciled_Balance__c,
                        Transaction_Charge__c,VAT__c,KRA_Pin__c,Special_Payment_Request__r.Total_Amount_Requested__c,Special_Payment_Request__r.Dim_2__c,
                        Special_Payment_Request__r.Dim_3__c,Special_Payment_Request__r.Total_Approved_EPR_Value__c
                        from Renconciling_Object__c 
                        where Special_Payment_Request__c  =: spr.Id
                    ];
                
                List<c2g__codaPurchaseInvoiceExpenseLineItem__c> PIN_Line=new List<c2g__codaPurchaseInvoiceExpenseLineItem__c>();
                for(Renconciling_Object__c sprR: sprRecon){
                    
                    c2g__codaPurchaseInvoiceExpenseLineItem__c pinLine=new c2g__codaPurchaseInvoiceExpenseLineItem__c(
                        c2g__PurchaseInvoice__c=PIN.ID,
                        ffap__SetGLAToDefault__c=false,
                        c2g__LineDescription__c=sprR.Expense_Description__c,
                        c2g__NetValue__c=sprR.Total_Reconciled__c,
                        c2g__TaxValue1__c = sprR.VAT__c,
                        ffap__SetTaxCodeToDefault__c=false,
                        ffap__CalculateTaxValueFromRate__c=true,
                        ffap__DeriveTaxRateFromCode__c=true,
                        c2g__GeneralLedgerAccount__c=sprR.GLA__c,
                        c2g__Dimension1__c=sprR.DIM1__c
                    );
                    
                    PIN_Line.add(pinLine);
                    
                }
                INSERT PIN_LINE;
                system.debug('SPRLINE' + PIN_LINE);
                
                
                spr.Payable_Invoice__c=PIN.ID;
                UPDATE PIN;
            }     
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'PIN Successfully Created'));
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'To create the PIN; PIN = NULL, EPR Created = TRUE, Payment Method = Selected, Approve Reconciliation = TRUE'));
        }
        
        return NULL;
    }
    
    
}