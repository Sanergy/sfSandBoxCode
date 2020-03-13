@RestResource(urlMapping='/projects')
global with sharing class REST_Projects {

    @HttpPost
    global static List<Project> getAllProjects() {
    
        List<Project> projects = new List<Project>();
        
        List<rstk__pjproj__c> sanProjects = [SELECT Id, Name, rstk__pjproj_div__c, rstk__pjproj_itemno__c FROM rstk__pjproj__c];
        
        if(sanProjects!= null && sanProjects.size()> 0) {
        
            for(rstk__pjproj__c sanProject : sanProjects){
            
                Project project = new Project();
                
                project.setGuid(sanProject.Id);
                project.setName(sanProject.Name);
                project.setDivision(sanProject.rstk__pjproj_div__c);
                project.setItemNumber(sanProject.rstk__pjproj_itemno__c);
            
                projects.add(project);
                
            }
        }
        return projects;
    }
    
    global class Project {
    
        String guid;
        String name;
        String division;
        String itemNumber;
    
        public String getGuid() {
            return guid;
        }
    
        public void setGuid(String guid) {
            this.guid = guid;
        }
    
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    
        public String getDivision() {
            return division;
        }
    
        public void setDivision(String division) {
            this.division = division;
        }
    
        public String getItemNumber() {
            return itemNumber;
        }
    
        public void setItemNumber(String itemNumber) {
            this.itemNumber = itemNumber;
        }
    }
}