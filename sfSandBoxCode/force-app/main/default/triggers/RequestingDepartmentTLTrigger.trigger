trigger RequestingDepartmentTLTrigger on Special_Procurement__c (before insert , before update) {
    
    for(Special_Procurement__c p: Trigger.new){
        
        //Allow change of Dept/Requestor only if in Pending Approval Stage
        if(Trigger.isInsert || 
           ((Trigger.oldMap.get(p.id).Requesting_Department__c!= p.Requesting_Department__c || 
           Trigger.oldMap.get(p.id).Requesting_Department__c!= p.Requesting_Department__c ||
           Trigger.oldMap.get(p.id).Requestor__c!= p.Requestor__c) 
           && p.Approval_Status__c == 'Pending Approval'
           )
          ){
            
            //Get details of Creator and Requestor
            Employee__c empCreator = 
                [
                    SELECT Id, Name, Employee_SF_Account__c, Line_Manager_SF_Account__c
                    FROM Employee__c
                    WHERE Employee_SF_Account__c =: p.CreatedById LIMIT 1
                ];
            
            Employee__c empReq = 
                [
                    SELECT Id, Name, Employee_SF_Account__c, Line_Manager_SF_Account__c
                    FROM Employee__c
                    WHERE id =: p.Requestor__c LIMIT 1
                ];
            
            List<FFA_Config_Object__c> RDTL= [SELECT ID,Name,Teamlead__c, Teamlead__r.Team_Lead__c 
                                              FROM FFA_Config_Object__c
                                              WHERE Id=:p.Requesting_Department__c LIMIT 1];             
              //Requesting Department
              if(RDTl.size()>0){
                  if(RDTl.get(0).Teamlead__c!=null){
                      //check if the same employee raising or is the requestor then default to their Line Manager
                      if(RDTL.get(0).Teamlead__c == empCreator.Employee_SF_Account__c){
                          p.Requesting_Department_TL__c = empCreator.Line_Manager_SF_Account__c;
                      }
                      else if(RDTL.get(0).Teamlead__c == empReq.Employee_SF_Account__c){
                          p.Requesting_Department_TL__c = empReq.Line_Manager_SF_Account__c;
                      }
                      else{
                          p.Requesting_Department_TL__c=RDTL.get(0).Teamlead__c; 
                      }
                  }
              }
            /*
            if(RDTL.size()>0){
                if(RDTL.get(0).Teamlead__c!=null){
                    p.Requesting_Department_TL__c=RDTL.get(0).Teamlead__c;
                    System.debug('REQUESTING DEPT TL 1: ' + p.Requesting_Department_TL__c);
                }
            } 
*/
          }else{
              //p.addError('You are not allowed to Edit the SPR Requestor once it has been approved');
          }
            
    }
}