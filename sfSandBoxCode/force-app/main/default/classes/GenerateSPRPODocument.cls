public class GenerateSPRPODocument {
  
    public Special_Procurement__c spr {get; set;}
    
    private ApexPages.StandardController standardController;
    
    public List<Special_Procurement_Line_Item__c> sprLineItems {get; set;}
    
    public List<String> terms {get; set;}
    
    public Decimal itemSubtotal {get; set;}
    public Decimal totalTax {get; set;}
    public Decimal totalAmount {get; set;}
    public static Integer rank=1;
    @TestVisible public String sprCreatedDate {get; set;}
    
    public List<SPRLineWrapper> sprlineWrapper {get; set;}
   
    
    public GenerateSPRPODocument(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        sprlineWrapper =new List<SPRLineWrapper>();
        
        //initialize models
        spr =(Special_Procurement__c )standardController.getRecord(); 
        
        this.sprLineItems = [SELECT id, Purchase_Order_Item__r.Item_Description__c,Quantity_Requested__c,
                             Purchase_Order_Item__r.Vendor_Code__c,
                             Purchase_Order_Item__r.Purchase_UoM__r.Name, Unit_Price__c ,Item__c,
                             Purchase_Order_Item__r.Vendor_Description__c,Total_Price__c, Unit_Net_Price__c ,
                             Net_Total_Amount__c, Total_VAT__c
                             FROM Special_Procurement_Line_Item__c
                             WHERE Special_Procurement__c =:spr.id];
       
        terms=new List<String>();
                            
        itemSubtotal =0; 
        totalTax =0;
        totalAmount=0;
        
        init(this.sprLineItems);
        system.debug('spr ID:' + spr.id +'*** spr date' + spr.CreatedDate);
        
        if(this.sprCreatedDate == NULL){
            this.sprCreatedDate = System.now().format('YYYY-MM-DD');
        } else
        {
           this.sprCreatedDate = spr.CreatedDate.format('YYYY-MM-DD'); 
        }
        //buildTermsAndConditions();
    }
    
     private void init(List<Special_Procurement_Line_Item__c> spr_line){
        for(Special_Procurement_Line_Item__c sprLine : spr_line){
            this.itemSubtotal += sprLine.Total_Price__c; 
            this.totalTax += sprLine.Total_VAT__c.setScale(2);
            this.totalAmount += sprLine.Total_Price__c;
            
            SPRLineWrapper sprw=new SPRLineWrapper(sprLine );
            this.SPRLineWrapper.add(sprw);
            
        }
    }
    
    /*
    private void buildTermsAndConditions(){
        for(SPRLineWrapper sprline: this.sprlineWrapper){
            if(sprline.sprLineItem.Terms_Conditions__c!=null){
                this.terms.add('#'+sprline.rnk+' - '+sprline.sprLineItem.Terms_Conditions__c);
            }
        }
    }
*/


    
    
    public class SPRLineWrapper{
    
        public Special_Procurement_Line_Item__c sprLineItem {get; set;}
        public Integer rnk  {get; set;}
        
        public SPRLineWrapper(Special_Procurement_Line_Item__c sprline){
            this.sprLineItem=sprline;
            rnk=rank;
            rank++;
        }
    } 
}