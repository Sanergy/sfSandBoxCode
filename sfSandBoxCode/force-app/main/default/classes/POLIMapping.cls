public class POLIMapping {
/*    public ApexPages.StandardController standardController;
    public Vendor_Invoice__c vi{get;set;}
    public Integer rowCount{get;set;}
//    public List<ItemWrapper>items{get;set;}
    public List<PoliWrapper>poItems{get;set;}
    public List<Vendor_Invoice_Purchase_Order_Line_Item__c> VIPOitems{get;set;}
    public Purchase_Order_Line_Item__c poli{get;set;}
    public List<Purchase_Order_Line_Item__c> poliList;
    
    public POLIMapping(ApexPages.StandardController standardController){
        this.standardController = standardController;
        
        // ApexPages.currentPage().getParameters().get('id')
        // get the vi  items of the current vendor invoice
        this.vi = (Vendor_Invoice__c)standardController.getRecord();
        this.vi = [SELECT ID,Name,Expected_Total__c,Receipt_Variance__c,Payment_Variance__c,Invoice_Total__c,
                   Total_Payments__c,Reconciled_Invoice_Total__c,Reconciled_Received_Value__c,Sum_VI_Items_Received_Value__c
                   FROM Vendor_Invoice__c
                   WHERE id =: this.vi.Id
                  ];
        system.debug('vENDOR iNVOICE' + this.vi);
     //  getItems();
        
        Rows();
        getpoItems();
        
    }

    //get the list of vendor invoice purchase order line items
 public List<Vendor_Invoice_Purchase_Order_Line_Item__c> getItems(){
        
      //  items = new List<ItemWrapper>();
        
        VIPOitems = [SELECT ID,Name,Item_Received_Total__c,
                     Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,
                     Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
                     Purchase_Order_Line_Item__r.Quantity_Requested__c,
                     Purchase_Order_Line_Item__r.Quantity_Accepted__c,
                     Purchase_Order_Line_Item__c,Requested_Quantity__c,
                     Status__c,Total_Cost__c,Vendor_Invoice__c,
                     Reconciled_Item_Quantity_Received__c,
                     Last_Invoice__c,Payment_Variance__c,Receipt_Variance__c
                     FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                     WHERE Vendor_Invoice__c =: this.vi.Id
                    ];
         
        return  VIPOitems;   
    }

    //get the purchase order line items that hav ebeen selected for reconciliation 
    public List<PoliWrapper> getpoItems(){
        
              VIPOitems = [SELECT ID,Name,Item_Received_Total__c,
                     Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,
                     Purchase_Order_Line_Item__r.Purchase_Order_Item__r.Name,
                     Purchase_Order_Line_Item__r.Quantity_Requested__c,
                     Purchase_Order_Line_Item__r.Quantity_Accepted__c,
                     Purchase_Order_Line_Item__c,Requested_Quantity__c,
                     Status__c,Total_Cost__c,Vendor_Invoice__c,
                     Reconciled_Item_Quantity_Received__c,
                     Last_Invoice__c,Payment_Variance__c,Receipt_Variance__c
                     FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                     WHERE Vendor_Invoice__c =: this.vi.Id
                    ];
        
        List<String> poliIds = new List<String>();

              for(Vendor_Invoice_Purchase_Order_Line_Item__c vendorInvoice: VIPOitems){
                poliIds.add(vendorInvoice.Purchase_Order_Line_Item__c);
            }
      
        poItems = new List<PoliWrapper>();
        
       // for(Vendor_Invoice_Purchase_Order_Line_Item__c item: VIPOitems ){  
            poliList = [SELECT ID,Name,Last_Invoice__c,VI_Avg_Unit_Price__c,Item__c,
                        Unit_Gross_Price__c,Payment_Variance__c,Receipt_Variance__c,Purchase_Order_Item__r.Name,
                        Quantity_Requested__c,Quantity_Accepted__c,Po_line_Receipt_Status__c,Status__c	
                        FROM Purchase_Order_Line_Item__c 
                        WHERE ID IN : poliIds
                        AND (Last_Invoice__c = TRUE
                             AND Status__c != 'Closed')
                       ]; 
            
            for(Purchase_Order_Line_Item__c lst:poliList){
                //PoliWrapper wrap = new PoliWrapper(lst);
                //poItems.add(wrap);
                poItems.add(new PoliWrapper(lst));    
            }
        //} 
        
        return poItems;
    }
    
    // Get the number of Rows 
    public Integer Rows(){
        AggregateResult [] Results = [SELECT COUNT(ID)no
                                      FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                                      WHERE Vendor_Invoice__c =: this.vi.Id
                                     ];
        rowCount = integer.valueOf(Results[0].get('no'));
        return rowCount;
    }
    //save method
    public PageReference save(){
        upsert vi;       
       // upsert VIPOitems;
      System.debug('RETERTERTETETETETE' +poliList);

        
        upsert poliList; 
        
     
      //  getpoItems();
     System.debug('RETERTERTETETETETE' +poliList);

        return Page.POLIMapping;
        //  return (new ApexPages.StandardController(vi)).view();
        //return new PageReference('/' + vi.Id);
        
    }
    
    
    public void ReconcilePOLI(){
                //getpoItems();
        //getpoItems();
        for(PoliWrapper poItm: getpoItems()){
             poliList = [SELECT ID,Name,Last_Invoice__c,VI_Avg_Unit_Price__c,Item__c,
                        Unit_Gross_Price__c,Payment_Variance__c,Receipt_Variance__c,Purchase_Order_Item__r.Name,
                        Quantity_Requested__c,Quantity_Accepted__c,Po_line_Receipt_Status__c,Status__c	
                        FROM Purchase_Order_Line_Item__c 
                        WHERE ID =: poItm.polineItems.id
                       ];
            
            
            upsert poliList; 
            //System.debug('RETERTERTETETETETE' + poItm.paymentVariance2);
              //  poliList.get(0).Payment_Variance__c = poItm.paymentVariance2;
          
        }
        System.debug('qwwqeqweweqewqe ' +poliList);

       // system.debug('polist'+poliList );
        
        //return (new ApexPages.StandardController(vi)).view(); 
    }
    
    //wrapper class
  /*  public PageReference CalculateTotals(){
        
        VIPOitems = [SELECT ID,Name,Item_Received_Total__c,
                     Item_Total__c,Item_Unit_Cost__c,Item_Vat__c,
                     Purchase_Order_Line_Item__c,Requested_Quantity__c,
                     Reconciled_Line_Total__c,
                     Status__c,Total_Cost__c,Vendor_Invoice__c
                     FROM Vendor_Invoice_Purchase_Order_Line_Item__c
                     WHERE Vendor_Invoice__c =: vi.Id
                    ];       
        
        for (Vendor_Invoice_Purchase_Order_Line_Item__c item : VIPOitems){
            for(ItemWrapper itm : getItems()){
                item.Item_Total__c = (itm.vipoli.Item_Unit_Cost__c);
            }
            ItemWrapper wrapper = new ItemWrapper(item);
            items.add(wrapper);
        }
        
        //getItems();
        return null;
        
    }
    //Vendor Invoice Purchase Order Line Items Wrapper Class 
   public class ItemWrapper{
        public Vendor_Invoice_Purchase_Order_Line_Item__c vipoli{get;set;}
        public Boolean selected {get; set;}
        
        public ItemWrapper(Vendor_Invoice_Purchase_Order_Line_Item__c vipolitems){
            selected = false;
            vipoli = vipolitems;
        }
        
    }*/
    //Purcahse Order line item wrapper class
  /*  public class PoliWrapper{
        public Purchase_Order_Line_Item__c polineItems{get;set;}
     //  public String paymentVariance2 {get;set;}
       // public String receiptVariance2 {get;set;}
        
        public PoliWrapper(Purchase_Order_Line_Item__c poL){
            polineItems =  poL;
        }
    }
    */
}