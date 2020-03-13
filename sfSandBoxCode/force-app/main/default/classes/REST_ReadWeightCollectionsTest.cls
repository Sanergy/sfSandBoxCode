@isTest(SeeAllData=true)
public class REST_ReadWeightCollectionsTest{
    static testMethod void collectionDataTest() {
        List<Toilet__c> toiletList = [SELECT id,name,Collection_Route__c 
                                       FROM Toilet__c
                                       WHERE Location__r.Add_on_Project__c= true
                                       AND Operational_Status__c = 'Open'
                                       AND Collection_Route__c != null
                                       LIMIT 1];
                                       
        if(toiletList.size() > 0){
            
             String[] data = new String[] {toiletList.get(0).Collection_Route__c};
             String jsonString = System.JSON.serialize(data);
             
             if(data != null){
                 REST_ReadWeightCollections.collectionData(jsonString );
             }
             
             //try with unserializable string to catch error
                REST_ReadWeightCollections.collectionData(null);
        
        }
    }
}