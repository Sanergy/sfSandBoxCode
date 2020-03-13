@isTest(SeeAllData=true)
public class Pull_Toilets_To_Account_Test {
    static testMethod void test_Pulling_Of_Toilets(){
       LIST<Toilet__c> openToilet=[SELECT Id,Test_Field__c,Operational_Status__c FROM Toilet__c 
                                WHERE  Operational_Status__c='Open' AND Test_Field__c=null LIMIT 10];
        
        if(openToilet.size()>0){
            //System.debug('TOILET OPEN');
            for(Toilet__c t:openToilet){
               t.Operational_Status__c='Closed';
                t.Closure_Type__c='Closed-By FLI';
                t.Reason_1__c = 'Dispute';
                t.Explanation_1__c='With neighbors';
            }
            update openToilet;
        }
        Toilet__c toilet=new Toilet__c();
        toilet.Name='KM-8.11';
        toilet.Opening_Date__c=date.today();
        toilet.Opportunity__c='006D000000euD2R';
        toilet.Location__c='a0hD00000091OH8';
        toilet.Operational_Status__c='Open';
        toilet.Current_Specific_Status__c='Open-New';
        toilet.Collection_Route__c='CLOSED';
        toilet.Toilet_Type__c='Demo';
        
        insert toilet;

    }

}