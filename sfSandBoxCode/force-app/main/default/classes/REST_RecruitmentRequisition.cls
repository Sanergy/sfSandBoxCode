@RestResource(urlMapping='/recruitment_requisition')
global with sharing class REST_RecruitmentRequisition {

    @HttpGet
    global static List<Requisition> getRequisitions() {
    
        List<Requisition> requisitions = new List<Requisition>();
        
        List<Recruitment_Requisition__c> sfRequisitions = [SELECT Id, Name FROM Recruitment_Requisition__c];
        
        if(sfRequisitions != null && sfRequisitions.size()> 0){
            
            for(Recruitment_Requisition__c sfRequisition : sfRequisitions){
            
                Requisition req = new Requisition();                
                req.guid = sfRequisition.Id;
                req.name = sfRequisition.Name;
            
                requisitions.add(req);
            }
        }
        
        return requisitions;
    }
    
    @HttpPost
    global static Response getRequisition(String jobId) {
        Response response = new Response();
        
        try{
            
            if(jobId != null && jobId.length() > 0){
                
                List<Recruitment_Requisition__c> sfRequisitions = [SELECT Id, Name, Employee_Role__c, Requesting_Department__c,
                                                                   Employee_Role__r.Name, Requesting_Department__r.Name
                                                                   FROM Recruitment_Requisition__c
                                                                   WHERE Id = :jobId
                                                                  ];

                List<Requisition> requisitions = new List<Requisition>();
                
                if(sfRequisitions != null && sfRequisitions.size()> 0){
                    
                    for(Recruitment_Requisition__c sfRequisition : sfRequisitions){
                        
                        Requisition req = new Requisition();                
                        req.guid = sfRequisition.Id;
                        req.name = sfRequisition.Name;
                        req.role = sfRequisition.Employee_Role__r.Name;
                        req.department = sfRequisition.Requesting_Department__r.Name;
                        
                        requisitions.add(req);
                    }
                }
                response.success = true;
            	response.data = requisitions;
            }
        } catch(Exception e){
            response.success = false;
            response.message = e.getMessage();
        }
        return response;
    }
        
    global class Response {
       public boolean success;
       public String message;
       public List<Requisition> data;
    }
    
    global class Requisition {
        public long id;        
        public String guid;
        public String name;
        public String role;
        public String department;
    }
}