//Get all Case Timelines for a specific Case Category
@RestResource(urlMapping='/api/casecategory/*/casetimelines')
global with sharing class REST_CaseTimelines {
    
    @HttpGet
    global static List<CaseTimelines> getCaseTimeliness() {
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        //String caseCategoryId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);        
        String caseCategoryId = request.requestURI.substringBetween('/api/casecategory/','/casetimelines');
        
        List<CaseTimelines> caseTimelines = new List<CaseTimelines>();
        
        //Get Case Timeliness
        List<Case_Timeliness__c> results =  [SELECT Id, Name, USSD_TEXT__c,USSD_Category_Text__c,Active_On_USSD__c,
                                             Case_Category__c,Agreed_Upon_Time_For_Resolution__c,Priority_Level__c,
                                             USSD_Case_Categories__c,USSD_Case_Categories__r.USSD_Row_Number__c
                                             FROM Case_Timeliness__c
                                             WHERE USSD_Case_Categories__c =: caseCategoryId
                                             ORDER BY USSD_Case_Categories__r.USSD_Row_Number__c ASC];        
        
        if(results != null && results.size()> 0){
            
            for(Case_Timeliness__c timeline : results){
                
                //Case Timeliness
                CaseTimelines caseTimeline = new CaseTimelines();                
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
        
        System.debug('CASE TIMELINES: = ' + caseTimelines);                
        
        return caseTimelines;
    }
    
    global class CaseTimelines {        
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