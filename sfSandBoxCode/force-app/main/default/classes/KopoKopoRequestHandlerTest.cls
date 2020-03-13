/*****************************************************************
Developer - Dreamwares, India
Discription - test class to check REST API request handler class.

******************************************************************/

@isTest(seeAllData = true)
public class KopoKopoRequestHandlerTest
{
    /***************************************************
    Method Name - testPresentRecord
    Parameters  - none
    Return      - none
    Description - Test KopoKopo site API for present 
                  Account record
    ****************************************************/
    
    static testMethod void testPresentRecord() 
    {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/kopokopo/services/apexrest/KopoKopoService';
        
        //set parameters of request
        RestContext.request.addParameter('service_name','M-PESA');
        RestContext.request.addParameter('business_number','888555');
        RestContext.request.addParameter('transaction_reference','DE45GK45');
        RestContext.request.addParameter('internal_transaction_id','3222');
        RestContext.request.addParameter('transaction_timestamp','2016-11-03T13:57:00Z');
        RestContext.request.addParameter('transaction_type','Paybill');
        RestContext.request.addParameter('account_number','445534');
        RestContext.request.addParameter('sender_phone','12345');
        RestContext.request.addParameter('first_name','Test2');
        RestContext.request.addParameter('middle_name','DEV2');
        RestContext.request.addParameter('last_name','DWS2');
        RestContext.request.addParameter('amount','100');
        RestContext.request.addParameter('currency','KES');
        RestContext.request.addParameter('signature','dfafwerewKkladaHOKJdafdf');
        
        System.RestContext.response = new RestResponse();
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            KopoKopoRequestHandler.makeCashEntry();
        }
        
        //verify if Cash entry record inserted or not
        List<c2g__codaCashEntry__c> lstCashEntry = new List<c2g__codaCashEntry__c>();
        lstCashEntry = [SELECT Id,Name FROM c2g__codaCashEntry__c LIMIT 10];
        System.assertEquals(false, lstCashEntry.isEmpty());
        
        List<c2g__codaCashEntryLineItem__c> lstCashEntryLineItem = new List<c2g__codaCashEntryLineItem__c>();
        lstCashEntryLineItem = [SELECT Id,Name FROM c2g__codaCashEntryLineItem__c LIMIT 10];
        System.assertEquals(false, lstCashEntryLineItem.isEmpty());
    }
    
    /***************************************************
    Method Name - testUnknownRecord
    Parameters  - none
    Return      - none
    Description - Test KopoKopo site API for unknown 
                  Account record
    ****************************************************/
    
    static testMethod void testUnknownRecord() 
    {
        //make API request
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = 'https://ffa-sanergy.cs14.force.com/kopokopo/services/apexrest/KopoKopoService';
        
        //set parameters of request
        RestContext.request.addParameter('service_name','M-PESA');
        RestContext.request.addParameter('business_number','888555');
        RestContext.request.addParameter('transaction_reference','DE45GK45');
        RestContext.request.addParameter('internal_transaction_id','3222');
        RestContext.request.addParameter('transaction_timestamp','2016-11-03T13:57:00Z');
        RestContext.request.addParameter('transaction_type','Paybill');
        RestContext.request.addParameter('account_number','445534');
        RestContext.request.addParameter('sender_phone','1234');
        RestContext.request.addParameter('first_name','Test2');
        RestContext.request.addParameter('middle_name','DEV2');
        RestContext.request.addParameter('last_name','DWS2');
        RestContext.request.addParameter('amount','100');
        RestContext.request.addParameter('currency','KES');
        RestContext.request.addParameter('signature','dfafwerewKkladaHOKJdafdf');
        
        System.RestContext.response = new RestResponse();
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            KopoKopoRequestHandler.makeCashEntry();
        }
        
        //verify if Cash entry record inserted or not
        List<c2g__codaCashEntry__c> lstCashEntry = new List<c2g__codaCashEntry__c>();
        lstCashEntry = [SELECT Id,Name FROM c2g__codaCashEntry__c LIMIT 10];
        System.assertEquals(false, lstCashEntry.isEmpty());
        
        List<c2g__codaCashEntryLineItem__c> lstCashEntryLineItem = new List<c2g__codaCashEntryLineItem__c>();
        lstCashEntryLineItem = [SELECT Id,Name FROM c2g__codaCashEntryLineItem__c LIMIT 10];
        System.assertEquals(false, lstCashEntryLineItem.isEmpty());
    }
}