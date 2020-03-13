@isTest(SeeAllData=True)
public class AllowanceUpdaterTest {
    static testMethod void basicTest(){
        List<Sanergy_Department_Unit__c> departmentUnit = [select id,approver__c,Unit_Code__c
                                                          from Sanergy_Department_Unit__c
                                                          where Approver__c !=null
                                                          limit 1
                                                          ];
        if(departmentUnit.size()>0){
            List<User> newApprover = [select Id
                                   from User 
                                   where id !=: departmentUnit.get(0).Approver__c
                                   AND isActive = true
                                   limit 1
                                  ];
            if(newApprover.size()>0){
                departmentUnit.get(0).Approver__c = newApprover.get(0).id;
				departmentUnit.get(0).Unit_Code__c = 'IT';                
                update departmentUnit;
            }            
        }
            
    }
}