trigger CreateEmployeeLeaveRequest on Employee_Leave_Request__c (before insert) {
    
    Integer countHolidays=0;
    Integer countWeekends=0;
    Integer NoOfDays=0;  
    
    for(Employee_Leave_Request__c leaveRequest: Trigger.new){
        
        //if request is from the create leave visual force page then do nothing
        if(leaveRequest.Request_From_VFP__c == true){
            
            
        }else{
            //if request is from the object view
            if(Trigger.isInsert){
                
                Date startDate = Date.valueOf(leaveRequest.Leave_Start_Date__c);
                Date endDate = Date.valueOf(leaveRequest.Leave_End_Date__c + 1);
                NoOfDays = startDate.daysBetween(endDate);
                
                System.debug('INITIAL NO. OF DAYS: ' + NoOfDays );
                
                //Get the no. of holidays between the leave request            
                List<Sanergy_Calendar__c> sanergyCalendar = [SELECT Id,Name,Date__c,Description__c, Weekday_Name__c,Weekday_No__c,
                                                             IsHoliday__c,IsWeekend__c
                                                             FROM Sanergy_Calendar__c                                                       
                                                             WHERE Date__c >=: leaveRequest.Leave_Start_Date__c
                                                             AND Date__c <=: leaveRequest.Leave_End_Date__c
                                                             AND (IsHoliday__c=true OR IsWeekend__c=true)];
                
                for (Integer i = 0; i < sanergyCalendar.size(); i++) {
                    
                    if(sanergyCalendar.get(i).Weekday_Name__c == 'Saturday' || sanergyCalendar.get(i).Weekday_Name__c == 'Sunday'){
                        countWeekends+=1; 
                    }else if(sanergyCalendar.get(i).IsHoliday__c==true && sanergyCalendar.get(i).IsWeekend__c==false){
                        countHolidays+=1;
                        
                    }                               
                    
                    System.debug('DAY: ' + sanergyCalendar.get(i).Weekday_Name__c);
                    System.debug('NO. OF WEEKENDS: ' + countWeekends);
                    System.debug('NO. OF HOLIDAYS: ' + countHolidays);
                }
                // Get no. of leave days after deduction
                NoOfDays = NoOfDays - countWeekends - countHolidays;
                
                //Update no. of leave days requested
                leaveRequest.No_Of_Leave_Days_Requested__c = NoOfDays;
                leaveRequest.No_Of_Approved_Leave_Days__c = NoOfDays;
                
                System.debug('NO. OF LEAVE DAYS AFTER DEDUCTION: ' + leaveRequest.No_Of_Leave_Days_Requested__c);           
            }
            
        }
    }
}