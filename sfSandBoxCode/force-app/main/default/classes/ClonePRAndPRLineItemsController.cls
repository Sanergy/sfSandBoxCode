public class ClonePRAndPRLineItemsController {
    
    private ApexPages.StandardController standardController;
    public Procurement_Tracking_Sheet__c pr{get; set;}
    public Procurement_Tracking_Sheet__c PRequest{get;set;}
    public List<PTS_Line_Item__c> items{get;set;}
    public List<PTS_Line_Item__c> itemsToInsert {get;set;}
    public List<PRLineItemsWrapper> pRLineItemsWrapper {get; set;}
    ApexPages.Message myMsg;
    
    public ClonePRAndPRLineItemsController(ApexPages.StandardController standardController){
        this.standardController = standardController;
         // Record being cloned
        Procurement_Tracking_Sheet__c originalPR = (Procurement_Tracking_Sheet__c) standardController.getRecord();
        
        String soql = Utils.getCreatableFieldsSOQL('Procurement_Tracking_Sheet__c', 'Id=\'' + originalPR.Id + '\'');
        Procurement_Tracking_Sheet__c completePR = (Procurement_Tracking_Sheet__c)Database.query(soql);
         
        PRequest = completePR.clone(false, false, false, false);

        pRLineItemsWrapper = new List<PRLineItemsWrapper>();
                
        //Select Items
             String itemQry = Utils.getCreatableFieldsSOQL('PTS_Line_Item__c', 'Procurement_Tracking_Sheet__c=\'' + originalPR.Id + '\'');
             
             List<PTS_Line_Item__c> items = (List<PTS_Line_Item__c>)Database.query(itemQry);
                                         
        for(PTS_Line_Item__c item:items){
            PTS_Line_Item__c newLine = item.clone(false, false, false, false);
            PRLineItemsWrapper wr = new PRLineItemsWrapper(newLine);
            pRLineItemsWrapper.add(wr);
        }
    } 
    
     public PageReference selectAll() {
        if(pRLineItemsWrapper != null){
            for(PRLineItemsWrapper lg:pRLineItemsWrapper){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(pRLineItemsWrapper != null){
            for(PRLineItemsWrapper lg:pRLineItemsWrapper){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    public PageReference  processSelected() {
        
         if(pRLineItemsWrapper != null && pRLineItemsWrapper.size() > 0){
            
            integer issued = 0;
            integer expected = 0;
             try{
            	
            	PRequest.Id = null;
                PRequest.Stage__c = 'Open';
                PRequest.Team_Lead_Approval_Status__c = 'Pending';
                insert PRequest;
                 
                 itemsToInsert = new List<PTS_Line_Item__c>();

                 for(PRLineItemsWrapper item : pRLineItemsWrapper){
                     expected +=1;
                     item.newItem.Procurement_Tracking_Sheet__c = PRequest.Id;
                     item.newItem.Status__c = 'Open';                     
                     itemsToInsert.add(item.newItem);
                 }
                 insert itemsToInsert;
                 /*BatchInsertUtil batch=new BatchInsertUtil (itemsToInsert);
                 Database.executeBatch(batch, 100);*/
             //}
                 issued +=1;
                 
             }catch(Exception  e){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:'+e);
                 //System.debug('ERROR:'+e);
                 //ApexPages.addMessage(myMsg);
                 return null;

             }
            
        
            if(expected == issued && myMsg == null){
                return new PageReference('/' + PRequest.Id);
            } else {

                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Some Line Items were not edited');
                ApexPages.addmessage(msg);
                return null;
            }
            
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly confirm that selected Request has Lines'));
            return null;
        }
        return null;
    }
    
    public class PRLineItemsWrapper{
        
        public PTS_Line_Item__c newitem {get; set;}
        public Boolean selected {get; set;}
        public PRLineItemsWrapper(PTS_Line_Item__c item) {
            newItem = item;
           
            this.selected = true;
        }
    }


}