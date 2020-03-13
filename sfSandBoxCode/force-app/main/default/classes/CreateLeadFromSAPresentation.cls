public class CreateLeadFromSAPresentation {
   
    private ApexPages.StandardController standardController;
    
    public CreateLeadFromSAPresentation(ApexPages.StandardController standardController){
        this.standardController = standardController;
    }
    
    
    public PageReference createLead() {
        SA_Presentations__c sAP= (SA_Presentations__c) standardController.getRecord();
        
      
        if(sAP.Last_Name__c==null ||sAP.Company__c==null  ){
        
         Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Kindly ensure that Campany and Last name fields are filled.'));
          return null;
        
        }
       
        else{
            
            
            //create new Lead
            Lead ld=new Lead(
               Company=sAP.Company__c,
          	    Status='Open',
         	    LastName=sAP.Last_Name__c, 
                FirstName=sAp.First_name__c,
                Phone=sAp.Phone__c,
                Sub_Area_Lookup__c=sAP.Sub_Area__c,
                LeadSource=sAp.Lead_Source__c,
                Referrer__c=sAp.Name_of_Referrer__c,
                Primary_Salesperson__c=sAP.SA_Name__c,
                First_Contact_Date__c=sAP.First_Contact_Date__c,
                Presented_to__c=sAP.Presented_to__c
                
                               
            );
            
            insert ld;          
           
       
            return new PageReference('/' + sAP.Id);
        }
    }

}