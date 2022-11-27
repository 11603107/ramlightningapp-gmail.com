public class Batch_SumOfOPPLineQuentity implements database.Batchable<sObject>,Database.Stateful { 
    private  set<id> oppsetId = new set<id>(); 
    private boolean callBatch = false;
    public Batch_SumOfOPPLineQuentity(Set<Id> oppsetId) {
        this.oppsetId = oppsetId;
    } 
    public Database.QueryLocator start(database.BatchableContext BC){ 
        System.debug('inside in start method --> '+this.oppsetId);
        System.debug('');
        return Database.getQueryLocator([SELECT Id, Name, Quantity__c from Opportunity WHERE Id NOT IN : this.oppsetId LIMIT 5]); 
    }
    public void execute(database.BatchableContext BC, List<Opportunity> oppList){
        try{
            System.debug('sieze -> '+oppList.size()); 
            Set<Id> OppSet = new set<Id>();
            for(Opportunity opp : oppList){ 
                System.debug('opp-> '+opp.Quantity__c);
                OppSet.add(opp.Id);
                this.oppsetId.add(opp.Id);
            }  
            Map<Id,AggregateResult> mapOfOpportuntLineItem = new Map<id,AggregateResult>([SELECT OpportunityId Id, SUM(Quantity) sum FROM OpportunityLineItem Where  OpportunityId IN: OppSet group by OpportunityId]);
            for(opportunity opp : oppList){
                System.debug('Sum -> '+mapOfOpportuntLineItem.get(opp.Id));
                if(mapOfOpportuntLineItem.get(opp.Id) != null){
                    System.debug('sum -> '+integer.valueOf(mapOfOpportuntLineItem.get(opp.Id).get('sum')));
                    opp.Quantity__c =integer.valueOf(mapOfOpportuntLineItem.get(opp.Id).get('sum'));
                } 
            } 
            update oppList;
            List<opportunity> oppListnew =[ SELECT Id from Opportunity Where Id NOT IN : this.oppsetId]; 
            if(!oppListnew.isEmpty()){
                callBatch = true; 
            }else {
                callBatch = false;
            }   
        }catch(Exception e){
            System.debug('Exception e -> '+e.getMessage()+ ' line --> '+e.getLineNumber());
        }
    } 
    public void finish(database.BatchableContext BC){ 
        System.debug('inside in finish methids ');
        System.debug('opp id -> '+this.oppsetId);
 
        if(callBatch == true){ 
            Batch_SumOfOPPLineQuentity batchClassCall = new Batch_SumOfOPPLineQuentity(this.oppsetId);
            Database.executeBatch(batchClassCall); 
        }  
    }
}