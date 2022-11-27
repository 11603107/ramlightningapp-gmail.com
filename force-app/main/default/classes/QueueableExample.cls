public with sharing class QueueableExample implements Queueable {
private set<Id> accSetId;
public QueueableExample(Set<Id> accList) {
    System.debug('inside in contatruceteuryfewvbrwvbq vgv');
    this.accSetId = accList;
} 
public void execute(queueableContext qc){
   try{
    System.debug('in side in queueqble class '+this.accSetId);
    Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
    List<user> userList = new List<user>();
    for(account acc:[SELECT id, Name from account WHERE Id IN: This.accSetId]){
        User objUser = new User(); 
        objUser.FirstName=acc.Name;
        objUser.LastName = 'Samal';
        objUser.Alias = 'Biswa';
        objUser.Email = 'itzbiswajeet@gmail.com';
        objUser.Username = acc.Name.deleteWhitespace()+'@gmail.com';
        objUser.ProfileId = profileId.id;
        objUser.TimeZoneSidKey = 'GMT';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.EmailEncodingKey = 'UTF-8';
        objUser.LocaleSidKey = 'en_US'; 
        userList.add(objUser);
    } 
    for(user us: userList){
        System.debug(' user -> '+us);
        }
insert userList;

   }catch(Exception e){
    System.debug('error -> '+e.getMessage()+' at line --> '+e.getLineNumber());
   } 
} 

@future
public  static  void insertuser(Set<Id> accId){
    try{
        System.debug('in side in queueqble class '+accId);
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        List<user> userList = new List<user>();
        for(account acc:[SELECT id, Name from account WHERE Id IN: accId]){
            User objUser = new User(); 
            objUser.FirstName=acc.Name;
            objUser.LastName = 'Samal';
            objUser.Alias = 'Biswa';
            objUser.Email = acc.Name.deleteWhitespace()+'@gmail.com';
            objUser.Username = acc.Name.deleteWhitespace()+'@gmail.com';
            objUser.ProfileId = profileId.id;
            objUser.TimeZoneSidKey = 'GMT';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.EmailEncodingKey = 'UTF-8';
            objUser.LocaleSidKey = 'en_US'; 
            userList.add(objUser);
        } 
        for(user us: userList){
            System.debug(' user -> '+us);
            }
    insert userList;
    
       }catch(Exception e){
        System.debug('error -> '+e.getMessage()+' at line --> '+e.getLineNumber());
       } 

}

@future
public static void jsonFutureMethod(String jsonAccount){
    List<account> accLIst = new List<account>();
    System.debug('String -> '+jsonAccount);
      accLIst = (List<Account>)Json.deserialize(jsonAccount,List<Account>.class);
      System.debug(' account -> '+accLIst);

}
}