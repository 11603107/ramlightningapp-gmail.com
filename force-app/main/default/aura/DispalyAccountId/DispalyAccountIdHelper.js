({
    doint_helper : function( component, event, helper) {
        try{
            console.log('inside in helper'); 
            var action = component.get('c.getAccountData');
            action.setCallback(this , function(responce) {
                var accdata = responce.getReturnValue(); 
                console.log('Data--> 1'+accdata);
                component.set("v.AccList",accdata);
                console.log(' AFTER Data--> '+JSON.stringify(component.get('v.AccList')));
            });
            $A.enqueueAction(action); 
        }catch(err){
            console.log('error--> '+err);
        } 
    },
    
    onclickonButton: function(component, event, helper){
        try{
            console.log('inside in helper11');
            var AccId = event.getSource().get("v.value"); 
            console.log('Acc Id--> '+AccId);
           var compEvent = $A.get("e.c:CompEventAccData");
          
              console.log('compEvent --> '+compEvent);
            
            compEvent.setParams({"AccountId" : AccId}); 
             compEvent.fire();
           
            
        }catch(err){
            console.log('error--> '+err);
        }
        
        
    }
})