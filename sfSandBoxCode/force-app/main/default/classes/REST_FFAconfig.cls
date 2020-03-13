@RestResource(urlMapping='/ffa_config')
global with sharing class REST_FFAconfig{
    
    @HttpPost
    global static List<FFAConfig> getAllRecords() {
    
        List<FFAConfig> records= new List<FFAConfig>();
        
        List<FFA_Config_Object__c> ffaConfig= [SELECT Id, Name, Type__c,lookup_ID__c,Teamlead__c, Teamlead__r.email, isActive__c FROM FFA_Config_Object__c];
        
        if(ffaConfig!= null && ffaConfig.size() > 0){
        
            for(FFA_Config_Object__c ffaConfigRecord: ffaConfig){
                
                FFAConfig config= new FFAConfig ();
                
                config.guid = ffaConfigRecord.Id;
                config.name = ffaConfigRecord.Name;
                config.type = ffaConfigRecord.Type__c;
                config.teamLead = ffaConfigRecord.Teamlead__c;
                config.teamLeadEmail = ffaConfigRecord.Teamlead__r.email;
                config.lookupId = ffaConfigRecord.lookup_ID__c;
                config.isActive= ffaConfigRecord.isActive__c;

                
                records.add(config);
            }
        }
        
        return records;
    }
    
    global class FFAConfig{
        
        public String guid;
        public String name;
        public String type;
        public String lookupId;
        public String teamLead;
        public String teamLeadEmail;
        public boolean isActive;     
    }
}