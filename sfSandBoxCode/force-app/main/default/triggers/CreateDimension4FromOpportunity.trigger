trigger CreateDimension4FromOpportunity on Opportunity (before insert, before update) {
    for(Opportunity op:Trigger.new){
        //lock this implementation to Contracts and Grants recordtypes
        if(op.RecordTypeId.equals('012D0000000KFArIAO')){ 
           if(op.Create_DIM4__c==true && Trigger.oldMap.get(op.id).Create_DIM4__c==false){
               if(op.Dimension_4__c==null && op.DIM_4_Reporting_Code__c!=null && op.DIM_4_Reporting_Code__c!='' ){
                   //create new Dimension 4 record
                   Integer dimCount=[SELECT  count()
                                     FROM c2g__codaDimension4__c
                                     WHERE c2g__ReportingCode__c=:op.DIM_4_Reporting_Code__c];
                                     
                   if(dimCount>0){
                       op.addError('A dimension 4 record is already existing with the same Reporting Code.');
                   }
                   else{
                       c2g__codaDimension4__c dim4=new c2g__codaDimension4__c(
                           Name=op.DIM_4_Reporting_Code__c,
                           c2g__ReportingCode__c=op.DIM_4_Reporting_Code__c,
                           Dimension_4_Description__c=op.Dimension_4_Description__c
                       );
                       insert dim4;
                       op.Dimension_4__c=dim4.id;
                   }
               
               }
           }
        }
     }
}