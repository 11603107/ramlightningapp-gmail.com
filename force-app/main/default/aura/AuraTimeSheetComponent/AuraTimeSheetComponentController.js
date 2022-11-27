({
    doInit : function(component, event, helper) {
        console.log('insode in doint ');
        component.set('v.callLWC', true); 
    },
    createRecord:  function(component, event, helper){
        try{
            console.log('date --> '+event.getParam('currentdate'));
            var createAcountContactEvent = $A.get("e.force:createRecord");
             createAcountContactEvent.setParams({
                "entityApiName": "TimeSheetLineItem__c",
                "defaultFieldValues": {
                    'Created_Date__c' : event.getParam('currentdate')
                      
                }
            });
            createAcountContactEvent.fire();  
        }catch(err){
            console.log('error--> '+err);
        }
    },
    
    getValueFromLwc : function(component, event, helper) {
        try{ 
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId":event.getParam('recordId')  
            });
            editRecordEvent.fire(); 
            
        }catch(error){
            console.log('error--> '+error);
        }
        
    },
    toastInfo: function(component, event, helper) {
        console.log('message  --> '+event.getParams().message);
        $A.get('e.force:refreshView').fire();
    }
})