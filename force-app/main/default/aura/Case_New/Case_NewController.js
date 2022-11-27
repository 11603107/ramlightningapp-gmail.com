({
	doInit : function(c, e, h) {
		h.doInit_helper(c,e,h);
	},
    getContactRelatedAccount : function(c,e,h){
        try{
            console.log('inside in controller ');
        h.getContactRelatedAccount_helper(c,e,h);
        }catch(err){
            console.log('error--> '+err);
        }
    },
      closeModel :function(c,e,h)
      {
          console.log('inside in close');
     var urlEvent = $A.get("e.force:navigateToURL");
     urlEvent.setParams({
        "url": 'lightning/o/Case/list?filterName=Recent'
    });
     urlEvent.fire();
     },
    
      
})