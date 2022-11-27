public class TimeSheetnewComponentController {

    @AuraEnabled
    public static List<TimeSheetLineItem__c> fetchDate( String  currentdate){
        try{

            System.debug('date --> '+currentdate);
                 List<TimeSheetLineItem__c> timeSheetList = new List<TimeSheetLineItem__c>();
            timeSheetList = [SELECT Id, Time_Sheet__c,billable_hours__c,Project_Name__c,decription__c,ProjectDat__c, Created_Date__c  FROM TimeSheetLineItem__c WHERE Created_Date__c =:currentdate];
               System.debug('data --> '+ timeSheetList);
            return timeSheetList;

        }catch(Exception e){
           
          System.debug('error --> '+e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static boolean  insertTimeSheetLine(TimeSheetLineItem__c timeSheetObj){

           try{
               System.debug('inside in insert  data');
                Database.SaveResult results = Database.insert(timeSheetObj, true);
            System.debug('data --> '+results.isSuccess());
            System.debug('Result --> '+results.isSuccess());
            return results.isSuccess();

           }catch(Exception e){
              System.debug('error --> '+e.getMessage());
            return null;
           }
    }


    



}