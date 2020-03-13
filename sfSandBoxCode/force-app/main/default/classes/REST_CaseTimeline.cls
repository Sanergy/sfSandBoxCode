//Get a Case Timeline for a specific Case Category
@RestResource(urlMapping='/api/casecategory/*/casetimeline/*')
global with sharing class REST_CaseTimeline {
    
    @HttpGet
    global static List<CaseTimeline> getCaseTimelineById() {
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        List<CaseTimeline> caseTimelines = new List<CaseTimeline>();
        
        String caseCategoryId = request.requestURI.substringBetween('/api/casecategory/','/casetimeline/');        
        String caseTimeLineId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        //Get Case Timeliness
        List<Case_Timeliness__c> results =  [SELECT Id, Name, USSD_TEXT__c,USSD_Category_Text__c,Active_On_USSD__c,
                                             Case_Category__c,Agreed_Upon_Time_For_Resolution__c,Priority_Level__c,
                                             USSD_Case_Categories__c,USSD_Case_Categories__r.USSD_Row_Number__c
                                             FROM Case_Timeliness__c
                                             WHERE USSD_Case_Categories__c =: caseCategoryId
                                             AND Id =: caseTimeLineId
                                             ORDER BY USSD_Case_Categories__r.USSD_Row_Number__c ASC];
        
        if(results != null && results.size()> 0){
            
            for(Case_Timeliness__c timeline : results){
                
                //Case Timeliness
                CaseTimeline caseTimeline = new CaseTimeline();                
                caseTimeline.guid = timeline.Id;
                caseTimeline.caseTimelineName = timeline.Name;
                caseTimeline.shortenedCaseTimelineName = timeline.USSD_TEXT__c;
                caseTimeline.displayCaseTimelineNameOnAndroid = timeline.Active_On_USSD__c;
                caseTimeline.maximumDaysToResolveCase = timeline.Agreed_Upon_Time_For_Resolution__c;
                caseTimeline.priorityLevel = timeline.Priority_Level__c;
                caseTimeline.caseCategoryId = timeline.USSD_Case_Categories__c;
                caseTimeline.caseCategoryName = timeline.USSD_Category_Text__c;
                caseTimeline.caseCategoryRowNumber = timeline.USSD_Case_Categories__r.USSD_Row_Number__c;
                caseTimelines.add(caseTimeline);
            }
        }        
                        
        System.debug('CASE TIMELINE: = ' + caseTimelines);                
        
        return caseTimelines;
    }    
    
    global class CaseTimeline {        
        public String guid;
        public String caseTimelineName;
        public String shortenedCaseTimelineName;
        public Boolean displayCaseTimelineNameOnAndroid;        
        public Decimal maximumDaysToResolveCase;
        public String priorityLevel;        
        public String caseCategoryId;
        public String caseCategoryName;
        public Decimal caseCategoryRowNumber;
        
    }     
    
}