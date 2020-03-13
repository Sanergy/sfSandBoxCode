@isTest(SeeAllData=true)
public class CloneSINControllerTest{
    
    public static testMethod void testCloneSINController() {
        
        List<User> userFFA=[Select Name, ID  From User WHERE name='Temp RS Account'];
        if(userFFA.size()>0){
            System.runAs(userFFA.get(0)){
                //get a SIN
                List<c2g__codaInvoice__c> SINList =[SELECT ID FROM c2g__codaInvoice__c 
                                                    WHERE c2g__NetTotal__c >0
                                                    AND c2g__ExternalId__c=null 
                                                    AND c2g__InvoiceCurrency__r.c2g__OwnerCompany__r.name='Sanergy Limited' 
                                                    LIMIT 1];
                
                if(SINList.size()>0){
                    
                    PageReference pageRef = Page.Clone_SIN;
                    Test.setCurrentPage(pageRef);
                    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(SINList.get(0));
                    ApexPages.currentPage().getParameters().put('Id',SINList.get(0).id);
                    CloneSINController controller = new CloneSINController(sc);
                    
                    controller.cloneSin();
                }
            }
        }
    }        
}