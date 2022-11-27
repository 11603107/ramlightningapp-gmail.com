public class CreteAccountWhenmorethenNContact {
    
    public static void createAccount(){
        try{
            List<AggregateResult> aggList = getAggregaterecord();
            System.debug('aggList -> '+aggList.size());
            
        }catch(Exception e){
            System.debug('Exception -> '+e.getMessage()+' line -> '+e.getLineNumber());
        }
    }
    public static List<AggregateResult> getAggregaterecord(){
        try{
             List<AggregateResult> aggnewList = [SELECT AccountId, count(Id) from Contact group by AccountId HAVING COUNT(Id) > 2];
            return  aggnewList;
            
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage()+ ' line -> '+e.getLineNumber());
            return null;
        }
    }

}