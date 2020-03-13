@RestResource(urlMapping='/card_type')
global with sharing class REST_CardType {
    
    @HttpGet
    global static List<CardType> getCardTypes() {
    
        List<CardType> cardTypes = new List<CardType>();
        
        List<Card_Type__c> types = [SELECT Id, Name, Card_Name__c, Description__c FROM Card_Type__c];
        
        if(types != null && types.size()> 0){
            for(Card_Type__c type : types){
            
                CardType ct = new CardType();
                
                ct.guid = type.Id;
                ct.name = type.Card_Name__c;
                ct.description = type.Description__c;
            
                cardTypes.add(ct);
            }
        }
        
        return cardTypes;
    }
    
    global class CardType {
        
        public String guid;
        public String name;
        public String description;
        
    }
}