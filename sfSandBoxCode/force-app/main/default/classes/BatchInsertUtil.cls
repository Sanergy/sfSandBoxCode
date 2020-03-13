global class BatchInsertUtil implements Database.Batchable<sObject>,Database.Stateful
{
    
    List<sObject> listObjects;

    //constructor
    public BatchInsertUtil (List<sObject> listObjects){
        this.listObjects=listObjects;
    }
    
    
    //start
    global Iterable<sObject> start(Database.BatchableContext BC){
            return listObjects;
    }


    //execute
    global void execute(Database.BatchableContext BC, List<sObject> listObjects)
    {
        insert listObjects;
    }  
    
    
    //finish
    global void finish(Database.BatchableContext BC){
      
    }
}