({
	doInit_helper : function(c,e,h) {
        
        console.log('inside in helepr ');
        var action = c.get("c.getAcclountRecord");
        action.setCallback(this, function (response) {
                var check = response.getReturnValue();
                   console.log("return values--> "+response.getReturnValue());
                var state = response.getState();
                if (state === "SUCCESS") {
                     console.log('data--' +response.getReturnValue());
                    c.set('v.AccList',response.getReturnValue());
                    
                    console.log('data1--> '+c.get('v.accList'));
                }
            });
            $A.enqueueAction(action);
    } ,
    
    getContactRelatedAccount_helper: function(c,e,h){
        try{
             console.log('inside in getContactRelatedAccount_helper helepr'); 
         var recordId = e.getSource().get("v.value");
        
        console.log('data -> '+recordId);
            var action = c.get('c.getAccountContactRalationRecords');
            action.setParams({"AccountId":recordId});
            
            action.setCallback(this, function (response) {
                var check = response.getReturnValue();
                   console.log("return values--> "+response.getReturnValue());
                var state = response.getState();
                if (state === "SUCCESS") {
                     console.log('data--' +response.getReturnValue());
                    c.set('v.ConList',response.getReturnValue());
                    
                    console.log('data1--> '+JSON.stringify(c.get('v.ConList')));
                }
            });
            $A.enqueueAction(action);
            
        }catch(err){
            console.log('error in helper---> '+err);
        }
    }
})