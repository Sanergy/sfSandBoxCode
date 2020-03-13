trigger PopulateCampaignonCollectionData on Campaign_Influence__c (after delete, after insert, after update) 
{
    //List<String> CollectionIds=new List<string>();
    Set<String> CollectionIds=new Set<string>();
    Map<Id,list<String>> Events=new Map<Id,list<String>>();
    Map<Id,list<String>> ToiletCampaigns=new Map<Id,list<String>>();
    
   if(trigger.isInsert || trigger.isUpdate) 
   { 
        for(Campaign_Influence__c c:trigger.new)
        {
            CollectionIds.add(c.Collection_Data__c);    
        }
   }
   if(trigger.isDelete)
   {
        for(Campaign_Influence__c c:trigger.old)
        {
            CollectionIds.add(c.Collection_Data__c); 
               
        }
   }
    
    List<Campaign_Influence__c> CampaignRecordsList=[select id,Collection_Data__c,Event_Tool__c,Toilet_Campaign__r.Name from Campaign_Influence__c where Collection_Data__c in:CollectionIds order by createddate limit 5];
    if(CampaignRecordsList.size()>0 && CampaignRecordsList!=null)
    {
        for(Campaign_Influence__c c:CampaignRecordsList)
        {
            if(c.Event_Tool__c!=null && c.Event_Tool__c!='')
            {
                if(!Events.keyset().contains(c.Collection_Data__c))      
                {              
                    Events.put(c.Collection_Data__c, new List<string>{c.Event_Tool__c});
                }           
                else
                {              
                    Events.get(c.Collection_Data__c).add(c.Event_Tool__c)  ;         
                }
            }
            if(c.Toilet_Campaign__r.Name!=null && c.Toilet_Campaign__r.Name!='')
            {
                if(!ToiletCampaigns.keyset().contains(c.Collection_Data__c))      
                {              
                    ToiletCampaigns.put(c.Collection_Data__c, new List<string>{c.Toilet_Campaign__r.Name});
                }           
                else
                {              
                    ToiletCampaigns.get(c.Collection_Data__c).add(';'+c.Toilet_Campaign__r.Name)  ;         
                }
            }
                     
        }
        
    }
        string AllEvents='',AllToiletCampaigns='';
        List<Collection_Data__c> CollectionList=[select id,Campaigns_Influencing__c,Campaign_Tools_Influencing__c from Collection_Data__c where id in :CollectionIds limit 1000];
        if(CampaignRecordsList.size()>0 && CampaignRecordsList!=null)
        {
            for(Collection_Data__c c:CollectionList)
            {
                
                if(Events.keyset().contains(c.id))
                  {                   
                     for(string is : Events.get(c.id))                  
                        {
                         AllEvents+=is;
                        }
                  }   
                  if(ToiletCampaigns.keyset().contains(c.id))
                  {                   
                     for(string is : ToiletCampaigns.get(c.id))                  
                        {
                         AllToiletCampaigns+=is;
                        }
                  }   
                
                c.Campaign_Tools_Influencing__c=AllEvents;   
                c.Campaigns_Influencing__c=AllToiletCampaigns;
                AllEvents='';
                AllToiletCampaigns='';
            }
        }
        else
        {
            for(Collection_Data__c c:CollectionList)
            {
                c.Campaign_Tools_Influencing__c='';   
                c.Campaigns_Influencing__c='';
            }
        }
        if(CollectionList.size()>0)
            update CollectionList;
    
    
}