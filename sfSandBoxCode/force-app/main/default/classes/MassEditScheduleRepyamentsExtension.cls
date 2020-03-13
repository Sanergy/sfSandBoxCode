/*****************************************************
* Mass Edit Schedule Repayments associated with the opportunity
* Query existing records,when page is loaded
* and create dummy records for showing on the UI
******************************************************/

public class MassEditScheduleRepyamentsExtension { 
    private final Opportunity opportunity;
    private List<PaymentLineItem> lstGrantPaymentLineItem;
    private List<Id> lstDeletedPayments = new List<Id>();
    private List<PaymentLineItem> lstPaymentLineItem ;
    
    //========================================================//
    //Constructor
    //========================================================//
    public MassEditScheduleRepyamentsExtension(ApexPages.StandardController controller) {
        
        if(!Test.isRunningTest()) {
            controller.addFields(new String[]{'Actual_Launch_Date__c', 'Total_Number_of_Products__c'});
        }
        
        opportunity = (Opportunity)controller.getRecord();
        lstPaymentLineItem = new List<PaymentLineItem>();
        //LoadExistingPayments();
        if(lstPaymentLineItem.size() == 0) {
            AddRows(12);
        }
        Date launchDate = opportunity.Actual_Launch_Date__c ;
        Date originalLaunchDate = launchDate ;
        for (PaymentLineItem paymentWrapper : lstPaymentLineItem) {
            if(paymentWrapper.index == 1 ){   
                paymentWrapper.dbPayment.Payment_Date__c = launchDate ;
                paymentWrapper.dbPayment.Payment_Type__c = 'Kiva Monthly Payment' ;
                paymentWrapper.dbPayment.Payment_Status__c = 'Scheduled' ;
                if (opportunity.Total_Number_of_Products__c == 1) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 3000;
                } else if (opportunity.Total_Number_of_Products__c == 2) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 5000;
                } else if(opportunity.Total_Number_of_Products__c == 3) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 6500;
                } else if(opportunity.Total_Number_of_Products__c == 4) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 10000;
                }   
            }
            else {
                paymentWrapper.dbPayment.Payment_Date__c = launchDate ;
                paymentWrapper.dbPayment.Payment_Type__c = 'Kiva Monthly Payment' ;
                paymentWrapper.dbPayment.Payment_Status__c = 'Scheduled' ;
                if (opportunity.Total_Number_of_Products__c == 1) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 3000;
                } else if (opportunity.Total_Number_of_Products__c == 2) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 5000;
                } else if(opportunity.Total_Number_of_Products__c == 3) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 6500;
                } else if(opportunity.Total_Number_of_Products__c == 4) {
                    paymentWrapper.dbPayment.Payment_Amount__c = 10000;
                }
            }
            
            if(originalLaunchDate != null) {
                Integer year = launchDate.year();
                Integer month = launchDate.month();
                Integer day = originalLaunchDate.day();
                
                if (day >= 29 && month == 1) {
                    launchDate = Date.newInstance(year, month+1, 28);
                }
                else if (day == 31 && ( month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)) {
                    launchDate = Date.newInstance(year, month+1, 30);
                } else {
                    launchDate = Date.newInstance(year, month+1, day);
                }
                
            }
        }
        
    }
    
    public List<PaymentLineItem> getPayments() {
        return lstPaymentLineItem;
    }
    
    //----------------------------------------------------------------------//
    //Remove Payment Row
    //-----------------------------------------------------------------------//
    public PageReference RemovePaymentRow() {
        String rowIndex = ApexPages.currentPage().getParameters().get('delIndex');
        //Safety first
        if(rowIndex == null){
            return null;
        }
        
        Integer index = Decimal.valueOf(rowIndex).intValue() - 1;
        //Possibly a mistake
        if(index >= lstPaymentLineItem.size()) {
            return null;
        }
        
        PaymentLineItem currentPaymentLineItem = lstPaymentLineItem[index];
        lstPaymentLineItem.remove(index);
        if(currentPaymentLineItem.dbPayment != null && currentPaymentLineItem.dbPayment.Id != null) {
            lstDeletedPayments.add(currentPaymentLineItem.dbPayment.Id);
        }
        return null;
    }
    
    
    //==========================================================//
    //Add new payment line Item row the grid
    //==========================================================//  
    public PageReference AddPaymentLineItem() {
        AddRows(1);
        return null;
    }
    
    //============================================================//
    //Save All rows
    //=============================================================//
    public PageReference SaveAll() {
        try {
            delete [select Id from Payment__c where ID IN :lstDeletedPayments];
            List<Payment__c> lstPayment = ExtractRows();
            
            for (Payment__c payment : lstPayment ) {
                payment.Description__c = payment.Payment_Type__c ;
            }
            upsert lstPayment;
        }
        catch(DmlException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
        return new PageReference('/' + this.opportunity.Id);
    }
    
    //============================================================//
    //Extract rows
    //=============================================================//
    private List<Payment__c> ExtractRows() {
        List<Payment__c> lstPayment = new List<Payment__c>();
        for(PaymentLineItem  rptLineItem :lstPaymentLineItem){
            //If Id is not null,this record is already inserted,we have to upsert it 
            if(rptLineItem.dbPayment.Id != null) {
                lstPayment.add(rptLineItem.dbPayment);
                continue;
            }
            
            //Check if all data is blank,then we will have to skip adding the row
            if(!isRowBlank(rptLineItem.dbPayment)) {
                lstPayment.add(rptLineItem.dbPayment);
            }
        }
        return lstPayment ;
    }
    
    
    private Boolean isRowBlank(Payment__c payment) {
        if(payment.Description_Hidden__c != null)
            return false;
        if(payment.Payment_Date__c != null)
            return false;
        if(payment.Payment_Amount__c != null)
            return false;
        if(payment.Payment_Status__c != null)
            return false;
        
        //All fields are blank
        return true;
        
    }
    
    
    //=============================================================//
    //Add rows 
    //==============================================================//
    private void AddRows(Integer counter) {
        for(Integer i = 0; i < counter;i++) {
            lstPaymentLineItem.add(new PaymentLineItem(new Payment__c(Opportunity__c = this.opportunity.Id),lstPaymentLineItem.size()+1));
        }
    }
    /*
//==========================================================//
//Load Existing Payments for this opportunity
//===========================================================//
private void LoadExistingPayments() {
Integer i = 1;
for(Payment__c  payment :[Select ID,Payment_Date__c,Payment_Amount__c,Description__c,Payment_Status__c, Description_Hidden__c 
from Payment__c where Opportunity__c = :this.opportunity.ID order by Name]) {
lstPaymentLineItem.add(new PaymentLineItem(payment,i++));
}
}
*/
    //==============================Inner Class============================================//
    public class PaymentLineItem {
        public Boolean isSelected {get;set;}
        public Integer index {get;set;}
        public Payment__c dbPayment {get;set;}
        
        public PaymentLineItem(Payment__c payment,Integer index) {
            this.dbPayment  = payment;
            this.isSelected = false;
            this.index = index;
        }
    }
    
    
    @isTest
    private static void Test_Controller() {
        
        Account acc1 = new Account(Name = 'Test Account');
        insert acc1;
        
        Contact con1 = new Contact(LastName = 'Test Opp Salesperson');
        insert con1;
        
        Opportunity opp = new Opportunity( AccountId = acc1.Id, Primary_Salesperson__c = con1.Id, Sub_Area_Lookup__c = 'a09D000000JZ1eH', 
                                          CloseDate = System.today().addDays(20), StageName = 'Prospecting', Name = 'Test Opp');
        //Run test as TEMP RS        
        User u = [Select Id,Alias FROM User WHERE Alias = 'dev'];
        System.runAs(u) {            
            INSERT opp;
        }//End System.runAs(u)
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(opp);
        MassEditScheduleRepyamentsExtension extController = new MassEditScheduleRepyamentsExtension(ctrl);
        
        extController.getPayments();
        extController.AddPaymentLineItem();  
        extController.SaveAll();
        
        ctrl = new ApexPages.StandardController(opp);
        extController = new MassEditScheduleRepyamentsExtension(ctrl);
        
        Test.setCurrentPage(Page.MassEditScheduleRepyaments);
        ApexPages.currentPage().getParameters().put('delIndex',String.valueOf(1));
        extController.RemovePaymentRow();
        
        extController.SaveAll();
    }
    
    
}