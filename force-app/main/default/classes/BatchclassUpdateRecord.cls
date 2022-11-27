public class BatchclassUpdateRecord implements Database.Batchable<sObject> {
    
    public  Database.QueryLocator start(Database.BatchableContext bc){
        String accList = 'SELECT Id,Name FROM account';
        return Database.getQueryLocator(accList);
    }
    
    public void execute(Database.BatchableContext bc, List<account> accLIst){
        
        for(account acc : accList){
            acc.Name = acc.Name = acc.Name+' 1';
        } 
        update accList;
        
    }
    public void finish(database.BatchableContext bc){
        System.debug(' record Update ');
    }
}