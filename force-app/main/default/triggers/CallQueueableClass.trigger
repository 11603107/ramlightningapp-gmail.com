trigger CallQueueableClass on Account (after insert) {
    System.debug(' account -> '+trigger.new); 
   if(trigger.isinsert && trigger.isafter){
    System.debug(' account -> '+trigger.new); 
    String jsonAccount = json.serialize(trigger.new);
    System.debug('account --> '+jsonAccount);
    QueueableExample.jsonFutureMethod(jsonAccount); // calling future method with JSON sObject
//     set<Id> accId = new Set<Id>();
//     for(account acc: trigger.new){
//         accId.add(acc.Id);
//     }
//    // System.enqueueJob(new QueueableExample(accId)); // call Queueable class from trigger
//      QueueableExample.insertuser(accId);   // Call Future method from Trigger 
//     //  database.executeBatch(new BatchClassNAme(conMap));   // Call batch class from atrigger

 
   }
    
    if(trigger.isinsert && trigger.isBefore){
        set<Id> accIdSet = new set<Id>();
        
        for(account accObj : trigger.new){
            accIdSet.add(accObj.Id);
        }
    }

}