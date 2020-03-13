trigger CountTeamMemberRole on Opportunity (before insert, before update)
{
//
//Boolean TeamMemberRole;
//Integer iCount;

//check if the Team Role is needed and add it to the Count_TM_Role map

//Map<Id, Opportunity> Count_TM_Role = new Map<Id, Opportunity>();
//for (Integer i = 0; i < Trigger.new.size(); i++) 
//{
//        Count_TM_Role.put(Trigger.new[i].id,
//        Trigger.new[i]);      

//}
//iCount = 0;
//for (List<OpportunityTeamMember> oppcntctrle2 : [select OpportunityId from OpportunityTeamMember where (OpportunityTeamMember.OpportunityId in :Count_TM_Role.keySet())])//Query for Contact Roles
//{    
// if (oppcntctrle2 .Size()>0)
// {
// iCount= oppcntctrle2 .Size();     
// }
//}
//Check if  roles exist in the map or team member role role isn't required 
//
//for (Opportunity Oppty : system.trigger.new) 
//{
//Oppty.Count_TM_Role__c = iCount;
// 
//}
}