trigger CountOpportunity on Opportunity (after insert,after delete,after update,after undelete) {
    System.debug('inside in trigger');
    if(trigger.isafter){
        system.debug('inside in if condition');
        if(trigger.isUpdate || trigger.isinsert || trigger.isDelete || trigger.Isundelete){ 
            System.debug('inside in other if');
               OpportunityHandler.updateOpportunity(trigger.new, trigger.old);  
        } 
    } 

}