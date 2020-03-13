@RestResource(urlMapping='/cards')
global with sharing class REST_Cards {
    
   @HttpGet
    global static List<Card> getCards() {
    
        List<Card> cards = new List<Card>();
        
        List<Card__c> sfCards = [SELECT Id, Name, Card_Type__c, Description__c, Serial_Number__c, Toilets__c FROM Card__c];
        
        if(sfCards != null && sfCards.size()> 0){
            
            for(Card__c sfCard : sfCards){
            
                Card cr = new Card();                
                cr.guid = sfCard.Id;
                cr.cardTypeGuid = sfCard.Card_Type__c;
                cr.name = sfCard.Name;
                cr.description = sfCard.Description__c;
                cr.toiletGuid = sfCard.Toilets__c;
                cr.serialNumber = sfCard.Serial_Number__c;
            
                cards.add(cr);
            }
        }
        
        return cards;
    }
    
    @HttpPost
    global static Response saveCards(String jsonRequest) {
        Response response;
        try{
            List<Card> cards = (List<Card>) System.JSON.deserialize(jsonRequest, List<Card>.class);  
                   
            if(cards != null && cards.size() > 0){            
                List<Card__c> cardsToSave = new List<Card__c>();
                
                for(Card card:cards){
                
                    Card__c cardToSave = new Card__c();
                    cardToSave.id = card.guid;
                    cardToSave.Card_Type__c= card.cardTypeGuid;
                    cardToSave.Description__c = card.description;
                    cardToSave.Serial_Number__c = card.serialNumber;
                    cardToSave.Toilets__c = card.toiletGuid;
                    
                    cardsToSave.add(cardToSave);
                }
                
                
                if(cardsToSave.size() > 0){
                    upsert cardsToSave;
                }
                
                for(Card__c savedCard : cardsToSave){
                    for(Card initCard : cards){
                        if(initCard.serialNumber == savedCard.Serial_Number__c){
                           initCard.guid = savedCard.Id; 
                        }
                    }
                }
            }
            
             response = new Response();
             response.success = true;
             response.data = cards;
        }catch(Exception e){
             response = new Response();
             response.success = false;
             response.message = e.getMessage();
             System.debug('Error: '+e);
        }
        
        return response;
    }
    
    global class Response{
       public boolean success;
       public String message;
       public List<Card> data;
    }
    
    global class Card {
        public long id;        
        public String guid;
        public String cardTypeGuid;
        public String name;
        public String description;
        public String toiletGuid;
        public String serialNumber;
    }
}