trigger calculateUsersForToilet on Collection_Data__c (after insert, after update, after delete) {
    
    Set<Id> toiletIds = new Set<Id>();
    Date triggerFireDate ;
    List<Collection_Data__c> collectionDataList = trigger.isDelete ? trigger.old: trigger.new ;

    for(Collection_Data__c collectionData : collectionDataList ) {
        toiletIds.add(collectionData.Toilet__c);
        triggerFireDate = collectionData.LastModifiedDate.date() ;
    }
    
    List<Toilet__c> toiletList = [select Users_Two_Weeks_Ago__c, Users_Last_Week__c, Users_Three_Weeks_Ago__c , (select ApproxCust__c, Collection_Date__c from Collection_Data__r)
                       from Toilet__c where Id in: toiletIds LIMIT 5] ;
    
    List<Toilet__c> tobeUpdatedToilet = new List<Toilet__c>();
    for (Toilet__c toilet : toiletList ) {
    
        List<Collection_Data__c > toiletCollectionList = toilet.Collection_Data__r ;
        Date nearestSunday = getNearestSunday(triggerFireDate);
        
        Integer countForLastWeek = 0, countForTwoWeekAgo = 0, countForThreeWeekAgo = 0;
        
        for (Collection_Data__c colc : toiletCollectionList) {
            if (colc.ApproxCust__c != null ) {
                if (colc.Collection_Date__c >= nearestSunday.addDays(-7) && colc.Collection_Date__c <= nearestSunday) {
                    countForLastWeek += Integer.valueOf(colc.ApproxCust__c) ;
                }
                else if (colc.Collection_Date__c >= nearestSunday.addDays(-14) && colc.Collection_Date__c <= nearestSunday.addDays(-7)) {
                    countForTwoWeekAgo += Integer.valueOf(colc.ApproxCust__c) ;
                }
                else if (colc.Collection_Date__c >= nearestSunday.addDays(-21) && colc.Collection_Date__c <= nearestSunday.addDays(-14)) {
                    countForThreeWeekAgo += Integer.valueOf(colc.ApproxCust__c) ;
                }
            }
        }
        

        if(toilet.Users_Last_Week__c != countForLastWeek || toilet.Users_Two_Weeks_Ago__c != countForTwoWeekAgo
            || toilet.Users_Three_Weeks_Ago__c != countForThreeWeekAgo) {
            toilet.Users_Last_Week__c = countForLastWeek ;
            toilet.Users_Two_Weeks_Ago__c = countForTwoWeekAgo ;
            toilet.Users_Three_Weeks_Ago__c = countForThreeWeekAgo ;
            tobeUpdatedToilet.add(toilet);
        }
        
    }
    
    if (!tobeUpdatedToilet.isEmpty())
        update tobeUpdatedToilet ;
    
    
    public Integer getDayOfWeek(Date dt)
    {
        Integer daysBetween = DateTime.valueOfGmt('1990-07-1 00:00:00').dateGMT().daysBetween(dt);
        Integer remainder = Math.mod(daysBetween, 7);
        
        return remainder ;
    }

    public Date getNearestSunday(Date currentDate) {
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
    
}