/*************************************************************************
Developer   - Dreamwares (India)
Description - This class is used to perform following operations
              1. Handle the Post request made by KopoKopo to salesforce custom API
              2. Create new records of Cash Entry and Cash Entry Line Item 
                 in salesforce based on KopoKopo Request parameters.
              3. Send notification Email to Account Clerk about unknown 
                 Cash Transactions form KopoKopo.
 ************************************************************************/

@RestResource(urlMapping='/KopoKopoService')
global class KopoKopoRequestHandler 
{
    /***************************************************
    Method Name - makeCashEntry
    Parameters  - none
    Return      - none
    Description - Used to parse the HTTP POST request of
                  KopoKopo and match the Phone Number with
                  KopoKopo contact or SF Account and create
                  new Cash Entry and Cash Entry Line Item
                  record in SF.
    ****************************************************/
    
    @HttpPost
    global static void makeCashEntry() 
    {
        RestRequest requestData = RestContext.request;
        RestResponse responseData = RestContext.response;
        responseData.addHeader('Content-Type', 'application/json');
        String strJsonResponse = '';
        
        //fetch parameters of HTTP request from KopoKopo
        String strBusinessNumber = requestData.params.get('business_number');
        String strTransactionReference = requestData.params.get('transaction_reference');
        String strTransactionTimestamp = requestData.params.get('transaction_timestamp');
        String strSenderPhone = requestData.params.get('sender_phone');
        String strAmount = requestData.params.get('amount');
        String strFirstName = requestData.params.get('first_name');
        String strMiddleName = requestData.params.get('middle_name');
        String strLastName = requestData.params.get('last_name');
        
        if(strSenderPhone.Contains('+'))
        {
            strSenderPhone = strSenderPhone.replace('+','');
        }
        
        system.debug('strSenderPhone : ' + strSenderPhone);
        //find if customer has registered phone number or not
        Boolean isAccountPresent = false;
        Boolean isInContacts = false;
        Boolean isDuplicate = false;
        
        c2g__codaCashEntry__c newCashEntry = new c2g__codaCashEntry__c();
        c2g__codaCashEntryLineItem__c newCashEntryLineItem = new c2g__codaCashEntryLineItem__c();
        String strStatus = '';
        
        //get values of all lookup objects needed for creating new cash entry
        List<KopoKopo_Contact__c> lstKopoKopoContacts = new List<KopoKopo_Contact__c>();
        lstKopoKopoContacts = [SELECT Id,Related_Account__c,Name,Phone__c
                               FROM KopoKopo_Contact__c
                               WHERE Phone__c = :strSenderPhone];
        
        List<KopoKopo_Contact__c> lstNewKopoKopoContacts = new List<KopoKopo_Contact__c>();
        
        List<Account> lstAccount = new List<Account>();
        lstAccount = [SELECT Id,Name,Phone
                       FROM Account
                       WHERE Phone = :strSenderPhone
                          OR Name = 'Unknown Customer Payment'];
        
        List<c2g__codaBankAccount__c> lstBankAccount = new List<c2g__codaBankAccount__c>();
        lstBankAccount = [SELECT Id,Name 
                          FROM c2g__codaBankAccount__c 
                          WHERE Name = 'FLI - KK - KES' LIMIT 1];
        
        List<c2g__codaGeneralLedgerAccount__c> lstBankChargesGLA = new List<c2g__codaGeneralLedgerAccount__c>();
        lstBankChargesGLA = [SELECT Id,Name 
                             FROM c2g__codaGeneralLedgerAccount__c 
                             WHERE Name = '6010 - Bank Charges & Interest' LIMIT 1];
        
        List<c2g__codaCompany__c> lstCompanies = new List<c2g__codaCompany__c>();
        lstCompanies = [SELECT Id,Name 
                        FROM c2g__codaCompany__c 
                        WHERE Name = 'Fresh Life Initiative Limited' LIMIT 1];
                        
        System.debug('Company ==> ' + lstCompanies[0]);
        
        List<c2g__codaAccountingCurrency__c> lstCurrency = new List<c2g__codaAccountingCurrency__c>();
        
        //Create new cash Entry and Cash Entry Line Item record
        
        if(!lstKopoKopoContacts.isEmpty())
        {
            if(lstKopoKopoContacts.size() > 1)
            {
                strStatus = 'Duplicate Matches Found.';
                isDuplicate = true;
            }
            else
            {
                isInContacts = true;
                newCashEntry.c2g__Account__c = lstKopoKopoContacts[0].Related_Account__c;
                newCashEntryLineItem.c2g__Account__c = lstKopoKopoContacts[0].Related_Account__c;
                strStatus = 'Fully Matched';
            }
        }
        
        
        if(!lstAccount.isEmpty() && !isInContacts && lstKopoKopoContacts.isEmpty())
        {
            if(lstAccount.size() <= 2)
            {
                for(Account selectedAccount : lstAccount)
                {
                    if(selectedAccount.Name != 'Unknown Customer Payment')
                    {
                        isAccountPresent = true;
                        newCashEntry.c2g__Account__c = selectedAccount.Id;
                        newCashEntryLineItem.c2g__Account__c = selectedAccount.Id;
                        
                        strStatus = 'Fully Matched';
                        
                        KopoKopo_Contact__c newKopoKopoContact = new KopoKopo_Contact__c();
                        newKopoKopoContact.Related_Account__c = selectedAccount.Id;
                        newKopoKopoContact.Name = selectedAccount.Name;
                        newKopoKopoContact.Phone__c = selectedAccount.Phone;
                        
                        lstNewKopoKopoContacts.add(newKopoKopoContact);
                    }
                }
                
                if(!lstNewKopoKopoContacts.isEmpty())
                {
                    try
                    {
                        insert lstNewKopoKopoContacts;
                    }
                    Catch(Exception e)
                    {
                        System.debug('ERROR : ' + e.getMessage());
                    }
                }
            }
            else
            {
                strStatus = 'Duplicate Matches Found.';
                isDuplicate = true;
            }
        }
        
        if(!isAccountPresent && !isInContacts)
        {
            if(!isDuplicate)
            {
                strStatus = 'Account not found';
            }
            
            for(Account selectdAccount : lstAccount)
            {
                if(selectdAccount.Name == 'Unknown Customer Payment')
                {
                    newCashEntry.c2g__Account__c = selectdAccount.Id;
                    newCashEntryLineItem.c2g__Account__c = selectdAccount.Id;
                    break;
                }
            }
        }
        
        if(!lstBankAccount.isEmpty())
        {
            newCashEntry.c2g__BankAccount__c = lstBankAccount[0].Id;
        }
        
        if(!lstBankChargesGLA.isEmpty())
        {
            newCashEntry.c2g__ChargesGLA__c = lstBankChargesGLA[0].Id;
        }
        
        if(!lstCompanies.isEmpty())
        {
            newCashEntry.c2g__OwnerCompany__c = lstCompanies[0].Id;
            lstCurrency = [SELECT Id,Name 
                       FROM c2g__codaAccountingCurrency__c 
                       WHERE Name = 'KES' 
                         AND c2g__OwnerCompany__c = :lstCompanies[0].Id LIMIT 1];
        }
        
        if(!lstCurrency.isEmpty())
        {
            newCashEntry.c2g__CashEntryCurrency__c = lstCurrency[0].Id;
        }
        
        List<String> lstTimeStamp = new List<String>();
        lstTimeStamp = strTransactionTimestamp.split('T');
        lstTimeStamp = lstTimeStamp[0].split('-');
        
        Date transactionDate;
        if(!lstTimeStamp.isEmpty())
        {
            transactionDate = Date.parse(lstTimeStamp[2]+ '/' + lstTimeStamp[1] + '/' + lstTimeStamp[0]);
            newCashEntry.c2g__Date__c = transactionDate;
        }
        
        String strDescription = '';
        strDescription += 'Business Number = ' + strBusinessNumber + '\n';
        if(transactionDate != null)
        {
            strDescription += 'Date = ' + transactionDate + '\n';
        }
        strDescription += 'Transaction Reference = ' + strTransactionReference + '\n';
        
        strDescription += ('Matching Status = ' + strStatus);
        
        newCashEntry.c2g__Description__c = strDescription;
        
        newCashEntry.c2g__PaymentMethod__c = 'Electronic';
        newCashEntry.c2g__Reference__c = strTransactionReference;
        newCashEntry.c2g__Type__c = 'Receipt';
        newCashEntry.c2g__Status__c = 'In Progress';
        
        newCashEntryLineItem.c2g__AccountReference__c = strTransactionReference;
        newCashEntryLineItem.c2g__BankAccountValue__c = Decimal.valueOf(strAmount);
        newCashEntryLineItem.c2g__CashEntryValue__c = Decimal.valueOf(strAmount);
        newCashEntryLineItem.ffcash__DeriveLineNumber__c = true;
        newCashEntryLineItem.ffcash__DerivePaymentMethod__c = true;
        newCashEntryLineItem.c2g__ExternalId__c = strTransactionReference;
        newCashEntryLineItem.c2g__AccountPaymentMethod__c = 'Electronic';
        
        //insert new Cash Entry and Cash Entry Line Item records
        try
        {
            system.debug('Cash Entry ==> ' + newCashEntry);
            insert newCashEntry;
            
            newCashEntryLineItem.c2g__CashEntry__c = newCashEntry.Id;
            system.debug('Cash Entry LineItem ==> ' + newCashEntryLineItem);
            insert newCashEntryLineItem;
        }
        catch(Exception e)
        {
            System.debug('ERROR : ' + e.getMessage());
        }
        
        //send Notification Email to Account Clerk if Account is not present
        system.debug('isAccountPresent' + isAccountPresent);
        if(!isAccountPresent && !isInContacts)
        {
            try
            {
                // send an email 
                List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage Mail = new Messaging.SingleEmailMessage();
                
                c2g__codaCashEntry__c cashEntry = [SELECT Id,Name FROM c2g__codaCashEntry__c WHERE Id = :newCashEntry.Id];
        
                List<String> lstSendToAddress = new List<String>();
                List<Profile> lstProfile = new List<Profile>();
                
                lstProfile = [SELECT Id, Name, (SELECT Id, Email FROM Users) 
                              FROM Profile 
                              WHERE Name = 'Sanergy - Finance - Accounts Receivable Clerk' LIMIT 1];
                
                if(!lstProfile.isEmpty())
                {
                    for(User usr :lstProfile[0].Users)
                    {
                        lstSendToAddress.add(usr.Email);
                    }
                }
                
                Mail.setToAddresses(lstSendToAddress);
                
                String emailDate = '';
                
                if(!lstTimeStamp.isEmpty())
                {
                  emailDate = lstTimeStamp[2]+ '/' + lstTimeStamp[1] + '/' + lstTimeStamp[0];
                }
                else
                {
                  emailDate = String.valueOf(transactionDate);
                }
        
                Mail.setSubject('Cash Matching - Unknown Payment - ' + cashEntry.Name + ' ' + strTransactionReference + ' Date : ' + emailDate);
                
                String strEmailBody = '';
                strEmailBody += '<br/><br/> The payment could not be matched.';
                strEmailBody += '<br/><br/> Payment Details : <br/><br/>';
                
                String salesforceInstanceURL = Salesforce_Instance_URL__c.getInstance('URL').URL__c;
                strEmailBody += 'Cash Entry ID : ' + '<a href=\'' + salesforceInstanceURL + '/' + cashEntry.Id + '\'>' + cashEntry.Name +'</a><br/>';
                
                if(strFirstName != null)
                  strEmailBody += '<br/> First Name   : ' + strFirstName  +'<br/>';
                
                if(strLastName != null)
                  strEmailBody += '<br/> Last Name    : ' + strLastName +'<br/>';
                
                if(strSenderPhone != null)
                  strEmailBody += '<br/> Phone Number : ' + strSenderPhone +'<br/>';
                
                if(strAmount != null)
                  strEmailBody += '<br/> Amount       : ' + strAmount +'<br/>';
                  
                if(strBusinessNumber != null)
                  strEmailBody += '<br/> Business Number : ' + strBusinessNumber +'<br/>';
                  
                if(strTransactionReference != null)
                  strEmailBody += '<br/> Transaction Reference : ' + strTransactionReference +'<br/>';
                  
                if(emailDate != null)
                  strEmailBody += '<br/> Transaction Date : ' + emailDate +'<br/>';
                  
                if(strStatus != null)
                  strEmailBody += '<br/> Reason : ' + strStatus +'<br/>';
                  
                Mail.setHtmlBody(strEmailBody);
                    
                lstMails.add(Mail);
                //Messaging.sendEmail(lstMails);
                    
            }
            Catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
            }
        }
        
        //response to KopoKopo about successfull payment recieving
        ResponseJSON response = new ResponseJSON();
        response.status = '01';
        response.description = 'Accepted';
        response.subscriber_message = 'Thank you..!!';
        responseData.statusCode = 200;
        strJsonResponse = JSON.serialize(response);
        responseData.responseBody = blob.valueOf(strJsonResponse);
        return;
    }
    
    public class ResponseJSON
    {
        public String status;
        public String description;
        public String subscriber_message;
    }
}