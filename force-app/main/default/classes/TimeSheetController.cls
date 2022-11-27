public class TimeSheetController {

    @AuraEnabled(cacheable=true)
    public static List<TimeSheetLineItem__c> getTimeSheetData(String currentDate){
        try{
                System.debug('date --> '+currentDate);
            List<TimeSheetLineItem__c> timeSheetList = new List<TimeSheetLineItem__c>();
            timeSheetList = [SELECT Id, Time_Sheet__c,billable_hours__c,Project_Name__c,decription__c,ProjectDat__c, Created_Date__c  FROM TimeSheetLineItem__c WHERE Created_Date__c =:currentDate];
               System.debug('data --> '+ timeSheetList);
               
                return timeSheetList;
        }catch(Exception e){
            System.debug('error --> '+e.getMessage());
            return null;
        }
    }

     @AuraEnabled
    public static boolean  insertTimeSheetLine(TimeSheetLineItem__c timeSheetObj){

            Database.SaveResult results = Database.insert(timeSheetObj, true);
            System.debug('data --> '+results.isSuccess());
            return results.isSuccess();
    }

}