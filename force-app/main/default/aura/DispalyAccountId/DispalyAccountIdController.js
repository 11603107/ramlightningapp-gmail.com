({
	doint : function(component, event, helper) {
        console.log('inside in controller ');
        helper.doint_helper(component, event, helper);
		
	},
    
    onclickonButton: function(component, event, helper){
        helper.onclickonButton(component, event, helper);
    }
})