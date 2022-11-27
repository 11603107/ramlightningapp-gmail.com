public class Account_handler {
    public static void updateOpportunity(Set<Id> accSet){ 
        DateTime day30=system.now()-30; 
        List<opportunity> oppList = new List<opportunity>(); 
        oppList = [SELECT Id, Name, stageName, CloseDate from opportunity where StageName = 'Closed Won'];
        for(opportunity opp :[SELECT Id, Name,AccountId,  stageName, CloseDate from opportunity where StageName = 'Closed Won' AND AccountId IN :accSet] ){
            if(opp.CloseDate >day30 ){
                opp.StageName= 'Closed Lost';
                opp.CloseDate =system.today();
               oppList.add(opp); 
            }
        }
        update oppList;
    } 
   
     public static void accoutUpdateAmount(Set<Id> accSet){
        try{
             Map<Id, integer> oppmap = new map<id, integer>();
            for(opportunity opp: [SELECT AccountId, amount FROM Opportunity WHERE id IN : accSet]){
                if(oppmap.containskey(opp.AccountId)){
                    integer amount1 = Integer.valueOf(opp.amount);
                    integer sum = amount1+oppmap.get(opp.AccountId);
                    oppmap.put(opp.AccountId, sum); 
                }else  {
                     oppmap.put(opp.AccountId, Integer.valueOf(opp.Amount));
                }
            } 
            List<account> accList = new List<account>();
            for(Account acc: [SELECT Id, Sum_fo_opportunity_amount__c FROM Account WHERE Id IN:accSet]){
                acc.Sum_fo_opportunity_amount__c = oppmap.get(acc.Id);
                accList.add(acc);
            }
            insert accList;
        }catch(Exception e){
            System.debug('error -> '+e.getMessage()+' line -> '+e.getLineNumber());
        }
    }

}