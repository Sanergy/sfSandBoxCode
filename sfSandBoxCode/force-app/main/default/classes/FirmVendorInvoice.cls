public class FirmVendorInvoice {

    @TestVisible Public Vendor_Invoice__c vi{get;set;}
    @TestVisible public ApexPages.StandardController standardController;
    
    
    public FirmVendorInvoice(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.vi = (Vendor_Invoice__c)standardController.getRecord();
        /*
        this.vi =
            [
                SELECT Id, VI_Status__c, VI_Company__c
                FROM Vendor_Invoice__c
                WHERE Id =: this.vi.Id 
            ];
		*/
    }
    
    public PageReference FirmVI() {
        //insert VI Company at this stage
        //if the first VII, set the VI company to the Company on the VII
        /*
        AggregateResult [] aggVI = 
            [SELECT Company__c, Company__r.Name CompanyName, COUNT(id)VICOs
             FROM Vendor_Invoice_Items__c
             WHERE Vendor_Invoice__c =: this.vi.Id
             AND CreatedDate >= 2020-01-01T00:00:00Z
             GROUP BY Company__c, Company__r.Name
            ];
        //if one record found and company matches vii company firm the VI
        if(aggVI.size() > 0 && aggVI.size() == 1 ){
            //vi.VI_Company__c = (String)aggVI[0].get('Company__c');
            vi.VI_Status__c = 'Firmed';
            UPDATE vi;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'VI has been Firmed'));
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Company on the VI must match that of the VI Items'));
        }
        */
        return NULL;   
    }   
}