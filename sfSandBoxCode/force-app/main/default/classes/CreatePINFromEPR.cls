public class CreatePINFromEPR {

    
    private ApexPages.StandardController standardController;
    private String id;
    Electronic_Payment_Request__c epr;
   
    public CreatePINFromEPR (ApexPages.StandardController standardController){
        this.standardController = standardController;    
    }
    
    
    public PageReference CreatePINFromEPR(){
        
        Electronic_Payment_Request__c epr=(Electronic_Payment_Request__c)standardController.getRecord();
        this.epr=[SELECT Company__c,Payable_Invoice__c,Payment_Method__c,Notes__c,Vendor_Company__c,Confirmation_Number__c,Vendor_Currency__c,Payment_Type__c,Scheduled_Payment_Date__c,Invoice_Number__c
                  FROM Electronic_Payment_Request__c
                  WHERE ID=:epr.id];
                  
        if(this.epr.Payable_Invoice__c==null){
            
       String company=this.epr.Company__c;
        String bankName;
        
        //If company is Sanergy
        if(company=='Sanergy Ltd'){
            //if payment is Check or EFT
            if(this.epr.Payment_Method__c=='Check' || this.epr.Payment_Method__c=='EFT'){
                if(this.epr.Vendor_Currency__c=='KES'){
                    bankName='SL - PBH - KES';
                }
                else if(this.epr.Vendor_Currency__c=='USD'){
                    bankName='SL - PBR - USD';
                }
                else if(this.epr.Vendor_Currency__c=='EUR'){
                    bankName='SL - PBR - EUR';
                }
                else if(this.epr.Vendor_Currency__c=='GBP'){
                    bankName='SL - PBR - GBP';
                }
            }
            //if payment is Electronic.
            else if(this.epr.Payment_Method__c=='Electronic'){
                bankName='SL - SCB - KES';
            }   
        }
        
        //If company is Fresh Life
        else if(company=='Fresh Life Initiative Ltd'){
            //if payment is Check or EFT
            if(this.epr.Payment_Method__c=='Check' || this.epr.Payment_Method__c=='EFT'){
                if(this.epr.Vendor_Currency__c=='KES'){
                    bankName='FLI - PBH - KES';
                }
                else if(this.epr.Vendor_Currency__c=='USD'){
                    bankName='FLI - PBR - USD';
                }
                else if(this.epr.Vendor_Currency__c=='EUR'){
                    bankName='FLI - PBR - EUR';
                }
                else if(this.epr.Vendor_Currency__c=='GBP'){
                    bankName='FLI - PBR - GBP';
                }
            }
            //if payment is Electronic.
            else if(this.epr.Payment_Method__c=='Electronic'){
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
       
        if(bankAcc.size()>0){
                            
             List<EPR_Payable_Item__c> EPR_Line=[SELECT Item__c,Quantity__c,Gross_price__c,Dim_3__c, GLA__c,Grant_Funding_Availale_dim4__c,Location_Dim2__c,Department_dim1__c
                                                 FROM EPR_Payable_Item__c
                                                 WHERE EPR__c=:this.epr.id]; 
             
             //create a pin
                 c2g__codaPurchaseInvoice__c PIN=new c2g__codaPurchaseInvoice__c(
                    c2g__Account__c=this.epr.Vendor_Company__c,
                    c2g__InvoiceDate__c=Date.Today(),
                    c2g__DueDate__c=this.epr.Scheduled_Payment_Date__c,
                    c2g__AccountInvoiceNumber__c=this.epr.Invoice_Number__c,
                    c2g__InvoiceCurrency__c=bankAcc.get(0).c2g__BankAccountCurrency__c
                    );
                    
                  try{
                      insert PIN;
                      //insert PIN Line Items                                  
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
                     idStr.add(eprLine.Dim_3__c);
                    
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
                    String dim3=ECO_Map.get(eprLine.Dim_3__c);
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
                                                                          c2g__Dimension3__c=dim3,
                                                                          c2g__Dimension4__c=GrantFunding
                                                                         );
                   PIN_Line.add(pinLine);
                  }
                  
                  insert PIN_Line;
                 }
                 this.epr.Payable_Invoice__c=PIN.ID;
                 
                 //copy attachments for PIN header
                 Attachment[] attList = [select id, name, body from Attachment where ParentId = :this.epr.id];
                 Attachment[] insertAttList = new Attachment[]{};
                 
                 for(Attachment a: attList)
                 {
                       Attachment att = new Attachment(name = a.name, body = a.body, parentid = PIN.id);
                       insertAttList.add(att);
                 }
                   if(insertAttList.size() > 0)
                 {
                       insert insertAttList;
                 }
             update this.epr;
             
             return  new PageReference('/' + epr.Id);
          }catch(Exception e){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
              return null;
          }
                    
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not get a matching bank account'));
            return null;
        } 
        
        
      }
      else{
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This EPR already has a PIN'));
          return null;
      }   
    }
   }