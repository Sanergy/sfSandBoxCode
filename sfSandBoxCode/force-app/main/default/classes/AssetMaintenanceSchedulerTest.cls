@istest(SeeAllData=true)
public class AssetMaintenanceSchedulerTest {
    
    public static testmethod void testGetTasks(){
        Test.startTest();
        AssetMaintenanceScheduler j = new AssetMaintenanceScheduler();
        j.day = 1;
        j.dayOfWeek = 'Monday';
        j.getTasks();
        Test.stopTest();
    }  
    
}