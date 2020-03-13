public with sharing class FFSCapitalisation {
    
    public List<c2g__codaJournalLineItem__c> jnlLineItems {get;set;}
    public List<c2g__codaJournal__c> jnls {get;set;}
    public AggregateResult [] jnlsToCreate {get;set;}
    public List<jnlsLIToDisplay> jnLIx {get;set;}
    
    public String jnlCreated {get;set;}
    public String periodSearchText {get;set;}
    public Integer noOfLineItemsToProcess {get;set;}
    String jnlPeriodLineDesc = '';
    Public String sfInstanceURL {get;set;}
    String sfJNLURL = '';
    

    Double DebitValue = 0.0;
    Double CreditValue = 0.0;
    Double jnlLIValue = 0.0;
    
    public FFSCapitalisation(){
        //Initialise
        periodSearchText = '';
        //Get current period
        String ffaPeriod = '000' + String.valueOf(Date.today().month());
        ffaPeriod = String.valueOf(Date.today().year()) + '/' + ffaPeriod.Right(3);
        periodSearchText = ffaPeriod;
        noOfLineItemsToProcess = 50; //Default to 50 Line Items to Process
        sfInstanceURL = string.valueof(System.URL.getSalesforceBaseUrl().toExternalForm());
        show();
    } 
    
    public void show(){
        jnLIx = new List<jnlsLIToDisplay>();
    }
    public PageReference SearchJournals(){
        //period format = ####/### eg 2019/005
        if(periodSearchText != '' && periodSearchText.length() == 8){
            jnlPeriodLineDesc = '- FFS Updated (' + periodSearchText +')';
            DisplayJournalsToCreate();  
        }else
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Period format must be in the form "####/###" eg 2019/005');
            ApexPages.addmessage(errorMessage); 
        }

        return null;
    }
    public void DisplayJournalsToCreate() {
        //Display journals to be created. GROUP BY will return distinct set with aggregate value
       system.debug('hellow world');
         jnlsToCreate = [
                         SELECT c2g__Journal__r.c2g__Period__r.Name Period ,c2g__Dimension1__r.Name DIM1,
                         c2g__GeneralLedgerAccount__r.c2g__ReportingCode__c,
                         c2g__GeneralLedgerAccount__c GLAGUID,
                         c2g__GeneralLedgerAccount__r.Name GLA, SUM(c2g__Value__c)Value
                         FROM c2g__codaJournalLineItem__c
                         WHERE c2g__Journal__r.Product_Type__c = 'Fee for Service FLT - "FFS FLT",' 
                         AND c2g__Journal__r.c2g__Period__r.Name =: periodSearchText
                         //AND (NOT c2g__LineDescription__c LIKE : '%' + jnlPeriodLineDesc + '%')
                         AND c2g__Value__c > 0
                         AND c2g__OwnerCompany__c = 'a19D00000026xHv' //Fresh Life
                         AND c2g__Dimension1__r.Name = 'Fresh Life Operations - Installation' 
                         AND c2g__GeneralLedgerAccount__r.c2g__ReportingCode__c IN ('5102','5104')
                         AND c2g__Journal__r.c2g__JournalStatus__c = 'In Progress'
                         GROUP BY c2g__Journal__r.c2g__Period__r.Name,c2g__Dimension1__r.Name,c2g__GeneralLedgerAccount__c,
                         c2g__GeneralLedgerAccount__r.Name,c2g__GeneralLedgerAccount__r.c2g__ReportingCode__c
                         ];
        if(jnlsToCreate.size() > 0){
            
            //get the Journal Line Items
            DisplayJournalLineItems() ;
            
        }else{
            //Set Journal Line Items to empty to avoid displaying previous search details
            //jnlLineItems.clear();
            ApexPages.Message jnlLIUpdatedMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There are no Journals found for the specified period.');
            ApexPages.addmessage(jnlLIUpdatedMsg); 
        }
           
    }  
    
    public void DisplayJournalLineItems() {
        //Display journals to be created. 
        if(noOfLineItemsToProcess >0 && noOfLineItemsToProcess <501){
            noOfLineItemsToProcess = noOfLineItemsToProcess;
        }else{
            //Limit to 100 JNLs to reduce too many SOQL error
            noOfLineItemsToProcess = 500;
        }
        if(jnlsToCreate !=null && jnlsToCreate.size() > 0){
            jnlLineItems = [
                                SELECT id, Name, c2g__Journal__c,c2g__Journal__r.Name,c2g__Journal__r.Product_Type__c, c2g__LineDescription__c ,
                                c2g__Journal__r.c2g__Period__r.Name, c2g__Value__c,c2g__Dimension1__r.Name,
                                c2g__GeneralLedgerAccount__r.Name
                                FROM c2g__codaJournalLineItem__c
                                WHERE c2g__Journal__r.Product_Type__c = 'Fee for Service FLT - "FFS FLT",' 
                				AND c2g__Value__c > 0
                				AND c2g__OwnerCompany__c = 'a19D00000026xHv' //Fresh Life
                                AND c2g__Journal__r.c2g__Period__r.Name =: periodSearchText
                                AND c2g__Dimension1__r.Name = 'Fresh Life Operations - Installation' 
                                AND c2g__GeneralLedgerAccount__r.c2g__ReportingCode__c IN ('5102','5104')
                                AND c2g__Journal__r.c2g__JournalStatus__c = 'In Progress'
                				//AND (NOT c2g__LineDescription__c LIKE : '%' + jnlPeriodLineDesc + '%')	
                                //AND c2g__Journal__r.c2g__Period__r.Name = '2019/005'
                                LIMIT : noOfLineItemsToProcess
                            ]; 
        }

    }
    
    
    public PageReference CreateJournal(){
        //for each row in the JNLs List, create one JNL Header and then for each row, 
        //and 2 line items one to debit 1580 and the other credit the relevant 5102-4 GLA
        if(jnlsToCreate!=null && jnlsToCreate.size() > 0){
            //Create Journal
            c2g__codaJournal__c ffajournal = new c2g__codaJournal__c
                (
                    c2g__JournalDate__c = System.today(),
                    c2g__JournalStatus__c = 'In Progress',
                    ffgl__DerivePeriod__c = true,
                    c2g__Transaction__c = null,                        
                    c2g__JournalCurrency__c = 'a0qD0000005LWNc', //FreshLife KES Currency
                    c2g__OwnerCompany__c = 'a19D00000026xHv', //Fresh Life Company,
                    c2g__JournalDescription__c = 'FFS Capitalisation',
                    c2g__Reference__c = 'FFS Capitalisation',
                    Product_Type__c = 'FFS Capitalisation'
                );
            insert ffajournal;
            
            sfJNLURL = sfInstanceURL + '/' + string.valueof(ffajournal.id);
            
            system.debug('jnlCreated URL '+ sfInstanceURL);
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.INFO,'Journal has been successfully created. </br>Click <a href = "' + sfJNLURL +'">here</a> to view the Journal</br>');
            ApexPages.addmessage(errorMessage);  
            
            for(AggregateResult jnlRow : jnlsToCreate){
                //create debit and credit line items for each row
                DebitValue = (Decimal) CalculateJNLLineItemsValues((Id) jnlRow.get('GLAGUID')); //jnlRow.get('Value');
                CreditValue = (Decimal) CalculateJNLLineItemsValues((Id) jnlRow.get('GLAGUID')) * -1;
                c2g__codaJournalLineItem__c debitLine = new c2g__codaJournalLineItem__c
                    (
                        c2g__Journal__c =  ffajournal.Id,
                        c2g__DebitCredit__c = 'Debit',
                        c2g__LineType__c = 'General Ledger Account',
                        c2g__GeneralLedgerAccount__c = 'a1QD000003EeFYv',//1580 GLA Account
                        c2g__Value__c = DebitValue  ,
                        c2g__Dimension1__c = 'a1ID0000008zZCd', //DIM 1 Fresh Life Operations - Installation
                        c2g__LineDescription__c = 'FFS Capitalisation'
                    );
                insert debitLine;
                
                c2g__codaJournalLineItem__c creditLine = new c2g__codaJournalLineItem__c
                    (
                        c2g__Journal__c = ffajournal.Id,
                        c2g__DebitCredit__c = 'Credit',
                        c2g__LineType__c ='General Ledger Account',
                        c2g__GeneralLedgerAccount__c =  (Id) jnlRow.get('GLAGUID'),// Credit the relevant JNL GLA
                        c2g__Value__c = CreditValue,
                        c2g__Dimension1__c = 'a1ID0000008zZCd', //DIM 1 Fresh Life Operations - Installation
                        c2g__LineDescription__c = 'FFS Capitalisation'
                	);
                insert creditLine;    
                
                //display amount that will be updated
                jnLIx.add(new jnlsLIToDisplay(jnlRow, sfJNLURL, DebitValue));
	
            }
            //update the line items
            UpdateJNLLineItems();          
        }else{
            ApexPages.Message jnlLIUpdatedMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There are no Journals to be created.');
            ApexPages.addmessage(jnlLIUpdatedMsg); 
        }
        //Clear the JNL Lists
        if(jnlsToCreate!=null && jnlsToCreate.size()>0){
           jnlsToCreate.clear(); 
        } 
        if(jnlLineItems!=null && jnlLineItems.size() > 0){
           jnlLineItems.clear(); 
        }
        
        return null;
    }
    
    public void UpdateJNLLineItems(){
        //Loop through list and update the product type with the period
        for(c2g__codaJournalLineItem__c jnlLI : jnlLineItems )
        {           
            //Update the Line Description to sho that the JNL LI was updated eg "- FFS Updated (2019/005)"
            jnlLI.c2g__LineDescription__c = jnlLI.c2g__LineDescription__c + jnlPeriodLineDesc;
        }

        //update the Line Items to indicate that the respective Journals have been created
        if(jnlLineItems!=null && jnlLineItems.size() > 0)
        {
            //Update the Journal Line Items
            update jnlLineItems;
            
            ApexPages.Message jnlLIUpdatedMsg = new ApexPages.Message(ApexPages.Severity.INFO,'The associated Journal Line Items have been updated with Line Description :"' + jnlPeriodLineDesc + '"');
            ApexPages.addmessage(jnlLIUpdatedMsg); 
        } 
    }
    
    public Double CalculateJNLLineItemsValues(Id GLAGUID){
        //Set default
        jnlLIValue = 0.0;
        
        //Loop through list and update the product type with the period
        for(c2g__codaJournalLineItem__c jnlLI : jnlLineItems )
        {           
            //check if they have the same GLA and add to  the debits value
            if(jnlLI.c2g__GeneralLedgerAccount__c == GLAGUID){
                jnlLIValue = jnlLIValue + jnlLI.c2g__Value__c;
            }
        }
        system.debug('jnlLIValue = ' + jnlLIValue);
        return jnlLIValue;
    }
    
    public class jnlsLIToDisplay {
        public String TimeUpdated {get;set;}
        public String JNLID {get;set;}
        public String Period {get;set;}
        public String DIM1 {get;set;}
        public String GLA {get;set;}
        Public Double DebitValue {get;set;}
        
        public jnlsLIToDisplay(AggregateResult a, String JNLGUID, Double jnlValue){
            TimeUpdated = string.valueofGmt(System.now());
            JNLID = JNLGUID;
            Period = (String) a.get('Period');
            DIM1 = (String) a.get('DIM1');
            GLA = (String) a.get('GLA');
            DebitValue = jnlValue;
        }
    }
}