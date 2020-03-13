trigger UpdateTrialCropQuantityField on Treatment_Block__c (after update) {
   for(Treatment_Block__c  tb: Trigger.new){
       if(tb.Crop_Quantity__c!=null && tb.Crop_Quantity__c!=Trigger.oldMap.get(tb.id).Crop_Quantity__c){
       
           List<Treatment_Block__c> tbList=[SELECT Crop_Quantity__c, Name 
                                            FROM Treatment_Block__c
                                            WHERE Trial__c=:tb.Trial__c ];
           
           List<Trial__c> trial=[SELECT Crop_Quantity__c
                                 FROM Trial__c
                                 WHERE ID=:tb.Trial__c];
                                 
           String cropQuantity='';
           
           for(Treatment_Block__c tbTrial:tbList){
             if(tbTrial.Crop_Quantity__c!=null){
                 cropQuantity+=tbTrial.Name+' - '+tbTrial.Crop_Quantity__c+'\n';
             }
           }
       
           trial.get(0).Crop_Quantity__c=cropQuantity;
           update trial;
       }
   }
}