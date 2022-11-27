({
    doint_helper : function(component, event, helper) {
        try{
            console.log('inside in helper'); 
            var action = component.get('c.getAccountData');
            action.setCallback(this , function(responce) {
                var accdata = responce.getReturnValue(); 
                console.log('Data--> 1'+JSON.stringify(accdata));
                component.set("v.accList", accdata);
                console.log(' AFTER Data--11> '+component.get('v.accList'));
            });
            $A.enqueueAction(action); 
        }catch(err){
            console.log('error--> '+err);
        } 
    },

    onclickonButton_helper: function(component, event, helper){
        try{
            var AccId = event.getSource().get("v.value"); 
            console.log('data--> '+AccId);
                 component.set('v.AccountId',AccId);
                 component.set('v.callParentComponent', true);
                 console.log('data--> '+component.get('v.callParentComponent'));
        }catch(err){
            console.log('error--> '+err);
        }
    }
})