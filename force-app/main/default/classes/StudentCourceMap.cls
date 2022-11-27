public class StudentCourceMap {
    
    public static void getstudetdetails(){
        Map<Id, List<String>> studentMap = new Map<Id, List<String>>(); 
        Map<Id, List<String>> courceMap= new map<Id, List<String>>();
        Map<Id,student__c> studentNameMap =  new Map<Id, student__c>([SELECT id,Name from student__c ]);
        Map<Id, course__c> courceNameMap = new Map<Id, course__c>([SELECT Id,Name from course__c]);
        List<studentHistory__c> junctionList =  new List<studentHistory__c>();         
        for(studentHistory__c  junobject : [ SELECT Id, Name, course__c,course__r.Name,student__r.Name,  student__c from studentHistory__c]){
            junctionList.add(junobject);
        } 
        for(studentHistory__c mapobje : junctionList){
            if(mapobje.student__c != null){
                if(courceMap.containsKey(mapobje.course__c)){
                     courceMap.get(mapobje.course__c).add(mapobje.student__r.Name);
                }else {
                    courceMap.put(mapobje.course__c, new List<String>{mapobje.student__r.Name});
                }
            } 
            
            if(mapobje.course__c != null){
                if(studentMap.containsKey(mapobje.student__c)){
                   studentMap.get(mapobje.student__c).add(mapobje.course__r.Name); 
                }else { 
                     studentMap.put(mapobje.student__c, new List<String>{mapobje.course__r.Name}); 
                } 
            }
        } 
        
        System.debug('Cource -> ');
        for(Id courdIbj :courceMap.keyset()){
            System.debug(courceNameMap.get(courdIbj).Name+' --> '+courceMap.get(courdIbj)); 
        } 
         System.debug('student  -> ');
        for(Id studentObj :studentMap.keyset()){
            System.debug(studentNameMap.get(studentObj).Name+' --> '+studentMap.get(studentObj)); 
        } 
    } 
}