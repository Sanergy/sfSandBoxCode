trigger TeamleadsTrigger on Procurement_Tracking_Sheet__c (before insert , before update) {
    for(Procurement_Tracking_Sheet__c p: Trigger.new){
        /*if(Trigger.isInsert || Trigger.oldMap.get(p.id).Maintenance_Department__c != p.Maintenance_Department__c ||
          Trigger.oldMap.get(p.id).Requesting_Department__c!= p.Requesting_Department__c){
              List<Procurement_Tracking_Sheet__c> pr = 
                  [
                      SELECT id, Requesting_Department__c, Requesting_Department__r.name, Requesting_Department__r.Teamlead__c, 
                      Requesting_Department__r.Teamlead__r.Team_Lead__c, Maintenance_Department__c, Maintenance_Department__r.name, 
                      Maintenance_Department__r.Teamlead__c, Maintenance_Department__r.Teamlead__r.Team_Lead__c 
                      FROM Procurement_Tracking_Sheet__c 
                      WHERE id = :p.Requesting_Department__c
                  ];
              
              if(pr.size()>0){
                  if(pr.get(0).Teamlead__c!=null){
                      p.Team_Ld__c=RDTL.get(0).Teamlead__c;
                  }
              }
          }
        */
        if(Trigger.isInsert || Trigger.oldMap.get(p.id).Maintenance_Department__c != p.Maintenance_Department__c ||
          Trigger.oldMap.get(p.id).Requesting_Department__c!= p.Requesting_Department__c||
          Trigger.oldMap.get(p.id).Requestor__c != p.Requestor__c
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
              List<FFA_Config_Object__c> RDTl= [SELECT ID,Name,Teamlead__c, Teamlead__r.Team_Lead__c FROM FFA_Config_Object__c
                                                WHERE Id=:p.Requesting_Department__c LIMIT 1];
              
              List<FFA_Config_Object__c> MDTl= [SELECT ID,Name,Teamlead__c FROM FFA_Config_Object__c 
                                                WHERE Id=:p.Maintenance_Department__c LIMIT 1];
              
              //Requesting Department
              if(RDTl.size()>0){
                  if(RDTl.get(0).Teamlead__c!=null){
                      //check if the same employee raising or is the requestor then default to their Line Manager
                      if(RDTL.get(0).Teamlead__c == empCreator.Employee_SF_Account__c){
                          p.Team_Ld__c = empCreator.Line_Manager_SF_Account__c;
                      }
                      else if(RDTL.get(0).Teamlead__c == empReq.Employee_SF_Account__c){
                          p.Team_Ld__c = empReq.Line_Manager_SF_Account__c;
                      }
                      else{
                          p.Team_Ld__c=RDTL.get(0).Teamlead__c; 
                      }
                  }
              }
              
              //Maintenance Department
              if(MDTl.size()>0){
                  if(MDTl.get(0).Teamlead__c!=null){
                      //check if the same employee raising or is the requestor then default to their Line Manager
                      if(MDTl.get(0).Teamlead__c == empCreator.Employee_SF_Account__c){
                          p.Maintenance_TL__c = empCreator.Line_Manager_SF_Account__c;
                      }
                      else if(MDTl.get(0).Teamlead__c == empReq.Employee_SF_Account__c){
                          p.Maintenance_TL__c = empReq.Line_Manager_SF_Account__c;
                      }
                      else{
                          p.Maintenance_TL__c=MDTl.get(0).Teamlead__c;
                      }
                  }
              }
              
              //update the approver and director on the line items
              List<PTS_Line_Item__c> ptsLines=[SELECT Approver__c, Quote_Approving_Director__c
                                               FROM PTS_Line_Item__c
                                               WHERE Procurement_Tracking_Sheet__c=:p.id];
              
              if(ptsLines.size()>0){
                  for(PTS_Line_Item__c line:ptsLines){
                      line.Approver__c=RDTl.get(0).Teamlead__c;
                      line.Quote_Approving_Director__c=RDTl.get(0).Teamlead__r.Team_Lead__c;
                  }
                  update ptsLines;
              }
          }
    }
}