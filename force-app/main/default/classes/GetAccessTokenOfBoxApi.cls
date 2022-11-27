public class GetAccessTokenOfBoxApi {  
   
    public static void getAccessttoken(){ 
        try{  
            List<String> urlList = new List<String>{
                'grant_type=authorization_code',
			'code=' + EncodingUtil.urlEncode('CIEPZreCYTdAzGFfSR8PuCtw02gu5TFd', 'UTF-8'),
			'client_id=' + EncodingUtil.urlEncode('h6ul49r05q7h1ivxmrpjyf2ibba390ae', 'UTF-8'),
			'client_secret=' + EncodingUtil.urlEncode('nMnxrNJxgQrSJPq33JFGt3VRC5RYgDkT', 'UTF-8'),
			 'redirect_uri=' + EncodingUtil.urlEncode('https://google.com', 'UTF-8') 
            };

            String ApiUEl = 'grant_type=authorization_code&code=CIEPZreCYTdAzGFfSR8PuCtw02gu5TFd&client_id=h6ul49r05q7h1ivxmrpjyf2ibba390ae&client_secret=nMnxrNJxgQrSJPq33JFGt3VRC5RYgDkT&redirect_uri=https://google.com';
                System.debug('urlList --> '+urlList);
                System.debug('ApiUEl --> '+ApiUEl);
                String body = String.join(urlList, '&');
                System.debug('String -> '+body);
                Http h = new Http();
            	HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.box.com/oauth2/token');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
			req.setHeader('Accept', 'application/json');
            req.setBody(ApiUEl);
                	//String body = String.join(ApiUEl, '&');
            System.debug('body --> '+ApiUEl);
           
           // HttpResponse res = h.send(req);
            
            HttpResponse res = new Http().send(req);
            System.debug('res.getBody() --> '+res.getBody());
            
        }catch(Exception e){
            System.debug('error --> '+e.getMessage()+' Line -> '+e.getLineNumber());
        }
    }  
    

   
    public static String getAccessToken(String code){
     try{
        String username = 'h6ul49r05q7h1ivxmrpjyf2ibba390ae';
        String password = 'nMnxrNJxgQrSJPq33JFGt3VRC5RYgDkT';
        String endpoint = 'https://api.box.com/oauth2/token'; // be sure this is configured in "Remote Site Settings"
        String boxSubjectId = '12345';
        // define transaction variables
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http h = new Http();
 
        // Configure the request
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setTimeout(120000);
       // String payload = 'grant_type=authorization_code&code='+code+'&client_id=h6ul49r05q7h1ivxmrpjyf2ibba390ae&client_secret=nMnxrNJxgQrSJPq33JFGt3VRC5RYgDkT';
       string payload = 'client_id=' + username + '&client_secret=' + password + '&grant_type=client_credentials&box_subject_type=user&box_subject_id=' + boxSubjectId;
       System.debug('Reena1234@ -> '+payload);
        req.setBody(payload);
        res = h.send(req);
        System.debug('Status code -> '+res.getStatusCode());
        if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
            System.debug('Inside in if');
            Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            if(untypedMap.containsKey('access_token')){
                System.debug('token -> '+(String) untypedMap.get('access_token'));
                return (String) untypedMap.get('access_token');
            }
            System.debug('nothng ');
            return '';
        }else{
            System.debug('Inside in if'+ res.getBody() );
            return '';
        }

     }catch(Exception e){
        System.debug('error -> '+e.getMessage()+ ' Line --> '+e.getLineNumber());
        return null;
     }
    }
    // @AuraEnabled 
    // public List<consolewrap> ConsoleWrapperList{get;set;}

@AuraEnabled 
    public static  WrapperClass getallFiles(String folderId){
        try{
            
            WrapperClass  ConsoleWrapperList = new WrapperClass(); 
            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
           // String accessToken = 'OcRk9mWbz9aBKtCyzxzmvxVcjOFkaGYD';
            String accessToken =accessToken();
        String endpoint = 'https://api.box.com/2.0/folders/'+folderId+'/items';
            req.setEndpoint(endpoint);
        req.setMethod('GET'); 
        req.setHeader('Authorization', 'Bearer '+accessToken); 
       // req.setBody(body);
        res = h.send(req);

        System.debug('data -> '+res.getBody());
        System.debug('getStatusCode -> '+res.getStatusCode());
        System.debug('getStatusCode -> '+res.getStatusCode());  
        if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
            System.debug('Inside in if con');
            System.debug('data -> '+res.getBody()); 
            System.debug('ConsoleWrapperList -> '+ConsoleWrapperList);
             
          ConsoleWrapperList=(WrapperClass)json.deserialize(res.getBody(),WrapperClass.class);
          System.debug('wrapper class -> '+ConsoleWrapperList);
         // System.debug('wrapper class -> '+ConsoleWrapperList);
            return ConsoleWrapperList; 
        }
        return null; 
        }catch(Exception e){
            System.debug(' error -> '+e.getMessage()+' line --> '+e.getLineNumber());
            return null;
        }
    }
   
    public class WrapperClass{ 
        @AuraEnabled 
         public integer total_count {get; set;} 
         @AuraEnabled 
         public  List<Entries> entries {get; set;}
         @AuraEnabled 
        public integer offset {get; set;}  
      
    }
 

    public class Entries { 
        @AuraEnabled    
            public String type{get;set;} 
            @AuraEnabled 
            public String id{get;set;}  
            @AuraEnabled 
            public String sequence_id{get;set;}  
            @AuraEnabled 
            public String etag{get;set;} 
            @AuraEnabled  
            public String name{get;set;}
            @AuraEnabled  
            public String icon{get;set;}
    } 
     
    @AuraEnabled 
    public static String accessToken(){ 
            String accesstoken = 'XQXkmrEhlB8yhwZHpzKEDczj6taj9Zpg';
            return accesstoken;  
    }  

 
    
    
    

}