public class OpportunityHandler {
    public static void updateOpportunity(List<Opportunity> OppList, List<opportunity> oppOldMap){
        System.debug('old map -> '+oppOldMap);
        System.debug('insid in class');
         Set<Id> oppOldAccId = new set<Id>();
        for(opportunity opp : oppOldMap){
            oppOldAccId.add(opp.accountid);
        } 
        Set<Id> oppAccId = new set<Id>(); 
        for(opportunity opp : oppList){
            oppAccId.add(opp.accountid);
        }  
        for(account acc: [SELECT id, Name,(SELECT Id from opportunities) from account WHERE Id IN:oppAccId OR Id IN: oppOldAccId]){
            System.debug(acc.Id + 'size0--> '+acc.opportunities.size());
        } 
    }

}