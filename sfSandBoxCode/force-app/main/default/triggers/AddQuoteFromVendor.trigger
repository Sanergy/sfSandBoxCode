trigger AddQuoteFromVendor on PTS_Line_Item__c (before insert , before update) {
    if(Trigger.isInsert){        
        for(PTS_Line_Item__c prl: Trigger.new){
            System.debug('AddQuoteFromVendor prLI = ' + prl);
            System.debug('AddQuoteFromVendor prl.Purchase_Order_Item__c = ' + prl.Purchase_Order_Item__c);
            if(prl.Purchase_Order_Item__c != null){
                
                Purchase_Order_Item__c poI = [SELECT Id, Unit_Net_Price__c,Name, Inventory_Item__c ,Gross_Value__c,Item_Cost__c,
                                              Item_Description__c,Net_VAT__c,Primary_Vendor__c,Purchase_UoM__c,Vendor__c,Vatable__c,
                                              VAT_Percentage__c,VAT_Inclusive__c, Currency__c
                                              FROM Purchase_Order_Item__c WHERE Id =: prl.Purchase_Order_Item__c
                                              /*AND Primary_Vendor__c = true*/];
                
                
               
                if(poI != null){
                    
                    prl.Quote_Currency__c = poI.Currency__c;                      
                    prl.Unit_Quote_Price__c = poI.Item_Cost__c;                                
                    prl.Vatable__c = poI.Vatable__c;                                            
                    prl.VAT_Percentage__c = poI.VAT_Percentage__c;                                    
                    prl.Vendor__c = poI.Vendor__c;                                
                    prl.Item_Quote_Information__c =  poI.Item_Description__c;   
                    prl.VAT_Inclusive__c= poI.VAT_Inclusive__c;                                                
                }
                /*
for(Purchase_Order_Item__c po:poI){ 

Quote__c quote = new Quote__c();

quote.Net_Value__c = po.Unit_Net_Price__c;
quote.PTS_Line_Item__c = prl.Id;
quote.Quantity__c = 1;
quote.Vatable__c = po.Vatable__c;
quote.VAT_Inclusive__c = po.VAT_Inclusive__c;
quote.Vendor__c = po.Vendor__c;
quote.UoM__c = po.Purchase_UoM__c;
quote.Description__c = po.Item_Description__c;
quote.VAT_Total__c = po.VAT_Percentage__c;              
quote.Amount__c = po.Item_Cost__c;
if(po.Primary_Vendor__c = true){
quote.Selected__c = true;
}

insert quote;
}
*/
            }
        }
    }
    else if(Trigger.isUpdate){        
        for(PTS_Line_Item__c prl: Trigger.new){
            if(prl.Purchase_Order_Item__c != trigger.oldMap.get(prl.id).Purchase_Order_Item__c){
                /* 
LIST< Quote__c > q = [SELECT Id, PTS_Line_Item__c, Selected__c FROM Quote__c 
WHERE PTS_Line_Item__c =: prl.Id AND Selected__c = true];

//1. Clear values
if(q.size() > 0 ){
for(Quote__c qt:q){
// prl.Quote_Currency__c = null;                      
//prl.Unit_Quote_Price__c = null;                                
//prl.Vatable__c = false;                                            
prl.VAT_Percentage__c = null;                                    
prl.Vendor__c = null;                                
prl.Item_Quote_Information__c =  null;     
prl.VAT_Inclusive__c= false;        

update prl;

qt.Selected__c = false;
update qt;
}
//}else{
List<Purchase_Order_Item__c> poI = [SELECT Id, Unit_Net_Price__c,Name, Inventory_Item__c ,Gross_Value__c,Item_Cost__c,
Item_Description__c,Net_VAT__c,Primary_Vendor__c,Purchase_UoM__c,Vendor__c,Vatable__c,
VAT_Percentage__c,VAT_Inclusive__c
FROM Purchase_Order_Item__c WHERE Id =: prl.Purchase_Order_Item__c
AND Primary_Vendor__c = true];

for(Purchase_Order_Item__c po:poI){ 

Quote__c quote = new Quote__c();

quote.Net_Value__c = po.Unit_Net_Price__c;
quote.PTS_Line_Item__c = prl.Id;
quote.Quantity__c = 1;
quote.Vatable__c = po.Vatable__c;
quote.VAT_Inclusive__c = po.VAT_Inclusive__c;
quote.Account__c = po.Vendor__c;
quote.UoM__c = po.Purchase_UoM__c;
quote.Description__c = po.Item_Description__c;
quote.VAT_Total__c = po.VAT_Percentage__c;              
quote.Amount__c = po.Item_Cost__c;
quote.Currency__c = prl.Currency_Config__c;
if(po.Primary_Vendor__c = true){
quote.Selected__c = true;
}

insert quote;
}}
else{*/
                
                if(prl.Purchase_Order_Item__c == null){
                    prl.Quote_Currency__c = null;                      
                    prl.Unit_Quote_Price__c = null;                                
                    prl.Vatable__c = false;                                            
                    prl.VAT_Percentage__c = '';                                    
                    prl.Vendor__c = null;                                
                    prl.Item_Quote_Information__c =  null;           
                    prl.VAT_Inclusive__c= false; 
                }
                else{
                    Purchase_Order_Item__c poI = [SELECT Id, Unit_Net_Price__c,Name, Inventory_Item__c ,Gross_Value__c,Item_Cost__c,
                                                  Item_Description__c,Net_VAT__c,Primary_Vendor__c,Purchase_UoM__c,Vendor__c,Vatable__c,
                                                  VAT_Percentage__c,VAT_Inclusive__c, Currency__c
                                                  FROM Purchase_Order_Item__c WHERE Id =: prl.Purchase_Order_Item__c
                                                  /*AND Primary_Vendor__c = true*/];
                    
                    if(poI != null){
                        prl.Quote_Currency__c = poI.Currency__c;                      
                        prl.Unit_Quote_Price__c = poI.Item_Cost__c;                                
                        prl.Vatable__c = poI.Vatable__c;                                            
                        prl.VAT_Percentage__c = poI.VAT_Percentage__c;                                    
                        prl.Vendor__c = poI.Vendor__c;                                
                        prl.Item_Quote_Information__c =  poI.Item_Description__c;           
                        prl.VAT_Inclusive__c= poI.VAT_Inclusive__c; 
                    }
                }
                
            }
        }
    }
    
}