Public with sharing class TimeSheetApexClass {
    
    
    @AuraEnabled(cacheable=true)
    public static Wrapperclass fatchRecords(string nameOfTiemSheet){
        try{
            System.debug('name--> '+nameOfTiemSheet);
            Wrapperclass wrapperobject = new Wrapperclass();
            List<Billing_Project__c> proList = new List<Billing_Project__c>();
            List<Billing_Task__c> takList = new List<Billing_Task__c>();
              List<Billing_newTimeSheet__c> timeSheetList  = new List<Billing_newTimeSheet__c>();
            List<user> userList = new List<user>();
            user userobj = new user();
            timeSheetList = [SELECT Id, Name, Billing_Project__r.name, Fri__c, mon__c, project_Task__c, row__c,Sat__c,Sun__c,Thu__c,Total__c,Tue__c, Wed__c,Billing_TimeSheet__r.name  FROM Billing_newTimeSheet__c WHERE Billing_TimeSheet__r.name =:nameOfTiemSheet  ORDER BY row__c ASC LIMIT 5000];
            
            proList = [SELECT Id, Name FROM Billing_Project__c LIMIT 10000];
            takList = [SELECT Id, Name FROM Billing_Task__c LIMIT 10000];
            userList = [SELECT Id, Name FROM user LIMIT 50000];
            userobj = [SELECT Id , Name from user where Id =:UserInfo.getUserId()];
            
            System.debug(proList);
            System.debug(takList);
            if(proList != null){
                wrapperobject.porojectList = proList; 
            }
            if(takList != null){
                wrapperobject.taskList = takList;
            }
            if(userList != null){
                wrapperobject.userList = userList;
                wrapperobject.userobj = userobj;
                
            }
            if(timeSheetList != null){
                 wrapperobject.timeSheetList = timeSheetList;
            }
            System.debug('data--> '+ wrapperobject.porojectList);
            
            return wrapperobject;
            
        }catch(Exception e){
            System.debug('error --> '+e.getMessage());
            return null;
        }
        
        
    }
    
    public class Wrapperclass{
        @AuraEnabled 
        public  List<Billing_Project__c> porojectList {get;set;}
        @AuraEnabled 
        public List<Billing_Task__c> taskList {get;set;}
        @AuraEnabled 
        public List<user> userList {get;set;}
        @AuraEnabled 
        public user userobj {get;set;}
         @AuraEnabled 
        public List<Billing_newTimeSheet__c>  timeSheetList {get;set;}
        
    }
    
    @AuraEnabled
    public static WrapperInsertEntry createtimeSheetrecord(Billing_TimeSheet__c timeSheetObject, List<Billing_newTimeSheet__c> listOfNewTimeSheet) {
        try{
            Boolean timeSheetStatus = false;
            Boolean timeSheetEntryStatus = false;
            WrapperInsertEntry timeSheetObj = new WrapperInsertEntry();

            System.debug('data -->1 '+timeSheetObject.Name+' size() --> '+listOfNewTimeSheet.size());
            Id timeSheetId = null;
            List<Billing_TimeSheet__c> timeSheet = new List<Billing_TimeSheet__c>();
            timeSheet = [SELECT Id, Name FROM Billing_TimeSheet__c WHERE Name =: timeSheetObject.Name];

           
          
            if(timeSheet.isEmpty()){
                Database.SaveResult results = Database.insert(timeSheetObject, true);
                System.debug('data --> '+results.isSuccess());
                if(results.isSuccess() == true){
                    timeSheetId =  results.getId();
                    timeSheetStatus=  results.isSuccess(); 
                }
               
            }else{
                timeSheetId = timeSheet[0].Id;
                timeSheetStatus=  true;
            }
            System.debug('timeSheetId--> '+timeSheetId);
            List<Billing_newTimeSheet__c> updatetimeSheet = new List<Billing_newTimeSheet__c>();
            List<Billing_newTimeSheet__c> inserttimeSheet = new List<Billing_newTimeSheet__c>();
            System.debug('tike sheet --> '+listOfNewTimeSheet.size()+' --> Id  '+timeSheetId);
            for(Billing_newTimeSheet__c newtimeSheet : listOfNewTimeSheet){
                 System.debug('indide in forr loop '+newtimeSheet.Billing_TimeSheet__c);
                if( newtimeSheet.Billing_TimeSheet__c == null){
                     newtimeSheet.Billing_TimeSheet__c = timeSheetId;
                    inserttimeSheet.add(newtimeSheet);
                }else
                {
                    updatetimeSheet.add(newtimeSheet);
                }
               
            }
           System.debug('update list --> '+updatetimeSheet);
           Database.SaveResult [] upList = Database.update(updatetimeSheet, false);

            for(Database.SaveResult  updateobj : upList) {
             if (updateobj.isSuccess()) {
                 // Operation was successful, so get the ID of the record that was processed
                 System.debug('Successfully deleted account with ID: ' + updateobj.getId());
                 timeSheetEntryStatus = true;
             }
             else {
                 // Operation failed, so get all errors                
                 for(Database.Error err : updateobj.getErrors()) {
                     System.debug('The following error has occurred.');                    
                     System.debug(err.getStatusCode() + ': ' + err.getMessage());
                     System.debug('Account fields that affected this error: ' + err.getFields());
                     timeSheetEntryStatus = false;
                 }
             }
            }
 
            
           
            Database.SaveResult[] srList = Database.insert(inserttimeSheet, false); 
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) { 
                    System.debug('Successfully inserted TimeSheet Record.  ID: ' + sr.getId());
                    timeSheetEntryStatus = true;
                }
                else { 
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('time sheet fields that affected this error: ' + err.getFields());
                        timeSheetEntryStatus =false;
                        break;
                    }
                }
            } 
            timeSheetObj.timeSheet = timeSheetStatus;
            timeSheetObj.timeSheetEntry = timeSheetEntryStatus;

            return timeSheetObj;
 
        }catch(Exception e){
            System.debug('error --> '+e.getMessage()+' line --> '+e.getLinenumber());
            return null; 
        }
    }
    public class WrapperInsertEntry{
        @AuraEnabled
        public boolean timeSheet{get;set;}

        @AuraEnabled
        public boolean timeSheetEntry{get;set;}
    }

    @AuraEnabled

    public static Boolean deleteRowOfTimeSheet(List<Billing_newTimeSheet__c> deleteList, List<Billing_newTimeSheet__c> updateList){
        try {
           System.debug('data --> '+updateList);
           System.debug( ' delete-> '+deleteList);
           

           Database.DeleteResult[] delList = Database.delete(deleteList, false);

           for(Database.DeleteResult dr : DelList) {
            if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted account with ID: ' + dr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred in delete .');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }


            Database.SaveResult [] upList = Database.update(updateList, false);

            for(Database.SaveResult  updateobj : upList) {
             if (updateobj.isSuccess()) {
                 // Operation was successful, so get the ID of the record that was processed
                 System.debug('Successfully update  account with ID: ' + updateobj.getId());
             }
             else {
                 // Operation failed, so get all errors                
                 for(Database.Error err : updateobj.getErrors()) {
                     System.debug('The following error has occurred. in update ');                    
                     System.debug(err.getStatusCode() + ': ' + err.getMessage());
                     System.debug('Account fields that affected this error: ' + err.getFields());
                 }
             }
            }
            return null;

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}