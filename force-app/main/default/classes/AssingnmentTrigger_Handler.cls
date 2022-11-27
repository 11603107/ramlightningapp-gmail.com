public class AssingnmentTrigger_Handler {
    public static void updateInventory(Map<String, String> MapOforderProduct){ 
        try{
               List<Inventory__c>InventoryList = new List<Inventory__c>();
               List< Order__c>OrderList = [select id, name, Associate__c from Order__c where id IN: MapOforderProduct.keyset()];
            Set < String > associateOrderSet = new Set < String > ();
        For(Order__c OrderObj: OrderList) {
            associateOrderSet.add(OrderObj.Associate__c);
        }
        List<Inventory__c>InventoryNewList = [select Id, Status__c from Inventory__c where Product__c In: MapOforderProduct.values() And Associate__c IN: associateOrderSet AND Status__c = 'Assigned'];
         for (Inventory__c Inventoryobj: InventoryNewList) {
            Inventoryobj.Status__c = 'Sold';
            InventoryList.add(Inventoryobj);
        }
        update InventoryList;
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        } 
    } 
}