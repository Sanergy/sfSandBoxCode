public class CreateCashEntryFromEPR {
    private ApexPages.StandardController standardController;
    private String id;
    public id cshEntryID {get; set;}
    public List<c2g__codaCashEntry__c> cashEntry {get; set;}
    Electronic_Payment_Request__c epr;
    public String companyGUID {get; set;}
    public String companyName {get; set;}
    private String companyNameInitials {get; set;}
    
    public CreateCashEntryFromEPR (ApexPages.StandardController standardController){
        this.standardController = standardController;
        epr=(Electronic_Payment_Request__c)standardController.getRecord();
        this.epr=[SELECT id, Name, Cash_Entry__c,Payable_Invoice__c,Payment_Method__c,Notes__c,Vendor_Company__c,Confirmation_Number__c,
                  Vendor_Currency__c,Payment_Type__c,Scheduled_Payment_Date__c,Invoice_Number__c,Company__c, department__c,
                  Vendor_Invoice_Number__c, Status__c, Gross_Payment_Amount__c, EPR_Request_Type__c, Vendor_and_Payment_Currencies_match__c
                  FROM Electronic_Payment_Request__c
                  WHERE ID=:epr.id];
    }
    
    private Boolean CheckFFAUserCompany(){
        //check the Company associated with the EPR
        List<String> FFAConfigCompanyName = SanergyUtils.GetFFAConfigCompanyName(epr.Company__c);
        system.debug('Company__c 11' + FFAConfigCompanyName);
        if(FFAConfigCompanyName != NULL){
            this.CompanyGUID =  FFAConfigCompanyName[1];
            this.CompanyName = FFAConfigCompanyName[0];
        }
        
        //proceed if one company found and company names are the same
        if(c2g.CODAAPICompany_2_0.GetCurrentCompanies(null).size() == 1 &&
           this.companyName == c2g.CODAAPICompany_2_0.GetCurrentCompanies(null)[0] //check if Companies match
          ){
              return TRUE; //confirm current company is same as what user is currently in
          }
        else{
            //not Found
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot create Cash Entry, ensure FFA Company selected is the same as that of the EPR'));
            return FALSE;
        }
    }
    
    public PageReference createCashEntryWithLines(){
        if (CheckFFAUserCompany() == TRUE){
            Electronic_Payment_Request__c epr=(Electronic_Payment_Request__c)standardController.getRecord();
            this.epr=[SELECT Cash_Entry__c,Payable_Invoice__c,Payment_Method__c,Notes__c,Vendor_Company__c,Confirmation_Number__c,
                      Vendor_Currency__c,Payment_Type__c,Scheduled_Payment_Date__c,Invoice_Number__c,Company__c, department__c,
                      Vendor_Invoice_Number__c, Status__c, Gross_Payment_Amount__c, EPR_Request_Type__c, Vendor_and_Payment_Currencies_match__c
                      FROM Electronic_Payment_Request__c
                      WHERE ID=:epr.id];
            
            if(this.epr.Cash_Entry__c==null){
                
                String company=this.epr.Company__c;
                String bankName;
                
                //If company is Sanergy
                if(company=='Sanergy Ltd'){
                    //if payment is Check or EFT
                    if(this.epr.Payment_Method__c=='Check' || this.epr.Payment_Method__c=='EFT'){
                        if(this.epr.Vendor_Currency__c=='KES'){
                            bankName='SL - SCB - KES';
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
                    else if(this.epr.Payment_Method__c=='Electronic' || this.epr.Payment_Method__c=='ACH'){
                        bankName='SL - SCB - KES';
                    }   
                }
                
                //If company is Fresh Life
                else if(company=='Fresh Life Initiative Ltd'){
                    //if payment is Check or EFT
                    if(this.epr.Payment_Method__c=='Check' || this.epr.Payment_Method__c=='EFT'){
                        if(this.epr.Vendor_Currency__c=='KES'){
                            bankName='FLI - SCB - KES';
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
                    else if(this.epr.Payment_Method__c=='Electronic' || this.epr.Payment_Method__c=='ACH'){
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
                
                List<c2g__codaBankAccount__c> bankAcc=[SELECT Id,c2g__BankAccountCurrency__c 
                                                       FROM c2g__codaBankAccount__c
                                                       WHERE Name=:bankName];
                
                if(bankAcc.size()>0){
                    c2g__codaCashEntry__c cashEntry=new c2g__codaCashEntry__c(
                        c2g__Type__c='Payment',
                        c2g__BankAccount__c=bankAcc.get(0).id,
                        c2g__CashEntryCurrency__c=bankAcc.get(0).c2g__BankAccountCurrency__c ,
                        c2g__Reference__c=this.epr.Confirmation_Number__c,
                        c2g__PaymentMethod__c=this.epr.Payment_Method__c,
                        c2g__Description__c=this.epr.Notes__c,
                        EPR__c=this.epr.id
                    );
                    
                    try{
                        insert cashEntry;
                        cshEntryID = cashEntry.id;
                        List<EPR_Payable_Item__c> EPR_Line=[SELECT Item__c,Quantity__c,Gross_price__c, GLA__c,Grant_Funding_Availale_dim4__c,Location_Dim2__c,Department_dim1__c
                                                            FROM EPR_Payable_Item__c
                                                            WHERE EPR__c=:this.epr.id]; 
                        
                        List<c2g__codaCashEntryLineItem__c> cashEntryLine=new List<c2g__codaCashEntryLineItem__c>();
                        
                        for(EPR_Payable_Item__c eprLineItem:EPR_Line){
                            c2g__codaCashEntryLineItem__c cEntryLine=new c2g__codaCashEntryLineItem__c(
                                c2g__Account__c=this.epr.Vendor_Company__c,
                                c2g__AccountReference__c=this.epr.Confirmation_Number__c,
                                c2g__AccountPaymentMethod__c=this.epr.Payment_Method__c,
                                c2g__CashEntryValue__c=eprLineItem.Gross_price__c ,
                                c2g__CashEntry__c=cashEntry.id
                            );
                            
                            cashEntryLine.add(cEntryLine);       
                        }
                        insert cashEntryLine;
                        
                        this.epr.Cash_Entry__c=cashEntry.id;
                        
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
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This EPR already has a Cash Entry record!'));
                return null;
            }   
        }else{
            //Multiple Companies found
            return NULL;
        }
    }
}