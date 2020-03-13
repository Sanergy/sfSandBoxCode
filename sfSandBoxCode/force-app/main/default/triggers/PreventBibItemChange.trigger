trigger PreventBibItemChange on Opportunity_BIB_Item__c (before update, before delete) {    
    
    if(Trigger.isDelete){
        for(Opportunity_BIB_Item__c bib: Trigger.old){
            if(bib.Approved__c == true){
                bib.adderror('You are not permitted to delete a BIB Item once it has been approved!');
            }//End if(bib.Approved__c == true)   
        }//End for(Opportunity_BIB_Item__c bib: Trigger.old) 
    }
}