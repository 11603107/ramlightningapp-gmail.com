({
    doint : function(component, event, helper) {

        try{
            helper.doint_helper(component, event, helper);
        }catch(err){
            console.log('error--> '+err.message());
        }

    },
    onclickonButton : function(component, event, helper){
        helper.onclickonButton_helper(component, event, helper);
    }
})