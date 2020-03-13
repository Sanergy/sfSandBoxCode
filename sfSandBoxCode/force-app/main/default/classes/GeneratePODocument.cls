public class GeneratePODocument{
  
    public Purchase_Order__c po {get; set;}
    
    private ApexPages.StandardController standardController;
    
    public List<Purchase_Order_Line_Item__c> poLineItems {get; set;}
    
    public List<String> terms {get; set;}
    
    public Decimal itemSubtotal {get; set;}
    public Decimal totalTax {get; set;}
    public Decimal totalAmount {get; set;}
    public static Integer rank=1;
    
    public List<PoLineWrapper> polineWrapper {get; set;}
   
    
    public GeneratePODocument(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        polineWrapper =new List<PoLineWrapper>();
        
        //initialize models
        po =(Purchase_Order__c )standardController.getRecord(); 
        
        this.poLineItems = [SELECT Purchase_Order_Item__r.Item_Description__c, Quantity_Requested__c,Purchase_Order_Item__r.Vendor_Code__c,
                            Purchase_Order_Item__r.Purchase_UoM__r.Name,Unit_Price__c,Item__c,UoM__c,Purchase_Order_Item__r.Vendor_Description__c,
                            Total_Price__c, Terms_Conditions__c,Unit_Net_Price__c ,Total_Net_Price__c
                            FROM Purchase_Order_Line_Item__c
                            WHERE Purchase_Order__c=:po.id];
       
        terms=new List<String>();
                            
        itemSubtotal =0; 
        totalTax =0;
        totalAmount=0;
        
        init(this.poLineItems);
        
        buildTermsAndConditions();
       
    }
    
    private void init(List<Purchase_Order_Line_Item__c> po_line){
        for(Purchase_Order_Line_Item__c poLine : po_line){
            this.itemSubtotal += poLine.Total_Price__c; 
            //this.totalTax += (poLine.VAT_Amount__c * poLine.Quantity_Requested__c).setScale(2);
            this.totalAmount += poLine.Total_Price__c;
            
            PoLineWrapper pow=new PoLineWrapper(poLine );
            this.polineWrapper.add(pow);
            
        }
    }
    
    private void buildTermsAndConditions(){
        for(PoLineWrapper poline: this.polineWrapper){
            if(poline.poLineItem.Terms_Conditions__c!=null){
                this.terms.add('#'+poline.rnk+' - '+poline.poLineItem.Terms_Conditions__c);
            }
        }
    }
    
   
    
    public class PoLineWrapper{
    
        public Purchase_Order_Line_Item__c poLineItem {get; set;}
        public Integer rnk  {get; set;}
        
        public PoLineWrapper(Purchase_Order_Line_Item__c poline){
            this.poLineItem=poline;
            rnk=rank;
            rank++;
        }
    } 
}