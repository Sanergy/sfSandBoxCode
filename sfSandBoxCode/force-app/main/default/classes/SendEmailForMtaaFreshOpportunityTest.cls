@isTest(seeAllData=true)
public class SendEmailForMtaaFreshOpportunityTest {
    @isTest static void testSendEmailForMtaaFreshOpportunity(){
        
        List<RecordType> record = [SELECT Id,Name 
                                   FROM RecordType 
                                   WHERE Name ='Mtaa Fresh Sales'];
        
        System.debug('RECORD TYPE: ' + record);
        
        //Create Account       
        Account accounts = new Account();
        accounts.Name = 'Nicki Minaj';
        accounts.CurrencyIsoCode = 'KES';
        accounts.RecordTypeId = record.get(1).Id;
        INSERT accounts;
        
        //Create Opportunity
        Opportunity opportunity = new Opportunity();
        opportunity.RecordTypeId = record.get(0).Id;
        opportunity.Name = 'Nicki Minaj';
        opportunity.AccountId = accounts.Id;
        opportunity.StageName = 'Sale Open';
        opportunity.CloseDate = date.today() + 7;
        INSERT opportunity;
        
        opportunity.StageName = 'Confirmed';
        UPDATE opportunity;
    }

}