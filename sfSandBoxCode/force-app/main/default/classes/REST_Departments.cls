@RestResource(urlMapping='/departments')
global with sharing class REST_Departments {

    @HttpPost
    global static List<Department> getAllDepartments() {
    
        List<Department> departments = new List<Department>();
        
        List<Sanergy_Department__c> sanDepts = [SELECT Id, Name, RecordTypeId, Team_Lead__c FROM Sanergy_Department__c];
        
        if(sanDepts != null && sanDepts.size()> 0){
            for(Sanergy_Department__c sanDept : sanDepts){
            
                Department department = new Department();
                
                department.setGuid(sanDept.Id);
                department.setDivisionId(sanDept.RecordTypeId);
                department.setName(sanDept.Name);
                department.setTeamLead(sanDept.Team_Lead__c);
            
                departments.add(department);
            }
        }
        
        return departments;
    }
    
    global class Department {
        
        String guid;
        String divisionId;
        String name;
        String teamLead;
    
        public String getGuid() {
            return guid;
        }
    
        public void setGuid(String guid) {
            this.guid = guid;
        }
        
        public String getDivisionId() {
            return divisionId;
        }
    
        public void setDivisionId(String divisionId) {
            this.divisionId = divisionId;
        }
        
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    
        public String getTeamLead() {
            return teamLead;
        }
    
        public void setTeamLead(String teamLead) {
            this.teamLead = teamLead;
        }
                
    }
}