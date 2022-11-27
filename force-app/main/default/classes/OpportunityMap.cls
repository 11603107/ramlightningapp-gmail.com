public class OpportunityMap {
    
    public static void getOpportunityData(){
        try{
            
            List<opportunityLineItem> OppList = new List<OpportunityLineItem>();
            OppList = [SELECT Id, Name,TotalPrice, UnitPrice FROM opportunityLineItem];
            
            Map<Id, Opportunity> oppmap = new map<Id, opportunity>();
            
            for(opportunityLineItem opline :[SELECT Id,OpportunityId, Name,TotalPrice, UnitPrice FROM opportunityLineItem]){
                if(oppmap.containsKey(opline.OpportunityId)){
                  //  oppmap
                }else{
                   // oppmap.put(opline.OpportunityId, new opportunity){opportunity.Total_Price__c = opline.TotalPrice};
                }
                
            }
            
        }catch(Exception e){
            System.debug('error--> '+e.getMessage()+ ' Line --> '+e.getLineNumber());
        }
    }

}