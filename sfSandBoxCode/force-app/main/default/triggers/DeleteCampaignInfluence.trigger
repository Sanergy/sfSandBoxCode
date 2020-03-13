trigger DeleteCampaignInfluence on Toilet_Campaign__c (before delete) 
{
	List<Toilet_Campaign__c> ToiletCam=new List<Toilet_Campaign__c>();
    if (Trigger.isBefore) 
    {
	    if (Trigger.isDelete) {
	
	        // In a before delete trigger, the trigger accesses the records that will be 
	    
	        // deleted with the Trigger.old list. 
	    
	        for (Toilet_Campaign__c a : Trigger.old) 
	        {
	             ToiletCam.add(a);
	        }
	        List<Campaign_Influence__c> CamInfluence=[select id from Campaign_Influence__c where Toilet_Campaign__c in:ToiletCam Limit 200];
	        if(CamInfluence.size()>0)
	         delete CamInfluence;
	    }
    }
}