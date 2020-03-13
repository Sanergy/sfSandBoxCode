@RestResource(urlMapping='/recruitment_candidate')
global with sharing class REST_RecruitmentCandidate {

    @HttpPost
    global static Response saveCandidate(String jsonRequest) {
        Response response;
        try{
            
            System.debug(jsonRequest);
            
            List<Candidate> candidates = (List<Candidate>) System.JSON.deserialize(jsonRequest, List<Candidate>.class);  
                   
            if(candidates != null && candidates.size() > 0){
                
                List<Candidate__c> applications = new List<Candidate__c>();
                
                for(Candidate candidate : candidates){
                
                    Candidate__c candidateToSave = new Candidate__c(
                        Recruitment_Requisition__c = candidate.guid,
                        First_Name__c = candidate.firstName,
                        Last_Name__c = candidate.lastName,
                        Email__c = candidate.email,
                        Phone_Number__c = candidate.phoneNumber,
                        Date_Available__c = candidate.dateAvailable,
                        Country__c = candidate.country,
                        Resume__c = candidate.resume
                    );
                    
                    applications.add(candidateToSave);
                }
                
                
                if(applications.size() > 0){
                    
                    insert applications;
                    
                     response = new Response();
                     response.success = true;
                }
            }
            
        }catch(Exception e){
             response = new Response();
             response.success = false;
             response.message = e.getMessage();
        }
        
        return response;
    }
    
    global class Response{
       public boolean success;
       public String message;
       public List<Candidate> data;
    }
    
    global class Candidate {
               
        public long id;        
        public String guid;
        public String firstName;
        public String lastName;
        public String email;
        public Date dateAvailable;
        public String country;
        public String resume;
        public String phoneNumber;
    }
}