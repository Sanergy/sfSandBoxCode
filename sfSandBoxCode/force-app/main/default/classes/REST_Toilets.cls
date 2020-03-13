@RestResource(urlMapping='/toilets')
global with sharing class REST_Toilets{
    
   @HttpGet
    global static List<Toilet> getToilets() {
    
        List<Toilet> toilets = new List<Toilet>();
        
        List<Toilet__c> sfToilets = [SELECT Id, Name, Location__c, Location__r.Name,
                                     Location__r.GPS_Latitude__c, Location__r.GPS_Longitude__c,Operational_Status__c
                                     FROM Toilet__c];
        
        if(sfToilets != null && sfToilets.size()> 0){
            
            for(Toilet__c sfToilet : sfToilets){
            
                Toilet tl = new Toilet();
                
                tl.guid = sfToilet.Id;
                tl.toiletName = sfToilet.Name;
                tl.locationId = sfToilet.Location__c;
                tl.locationName = sfToilet.Location__r.Name;
                tl.latitude = sfToilet.Location__r.GPS_Latitude__c;
                tl.longitude = sfToilet.Location__r.GPS_Longitude__c;
                tl.operationalStatus = sfToilet.Operational_Status__c;
            
                toilets.add(tl);
            }
        }
        
        return toilets;
    }
    
    global class Toilet {        
        public String guid;
        public String toiletName;
        public String locationId;
        public String locationName;
        public Decimal latitude;
        public Decimal longitude;
        public String operationalStatus;
    }
}