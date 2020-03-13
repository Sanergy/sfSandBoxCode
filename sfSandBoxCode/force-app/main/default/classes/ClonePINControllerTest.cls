@isTest(SeeAllData=true)
public class ClonePINControllerTest{

    public static testMethod void testClonePINController() {
    
    List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
    if(userFFA.size()>0){
     System.runAs(userFFA.get(0)){
    
      //get a SIN
        List<c2g__codaPurchaseInvoice__c> PINList =[SELECT ID FROM c2g__codaPurchaseInvoice__c 
                                            WHERE c2g__ExpensesNetTotal__c >0
                                            AND c2g__ExternalId__c=null 
                                            AND c2g__InvoiceCurrency__r.c2g__OwnerCompany__r.name='Sanergy Limited' 
                                            LIMIT 1];
                                            
        
        if(PINList.size()>0){
            PageReference pageRef = Page.Clone_PIN;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(PINList.get(0));
            ApexPages.currentPage().getParameters().put('Id',PINList.get(0).id);
            ClonePINController controller = new ClonePINController(sc);
      
            controller.clonePin();
         }
       }
     }
   }
}