trigger AreaLastLocationNumber on Area__c (before insert, before update) {
    
    /*Integer convertToInteger;
    String lastThreeCharacters = '' ;
    
    for(Area__c area: Trigger.new){
        
        Location__c lastLocation = [SELECT Id,Name,Last_FLT__c,Area__c,Area_Name__c
                                    FROM Location__c
                                    WHERE Area_Name__c =: area.Id//Area__c =: area.Name
                                    ORDER BY Name DESC
                                    LIMIT 1];
        
        lastThreeCharacters = lastLocation.Name;
        lastThreeCharacters = lastThreeCharacters.mid(3, 2);
        
        //Convert String to Integer
        convertToInteger = Integer.valueOf(lastThreeCharacters);
        
        //Insert Last Location No.
        area.Last_Location_No__c = convertToInteger;
        
    }*/
}