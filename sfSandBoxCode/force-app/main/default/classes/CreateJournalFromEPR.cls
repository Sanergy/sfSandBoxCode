public class CreateJournalFromEPR {

    private ApexPages.StandardController standardController;
    private String id;
   
    public CreateJournalFromEPR (ApexPages.StandardController standardController){
        this.standardController = standardController;    
    }
    
    
    public PageReference createJournal(){
        
        Electronic_Payment_Request__c eprin = (Electronic_Payment_Request__c) this.standardController.getRecord();
        
        Electronic_Payment_Request__c epr = [SELECT Journal__c, Company__c,Payable_Invoice__c,Payment_Method__c,Notes__c,Vendor_Company__c,
               Confirmation_Number__c,Vendor_Currency__c,Payment_Type__c,Scheduled_Payment_Date__c,Invoice_Number__c
               FROM Electronic_Payment_Request__c
               WHERE ID=:eprin.id
              ];
        
        if(epr.Journal__c == null){
            String company=epr.Company__c;
            String bankName;
            
            //If company is Sanergy
            if(company=='Sanergy Ltd'){
                 if(epr.Payment_Method__c=='Electronic'){
                    bankName='SL - SCB - KES';
                } else if(epr.Payment_Method__c=='Check' || epr.Payment_Method__c=='EFT'){
                    if(epr.Vendor_Currency__c=='KES'){
                        bankName='SL - PBH - KES';
                    }
                    else if(epr.Vendor_Currency__c=='USD'){
                        bankName='SL - PBR - USD';
                    }
                    else if(epr.Vendor_Currency__c=='EUR'){
                        bankName='SL - PBR - EUR';
                    }
                    else if(epr.Vendor_Currency__c=='GBP'){
                        bankName='SL - PBR - GBP';
                    }
                }
            }
            
            //If company is Fresh Life
            else if(company=='Fresh Life Initiative Ltd'){
                //if payment is Check or EFT
                if(epr.Payment_Method__c=='Check' || epr.Payment_Method__c=='EFT'){
                    if(epr.Vendor_Currency__c=='KES'){
                        bankName='FLI - PBH - KES';
                    }
                    else if(epr.Vendor_Currency__c=='USD'){
                        bankName='FLI - PBR - USD';
                    }
                    else if(epr.Vendor_Currency__c=='EUR'){
                        bankName='FLI - PBR - EUR';
                    }
                    else if(epr.Vendor_Currency__c=='GBP'){
                        bankName='FLI - PBR - GBP';
                    }
                }
                //if payment is Electronic.
                else if(epr.Payment_Method__c=='Electronic'){
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
            
            
            List<c2g__codaBankAccount__c > bankAcc=[SELECT Id, c2g__BankAccountCurrency__c, c2g__OwnerCompany__c,
                                                    c2g__GeneralLedgerAccount__c 
                                                    FROM c2g__codaBankAccount__c
                                                    WHERE Name=:bankName];
            
            
             if(bankAcc.size() > 0){
                 
                 c2g__codaJournal__c ffajournal = new c2g__codaJournal__c(
                     c2g__JournalDate__c = System.today(),
                     c2g__JournalStatus__c = 'In Progress',
                     ffgl__DerivePeriod__c = true,
                     c2g__Transaction__c = null,
                     Vendor_Account__c = epr.Vendor_Company__c,
                     c2g__OwnerCompany__c = bankAcc.get(0).c2g__OwnerCompany__c,
                     c2g__JournalDescription__c = epr.Notes__c,
                     Electronic_Payment_Request__c = epr.Id
                 );
                 insert ffajournal;
                 
                 epr.Journal__c = ffajournal.Id;
                 
                 List<EPR_Payable_Item__c> eprItems = [SELECT Id, GLA__r.lookup_ID__c, Gross_price__c, Item__c,
                                                       Department_dim1__r.lookup_ID__c, Location_Dim2__r.lookup_ID__c, 
                                                       Dim_3__r.lookup_ID__c, Grant_Funding_Availale_dim4__r.lookup_ID__c
                                                      FROM EPR_Payable_Item__c
                                                      WHERE EPR__c = :epr.Id
                                                      ];
                 
                 for(EPR_Payable_Item__c eprItem : eprItems){
                     
                      c2g__codaJournalLineItem__c debitLine = new c2g__codaJournalLineItem__c(
                        c2g__Journal__c =  ffajournal.Id,
                        c2g__DebitCredit__c = 'Debit',
                        c2g__LineType__c = 'General Ledger Account',
                        c2g__GeneralLedgerAccount__c = eprItem.GLA__r.lookup_ID__c,
                        c2g__Value__c = eprItem.Gross_price__c,
                        c2g__Dimension1__c = eprItem.Department_dim1__r.lookup_ID__c,
                        c2g__Dimension2__c = eprItem.Location_Dim2__r.lookup_ID__c,
                        c2g__Dimension3__c = eprItem.Dim_3__r.lookup_ID__c,
                        c2g__Dimension4__c = eprItem.Grant_Funding_Availale_dim4__r.lookup_ID__c,
                        c2g__LineDescription__c = eprItem.Item__c
                    );
                    insert debitLine;
                     
                     
                    c2g__codaJournalLineItem__c creditLine = new c2g__codaJournalLineItem__c(
                        c2g__Journal__c = ffajournal.Id,
                        c2g__DebitCredit__c = 'Credit',
                        c2g__LineType__c ='Bank Account', 
                        c2g__BankAccount__c = bankAcc.get(0).Id,
                        c2g__GeneralLedgerAccount__c = bankAcc.get(0).c2g__GeneralLedgerAccount__c,
                        c2g__Value__c = (eprItem.Gross_price__c == null ? eprItem.Gross_price__c :  (eprItem.Gross_price__c * -1)),
                        c2g__Dimension1__c = eprItem.Department_dim1__r.lookup_ID__c,
                        c2g__Dimension2__c = eprItem.Location_Dim2__r.lookup_ID__c,
                        c2g__Dimension3__c = eprItem.Dim_3__r.lookup_ID__c,
                        c2g__Dimension4__c = eprItem.Grant_Funding_Availale_dim4__r.lookup_ID__c,
                        c2g__LineDescription__c = eprItem.Item__c
                    );
                    insert creditLine;
                 }
                 
                 update epr;
                 return  new PageReference('/' + epr.Id);
             } else {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Could not get a matching bank account'));
             }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Te EPR already has a journal'));
        }
        return null;
    }
}