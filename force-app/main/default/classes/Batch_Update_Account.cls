public class Batch_Update_Account implements database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT id, Name FROM Account'; 
        return Database.getQueryLocator(query); 
    }
    
    public void execute(Database.BatchableContext BC, List<account> accList){
        for(account acc: accList){
            System.debug('acc'+acc);
            acc.name = acc.name.removeEnd('batch');
          //  acc.Name = acc.Name+' batch';
        }
        update accList; 
    }
    
    public void finish(Database.BatchableContext BC){
        System.debug('inside in finish methods ');
    }
    

}