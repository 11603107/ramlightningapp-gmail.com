({
    fireComponentEvent : function(component, event, helper) {
        console.log("we are in controller ");
        helper.fireComponentEvent_helper(component, event, helper);

    }
})