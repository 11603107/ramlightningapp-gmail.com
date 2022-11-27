public class BatchClassInsertRecord implements Database.Batchable<sObject>{
    public List<account> start(Database.BatchableContext bc){  
        List<account> acclist = new List<account>();
        for(integer i=0;i<500000;i++){
            account acc = new account();
            acc.Name='Ram '+i;
            accList.add(acc);
        } 
        return accList;  
    }
    public void execute(Database.BatchableContext ac, List<account> accList){
        if(accList.size()>0){
            insert accList;
        }
    }
    public void finish(Database.BatchableContext bc){
        
    }

}