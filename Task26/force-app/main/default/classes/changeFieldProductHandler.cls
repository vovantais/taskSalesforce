public class changeFieldProductHandler implements TriggerInterface {

   public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
         List<Product2> productList =( List<Product2> )newList;
         changeFieldProductHelper.createTasks(productList);
   }
   
   public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) {
      List<Product2> productList =( List<Product2> )newList;
      changeFieldProductHelper.createTasks(productList); 
   }
}