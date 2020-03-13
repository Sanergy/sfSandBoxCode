@isTest (seeAllData = true)
Public Class ProcurementRequestTrackerTest{

    public static TestMethod void ProcurementRequestTrackerTest(){
        ProcurementRequestTracker tracker = new ProcurementRequestTracker();
        tracker.getSelectItems();
        tracker.save();
        
        tracker.getwrapperItems();
        tracker.selectValue ='ALL';
        tracker.getwrapperItems();
        tracker.selectValue = 'PENDING USER CLOSURE';
        tracker.getwrapperItems();
        tracker.selectValue = 'OPEN';
        tracker.getwrapperItems();
        tracker.selectValue ='CLOSED';
        tracker.getwrapperItems();
        
    }
}