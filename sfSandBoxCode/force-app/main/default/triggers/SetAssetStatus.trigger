trigger SetAssetStatus on Sanergy_Asset__c (before insert, before update) {

    for (Sanergy_Asset__c asset: Trigger.new) {
        
        if(Trigger.isInsert){
            asset.Asset_Status__c = 'Inventory';
        }
        
        RecordType type = [SELECT Id, name from RecordType Where id = :asset.RecordTypeId];
               
        if(type != null && type.name.equalsIgnoreCase('Computers')){
        
            String message = '';
        
            if(asset.Manufacturer__c == null || asset.Manufacturer__c == ''){
                message = message + 'Manufacturer, ';
            }
            
            if(asset.Make__c == null || asset.Make__c == ''){
                message = message + 'Make, ';
            }
            
            if(asset.Model__c == null || asset.Model__c == ''){
                message = message + 'Model, ';
            }
            
            if(asset.Operating_System__c == null || asset.Operating_System__c == ''){
                message = message + 'Operating System';
            }
            if(message != null && message != ''){
                asset.addError('The following Fields are required for this type of asset: ' + message);
            }
        }
        
    }
}