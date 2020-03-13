//Get all Open Cases for a specific Toilet
@RestResource(urlMapping='/api/toilet/*/cases')
global with sharing class REST_Toilet_Cases {
    
    @HttpGet
    global static List<REST_Case.AndroidCases> getReportedCasesByToiletId() {
    //global static List<SalesforceResponse> getReportedCasesByToiletId() {
        
        RestRequest request = RestContext.request;
        //RestResponse response = RestContext.response;
        //SalesforceResponse response = new SalesforceResponse();
        
        List<REST_Case.AndroidCases> reportedCasesList = new List<REST_Case.AndroidCases>();
        //List<SalesforceResponse> salesforceResponseList = new List<SalesforceResponse>();
            
        //Get GUIDs
        String toiletId = request.requestURI.substringBetween('/api/toilet/','/cases');
        
        //Get reported Case
        List<Case> results = [SELECT Id, CaseNumber, Case_Type__c,Toilet__c,Case_Opportunity__c,
                              Case_Root_Cause__c,Description,Comments__c,Due_Date__c,
                              Case_Category__c,Location__c,Status,Priority,Subject,
                              Case_Type__r.USSD_Case_Categories__c,Location__r.Name,
                              Case_Type__r.Name,Toilet__r.Name,Case_Opportunity__r.Name,
                              Case_Type__r.USSD_Case_Categories__r.Name,Date_Reportedd__c,
                              Date_First_Reported__c,Photo__c,Photo_2__c,Photo_URL__c,
                              Photo_URL_2__c,Case_Reported_By__c
                              FROM Case
                              WHERE Toilet__c =: toiletId
                              AND Status != 'Closed'
                              ORDER BY CaseNumber DESC];
        
        if(results != null && results.size()> 0){
            
            for(Case reportedCase : results){
                            
                //Cases
                REST_Case.AndroidCases myCase = new REST_Case.AndroidCases();                
                myCase.guid = reportedCase.Id;
                myCase.caseNumber = reportedCase.CaseNumber;
                myCase.caseTimelineId = reportedCase.Case_Type__c;
                myCase.caseTimelineName = reportedCase.Case_Type__r.Name;
                myCase.toiletId = reportedCase.Toilet__c;
                myCase.toiletName = reportedCase.Toilet__r.Name;
                myCase.caseOpportunityId = reportedCase.Case_Opportunity__c;
                myCase.caseOpportunityName = reportedCase.Case_Opportunity__r.Name;
                myCase.caseRootCause = reportedCase.Case_Root_Cause__c;
                myCase.description = reportedCase.Description;
                myCase.comments = reportedCase.Comments__c;
                myCase.status = reportedCase.Status;
                myCase.caseCategory = reportedCase.Case_Category__c;
                myCase.locationId = reportedCase.Location__c;
                myCase.locationName = reportedCase.Location__r.Name;
                myCase.priority = reportedCase.Priority;
                myCase.dateCreatedOnSalesforce = reportedCase.Date_Reportedd__c;
                myCase.dateReportedOnAndroid = reportedCase.Date_First_Reported__c;
                myCase.dueDate = reportedCase.Due_Date__c;
                myCase.subject = reportedCase.Subject;
                myCase.image = reportedCase.Photo_URL__c;
                myCase.image2 = reportedCase.Photo_URL_2__c;
                myCase.reportedBy = reportedCase.Case_Reported_By__c;
                
                reportedCasesList.add(myCase);

            }
        }   
                
        System.debug('GET REPORTED CASE : = ' + reportedCasesList);
        
        return reportedCasesList;
    }

    /**global class SalesforceResponse{
       public String salesforceResponse;
       public List<REST_Case.AndroidCases> reportedCasesList;
    }*/    

}