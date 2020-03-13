@RestResource(urlMapping='/department_units')
global with sharing class REST_DepartmentUnits {

    @HttpPost
    global static List<DepartmentUnit> getAllDepartmentUnits() {
    
        List<DepartmentUnit> departmentunits = new List<DepartmentUnit>();
        
        List<Sanergy_Department_Unit__c> sanDeptUnits = [SELECT Id, Name, Sanergy_Department__c, Line_Manager__c FROM Sanergy_Department_Unit__c];
        
        if(sanDeptUnits != null && sanDeptUnits.size()> 0){
        
            for(Sanergy_Department_Unit__c sanDeptUnit: sanDeptUnits){
            
                DepartmentUnit unit = new DepartmentUnit();
                
                unit.setGuid(sanDeptUnit.Id);
                unit.setDepartment(sanDeptUnit.Sanergy_Department__c);
                unit.setName(sanDeptUnit.Name);
                unit.setLineManager(sanDeptUnit.Line_Manager__c );
            
                departmentunits.add(unit);
            }
        }
        
        return departmentunits;
    }
    
    global class DepartmentUnit {
        
        String guid;
        String department;
        String name;
        String lineManager;
    
        public String getGuid() {
            return guid;
        }
    
        public void setGuid(String guid) {
            this.guid = guid;
        }
    
        public String getDepartment() {
            return department;
        }
    
        public void setDepartment(String department) {
            this.department = department;
        }
    
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    
        public String getLineManager() {
            return lineManager;
        }
    
        public void setLineManager(String lineManager) {
            this.lineManager = lineManager;
        }
        
    }
}