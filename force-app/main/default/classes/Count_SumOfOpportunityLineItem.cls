public class Count_SumOfOpportunityLineItem { 
    public static void getSumOfOppList(){
        List<AggregateResult> sumofAmount = new List<AggregateResult>();
        sumofAmount = [SELECT OpportunityId, count(id) SumAmount FROM OpportunityLineItem group by OpportunityId]; 
        System.debug('Size -> '+sumofAmount.size());
        List<OpportunityLineItem> itemLis =[SELECT id, OpportunityId from OpportunityLineItem];
        System.debug('Opp Id -> '+itemLis.size()); 
        for(Opportunity opp: [SELECT id FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM OpportunityLineItem)]){
            System.debug('Id ->qqqq '+opp);
        }
        for(AggregateResult  amount :sumofAmount ){
            System.debug(amount.get('OpportunityId'));
            System.debug(amount.get('OpportunityId')+' ---> '+amount.get('SumAmount'));
            System.debug(amount.get('SumAmount'));
        }
        
        List<aggregateResult> oppAmount = new List<aggregateResult>();
        oppAmount =[SELECT accountId, sum(amount) amount, AVG(amount) amount1 from Opportunity group by accountId];
        for(aggregateResult acc:oppAmount){
            System.debug(acc.get('accountId')+' ---> '+acc.get('amount')+' --> '+acc.get('amount1'));
        }
        
        List<opportunity> oppList = new List<opportunity>();
        OppList = [SELECT Id , (select Id, opportunityId from opportunityLineItems) FROM Opportunity];
        Map<Id, Integer> oppMap = new Map<Id, Integer>();
        
        
        for(Opportunity opp : oppList){
            oppMap.put(opp.Id, opp.opportunityLineItems.size());
            //System.debug(opp.Id+' size  --> '+opp.opportunityLineItems.get('opportunityId')));
        }
        
        for(Id mapKey :oppMap.keySet()){
            System.debug(mapKey+'   --> '+oppMap.get(mapKey));
        }
        
        Map<Id, List<contact>> MapOfAccount = new Map<Id, List<contact>>();
        
        for(contact con : [SELECT Id, AccountId,Name from contact]){
            
           if(MapOfAccount.containsKey(con.AccountId)){
                MapOfAccount.get(con.AccountId).add(con);
           }else{
               MapOfAccount.put(con.AccountId, new List<contact>{con});
           }
        }
        for(LIst<contact> con : MapOfAccount.values())
        {
            System.debug('size -> '+con.size());
        }
    }

}