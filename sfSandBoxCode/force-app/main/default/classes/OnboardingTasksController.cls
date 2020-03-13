public class OnboardingTasksController {
    
    private ApexPages.StandardController standardController;
    public Employee__c employee{get; set;}
    public List<OnboardingTasks> onboardingTasks {get; set;}
    
    public OnboardingTasksController(ApexPages.StandardController standardController){
        this.standardController = standardController;
        this.employee = (Employee__c)standardController.getRecord();
        onboardingTasks = new List<OnboardingTasks>();
        
        List<On_Offboarding_Checklist__c> items = [SELECT Id,Name,Employee__c,Task_Name__c,Schedule_Date__c,Scheduled__c,Trained_By__c,Done__c
                                                     FROM On_Offboarding_Checklist__c 
                                                     WHERE Employee__c =: this.employee.Id
                                                    ];
        
        for(On_Offboarding_Checklist__c item:items){
            OnboardingTasks wr = new OnboardingTasks(item);
            onboardingTasks.add(wr);
        }
    } 
    
       public PageReference selectAll() {
        if(onboardingTasks != null){
            for(OnboardingTasks lg:onboardingTasks){
                lg.selected=true;                
            }
        }
        return null;
    }
    
    public PageReference unselectAll() {
        if(onboardingTasks != null){
            for(OnboardingTasks lg:onboardingTasks){
                lg.selected=false;                
            }
        }
        return null;
    }
    
    public PageReference  processSelected() {
        
         if(onboardingTasks != null && onboardingTasks.size() > 0){
            
            integer issued = 0;
            integer expected = 0;
            
            for(OnboardingTasks item : onboardingTasks){
                
                if(item.selected ){
                    
                    expected +=1;
                    update item.item;
                  
                } issued +=1;
            }
        
            if(expected == issued){
                return new PageReference('/' + this.employee.Id);
            } else {
                return new PageReference('/' + this.employee.Id);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Some Tasks were not edited');
                ApexPages.addmessage(msg);
                return null;
            }
            
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Kindly confirm that the selected Employee has Tasks'));
            return null;
        }
        return null;
    }
    
    public class OnboardingTasks{
        
        public On_Offboarding_Checklist__c item {get; set;}
        public On_Offboarding_Checklist__c onboardingItem {get; set;}
        public Boolean selected {get; set;}
        public OnboardingTasks(On_Offboarding_Checklist__c onboardingItem) {
            item = onboardingItem;

           // onboardingItem.Task_Name__c = line.Task_Name__c;
            this.selected = true;
        }
    }

}