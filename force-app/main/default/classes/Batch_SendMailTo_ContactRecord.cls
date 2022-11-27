public class Batch_SendMailTo_ContactRecord implements database.Batchable<sObject> {
    map<Id, contact> comMapnew =  new Map<Id, contact>();
    
   public  Batch_SendMailTo_ContactRecord(Map<Id, contact> conMap){
        comMapnew = conMap;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('inside in start method');
         return Database.getQueryLocator([SELECT Id,Name, Email FROM contact where Id IN :comMapnew.keySet()]);
    } 
    
    public void execute(database.BatchableContext BC, List<contact>conList){
        for(contact con: conLIst){
            System.debug('inside in Execute method ');
              Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
               email.setToAddresses(new string[] {con.email});
               email.setSubject('Welcome Mail');
               email.setPlainTextBody('Welcome Your Contact Is Created Successfully In Salesforce Name '+con.Name+ ' Id -> '+con.Id);
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        } 
    }
    public void finish(database.batchableContext BC){
        system.debug(' finally block '); 
    } 
}