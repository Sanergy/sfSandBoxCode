@RestResource(urlMapping='/record_types')
global with sharing class REST_RecordTypes {

    @HttpPost
    global static List<RecType> getAllRecordTypes() {
    
        List<RecType> recTypes = new List<RecType>();
        
        List<RecordType> sanRecTypes = [SELECT Id, Name FROM RecordType];
        
        if(sanRecTypes != null && sanRecTypes.size()> 0){
        
            for(RecordType sanRecType : sanRecTypes){
            
                RecType rec = new RecType();
                
                rec.setGuid(sanRecType.Id);
                rec.setName(sanRecType.Name);
            
                recTypes.add(rec);
            }
        }
        
        return recTypes ;
    }
    
    global class RecType{
        
        String guid;
        String name;
    
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
            
    }
}