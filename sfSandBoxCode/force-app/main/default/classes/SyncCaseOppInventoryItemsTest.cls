@isTest
public Class SyncCaseOppInventoryItemsTest{

    static testMethod void SyncCaseOppInventoryItemsTest(){
        SyncCaseOppInventoryItems.syncItems();
    }
    
    static testMethod void SyncCaseOppInventoryItemsScheduler(){
        CaseOppInventoryItemSync.scheduleThis();
    }
}