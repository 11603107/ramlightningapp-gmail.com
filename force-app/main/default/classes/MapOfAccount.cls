public class MapOfAccount {
    
    
    public static void getMapOfAccount(){
        Map<Id, List<contact>> MapOfAccount = new Map<Id, List<contact>>();
        Map<Id, contact> conmap = new Map<Id, contact>();
        for(contact con : [SELECT Id, AccountId,Name from contact]){
            conmap.put(con.Id,con);
           if(MapOfAccount.containsKey(con.AccountId)){
                MapOfAccount.get(con.AccountId).add(con);
           }else{
               MapOfAccount.put(con.AccountId, new List<contact>{con});
           }
        }
    }

}