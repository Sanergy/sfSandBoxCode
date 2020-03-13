@RestResource(urlMapping='/card_type_reasons')
global with sharing class REST_CardTypeReasons {
    
    @HttpGet
    global static List<CardTypeReason> getCardReasons() {
    
        List<CardTypeReason> cardReasons = new List<CardTypeReason>();
        
        List<Card_Type_Reason__c> reasons = [SELECT Id, Name, Card_Type__c, Description__c FROM Card_Type_Reason__c];
        
        if(reasons != null && reasons.size()> 0){
            for(Card_Type_Reason__c reason : reasons){
            
                CardTypeReason cr = new CardTypeReason();
                
                cr.guid = reason.Id;
                cr.cardTypeGuid = reason.Card_Type__c;
                cr.name = reason.Name;
                cr.description = reason.Description__c;
            
                cardReasons.add(cr);
            }
        }
        
        return cardReasons;
    }
    
    global class CardTypeReason {
        
        public String guid;
        public String cardTypeGuid;
        public String name;
        public String description;
    }
}