@isTest(SeeAllData=true)
public class REST_WriteWeightCollectionsTest{
    static testMethod void weightDataTest() {
        List<Toilet__c> toiletList = [SELECT id,name,Collection_Route__c 
                                       FROM Toilet__c
                                       WHERE Location__r.Add_on_Project__c= true
                                       AND Operational_Status__c = 'Open'
                                       AND Collection_Route__c != null
                                       LIMIT 1];
                                       
        if(toiletList.size() > 0){
            List<REST_WriteWeightCollections.FieldData> listEx= new List<REST_WriteWeightCollections.FieldData>();
            
            REST_WriteWeightCollections.FieldData ex= new REST_WriteWeightCollections.FieldData();
            
            ex.scheduleDate = Date.today();
            ex.toiletId = toiletList.get(0).id;
            ex.toiletName = toiletList.get(0).name;
            ex.solidWeight = 10.0;
            ex.urineWeight = 12.0;
            ex.scheduleStatus = 'Collect';
            ex.route = toiletList.get(0).Collection_Route__c ;
            ex.completed = true;
            
            listEx.add(ex);
             
            String jsonString = System.JSON.serialize(listEx);
             
             if(jsonString != null){
                 REST_WriteWeightCollections.weightData(jsonString);
             }
             
             //try with unserializable string to catch error
                REST_WriteWeightCollections.weightData(null);
        
        }
    }
}