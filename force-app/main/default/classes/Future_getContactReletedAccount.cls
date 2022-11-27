public class Future_getContactReletedAccount { 
    Public Static void getAccount(){
        Set<Id> accId = new Set<id>();
        for(Account acc: [SELECT id from Account]){
            accId.add(acc.Id);
        }
        getContact(accId);
    } 
    @future
    Public Static void getContact(Set<Id> accId){
        System.debug('insde in future method');         
        Map<id, List<contact>> conMap = new Map<Id, List<contact>>(); 
        for(Contact con : [SELECT Id,Name, Accountid FROM Contact WHERE Accountid IN:accId]){
            if(conMap.containsKey(con.Accountid)){
                conMap.get(con.accountId).add(con);
            }else {
                conMap.put(con.Accountid, new  List<contact>{con});
            }
        }
        System.debug('Map -> '+conMap);
    }

}