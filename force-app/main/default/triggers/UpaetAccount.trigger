trigger UpaetAccount on Opportunity (after insert, after update, after delete) {

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete){  
            ZoximaAssignment.updateAccountFiel(trigger.new); 
        }
    }
    
}