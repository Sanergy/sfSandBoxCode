//GET and POST a Case for a specific Case Timeline
@RestResource(urlMapping='/api/casecategory/*/casetimeline/*/case/*')
global with sharing class REST_Case {
    
    @HttpGet
    global static List<AndroidCases> getCaseById() {
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        List<AndroidCases> reportedCasesList = new List<AndroidCases>();
        
        //Get GUIDs
        String caseCategoryId = request.requestURI.substringBetween('/api/casecategory/','/casetimeline/');
        String caseTimeLineId = request.requestURI.substringBetween('/casetimeline/','/case/');        
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        //Get reported Case
        List<Case> results = [SELECT Id, CaseNumber, Case_Type__c,Toilet__c,Case_Opportunity__c,
                              Case_Root_Cause__c,Description,Comments__c,Due_Date__c,
                              Case_Category__c,Location__c,Status,Priority,Subject,
                              Case_Type__r.USSD_Case_Categories__c,Location__r.Name,
                              Case_Type__r.Name,Toilet__r.Name,Case_Opportunity__r.Name,
                              Case_Type__r.USSD_Case_Categories__r.Name,Date_Reportedd__c,
                              Date_First_Reported__c,Photo__c,Photo_URL__c,Case_Reported_By__c
                              FROM Case
                              WHERE Case_Type__r.USSD_Case_Categories__c =: caseCategoryId
                              AND Case_Type__c =: caseTimeLineId
                              AND Id =: caseId
                              ORDER BY CaseNumber ASC];
        
        if(results != null && results.size()> 0){
            
            for(Case reportedCase : results){
                
                //Cases
                AndroidCases myCase = new AndroidCases();                
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
                myCase.reportedBy = reportedCase.Case_Reported_By__c;
                reportedCasesList.add(myCase);
            }
        }        
                
        System.debug('GET REPORTED CASE: = ' + reportedCasesList);                
        
        return reportedCasesList;
    }
    
    @HttpPost
    global static List<Case> createCases(List<AndroidCases> incomingData) {
        
        //Set directory for saving images
        String imageDirectory = 'http://csapp.saner.gy/casephotos_test/';
        
        //Reported Cases
        List<Case> reportedCasesList = new List<Case>();        
        
        //Get Opportunity Maintenance Case RecordType
        RecordType opportunityMaintenanceCaseRecordType = [SELECT Id,Name 
                                                           FROM RecordType 
                                                           WHERE Name ='Maintenance Cases' 
                                                           LIMIT 1];
        
        for(AndroidCases c: incomingData){
            
            //Get Toilet
            Toilet__c toilet = [SELECT Id, Name, Opportunity__c,Opportunity__r.Name,
                                Opportunity__r.AccountId
                                FROM Toilet__c
                                WHERE Id =: c.toiletId];
            
            //Get Case Timeline
            Case_Timeliness__c caseTimeline = [SELECT Id, Name, USSD_TEXT__c
                                               FROM Case_Timeliness__c
                                               WHERE Id =: c.caseTimelineId];                     
            
            //Create Maintenance Case Opportunity
            Opportunity maintenanceOpportunity = new Opportunity();
            maintenanceOpportunity.RecordTypeId = opportunityMaintenanceCaseRecordType.Id;
            maintenanceOpportunity.Name = 'Maintenance Opportunity';
            maintenanceOpportunity.AccountId = toilet.Opportunity__r.AccountId;
            maintenanceOpportunity.CurrencyIsoCode = 'KES';
            maintenanceOpportunity.CloseDate = date.today();
            maintenanceOpportunity.StageName = 'Open';
            INSERT maintenanceOpportunity;
            
            //Create a Case
            Case myCase = new Case();
            myCase.Case_Type__c = c.caseTimelineId;
            myCase.Toilet__c = c.toiletId;
            myCase.Case_Opportunity__c = maintenanceOpportunity.Id;
            myCase.Date_First_Reported__c = c.dateReportedOnAndroid;
            myCase.Case_Root_Cause__c = 'Other';
            myCase.Description = 'Logged from Android';
            myCase.Comments__c = c.comments;
            myCase.Status = 'Open';
            myCase.Case_Category__c = 'Maintenance';
            myCase.Priority = 'Medium';
            myCase.Subject = caseTimeline.USSD_TEXT__c;
            myCase.Photo_URL__c = imageDirectory + c.image;
            myCase.Case_Reported_By__c = c.reportedBy;          
            //myCase.Location__c = locationId;            
            //myCase.Due_Date__c = datetime.now();
            //myCase.caseNumber = reportedCase.CaseNumber;
            //INSERT myCase;
            
            //Append the reported Case to the list
            reportedCasesList.add(myCase);
            
        }// End for(AndroidCases c: incomingData)
        
        //Insert Cases
        INSERT reportedCasesList;
        
        for(Case savedCase : reportedCasesList){
            for(AndroidCases c : incomingData){
                if(c.caseOpportunityId == savedCase.Case_Opportunity__c){
                    c.guid = savedCase.Id; 
                    c.caseNumber = savedCase.CaseNumber;
                }//End if(c.caseOpportunityId == savedCase.Case_Opportunity__c)
            }//End for(AndroidCases c : incomingData)
        }// End for(Case savedCase : reportedCasesList)
                        
        System.debug('CREATED CASE: = ' + reportedCasesList);                
        
        return reportedCasesList;
    }
    
    global class AndroidCases {        
        public String guid;
        public String caseNumber;
        public String caseTimelineId;
        public String caseTimelineName;
        public String toiletId;
        public String toiletName;
        public String caseOpportunityId;
        public String caseOpportunityName;
        public String caseRootCause;
        public String image;
        public String description;
        public String comments;
        public String status;
        public String caseCategory;
        public String locationId;
        public String locationName;
        public String priority;        
        public String reportedBy;
        public Datetime dateCreatedOnSalesforce;
        public Date dateReportedOnAndroid;
        public Datetime dueDate;
        public String subject;
        public String salesforceResponse;
    }     
    
}