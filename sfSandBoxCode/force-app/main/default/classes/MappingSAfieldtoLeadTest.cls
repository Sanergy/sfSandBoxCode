@isTest(seealldata=true)
public class MappingSAfieldtoLeadTest {
    static testMethod void testTrigger(){
        
        Lead l=new Lead();
        l.Company ='s';
        l.LastName ='Wambua';
        l.Presented_to__c ='Head Teacher';
   
        insert l;
        Lead l2=new Lead();
        l2.Company ='s';
        l2.LastName ='Wambua';
        l2.Presented_to__c ='Landlord';
        insert l2;
        
        Lead l3=new Lead();
        l3.Company ='s';
        l3.LastName ='Wambua';
        l3.Presented_to__c ='Commercial Renting Land';
        insert l3;
        
    
    }

}