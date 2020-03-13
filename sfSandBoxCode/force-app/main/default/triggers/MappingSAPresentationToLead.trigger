trigger MappingSAPresentationToLead on Lead (before insert) {
    for(Lead l:Trigger.new){
      
        if(l.Presented_to__c !=null){
           if(l.Presented_to__c=='Commercial Renting Land'){
                l.Franchise_Type__c='Commercial';
            }else if(l.Presented_to__c=='Head Teacher' ){
                l.Franchise_Type__c='School';
            }else if(l.Presented_to__c=='Landlord'){
                l.Franchise_Type__c='Plot';
            }
            
     	 } 

        //Generate One Time Passcode
        l.Payment_Reference_ID__c = SanergyUtils.generateOTP(9,FALSE);
	        
     }

}