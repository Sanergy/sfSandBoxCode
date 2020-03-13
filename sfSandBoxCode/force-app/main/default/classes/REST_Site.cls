@RestResource(urlMapping='/sites')
global with sharing class REST_Site {
    
    @HttpPost
    global static List<Site> getAllSites() {
        
        List<Site> sites = new List<Site>();
        
        List<rstk__sysite__c> rstk_sites = [SELECT ID, Name, rstk__sysite_div__c, rstk__sysite_descr__c
                                               FROM rstk__sysite__c];
        
        for(rstk__sysite__c rstk_site : rstk_sites){
            
            Site site = new Site();
            
            site.setName(rstk_site.Name);
            site.setDescription(rstk_site.rstk__sysite_descr__c);
            site.setGuid(rstk_site.ID);
            site.setDivision(rstk_site.rstk__sysite_div__c);
            
            sites.add(site);
        }
        
        return sites;
    }
    
    global class Site {
    
        String division;
        String name;
        String description;
        String guid;
    
        public String getDivision() {
            return division;
        }
    
        public void setDivision(String division) {
            this.division = division;
        }
    
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    
        public String getDescription() {
            return description;
        }
    
        public void setDescription(String description) {
            this.description = description;
        }
    
        public String getGuid() {
            return guid;
        }
    
        public void setGuid(String guid) {
            this.guid = guid;
        }
    }
}