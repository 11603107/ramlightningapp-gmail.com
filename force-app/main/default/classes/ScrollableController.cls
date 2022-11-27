public class ScrollableController {
@AuraEnabled
public static IOWrapperClass getIODetails(String recordId){
    try{
        IOWrapperClass wrapperIOInstance = new IOWrapperClass();
        List<String> ioStageNames= new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : picklistValues){
            ioStageNames.add(pickListVal.getLabel());
        }    
        System.debug('ioStageNames::'+ioStageNames);

        for(Opportunity opportunityInstance : [SELECT Id,Name,StageName FROM Opportunity WHERE Id =:recordId LIMIT 1]) {
            wrapperIOInstance.opportunityRecord = opportunityInstance;
        }
        wrapperIOInstance.ioStageNames = ioStageNames;
        return wrapperIOInstance;

    }catch(Exception e){
        throw new AuraHandledException(e.getLineNumber() +' '+ e.getMessage());
    }
}

public class IOWrapperClass{
    @AuraEnabled
    public Opportunity opportunityRecord {get;set;}

    @AuraEnabled
    public List<String> ioStageNames {get;set;}
}

}