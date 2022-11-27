({
	showAccountValue : function(component, event, helper) {
        try{
              console.log('inside controller');
        var AccountId = event.getParam("AccountId");
        
        console.log('Account Id--> '+AccountId);
        var action = component.get('c.getAccountRecord');
        
        console.log('type--> '+typeof AccountId);
        action.setParams({"AccountId" : AccountId});
        
        action.setCallback(this, function(response) {
         try{
            console.log('response--->'+response.getState());
            console.log('account-->11 '+JSON.stringify(response.getReturnValue()));
            if(response.getState() =="SUCCESS")  { 
                console.log(' inside getState response--->'+response.getState());
                var accountData = response.getReturnValue();
                console.log('data---> '+ accountData);
                //component.set("v.AccList",accdata );
                component.set("v.AccountRecord",accountData);
                console.log('data---> ');
            }else{
                console.log('We are in Else part');
            }

         }catch(error){
             console.log('error--> '+err);
         }
            
        });
            $A.enqueueAction(action);
        }catch(err){
            console.log('error--> '+err);
        }
 
        
	}
})