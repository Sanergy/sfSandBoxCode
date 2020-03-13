@isTest(seeAllData=true)
public class REST_Cards_Test {

    static testMethod void  saveCardsTest(){
       
          //Get Open toilet
          List<Toilet__c> toilet = [SELECT ID FROM Toilet__c WHERE Operational_Status__c = 'Open' LIMIT 1];
          
         //Create Card Type
         Card_Type__c cardType = new Card_Type__c();         
         cardType.Card_Name__c = 'green';
         cardType.Description__c = 'Collected';
         cardType.name = 'green';         
         insert cardType;
         
         
         REST_Cards.Card card = new REST_Cards.Card(); 
         card.name = 'red';
         card.description = 'desc';
         card.toiletGuid = toilet.get(0).id;
         card.serialNumber = 'xyxyxyxyx';
         card.cardTypeGuid = cardType.id;
         
         List<REST_Cards.Card> cardsList = new List<REST_Cards.Card>();
         cardsList.add(card);
        
        String jsonResponse = JSON.serialize(cardsList);
        
        
        
        REST_Cards.saveCards(jsonResponse);
        REST_Cards.getCards();
        
       
   }
}