public class LocationAddController{

    ApexPages.StandardController controller;
    Inventory_Item__c item;
    public Inventory_Item_Location__c location {get; set;}
    public List<lotWrapper> lots;
    public List<LocWrapper> wrapper {get; set;}
    public LocWrapper wr {get; set;}
    private Group_Details__c locAddCredit;
    private Group_Details__c locAddDebit;
    private Group_Details__c locAdjCredit;
    private Group_Details__c locAdjDebit;
    private Group_Details__c locScrpCredit;
    private Group_Details__c locScrpDebit;
    private Group_Details__c cyclCntCredit;
    private Group_Details__c cyclCntDebit;
                                         
    public boolean lotsVisible {get; set;}
   
    //controller
    public LocationAddController(ApexPages.StandardController controller){
        this.controller=controller;
        this.item=(Inventory_Item__c)controller.getRecord();
        this.item=[SELECT id, Name,Default_Lot__c,unit_cost__c,Item_Group__c,
                   Item_Group__r.Dimension_1__r.lookup_ID__c,Item_Group__r.Dimension_2__r.lookup_ID__c,
                   Item_Group__r.Dimension_3__r.lookup_ID__c,Item_Group__r.Dimension_4__r.lookup_ID__c
                   FROM Inventory_Item__c
                   WHERE Id=:this.item.id];                   
        
        List<Group_Details__c> glas = [SELECT Id, Name, Credit_Debit__c, Config_Account__r.Lookup_Id__c,Transaction_ID__c,Config_Account__c
                                       FROM Group_Details__c
                                       WHERE Inventory_Item_Group__c = :this.item.Item_Group__c
                                       AND (Transaction_ID__c = 'INVLOCADJ'
                                            OR Transaction_ID__c = 'INVLOCADD'
                                            OR Transaction_ID__c = 'CYCLECNT'
                                            OR Transaction_ID__c = 'INVLOCSCRP'
                                       )
                                       AND Is_GL_Account__c = true];
                                       
         for(Group_Details__c gd: glas){
            if(gd.Credit_Debit__c == 'Credit' && gd.Transaction_ID__c=='INVLOCADJ'){
                locAdjCredit= gd;
            } else if(gd.Credit_Debit__c == 'Credit' && gd.Transaction_ID__c=='INVLOCADD'){
                locAddCredit= gd;
            } else if(gd.Credit_Debit__c == 'Debit' && gd.Transaction_ID__c=='INVLOCADJ'){
                locAdjDebit= gd;
            } else if(gd.Credit_Debit__c == 'Debit' && gd.Transaction_ID__c=='INVLOCADD'){
                locAddDebit= gd;
            } else if(gd.Credit_Debit__c == 'Credit' && gd.Transaction_ID__c=='CYCLECNT'){
                cyclCntCredit= gd;
            } else if(gd.Credit_Debit__c == 'Credit' && gd.Transaction_ID__c=='INVLOCSCRP'){
                locScrpCredit= gd;
            } else if(gd.Credit_Debit__c == 'Debit' && gd.Transaction_ID__c=='CYCLECNT'){
                cyclCntDebit= gd;
            } else if(gd.Credit_Debit__c == 'Debit' && gd.Transaction_ID__c=='INVLOCSCRP'){
                locScrpDebit= gd;
            }
        }
                   
        lotsVisible =false;
        getLocations();
    }
    
    public void getLocations(){
    
        if(wrapper==null){
            wrapper= new List<LocWrapper>();
            List<Inventory_Item_Location__c> locations=[SELECT id,Name, Location__c,Location_Quantity__c,Location_Name__c ,Max_Location_Quantity__c,re_order_Level__c,
                                                        (SELECT id,name, Dimension_1__c, Expire_Date__c,Cycle_Count__c,Lot_Name__c,Quantity__c,Batch_Date__c,Adjust_Quantity__c
                                                         FROM Item_Location_Lots__r ORDER BY LastModifiedDate DESC) 
                                                        FROM Inventory_Item_Location__c 
                                                        WHERE Inventory_Item__c=:item.id];  
            
            Integer counter=0;
        
             for(Inventory_Item_Location__c loc:locations){
                LocWrapper wr=new LocWrapper(loc,counter);  
                wrapper.add(wr);          
                counter++;
            }
        }                                         
       
    }
    
    public PageReference pageItemAdjust(){
         return Page.Perform_Inventory_Adjust;
    }
    
    public void resetPageUpdate(){
        for(LocWrapper l : wrapper){
            for(lotWrapper lt: l.lots){
                lt.lots.Adjust_Quantity__c=null;
                lt.lots.Cycle_Count__c=false;
                lt.selectedAction ='';
            }                     
        }
    }
    
    
    public PageReference pageNewLocation(){
        location =new Inventory_Item_Location__c();
        location.Inventory_Item__c=item.id;
        
        lots= new List<lotWrapper>(); 
        addLotLine();  
        lots.get(0).lots.Lot_Name__c=this.item.Default_Lot__c;     
        
        return Page.Perform_Inventory_Adjust_New_Location;
    }
    
    public PageReference pageNewLots(){
        this.wr= null;
        
        Integer locIndex= Integer.valueOf(ApexPages.currentPage().getParameters().get('locId'));
       // Integer locIndex= Integer.valueOf(ApexPages.currentPage().getParameters().get('locId'));
        
        for(LocWrapper lw : this.wrapper){
            if(lw.index == locIndex){
                this.wr= lw;
                break;
            }
        }
        
        lots= new List<lotWrapper>(); 
        addLotLine();
        return Page.Perform_Inventory_Adjust_New_Lots;
    }
    
    
    public PageReference saveNewLocation(){    

        Inventory_Location__c loc=[SELECT name FROM Inventory_Location__c WHERE ID=:this.location.location__c];
      
        this.location.name=loc.name+' - '+this.location.Location_Name__c;
        LocWrapper lw=new LocWrapper(this.location,wrapper.size());    
        lw.lots=getLots();
        
        for(lotWrapper l:lw.lots){
            l.selectedAction='I';
        }
        wrapper.add(lw);
       
        return Page.Perform_Inventory_Adjust;
        
    }
    
    public PageReference saveNewLots(){   
       for(lotWrapper l:getLots()){
            l.selectedAction='I';
            wr.lots.add(l);
        }       
        return Page.Perform_Inventory_Adjust;
    }
    
    public PageReference pageUpdateQuantities(){
        return Page.Perform_Inventor_Adjust_Update;
    }
    
     public PageReference saveUpdateQuantities(){
        
        for(LocWrapper l : wrapper){
            for(lotWrapper lt: l.lots){
                lt.lots.Adjust_Quantity__c=null;
            }                     
        }
        return Page.Perform_Inventor_Adjust_Update;
    }
    
  
    
    //add lots
    public PageReference addLotLine(){
    
        lotWrapper wr=new lotWrapper(new Item_Location_Lot__c(Quantity__c=0),lots.size());
        lots.add(wr);
        
        return null;    
    }
    
    public PageReference removeLot(){
        Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('removeLotIndex'));
        
        for(lotWrapper w:lots){
            if(w.index==index ){
                w.rendered=false;
                break;
            }
        }
        return null;
    }
    
    public PageReference performLocationAdd(){       
        List<Inventory_Item_Location__c> newLocations=new List <Inventory_Item_Location__c>();
        List<Inventory_Item_Location__c> updateLocations=new List <Inventory_Item_Location__c>();
        List<Inventory_Transaction__c> transactions=new  List<Inventory_Transaction__c>();
        
        List<Item_Location_Lot__c>  newLots = new List<Item_Location_Lot__c>();
        List<Item_Location_Lot__c>  updatedLots = new List<Item_Location_Lot__c>();
    
        
        Boolean requiresAddGLAs=false;
        Boolean requiresAdjGLAs=false;
        Boolean requiresScrapGLAs=false;
        Boolean requiresCyclCntGLAs=false;        
        
       //insert new locations
        for(LocWrapper l : wrapper){
            if(l.selected==true && l.loc.id == null){  
                newLocations.add(l.loc);             
            }           
        }      
        insert newLocations;
        
        //insert new lots
        for(LocWrapper l : wrapper){
            if(l.selected==true){
                for(lotWrapper lt: l.lots){
                  if(lt.selected==true){                      
                      if(lt.lots.id==null){
                       
                        requiresAddGLAs=true;
                        lt.isNew=true;
                        lt.lots.Item_Location__c=l.loc.id;
                        newLots.add(lt.lots);                       
                      } 
                      else if(lt.lots.Adjust_Quantity__c!=null && lt.lots.Adjust_Quantity__c>0){
                        
                        if(lt.selectedAction=='S'){
                           requiresScrapGLAs=true;
                        }
                       
                        else if(lt.lots.Cycle_Count__c==true){
                             requiresCyclCntGLAs=true;
                        }  
                        else{
                            requiresAdjGLAs=true;
                        }                      
                      }
                  }                                       
                }
            }           
        }
        insert newLots;
        
        //check if required GLAs exist
        //Add
        if(requiresAddGLAs==true && (locAddCredit==null || locAddDebit==null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit INVLOCADD GL Accounts');
            ApexPages.addmessage(msg);
            return null;
        }
        //Adjust
        if(requiresAdjGLAs==true && (locAdjCredit==null || locAdjDebit==null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit INVLOCADJ GL Accounts');
            ApexPages.addmessage(msg);
            return null;
        }
        //Cycle Count
        if(requiresCyclCntGLAs==true && (cyclCntCredit==null || cyclCntDebit==null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit CYCLECNT GL Accounts');
            ApexPages.addmessage(msg);
            return null;
        }
        //Scrap
        if(requiresScrapGLAs==true && (locScrpCredit==null || locScrpDebit==null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'The item configuration is missing either credit or debit INVLOCSCRP GL Accounts');
            ApexPages.addmessage(msg);
            return null;
        }
        
        Set<id> departmentSet = new Set<id>();
        
        //get all departments
         for(LocWrapper l : wrapper){
             for(lotWrapper lt: l.lots){
                 if(lt.lots.Dimension_1__c!=null){
                     departmentSet.add(lt.lots.Dimension_1__c);
                 }
             }
         }
         
         Map<id, FFA_Config_Object__c> departmentMap = new Map<id, FFA_Config_Object__c>([SELECT id, lookup_ID__c FROM FFA_Config_Object__c WHERE ID IN :departmentSet ]);
        
        
        
        //update quantity values
         for(LocWrapper l : wrapper){
            if(l.selected==true){
                for(lotWrapper lt: l.lots){
                   if(lt.selected==true && lt.lots.Adjust_Quantity__c!=null && lt.lots.Adjust_Quantity__c>0){
                       
                      //create transaction record
                      Inventory_Transaction__c trans = new Inventory_Transaction__c(
                            Item__c = this.item.id,
                            Transaction_ID__c = 'INVLOCADJ',
                            Location__c = l.loc.id,
                            Location_Lot__c = lt.lots.id,
                            Transaction_Quantity__c = lt.lots.Adjust_Quantity__c,
                            Item_Unit_Price__c = this.item.unit_cost__c,
                            Quantity_Impact__c = lt.selectedAction,
                            Debit_Account__c = locAdjDebit.Config_Account__r.Lookup_Id__c,
                            Credit_Account__c = locAdjCredit.Config_Account__r.Lookup_Id__c,
                            Dimension_1__c = departmentMap.get(lt.lots.Dimension_1__c)== null? null : departmentMap.get(lt.lots.Dimension_1__c).lookup_ID__c,
                            Dimension_2__c = this.item.Item_Group__r.Dimension_2__r.lookup_ID__c,
                            Dimension_3__c = this.item.Item_Group__r.Dimension_3__r.lookup_ID__c,
                            Dimension_4__c = this.item.Item_Group__r.Dimension_4__r.lookup_ID__c
                        );
                       
                       if(lt.isNew){
                           trans.Transaction_ID__c = 'INVLOCADD';
                           trans.Debit_Account__c = locAddDebit.Config_Account__r.Lookup_Id__c;
                           trans.Credit_Account__c = locAddCredit.Config_Account__r.Lookup_Id__c;
                       } 
                       
                       else if(lt.selectedAction=='S'){
                           trans.Transaction_ID__c = 'INVLOCSCRP';
                           trans.Debit_Account__c = locScrpDebit.Config_Account__r.Lookup_Id__c;
                           trans.Credit_Account__c = locScrpCredit.Config_Account__r.Lookup_Id__c;
                       }
                       else if(lt.lots.Cycle_Count__c==true){
                           trans.Transaction_ID__c = 'CYCLECNT';
                           trans.Debit_Account__c = cyclCntDebit.Config_Account__r.Lookup_Id__c;
                           trans.Credit_Account__c = cyclCntCredit.Config_Account__r.Lookup_Id__c;
                       }
                       
                       trans.Comments__c =trans.Transaction_ID__c;
                       transactions.add(trans);                     
                   }                   
                }
            }           
         }
        insert transactions;
        
         
        return new PageReference('/'+item.id);
    }  
    
    public List<lotWrapper> getLots(){
        List<lotWrapper> lw=new List<lotWrapper>();
        for(lotWrapper l: lots ){
            if(l.rendered==true){
                lw.add(l);
            }
        }
        return lw;
     } 
     
    public class LocWrapper{
        public Inventory_Item_Location__c loc {get; set;}
        public Integer index {get; set;}        
        public boolean selected{get; set;}
        public List<lotWrapper> lots {get; set;}
        
        public LocWrapper(Inventory_Item_Location__c l, Integer count){
            this.loc = l;
            this.index=count;
            
            this.lots=new List<lotWrapper>();
            for(Item_Location_Lot__c lts: l.Item_Location_Lots__r){
                lotWrapper lw=new lotWrapper(lts);
                lots.add(lw);
            }
            
          
            selected=true;
        }
        
        public Integer getLotSize(){
            return loc.Item_Location_Lots__r.size();
        } 
        
        public List<lotWrapper> getLotsSelected(){
         List<lotWrapper> wrapperSelected=new List<lotWrapper>();
         
         for(lotWrapper l: this.lots){
             if(l.selected==true){
                 wrapperSelected.add(l);
             }
         }
         
         return wrapperSelected;
        }
    } 
     
    public class lotWrapper{
        public  boolean selected {get; set;}
        public  Item_Location_Lot__c lots {get; set;}
        public  Integer index {get; set;}
        public boolean rendered {get; set;}
        public List<SelectOption> adjustAction {get; set;}
        public String selectedAction {get;set;}
        public Decimal newQuantity;
        public String comments{get;set;}
        public Boolean isNew; //deternimes whether lot is new or existing
        
        public lotWrapper(Item_Location_Lot__c l, Integer index){
            this.lots=l;
            selected=true;
            this.index=index;
            rendered=true;
            adjustAction=new List<SelectOption>();
            adjustAction.add(new SelectOption('','-NONE-'));
            adjustAction.add(new SelectOption('I','I'));
            adjustAction.add(new SelectOption('D','D'));
            adjustAction.add(new SelectOption('S','SCRAP'));
            isNew=false;
            comments = '';
        }
        
        //if constructor has no index, call main constructor with 0 index
        public lotWrapper(Item_Location_Lot__c l){
            this(l, 0);
        }
        
        public Decimal getNewQuantity(){
        
            Decimal finalQuantity=lots.Quantity__c;
            
            if(lots.Adjust_Quantity__c==null){
                finalQuantity=lots.Quantity__c;
            }
            else if(selectedAction=='I'){
                finalQuantity=lots.Quantity__c + lots.Adjust_Quantity__c;
            }
            else if(selectedAction=='D'){
                finalQuantity=lots.Quantity__c - lots.Adjust_Quantity__c;
            }
          
            
            
            return finalQuantity;
        }
        
        
    }
}