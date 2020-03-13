@RestResource(urlMapping='/gla_accounts')
global with sharing class REST_GlaAccounts {
    
    @HttpPost
    global static List<GlaAccount> getAllAccounts() {
    
        List<GlaAccount> accounts = new List<GlaAccount>();
        
        List<c2g__codaGeneralLedgerAccount__c> glAccounts = [SELECT Id, Name, sanergy_showinv__c FROM c2g__codaGeneralLedgerAccount__c];
        
        if(glAccounts != null && glAccounts.size() > 0){
        
            for(c2g__codaGeneralLedgerAccount__c glAccount : glAccounts){
                
                GlaAccount account = new GlaAccount();
                
                account.guid = glAccount.Id;
                account.name = glAccount.Name;
                account.isInventory = glAccount.sanergy_showinv__c;
                
                accounts.add(account);
            }
        }
        
        return accounts;
    }
    
    global class GlaAccount {
        
        public String guid;
        public String name;
        public boolean isInventory;
        
    }
}