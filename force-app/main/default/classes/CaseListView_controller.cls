public class CaseListView_controller {
    @AuraEnabled
    public static CaseWrapper fetchCaseRecords(){
        try {
            CaseWrapper caseWrapper = new CaseWrapper();
            List<Case> caseList =  new List<Case>(); 
            for(Case taskObject : [SELECT Id,CaseNumber ,AccountId, Account.Name, OwnerId,Owner.Name ,Status,CreatedDate  FROM Case]){
                caseList.add(taskObject);
            }
            List<String> StageValuesList= new List<String>();
            Schema.DescribeFieldResult fieldResult = case.Status.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                StageValuesList.add(pickListVal.getLabel());
            }  
            caseWrapper.caseList= caseList;
            caseWrapper.StageValuesList= StageValuesList; 
            return caseWrapper; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 
    
    public Class CaseWrapper{
        @AuraEnabled
        public List<case> caseList {get;set;}
        @AuraEnabled
        public List<String> StageValuesList {get;set;}

    }
 @AuraEnabled
    public static List<case> fetchCaseRecordBySort(String fieldName){
        try{
            System.debug('fieldApiName--> '+fieldName);
            String query = 'SELECT Id,CaseNumber ,AccountId, Account.Name, OwnerId,Owner.Name ,Status,CreatedDate  FROM Case ORDER BY '+fieldName+' desc';
           // return [SELECT Id,CaseNumber ,AccountId, Account.Name, OwnerId,Owner.Name ,Status,CreatedDate  FROM Case ORDER BY :fieldApiName ASC];

           List<case> caseList = new List<case>();

           for(case caseObj : Database.Query(query)) {
                    caseList.add(caseObj);
                }
                return caseList;

        }catch(Exception e){
          System.debug('Error ->'+e.getMessage()+' line -> '+e.getLineNumber());
          return null;
        }
    }

}