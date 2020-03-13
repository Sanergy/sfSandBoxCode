trigger CreateFLT on Opportunity (before update) {
    
    
    for(Opportunity opportunity: Trigger.new){
        
        if(opportunity.StageName == 'Pending Launch'){
            
            //Get Location
            Location__c loc = [SELECT Id,Name,Last_FLT__c,
                               Area__c,Area_Name__c
                               FROM Location__c
                               WHERE Id =: opportunity.Location__c
                               LIMIT 1];            
            
            Decimal newToiletNumber = loc.Last_FLT__c + 1;
            String toiletName = loc.Name + '.' + newToiletNumber;
            
            //Create Toilet
            Toilet__c toilet = new Toilet__c();
            toilet.RecordTypeId = '012D0000000K64jIAC'; //Sanergy
            toilet.Name = toiletName;
            toilet.Location__c = opportunity.Location__c;
            toilet.Opportunity__c = opportunity.Id;
            toilet.Operational_Status__c = 'Open';
            toilet.Collection_Route__c = 'CLOSED';
            toilet.Current_Specific_Status__c = 'Open - New';
            INSERT toilet;
            
            //Update Location 
            loc.Last_FLT__c =  newToiletNumber;
            UPDATE loc;
            
        }
        
    }  
    
}