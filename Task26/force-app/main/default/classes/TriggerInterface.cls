public interface TriggerInterface {

   void afterInsert(List<sObject> newList, Map<Id, sObject> newMap);   

   void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap);
   
}