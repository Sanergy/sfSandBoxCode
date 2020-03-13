trigger RollupSumOfAmountFromOpportunityToLocation on Opportunity (after delete, after insert, after undelete, 
after update) {
//Limit the size of list by using Sets which do not contain duplicate elements
  set<id> locationIds = new set<id>();
 
  //When adding new Opportunities or updating existing Opportunities
  if(trigger.isInsert || trigger.isUpdate){
    for(Opportunity opp : trigger.new){
      locationIds.add(opp.Location__c);
    }
  }
 
  //When deleting Opportunities - add undelete
  if(trigger.isDelete){
    for(Opportunity opp : trigger.old){
      locationIds.add(opp.Location__c);
    }
  }
 
  //Map will contain one Location Id to one sum value
  map<id,Double> locationMap = new map<id,Double> ();
 
  //Produce a sum of Opportunities and add them to the map
  //use group by to have a single Location Id with a single sum value
  for(AggregateResult q : [select Location__c,sum(Amount)
    from Opportunity where Location__c IN :locationIds group by Location__c]){
      locationMap.put((Id)q.get('Location__c'),(Double)q.get('expr0'));
  }
 
  List<Location__c> locationsToUpdate = new List<Location__c>();
 
  //Run the for loop on Location using the non-duplicate set of Location Ids
  //Get the sum value from the map and create a list of Locations to update
  List<Location__c> locList = [Select Id, Total_Price__c from Location__c where Id IN :locationIds];  
  
  for(Location__c loc : locList ){
    Double TotalPrice = locationMap.get(loc.Id);
    loc.Total_Price__c = TotalPrice;
    locationsToUpdate.add(loc);
  }
 
  update locationsToUpdate;

}