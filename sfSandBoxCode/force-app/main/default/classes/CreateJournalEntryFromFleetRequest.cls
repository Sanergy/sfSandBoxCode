public class CreateJournalEntryFromFleetRequest{
    
    private ApexPages.StandardController standardController;
    
    public CreateJournalEntryFromFleetRequest(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
    
    public PageReference createJournalLineEntry() {
        Fleet_Requests__c fleetReq= (Fleet_Requests__c) standardController.getRecord();
        
        //check if request type is internal
        if(fleetReq.Fleet_Request_Category__c!='Internal Fleet'){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Journal Line entry can only be created for an Internal Fleet Request Category.'));
            return null;
        }
        
        //check if Journal line entry is already created
        else if(fleetReq.Journal_Line_Entry__c!=null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Journal Line entry has already been created for this request.'));
            return null;
        }
        //check that required fields are specified
        else if(fleetReq.Company__c==null ||
           fleetReq.Fleet_Request_Category__c==null ||
           fleetReq.Departure_Date__c==null ||
           fleetReq.Requesting_Department__c==null ||
           fleetReq.End_Mileage__c==null ||
           fleetReq.Start_Mileage__c==null ||
           fleetReq.Location_Dim_2__c==null ||
           fleetReq.Dim_3__c==null ||
           fleetReq.Grant_Funding_Availale_Dim_4__c==null){
        
         Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kindly ensure all the required fields are filled.'));
          return null;
        }
       
        else{
            
          List<Fleet_Journal_Scheduler__c> fjs=[SELECT Journal__c FROM Fleet_Journal_Scheduler__c
                                                WHERE Start_date__c<=:fleetReq.Departure_Date__c
                                                AND End_date__c>=:fleetReq.Departure_Date__c
                                                AND Company__c=:fleetReq.Company__c];
                                                
          if(fjs.size()==0 || fjs.get(0).Journal__c==null){
              Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A journal has not been correctly scheduled for this period.'));
              return null;
          } 
          
          else if(fjs.size()>0){
          
              //get parameters from settings object
              Map<String, Sanergy_Settings__c> settings = Sanergy_Settings__c.getAll(); 
              
              //get actual Dimensions from FFA Config Object
              List<FFA_Config_Object__c> ffaConfig=[SELECT Type__c,lookup_ID__c FROM FFA_Config_Object__c
                                                    WHERE ID=:fleetReq.Requesting_Department__c
                                                    OR ID=:fleetReq.Location_Dim_2__c
                                                    OR ID=:fleetReq.Dim_3__c
                                                    OR ID=:fleetReq.Grant_Funding_Availale_Dim_4__c];
               
               //create a map of ffa config objects
               Map<String, String> ffaConfigMap=new Map<String, String>();
               for(FFA_Config_Object__c ffa:ffaConfig){
                   ffaConfigMap.put(ffa.Type__c, ffa.lookup_ID__c);
               }
              
              Decimal distanceCovered=0;
              if(fleetReq.Distance_Covered__c!=null){
                  distanceCovered=fleetReq.Distance_Covered__c;
              }
              
              //create a journal entry for the request
              c2g__codaJournalLineItem__c journalLine=new c2g__codaJournalLineItem__c(
                  c2g__Journal__c=fjs.get(0).Journal__c,
                  ffgl__DeriveLineNumber__c=true,
                  c2g__LineType__c='General Ledger Account',
                  c2g__DebitCredit__c='Debit',
                  c2g__GeneralLedgerAccount__c=settings.get('Fleet Journal GLA').value__c,
                  c2g__LineDescription__c='JE-Allocate transport usage to different departments per mileage report',
                  c2g__Value__c=Decimal.valueOf(settings.get('Fleet Cost Per Km').value__c)*distanceCovered,
                  c2g__Dimension1__c=ffaConfigMap.get('dim1'),
                  c2g__Dimension2__c=ffaConfigMap.get('dim2'),
                  c2g__Dimension3__c=ffaConfigMap.get('dim3'),
                  c2g__Dimension4__c=ffaConfigMap.get('dim4')
              );
              
              insert journalLine;
              
              fleetReq.Journal_Line_Entry__c=journalLine.id;
              update fleetReq;
              
          } 
          return new PageReference('/' + fleetReq.Id); 
        }
    }
 }