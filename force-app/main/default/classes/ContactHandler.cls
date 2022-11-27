public class ContactHandler {
    public static void afterinsert(List<contact> conList){
        try{
            System.debug('inside in contact ');
            Set<Id> accIdSet = new Set<Id>();
            Map<Id, String> accmap = new map<Id, String>();
            for(contact accId : conList){
                accIdSet.add(accId.accountId);
            }
            for(account acc: [SELECT id, name from Account WHERE Id IN:accIdSet]){
                accmap.put(acc.Id,acc.Name);
            }  
            for(Contact con : conList){
                con.accountName__c = accmap.get(con.AccountId);
            }
            System.debug(' ConList -> '+conList);  
        }catch(Exception e){
            System.debug('Error ->'+e.getMessage());
        }
    }
    
    public static void updateAccountfield(List<contact> conList){
        try{
             Set<Id> accIdSet = new Set<Id>();
            Map<Id, String> accmap = new map<Id, String>();
            for(contact accId : conList){
                accIdSet.add(accId.accountId);
            }  
            List<Account> AccList = new List<account>();
            AccList =[SELECT Id, Name,(SELECT Id FROM Contacts) FROM Account WHERE Id IN:accIdSet];
            
             List<Account> AccList1 = new List<account>();
            AccList1 =[SELECT Id, Name,(SELECT Id FROM Contacts WHERE checktrue__c =true) FROM Account WHERE Id IN:accIdSet]; 
        }catch(Exception e){
            System.debug('error -> '+e.getMessage());
        }
    }
    
    public static void preventDulicate(List<contact> conList){
        try{
            Map<String, contact> phoneMap= new map<String, contact>();
              Map<String, contact> EmailMap= new map<String, contact>(); 
            for(contact con : conList){
                if(con.phone != null){
                    phoneMap.put(con.Phone, con);
                } 
                if(con.Email != null){
                     EmailMap.put(con.Email, con);
                }
            }
            
            List<contact> conListnew = new List<Contact>();
             conListnew = [SELECT Id,phone,Email FROM Contact where Email IN:EmailMap.keySet() ANd Phone IN: phoneMap.keyset()];
            if(conListnew.size()>0){
                for(contact con :conListnew){
                    if(con.Email ==EmailMap.get(con.Email).email){
                        con.addError(EmailMap.get(con.Email).Id+' Have same Email Id');
                    } 
                     if(con.phone ==EmailMap.get(con.phone).phone){
                       con.addError(EmailMap.get(con.phone).Id+' Have same phone Id');

                    }
                }
            } 
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage()+' At line -> '+e.getLineNumber());
        }
    }
    
     public static void OnAfterInsert( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap ) {
		Set<Id> accountIds = new Set<Id>();
        for(Contact conRecord : newContact){
			accountIds.add(conRecord.AccountId);
		}	
		updateCount(accountIds);
    }

    public static void OnAfterUndelete( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap ) {
		Set<Id> accountIds = new Set<Id>();
        for(Contact conRecord : newContact){
			accountIds.add(conRecord.AccountId);
		}	
		updateCount(accountIds);
    }

    public static void OnAfterUpdate( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap ) {
		Set<Id> accountIds = new Set<Id>();
        for(Contact conRecord : newContact) {
            if(conRecord.AccountId != oldContactMap.get(conRecord.Id).AccountId) {
                accountIds.add(conRecord.AccountId);
                accountIds.add(oldContactMap.get(conRecord.Id).AccountId);
            }
        }    
		updateCount(accountIds);
    }
	
    public static void OnAfterDelete( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap )
    {
		Set<Id> accountIds = new Set<Id>();
        for(Contact conRecord : oldContact ){
            accountIds.add(conRecord.AccountId);
		}	
		updateCount(accountIds);
    }
	
	
	public static void updateCount( Set<Id> accountIds ) {
	
		if(accountIds.size() > 0) {
			List<Account> accountList = [SELECT count_Contact__c, (SELECT Id FROM Contacts) FROM Account WHERE Id in: accountIds];
			if(accountList.size() > 0){
				for(Account accRecord : accountList)
				{
					accRecord.count_Contact__c = accRecord.Contacts.size();
				}	
				UPDATE accountList;
			}
		}
    }	

}