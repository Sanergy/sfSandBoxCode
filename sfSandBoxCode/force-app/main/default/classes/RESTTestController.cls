@RestResource(urlMapping='/test/*')
global with sharing class RESTTestController {

@HttpPost   
  global static String createNewTest(String Name) {
         EmailSender email=new EmailSender(new String[] {'bryndox@gmail.com'},'test','Yeeessss!!!!');
         email.sendMessage();  
          
     return 'worked';
  }
}