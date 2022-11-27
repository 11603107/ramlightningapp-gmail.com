public class Batch_GetSumOfAmoung implements database.Batchable<sObject>, Database.Stateful{
    
    public Decimal sumAmountofOpportunity = 0; 
    public Database.QueryLocator start(database.BatchableContext BC){ 
        return Database.getQueryLocator([SELECT Id, Name, Amount from Opportunity]);
        
    }
    public void execute(database.BatchableContext BC, List<Opportunity> oppList){
        try{ 
        for(Opportunity opp : oppList){  
            sumAmountofOpportunity = sumAmountofOpportunity +opp.Amount;
        } 
        }catch(Exception e){
            System.debug('error -> '+e.getMessage()+ ' line --> '+e.getLineNumber());
            system.debug('---'+e.getCause());
        }
    }
    
    public void finish(database.BatchableContext BC){
        System.debug('inside in finish method '); 
        System.debug(' sum --> '+sumAmountofOpportunity);
        
    }

}