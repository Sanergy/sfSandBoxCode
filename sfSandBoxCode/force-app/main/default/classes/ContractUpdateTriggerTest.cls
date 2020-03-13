@isTest(seeAllData = true)
public class ContractUpdateTriggerTest {
    static testMethod void testCreateContract(){
        
        // Get Sanergy Vendor RecordType Id
        List<RecordType> rt=[SELECT Id,Name FROM RecordType WHERE Name='Sanergy Vendor'];
        
        //Create Account       
        Account accounts = new Account();
        accounts.RecordTypeId = rt.get(0).Id;
        accounts.Name = 'Unilever Kenya';
        accounts.CurrencyIsoCode = 'KES';                        
        INSERT accounts;
        
        // Create Contract
        Contract contract = new Contract();
        contract.AccountId = accounts.Id;
        contract.Type_of_Contract__c = 'Master Service Agreement';
        contract.Status = 'Draft';
        contract.StartDate = date.today();
        contract.ContractTerm = 5;
		contract.Primary_Contract__c=true;        
        contract.Payment_Terms__c = '30 Days';
        contract.Contract_Summary__c = 'summary of contract';
        INSERT contract;
        
    }
    
    static testMethod void testUpdateContract(){
        
        // Get Sanergy Vendor RecordType Id
        List<RecordType> rt=[SELECT Id,Name FROM RecordType WHERE Name='Sanergy Vendor'];
        
        //Create Account       
        Account accounts = new Account();
        accounts.RecordTypeId = rt.get(0).Id;
        accounts.Name = 'Bamburi Cement';
        accounts.CurrencyIsoCode = 'KES';                        
        INSERT accounts;
        
        // Create Contract1
        Contract contract1 = new Contract();
        contract1.AccountId = accounts.Id;
        contract1.Type_of_Contract__c = 'Master Service Agreement';
        contract1.Status = 'Draft';
        contract1.StartDate = date.today();
        contract1.ContractTerm = 6;        
        contract1.Payment_Terms__c = '7 Days';
        contract1.Contract_Summary__c = 'new summary of contract';
        INSERT contract1;
        
        // Create Contract2
        Contract contract2 = new Contract();
        contract2.AccountId = accounts.Id;
        contract2.Type_of_Contract__c = 'Credit Term';
        contract2.Status = 'Draft';
        contract2.StartDate = date.today();
        contract2.ContractTerm = 8;        
        contract2.Payment_Terms__c = '15 Days';
        contract2.Contract_Summary__c = 'new summary of contract';
        INSERT contract2; 
        
        //Update contract1
        contract1.Current_Version_Of_Contract__c = contract2.Id;
        UPDATE contract1;
        
    }    
}