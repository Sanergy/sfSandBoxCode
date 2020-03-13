@isTest(seeAllData = true)
public class REST_SweetSanergyTest {
    static testMethod void testSweetSanergy() {
        /*//Commented as we are no longer using this application - 2020-02-13
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs86.force.com/services/apexrest/read_sweetSense';
        RestContext.request.requestURI = 'https://ffa-sanergy.cs86.force.com/services/apexrest/write_sweetSense';
                  
        System.RestContext.response = new RestResponse();
        
        List<REST_readSweetSense.dataHolder> recs = REST_readSweetSense.getAll();      
       
       //Read REST_readSweetSense       
        //to add code coverage, call the getters of the util class
        REST_readSweetSense.dataHolder rrecs=new REST_readSweetSense.dataHolder();
            rrecs.getName();
            rrecs.getCardID();
            rrecs.getToiletID();
            rrecs.getCardType();
			rrecs.getTriggerType();
			rrecs.getFillLevel();
			rrecs.getTimestamp();
			rrecs.getid();
        	rrecs.getComments();
        	rrecs.getStatus();
        
         System.RestContext.response = new RestResponse();
           
 			//Write to REST_writeSweetSense          
            REST_writeSweetSense.clientRequest  req=new  REST_writeSweetSense.clientRequest();
            req.cardId='W2C001';
            req.toiletId='a08D0000015b3Pc';
            req.cardType=12;
            req.triggerType=32;
            req.fillLevel=21;
            req.timestamp=45;
            req.id=2;
        	req.status='Open';
        	req.comments='comment';
                       
            String jsonString=JSON.serialize(req);
           // String jsonString='[{"CARDID":"98re3","TOILETID":"rg234f","CARDTYPE":12,"TRIGGERTYPE":32,"FILLLEVEL":21,"TIMESTAMP":45,"ID":2}]';
           // REST_writeSweetSense.Message cer = REST_writeSweetSense.sweetData(jsonString);
           
        REST_writeSweetSense wss=new REST_writeSweetSense();
        REST_writeSweetSense.Message cer=REST_writeSweetSense.sweetData(jsonString);
		*/	
    }

}