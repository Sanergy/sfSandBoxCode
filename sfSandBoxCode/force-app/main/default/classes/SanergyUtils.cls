global class SanergyUtils {
    public static Double monthsBetween(Date startDate, Date endDate){
        Double monthsBetween=0.0;
        Double varDbl=1.0;
        Integer daysInMonth1=0;
        Integer daysInMonth2=0;
        Double daysInStartMonth=0.0;
        Double daysInEndMonth=0.0;
        Integer years=0;
        Integer fullMonthsBetween=0;
        
        //Month the leave begins
        if(startDate.year() == endDate.year() && startDate.month() == endDate.month()){
                        daysInMonth1 = date.daysInMonth(startDate.YEAR(),startDate.MONTH());

                daysInStartMonth=(startDate.daysBetween(endDate)+1)/(daysInMonth1*varDbl);
        }else{            
            daysInMonth1 = date.daysInMonth(startDate.YEAR(),startDate.MONTH());
            daysInStartMonth = (daysInMonth1 - startDate.day())/(daysInMonth1*varDbl);           
        }              
       
        System.debug('DAYS IN START MONTH: ' + daysInStartMonth);
        
        //Months between start & end date
        years = (endDate.year() - startDate.year())*12;
        System.debug('YEARS: ' + years);
        
        if(endDate.year() > startDate.year()){
            //years = years + endDate.month();
            years = years + (endDate.month()-1);
            fullMonthsBetween = years - startDate.month();
        	System.debug('FULL MONTHS BETWEEN one: ' + fullMonthsBetween);
            
        }else{
            years=0;
            if(endDate.month() - startDate.month() < 2){
                fullMonthsBetween=0;
            }
            else{
                fullMonthsBetween = (endDate.month() - startDate.month()) - 1;
            }           
            System.debug('FULL MONTHS BETWEEN two: ' + fullMonthsBetween);            
        }
        
        //Month the leave ends
        if(startDate.year() == endDate.year() && startDate.month() == endDate.month()){
            daysInEndMonth=0;
        }else{
            daysInMonth2 = date.daysInMonth(endDate.YEAR(),endDate.MONTH());
            daysInEndMonth = (endDate.day())/(daysInMonth2*varDbl);
            
            //Check if leave start date and leave end date are in different years
            if(startDate.year() < endDate.year()){
               daysInEndMonth=0; 
            }//End if(startDate.year() < endDate.year())         
        }
        System.debug('DAYS IN END MONTH: ' + daysInEndMonth);
		monthsBetween = daysInStartMonth + daysInEndMonth +  fullMonthsBetween;
        System.debug('MONTHS BETWEEN: ' + monthsBetween);
        
        //Return months between
        return monthsBetween;        
    }
    
    public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd, Boolean includeWeekends) {
       //Add or decrease in BusinessDaysToAdd days 
       //Runs from the Sanergy Calender object, pay attention to the ordering is a +/-ve number of days is provided
       Date finalDate = StartDate ;
       List<Sanergy_Calendar__c> sanergyCal;
       if(BusinessDaysToAdd > 0){
           sanergyCal = [
               				//Do not copy and paste without reference to the sorting
                           SELECT id, Date__c 
                           FROM Sanergy_Calendar__c 
                           WHERE (Date__c >= : StartDate AND isBusinessDay__c  = TRUE AND IsHoliday__c = FALSE)  
                           OR (Date__c >= : StartDate  AND isBusinessDayInclSat__c = : includeWeekends AND Weekday_Name__c <>'Sunday' AND IsHoliday__c = FALSE) 
                           ORDER BY Date__c ASC LIMIT : BusinessDaysToAdd  // ORDER ASC  !!!
           				];
       } else if (BusinessDaysToAdd < 0){
           sanergyCal = [
               			//Do not copy and paste without reference to the sorting
                           SELECT id, Date__c 
                           FROM Sanergy_Calendar__c 
                           WHERE (Date__c <= : StartDate AND isBusinessDay__c  = TRUE AND IsHoliday__c = FALSE)  
                           OR (Date__c <= : StartDate  AND isBusinessDayInclSat__c = : includeWeekends AND Weekday_Name__c <>'Sunday' AND IsHoliday__c = FALSE) 
                           ORDER BY Date__c DESC LIMIT : BusinessDaysToAdd * -1    //needs to be a non negative value AND ORDER DESC  !!!
           				];
       }
       
       //if records found
       if(sanergyCal != NULL && sanergyCal.size() > 0){
           //last date in the list will always be the date to return
           system.debug('Last Date' + sanergyCal.get(sanergyCal.size()-1).Date__c);
           finalDate = sanergyCal.get(sanergyCal.size()-1).Date__c;
       }
	

       return finalDate;
    }
    
    //Function to round off to nearest integer
    //65.08 return 65; 65.12 return 66
    public static Long KRARound (decimal val){
        if (Math.abs(val - val.intValue()) >= 0.1){
            return val.round(System.RoundingMode.CEILING);
        }else
        {
            return val.intValue();
        }
    }
    
    //Function to generate a One Time Passcode
    public static String generateOTP(Integer OTPLength, Boolean OTPCaseSensitive ) {
        String chars = '';
        Integer charsLength = 0;
        //if case sensitive include lower case letters
        if(OTPCaseSensitive == TRUE){
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
            charsLength = 62;
        }else {
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            charsLength = 36;
        }
            
        String strOTP = '';
        while (strOTP.length() < OTPLength) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), charsLength);
            strOTP += chars.substring(idx, idx+1);
        }
        return strOTP;
    }
    
/*
Sanergy, Inc. (NP)		
Fresh Life Initiative Limited		
Sanergy, Inc. (FP)		
   */     
    //return string list object of FFAConfigValues name, id, lookup_ID__c
    public static List<String> GetFFAConfigCompanyName(String CompanyName){
        switch on companyName {
            when 'Sanergy Limited', 'Sanergy Ltd', 'Sanergy Ltd.' 
            { return new List<String> {'Sanergy Limited', 'aEBD0000000k9yMOAQ', 'a19D00000026xGa'}; }
            when 'Fresh Life Initiative Limited', 'Fresh Life Initiative Ltd', 'Fresh Life Initiative Ltd.' 
            { return new List<String> {'Fresh Life Initiative Limited',	'aEBD0000000kA4jOAE', 'a19D00000026xHv'}; }
            when 'Sanergy Inc. (FP)', 'Sanergy Inc (FP)', 'Sanergy Inc (FP).' 
            { return new List<String> {'Sanergy, Inc. (FP)', 'aEBD0000000kA4oOAE', 'a19D0000004Tbl1'}; }
            when 'Sanergy Inc (NP)', 'Sanergy, Inc. (NP)', 'Sanergy, Inc (NP)'
            { return new List<String> {'Sanergy, Inc. (NP)', 'aEBD0000000kA4tOAE', 'a19D0000004vTfL'}; }
        }
        return null;
    }
    
    @future 
    public static void AssignEmpToBambooHRPermSet(Id EmpId)
    {
        Employee__c emp = [SELECT Id,Employee_SF_Account__c, Employee_Active__c
                                    FROM Employee__c 
                                    WHERE Id =: EmpId
                                   ];
        if(emp != NULL && emp.Employee_Active__c == TRUE && emp.Employee_SF_Account__c != NULL){
            //add to permission set
            PermissionSet BambooHRPermSet = [SELECT Id,Name FROM PermissionSet WHERE Name = 'BambooHR'];
            if(BambooHRPermSet != NULL){
                //check if user already assigned to Permission Set
                AggregateResult[] aggPerm = 
                    [SELECT COUNT(AssigneeId) Assigned FROM PermissionSetAssignment WHERE PermissionSet.Name = 'BambooHR' AND AssigneeId =: emp.Employee_SF_Account__c];
                Integer rowCount =  (aggPerm[0].get('Assigned') != null) ? Integer.valueOf(aggPerm[0].get('Assigned')) : 0 ;
                if(rowCount == 0){ //no assignments, proceed to assign
                    PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = BambooHRPermSet.Id, AssigneeId = emp.Employee_SF_Account__c);
                    INSERT psa;  
                }
                
            }   
        }
    }
    
    //method to clone documents from one object to another	
    public static Boolean CloneAttachments(Set<Id> SourceDocsIds, Id DestinationObjectID, String NewFilePrefix){
        //set variables
        Boolean attFound = TRUE;
        Integer attIndex = 0;
        Boolean attachSuccess = FALSE;
        NewFilePrefix = NewFilePrefix == '' ? '[**]: ' : NewFilePrefix + ' ';
        //Get the associated PR IDs to this PO
        List<Attachment> attachments = [
            SELECT id, Name, Body, BodyLength
            FROM Attachment
            WHERE ParentID IN : SourceDocsIds
        ];
        
        //Get current attachments on the PO
        List<Attachment> currDocAttachments = [
            SELECT id, Name, Body, BodyLength
            FROM Attachment
            WHERE ParentID =: DestinationObjectID
        ];  
        
        System.debug('attachments >>' + attachments +  '**** currPOAttachments >>>>' + currDocAttachments);
        //Create list of attachments
        List<Attachment> attachmentsToInsert = new List<Attachment>();
        for(Attachment file : attachments) {
            Attachment newFile = file.clone();
            newFile.ParentId = DestinationObjectID;
            newFile.Name = NewFilePrefix + file.Name;
            newFile.Body = file.body;
            
            attachmentsToInsert.add(newFile);    
        }
        /* 
            //to avoid duplication check if name and body length is the same
            attFileDuplicate = TRUE;
            for(Attachment ati : attachmentsToInsert){
                //system.debug('ati = ' + ati);
                //system.debug('file = ' + file);
                if(newFile.Name == ati.name && newFile.BodyLength == ati.BodyLength){
                    system.debug('in here ');
                    attFileDuplicate = TRUE;
                break;
                }else{
                    attFileDuplicate = FALSE; 
                }
            }
        */
        system.debug('attachmentsToInsert = ' + attachmentsToInsert);
        //Clone List to insert
        List<Attachment> attachmentsToInsertFinal = currDocAttachments.clone();
        //Clear list and get ready to insert
        attachmentsToInsertFinal.clear();  
        
        //if there aren't any attachments in the current PO then we can insert without need to search for duplicates
        if(currDocAttachments == NULL || currDocAttachments.size() == 0){
            //clone attachments list
            attachmentsToInsertFinal = attachmentsToInsert.clone();
        }else {
            //Check if any duplicates existing
            for(Attachment att : attachmentsToInsert  ){
                system.debug('ffff' + att.Name);
                //loop through attachments to insert. If does not exist, add to final list
                
                //Set Default
                attFound = TRUE;
                for(Attachment attToIns : currDocAttachments){
                    if(attToIns.Name == att.Name){
                        system.debug ('attToIns.Name == att.Name: ' + attIndex + ' >> '  + attToIns.Name + ' ** ' + att.Name);
                        attFound = TRUE;
                        break;
                    }else {
                        //Not found to be added
                        attFound = FALSE;
                    }
                }
                if(attFound == FALSE){
                    //add item
                    attachmentsToInsertFinal.add(att); 
                }
            }
        }
        // finally, insert the cloned attachments
        system.debug('attachmentsToInsert = ' + attachmentsToInsertFinal);
        try{
            if(attachmentsToInsertFinal != NULL && attachmentsToInsertFinal.size()>0){
                insert attachmentsToInsertFinal; 
                attachSuccess = TRUE;
            }
        }
        catch (Exception e){
            system.debug('Failed to attach documents = ' + e.getMessage());
            attachSuccess = FALSE;
        }
         
        return attachSuccess;
    }
    
    
    public static Boolean CloneNotes(Set<Id> SourceDocsIds, Id DestinationObjectID, String NewFilePrefix){
        //set variables
        Boolean noteFound = TRUE;
        Integer attIndex = 0;
        Boolean attachSuccess = FALSE;
        NewFilePrefix = NewFilePrefix == '' ? '[**]: ' : NewFilePrefix + ' ';
        
        //copy over Notes from PRs
        List<Note> notes = [
            SELECT Body,Id,OwnerId,ParentId,Title
            FROM Note
            WHERE ParentID IN :SourceDocsIds
        ];
        
        //Get current attachments on the Current Document
        List<Note> currDocNotes = [
            SELECT Body,Id,OwnerId,ParentId,Title
            FROM Note
            WHERE ParentID =: DestinationObjectID
        ];  
        
        //Create list of Notes
        List<Note> notesToInsert = new List<Note>();
        for(Note poNote : notes) {
            Note newNote = poNote.clone();
            newNote.ParentId = DestinationObjectID;
            newNote.Title = NewFilePrefix + poNote.Title;
            newNote.Body = poNote.body;
            
            notesToInsert.add(newNote);    
        }
       
        //Clone List to insert
        List<Note> notesToInsertFinal = currDocNotes.clone();
        //Clear list and get ready to insert
        notesToInsertFinal.clear();  
        
        //if there aren't any Notes in the current PO then we can insert without need to search for duplicates
        if(currDocNotes == NULL || currDocNotes.size() == 0){
            //clone NOtes list
            notesToInsertFinal = notesToInsert.clone();
        }else {
            //Check if any duplicates existing
            for(Note nt : notesToInsert ){
                //loop through notes to insert. If does not exist, add to final list
                
                //Set Default
                noteFound = TRUE;
                for(Note noteToIns : currDocNotes){
                    if(noteToIns.Title == nt.Title){
                        noteFound = TRUE;
                        break;
                    }else {
                        //Not found to be added
                        noteFound = FALSE;
                    }
                }
                if(noteFound == FALSE){
                    //add item
                    notesToInsertFinal.add(nt); 
                }
            }
        }
        // finally, insert the cloned notes
        try{
            if(notesToInsertFinal != NULL && notesToInsertFinal.size()>0){
                insert notesToInsertFinal; 
                attachSuccess = TRUE;
            } 
        }
        catch (Exception e) {
            system.debug('Failed to attach documents = ' + e.getMessage());
            attachSuccess = FALSE;
        }
        return attachSuccess;
    }

    public static Boolean CloneGoogleDocs(Set<Id> SourceDocsIds, Id DestinationObjectID, String NewFilePrefix){
        //set variables
        Boolean gDocFound = TRUE;
        Integer attIndex = 0;
        Boolean attachSuccess = FALSE;
        NewFilePrefix = NewFilePrefix == '' ? '[**]: ' : NewFilePrefix + ' ';
        //copy over GoogleDocs from Objects
        //Using Group BY to get distinct URL.
        AggregateResult[] gDoc = 
            [SELECT  MAX(Name)GDocName, URL 
             FROM GoogleDoc 
             WHERE ParentId IN :SourceDocsIds
             GROUP BY URL 
            ];
        
        //Get current Google Docs on the Current Object
        Set<GoogleDoc> currDocGDocs = new Set<GoogleDoc>([
            SELECT URL
            FROM GoogleDoc
            WHERE ParentID =: DestinationObjectID
        ]);  
        
         //Create list of GoogleDoc
        List<GoogleDoc> gDocsToInsert = new List<GoogleDoc>();
        
        if (gDoc != NULL && gDoc.size() > 0){
            for(AggregateResult ar : gDoc){
                //if currDocGDocs empty then insert all
                if(currDocGDocs == NULL || currDocGDocs.size() == 0){
                    GoogleDoc newGDoc = new GoogleDoc();
                    newGDoc.ParentId = DestinationObjectID;
                    newGDoc.Name = NewFilePrefix + ar.get('GDocName') ;
                    newGDoc.url = String.valueOf(ar.get('Url'));
                    gDocsToInsert.add(newGDoc);
                }else
                {
                    //Loop through an check if another Doc with same URL exists
                    gDocFound = TRUE;
                    for(GoogleDoc gd: currDocGDocs){
                        if(gd.Url == ar.get('Url')){
                            gDocFound = TRUE;
                            break;
                        } else {
                            gDocFound = FALSE;
                        }                 
                    }
                    if(gDocFound == FALSE){
                        GoogleDoc newGDoc = new GoogleDoc();
                        newGDoc.ParentId = DestinationObjectID;
                        newGDoc.Name = NewFilePrefix + ar.get('GDocName') ;
                        newGDoc.url = String.valueOf(ar.get('Url'));
                        gDocsToInsert.add(newGDoc);
                    }
                }
            }      

        }

        // finally, insert the cloned Google Docs
        try{
            if(gDocsToInsert != NULL && gDocsToInsert.size()>0){
                insert gDocsToInsert; 
                attachSuccess = TRUE;
            } 
        }
        catch (Exception e){
            system.debug('Failed to attach documents = ' + e.getMessage());
            attachSuccess = FALSE;
        }
        return attachSuccess;
    }  
    
    public static String IsSandBox(){
        List<organization> lstOrganization = [Select id,instanceName,isSandbox FROM Organization];
        if(lstOrganization.size()>0) {
            if(lstOrganization[0].isSandbox) {
                return 'YES';
            } else 
            {
                return 'NO';
            }
        }
        return 'UNKNOWN';
    }
}