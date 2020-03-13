/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Recruitment_Request_ConfigTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Recruitment_Request_ConfigTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Recruitment_Request_Config__c());
    }
}