trigger UpdateOperationalStatus on Toilet__c ( after update, after insert)  {

           
         
            Toilet__c[] toilet=Trigger.new;
             for (Toilet__c updatedToilet : toilet) {
             
             
             if((Trigger.isUpdate && updatedToilet.Current_Specific_Status__c != Trigger.oldMap.get(updatedToilet.ID).Current_Specific_Status__c)
                || Trigger.isInsert){
                //Variables from the updated toilet
                String status=updatedToilet.Operational_Status__c;
                String specific_status=updatedToilet.Current_Specific_Status__c;
                String id=updatedToilet.ID;
                String name=updatedToilet.Name;
                
                /*
                    If status is set as Demolished, check if location demolition record exists for the 
                    respective location. Display an error is the location demolition record doesnt exist
                */
                if(specific_status!=null){
                
                 /*
                    Create a new Toilet operational status if the status is changed to 'Open' or 'Closed'
                */
                
 
                    //create new Operational status record
                    Toilet_Operational_Status__c OS = new Toilet_Operational_Status__c(
                                                       
                                                       Status__c=status,
                                                       Specific_Status__c=specific_status,
                                                       Date_From__c= date.today(),
                                                       Toilet_Status__c=id,
                                                       Current_Record__c=true,
                                                       Closure_Type__c=updatedToilet.Closure_Type__c,
                                                       Name=name+' - '+Datetime.now().format('yyyy-MM-dd HHmmss')
                                                      ); 
                       
                      List<Toilet_Operational_Status__c>   tosList=new List<Toilet_Operational_Status__c>();
                      tosList.add(OS);
                      
                      if(Trigger.isInsert){
                          insert tosList;
                      }  
                      else if(Trigger.isUpdate){
                          Utils.insertOnce(updatedToilet,tosList,'Current_Specific_Status__c'); 
                      }
                                          
                      
                      
                      //update the number of open locations in the location
                      Integer numOpenToilets=[SELECT count()
                                          FROM Toilet__c
                                          WHERE Location__c=:updatedToilet.Location__c
                                          AND Operational_Status__c='Open'];
                        
                      Location__c location=[SELECT Location_Operational_Status__c,No_of_Open_toilets__c
                                            FROM Location__c
                                            WHERE ID=:updatedToilet.Location__c];
                                            
                     location.No_of_Open_toilets__c=numOpenToilets;
                     location.Location_Operational_Status__c=numOpenToilets==0?'Closed':'Open';
                     
                     update location;
                      
                      
                  }
                  
                  else{
                  
                      updatedToilet.addError('Please choose an option for the "Current Specific Status" field.');
                  }
                }// end  outer if
            }//end for
    
}//end trigger