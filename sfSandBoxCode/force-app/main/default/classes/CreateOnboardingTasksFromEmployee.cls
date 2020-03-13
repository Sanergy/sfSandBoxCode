public class CreateOnboardingTasksFromEmployee {
    
    //create standard controller
    private ApexPages.StandardController controller;
    
    //User
    private List<User> users {get; set;}
    
    //Employee
    public Employee__c employee {get; set;}
    
    //On-boarding Task
    public Onboarding_Task_Config__c onboardingTaskConfig {get; set;}
    
    //On-boarding Tasks
    public List<OnboardingTask> onboardingTaskList {get; set;}      
    
    // Constructor
    public CreateOnboardingTasksFromEmployee(ApexPages.StandardController controller){               
        this.controller = controller;                
        employee = (Employee__c)controller.getRecord();
        
        employee = [SELECT Name,Employee_First_Name__c,Employee_Last_Name__c,Sanergy_Department__c,
                    Sanergy_Department__r.Name,Sanergy_Department__r.Team_Lead__r.Name,Primary_Phone__c,
                    Recruitment_Requisition__c,Recruitment_Requisition__r.Name,Leave_Group__c,Leave_Group__r.Name,
                    Employee_Role__c,Employee_Role__r.Name,Employment_Start_Date__c 
                    FROM Employee__c 
                    WHERE Employee_Role__c != NULL
                    AND Id =: employee.Id
                    ORDER BY Name DESC];       
        
        System.debug('EMPLOYEE: ' + employee);
    }
    
    // Get On-boarding Tasks
    public List<OnboardingTask> getItems() {        
        
        if(onboardingTaskList == null){
            
            onboardingTaskList = new List<OnboardingTask>();
            
            //Get On-boarding Task
            List<Onboarding_Task_Config__c> onboardingItems = [SELECT Name,Employee_Role__c,Employee_Role__r.Name,Task_Name__c,
                                                               Assigned_To__c,Assigned_To__r.Name,No_of_Days_After_Hire_Date__c,
                                                               Category__c,Description__c,On_boarding_Done_By__c,
                                                               Onboarding_for__c
                                                               FROM Onboarding_Task_Config__c
                                                               WHERE Employee_Role__c =: employee.Employee_Role__c
                                                               OR Onboarding_for__c = 'All roles'
                                                               OR Onboarding_for__c = 'All roles in a department'];
            
            for(Onboarding_Task_Config__c onboardingItem : onboardingItems){                              
                onboardingTaskList.add(new OnboardingTask(onboardingItem));
            }
            System.debug('ON-BOARDING TASK: ' + onboardingTaskList);
        }
        return onboardingTaskList;
    }
    
    //Create Task
    public PageReference createTask(){
        
        if(onboardingTaskList!= null  && onboardingTaskList.size() > 0){
            for(OnboardingTask item : onboardingTaskList){
                
                System.debug('TASK NAME SELECTED = ' + item.onboardingTask.Task_Name__c);
                
                if(item.selected == true){
                    
                    //No. of days after hiring an employee
                    Decimal daysAfterHire = item.onboardingTask.No_of_Days_After_Hire_Date__c;                        
                    
                    //if NULL set to 0
                    daysAfterHire = daysAfterHire == NULL ? 0:daysAfterHire;
                    
                    //Convert daysAfterHire to Integer
                    Integer days = daysAfterHire.intValue();                        
                    
                    //Create a task
                    Task task = new Task();
                    task.OwnerId = item.onboardingTask.Assigned_To__c;
                    task.Subject = item.onboardingTask.Category__c;
                    task.Employee__c = employee.Id;
                    task.Goals__c = item.onboardingTask.Task_Name__c;
                    task.Outcomes__c = item.onboardingTask.Description__c;
                    task.WhatId = item.onboardingTask.Id;
                    task.ActivityDate = employee.Employment_Start_Date__c + days;                        
                    INSERT task;
                    
                    System.debug('TASK UPSERT = ' + task);
                } 
            }              
        }
        
        return new PageReference('/'+ employee.Id);
    }
    
    
    // Wrapper class
    public class OnboardingTask{        
        public Onboarding_Task_Config__c onboardingTask {get; set;}
        public Boolean selected {get; set;}
        
        //Constructor
        public OnboardingTask(Onboarding_Task_Config__c ot) {
            onboardingTask = ot;
            selected = true;
        }        
    }    
}