trigger UnitsAndDateValidation on Asset_Usage_Reading__c (before insert) {
    //variable
    List<Asset_Usage_Reading__c> assetUse = new  List<Asset_Usage_Reading__c>();
    
    for(Asset_Usage_Reading__c assetUsage : Trigger.New){
        
        //query to get the last entered date and units
        assetUse = [SELECT Name, Actual_Units__c,Date__c,Sanergy_Asset__c,Units__c,Current_Reading__c
                    FROM Asset_Usage_Reading__c
                    WHERE Sanergy_Asset__c =: assetUsage.Sanergy_Asset__c
                    ORDER BY Actual_Units__c DESC
                    LIMIT 1];
        
        
        if(assetUse.size() > 0){
            // if there is an existing record
            // check if the date and the units of the record you are trying to create are higher than
            //  the ones of the current highest reading
            
            if(assetUsage.Actual_Units__c > assetUse.get(0).Actual_Units__c){
                if(assetUsage.Date__c >= assetUse.get(0).Date__c && assetUsage.Date__c <= date.today()){
                    assetUsage.Current_Reading__c = true;
                    
                    List<Asset_Usage_Reading__c> AssetsUsageList = [SELECT Id,Current_Reading__c,Sanergy_Asset__c
                                                                    FROM Asset_Usage_Reading__c 
                                                                    WHERE Current_Reading__c = true
                                                                    AND Sanergy_Asset__c =: assetUsage.Sanergy_Asset__c
                                                                    AND  ID !=: assetUsage.Id
                                                                   ];
                    if(AssetsUsageList.Size() > 0){
                        for (Asset_Usage_Reading__c use: AssetsUsageList){
                            use.Current_Reading__c = false;
                        }
                        update AssetsUsageList;
                    }
                        //assetUse.get(0).Current_Reading__c = false;
                        
                        Sanergy_Asset__c assets  = [SELECT ID,Current_Reading__c
                                                    FROM Sanergy_Asset__c
                                                    WHERE ID =: assetUsage.Sanergy_Asset__c
                                                   ];
                        
                        assets.Current_Reading__c = assetUsage.Actual_Units__c;
                        update assets;  
                    }
                    else{
                        assetUsage.Date__c.addError('Date should not be in the future and also not less than last entered date');
                        
                    }
                    
                }
                else{
                    assetUsage.Actual_Units__c.addError('Units should be greater than previously entered units');
                }
                
            }
            // If it is the first record insert that as the current reading on the Asset 
            else{
                Sanergy_Asset__c assets  = [SELECT ID,Current_Reading__c
                                            FROM Sanergy_Asset__c
                                            WHERE ID =: assetUsage.Sanergy_Asset__c
                                           ];
                
                assets.Current_Reading__c = assetUsage.Actual_Units__c;
                update assets;   
            }
        }
    }
    
    //CHECK IF QUERY RETURNs a record
    /*if(assetUse.size() > 0 && assetUse != null ){
//check the last given date and Actual Units and compare it to entrered date and units
Date lastSavedDate = assetUse.get(0).Date__c;
Decimal lastSavedActualUnits = assetUse.get(0).Actual_Units__c;

System.debug('Date >> ' + lastSavedDate);
System.debug('units >> ' + lastSavedActualUnits);

//check if given date less than today but more than previously saved date
if(assetUsage.Date__c > lastSavedDate && assetUsage.Date__c <= date.today()){
//now check if entered units are greater than actual units 
if(assetUsage.Actual_Units__c > lastSavedActualUnits ){
//if everything is fine
//save the record and update the current Reading field on sanergy asset
//update this record as current usage record
Sanergy_Asset__c assetRead = new Sanergy_Asset__c(id = assetUsage.Sanergy_Asset__c);
assetRead.Current_Reading__c =  String.valueOf(assetUsage.Actual_Units__c );
update assetRead;

//fetch the asset Usage
List<Asset_Usage_Reading__c> assetUse = [SELECT Id, Current_Reading__c,Sanergy_Asset__c
FROM Asset_Usage_Reading__c
WHERE Sanergy_Asset__c =: assetUsage.Sanergy_Asset__c
];

//set all current asset Usage to false(not active)
for(Asset_Usage_Reading__c asset : assetUse){
//loop through and set all of the readings to null
asset.Current_Reading__c = false;
}

//set the this record as current reading
assetUsage.Current_Reading__c = true;

}else{
//Display error at the actual units field and prevent save
assetUsage.Actual_Units__c.addError('Units should be greater than previously entered units');
}
}else{
//Display error at the Date field and prevent save
assetUsage.Date__c.addError('Date should not be in the future and also not less than last entered date');
}
}else{
//if query doesnt return an item just save the given records
}
}

}
*/