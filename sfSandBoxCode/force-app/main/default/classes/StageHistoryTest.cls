@isTest(seeAllData=true)
public class StageHistoryTest {
   static testMethod void HistoryTest(){
       
        LIST<Opportunity> op=[SELECT StageName FROM Opportunity 
                              WHERE StageName=:'Launched' LIMIT 1]; 
        for(Opportunity o:op){
            o.StageName='Pending Install Start';
        }
        update op;
        for(Opportunity o:op){
            o.StageName='Launched';
        }
        update op;
        
         //get application management recordtype id
        List<RecordType> rec=[SELECT id FROM RecordType WHERE Name='Toilet Sale - Application Management' ];
        
        //get one sub area
        List<Sub_Area__c> subArea=[SELECT id FROM Sub_Area__c LIMIT 1];
        
        //Get one contact
        List<Contact> c=[SELECT ID FROM Contact LIMIT 1];
        
        //Get one account
         List <Account> ac=[SELECT ID FROM  Account LIMIT 1];
        
        //create and insert an opportunity
        Opportunity p=new Opportunity();
        p.RecordTypeId=rec.get(0).id;
        p.Name='x';
        p.Sub_Area_Lookup__c=subArea.get(0).id;
        p.CloseDate=date.today();
        p.StageName='Pending Credit Approval';
        p.AccountId=ac.get(0).ID;
        p.Primary_Salesperson__c=c.get(0).ID;
        
        insert p;
    }

}