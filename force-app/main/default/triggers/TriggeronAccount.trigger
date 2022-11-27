trigger TriggeronAccount on Account (after update) {
    if(Trigger.isInsert && trigger.isAfter){
        set<Id> accId = new Set<Id>();
        for(Account acc: trigger.new){
            accId.add(acc.Id);
        }
        Account_handler.accoutUpdateAmount(accId);
    } 
    
      if(Trigger.isUpdate && trigger.isBefore){
        set<Id> accId = new Set<Id>();
        for(Account acc: trigger.new){
            accId.add(acc.Id);
        }
       // Account_handler.accoutUpdateAmount(accId);
    } 
}