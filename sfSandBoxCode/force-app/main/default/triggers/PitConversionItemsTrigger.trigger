trigger PitConversionItemsTrigger on Pit_Conversion_Item__c (before insert, before update, before delete) {
    
    /*List<Pit_Conversion_Item__c> pitConversionItems = null;
    
    if(Trigger.isDelete){
        pitConversionItems = Trigger.old;
    } else{
        pitConversionItems = Trigger.new;
    }
    
    if(pitConversionItems != null && pitConversionItems.size() > 0){
        Pit_Conversion_Item__c item = pitConversionItems.get(0);
        
        if(item != null && item.Approved__c){
            item.adderror('You are not permitted to perform this action once items have been approved');
        }
    }*/
    
}