trigger TriggerOnContact on Contact (after insert,after update, after delete) { 
    /* if(trigger.isInsert && trigger.isBefore){
       System.debug('inside in trigger ');
        List<contact> conList = new List<contact>();
        for(contact con: trigger.new){
            if(con.AccountId != null){ 
                System.debug('con.Account.Name -> '+con.Account.Name);
                System.debug('Id-> '+con.AccountId);
                con.accountName__c =con.Account.Name;
                conList.add(con);
            }
       }
        if(conList.size()!=0){
           // ContactHandler.afterinsert(conList);
           ContactHandler.updateAccountfield(conList);
        }
       // insert conList;
        System.debug('record inserted ');  
      // ContactHandler.preventDulicate(trigger.new);
        
    }
    if(trigger.isInsert && trigger.IsAfter){
        if(StopTrigerr.runonce()){
            List<contact> conList =new List<contact>();
            conList = trigger.new.deepClone();
            insert conList;
            
        }
    }*/
    
     // ContactTriggerHandler handler = new ContactTriggerHandler();
	if(Trigger.isDelete){
		ContactHandler.OnAfterDelete(trigger.new,trigger.old,Trigger.newMap,trigger.oldMap);
    }else if(Trigger.isInsert ){
		ContactHandler.OnAfterInsert(trigger.new,trigger.old,Trigger.newMap,trigger.oldMap);
	
	}else if(Trigger.isUndelete){
		ContactHandler.OnAfterUndelete(trigger.new,trigger.old,Trigger.newMap,trigger.oldMap);
	
	} else if(Trigger.isUpdate){
		ContactHandler.OnAfterUpdate(trigger.new,trigger.old,Trigger.newMap,trigger.oldMap);
	}

}