public with sharing class ApiCallOutClass {
    public ApiCallOutClass() {

    }

    public static void getAccessToke(String userName, String orgPassword){
      try{
        System.debug('User Name -> '+userName+' --> '+orgPassword); 
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setBody('grant_type=password' + '&username='+userName + '&password='+orgPassword+'&client_id=3MVG9wt4IL4O5wvL.QSYaml0UyFfNy5CpRgY3udgLHI2LZejEXUpr3OJpYIoYO8u480tQG6ZzRYVD0_wCvf2K'+'&client_secret=06714D35C59A0846EDD4537C4B88A23CA372CAE12469A796D539A6B38B7DB236');
        Http h = new Http();
       HTTPResponse res = h.send(req);
       System.debug('Body ' + res.getBody());
       System.debug('Status ' + res.getStatus());
        System.debug('Status code ' + res.getStatusCode()); 
        String strResponse = res.getBody();
        System.debug('res get body -> '+strResponse);
        Map<String,Object> newMap = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
        //String tkn = (List<Object>) newMap.get('value');
        string token= String.valueOf(newMap.get('access_token'));
        System.debug('Access token '+token);
        System.debug('Id -> '+UserInfo.getSessionID().substring(15)); 
        System.debug(UserInfo.getOrganizationId().substring(0, 15) + ' ' +  UserInfo.getSessionId().substring(15)); 
      }catch(Exception e){
        System.debug('error -> '+e.getMessage()+ ' at line number -> '+e.getLineNumber());
      } 
    }

    public static void getObjectRecord(){
        try{ 
            String accessToken = UserInfo.getOrganizationId().substring(0, 15) + ' ' +  UserInfo.getSessionId().substring(15);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://cloudanalogy-e4-dev-ed.my.salesforce.com/services/data/v42.0/query/?q=SELECT+Id,Name,Type+FROM+Account');
            req.setMethod('GET'); 
            string autho = 'Bearer '+userInfo.getSessionId();
           // String autho = 'Bearer '+'00D5i0000013ifC!AREAQJzOX.BpCAwDvlPZqvAkHd7yrz5O1g8Hpf.EFabHRolV3IbaHAqQC27vCic83zNaCCOcSxPxRKUuJ_Peh7LXto0Rs5j1';
            System.debug('autho -> '+autho);
        req.setHeader('Authorization', autho); 
        Http http = new Http();
        HTTPresponse res= http.send(req);
        string response = res.getBody();
        System.debug('get body -> '+res.getBody());
        System.debug('get code -> '+res.getStatusCode());
        System.debug('get status -> '+res.getStatus()); 
        string str = '['+ response.substring(response.indexOf('records":[')+10,response.indexof(']}')) +']';
        list<Account>  acc = (list<Account>)JSON.deserialize(str,list<Account>.class); 
        for(account accobj : acc){
            System.debug('acc -> '+accobj); 
        }}catch(Exception e){
            System.debug('error -> '+e.getMessage()+ ' --> '+e.getLineNumber());
        }
    }
}