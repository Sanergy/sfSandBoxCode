public with sharing class Utils{ 
 
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
    
    
    
    
    private static Map<Id, sObject> oldMapOverride = new Map<Id, sObject>();
    
    //a function to insert single records from triggers without duplicating
     public static void insertOnce(sObject record, List<sObject> listRecords, String fieldName){
         
         sObject oldRecord=oldMapOverride.containsKey(record.id)?oldMapOverride.get(record.id):Trigger.oldMap.get(record.id);
         
         if(oldRecord!=null && oldRecord.get(fieldName)!=record.get(fieldName)){
                 insert listRecords;
                 oldMapOverride.put(record.id, record);
         }
         
         
     
     
     }
     
     
     //Counter
     private static Integer tCounter=0;
     public static  boolean transactionHasOccurred(){
         tCounter++;
         return tCounter > 1;     
     }
     
     
     //function to return unique random string
     public static String getUniqueRandomString(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        
        return hexDigest;        
     }
    
    
}