public class CaseobjectClass {
    @AuraEnabled
    public static List<account> getAcclountRecord(){
        List<account> accList = new List<account>();
        accList =[SELECT id, name from account];
        return accList;
    }
    
    @auraEnabled
    public static List<AccountContactRelation> getAccountContactRalationRecords(String AccountId){
        try{
            List<AccountContactRelation> conList= new list<AccountContactRelation>();
            conList = [SELECT Id, contact.Name, AccountId, contactId FROM AccountContactRelation WHERE AccountId = :AccountId];
            System.debug('conList --> '+conList);
            if(!conList.isEmpty()){
                return conList;
            }else{
                return null;
            }
            
        }catch(Exception e){
            System.debug('Error--> '+e.getMessage()+' line --> '+e.getLineNumber());
            return null;
        }
    }
}