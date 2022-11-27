/* Name : Ram Niwas Verma
 * date : 24/07/2022
 * */

public class ZoximaAssignment {
    public static void updateAccountFiel(List<opportunity> OppListfromTrigger){
        Set<Id> accSet = new Set<Id>();
        for(Opportunity oppObj : OppListfromTrigger){
            accSet.add(oppObj.accountId);
        }
        
        List<AggregateResult> oppList = new List<AggregateResult>(); 
        oppList =[SELECT AccountId, avg(amount) avgAmount from Opportunity WHERE AccountId IN : accSet group by AccountId ];  // getting aal opportunity using Aggregate Query
         Map<Id, integer> MapOfOppAmount = new map<Id,integer>();
        for(AggregateResult agg : oppList){
            system.debug('Resilt -> '+agg.get('AccountId')+' ---> '+ agg.get('avgAmount'));
            String AccId = String.valueOf(agg.get('AccountId'));
            integer sumOfAmount =  integer.valueOf(agg.get('avgAmount'));
             MapOfOppAmount.put(String.valueOf(agg.get('AccountId')), integer.valueOf(agg.get('avgAmount'))); // Map of Account Id and Avg if Opportunit Amount
        }
        
        List<account> accList = new List<account>();
        for(Account acc:[SELECT Id, Name, Account_lable__c from account]){  
            integer sumofAmount =  MapOfOppAmount.get(acc.Id); 
            // applying condtions
            if(sumofAmount> 10000){
                System.debug(sumofAmount+' > 10000');
                acc.Account_lable__c = 'Key account';
            }else if(sumofAmount > 5000 && sumofAmount < =10000){ 
                System.debug(sumofAmount+' > 5000 '+sumofAmount +' <== 10000 ');
                acc.Account_lable__c = 'Engage account';
            }else
            {
                System.debug(sumofAmount +'inside in else');
                acc.Account_lable__c = 'Low engagement account';
            } 
            accList.add(acc);
        }   
        update accList;  // updateing record 
    }

}