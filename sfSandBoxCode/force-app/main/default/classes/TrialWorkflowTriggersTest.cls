@isTest
public class TrialWorkflowTriggersTest{
/*
This test class is made to test the triggers used within the Trial sales workflow.
_________________________________________________________________________________
|Object                | Triggger                                                 |
---------------------------------------------------------------------------------
|Trial                 | CreateTrialOppoortunity                                  |
|Trial Harvest         | CreateHarvestLookupToTrial                               |
|Trial Observation     | UdpateAccountOnTrialObservation                          |
|Treatment Blocks      | CreateControlBlock                                       |
---------------------------------------------------------------------------------
*/

    //test the creation of trial harvests
    public static testMethod void testTrialWorkflowTriggers() {
        
        //get RecordType
        List<RecordType> recType=[SELECT ID
                                  FROM RecordType  
                                  WHERE Name='Sanergy Agricultural Products Customers'];
                                  
        if(recType.size()>0){
        
         //insert account
         Account ac=new Account(
                          Name='test account',
                          CurrencyIsoCode='KES' ,
                          RecordTypeId=recType.get(0).id
         );
         insert ac;
         
        
         //insert trial
         Trial__c trial=new Trial__c(
             Account__c=ac.id,
             Trial_start_date__c=date.today(),
             Trial_end_date__c=date.today().addMonths(2),
             Trial_block_size__c='200',
             Trial_status__c='Pre-trial',
             Initial_trial_re_trial__c='Initial trial',
             Paid_Unpaid__c='Paid'
             
         );
         insert trial;
         
         //create Treatment block
         Treatment_Block__c tb=new Treatment_Block__c(
             Trial__c=trial.id,
             Crops_trialing_on__c='Test Crop',
             Variety__c='Variety',
             Type__c='Treatment Block',
             Block__c='Text Number',
             Block_size__c=200,
             Evergrow_Rate__c=200
         );
         
         insert tb;
         
         
         //create Trial Harvest
         Trial_Harvest__c th=new Trial_Harvest__c(
             Treatment_Block__c=tb.id,
             Date_of_Visit__c=date.today(),
             Harvest_date__c=date.today(),
             Yield__c=200
         );
         
         insert th;
         
         //create observation record
         Trial_Observation__c to=new Trial_Observation__c(
             Trial__c=trial.id,
             Observation_date__c=date.today(),
             Observations__c='Sample Observations'
         );
         
         insert to;
         
        }
        else{
            System.debug('Trial Not Created');
        
        }
       
    }
}