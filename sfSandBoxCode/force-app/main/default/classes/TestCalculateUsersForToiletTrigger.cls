/*
 *
 */
 
@isTest
private class TestCalculateUsersForToiletTrigger {
    
    static Integer getDayOfWeek(Date dt)
    {
        Integer daysBetween = DateTime.valueOfGmt('1990-07-1 00:00:00').dateGMT().daysBetween(dt);
        Integer remainder = Math.mod(daysBetween, 7);
        
        return remainder ;
    }

    static Date getNearestSunday(Date currentDate) {
        Date adjustedStartOfWeek = null;
        
        if(getDayOfWeek(currentDate) == 0) {
            adjustedStartOfWeek = currentDate;
        } else if(getDayOfWeek(currentDate) == 1) {
            adjustedStartOfWeek = currentDate.addDays(-1);
        } else if(getDayOfWeek(currentDate) == 2) {
            adjustedStartOfWeek = currentDate.addDays(-2);
        } else if(getDayOfWeek(currentDate) == 3) {
            adjustedStartOfWeek = currentDate.addDays(-3);
        } else if(getDayOfWeek(currentDate) == 4) {
            adjustedStartOfWeek = currentDate.addDays(-4);
        } else if(getDayOfWeek(currentDate) == 5) {
            adjustedStartOfWeek = currentDate.addDays(-5);
        } else if(getDayOfWeek(currentDate) == 6) {
            adjustedStartOfWeek = currentDate.addDays(-6);
        }
        return adjustedStartOfWeek;
    }
    
    static testmethod void testTrigger() {
        
        Location__c loc = new Location__c(Name = 'TS');
        insert loc;
        
        Toilet__c toilet1 = new Toilet__c(Location__c = loc.Id, Operational_Status__c='Open',
                                       Current_Specific_Status__c='Open - New',Name = 'TS-1.1', Collection_Route__c = 'CLOSED', Opening_Date__c = Date.today().addMonths(-2)) ;
        Toilet__c toilet2 = new Toilet__c(Location__c = loc.Id, Name = 'TS-2.1', Operational_Status__c='Open',
                                       Current_Specific_Status__c='Open - New', Collection_Route__c = 'CLOSED', Opening_Date__c = Date.today().addMonths(-2)) ;
        insert new Toilet__c[]{toilet1, toilet2};
        
        Date referenceDate = getNearestSunday(Date.today());
        
        Collection_Data__c toilet1CollData1 = new Collection_Data__c(Toilet__c = toilet1.Id, Name = 'Test Waste',
                                                                     Feces_kg__c = 12, Urine_kg__c = 11, Collection_Date__c = referenceDate.addDays(-3));
                                                                     
        Collection_Data__c toilet1CollData2 = new Collection_Data__c(Toilet__c = toilet1.Id, Name = 'Test Waste',
                                                                     Feces_kg__c = 9, Urine_kg__c = 8, Collection_Date__c = referenceDate.addDays(-9));
                                                                     
        Collection_Data__c toilet2CollData1 = new Collection_Data__c(Toilet__c = toilet1.Id, Name = 'Test Waste',
                                                                     Feces_kg__c = 4, Urine_kg__c = 5, Collection_Date__c = referenceDate.addDays(-4)); 
        
        Collection_Data__c toilet2CollData2 = new Collection_Data__c(Toilet__c = toilet1.Id, Name = 'Test Waste',
                                                                     Feces_kg__c = 2, Urine_kg__c = 1, Collection_Date__c = referenceDate.addDays(-17));  
                                                                     
        insert new Collection_Data__c[]{toilet1CollData1 , toilet1CollData2, toilet2CollData1, toilet2CollData2 };
        
        toilet2CollData1.Feces_kg__c = 5 ;
        toilet1CollData2.Collection_Date__c = referenceDate.addDays(-10);
        
        update new Collection_Data__c[]{toilet2CollData1, toilet1CollData2};
        
    }

}