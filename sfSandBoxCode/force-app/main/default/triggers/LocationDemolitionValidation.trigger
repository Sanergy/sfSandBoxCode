trigger LocationDemolitionValidation on Location_Demolition_Toilets__c (before insert, before update, before delete) {
    /*if(Trigger.isInsert){
        for(Location_Demolition_Toilets__c LDT:Trigger.new){
            Integer numberOfLTD=[SELECT count()
                                 FROM Location_Demolition_Toilets__c
                                 WHERE Toilet__c=:LDT.Toilet__c
                                 AND Toilet_Status__c=null];
            
            
            Location_Demolition__c LD=[SELECT Name,Demolished_Location__c,Firm_Toilets__c, Stage__c, ID
                                       FROM Location_Demolition__c
                                       WHERE ID=:LDT.Location_Demolition__c ];
            
            Toilet__c toilet=[SELECT Current_Specific_Status__c,Operational_Status__c, Location__c FROM Toilet__c
                              WHERE ID=:LDT.Toilet__c];
            
            
            
            
            
            
            //ensure that no record can be added  once firming has been done
            if(LD.Firm_Toilets__c==true){
                LDT.addError('New toilets cannot be added if Toilets have been firmed');
            }
            
            
            //ensure that the toilet is in the respective location 
            else if(toilet.Location__c!=LD.Demolished_Location__c){
                LDT.addError('This toilet is not in the specified location.');
                
            }
            
            //Ensure that the same toilet is not marked more than once in Location demolitions
            else if(numberOfLTD>0){
                LDT.addError('This toilet already has a pending status in another Location Demolition');
            }
            
            //ensure that one demolition record does not contain duplicate toilets
            else{
                
                Integer numberOfLTDperLD=[SELECT count()
                                          FROM Location_Demolition_Toilets__c
                                          WHERE Toilet__c=:LDT.Toilet__c
                                          AND Location_Demolition__c=:LDT.Location_Demolition__c];
                
                if(numberOfLTDperLD>0){
                    LDT.addError('You cannot insert the same toilet more than once in a Location Demolition');
                    
                }
                String ldtName=LDT.Name;
                LDT.Name=LD.Name+' LDT-'+ldtName;
                
                //update toilet status
                if(LDT.Close_Toilet__c==true){
                    toilet.Operational_Status__c='Closed';
                    toilet.Current_Specific_Status__c='Closed - Demolished';
                    toilet.closure_type__c='Permanent';
                    update toilet;
                }
                
                
                //Create location demolition history record
                CreateLocationDemolitionHistoryRecords.createRecord('New toilet record created: '+LDT.Name,LD.Stage__c,LD.ID);
                
                
                
                
            }
            
        }
    }
    
    else if(Trigger.isUpdate){
        for(Location_Demolition_Toilets__c LDT:Trigger.new){
            
            Location_Demolition__c LD=[SELECT Demolished_Location__c,Firm_Toilets__c
                                       FROM Location_Demolition__c
                                       WHERE ID=:LDT.Location_Demolition__c];
            
            
            
            Toilet__c toilet=[SELECT Current_Specific_Status__c,Operational_Status__c, Location__c FROM Toilet__c
                              WHERE ID=:LDT.Toilet__c];
            
            if(LDT.Close_Toilet__c!=Trigger.oldMap.get(LDT.ID).Close_Toilet__c && LDT.Close_Toilet__c==true){
                toilet.Operational_Status__c='Closed';
                toilet.Current_Specific_Status__c='Closed - Demolished';
                toilet.closure_type__c='Permanent';
                update toilet; 
                
            }
        }
    }
    
    
    
    else if(Trigger.isDelete){
        for(Location_Demolition_Toilets__c LDT:Trigger.old){
            
            Location_Demolition__c LD=[SELECT Demolished_Location__c,Firm_Toilets__c
                                       FROM Location_Demolition__c
                                       WHERE ID=:LDT.Location_Demolition__c];
            
            //ensure that record cannot be deleted once firming has been done
            if(LD.Firm_Toilets__c==true){
                LDT.addError('Location Demolition Toilets cannot be deleted if Toilets have been firmed');
            }
        }
    }*/
    
    
}