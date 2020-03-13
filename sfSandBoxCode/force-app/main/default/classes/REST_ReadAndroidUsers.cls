@RestResource(urlMapping='/read_adnroid_users')
global with sharing class REST_ReadAndroidUsers {
    @HttpGet
    global static LIST<dataHolder> getAll(){
        LIST<dataHolder> dh=new LIST<dataHolder>();
        LIST<Android_User__c> android=[SELECT Id,Name,Email__c,Token__c FROM Android_User__c];
        for(Android_User__c newAndroid:android){
            @TestVisible dataHolder holder=new dataHolder();
            holder.setId(newAndroid.Id);
            holder.setName(newAndroid.Name);
            holder.setEmail(newAndroid.Email__c);
            holder.setToken(newAndroid.Token__c);
            
            dh.add(holder);
        }return dh;
    }
        //Utility class to help with serialization of json
        @TestVisible global class dataHolder{
            String id;
            String name;
            String email;
            String token;
            
            public dataHolder(){
                id='';
                name='';
                email='';
                token='';
            }
            @TestVisible public void setId(String id){this.id=id;}
            @TestVisible public void setName(String name){this.name=name;}
            @TestVisible public void setEmail(String email){this.email=email;}
            @TestVisible public void setToken(String token){this.token=token;}
            public  String getId(){return this.id=id;}
            public  String getName(){return this.name=name;}
            public  String getEmail(){return this.email=email;}
            public  String getToken(){return this.token=token;}
        }
}