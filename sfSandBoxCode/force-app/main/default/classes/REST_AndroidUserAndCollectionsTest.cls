@isTest(seeAllData=true)
public class REST_AndroidUserAndCollectionsTest {
    static testMethod void testAndroidUsersAndCollections(){
        //make API request
        System.RestContext.request = new RestRequest();
        
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/write_android_users';
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/services/apexrest/read_adnroid_users';
                  
        System.RestContext.response = new RestResponse();
        
        //Read REST_readSweetSense
        List<REST_ReadAndroidUsers.dataHolder> recs = REST_ReadAndroidUsers.getAll(); 
              
        //to add code coverage, call the getters of the util class
        REST_ReadAndroidUsers.dataHolder rrecs=new REST_ReadAndroidUsers.dataHolder();
            
            rrecs.getId();
            rrecs.getName();
            rrecs.getEmail();
            rrecs.getToken();
        
             System.RestContext.response = new RestResponse();    
 			//Write to REST_WriteCollections          
            REST_WriteAndroidUsers.appData  adt = new  REST_WriteAndroidUsers.appData();
        
            adt.email='wewrwdsd';
        	adt.token='23se3wd23';        
            String s;           
            String jsonString=JSON.serialize(adt);
        	String jString=JSON.serialize(s);
                      
        REST_WriteAndroidUsers wss=new REST_WriteAndroidUsers();
        REST_WriteAndroidUsers.Response resp=REST_WriteAndroidUsers.resp(jsonString);
        REST_WriteAndroidUsers.Response res=REST_WriteAndroidUsers.resp(jString);
		
    }
}