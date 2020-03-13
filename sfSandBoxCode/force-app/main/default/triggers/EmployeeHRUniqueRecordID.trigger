trigger EmployeeHRUniqueRecordID on Employee__c (before insert) {
 Employee__c UniqueRec = [SELECT HR_Unique_Record_ID__c,HR_Employee_ID__c
                                 FROM Employee__c
                                 WHERE HR_Unique_Record_ID__c  !=  null
                                 ORDER BY HR_Unique_Record_ID__c DESC
                                 limit 1
                                ];
    system.debug('UniqueRec' + UniqueRec);
    Integer myInteger = 1 + Integer.valueOf(UniqueRec.HR_Unique_Record_ID__c);
    Integer myInteger2 = 1 + Integer.valueOf(UniqueRec.HR_Employee_ID__c);
    system.debug('Integer' + myInteger);
    String myString =  String.valueOf(myInteger);
    String myString2 =  String.valueOf(myInteger2);

    
    
    for(Employee__c inv: Trigger.new){       
        
        inv.HR_Unique_Record_ID__c = myString;
        inv.HR_Employee_ID__c  = myString2;
        system.debug('HR Unique Record' + inv.HR_Unique_Record_ID__c);
        system.debug('Second Addition' + inv.HR_Employee_ID__c);
    } 

}