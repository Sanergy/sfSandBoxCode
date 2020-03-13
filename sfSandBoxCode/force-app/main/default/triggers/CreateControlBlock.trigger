trigger CreateControlBlock on Treatment_Block__c (before insert) {
  for(Treatment_Block__c  tb:Trigger.new){
      List<RecordType> rName=[SELECT Name
                              FROM RecordType
                              WHERE ID=:tb.RecordTypeId];
       
       List<RecordType> rID=[SELECT Id
                              FROM RecordType
                              WHERE Name='Control Block'];
                              
                              
       if(rName.size()>0 && rName.get(0).Name=='Treatment Block' && rId.size()>0){
       
           Treatment_Block__c controlBlock=new Treatment_Block__c (
               Trial__c=tb.Trial__c,
               RecordTypeId=rID.get(0).id,
               Type__c='Control Block'
           );
           
           insert controlBlock;
           tb.Control_Block__c=controlBlock.id;
           
       }
  }
}