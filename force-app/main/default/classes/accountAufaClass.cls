public class accountAufaClass {
    
    @AuraEnabled
    public static List<account> getAccountData(){
        Return [SELECT Id,Name,Website, Phone  FROM Account];
    }
    
    
     @AuraEnabled
    public static List<account> getAccountRecord(String AccountId){
    
        try{

            System.debug('inside in getAccountRecord ');
                System.debug('accountId--> '+AccountId);
        
         List<account> accList = new  List<account>();
        accList =  [SELECT Id,Name FROM Account WHERE Id =:AccountId ];

        System.debug('accList--> '+accList);
        if(!accList.isEmpty()){
            System.debug('accList--> return  '+accList);
            return accList;
        }else{
            return null;
        }
        
            
        }catch(Exception e){
            System.debug('Error--> '+e.getMessage()+ ' line--> '+e.getLineNumber());
            return null;
        }
            
        }  

        @AuraEnabled
        public static List<contact> getAllContact(String AccountId){
            try {
                    System.debug('Account Id--> '+AccountId);
                List<contact> conList = new List<contact>();
                conList= [SELECt id, LastName , accountId from contact Where accountId =:AccountId];
                System.debug('Account Id--> '+conList);
                return conList;
                
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
}