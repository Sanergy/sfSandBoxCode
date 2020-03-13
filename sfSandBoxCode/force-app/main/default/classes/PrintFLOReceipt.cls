public class PrintFLOReceipt{
  
    //models
    public Flo_Document_Printing_Config__c printingConfig {get; set;}
    public List<cashEntryHolder> cashEntryList {get; set;}
    Account acc {get; set;}
    public String errorMessage {get; set;}
    public c2g__codaCashEntry__c  selectedCE {get; set;}
    
    private ApexPages.StandardController standardController;
   
    
    public PrintFLOReceipt(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        //initialize models
        acc=(Account)standardController.getRecord();
        printingConfig =new Flo_Document_Printing_Config__c ();
        cashEntryList =new List<cashEntryHolder>();
        errorMessage = 'Some error message goes here';
        selectedCE =new c2g__codaCashEntry__c ();
        
        List<c2g__codaCashEntry__c> cEntriesForAccount=[SELECT name,c2g__Date__c,c2g__PaymentMethod__c,c2g__Reference__c,c2g__Value__c,Receipt_Generated__c
                                                        FROM c2g__codaCashEntry__c 
                                                        WHERE c2g__Account__c=:acc.id
                                                        ORDER BY Receipt_Generated__c, name DESC];
         //initialize cash entry holder                                               
        for(c2g__codaCashEntry__c c:cEntriesForAccount){
            cashEntryHolder ceh=new cashEntryHolder(c);
            cashEntryList.add(ceh);
        }
        
    }
    
    public List<cashEntryHolder> getCashEntries(){
        return cashEntryList;
    }
    
    
    public PageReference generateReceipt() {
    
        Integer count=0;
        for(cashEntryHolder ceh:cashEntryList ){
            if(ceh.selected==true){
                selectedCE =ceh.cashEntry;
                count++;
            }
            
            if(count > 1){
                break;
            }
        }
        
        
        if(count > 1){        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select only one Cash Entry record'));
            return null;
        }else if(count < 1){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Cash Entry record'));
            return null;
        }else{
            selectedCE.Receipt_Generated__c=true;
            update selectedCE;
            
            return Page.FLO_Receipt_template;
        }    
    }
    
    
    //model class
    public class cashEntryHolder{
     
        public c2g__codaCashEntry__c cashEntry{get; set;}
        public boolean selected{get; set;}
                
        public cashEntryHolder(c2g__codaCashEntry__c ce){
            cashEntry=ce;
            selected=false;
        }        
    }
}