trigger AssingnmentTrigger on Order_Entry__c (after update) { 
    if(trigger.isupdate && trigger.isAfter){
        Map < String, String > MapOforderProduct = new Map < String, String > (); 
        for (Order_Entry__c orderEntryObj: trigger.new) {
            if (orderEntryObj.Product__c!= trigger.oldmap.get(orderEntryObj.Id).Product__c ||
                orderEntryObj.Order__c != trigger.oldmap.get(orderEntryObj.Id).Order__c) {
                    MapOforderProduct.put(orderEntryObj.Order__c, orderEntryObj.Product__c);
                }
        } 
        AssingnmentTrigger_Handler.updateInventory(MapOforderProduct);
    }   
}