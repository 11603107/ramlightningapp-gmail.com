({
    fireComponentEvent_helper : function(component, event, helper) {
        try{
            console.log('inside in helper of parent component --> ');
            var accountId = component.get('v.AccountId');
            console.log('inside in helper of parent component --> '+accountId);
            var compEvent  = component.getEvent('getAccountId');

            var action = component.get('c.getAllContact');
            action.setParams({'AccountId':accountId});
            action.setCallback(this, function(res){
                console.log('get state--> '+res.getState());
                if(res.getState() =='SUCCESS'){
                    console.log('insite  state--> '+res.getState());
                    var conData = res.getReturnValue(); 
                    component.set('v.ConList',conData);

                    console.log('Con data -->  '+res.getReturnValue());
                }
                compEvent.setParams( { ConList : cmp.get("v.ConList") } );
                compEvent.fire();
            });
            $A.enqueueAction(action); 

        }catch(ere){
            console.log('we  error-->  '+ere);
        }

    }
})