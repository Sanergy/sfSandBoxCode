@isTest(seeAllData = true)
public class REST_Collections_Android_Users_API_Test {
    static testMethod void testCollectionsAndAndroidUsersAPI() {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/read_collections';
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/write_collections';
                  
        System.RestContext.response = new RestResponse();
        
        List<REST_ReadCollections.dataHolder> recs = REST_ReadCollections.getAll();      
       
       //Read REST_readSweetSense        
        REST_ReadCollections.dataHolder rrecs=new REST_ReadCollections.dataHolder();
        
        //to add code coverage, call the getters of the util class
            rrecs.getId();
            rrecs.getName();
            rrecs.getToilet();
            rrecs.getCollection();
            rrecs.getCollectionDate();
            rrecs.getSolidWasteWeight();
            rrecs.getUrineWeight();
            rrecs.getScheduled();
        	        
         System.RestContext.response = new RestResponse();
           
            //Write to REST_WriteCollections          
            REST_WriteCollections.fieldData  req=new  REST_WriteCollections.fieldData();
            REST_WriteCollections.fieldData  exc=new  REST_WriteCollections.fieldData();
             req.collection='Collect';
             req.toilet='a08D0000015b3Pc';
             req.collectionDate=date.today();
             req.solidWeight=4;
             req.urineWeight=2;
        	 exc.toilet='a08D0000015b3Pcx';
        
            String s;           
            String jsonString=JSON.serialize(req);
        	String jString=JSON.serialize(s);
        	String jsString=JSON.serialize(exc);
                      
        REST_WriteCollections wss=new REST_WriteCollections();
        REST_WriteCollections.Response cer=REST_WriteCollections.collectionData(jsonString);
        REST_WriteCollections.Response resp=REST_WriteCollections.collectionData(jString);
        REST_WriteCollections.Response res=REST_WriteCollections.collectionData(jsString);
            
    }

}